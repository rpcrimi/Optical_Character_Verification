% nn.m
% Samuel P. Tobey, Robert Crimi
% December 1, 2016
% CSCI 5722 - Computer Vision - Dr. Ioana Fleming

% Neural net for handwritten characters 'a'-'z' from two people.  52 labels
% total.
% Plot the confusion matrix, or the following code to analyze results:
% >> [c,cm,ind,per] = confusion(labelsTestData,y2);

% Modified from MATLAB's example: "Train Stacked Autoencoders for Image
% Classification."
% In MATLAB:
% >> openExample('nnet/AutoencoderDigitsExample');
% On the Web:
% <https://www.mathworks.com/help/nnet/examples/training-a-deep-neural-network-for-digit-classification.html>

% Other useful resources:
% http://www.cs.cmu.edu/afs/cs/Web/Groups/AI/html/faqs/ai/neural/faq.html
% >> nnstart;
% >> nprtool;

% Input:
%   inputFolder     : String of directory with labeled images.
%   name1           : The string of the first (alphabetical) person's
%                     name in the image names.
%   name2           : The string of the second name.
% Output:
%   labels          : 26 by n binary matrix containing 1's in the rows for
%                     the label of the corresponding image.
%   images          : 1 by n cell array of images used for the NN.
%   labelsTestData  : 26 by n matrix, a subset of the labels.
%   y1              : The predicted labels subset using the NN.
%   y2              : The predicted labels subset, with NN fine tuning.

% Example usage:
% >> [labels, images, labelsTestData, y1, y2] = nn('labeled_images/150/','bobby','sam');

function [labels, images, labelsTestData, y1, y2] =  nn(inputFolder, name1, name2)
    %% Create labels matrix and images cell array.
    
    filesStruct = dir(strcat(inputFolder, '*.png'));
    nFiles = length(filesStruct);
    nTrain = uint64(nFiles*0.8);
    
    % 52 labels: a-z for each of two people (Bobby, Samuel).
    labels = zeros(52, nFiles);
    images = cell(1, nFiles);
    
    % Used to convert chars to indices 1-26 (i.e. 'a'-'z').
    char_shift = double('a') - 1;
    
    for file = 1:1:nFiles
        fileName = strcat(inputFolder, filesStruct(file).name);
        images{file} = imcomplement( ...
            imresize(imread(fileName), [32 NaN]));
        fileNameDetails = strsplit(filesStruct(file).name, { '.' , '_' } );
        name = fileNameDetails{1};
        label_idx = double(fileNameDetails{2}) - char_shift;
        switch name
            case name1
                labels(        label_idx , file ) = 1;
            case name2
                labels( (label_idx + 26) , file ) = 1;
        end
    end
    
    % Set aside some data for testing, use the rest for training.
    permute = randperm( nFiles );
    labels  = labels( : , permute );
    images  = images(     permute );
    labelsTestData = labels( : , nTrain : nFiles );
    labelsTrain    = labels( : ,      1 : nTrain );
    imagesTestData = images(     nTrain : nFiles );
    imagesTrain    = images(          1 : nTrain );
    
    %% Sparse autoencoder.
    
    rng('default');
    hiddenSize1 = 150;
    
    autoenc1 = trainAutoencoder(imagesTrain,hiddenSize1, ...
    'MaxEpochs',400, ...
    'L2WeightRegularization',0.004, ...
    'SparsityRegularization',4, ...
    'SparsityProportion',0.15, ...
    'ScaleData', false);

    view(autoenc1);
    
    figure();
    plotWeights(autoenc1);
    
    feat1 = encode(autoenc1,imagesTrain);
    
    %% Second autoencoder
    
    hiddenSize2 = 75;
    autoenc2 = trainAutoencoder(feat1,hiddenSize2, ...
    'MaxEpochs',100, ...
    'L2WeightRegularization',0.002, ...
    'SparsityRegularization',4, ...
    'SparsityProportion',0.1, ...
    'ScaleData', false);

    view(autoenc2);
    
    feat2 = encode(autoenc2,feat1);
	
    %% Train softmax layer
    
    softnet = trainSoftmaxLayer(feat2,labelsTrain,'MaxEpochs',400);
    
    view(softnet);
    
    %% Stacked neural net
    
    deepnet = stack(autoenc1,autoenc2,softnet);
    
    view(deepnet);
    
    % Get the number of pixels in each image
    imageWidth = 32;
    imageHeight = 32;
    inputSize = imageWidth*imageHeight;

    % Turn the test images into vectors and put them in a matrix
    xTest = zeros(inputSize,numel(imagesTestData));
    for i = 1:numel(imagesTestData)
        xTest(:,i) = imagesTestData{i}(:);
    end
    
    y1 = deepnet(xTest);
    
    % Confusion matrix is 52 by 52, plot as three separate figures.
%     figure(); plotconfusion(labelsTestData(1:17,:),y1(1:17,:));
%     figure(); plotconfusion(labelsTestData(18:35,:),y1(18:35,:));
%     figure(); plotconfusion(labelsTestData(36:end,:),y1(36:end,:));
    
    %% Fine tuning
    
    % Turn the training images into vectors and put them in a matrix
    xTrain = zeros(inputSize,numel(imagesTrain));
    for i = 1:numel(imagesTrain)
        xTrain(:,i) = imagesTrain{i}(:);
    end

    % Perform fine tuning
    deepnet = train(deepnet,xTrain,labelsTrain);

    y2 = deepnet(xTest);
    
    % Confusion matrix is 52 by 52, plot as three separate figures.
%     figure(); plotconfusion(labelsTestData(1:17,:),y2(1:17,:));
%     figure(); plotconfusion(labelsTestData(18:35,:),y2(18:35,:));
%     figure(); plotconfusion(labelsTestData(36:end,:),y2(36:end,:));

end
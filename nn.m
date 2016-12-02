% nn.m
% Samuel P. Tobey, Robert Crimi
% December 1, 2016
% CSCI 5722 - Computer Vision - Dr. Ioana Fleming

% Process from MATLAB's example: "Train Stacked Autoencoders for Image
% Classification" (for digits 0-9).

% example usage:
% >> [labels, images] = nn('labeled_images/150/','bobby','sam');

function [trainLabels, trainImages] =  nn(inputFolder, name1, name2)

    filesStruct = dir(strcat(inputFolder, '*.png'));
    nFiles = length(filesStruct);
    split_80 = uint64(nFiles*0.8);
    
    % 52 labels: a-z for each of two people (Bobby, Samuel).
    trainLabels = zeros(52, nFiles);
    trainImages = cell(1, nFiles);
    
    % Used to convert chars to indices.
    char_shift = double('a') - 1;
    
    for file = 1:1:nFiles
        fileName = strcat(inputFolder, filesStruct(file).name);
        trainImages{file} = imread(fileName);
        fileNameDetails = strsplit(filesStruct(file).name, { '.' , '_' } );
        name = fileNameDetails{1};
        label_idx = double(fileNameDetails{2}) - char_shift;
        switch name
            case name1
                trainLabels(  label_idx       , file ) = 1;
            case name2
                trainLabels( (label_idx + 26) , file ) = 1;
        end
    end
    
    rng('default');
    
end
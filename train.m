function [nameAccuracy, totalAccuracy] = train(inputFolder, method)
    % Read png files into training set
    imageFiles = dir(strcat(inputFolder, '*.png'));
    nFiles = length(imageFiles);
    split = uint64(nFiles*0.8);
    X = [];
    Y = [];
    for f=1:nFiles
        fileName = strcat(inputFolder, imageFiles(f).name);
        y = strsplit(imageFiles(f).name, {'.', '_'});
        Y = [Y; strcat(y(1), '_', y(2))];
        img = imbinarize(imread(fileName));
        X = [X; reshape(img, 1, [])];
    end
    % Permutate for training
    ordering = randperm(nFiles);
    X = double(X(ordering, :));
    Y = Y(ordering, :);
    testX = X(split:nFiles, :);
    testY = Y(split:nFiles, :);
    trainX = X(1:split, :);
    trainY = Y(1:split, :);
    
    switch method
        case 'kNN'
            predicted = knnclassify(testX, trainX, trainY, 3);
        case 'SVM'
            pool = parpool; % Invoke workers
            options = statset('UseParallel',1);
            Mdl = fitcecoc(trainX,trainY,'Coding','onevsall','Prior','uniform','Verbose', 2, 'Options',options)
            CVMdl = crossval(Mdl,'Options',options)
    end
    
    nameWrong = 0.0;
    totalWrong = 0.0;
    for i=1:length(testY)
        actual = strsplit(char(testY(i)), '_');
        pred = strsplit(char(predicted(i)), '_');
        if ~strcmp(testY(i),predicted(i))
            totalWrong = totalWrong + 1.0;
        end
        if ~strcmp(actual(1), pred(1))
            nameWrong = nameWrong + 1.0;
        end
    end
    nameAccuracy = (length(testY)-nameWrong)/length(testY)
    totalAccuracy = (length(testY)-totalWrong)/length(testY)
end


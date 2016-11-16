function [success] = charLabel(image, dest_labeled, dest_unlabeled, method, name)
    import containers.*
    I = imread(image);
    format = '.png';
    imSqrDim = 150;

    bboxes = getBBoxes(image);
    test = bboxes(:,:);

    switch method
        case 'Train'
            letters = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'};
            exampleCounts = containers.Map(letters, zeros(size(letters)));
            [labels] = labelgui(I,test);
            % Save labeled characters.
            for i = 1:1:size(test,1)
                character = char(labels(i));
                if(character)
                    x1 = floor( test(i,1) );
                    y1 = floor( test(i,2) );
                    x2 = ceil ( test(i,1) + test(i,3) );
                    y2 = ceil ( test(i,2) + test(i,4) );
                    char_image = I(y1:y2,x1:x2,:);
                    pad = ceil(([imSqrDim imSqrDim] - size(char_image))/2);
                    char_image = padarray(char_image, pad, 255);
                    char_image = char_image(1:imSqrDim,1:imSqrDim,:);
                    filename = sprintf('%s%s_%s_%d%s',dest_labeled,name,character,exampleCounts(character),format);
                    imwrite(char_image,filename);
                    exampleCounts(character) = exampleCounts(character) + 1;
                end
            end
        case 'Test'
            % Save unlabeled characters.
            for i = 1:1:size(bboxes,1)
                x1 = floor( bboxes(i,1) );
                y1 = floor( bboxes(i,2) );
                x2 = ceil ( bboxes(i,1) + bboxes(i,3) );
                y2 = ceil ( bboxes(i,2) + bboxes(i,4) );
                char_image = I(y1:y2,x1:x2,:);
                filename = sprintf('%s%s_%d%s',dest_unlabeled,output_name,i,format);
                imwrite(char_image,filename);
            end
    end
end


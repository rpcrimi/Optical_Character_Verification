% charLabel.m
% Samuel P. Tobey, Robert Crimi
% November 11, 2016
% CSCI 5722 - Computer Vision - Dr. Ioana Fleming

% Add figs/ to Path before running

image = 'sample1.png';
I = imread(image);
dest_unlabeled = 'unlabeled_images/sample1/';
dest_labeled = 'labeled_images/sample1/';
output_name = 'char';
format = '.png';

bboxes = getBBoxes(image);
test = bboxes(1:4,:);

[labels] = labelgui(I,test);

% Save labeled characters.
for i = 1:1:size(test,1)
    char = labels(i);
    if(char ~= '')
        x1 = floor( test(i,1) );
        y1 = floor( test(i,2) );
        x2 = ceil ( test(i,1) + test(i,3) );
        y2 = ceil ( test(i,2) + test(i,4) );
        char_image = I(y1:y2,x1:x2,:);
        filename = sprintf('%s%s_%s%s',dest_labeled,output_name,char,format);
        imwrite(char_image,filename);
    end
end

% Save unlabeled characters.
% for i = 1:1:size(bboxes,1)
%     x1 = floor( bboxes(i,1) );
%     y1 = floor( bboxes(i,2) );
%     x2 = ceil ( bboxes(i,1) + bboxes(i,3) );
%     y2 = ceil ( bboxes(i,2) + bboxes(i,4) );
%     char_image = I(y1:y2,x1:x2,:);
%     filename = sprintf('%s%s_%d%s',dest_unlabeled,output_name,i,format);
%     imwrite(char_image,filename);
% end
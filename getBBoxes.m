% charLabel.m
% Samuel P. Tobey, Robert Crimi
% November 13, 2016
% CSCI 5722 - Computer Vision - Dr. Ioana Fleming

% Get boundingbox information for text from an image and save the detected
% characters.

% Modified from MATLAB's TextDetectionExample

function [textBBoxes] = getBBoxes(image)

    %% Steps 1-2 ...
    
    colorImage = imread(image);
    %I = rgb2gray(colorImage);
    I = colorImage;
    % Detect MSER regions.
    [mserRegions, mserConnComp] = detectMSERFeatures( ...
        I,'RegionAreaRange',[200 8000],'ThresholdDelta',2);
    
    mserStats = regionprops(mserConnComp, 'BoundingBox', 'Eccentricity', ...
    'Solidity', 'Extent', 'Euler', 'Image');

    %% Step 4 ...

    % Get bounding boxes for all the regions
    bboxes = vertcat(mserStats.BoundingBox);

    % Convert from the [x y width height] bounding box format to the [xmin ymin
    % xmax ymax] format for convenience.
    xmin = bboxes(:,1);
    ymin = bboxes(:,2);
    xmax = xmin + bboxes(:,3) - 1;
    ymax = ymin + bboxes(:,4) - 1;
    
    % Expand the bounding boxes by a small amount.
    %expansionAmount = 0.02;

    % Do not expand the bounding boxes.  This seems to help prevent separate
    % letters' boxes from overlapping and being combined.
    % Idea: instead shrink the boxes, combine, then expand.
    expansionAmount = 0.00;

    xmin = (1-expansionAmount) * xmin;
    ymin = (1-expansionAmount) * ymin;
    xmax = (1+expansionAmount) * xmax;
    ymax = (1+expansionAmount) * ymax;

    % Clip the bounding boxes to be within the image bounds
    xmin = max(xmin, 1);
    ymin = max(ymin, 1);
    xmax = min(xmax, size(I,2));
    ymax = min(ymax, size(I,1));
    
    % Show the expanded bounding boxes
    expandedBBoxes = [xmin ymin xmax-xmin+1 ymax-ymin+1];
    IExpandedBBoxes = insertShape(colorImage,'Rectangle',expandedBBoxes,'LineWidth',3);

    %figure, imshow(IExpandedBBoxes), title('Expanded Bounding Boxes Text')
    
    %% ...
    
    % Compute the overlap ratio
    overlapRatio = bboxOverlapRatio(expandedBBoxes, expandedBBoxes);

    % Set the overlap ratio between a bounding box and itself to zero to
    % simplify the graph representation.
    n = size(overlapRatio,1); 
    overlapRatio(1:n+1:n^2) = 0;

    % Create the graph
    g = graph(overlapRatio);

    % Find the connected text regions within the graph
    componentIndices = conncomp(g);
    
    %% ...

    % Merge the boxes based on the minimum and maximum dimensions.
    xmin = accumarray(componentIndices', xmin, [], @min);
    ymin = accumarray(componentIndices', ymin, [], @min);
    xmax = accumarray(componentIndices', xmax, [], @max);
    ymax = accumarray(componentIndices', ymax, [], @max);

    % Compose the merged bounding boxes using the [x y width height] format.
    textBBoxes = [xmin ymin xmax-xmin+1 ymax-ymin+1];
    
    %% ...

    % Show the final text detection result.
    ITextRegion = insertShape(colorImage, 'Rectangle', textBBoxes,'LineWidth',3);

    figure, imshow(ITextRegion), title('Detected Text')
    
end
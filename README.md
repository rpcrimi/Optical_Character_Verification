# Optical_Character_Verification

Robert Crimi,  
Samuel Tobey

Fall 2016 Project

CSCI 5722 - Computer Vision - Dr. Ioana Fleming

##How to Use

###Label images

*Note: Add figs/ directory to path in MATLAB to run the GUI in charLabel.m*

```MATLAB
charLabel('source_images/bobby_bw.jpg', 'labeled_images/150/', 'unlabeled_images/', 'Train', 'bobby')
```

###Train and Test KNN

```MATLAB
train('labeled_images/150/', 'kNN')
```

###Train and Test Neuaral Networks

Results from the neural network (without and with backpropagation) are stored in y1 and y2, respectively.  For character and scribe predictions:

```MATLAB
[labels, images, labelsTestData, y1, y2] = nn('labeled_images/150/','bobby','sam');
```

Or, for just character predictions:

```MATLAB
[labels, images, labelsTestData, y1, y2] = nnChars('labeled_images/150/');
```

Get information about the accuracy of the neural network's predictions.  See MATLAB's documentation for more information.

```MATLAB
[c,cm,ind,per] = confusion(labelsTestData,y2);
```

Alternatively, results from both neural networks are stored in the output/ directory in .mat files.

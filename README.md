# Optical_Character_Verification

Robert Crimi,  
Samuel Tobey

Fall 2016 Project

CSCI 5722 - Computer Vision - Dr. Ioana Fleming

**Notes**

 * Add figs/ to path in MATLAB to run the GUI in charLabel.m


##How to use

###Label images

charLabel('source_images/bobby_bw.jpg', 'labeled_images/150/', 'unlabeled_images/', 'Train', 'bobby')

###Train and test KNN

train('labeled_images/150/', 'kNN')

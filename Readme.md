My Getting and Cleaning Peer Assessment submission
==================================================

The run_analysis.R script in this repository is my submission to the getting and cleaning Data peer assessment. It consists of two helper functions, and two lines of code that execute these two helper functions.

The helper function getdata obtains and cleans data from the UCI HAR Dataset. It extracts the test and train data from the txt files and combines them into a single data set. The data set is labeled, and filtered as to only contain measurements on means and standard deviations. Activity and subject data is included, and activity data is labeled in a descriptive way. No analysis whatsoever is performed within the getdata helper function.

The helper function tidydata returns a tidy data set that contains the mean of each variable for each activity-subject pair.

The txt files are assumed to be in the 'UCI HAR Dataset' directory in the same way as in the zip file, and the 'UCI HAR Dataset' directory in the working directory.

## script: run_analysis.R
## author: VGM
## created: DEC-08-2014
## coursera: https://class.coursera.org/getdata-016/human_grading
## run_analysis is a utility function that is specifically designed to work with UCI HAR dataset
## HAR = Human Activity Recognition using smart phones Dataset
## (see http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
## & performs the following:
##	1. Merges the training and the test sets to create one data set
##  2. Extracts only the measurements on the mean and standard deviation for each measurement
##  3. Uses descriptive activity names to name the activities in the data set
##  4. Appropriately labels the data set with descriptive variable names
##  5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
##
## Assumptions & Meta-Data information
## -----------------------------------
## A) all data is stored under current working directory
## B) activity_labels.txt contains the labels for measured Human Activities - use these labels in association with y_train.txt or y_test.txt files
## C) features.txt        contains the labels for columns for the data measurements stored in the test or train sub-directories under X_train.txt & X_test.txt files

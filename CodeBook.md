Getting &amp; Cleaning Data Course Project
==========================================
run_analysis.R - CodeBook
=========================

Codebook for `run_analysis-Activity_Subject_Means.TXT`
===========================
Dataset that went into generating the grouped/summarized data file:
`run_analysis-Activity_Subject_Means.TXT` is based on UCI HAR study.

run_analysis.R is specifically written to the Coursera course project requirements
part of the John Hopkins Data Scientist series of Coursera.org classes:
https://class.coursera.org/getdata-016/human_grading)

Original source of the data for UCI Human Activity Recongnition is located at link below:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
URL to original data set:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Data transformations
--------------------
Data generated is via a R script called: `run_analysis.R`, included in this repository.
Detail documentation can be found in the script as well as README.MD file also included in
this repository.

`run_analysis.R` performs the following steps to transform UCI HAR raw data set:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Format & variables
------------------
`run_analysis-Activity_Subject_Means.TXT` is a comma-separated Text file which can be parsed by R's
`read.table` function or imported into Excel via TXT file import wizard.

The file contains the following descriptive identifier columns:

| Column Name | Description                                                    |
| ----------- | -------------------------------------------------------------- |
| Activity    | Type/Category of activity performed (Values: `WALKING`, `WALKING_UPSTAIRS`, `WALKING_DOWNSTAIRS`, `SITTING`, `STANDING`, `LAYING`). |
| Subject     | An integer between 1-30, indicating the student subject that took part of the study at UCI. |

Earch row for a unique combination of an **Activity** & a **Subject** contains 66 addition columns one per signal measurement mean or standard diviation for variables as defined by format:
```
<SignalDomain>-<FeatureMeasureSource>-<MeasurementType>-<Axis>
```

`SignalDomain` may be either `Time` or `Freq` (`Freq` denotes frequency domain signals).

`FeatureMeasureSource` indicated the type of feature source: accelerometer, gyroscope that was used to make measurement. Possible values: BodyAcc, GravityAcc, BodyAccJerk, BodyGyro, BodyGyroJerk, BodyAccMag, GravityAccMag, BodyAccJerkMag, BodyGyroMag, BodyGyroJerkMag, BodyBodyAccJerkMag, , BodyBodyGyroMag, & BodyBodyGyroJerkMag.

`MeasurementType` may be either `Mean`, indicating an average, or `SD`, indicating standard deviation.

`Axis` optional - indicates the axis of movement where the measurements took place. If applicable will either be: `X`, `Y` or `Z`.

Examples
--------
Time-BodyAcc-Mean-X
Freq-BodyAcc-Mean-Z
Freq-BodyAcc-SD-X
Time-BodyAccJerkMag-SD
Time-BodyGyroMag-Mean

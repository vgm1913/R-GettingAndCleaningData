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
##  3. Uses descriptive activity names to name the activities in the data set + Appropriately labels the data set with descriptive variable names
##  4. From the data set in previous step, creates a second, independent tidy data set with the average of each variable for each activity and each subject
##
## Assumptions & Meta-Data information
## -----------------------------------
## A) all data is stored under current working directory
## B) activity_labels.txt contains the labels for measured Human Activities - use these labels in association with y_train.txt or y_test.txt files
## C) features.txt        contains the labels for columns for the data measurements stored in the test or train sub-directories under X_train.txt & X_test.txt files
library(data.table)
library(reshape2)
## ------------------ Helper Functions -------------------
load_and_label <- function (file1, new_colnames, file2 = "") {
  if (file2 == "") {
    DT <- data.table(read.table(file1))
  }
  else {
    DT <- rbindlist(
      list(data.table(read.table(file1)),
           data.table(read.table(file2))
      )
    )
  }
  setnames(DT, old=colnames(DT), new=new_colnames)
  DT
}

add_id_column <- function (data_table) {
  data_table[, id_seq := seq (from=1, to=nrow(data_table), by=1)]
  setkey(data_table, id_seq)
  data_table
}

transform_column_names <- function (char_vector) {
  x <- gsub (",", "-", char_vector)
  x <- gsub ("^t", "Time", x)
  x <- gsub ("^f", "Freq", x)
  x
}
## ------------------ Begin Script -----------------------
## Stage 0) Download and set up Meta Data information
## Step 0.1 - download the dataset from UCI web-site - Note: URL for this assignment is hard-wired (in future it should be a configuration parameter)
if (!file.exists("UCI_HAR.zip")) {
	print("UCI HAR data zip find not found - please wait while download completes...")
	fileURL <- "http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip"
	download.file(fileURL, destfile = "UCI_HAR.zip")
}
if (!file.exists("features.txt")) {
	print("unzipping the content of UCI HAR zip file, please wait...")
	unzip("UCI_HAR.zip", files = NULL, list = FALSE, overwrite = TRUE,
      junkpaths = TRUE, exdir = ".", unzip = "internal",
      setTimes = FALSE)
}
## Step 0.2 - read Meta data information into R as tables for reference & processing
print ("Stage 0) Initializing and loading Meta data...")
DT_act_labels <- load_and_label("activity_labels.txt", c("act_id", "Activity"))
setkey(DT_act_labels, act_id)
DT_feat_labels <- load_and_label("features.txt", c("feat_id", "feat_label"))
setkey(DT_feat_labels, feat_id)
##
## Stage 1) Merge training and test sets into one data set
##
print ("Stage 1) Merge training and test sets into one data set - please wait...")
## Step 1.1 - load & merge test and train subject information + add a id_seq unique data row identifier
DT_HAR_data <- add_id_column (load_and_label ("subject_test.txt", c("Subject"), "subject_train.txt"))

## Step 1.2 - load & merge test and train activity information + add a id_seq unique data row identifier
DT_act_data <- merge (
                add_id_column (load_and_label ("y_test.txt", c("act_id"), "y_train.txt")),
                DT_act_labels,
                by = "act_id",
                all = TRUE)
setkey(DT_act_data, id_seq)

## Step 1.3 - merge subject & activity information via id_seq common row marker
DT_HAR_data <- merge (DT_HAR_data, DT_act_data,all=TRUE)
setkey(DT_HAR_data, id_seq)

## Step 1.4 - load test & train measurement information + add id_seq common row marker + merge them into one data.table
DT_HAR_feat <- add_id_column (
  load_and_label ("X_test.txt"
                , transform_column_names(
                    as.vector(DT_feat_labels[[2]])
                  )
                , "X_train.txt")
  )
setkey (DT_HAR_feat, id_seq)
##
## Stage 2) Extract only the measurements on the mean and stadard deviation for each measurement
##
print ("Stage 2) Extract only the measurements on the mean and stadard deviation for each measurement")
## Step 2.1 - make a vecor of all column names that we want to remove from the merged measurement data.table
DT_feat_col_to_remove <- DT_feat_labels[ !(
        (like(feat_label,"mean()") & !(like(feat_label, "meanFreq()")))
      | (like (feat_label, "std()")))
    ]
feat_col_to_remove <- transform_column_names(as.vector(DT_feat_col_to_remove$feat_label))

## Step 2.2 - remove the columns we do not need for this project
for (col in feat_col_to_remove) {
  DT_HAR_feat <- DT_HAR_feat[, c(col) := NULL]
}
##
## Stage 3) Uses descriptive activity names to name the activities in the data set
##
print ("Stage 3) Uses descriptive activity names to name the activities in the data set, & appropriately labels the data set with descriptive variable names")
## Step 3.1 - merge the subject and activity with the corresponding measurement data.table
DT_HAR_data <- merge (DT_HAR_data, 
                      DT_HAR_feat,
                      all=TRUE)
DT_HAR_data[, act_id := NULL] # remove it, we replaced it with the full form name of activity
DT_HAR_data[, id_seq := NULL] 

## Step 3.2 - tidy the resulting data via melt to make sure each measured value is appropriatly labeled 
tidy_data_ids <- c("Subject", "Activity")
measurement_variables <- colnames(DT_HAR_data)
measurement_variables <- measurement_variables[! measurement_variables %in% tidy_data_ids]
DT_HAR_tidy <- melt(DT_HAR_data, id=tidy_data_ids, measure.vars=measurement_variables)

## Step 3.3 - clean up the data and remove data and variable no longer needed
# remove these, we don't need it anymore
rm(DT_HAR_feat)
rm(DT_act_labels)
rm(DT_act_data)
rm(DT_feat_col_to_remove)
rm(DT_feat_labels)
rm(feat_col_to_remove)
rm(measurement_variables)
rm(DT_HAR_data)
rm(col)
##
## Stage 4) From the data set in previous step, creates a second, independent tidy data set with the average of each variable for each activity and each subject
##
print ("Stage 4) Creating a second, independent tidy data set with the average of each variable for each activity and each subject")
## Step 4.1 - make a new tidy data set with the average of each variable for each activity and each subject

## Step 4.2 - write out the resulting tidy data to a file in the current working directory

## Step 4.3 - final clean up
rm(tidy_data_ids)
## ------------------ End Script -----------------------

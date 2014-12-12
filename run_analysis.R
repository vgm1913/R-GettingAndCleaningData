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
library(data.table)
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
DT_act_labels <- load_and_label("activity_labels.txt", c("act_id", "act_label"))
setkey(DT_act_labels, act_id)
DT_feat_labels <- load_and_label("features.txt", c("feat_id", "feat_label"))
setkey(DT_feat_labels, feat_id)
##
## Stage 1) Merge training and test sets into one data set
##
print ("Stage 1) Merge training and test sets into one data set - please wait...")

DT_HAR_data <- add_id_column (load_and_label ("subject_test.txt", c("subject"), "subject_train.txt"))
DT_act_data <- merge (
                add_id_column (load_and_label ("y_test.txt", c("act_id"), "y_train.txt")),
                DT_act_labels,
                by = "act_id",
                all = TRUE)
setkey(DT_act_data, id_seq)
DT_HAR_data <- merge (DT_HAR_data, DT_act_data,all=TRUE)
setkey(DT_HAR_data, id_seq)

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
DT_feat_col_to_remove <- DT_feat_labels[ !(
        (like(feat_label,"mean()") & !(like(feat_label, "meanFreq()")))
      | (like (feat_label, "std()")))
    ]
feat_col_to_remove <- transform_column_names(as.vector(DT_feat_col_to_remove$feat_label))
for (col in feat_col_to_remove) {
  DT_HAR_feat <- DT_HAR_feat[, c(col) := NULL]
}
##
## Stage 3) Uses descriptive activity names to name the activities in the data set
##
print ("Stage 3) Uses descriptive activity names to name the activities in the data set, & appropriately labels the data set with descriptive variable names")
DT_HAR_data <- merge (DT_HAR_data, 
                      DT_HAR_feat,
                      all=TRUE)
##
## ------------------ End Script -----------------------

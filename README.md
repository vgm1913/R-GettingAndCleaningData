Getting &amp; Cleaning Data Course Project - README
===================================================

Background
==========
run_analysis.R script is designed specifically to work with UCI
HAR - Human Activity Recongition data files. 
*See: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones*
Coursera series on Data Scientist - offered by John Hopkins
University (3rd course in series: Getting &amp; Cleaning Data)


Description
===========
run_analysis.R scripts downloads, unpacks, merges the training and test
data sets provided for the 30 subjects in UCI HAR experiment.
The script selects only the Mean and Standard Diviation of measurements taken
for each subject and activity. It then labels the information (columns) with
descriptive names. The result is transformed into a tidy table with each 
Activity measurement by Subject being stored in 1 row while every unique measurement
of mean & SD stored as a unique column. The script then write the resulting
data into a file named: **run_analysis-Activity_Subject_Means.TXT** into the working
directory of the script.

Requirements
============

* **Internet Connection**: Required for download of UCI HAR zip file.
* **working directory with write permissions**: Required for unpacking and installing data files.

Attributes
==========

* `run_analysis`: No command line parameters have been setup at this time.
   The script assumes it can write in it's current working directory.

# Library Dependencies

## data.table
## reshape2

Usage
=====
`run_analysis` : will check for UCI_HAR.zip file existance, unpack if need be, 
                 complete analysis and output file: **run_analysis-Activity_Subject_Means.TXT**



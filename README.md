# GettingAndCleaningDataCoursera
Course project for the "Getting and Cleaning Data course" offered on Coursera

* The analysis is implemented in run_Analysis.R.
* The script can be run at the R command line as follows: source('run_Analysis.R')
* The script has only been tested on a Mac (OS Yosemite)
* The script does the following:
** Download the data set from the web
** Unzip the data set
** Combine the training and test data into a data table
** Extract features which have mean or std in their names
** Compute the mean of each feature on a per subject, per activity basis.
** Write the results to a file

* The dataset is organized as follows:
** Column 1: Subject ID (range 1 to 30)
** Column 2: Activity ID (range 1 to 6), where each index maps to an activity as described below
** Columns 3:81: Average value per subject, per activity of various features extracted from raw data

Since there are 30 subjects and 6 activities, the data has 180 rows. Since 79 features were found, the data has 81 columns (2 extra for subject and activity ID, as described above).

* The activity index to physical activity mapping is as follows:

1 WALKING

2 WALKING_UPSTAIRS

3 WALKING_DOWNSTAIRS

4 SITTING

5 STANDING

6 LAYING

A list of features can be found in the file extracted_features.txt.

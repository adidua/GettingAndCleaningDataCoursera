# run_Analysis.R
# Course project: Getting and cleaning data

# Function to combine two tables
combineTables<-function(src1,src2) {
  t1<-read.table(src1);
  t2<-read.table(src2);
  t<-rbind(t1,t2);
  return(t);
}

# Download file
download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip',destfile='dataset.zip',method='curl');
# Unzip file
unzip("dataset.zip");

# Combine data
combinedData<-combineTables('./UCI HAR Dataset/train/X_train.txt','./UCI HAR Dataset/test/X_test.txt');

# Combine subject lists
subjList<-combineTables('./UCI HAR Dataset/train/subject_train.txt','./UCI HAR Dataset/test/subject_test.txt');

# Combine training lists
trainList<-combineTables('./UCI HAR Dataset/train/y_train.txt','./UCI HAR Dataset/test/y_test.txt')

# Extract activity labels
actLabels<-read.table('./UCI HAR Dataset/features.txt');

# Find labels which contain the name mean or std
indexArrMean<-array(); # indicies of features which correspond to means
indexArrStd<-array();  # indicies of features which correspond to std dev
dims<-dim(actLabels);
# Initialize counters
countMean<-1;
countStd<-1;
for (n in 1:dims[1]) {
  flag<-grepl('mean',actLabels[n,2]);
  if (flag) {
    indexArrMean[countMean]<-n;
    countMean<-countMean+1;
  }
  flag<-grepl('std',actLabels[n,2]);
  if (flag) {
    indexArrStd[countStd]<-n;
    countStd<-countStd+1;
  }
}

# Extract relevant columns from the combined data set and label the columns appropriately
meanData<-combinedData[,indexArrMean];
names(meanData)<-actLabels[indexArrMean,2];
stdData<-combinedData[,indexArrStd];
names(stdData)<-actLabels[indexArrStd,2];
# Combine and create clean data set
cleanData<-cbind(meanData,stdData);
dims<-dim(cleanData);
numFeatures<-dims[2];

# Create independent clean data set with mean values of all features (per subject and per activity)
subjRange<-c(1:30); # possible subject indicies
actRange<-c(1:6); # possible activity indicies
meanMatrix<-data.frame() # data frame with final results
rowCount<-1;
totalCount<-0; # just for sanity check
# Loop over subjects and activities
for (subjIdx in subjRange) {
  for (actIdx in actRange) {
    # Find data points which correspond to specific subject and activity
    idx1<-which(subjList$V1 %in% subjIdx);
    idx2<-which(trainList$V1 %in% actIdx);
    matchIdx<-intersect(idx1,idx2);
    L<-length(matchIdx);
    totalCount<-totalCount+L;
    # Log subject ID and activity ID in results matrix
    meanMatrix[rowCount,1]<-subjIdx;
    meanMatrix[rowCount,2]<-actIdx;
    # Compute mean per feature and store in results matrix
    for (k in 1:numFeatures) {
      meanVal<-mean(cleanData[matchIdx,k]);
      meanMatrix[rowCount,k+2]<-meanVal;
    }
    rowCount<-rowCount+1;
  }
}

# Construct list of column names and assign to data frame
colNames<-c("SubjectID","ActivityID");
colNames<-c(colNames,names(cleanData));
names(meanMatrix)<-colNames;

# Write to file (this file will be submitted to Coursera)
write.table(meanMatrix,"./courseProjResults.txt",row.names=F);

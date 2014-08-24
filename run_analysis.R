require(reshape2)

# Download data
zipfile <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", zipfile, method="curl")
unzip(zipfile) 
unlink(zipfile)
rm(zipfile)

# 1. Merges the training and the test sets to create one data set.

trainSet <- read.table("UCI HAR Dataset/train/X_train.txt")
trainActivity <- read.table("UCI HAR Dataset/train/y_train.txt", col.names=c("activity.label"))
trainSubject <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names=c("subject"))

trainData <- cbind(trainSet,trainSubject,trainActivity,set="train")

testSet <- read.table("UCI HAR Dataset/test/X_test.txt")
testActivity <- read.table("UCI HAR Dataset/test/y_test.txt", col.names=c("activity.label"))
testSubject <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names=c("subject"))

testData <- cbind(testSet,testSubject,testActivity,set="test")

allData <- rbind(trainData,testData)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# Get features names.
features <- read.table("UCI HAR Dataset/features.txt", as.is = TRUE, col.names=c("feature.id", "feature.name"))

selectedCols <- features[grepl("mean\\(\\)", features$feature.name) | grepl("std\\(\\)", features$feature.name), ]
selectedCols <- paste("V",as.character(selectedCols$feature.id),sep = "")
selectedCols <- c("subject", "activity.label", selectedCols)

selectedData <- allData[,selectedCols]

# 3. Uses descriptive activity names to name the activities in the data set

# Get activity labels.
activity <- read.table("UCI HAR Dataset/activity_labels.txt", col.names=c("activity.label", "activity.name"))

selectedData <- merge(activity, selectedData, by="activity.label")
# remove activity.label replaced by activity.name
selectedData <- selectedData[,!(names(selectedData) %in% c("activity.label"))]
names(selectedData)

# 4. Appropriately labels the data set with descriptive variable names. 

renameFeatureCol <- function(col) {
  idx <- substring(col, 2)
  name <- features[idx,][2]
  
  name <- gsub("^t", "TimeDomain.", name)
  name <- gsub("^f", "FrequencyDomain.", name)
  name <- gsub('\\(|\\)',"", name, perl = TRUE)
  name <- make.names(name)
  name <- gsub("mean", "Mean", name)  
  name <- gsub("std", "StandardDeviation", name)
  name <- gsub('Acc',".Acceleration", name)
  name <- gsub('GyroJerk',".AngularAcceleration", name)
  name <- gsub('Gyro',".AngularSpeed", name)
  name <- gsub('Freq\\.',"Frequency.", name)
  name <- gsub('Mag',".Magnitude", name)
  
  return(name)
}

vnames <- names(selectedData)[3:68]
names(selectedData)[3:68] <- lapply(vnames, renameFeatureCol)
names(selectedData)

# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

meltedData <- melt(selectedData, id=c("subject","activity.name"))
tidyData <- dcast(meltedData, subject+activity.name ~ variable, mean)

# write the tidy data set to a file
write.csv(tidyData, "tidy.txt", row.names=FALSE)

# Getting and Cleaning Data - Course Project
# Author : Kavya Gujjula

# load test data set
  subject_test = read.table("C:\\Users\\i55245\\Desktop\\UCI HAR Dataset\\test\\subject_test.txt")
  X_test = read.table("C:\\Users\\i55245\\Desktop\\UCI HAR Dataset\\test\\X_test.txt")
  Y_test = read.table("C:\\Users\\i55245\\Desktop\\UCI HAR Dataset\\test\\Y_test.txt")

# load training data set
  subject_train = read.table("C:\\Users\\i55245\\Desktop\\UCI HAR Dataset\\train\\subject_train.txt")
  X_train = read.table("C:\\Users\\i55245\\Desktop\\UCI HAR Dataset\\train\\X_train.txt")
  Y_train = read.table("C:\\Users\\i55245\\Desktop\\UCI HAR Dataset\\train\\Y_train.txt")
  
# load lookup information
  features <- read.table("C:\\Users\\i55245\\Desktop\\UCI HAR Dataset\\features.txt", col.names=c("FeatureId", "FeatureLabel"))
  activities <- read.table("C:\\Users\\i55245\\Desktop\\UCI HAR Dataset\\activity_labels.txt", col.names=c("ActivityId", "ActivityLabel"))
  IncludedFeatures <- grep("-mean\\(\\)|-std\\(\\)", features$FeatureLabel) 

#  1: merge the test and training data
  
  subject <- rbind (subject_test, subject_train)
  names(subject) <- "SubjectID"
  
  X <- rbind (X_test, X_train)
  X <- X [, IncludedFeatures]
  names(X) <- gsub("\\(|\\)", "", features$FeatureLabel[IncludedFeatures])

  Y <- rbind (Y_test, Y_train)
  names(Y) = "activityId"
  allactivity <- merge (Y, activities, by.x ="activityId", by.y="ActivityId")
  Activity <- allactivity$ActivityLabel
  
# merge data frames of different columns to form one data table
  data <- cbind(subject, X, Activity)
  write.table(data, "merged_tidy_data.txt") # output
  
# Task 5: creates an independent tidy data set by calculating the average of each variable for each activity and each subject.
  library(data.table)
  dat <- data.table(data)
  calculatedData <- dat[, lapply(.SD, mean), by=c("SubjectID", "Activity")]
  write.table(calculatedData, "calculated_tidy_data.txt", row.names = FALSE) 
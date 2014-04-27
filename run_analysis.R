# Getting and Cleaning Data Assignment 1

## Merge the training and the test sets to create one data set
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt") 
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
variable <- rbind(X_train, X_test)
rm(X_train, X_test)

y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
activity_code <- rbind(y_train, y_test)
names(activity_code) <- "activity_code"
rm(y_train, y_test)

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subject <- rbind(subject_train, subject_test)
rm(subject_train, subject_test)
names(subject) <- "subject"

## Extracts only the measurements on the mean and standard deviation
## for each measurement
feature <- read.table("./UCI HAR Dataset/features.txt")

select_feature_index <- c(grep("mean()", feature[,2], fixed = TRUE),
                          grep("std()", feature[,2], fixed = TRUE))

select_variable <- variable[select_feature_index]

names(select_variable) <- feature[select_feature_index, 2]

## Uses descriptive activity names to name the activities in the data set
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

activity <- merge(activity_code, activity_labels, by.x = "activity_code", by.y = "V1")
activity <- as.data.frame(activity[,2])
names(activity) <- "activity"

## Appropriately labels the data set with descriptive activity names
tidy_data_1 <- cbind(subject, activity, select_variable)

write.table(tidy_data_1, "tidy_data_1")

## Creates a second, independent tidy data set with the average of each variable for each
## activity and each subject.
names(variable) <- feature[,2]
mydata <- cbind(subject, activity, variable)

library(reshape2)
mydata_melt <- melt(mydata, id = c("subject", "activity"))

tidy_data_2 <- dcast(mydata_melt, subject + activity ~ variable, mean)

write.table(tidy_data_2, "tidy_data_2")

library(dplyr)
library(plyr)
library(data.table)
labels <- read.table("./UCI HAR Dataset/features.txt")
labels <- labels[,2]
activities <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("number", "activity"))

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
colnames(x_test) <- labels
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "activity")
test_full <- cbind(subject_test,y_test,x_test)

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
colnames(x_train) <- labels
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "activity")
train_full <- cbind(subject_train,y_train,x_train)

merge_data <- rbind(train_full,test_full)
select_data <- merge_data %>% select(subject, activity, contains("mean"), contains("std"))
select_data$activity <- activities[select_data$activity, 2]
str(select_data)


names(select_data)<-gsub("Acc", "accelerometer", names(select_data), ignore.case = TRUE)
names(select_data)<-gsub("Gyro", "gyroscope", names(select_data), ignore.case = TRUE)
names(select_data)<-gsub("BodyBody", "body", names(select_data), ignore.case = TRUE)
names(select_data)<-gsub("Mag", "magnitude", names(select_data), ignore.case = TRUE)
names(select_data)<-gsub("^t", "time", names(select_data), ignore.case = TRUE)
names(select_data)<-gsub("^f", "frequency", names(select_data), ignore.case = TRUE)
names(select_data)<-gsub("tBody", "timebody", names(select_data), ignore.case = TRUE)
names(select_data)<-gsub("-mean()", "mean", names(select_data), ignore.case = TRUE)
names(select_data)<-gsub("-std()", "std", names(select_data), ignore.case = TRUE)
names(select_data)<-gsub("-freq()", "frequency", names(select_data), ignore.case = TRUE)
names(select_data)<-gsub("angle", "angle", names(select_data), ignore.case = TRUE)
names(select_data)<-gsub("gravity", "gravity", names(select_data), ignore.case = TRUE)

grouped <- select_data %>% group_by(subject, activity) %>% 
  summarise_all(funs(mean))

# Course 3 Project

## Open up necessary packages
1) dplyr: manipulate data
```
library(dplyr)
```
2) plyr: clean up data 
```
library(plyr)
```
3) data.table: read and write tables neatly
```
library(data.table)
```
## Upload the overaching data
1) Create labels that will be used for both x_test and x_train as a list.
```
labels <- read.table("./UCI HAR Dataset/features.txt")
labels <- labels[,2]
```
2) Upload activities codebook that will be used for y_test and y_train to label activitys in datasest. 
```
activities <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("number", "activity"))
```
## Upload and merge test and train data set.
1) Read three datasets in for both test and train
```
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "activity")

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "activity")
```
2) Apply labels from first stage to x_test and x_train.
```
colnames(x_test) <- labels
colnames(x_train) <- labels
```
3) Bind test and train datasets together by columns.
```
test_full <- cbind(subject_test,y_test,x_test)
train_full <- cbind(subject_train,y_train,x_train)
```
## Create Merged Dataset
1) Merge test and train datasets together by rows.
```
merge_data <- rbind(train_full,test_full)
```
2) Select key columns for final dataset and name new dataset. 
```
select_data <- merge_data %>% select(subject, activity, contains("mean"), contains("std"))
```
## Put values to actvities
1) Using activities data set in Stage 2, assign names to values in "activity" column. 
```
select_data$activity <- activities[select_data$activity, 2]
```
## Clean dataset
1) Change abbreviations to full spelling.
```
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
```

## Create final dataset
1) Group data by subject in activity so that each subject has six activities total and summarize info by mean. 
```
grouped <- select_data %>% group_by(subject, activity) %>% 
  summarise_all(funs(mean))
```
2) Export data. 
```
write.table(grouped, file = "./groupeddata.txt",row.name=FALSE)
```

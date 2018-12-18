library(plyr)
library(dplyr)
library(tidyr)

#loading files and prepearing for work

dataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(dataUrl, "~/R_code/Getting and Cleaning Data/data.zip")
unzip("~/R_code/Getting and Cleaning Data/data.zip", exdir = "~/R_code/Getting and Cleaning Data")

setwd("~/R_code/Getting and Cleaning Data/UCI HAR Dataset")

#open subject, activity, features and data for test and traning datasets

activity_labels <- read.csv("activity_labels.txt",sep="", stringsAsFactors = FALSE, header = FALSE)
features_labels <- read.csv("features.txt",sep="", stringsAsFactors = FALSE, header = FALSE)

test_activity_label <- read.csv("test/y_test.txt",sep="", stringsAsFactors = FALSE, header = FALSE)
subject_test <- read.csv("test/subject_test.txt",sep="", stringsAsFactors = FALSE, header = FALSE)
test_data <- read.csv("test/X_test.txt",sep="", header = FALSE)

train_activity_label <- read.csv("train/y_train.txt",sep="", stringsAsFactors = FALSE, header = FALSE)
subject_train <- read.csv("train/subject_train.txt",sep="", stringsAsFactors = FALSE, header = FALSE)
train_data <- read.csv("train/X_train.txt",sep="", header = FALSE)

#naming columns
names(test_data) <- features_labels[,2]
names(train_data) <- features_labels[,2]

#adding subject label
test_data$subject <- factor(subject_test$V1)
train_data$subject <- factor(subject_train$V1)


#add activity column to test data/ renaming and adding activity label
test_data$activity <- factor(test_activity_label$V1)
test_data$activity <- revalue(test_data$activity, c("1"=activity_labels[1,2], "2"=activity_labels[2,2], 
    "3"=activity_labels[3,2], "4"=activity_labels[4,2], "5"=activity_labels[5,2], "6"=activity_labels[6,2]))

#add activity column to train data/renaming and adding activity label
train_data$activity <- factor(train_activity_label$V1)
train_data$activity <- revalue(train_data$activity, c("1"=activity_labels[1,2], "2"=activity_labels[2,2], 
    "3"=activity_labels[3,2], "4"=activity_labels[4,2], "5"=activity_labels[5,2], "6"=activity_labels[6,2]))

#joining test and train datasets
complete_data <- rbind(test_data,train_data)


#subsetting mean and std columns/ arranging by subject column
subset_data <- complete_data[,grepl("mean|std|activity|subject", names(complete_data))]
subset_data <- arrange(subset_data, subject)


#renaming varables
names(subset_data)<- gsub("\\()", "", names(subset_data))
names(subset_data)<- gsub("mean", "Mean", names(subset_data))
names(subset_data)<- gsub("std", "Standard_Deviation", names(subset_data))

#creating tidy data table consisting mean for every colunm for every subject and activity
tidy_data <- group_by(subset_data, subject, activity)
mean_table <- summarize_all(tidy_data, funs(mean))

#write to file
write.table(mean_table, "tidy_data.txt", row.names = FALSE)


## Defining workspace
setwd("C:/JordiFF/Getting_cleaning_data/UCI HAR Dataset")

## Defining global variables
ubisumusTest <- c("test")
ubisumusData <- c("train")

library(plyr)
library(dplyr)


## Test Files
X_Test <- read.table(paste(ubisumusTest,"/x_test.txt",sep=""),header=FALSE, sep="")
Y_Test <- read.table(paste(ubisumusTest,"/y_test.txt",sep=""),header=FALSE, sep="")
Subject_Test <- read.table(paste(ubisumusTest,"/subject_test.txt",sep=""),header=FALSE, sep="")

# Train Files
X_Train <- read.table(paste(ubisumusData,"/x_train.txt",sep=""),header=FALSE, sep="")
Y_Train <- read.table(paste(ubisumusData,"/y_train.txt",sep=""),header=FALSE, sep="")
Subject_Train <- read.table(paste(ubisumusData,"/subject_train.txt",sep=""),header=FALSE, sep="")

## Building datasets
x_data <- rbind(X_Train, X_Test)
y_data <- rbind(Y_Train, Y_Test)
subject_data <- rbind(Subject_Train, Subject_Test)

## Use descriptive activity names to name the activities in the data set
## update values with correct activity names

activities <- read.table("activity_labels.txt")
y_data[, 1] <- activities[y_data[, 1], 2]

## Labeling
names(subject_data) <- c("subject")
names(y_data) <- c("activity")
features <- read.table("features.txt")
names(x_data) <- features$V2

## Select interest's columns 
ff <- c(grep("mean\\(\\)", features[,2]),grep("std\\(\\)", features[,2]))
x_data_set <- subset(x_data, select=as.numeric(ff))
f_names <- names(x_data_set)
f_names = gsub('-mean', 'Mean', f_names)
f_names = gsub('-std', 'Std', f_names)
f_names <- gsub('[-()]', '', f_names)
names(x_data_set) <- f_names
##rm("ff")

## Buiding Total Dataset 
dataCombine <- cbind(subject_data, y_data)
Data_total <- cbind(dataCombine, x_data_set)

##  Final Resume and export 
Data_Resume  <-  aggregate(. ~subject + activity, Data_total, mean)
Data_Resume <- Data_Resume[order(Data_Resume$subject,Data_Resume$activity),]
write.table(Data_Resume, file = "tidyData.txt",row.name=FALSE)   


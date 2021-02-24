library(dplyr)
#labels
features <- read.table("~/R studio/course 3/week4/project/UCI HAR Dataset/features.txt", col.names = c("n","functions"))
labels <- read.table("~/R studio/course 3/week4/project/UCI HAR Dataset/activity_labels.txt", col.names = c("num","labels"))

#test data
xtest<-read.table("~/R studio/course 3/week4/project/UCI HAR Dataset/test/X_test.txt", header = FALSE, sep = "", dec = ".",col.names = features$functions)
ytest<-read.table("~/R studio/course 3/week4/project/UCI HAR Dataset/test/Y_test.txt", header = FALSE, sep = "", dec = ".", col.names = 'num')
subjectTest<-read.table("~/R studio/course 3/week4/project/UCI HAR Dataset/test/subject_test.txt", header = FALSE, sep = "", dec = ".",col.names = 'subject')
test<-cbind(xtest,ytest,subjectTest)

#train data
xtrain<-read.table("~/R studio/course 3/week4/project/UCI HAR Dataset/train/X_train.txt", header = FALSE, sep = "", dec = ".",col.names = features$functions)
ytrain<-read.table("~/R studio/course 3/week4/project/UCI HAR Dataset/train/Y_train.txt", header = FALSE, sep = "", dec = ".", col.names = 'num')
subjectTrain<-read.table("~/R studio/course 3/week4/project/UCI HAR Dataset/train/subject_train.txt", header = FALSE, sep = "", dec = ".",col.names = 'subject')
train<-cbind(xtrain,ytrain,subjectTrain)

#Merges the training and the test sets to create one data set.

total<-rbind(train,test)

#Extracts only the measurements on the mean and standard deviation for each measurement. 

TidyData<-total %>% select(subject,num, contains('mean'),contains('std'))

#Uses descriptive activity names to name the activities in the data set

TidyData$num<-labels[TidyData$num,2]

#Appropriately labels the data set with descriptive variable names. 

names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))


#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

TidyData2 <- aggregate(. ~subject + activity, TidyData, mean)
TidyData2 <- TidyData2[order(TidyData2$subject, TidyData2$activity),]


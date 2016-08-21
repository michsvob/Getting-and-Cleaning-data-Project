#Download and unzip files
if(!file.exists("wearData.zip")){
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
              "wearData.zip",method = "curl")
  unzip("wearData.zip")
}

#Read files into memory
featLabels<-read.table("UCI HAR Dataset/features.txt")
actLabels<-read.table("UCI HAR Dataset/activity_labels.txt")
trainData<-read.table("UCI HAR Dataset/train/X_train.txt")
testData<-read.table("UCI HAR Dataset/test/X_test.txt")
testAct<-read.table("UCI HAR Dataset/test/y_test.txt")
trainAct<-read.table("UCI HAR Dataset/train/y_train.txt")

#Name the columns
names(actLabels)<-c("Activity_ID","Activity")
names(testAct)<-c("Activity_ID")
names(trainAct)<-c("Activity_ID")
names(trainData)<-make.names(featLabels$V2,unique = TRUE)
names(testData)<-make.names(featLabels$V2,unique = TRUE)

#Bind column with activity ID
testData<-cbind(testData,testAct)
trainData<-cbind(trainData,trainAct)

#Bind column with translated activity ID (column Activity)
testData<-merge(testData,actLabels)
trainData<-merge(trainData,actLabels)

#Connect test dataset and training dataset
mergedData<-rbind(testData,trainData)

#Delete Activity_ID columns as it is no longer needed
mergedData$Activity_ID<-NULL

#Select just columns with mean and std
colInd<-grep("mean|std|Activity",names(mergedData))
selection<-mergedData[,colInd]

#Calculate averages for each variable for each activity
library(dplyr)
averages<-selection %>% group_by(Activity) %>% summarise_all(mean)
averages

write.table(averages,file = "dataset.txt",row.names = F)

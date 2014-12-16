## import the packages and set the wd
library(data.table)
library(reshape2)
setwd("set your own working directory")

## load the data from the data file, and assign each data as value name.
subject_test = read.table("./test/subject_test.txt", quote="\"")
x_test = read.table("./test/X_test.txt", quote="\"")
y_test = read.table("./test/y_test.txt", quote="\"")
subject_train = read.table("./train/subject_train.txt", quote="\"")
x_train = read.table("./train/X_train.txt", quote="\"")
y_train = read.table("./train/y_train.txt", quote="\"")
features = read.table("features.txt", quote="\"")
activity_labels = read.table("activity_labels.txt", quote="\"")

## extract two column from two data.frame as the data labels later.
feature_names = features[,2]
activity_names = activity_labels[,2]

## use two column above to replace the column names of x_test & x_train data.frame.
names(x_test) = feature_names
names(x_train) = feature_names

## use grepl() function to extract what do we want to get, which include the character fo "mean" or "std".
x_test = x_test[,grepl("mean|std",feature_names)]
x_train = x_train[,grepl("mean|std", feature_names)]

## create a column in the y_test & y_train which matchs the order of activity_names,and combine x_test　　
data = rbind(x_test,x_train)
y_test[,2] = activity_names[y_test[,1]]
y_train[,2] = activity_names[y_train[,1]]
activities = rbind(y_test, y_train)

names(activities) = c("ActivityID","Activity")

subject<-rbind(subject_test, subject_train)
colnames(subject)<-"s_number"
class(subject)
class(activities)

final_data = cbind(subject, activities, data)

id_labels = c("s_number","ActivityID","Activity")
data_labels = setdiff(colnames(final_data), id_labels)

predata = melt(final_data, id = id_labels, measure.vars = data_labels)
result = dcast(predata, s_number + Activity ~ variable, mean)
write.table(result, "tidydataset.txt",sep="/")

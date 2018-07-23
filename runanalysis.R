# Specify the directory for loading the files
directory = "./Data/UCI HAR Dataset"

# Loading XTrain and XTest from the local files
xTrain <- read.table(file.path(directory,"train","X_train.txt"))
xTest <- read.table(file.path(directory,"test","X_test.txt"))

# Loading yTrain and yTest from the local files
yTrain <- read.table(file.path(directory, "train", "y_train.txt"))
yTest <- read.table(file.path(directory, "test", "y_test.txt"))

# Loading subject train and subject test from the local files
subjectTrain = read.table(file.path(directory,"train","subject_train.txt"))
subjectTest = read.table(file.path(directory,"test","subject_test.txt"))

# Reading the features table
features <- read.table(file.path(directory,"features.txt"))

#Reading the activity table
activityLabels <- read.table(file.path(directory,"activity_labels.txt"), header = FALSE)

# Combining the x train and test sets and giving it column name
X <- rbind(xTrain,xTest)
colnames(X) <- features[,2]

# Combining the y train and test sets and giving it column name
Y <- rbind(yTrain,yTest)
colnames(Y) <- "activityId"

# Combining subject train and test sets and giving it column name
subject <- rbind(subjectTrain, subjectTest)
colnames(subject) <- "subject"

# Giving column name for activity table
colnames(activityLabels) <- c('activityId', 'activityType')

# Combining X, subject and Y
mergedComplete <- cbind(X,subject,Y)

# Checking for mean and stantard deviation and selection those columns only
meanStdCol <- grepl("activityId|subject|mean..|std..", colnames(mergedComplete))
selectedMeanStd <- mergedComplete[ , meanStdCol == TRUE]

# Removing the variable used.
rm(xTest, yTest, xTrain, yTrain, subjectTest, subjectTrain, X, Y, subject, mergedComplete)

# Uses descriptive activity names to name the activities in the data set
withActivityNames <- merge(selectedMeanStd, activityLabels, by="activityId", all.x = TRUE)

# Creates tidy set with the average of each variable for each activity and each subject
tidySet <- aggregate(. ~ subject + activityType, withActivityNames, mean)
tidySet <- tidySet[order(tidySet$subject, tidySet$activityType),]

# Write the table to file
write.table(tidySet, "tidySet.txt", row.name = FALSE)

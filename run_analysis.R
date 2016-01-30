#Necessary packages
library(data.table)

#1. Read info
features <- read.table("UCI HAR Dataset/features.txt", col.names=c("featureID", "featureName"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names=c("activityID", "activityName"))

activities$activityName <- gsub("_", "", as.character(activities$activityName))
includedFeatures <- grep("-mean\\(\\)|-std\\(\\)", features$featureName)

# 2. Read data
#Read training data
subject_train = read.table("UCI HAR Dataset/train/subject_train.txt")
X_train = read.table("UCI HAR Dataset/train/X_train.txt")
y_train = read.table("UCI HAR Dataset/train/Y_train.txt")


#Read test data
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/Y_test.txt") 


# 3. Merge test and training set
subjects <- rbind(subject_test, subject_train)
names(subjects) <- "subjectID"
X <- rbind(X_test, X_train)
X <- X[, includedFeatures]
names(X) <- gsub("\\(|\\)", "", features$featureName[includedFeatures])
Y <- rbind(y_test, y_train)
names(Y) = "activityID"
activity <- merge(Y, activities, by="activityID")$activityName


# Merge data frames
data <- cbind(subjects, X, activity)
write.table(data, "final_dataset.txt")
datatable <- data.table(data)

# 4. Create dataset after calculations
calculatedData<- datatable[, lapply(.SD, mean), by= c("subjectID", "activity")]

# 5. Store dataset
write.table(calculatedData, "calculated_dataset.txt",row.names = FALSE)
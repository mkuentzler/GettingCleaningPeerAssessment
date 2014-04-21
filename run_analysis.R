# The helper function getdata obtains and cleans data from the UCI HAR Dataset.
# It extracts the test and train data from the txt files and combines them
# into a single data set. The data set is labeled, and filtered as to only
# contain measurements on means and standard deviations. Activity and subject
# data is included, and activity data is labeled in a descriptive way.
#
# No analysis whatsoever is performed.
#
# The txt files are assumed to be in the 'UCI HAR Dataset' directory
# in the same way as in the zip file, and the 'UCI HAR Dataset' directory
# in the working directory.
getdata <- function() {
    # Deactivate StringsAsFactors
    options(stringsAsFactors = FALSE)
    
    # Load labels
    labels <- read.table('UCI HAR Dataset//features.txt')
    labels <- c(labels[, 2], 'Activity', 'Subject')
    act_labels <- read.table('UCI HAR Dataset/activity_labels.txt')
    
    # Load train and test data
    train <- read.table('UCI HAR Dataset/train/X_train.txt')
    train_activities <- read.table('UCI HAR Dataset/train/y_train.txt')
    train_subjects <- read.table('UCI HAR Dataset/train/subject_train.txt')
    
    test <- read.table('UCI HAR Dataset/test/X_test.txt')
    test_activities <- read.table('UCI HAR Dataset/test/y_test.txt')
    test_subjects <- read.table('UCI HAR Dataset/test/subject_test.txt')
    
    # Give descriptive activity names to activities data set. Use
    # the activity labels for this.
    train_activities <- merge(train_activities, act_labels, 
                              by.x = 'V1', by.y = 'V1', sort = FALSE)
    test_activities <- merge(test_activities, act_labels, 
                              by.x = 'V1', by.y = 'V1', sort = FALSE)
    
    # Merge data set with activities and subjects, label the whole thing
    train <- cbind(train, train_activities[, 2], train_subjects)
    colnames(train) <- labels
    
    test <- cbind(test, test_activities[, 2], test_subjects)
    colnames(test) <- labels
    
    # Merge train and test data to create a single data set
    mergeddata <- rbind(train, test)
    
    # Only select means and standard deviations. That is, only select columns
    # whose labels include '-mean()' or '-std()' (and activities and subjects).
    # Notably, -meanFreq() is _not_ selected.
    filter <- grep('-(mean|std)\\(\\)|Activity|Subject', labels)
    filtereddata <- mergeddata[, filter]
    
    # After the filter, the parentheses in the labels are no longer needed and
    # cause some hassle. The same goes for the minus signs. The lines below
    # remove the parentheses and replace minus signs by underscores.
    colnames(filtereddata) <- gsub('\\(\\)', '', colnames(filtereddata))
    colnames(filtereddata) <- gsub('-', '_', colnames(filtereddata))
    
    return(filtereddata)
}

# The helper function tidydata returns a tidy data set that contains the mean
# of each variable for each activity-subject pair.
tidydata <- function(data) {
    # Load dplyr library
    library('dplyr')
    
    # Find all subjects and activities
    subjects = sort(unique(data$Subject))
    activities = sort(unique(data$Activity))
    
    # Declare the subject and activity columns as label columns, instead of
    # measurements. The other columns are measurement columns.
    labelcols <- c('Activity', 'Subject')
    measurecols <- colnames(data)[colnames(data)!=labelcols]
    
    # Group data by Subject and Activity
    groupeddata <- data %.% group_by(Subject, Activity) 
    
    # Define list of means to take. Average over each measurement variable.
    # Formatting is such as to fit into the dplyr summarise statement.
    measuremeans <- sapply(measurecols, 
                           function(x) substitute(mean(x), list(x=as.name(x))))
    
    # Summarise the data into the tidy data set. The tidy data set contains
    # averages for each variable for each activity and subject.
    tidydata <- do.call(summarise, c(list(.data=groupeddata), measuremeans))
    
    return(tidydata)
}

# Execute the two functions: First, get the data. Then, tidy it.
data <- getdata()
tidy <- tidydata(data)
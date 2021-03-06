
# get the data (train)
pmltrain <- read.csv("pml-training.csv", stringsAsFactors=FALSE)
#pmltrain <- subset(pmltrain, new_window == 'yes')
pmltrain$classe <- as.factor(pmltrain$classe)

# remove the first line (ID of the line)
pmltrain <- pmltrain[,-1]
pmltrain <- pmltrain[,-grep("user_name|raw_timestamp_part_1|raw_timestamp_part_2|cvtd_timestamp|new_window|num_window", 
                            colnames(pmltrain))]
# first group of missing data in validation data set
pmltrain <- pmltrain[,-grep("kurtosis_roll_belt|kurtosis_picth_belt|kurtosis_yaw_belt|skewness_roll_belt|skewness_roll_belt.1|skewness_yaw_belt|max_roll_belt|max_picth_belt|max_yaw_belt|min_roll_belt|min_pitch_belt|min_yaw_belt|amplitude_roll_belt|amplitude_pitch_belt|amplitude_yaw_belt|var_total_accel_belt|avg_roll_belt|stddev_roll_belt|var_roll_belt|avg_pitch_belt|stddev_pitch_belt|var_pitch_belt|avg_yaw_belt|stddev_yaw_belt|var_yaw_belt",
                            colnames(pmltrain))]

# second group of missing data
pmltrain <- pmltrain[,-grep("var_accel_arm|avg_roll_arm|stddev_roll_arm|var_roll_arm|avg_pitch_arm|stddev_pitch_arm|var_pitch_arm|avg_yaw_arm|stddev_yaw_arm|var_yaw_arm",
                            colnames(pmltrain))]
# another group of missing data
pmltrain <- pmltrain[,-grep("kurtosis_roll_arm|kurtosis_picth_arm|kurtosis_yaw_arm|skewness_roll_arm|skewness_pitch_arm|skewness_yaw_arm|max_roll_arm|max_picth_arm|max_yaw_arm|min_roll_arm|min_pitch_arm|min_yaw_arm|amplitude_roll_arm|amplitude_pitch_arm|amplitude_yaw_arm",
                            colnames(pmltrain))]

# another group of missing data
pmltrain <- pmltrain[,-grep("kurtosis_roll_dumbbell|kurtosis_picth_dumbbell|kurtosis_yaw_dumbbell|skewness_roll_dumbbell|skewness_pitch_dumbbell|skewness_yaw_dumbbell|max_roll_dumbbell|max_picth_dumbbell|max_yaw_dumbbell|min_roll_dumbbell|min_pitch_dumbbell|min_yaw_dumbbell|amplitude_roll_dumbbell|amplitude_pitch_dumbbell|amplitude_yaw_dumbbell",
                            colnames(pmltrain))]

# another group of missing data
pmltrain <- pmltrain[,-grep("var_accel_dumbbell|avg_roll_dumbbell|stddev_roll_dumbbell|var_roll_dumbbell|avg_pitch_dumbbell|stddev_pitch_dumbbell|var_pitch_dumbbell|avg_yaw_dumbbell|stddev_yaw_dumbbell|var_yaw_dumbbell",
                            colnames(pmltrain))]

# another group of missing data
pmltrain <- pmltrain[,-grep("kurtosis_roll_forearm|kurtosis_picth_forearm|kurtosis_yaw_forearm|skewness_roll_forearm|skewness_pitch_forearm|skewness_yaw_forearm|max_roll_forearm|max_picth_forearm|max_yaw_forearm|min_roll_forearm|min_pitch_forearm|min_yaw_forearm|amplitude_roll_forearm|amplitude_pitch_forearm|amplitude_yaw_forearm|total_accel_forearm|var_accel_forearm|avg_roll_forearm|stddev_roll_forearm|var_roll_forearm|avg_pitch_forearm|stddev_pitch_forearm|var_pitch_forearm|avg_yaw_forearm|stddev_yaw_forearm|var_yaw_forearm",
                            colnames(pmltrain))]

# ML start here 
library(caret)

inTrain = createDataPartition(pmltrain$classe, p=0.7, list=FALSE)
training = pmltrain[inTrain,]
testing = pmltrain[-inTrain,]

fitControl <- trainControl(method = "cv", #cross validation
                           number = 100 # fold cross-validation
)
modFit = train(classe ~ ., data=training, method="rf", trainControl=fitControl)

pred = predict(modFit,newdata = testing)

#plot(modFit)
confusionMatrix(pred,testing$classe)


# get the data (validation)
pmltesting <- read.csv("pml-testing.csv", stringsAsFactors=FALSE)
pmltesting <- pmltesting[,names(pmltesting) %in% names(pmltrain)]

predValid = predict(modFit,newdata = pmltesting)

predValid

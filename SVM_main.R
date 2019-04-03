# The time difference
timediff <- function(time_start, time_end) {
  time_start <- as.POSIXct(time_start)
  dt <- difftime(time_end, time_start, units="secs")
  format(.POSIXct(dt,tz = "GMT"), "%H:%M:%S")
}

# Calculate the same ratio
getAccu <- function(firstVec, secondVec) {
  # Calculate the accuracy
  count = 0
  num = length(firstVec)
  for (n in 1:num) {
    if(firstVec[n] == secondVec[n]) {
      count <- count + 1
    }
  }
  return(accurate = count / num)
}

# Binaryzation (thresholding)
binarize <- function(data) {
  return (ceiling(data / 255))
}


#----------Tune svm-------------------------
tuned <- tune.svm(label~., data = data_svm_train, degree=(2:4), gamma=10^(-4:1), cost=10^(0:1), coef0=(0:1))
# To select best parameters
summary(tuned)


#----------Prepare the Training Data------------------------
# Read the data，T for true，means the first row is hte name of columns
data_svm_train = read.csv("mnist_train.csv", header= T )
# Unpack the data_train frame to facilitate direct manipulation of its variables.
attach(data_svm_train)
# Get all the columns exclude label column
x_svm_train <- subset(data_svm_train, select = -label)
# Get the label column
y_svm_train <- label


#---------Prepare the Test Data---------------------
data_svm_test = read.csv("mnist_test.csv", header = T)
attach(data_svm_test)
x_svm_test <- subset(data_svm_test, select =- label)
y_svm_test <- label


#--------Data Pre-processing-------------------------
t1 = Sys.time()
x_svm_train <- binarize(x_svm_train)
t2 = Sys.time()
x_svm_test <- binarize(x_svm_test)
t3 = Sys.time()
paste("pre-possing time of the training data：", timediff(t1, t2))
paste("pre-possing time of the test data：", timediff(t2, t3))


#----------svm Training-------------------------
# Install e1071 package
library("e1071")
# svm Training
time_start_train = Sys.time()
model <- svm(x_svm_train, y_svm_train, 
             kernel = "polynomial", degree=3, gamma=3, coef0=1, cost=1 ,type = "C-classification")
time_end_train = Sys.time()


time_start_test = Sys.time()
y_svm_pred = predict(model, x_svm_test);
time_end_test = Sys.time()

print(model)

paste("training time：", timediff(time_start_train, time_end_train))
paste("testing time：", timediff(time_start_test, time_end_test))

# Show the results
table(y_svm_pred, y_svm_test)
# Show the model
paste("Number of training samples：", length(y_svm_train))
paste("Number of support vectors：", length(model$index))

# Calculate the accuracy
paste("accuracy：", getAccu(y_svm_pred, y_svm_test))


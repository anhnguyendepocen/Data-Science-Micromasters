# Function to visualize a number
plotImg <- function(data, row_index){
  # Obtaining the row as a numeric vector
  r <- as.numeric(data[row_index, 1:784])
  # Creating a empty matrix to use
  im <- matrix(nrow = 28, ncol = 28)
  # Filling properly the data into the matrix
  j <- 1
  
  for(i in 28:1){
    im[,i] <- r[j:(j+27)]
    j <- j+28
  }  
  # Plotting the image with the label
  image(x = 1:28, 
        y = 1:28, 
        z = im, 
        col=gray((0:255)/255), 
        main = paste("Number:", data[row_index, 1]))
}

setwd("~/Documents/GitHub/Data-Science-Micromasters/Machine Learning Fundamentals/Week 1 - Prediction Problems")

train <- read.csv2('Files/MNIST/train.csv', stringsAsFactors = F, dec = '.')
test  <- read.csv2('Files/MNIST/test.csv', stringsAsFactors = F, dec = '.')

trainData   <- as.matrix(train[1:784])
trainLabels <- as.matrix(train[785])
testData    <- as.matrix(test[1:784])
testLabels  <- as.matrix(test[785])

plotImg(train,1)

# Computes squared Euclidean distance between two vectors.
euclideanDistance <- function(x,y){
  return (sum((x-y)^2))
}

# Finds the nearest neighbor for a vector of values
findNN <- function(x){
  distances <- c()
  for(i in 1:nrow(train)){
    distances <- c(distances,euclideanDistance(x,trainData[i,]))
  }
  return(which.min(distances))
}

# Classifies the label for NN
NNClassifier <- function(x){
  index <- findNN(x)
  return(trainLabels[index])
}

# Predict on each test data point (and time it!)
before <- Sys.time()
testPredictions <- c()
for(i in 1:nrow(test)){
  testPredictions <- c(testPredictions,NNClassifier(testData[i,]))
}
after <- Sys.time()

time <- after - before

errPredictions <- sum(!(testPredictions == testLabels)*1)
error <- errPredictions/length(testLabels)

print(paste('Model\'s Error:',error))

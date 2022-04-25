# Read in entire train data
# Eliminate all superfluous columns
# Mutate columns to count the 220 + 108 words
# Create lasso model
library(tokenizers)
library(stopwords)
library(glmnet)

# Eliminate all superfluous columns
df <- read.csv("#Guides/train_yelp.csv",header=TRUE,stringsAsFactors=FALSE)
df = df[,-c(7:208)]

# Read in words list
target = c(atleast30, neverInFiveWords)

tokens = tokenize_words(df$text, stopwords = stopwords::stopwords("en"))

# Could use sum
dumvec = vector()
for (j in 1:length(tokens)){
  dumvec = append(dumvec, ifelse(target[1] %in% tokens[[j]], 1, 0))
}
cbinded = data.frame(dumvec)
for (i in 2:length(target)){
  dumvec = vector()
  cat("Processing", i, "\n")
  for (j in 1:length(tokens)){
    dumvec = append(dumvec, ifelse(target[i] %in% tokens[[j]], 1, 0))
  }
  cbinded = cbind(cbinded, dumvec)
}

df = cbind(df, cbinded)

# change column names
colnames(df) <- c("Id", "star", "name", "city", "postalCode", "text", target)


# Divide into predictor and response... Factorize postal code
# Drop Id, name, city, and text
y <- df$star
y <- as.factor(y)
x <- df[, -c(1, 2, 3, 4, 6)]
x$postalCode = as.factor(x$postalCode)

fit <- glmnet(x, y, family = "multinomial", type.multinomial = "grouped")
plot(fit)

# CV Lasso Regression
matrix.x <- data.matrix(x)
matrix.y <- data.matrix(y)
lasso_cv = cv.glmnet(matrix.x, matrix.y, family = "multinomial", type.multinomial = "grouped")

plot(lasso_cv)
coef(lasso_cv)

predictions = predict(lasso_cv, newx = matrix.x, s = "lambda.min", type = "class")

barplot(table(predictions))

mean(predictions[,1] == matrix.y[,1])

# SuperLearner
library(SuperLearner)
SL.library <- c("SL.glm", "SL.mean", "SL.glmnet","SL.step")

multinomial.SL <-SuperLearner(Y=df$star,X=x, 
                          SL.library=SL.library, family=gaussian(),
                          method="method.NNLS", verbose=TRUE) 

write.csv(df, file = "dataset.csv")

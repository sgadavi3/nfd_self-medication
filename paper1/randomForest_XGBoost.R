#load required packages
library(caret)
library(classInt)
library(data.table)
library(ggalluvial)
library(ggplot2)
library(Matrix)
library(pdp)
library(randomForest)
library(usdm)
library(xgboost)

#load data
data(iris)
#one hot code categorical variables
iris <- as.data.table(as.matrix(sparse.model.matrix(~.-1, data = iris)))

#explore correlations (target variable is Petal.Width)
cor(iris[,1:4])
#perform vif analysis to check for multicolinearity
vif(iris[,1:3])
#select variables from the correlation and vif analysis to include in models

#index data to split on
set.seed(16)
trainIndex <- createDataPartition(iris$Petal.Width, p = .7, list = FALSE, times = 1)
#split data into train and test 
iTrain <- iris[trainIndex,]
iTest <- iris[-trainIndex,]

#perform Random Forests 
Rfit <- randomForest(Petal.Width ~ ., data=iTrain, 
                     importance=TRUE, 
                     ntree=500, 
                     mtry = ncol(iTrain)/3)

#perform XGBoost
#set up 10 fold cross validation for parameter grid search 
tc <- trainControl(method="repeatedcv", number = 10, repeats = 1, allowParallel = T)
#set up grid for parameter grid search (low rounds and largers learning rate to reduce time)
xgbGrid <- expand.grid(nrounds = seq(100, 500, 200),
                       eta = 0.3,
                       max_depth = seq(4, 6, 4),
                       gamma = 0, 
                       min_child_weight = 1, 
                       colsample_bytree = 0.7, 
                       subsample = 0.7)
#run parameter tuning
set.seed(16)
xgbFit <- train(Petal.Width ~ ., 
                data = iTrain, 
                method = 'xgbTree', 
                trainControl = tc,
                verbose = T, 
                tuneGrid = xgbGrid,
                importance = T)

#set parameters for final model 
param_Xfit <- list(booster="gbtree",
                   silent=0,
                   eta=0.001,
                   max_depth=6,
                   #for proportion use reg:logistic
                   objective="reg:linear",
                   eval_metric='rmse',
                   subsample=0.7)

#create watchlist to check performance between train and test (have to convert data to xgb.DMatrix() to use xgboost)
watchlist <- list(train=xgb.DMatrix(as.matrix(iTrain[,c(1:3,5:7)]), 
                                    label = iTrain$Petal.Width), 
                  test=xgb.DMatrix(as.matrix(iTest[,c(1:3,5:7)]), 
                                   label = iTest$Petal.Width))
#run cross validation with the eta reduced to find the best number of rounds
set.seed(16)
xgb.cv(params = param_Xfit,
       data = xgb.DMatrix(as.matrix(iTrain[, c(1:3, 5:7)]),
                          label = iTrain$Petal.Width),
       watchlist = watchlist,
       nrounds = 5000,
       nfold = 10,
       early_stopping_rounds = 50)
#run the final xgboost model
set.seed(16)
Xfit <-xgb.train(params=param_Xfit,
                 data=xgb.DMatrix(as.matrix(iTrain[,c(1:3,5:7)]), 
                                  label = iTrain$Petal.Width),
                 watchlist = watchlist,
                 nrounds=5000, importance = T)

#variable importance 
z <- Rfit$importance
y <- xgb.importance(colnames(iTest), model = Xfit)

#alluvial plots (extension of Sankey diagrams)
#RF featimp rank 
x <- as.data.table(z)
x <- x[order(-x$`%IncMSE`),]
x$var <- c("Petal.Length", "Speciessetosa", "Speciesversicolor", "Speciesvirginica", 
           "Sepal.Width", "Sepal.Length")
x$rank <- c(1:6)
#XGBoost featimp rank 
w <- as.data.frame(y[,1:2])
w$rank <- c(1:5)
w[nrow(w) + 1, 1:3] = list("Speciessetosa", 0, 6)
#set colours 
colfunc <- colorRampPalette(c("deepskyblue2","orange","brown1"))
foo <- classIntervals(w$rank, 3, "quantile")
w$quants <- cut(w$rank, breaks = foo$brks, labels=as.character(1:3))
w[is.na(w)] <- 1
v <- merge(w, x, by.x ="Feature", by.y = "var")
#create plot 
u <- ggplot(v,
            aes(weight = 1, axis1 = rank.x, axis2 = rank.y)) + 
  geom_alluvium(aes(fill = quants), width = 1/24) +
  scale_fill_manual(values = colfunc(10)) + 
  geom_stratum(width = 1/24, fill = "grey", color = "black") + 
  theme(axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank()) + 
  geom_text(stat = "stratum", label.strata = TRUE,  size = 0) + 
  scale_x_continuous(breaks = 1:2, labels = c("XGBoost", "rForest")) 
u   

#partial dependency plots
set.seed(16)
rfPart <- partial(Rfit, 
                  var.data = iTrain,
                  pred.var = "Petal.Length",
                  plot = T)
xgbPart <- partial(Xfit, 
                   train = as.matrix(iTrain[,c(1:3,5:7)]),
                   pred.var = "Petal.Length",
                   plot = T)


#model summary metrics
#random forest
rfpred <- predict(Rfit, iTest[,c(1:3,5:7)])
postResample(rfpred, iTest$Petal.Width)
#xgboost
xgbpred <- predict(Xfit, xgb.DMatrix(as.matrix(iTest[,c(1:3,5:7)]), 
                                     label = iTest$Petal.Width))
postResample(xgbpred, iTest$Petal.Width)

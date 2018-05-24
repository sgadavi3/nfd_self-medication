#packages 
library(data.table)
library(caret)
library(classInt)
library(ggalluvial)
library(ggplot2)
library(ggpubr)
library(Matrix)
library(pdp)
library(randomForest)

#data
data(iris)
iris <- as.data.table(as.matrix(sparse.model.matrix(~.-1, data = iris)))

#reproduce results by setting seed
set.seed(123)

#index data to split 
trainIndex <- createDataPartition(iris$Sepal.Length, p = .8, list = FALSE, times = 1)
#split data to train and test 
iTrain <- iris[trainIndex,]
iTest <- iris[-trainIndex,]

#parameter tuning
tc <- trainControl(method="repeatedcv", number = 10, repeats = 3, allowParallel = T)

#Random Forest
#parameter grid search (mtry = p/3 for regression)
mtry <- ncol(iTrain) / 3
rfgrid <- expand.grid(.mtry = mtry)

#run rf model (replace 'rf' with 'parRF' for parallel application)
system.time(RfFit <- train(Sepal.Length ~ ., 
                            data = iTrain, 
                            method = 'rf', 
                            trainControl = tc,
                            verbose = F, 
                            tuneGrid = rfgrid, 
                            ntree = 500, 
                            importance = T,
                            verboseIter = T))

#XGBoost 
#parameter grid search 
xgbGrid <- expand.grid(nrounds = seq(50, 500, 50),
                       eta = seq(0.075, 0.3, 0.075),
                       max_depth = seq(4, 6, 4),
                       gamma = 0, 
                       min_child_weight = 1, 
                       colsample_bytree = 1, 
                       subsample = 1)
#run XGBoost model
xgbFit <- train(Sepal.Length ~ ., 
                data = iTrain, 
                method = 'xgbTree', 
                trainControl = tc,
                verbose = T, 
                tuneGrid = xgbGrid,
                importance = T)


#model summary 
RfFit
xgbFit

#variable importance 
z <- varImp(RfFit) 
y <- varImp(xgbFit)

#RF featimp rank 
x <- as.data.table(z$importance)
x$var <- c("Sepal.Width", "Petal.Length", "Petal.Width", "Speciessetosa", "Speciesversicolor", "Speciesvirginica")
x <- x[order(-x$Overall),]
x$rank <- c(1:6)

#XGBoost featimp rank 
w <- as.data.table(y$importance)
y
w$var <- c("Petal.Length", "Sepal.Width", "Petal.Width", "Speciesversicolor", "Speciesvirginica", "Speciessetosa")
w$rank <- c(1:6)

#colours
colfunc <- colorRampPalette(c("deepskyblue2","orange","brown1"))
foo <- classIntervals(w$rank, 3, "quantile")
w$quants <- cut(w$rank, breaks = foo$brks, labels=as.character(1:3))
w[is.na(w)] <- 1
v <- merge(w,x,"var")

#Plot
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
rfPart <- partial(RfFit, 
                  var.data = iTrain,
                  pred.var = "Petal.Length",
                  plot = F)
xgbPart <- partial(xgbFit, 
                  var.data = iTrain,
                  pred.var = "Petal.Length",
                  plot = F)


#plot pdp using ggplot2 (replace geom_line with geom_point for points)
a <- ggplot(rfPart, aes(x = Petal.Length, y = yhat)) +
    geom_line()
b <- ggplot(xgbPart, aes(x = Petal.Length, y = yhat)) +
    geom_line()

ggarrange(a,b,nrow=1,ncol=2)

#test on 30% unseen data
rfPred <- predict(RfFit, iTest)
xgbPred <- predict(xgbFit, iTest)


#summary metrics 
rfSum <- postResample(rfPred, iTest$Sepal.Length)
xgbSum <- postResample(xgbPred, iTest$Sepal.Length)
rfSum
xgbSum

library(corrgram)
library(corrplot)
library(caTools)

# making bike as the data frame for containing the bike.csv file

bike <- read.csv('bikeshare.csv')

# making the ggplot to really see how is count related to other factors

ggplot(bike,aes(temp,count)) + geom_point(aes(color=temp),alpha=0.5)

# we see that the count of bike rented is higher when the temp is higher

bike$datetime <- as.POSIXct(bike$datetime)

ggplot(bike,aes(datetime,count)) + geom_point(aes(color=temp),alpha=0.3) + scale_color_continuous(low='green',high='red')

# here we see that the bike rented is higher when its summer months

cor(bike[,c('temp','count')])

# from the above correlation function we see they are related by 0.4

pl <- ggplot(bike,aes(factor(season),count)) + geom_boxplot(aes(color=factor(season)))

pl + theme_bw()

# we see from the above ggplot that counts of bike rented are higher when its summer and fall
# making a new column for just hour to see which hour has the most rented bike

bike$hour <- sapply(bike$datetime,function(x){format(x,'%H')})

pl <- ggplot(filter(bike,workingday==1),aes(hour,count)) + geom_point(position=position_jitter(w=1, h=0),aes(color=temp),alpha=0.5)

pl <- pl + scale_color_gradientn(colours = c('dark blue','blue','light blue','light green','yellow','orange','red'))
pl + theme_bw()

# from the ggplot we can deduce that rented bikes are higher during rush hour in the weekdays

# Now we will see how is the rent of bike during the day in the weekends

pl <- ggplot(filter(bike,workingday==0),aes(hour,count)) + geom_point(position=position_jitter(w=1, h=0),aes(color=temp),alpha=0.5)

pl <- pl + scale_color_gradientn(colours = c('dark blue','blue','light blue','light green','yellow','orange','red'))

pl <- pl + theme_bw()

# we see that during the weekend the rented bikes are more during afternoon to sunset

# Now lets build the model as we have enough EDA

model <- lm(count ~ temp,bike)

summary(model)

# so we have our working model and if someone asks us how many bike will be rented when the temp is 25
# we have two ways to answer that one is by using the residual data and the other one is using predict function
# I like more the predict way so we will do that here
# know that our model is only made with two things in mind, count being affected by temp so if someone asks how many bike will be
# rented during weekends, then our model cant answer that, just to remember few things

temp.test <- data.frame(temp=c(25))

predict(model,temp.test)

# we have our answer, if the temp is 25 then the bikes rented are 235

#### Now we will do something quite interesting and slick if you would like, lets now see how it computes when we put it to test depending on all factors
#### not just the column temperature
#### lets see how well our model performs when all the factors are considered into the equation.
#### EXCITED

#### now we will go a step further and made the model which can predict the count based on all factors of the equation

bike <- read.csv('bikeshare.csv')

#### checking which we can factor

str(bike)

#### factoring now

bike$season <- factor(bike$season)
bike$holiday <- factor(bike$holiday)
bike$workingday <- factor(bike$workingday)
bike$weather <- factor(bike$weather)

str(bike)

#### all set so now lets go for the modeling

sample <- sample.split(bike$count,SplitRatio = 0.7)

train <- subset(bike, sample == TRUE)
test <- subset(bike,sample == FALSE)

model <- lm(count ~ .,train)

summary(model)

#### prediction

predict.model <- predict(model,test[,!names(test) %in% 'count'])

#### but to really check the accuracy we can't do on such a big continuous data
#### because our model predicts the count, it will be a confusing to draw the confusion matrix
#### so to solve that and to see the accuracy of our project we will do something sneaky
#### we will select random row from the test and then compare to the prediction



#### using just 1 row to really see, excited

single.row <- test[7,!names(test) %in% 'count']

View(test)
test[7,]
test$count[7]

#### the count on the test data shows 9 so lets see now

View(single.row)
single.row

predict.model.2 <- predict(model,single.row)
#### testing the prediction and model

print(predict.model.2)

table(predict.model.2,test$count[7])

#### seems pretty accurate

#### lets try one more time 

single.row <- test[264,!names(test) %in% 'count']


predict.model.3 <- predict(model,single.row)

print(predict.model.3)

test$count[264]

table(predict.model.3,test$count[264])

#### that sums it up, in statistics we never say our model is perfect or solidly accurate but here i can say its a good model

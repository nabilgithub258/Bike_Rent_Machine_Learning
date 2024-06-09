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
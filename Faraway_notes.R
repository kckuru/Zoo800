###################################
### Notes from Faraway textbook ###
###################################

install.packages("faraway")
library(faraway)
data(pima)
head(pima)

summary(pima)
sort(pima$diastolic)

pima$diastolic[pima$diastolic == 0] <- NA
pima$triceps[pima$triceps == 0] <- NA
pima$insulin[pima$insulin == 0] <- NA
pima$glucose[pima$glucose == 0] <- NA
pima$bmi[pima$bmi == 0] <- NA

pima$test <- factor(pima$test)
summary(pima$test)

levels(pima$test) <- c("negative", "positive")
summary(pima)

hist(pima$diastolic, xlab = "Diastolic", main = "")

plot(density(pima$diastolic, na.rm = TRUE), main = "")

plot(sort(pima$diastolic), ylab = "Sorted Diastolic")

plot(diabetes ~ diastolic, pima)
plot(diabetes ~ test, pima)


library(ggplot2)
require(ggplot2)
ggplot(pima,aes(x=diastolic))+geom_histogram()
ggplot(pima,aes(x=diastolic))+geom_density()
ggplot(pima,aes(x=diastolic,y=diabetes))+geom_point()

ggplot(pima,aes(x=diastolic,y=diabetes,shape=test))+geom_point()+
  theme(legend.position = "top", legend.direction = "horizontal")

ggplot(pima,aes(x=diastolic,y=diabetes)) + geom_point(size=1) +
  facet_grid(~ test)



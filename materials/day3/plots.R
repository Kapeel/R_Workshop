set.seed(83465)

n <- 16 * 5
hotdog <- data.frame(Week = rep(1:16, each = 5),
                     Day = c("Mon", "Tue", "Wed", "Thu", "Fri"),
                     Beef = sample(1:20, 80, replace = TRUE),
                     Pork = sample(1:20, 80, replace = TRUE),
                     Turkey = sample(1:20, 80, replace = TRUE))

hotdog <- within(hotdog, {
  Turkey.Sodium <- rnorm(n, 821, 30) * Turkey
  Pork.Sodium <- rnorm(n, 620, 30) * Pork
  Beef.Sodium <- rnorm(n, 657, 30) * Beef
  Turkey.Fat <- rnorm(n, 10, 3) * Turkey
  Pork.Fat <- rnorm(n, 18, 3) * Pork
  Beef.Fat <- rnorm(n, 17, 3) * Beef 
  Turkey.Calories <- rnorm(n, 132, 15) * Turkey
  Pork.Calories <- rnorm(n, 205, 15) * Pork
  Beef.Calories <- rnorm(n, 194, 15) * Beef
})

hotdog <- within(hotdog, {
  Total.Sodium <- rowSums(hotdog[grep("Sodium$", names(hotdog))])
  Total.Fat <- rowSums(hotdog[grep("Fat$", names(hotdog))])
  Total.Calories <- rowSums(hotdog[grep("Calories$", names(hotdog))])
  Total <- rowSums(hotdog[c("Beef", "Pork", "Turkey")])
})

write.csv(hotdog, "materials/day3/hotdog.csv", row.names = FALSE)

hd1 <- read.csv("materials/day3/hotdog.csv")

################################################################################

require(gdata)
hotdog <- read.xls("materials/day3/hotdog.xlsx", 
                   pattern = "Week", sheet = "HotDog")

# order the factor Day
hotdog$Day <- factor(hotdog$Day, levels = c("Mon", "Tue", "Wed", "Thu", "Fri"))

# Histograms
par(mfrow = c(2, 2))
with(hotdog, hist(Beef), xlab = "Daily Count")
with(hotdog, hist(Pork), xlab = "Daily Count")
with(hotdog, hist(Turkey), xlab = "Daily Count")
with(hotdog, hist(Total), xlab = "Daily Count")
par(mfrow = c(1, 1))

# Boxplots
par(mfrow = c(2, 2))
boxplot(Beef ~ Day, data = hotdog, main = "Beef Counts")
boxplot(Beef.Calories ~ Day, data = hotdog, main = "Beef Calories")
boxplot(Beef.Fat ~ Day, data = hotdog, main = "Beef Fat (g)")
boxplot(Beef.Sodium ~ Day, data = hotdog, main = "Beef Sodium (mg)")
par(mfrow =hotdog c(1, 1))

par(mfrow = c(2, 2))
boxplot(hotdog[c("Beef", "Pork", "Turkey", "Total")], 
        main = "Daily Counts")
boxplot(hotdog[paste0(c("Beef", "Pork", "Turkey", "Total"), ".Calories")], 
        main = "Daily Calories")
boxplot(hotdog[paste0(c("Beef", "Pork", "Turkey", "Total"), ".Fat")], 
        main = "Daily Fat")
boxplot(hotdog[paste0(c("Beef", "Pork", "Turkey", "Total"), ".Sodium")], 
        main = "Daily Sodium")
par(mfrow = c(1, 1))

# Scatterplots
plot(hotdog[3:14])
require(psych)
pairs.panels(hotdog[3:14])
par(mfrow = c(2, 2))
boxplot(Beef.Fat ~ Beef.Calories, data = hotdog, 
        main = "Beef: Fat v. Calories")
boxplot(Pork.Fat ~ Pork.Calories, data = hotdog, 
        main = "Pork: Fat v. Calories")
boxplot(Turkey.Fat ~ Turkey.Calories, data = hotdog, 
        main = "Turkey: Fat v. Calories")
boxplot(Total.Fat ~ Total.Calories, data = hotdog, 
        main = "Total: Fat v. Calories")
par(mfrow = c(1, 1))

# Week 1 Plot
hd.w1 <- subset(hotdog, hotdog$Week == 1)
plot(hd.w1$Beef, type = "o", col = "red", ylim = c(0, 20), 
       axes = FALSE, ann = FALSE)
title(main = "Isaac's Weekly Hot Dog Consumption", 
      col.main = "Maroon", font.main = 4)
lines(hd.w1$Pork, type = "o", col = "forestgreen", 
      pch = 22, lty = 2)
lines(hd.w1$Turkey, type = "o", col = "blue", 
      pch = 23, lty = 3)
axis(1, at = 1:5, lab = hd.w1$Day)
title(xlab = "Days", col.lab = "steelblue", font.lab = 2)
axis(2, las = 1, at = seq(0, 20, 5))
title(ylab = "Devoured", col.lab = 3, font.lab = 2)
# Add legend and text
legend(x = 4.5, y = 3, 
       legend = c("Beef", "Pork", "Turkey"),                  
       col = c("red", "forestgreen", "blue"),   
       pch = 21:23, lty = 1:3,                                   
       bty = "n", cex = 0.8                                      
)  
text(x = 3, y = 17, "SICK", col = "tomato4")

## Step through making above plot ##

# clean data --> Make it TIDY
get.each.type <- function(type) {
  # returns the complete data for a hot dog type
  data.frame(hotdog[c("Week", "Day")],
             Type = type,
             Count = hotdog[, type],
             Calories = hotdog[, paste(type, "Calories", sep = ".")],
             Fat = hotdog[, paste(type, "Fat", sep = ".")],
             Sodium = hotdog[, paste(type, "Sodium", sep = ".")])
}

# get complete data for each hot dog type and stack them
hd <- rbind(get.each.type("Beef"),
            get.each.type("Pork"),
            get.each.type("Turkey"),
            get.each.type("Total"))
# by day
# order by week and day and cleanup row names
hd <- hd[order(hd$Week, hd$Day), ]
rownames(hd) <- 1:nrow(hd)

# summarise the data
require(dplyr)
# by hotdog type
hd %.%
  group_by(Type) %.%
  summarise(Count = sum(Count),
            Calories = sum(Calories),
            Fat = sum(Fat),
            Sodium = sum(Sodium))
# by day
subset(hd, hd$Type != "Total") %.%
  group_by(Day) %.%
  summarise(Count = sum(Count),
            Calories = sum(Calories),
            Fat = sum(Fat),
            Sodium = sum(Sodium))

require(ggplot2)
# histograms
ggplot(hd, aes(x = Count)) + 
  facet_wrap(~Type, scales = "free_x") +
  geom_histogram(aes(color = Type, y = ..density..), fill = "white",) +
  geom_density() +
  ggtitle("Daily Counts")

# boxplots
ggplot(hd, aes(x = Type, y = Count)) +
  #facet_wrap(~Type) +
  geom_boxplot() +
  ggtitle("Daily Counts")

ggplot(hd, aes(x = Day, y = Calories)) +
  facet_wrap(~Type) +
  geom_boxplot() +
  ggtitle("Daily Calories")

ggplot(hd, aes(x = Type, y = Sodium)) +
  facet_wrap(~Day, nr = 1) +
  geom_boxplot() +
  ggtitle("Daily Sodium")







# Create Data Set (For Instructor Only)
set.seed(23466)

hd <- read.csv("~/statlab_bb/old/Stat_Lab/R_BIOC_WS/Day3/hotdogdata.csv")
hd <- data.frame(Day = sample(c("Mon", "Tue", "Wed", "Thu", "Fri"), 
                              nrow(hd), replace = TRUE),
                 Brand = sample(c("OscarMayer", "Nathans"), 
                                nrow(hd), replace = TRUE),
                 hd)
# order the factor Day
hd$Day <- factor(hd$Day, levels = c("Mon", "Tue", "Wed", "Thu", "Fri"))

hd <- hd[with(hd, order(Day, Brand)), ]
rownames(hd) <- 1:nrow(hd)

write.csv(hd, "materials/day3/hotdog.csv", row.names = FALSE)
# Now open this in excel, modify it as desired, and save as xlsx file

################################################################################
# Begin Lesson

################################################################################
# Read IN an EXCEL file
myFile <- "hotdog.xlsx"
require(gdata)
hd <- read.xls(myFile)
# Challenge: Did the file read in correctly?
head(hd)
str(hd)
tail(hd)
# NO ---> Let's fix
rm(hd)
hd <- read.xls(myFile, pattern = "Day", sheet = "HotDog")
# Challenge: How about now?
head(hd)
str(hd)
tail(hd)
# NO ---> Let's fix
rm(hd)
hd <- read.xls(myURL, pattern = "Day", sheet = "HotDog", nrows = 54)
# Challenge: How about now?
head(hd)
str(hd)
tail(hd)
# Almost Done
# order the factor Day
str(hd)
levels(hd$Day)
hd$Day <- factor(hd$Day, levels = c("Mon", "Tue", "Wed", "Thu", "Fri"))
str(hd)
# Alternative
# Download the file
myURL <- "http://icj.github.io/R_Workshop/materials/day3/hotdog.xlsx"
hd <- read.xls(myURL, pattern = "Day", sheet = "HotDog", nrows = 54)

################################################################################
# Attach/Detach
plot(Calories)
attach(hd)
plot(Calories)
detach(hd)
plot(Calories)
plot(hd$Calories)

################################################################################
# Tables
attach(hd)
table(Day)
table(Day, Brand)
table(Day, Type)
table(Brand, Type)
table(Day, Type, Brand)
detach(hd)
# Challenge: Type these in and comment on what each line is doing
attach(hd)
hd.tab <- table(Day, Brand) # store table
hd.tab # view table
prop.table(hd.tab) # cell percentage
prop.table(hd.tab, 1) # row percentage
prop.table(hd.tab, 2) # col percentage
margin.table(hd.tab) # sum all cells
margin.table(hd.tab, 1) # sum across rows
margin.table(hd.tab, 2) # sum across columns
detach(hd)

################################################################################
# Summaries and Advanced Summaries
summary(hd)
plot(hd)
# install psych, Hmisc, and dplyr packages through RStudio
require(psych)
describe(hd)
pairs.panels(hd)
require(Hmisc)
describe(hd)
require(dplyr)
hd %.%
  group_by(Day) %.%
  summarise(n = length(Type),
            mean.cals = mean(Calories),
            sd.cals = sd(Calories),
            se.cals = sd.cals / sqrt(n),
            misc.stat = mean.cals / mean(Sodium))
# Challenge: Use dplyr to calculate the n, mean, sd, and se of hotdog
# sodium consumed by Brand
hd %.%
  group_by(Brand) %.%
  summarise(n = length(Type),
            mean.sod = mean(Sodium),
            sd.sod = sd(Sodium),
            se.sod = sd.sod / sqrt(n))
# Challenge: Now summarize sodium by Brand and Type
hd %.%
  group_by(Brand, Type) %.%
  summarise(n = length(Type),
            mean.sod = mean(Sodium),
            sd.sod = sd(Sodium),
            se.sod = sd.sod / sqrt(n))

################################################################################
# Histograms
hist(hd$Calories)
with(hd, hist(Calories))
with(hd, hist(Calories, breaks = 10))
with(hd, hist(Calories, freq = FALSE))
# Histogram with Density
with(hd, hist(Calories, freq = FALSE))
lines(density(hd$Calories), col = "red")
# Challenge: Plot separate histograms of beef, meat, and poultry calories
# hint: with(subset(hd, ), hist())
with(subset(hd, hd$Type == "Beef"), hist(Sodium))
hist(hd$Sodium[hd$Type == "Beef"])
with(hd[hd$Type == "Beef", ], hist(Sodium))
with(subset(hd, hd$Type == "Meat"), hist(Sodium))
with(subset(hd, hd$Type == "Poultry"), hist(Sodium))

################################################################################
# Boxplots
# 1 variable
boxplot(hd$Calories)
boxplot(hd$Calories, xlab = "Calories", main = "All Hot Dogs")
# by a factor
boxplot(Calories ~ Type, data = hd, main = "Calories by Type", 
        xlab = "Hot Dog Type", ylab = "Calories")
boxplot(Calories ~ Type, data = hd, main = "Calories by Type", 
        ylab = "Hot Dog Type", xlab = "Calories", 
        horizontal = TRUE)
# by 2 factors
boxplot(Calories ~ Brand * Type, data = hd, main = "Calories", 
        xlab = "Brand and Type")
# add color
boxplot(Calories ~ Brand * Type, data = hd, main = "Calories", 
        xlab = "Brand and Type", col = c("green", "red"))
# by data frame
boxplot(hd)
boxplot(hd[4:5])
# Challenge: Create a horizontal boxplot of Sodium by Type with the 
# Types differed by color (link to color page)
# Include a main title and x and y axes labels
boxplot(Sodium ~  Type, data = hd, horizontal = TRUE,
        main = "Sodium", xlab = "mg", ylab = "Hot Dog Type",
        col = c("burlywood", "cornflowerblue", "springgreen"))

################################################################################
# Stripcharts
# Sometimes if the sample size is small, stripcharts are better
with(hd, stripchart(Calories))
stripchart(Calories ~ Type, data = hd)
stripchart(Calories ~ Type * Brand, data = hd)
stripchart(Calories ~ Type * Brand, data = hd, method = "jitter", jitter = 0.1)
# Challenge: Create a stripchart of Calories separated by Brand
# Use method = "stack"; what does this do?
stripchart(Calories ~ Brand, data = hd, method = "stack")

################################################################################
# Barplots
# 1 variable
hd.tab <- table(hd$Type)
barplot(hd.tab)
barplot(hd.tab, horiz = TRUE)
# 2 variables Stacked
hd.tab <- table(hd$Type, hd$Day) # second var will be on x-axis
barplot(hd.tab)
barplot(hd.tab, col = c("burlywood", "cornflowerblue", "springgreen"))
legend("topleft", legend = levels(hd$Type), bty = "n",
       fill = c("burlywood", "cornflowerblue", "springgreen"))
# 2 variables Beside
hd.tab <- table(hd$Day, hd$Type)
barplot(hd.tab, beside = TRUE)
barplot(hd.tab, beside = TRUE, col = rainbow(5))
legend("topright", legend = levels(hd$Day), bty = "n", fill = rainbow(5))
# Challenge: Create a "Beside" barplot with Brand on the x-axis grouped 
# by Type. Experiment with adding color and a legend (hint: try heat.colors(3))
hd.tab <- table(hd$Type, hd$Brand)
barplot(hd.tab, beside = TRUE, col = heat.colors(3))
legend("topleft", legend = levels(hd$Type), bty = "n", fill = heat.colors(3))

################################################################################
# Scatterplot
plot(Calories ~ Sodium, data = hd)
abline(lm(Calories ~ Sodium, data = hd))

################################################################################
# Custom Plot
# Sometimes we need to make custom plots
# Let's make this plot
hotdog <- with(hd, data.frame(table(Day, Type)))
attach(hotdog)
plot(Freq[Type == "Beef"], type = "o", col = "red", ylim = c(0, 10), 
     axes = FALSE, ann = FALSE)
lines(Freq[Type == "Meat"], type = "o", col = "forestgreen", 
      pch = 22, lty = 2)
lines(Freq[Type == "Poultry"], type = "o", col = "blue", 
      pch = 23, lty = 3)
title(main = "Isaac's Weekly Hot Dog Consumption", 
      col.main = "Maroon", font.main = 4)
axis(1, at = 1:5, lab = levels(hotdog$Day))
title(xlab = "Days", col.lab = "steelblue", font.lab = 2)
axis(2, las = 1, at = seq(0, 10, 2))
title(ylab = "Devoured", col.lab = 3, font.lab = 2)
# Add legend and text
legend(x = 1, y = 10, 
       legend = levels(hotdog$Type),                  
       col = c("red", "forestgreen", "blue"),   
       pch = 21:23, lty = 1:3,                                   
       bty = "n", cex = 0.8                                      
)  
text(x = 3, y = 0.5, "SICK", col = "tomato4")
detach(hotdog)
# Challenge: Make this plot
# Hint
hd2 <- with(hd, data.frame(table(Day, Brand)))
attach(hd2)

plot(Freq[Brand == "Nathans"], type = "o", col = "red", ylim = c(0, 10), 
     axes = FALSE, ann = FALSE)
lines(Freq[Brand == "OscarMayer"], type = "o", col = "forestgreen", 
      pch = 22, lty = 2)
title(main = "Isaac Prefers Oscar Mayer Hot Dogs", 
      col.main = "RoyalBlue3", font.main = 4)
axis(1, at = 1:5, lab = levels(hd2$Day))
title(xlab = "Days", col.lab = "steelblue", font.lab = 2)
axis(2, las = 1, at = seq(0, 10, 2))
title(ylab = "Consumed", font.lab = 2)
# Add legend and text
legend(x = 1, y = 10, 
       legend = levels(hd2$Brand),                  
       col = c("red", "forestgreen"),   
       pch = 21:22, lty = 1:2,                                   
       bty = "n", cex = 0.8                                      
)  
text(x = 1, y = 4.65, "Fair", col = "purple4")
detach(hd2)

################################################################################
# Now with ggplot
require(ggplot2)
hotdog <- with(hd, data.frame(table(Day, Type)))
ggplot(hotdog, aes(x = Day, y = Freq, color = Type)) +
  geom_point(aes(shape = Type)) +
  geom_line(aes(group = Type, linetype = Type)) +
  geom_text(aes(x = 3, y = 0.5, label = "SICK"), color = "tomato4") +
  ggtitle("Isaac's Weekly Hot Dog Consumption") +
  xlab("Days") +
  ylab("Devoured")
#   theme(plot.title = element_text(color = "maroon", face = "italic"),
#         axis.title.x = element_text(color = "steelblue", face = "bold"),
#         axis.title.y = element_text(color = "green", face = "bold"))
# Challenge: make this ggplot
hd2 <- with(hd, data.frame(table(Day, Brand)))
ggplot(hd2, aes(x = Day, y = Freq, color = Brand)) +
  geom_point(aes(shape = Brand)) +
  geom_line(aes(group = Brand, linetype = Brand)) +
  geom_text(aes(x = 1, y = 4.65, label = "Fair"), color = "purple4") +
  ggtitle("Isaac Prefers Oscar Mayer Hot Dogs") +
  xlab("Days") +
  ylab("Consumed")
#   theme(plot.title = element_text(color = "royalblue3", face = "italic"),
#         axis.title.x = element_text(color = "steelblue", face = "bold"),
#         axis.title.y = element_text(face = "bold"))

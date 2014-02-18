Getting Data In and Summarizing
========================================================
author: Isaac Jenkins
date: February 20, 2014




Workshop Objectives
========================================================
- Start an RStudio Project
- Read an Excel file into R
- Summarize the data **numerically**
- Summarize the data **graphically**
- Explore the **```ggplot2```** package

Create an RStudio Project
========================================================
- [RStudio Projects](http://www.rstudio.com/ide/docs/using/projects) are handy!
- Let's make one for today's workshop
![Alt text](http://www.rstudio.com/images/docs/projects_new.png)

The Magical Working Directory
========================================================

```r
getwd()
```



```
[1] "/Users/isaac/r_ws_day3"
```


![Alt text](http://icj.github.io/R_Workshop/materials/day3/getwd.png)

How do we get this into R?
========================================================
![Alt text](http://icj.github.io/R_Workshop/materials/day3/excel.png)

Download the File
========================================================
- Get it **[here](http://icj.github.io/R_Workshop/materials/day3/hotdog.xlsx)**
- Copy it to your working directory using R (assuming file is in default 
Downloads folder)

```r
# On a MAC (or Linux)
file.copy(from = "~/Downloads/hotdog.xlsx", to = getwd())
# On Windows (change USERNAME and/or drive)
file.copy(from = "C:/Users/USERNAME/Downloads/hotdog.xlsx", to = getwd())
```

- Or, copy it using your preferred method (e.g., file explorer, Terminal, 
Finder)

Get the Right R Package
========================================================
- Install the **```gdata```** package
- We need the **```read.xls()```** function
- Use the RStudio **Packages** pane
- Or, try

```r
install.packages("gdata")
```


Import the Data
========================================================

```r
# Read IN an EXCEL file
myFile <- "hotdog.xlsx"
require(gdata)
hd <- read.xls(myFile)
```


Challenge 1
========================================================
type: prompt
1. Open the file **```hotdog.xlsx```** in Excel (or Libre Office, or Google 
Drive).
2. Use ```head(hd)```, ```str(hd)```, and ```tail(hd)``` to see
if the data read in correctly.
3. What are some of the problems?

Challenge 1 Solutions
========================================================
type: prompt

```r
head(hd)
```

```
  Isaac.s.Daily.Hot.Dog.Consumption       X     X.1      X.2    X.3
1                               Day   Brand    Type Calories Sodium
2                               Mon Nathans    Meat      175    507
3                               Mon Nathans Poultry      129    430
4                               Mon Nathans Poultry      102    542
5                               Mon Nathans Poultry      135    426
6                               Mon Nathans Poultry      142    513
```


Challenge 1 Solutions
========================================================
type: prompt

```r
str(hd)
```

```
'data.frame':	57 obs. of  5 variables:
 $ Isaac.s.Daily.Hot.Dog.Consumption: Factor w/ 7 levels "","Day","Fri",..: 2 4 4 4 4 4 4 4 4 4 ...
 $ X                                : Factor w/ 4 levels "","Brand","Nathans",..: 2 3 3 3 3 3 4 4 4 4 ...
 $ X.1                              : Factor w/ 6 levels "Beef","Mean",..: 6 3 4 4 4 4 1 1 1 3 ...
 $ X.2                              : Factor w/ 44 levels "102","106","107",..: 44 29 6 1 9 15 36 24 8 28 ...
 $ X.3                              : Factor w/ 50 levels "144","253","298",..: 50 38 28 43 26 40 46 22 2 30 ...
```


Challenge 1 Solutions
========================================================
type: prompt

```r
tail(hd)
```

```
   Isaac.s.Daily.Hot.Dog.Consumption          X   X.1                 X.2
52                               Fri OscarMayer  Beef                 157
53                               Fri OscarMayer  Beef                 131
54                               Fri OscarMayer  Meat                 190
55                               Fri OscarMayer  Meat                 107
56                                               Mean 145.444444444444457
57                                              StDev  29.383390679068008
                   X.3
52                 440
53                 317
54                 545
55                 144
56 424.833333333333314
57  95.856368574166297
```


Challenge 1 Solutions
========================================================
type: prompt
Problems

1. All columns read in as factors 
  - no numeric data
2. Calculations at bottom of data are read in
  - too many rows

Import the Data - Second Try
========================================================

```r
# Read IN an EXCEL file
hd <- read.xls(myFile, sheet = "HotDog", pattern = "Day", nrows = 54)
```

- **```sheet=```**
  - Tells it which sheet to read from
- **```pattern=```**
  - Tells it which row to start reading from
- **```nrows=```**
  - Tells it how many rows to read in 

Challenge 2
========================================================
type: prompt
1. Confirm that the data was read in correctly.
2. Any other concerns?

Challenge 2 Solution
========================================================
type: prompt

```r
str(hd)
```

```
'data.frame':	54 obs. of  5 variables:
 $ Day     : Factor w/ 5 levels "Fri","Mon","Thu",..: 2 2 2 2 2 2 2 2 2 2 ...
 $ Brand   : Factor w/ 2 levels "Nathans","OscarMayer": 1 1 1 1 1 2 2 2 2 2 ...
 $ Type    : Factor w/ 3 levels "Beef","Meat",..: 2 3 3 3 3 1 1 1 2 3 ...
 $ Calories: int  175 129 102 135 142 190 153 132 173 152 ...
 $ Sodium  : int  507 430 542 426 513 587 401 253 458 588 ...
```

```r
levels(hd$Day)
```

```
[1] "Fri" "Mon" "Thu" "Tue" "Wed"
```


Fix Day Factor
========================================================
Want the factor **```Day```** to be in meaninful order.

```r
levels(hd$Day)
```

```
[1] "Fri" "Mon" "Thu" "Tue" "Wed"
```

```r
hd$Day <- factor(hd$Day, levels = c("Mon", "Tue", "Wed", "Thu", "Fri"))
levels(hd$Day)
```

```
[1] "Mon" "Tue" "Wed" "Thu" "Fri"
```


Band-Aid
========================================================
If you could NOT download the file, RUN this now

```r
myURL <- "http://icj.github.io/R_Workshop/materials/day3/hotdog.xlsx"
hd <- read.xls(myURL, pattern = "Day", sheet = "HotDog", nrows = 54)
hd$Day <- factor(hd$Day, levels = c("Mon", "Tue", "Wed", "Thu", "Fri"))
```


Summarizing Frequencies - 1 & 2 Factors
========================================================
The **```table()```** function builds a contingency table of counts for 
combinations of factor levels.

```r
table(hd$Day)
```

```

Mon Tue Wed Thu Fri 
 10  10   8  11  15 
```

```r
table(hd$Brand, hd$Day)
```

```
            
             Mon Tue Wed Thu Fri
  Nathans      5   2   2   4   5
  OscarMayer   5   8   6   7  10
```


Summarizing Frequencies - 3 Factors
========================================================

```r
table(hd$Type, hd$Day, hd$Brand)
```

```
, ,  = Nathans

         
          Mon Tue Wed Thu Fri
  Beef      0   0   0   1   1
  Meat      1   1   0   2   2
  Poultry   4   1   2   1   2

, ,  = OscarMayer

         
          Mon Tue Wed Thu Fri
  Beef      3   2   3   2   8
  Meat      1   3   1   4   2
  Poultry   1   3   2   1   0
```


Challenge 3
========================================================
type: prompt
Run the following commands and comment on what they are doing.

```r
hd.tab <- table(hd$Day, hd$Brand) # This stores the table
hd.tab # This prints the table
prop.table(hd.tab) # This ...
prop.table(hd.tab, 1) # This ...
prop.table(hd.tab, 2) # This ...
margin.table(hd.tab) # This ...
margin.table(hd.tab, 1) # This ...
margin.table(hd.tab, 2) # This ...
```


Challenge 3 Solutions
========================================================
type: prompt

```r
hd.tab <- table(hd$Day, hd$Brand) # This stores the table
hd.tab # This prints the table
prop.table(hd.tab) # cell percentages
prop.table(hd.tab, 1) # row percentages
prop.table(hd.tab, 2) # column percentages
margin.table(hd.tab) # sum all cells
margin.table(hd.tab, 1) # sum across rows
margin.table(hd.tab, 2) # sum across columns
```


Summarize with Basic Functions
========================================================

```r
summary(hd)
```

```
  Day            Brand         Type       Calories       Sodium   
 Mon:10   Nathans   :18   Beef   :20   Min.   : 86   Min.   :144  
 Tue:10   OscarMayer:36   Meat   :17   1st Qu.:132   1st Qu.:362  
 Wed: 8                   Poultry:17   Median :145   Median :405  
 Thu:11                                Mean   :145   Mean   :425  
 Fri:15                                3rd Qu.:173   3rd Qu.:504  
                                       Max.   :195   Max.   :645  
```

```r
plot(hd)
```

<img src="day3_slides-figure/summ_base.png" title="plot of chunk summ_base" alt="plot of chunk summ_base" style="display: block; margin: auto;" />


Summarize with psych
========================================================

```r
require(psych)
describe(hd)
```

```
         var  n   mean    sd median trimmed    mad min max range  skew
Day*       1 54   3.20  1.50      3    3.25   1.48   1   5     4 -0.18
Brand*     2 54   1.67  0.48      2    1.70   0.00   1   2     1 -0.69
Type*      3 54   1.94  0.83      2    1.93   1.48   1   3     2  0.10
Calories   4 54 145.44 29.38    145  146.14  22.24  86 195   109 -0.16
Sodium     5 54 424.83 95.86    405  424.61 108.23 144 645   501 -0.10
         kurtosis    se
Day*        -1.46  0.20
Brand*      -1.56  0.06
Type*       -1.58  0.11
Calories    -0.82  4.00
Sodium       0.03 13.04
```


Summarize with psych
========================================================

```r
pairs.panels(hd)
```

<img src="day3_slides-figure/summ_psych2.png" title="plot of chunk summ_psych2" alt="plot of chunk summ_psych2" style="display: block; margin: auto;" />


Summarize with Hmisc
========================================================

```r
# Install package if needed
install.packages("Hmisc")
```


```r
require(Hmisc)
describe(hd)
```

```
hd 

 5  Variables      54  Observations
---------------------------------------------------------------------------
Day 
      n missing  unique 
     54       0       5 

          Mon Tue Wed Thu Fri
Frequency  10  10   8  11  15
%          19  19  15  20  28
---------------------------------------------------------------------------
Brand 
      n missing  unique 
     54       0       2 

Nathans (18, 33%), OscarMayer (36, 67%) 
---------------------------------------------------------------------------
Type 
      n missing  unique 
     54       0       3 

Beef (20, 37%), Meat (17, 31%), Poultry (17, 31%) 
---------------------------------------------------------------------------
Calories 
      n missing  unique    Mean     .05     .10     .25     .50     .75 
     54       0      41   145.4   97.25  103.20  132.00  145.00  172.75 
    .90     .95 
 185.40  190.00 

lowest :  86  87  94  99 102, highest: 184 186 190 191 195 
---------------------------------------------------------------------------
Sodium 
      n missing  unique    Mean     .05     .10     .25     .50     .75 
     54       0      47   424.8   299.3   319.9   362.5   405.0   503.5 
    .90     .95 
  544.1   583.1 

lowest : 144 253 298 300 317, highest: 545 581 587 588 645 
---------------------------------------------------------------------------
```


Summarize with dplyr
========================================================

```r
# Install package if needed
install.packages("dplyr")
```


```r
require(dplyr)
hd %.%
  group_by(Day) %.%
  summarise(n = length(Type),
            mean.cals = mean(Calories),
            sd.cals = sd(Calories),
            se.cals = sd.cals / sqrt(n),
            misc.stat = mean.cals / mean(Sodium))
```

```
Source: local data frame [5 x 6]

  Day  n mean.cals sd.cals se.cals misc.stat
1 Fri 15     147.3   30.37   7.842    0.3725
2 Thu 11     141.9   29.13   8.784    0.3771
3 Wed  8     147.5   36.78  13.003    0.3061
4 Tue 10     142.0   30.49   9.642    0.3296
5 Mon 10     148.3   26.03   8.230    0.3152
```

See an excellent ```dplyr``` tutorial
[here](http://cran.r-project.org/web/packages/dplyr/vignettes/introduction.html)

Challenge 4
========================================================
type: prompt
Use **```dplyr```** to summarize the n, mean, standard deviation and standard 
error of hot dog sodium by **Brand**

**Bonus:** Summarize by **Brand** and **Type**

Challenge 4 Solution
========================================================
type: prompt

```r
hd %.%
  group_by(Brand) %.%
  summarise(n = length(Type),
            mean.sod = mean(Sodium),
            sd.sod = sd(Sodium),
            se.sod = sd.sod / sqrt(n))
```

```
Source: local data frame [2 x 5]

       Brand  n mean.sod sd.sod se.sod
1 OscarMayer 36    430.4 106.30  17.72
2    Nathans 18    413.8  72.04  16.98
```


Challenge 4 Bonus Solution
========================================================
type: prompt

```r
hd %.%
  group_by(Brand, Type) %.%
  summarise(n = length(Type),
            mean.sod = mean(Sodium),
            sd.sod = sd(Sodium),
            se.sod = sd.sod / sqrt(n))
```

```
Source: local data frame [6 x 6]
Groups: Brand

       Brand    Type  n mean.sod sd.sod se.sod
1    Nathans    Beef  2    311.0  15.56  11.00
2 OscarMayer Poultry  7    497.3  93.99  35.53
3 OscarMayer    Meat 11    419.2 110.47  33.31
4 OscarMayer    Beef 18    411.2 103.20  24.33
5    Nathans Poultry 10    432.2  70.27  22.22
6    Nathans    Meat  6    417.3  61.55  25.13
```



Histograms
========================================================

```r
hist(hd$Calories)
```

<img src="day3_slides-figure/base_hist11.png" title="plot of chunk base_hist1" alt="plot of chunk base_hist1" style="display: block; margin: auto;" />

```r
with(hd, hist(Calories))
```

<img src="day3_slides-figure/base_hist12.png" title="plot of chunk base_hist1" alt="plot of chunk base_hist1" style="display: block; margin: auto;" />


***


```r
with(hd, hist(Calories, breaks = 10))
```

<img src="day3_slides-figure/base_hist21.png" title="plot of chunk base_hist2" alt="plot of chunk base_hist2" style="display: block; margin: auto;" />

```r
with(hd, hist(Calories, freq = FALSE))
```

<img src="day3_slides-figure/base_hist22.png" title="plot of chunk base_hist2" alt="plot of chunk base_hist2" style="display: block; margin: auto;" />


Histogram with Density
========================================================

```r
with(hd, hist(Calories, freq = FALSE))
lines(density(hd$Calories), col = "red")
```

<img src="day3_slides-figure/base_hist_density.png" title="plot of chunk base_hist_density" alt="plot of chunk base_hist_density" style="display: block; margin: auto;" />


Challenge 5
========================================================
type: prompt
Plot separate histograms for beef, meat, and poultry sodium

Challenge 5 Solutions
========================================================
type: prompt

```r
with(subset(hd, hd$Type == "Beef"), hist(Sodium, main = "Beef"))
hist(hd$Sodium[hd$Type == "Beef"], main = "Beef")
with(hd[hd$Type == "Beef", ], hist(Sodium, main = "Beef"))
```

<img src="day3_slides-figure/ch5_sol2.png" title="plot of chunk ch5_sol2" alt="plot of chunk ch5_sol2" style="display: block; margin: auto;" />



```r
with(subset(hd, hd$Type == "Meat"), hist(Sodium, main = "Meat"))
with(subset(hd, hd$Type == "Poultry"), hist(Sodium, main = "Poultry"))
```

<img src="day3_slides-figure/ch5_sol4.png" title="plot of chunk ch5_sol4" alt="plot of chunk ch5_sol4" style="display: block; margin: auto;" />


Boxplots - Single Vector
========================================================

```r
# Specifying a vector
boxplot(hd$Calories)
```

<img src="day3_slides-figure/base_box1.png" title="plot of chunk base_box1" alt="plot of chunk base_box1" style="display: block; margin: auto;" />


***


```r
boxplot(hd$Calories, xlab = "Calories", main = "All Hot Dogs")
```

<img src="day3_slides-figure/base_box2.png" title="plot of chunk base_box2" alt="plot of chunk base_box2" style="display: block; margin: auto;" />


Boxplots - Continuous Variable and a Factor
========================================================

```r
boxplot(Calories ~ Type, data = hd, main = "Calories by Type", 
        xlab = "Hot Dog Type", ylab = "Calories")
```

<img src="day3_slides-figure/box_2v1.png" title="plot of chunk box_2v1" alt="plot of chunk box_2v1" style="display: block; margin: auto;" />


Boxplots - Continuous Variable and a Factor
========================================================
Horizontal version

```r
boxplot(Calories ~ Type, data = hd, main = "Calories by Type", 
        ylab = "Hot Dog Type", xlab = "Calories", 
        horizontal = TRUE)
```

<img src="day3_slides-figure/box_2v2.png" title="plot of chunk box_2v2" alt="plot of chunk box_2v2" style="display: block; margin: auto;" />


Boxplots - Continuous Variable and 2 Factors
========================================================

```r
boxplot(Calories ~ Brand * Type, data = hd, main = "Calories", 
        xlab = "Brand and Type")
```

<img src="day3_slides-figure/box_2v3.png" title="plot of chunk box_2v3" alt="plot of chunk box_2v3" style="display: block; margin: auto;" />


Boxplots - Continuous Variable and 2 Factors
========================================================
Add some color

```r
boxplot(Calories ~ Brand * Type, data = hd, main = "Calories", 
        xlab = "Brand and Type", col = c("green", "red"))
```

<img src="day3_slides-figure/box_2v4.png" title="plot of chunk box_2v4" alt="plot of chunk box_2v4" style="display: block; margin: auto;" />


Boxplots - Data Frames
========================================================

```r
boxplot(hd)
```

<img src="day3_slides-figure/box_2v5.png" title="plot of chunk box_2v5" alt="plot of chunk box_2v5" style="display: block; margin: auto;" />


***


```r
boxplot(hd[4:5])
```

<img src="day3_slides-figure/box_2v6.png" title="plot of chunk box_2v6" alt="plot of chunk box_2v6" style="display: block; margin: auto;" />


Challenge 6
========================================================
type: prompt
Create a horizontal boxplot of Sodium by Type. Differ the hot dog types by 
color and include a main title and custom x and y axes labels.

More colors available 
[here](http://sape.inf.usi.ch/quick-reference/ggplot2/colour)

Challenge 6 Solution
========================================================
type: prompt


```r
boxplot(Sodium ~  Type, data = hd, horizontal = TRUE,
        main = "Sodium", xlab = "mg", ylab = "Hot Dog Type",
        col = c("burlywood", "cornflowerblue", "springgreen"))
```

<img src="day3_slides-figure/ch6_sol.png" title="plot of chunk ch6_sol" alt="plot of chunk ch6_sol" style="display: block; margin: auto;" />


Stripchart
========================================================


Let's Make this Plot
========================================================





```
Error in plot(hotdog$Beef, type = "o", col = "red", ylim = c(0, 20), axes = FALSE,  : 
  object 'hotdog' not found
```

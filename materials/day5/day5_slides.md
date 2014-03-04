Intro to Bioconductor
========================================================
author: Isaac Jenkins
date: March 6, 2014

With material borrowed from B. Wolf, S. Falcon, M. Morgan, R. Gentleman and C. Wong (Thank you!)




Objectives
========================================================
- Learn what Bioconductor is
- Navigate the [Bioconductor website](http://www.bioconductor.org/)
- Install Bioconductor and its packages
- Create an ***ExpressionSet*** object

About Bioconductor
========================================================
> Bioconductor is an open source, open development software project
to provide tools for the analysis and comprehension of 
high-throughput genomic data. It is based primarily on the R
programming language.

*Source*: [Bioconductor](http://www.bioconductor.org/about/)


Navigate the Bioconductor Website
========================================================
Head over to:

[![Alt text](http://upload.wikimedia.org/wikipedia/en/f/f5/BioClogo.gif)](http://www.bioconductor.org/)

Installing Bioconductor
========================================================
- Bioconductor packages are run using R
- First we must install the core Bioconductor packages


```r
source("http://bioconductor.org/biocLite.R")
biocLite()
```


- This installs the Bioconductor packages Biobase, IRanges and 
AnnotationDbi (as well as some dependencies)
- Refresh your package list in RStudio

Installing Bioconductor Packages
========================================================
- Functionality is similar to R packages, but installation is 
different
- **CANNOT** use the Install Packages button in RStudio
- **CANNOT** use the R function ```install.packages()```
- Instead, use the ```biocLite()``` function in the 
**BiocInstaller** package

Installing Bioconductor Packages
========================================================
- Installing Bioconductor packages requires **2 steps**
  1. Load the installer package
  2. Install the desired package
- Let's install the Bioconductor package [```affy```](http://www.bioconductor.org/packages/release/bioc/html/affy.html)


```r
require(BiocInstaller) # load the installer package
biocLite("affy") # install the affy package
```


- Note that step 1 only has to be done once during the current 
R session

Help for Bioconductor Packages
========================================================
- Similar to R, there are help files for all Bioconductor functions


```r
require(affy) # load the affy package
?expresso
```


- In general, there are exceptionally useful Vignettes


```r
browseVignettes("affy") # opens in web browser
```


A Note about Class Systems
========================================================
- R and Bioconductor packages are loaded and used similarly
- R contains an *S3* and *S4* class system
- R packages typically use the S3 system
- Bioconductor packages typically use the S4 system
- S4 is based on object-oriented programming, which is more 
formal and rigourous
- [More details on S4](http://cran.r-project.org/doc/contrib/Genolini-S4tutorialV0-5en.pdf)

Example: ExpressionSet Object
========================================================
- The **Biobase** package contains standardized data structures 
(or classes)
- The idea is to combine multiple sources of information into one 
convenient structure
- The *ExpressionSet* class is a common example of these 
structures
- It is the input and output of many Bioconductor functions

ExpressionSet Components
========================================================
- **assayData**: expression data from microarray experiments
- **phenoData**: metadata describing the experiment's samples
- **featureData**: metadata about the features in the experiment
- **annotation**: the platform on which the samples were assayed
- **experimentData**: a flexible structure for describing the 
experiment

ExpressionSet from a .CEL file
========================================================
- One may have an output file from a microarray chip manufacturer
- Possible strategy is to use a bioconductor package 
(e.g., affy or limma) to read in the data as an *ExpressionSet*
or other type of object
- It is sometimes possible to convert other types of Bioconductor objects into *ExpressionSets* using the 
[```convert```](http://www.bioconductor.org/packages/release/bioc/html/convert.html) 
package

```r
biocLite("convert")
require(convert)
as(myObject, "ExpressionSet")
```

- When none of this works...

Build an ExpressionSet from Scratch
========================================================
- It's likely that your experiment's data resides in conceptually distinct parts:
  - assay data
  - phenotypic meta-data
  - feature annontation
  - experiment data
- We can load these parts individually and merge them into an
*ExpressionSet* object ... sort of like Voltron.

![Alt text](http://upload.wikimedia.org/wikipedia/en/b/b0/Voltron_boxart.jpg)

Possible Scenario
========================================================
- You identify a Bioconductor package that is perfect for your 
analysis (e.g., 
[```ChromHeatMap```](http://www.bioconductor.org/packages/release/bioc/html/ChromHeatMap.html))
- The package takes an *ExpressionSet* object as input
- Your data is stored in an excel spreadsheet or .csv file

**What do you do?** ... Build an *ExpressionSet* object.

Gather the Data
========================================================
1. Create a new RStudio project
2. If data is in an Excel file, export to csv 
(I've already done this)
3. Put the csv files in your working directory
  - Get the files and move them your preferred way: 
  [file1](http://icj.github.io/R_Workshop/materials/day5/expression.csv) and 
  [file2](http://icj.github.io/R_Workshop/materials/day5/phenotype.csv)
  - Or, run this:
  

```r
myURL <- "http://icj.github.io/R_Workshop/materials/day5/"
download.file(paste0(myURL, "expression.csv"), "expression.csv")
download.file(paste0(myURL, "phenotype.csv"), "phenotype.csv")
```


Load Assay/Expression Data
========================================================
Use ```read.csv()``` to load the expression data


```r
express <- read.csv("expression.csv", 
                    stringsAsFactors = FALSE,
                    row.names = 1)
```


We want this to be a ```matrix```


```r
express <- as.matrix(express)
```


Check Assay/Expression Data
========================================================

```r
class(express)
```

```
[1] "matrix"
```

```r
mode(express)
```

```
[1] "numeric"
```

```r
typeof(express)
```

```
[1] "double"
```

```r
dim(express)
```

```
[1] 500  26
```


***


```r
head(colnames(express))
```

```
[1] "A" "B" "C" "D" "E" "F"
```

```r
head(rownames(express))
```

```
[1] "AFFX-MurIL2_at"  "AFFX-MurIL10_at" "AFFX-MurIL4_at"  "AFFX-MurFAS_at" 
[5] "AFFX-BioB-5_at"  "AFFX-BioB-M_at" 
```

```r
express[1:3, 1:2]
```

```
                     A       B
AFFX-MurIL2_at  192.74  85.753
AFFX-MurIL10_at  97.14 126.196
AFFX-MurIL4_at   45.82   8.831
```


We could stop here...
========================================================
A minimal *ExpressionSet* object has only the expression data


```r
require(Biobase)
minimalSet <- ExpressionSet(assayData = express)
minimalSet
```

```
ExpressionSet (storageMode: lockedEnvironment)
assayData: 500 features, 26 samples 
  element names: exprs 
protocolData: none
phenoData: none
featureData: none
experimentData: use 'experimentData(object)'
Annotation:  
```


But we won't.

Load Phenotypic Data
========================================================
Use ```read.csv()``` to load the phenotype data


```r
pheno <- read.csv("phenotype.csv", 
                  colClasses = c("character", rep("factor", 2),
                                 "numeric"),
                  skip = 4)
```


Check Phenotypic Data
========================================================

```r
head(pheno)
```

```
  id gender    type score
1  A Female Control  0.75
2  B   Male    Case  0.40
3  C   Male Control  0.73
4  D   Male    Case  0.42
5  E Female    Case  0.93
6  F   Male Control  0.22
```

```r
str(pheno)
```

```
'data.frame':	26 obs. of  4 variables:
 $ id    : chr  "A" "B" "C" "D" ...
 $ gender: Factor w/ 2 levels "Female","Male": 1 2 2 2 1 2 2 2 1 2 ...
 $ type  : Factor w/ 2 levels "Case","Control": 2 1 2 1 1 2 1 1 1 2 ...
 $ score : num  0.75 0.4 0.73 0.42 0.93 0.22 0.96 0.79 0.37 0.63 ...
```

```r
summary(pheno)
```

```
      id               gender        type        score      
 Length:26          Female:11   Case   :15   Min.   :0.100  
 Class :character   Male  :15   Control:11   1st Qu.:0.328  
 Mode  :character                            Median :0.415  
                                             Mean   :0.537  
                                             3rd Qu.:0.765  
                                             Max.   :0.980  
```


Summarize Phenotypic Data
========================================================

```r
summary(pheno)
```

```
      id               gender        type        score      
 Length:26          Female:11   Case   :15   Min.   :0.100  
 Class :character   Male  :15   Control:11   1st Qu.:0.328  
 Mode  :character                            Median :0.415  
                                             Mean   :0.537  
                                             3rd Qu.:0.765  
                                             Max.   :0.980  
```


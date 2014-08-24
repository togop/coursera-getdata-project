## Getting and Cleaning Data - Course Project
=============================================

This is my repo for the [Getting and Cleaning Data course on Coursera](https://www.coursera.org/course/getdata) Course Project.

Source dataset https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.

Files:

* run_analysis.R that does the following:
 - 1. Merges the training and the test sets to create one data set.
 - 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
 - 3. Uses descriptive activity names to name the activities in the data set
 - 4. Appropriately labels the data set with descriptive variable names. 
 - 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

* CodeBook.md A code book for the project

##  Running
```{r}
require(reshape2)
source("run_analysis.R")
```

Tested on the following platform
```R
> version
               _                           
platform       x86_64-apple-darwin10.8.0   
arch           x86_64                      
os             darwin10.8.0                
system         x86_64, darwin10.8.0        
status                                     
major          3                           
minor          1.0                         
year           2014                        
month          04                          
day            10                          
svn rev        65387                       
language       R                           
version.string R version 3.1.0 (2014-04-10)
nickname       Spring Dance     
```
 

```bash
$ Rscript run_analysis.R
```


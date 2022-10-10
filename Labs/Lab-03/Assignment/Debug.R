
dat <- read_csv("/Users/berkankutuk/Documents/5.Semester/SE05-DV/Lab-03/Assignment/DataExerciseShinyApps.csv")
dat <- dat %>% select(c("pid7","ideo5"))

table(dat['pid7'])

table(dat['ideo5'])



import csv
from datetime import datetime

file = 'release_dates.csv'

with open(file, newline='') as f:
    reader = csv.reader(f)
    data = list(reader)

data_name = data.pop(0)

listSize = 0

#Formats to change
format1 = '%b %d, %Y' #"Nov 01, 2015"
format2 = "%b %Y" #"Jun 2020"
format3 = "%B %Y" #"April 2020" 
format4 = "%Y" #"2020"

#Correct format (Change output format here)
correct_format = "%Y-%m-%d"


format_match = 0

formated_dates = []

for x in data:
    datetime_object = "NA"
    match = False
    if(x[0] == "NA"):
        format_match = format_match + 1
        formated_dates.append(["NA"])
        match = True
        continue

    try:
        datetime_object = datetime.strptime(x[0], format1)
        format_match = format_match + 1
        match = True
        formated_dates.append([datetime_object.strftime(correct_format)])
        continue
    except:
        pass

    try:
        datetime_object = datetime.strptime(x[0], format2)
        format_match = format_match + 1
        match = True
        formated_dates.append([datetime_object.strftime(correct_format)])
        continue
    except:
        pass

    try:
        datetime_object = datetime.strptime(x[0], format3)
        format_match = format_match + 1
        match = True
        formated_dates.append([datetime_object.strftime(correct_format)])
        continue
    except:
        pass

    try:
        datetime_object = datetime.strptime(x[0], format4)
        format_match = format_match + 1
        match = True
        formated_dates.append([datetime_object.strftime(correct_format)])
        continue
    except:
        pass

    if(not match):
        print("format not matching for " + x[0])
    

print(formated_dates)    
print("All data has been moved: " + str(len(data) == len(formated_dates)))

with open('formatted_dates.csv', 'w+') as f:
    write = csv.writer(f)
    write.writerow(data_name)
    write.writerows(formated_dates)


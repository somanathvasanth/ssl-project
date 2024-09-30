import numpy as np  # Importing the numpy library for numerical operations
import sys  # Importing the sys module for system-specific parameters and functions

file = sys.argv[1]  # Getting the filename from command line arguments
# exam = sys.argv[2]  # Getting the exam name from command line arguments

x = open(file, "r")  # Opening the file in read mode
y = x.read()  # Reading the contents of the file
y = y.replace(",", " ")  # Replacing commas with spaces in the content
y = y.split()  # Splitting the content into a list of words

rollnumber=[]
name=[]
marks=[]

# Parsing the content to extract roll numbers, names, and marks
for x in range(int(len(y)/3)-1):
    rollnumber.append(y[3*x+3])
    name.append(y[3*x+3+1])
    marks.append(float(y[3*x+3+2]))

# Converting marks list to numpy array for numerical operations
marks = np.array(marks)

# Calculating the mean of the marks
mean = np.mean(marks)

# Total number of students
total_students = len(marks)

# Initializing lists to store indices of good and bad performing students
good = []
bad = []

# Determining good and bad performing students based on mean marks
#here according to my logic a student whose marks are greater than or equal to the mean is considered as good student and thosde with less than mean marks are considered as bad student.
for aaa in range(total_students):
    if marks[aaa] >= mean:
        good.append(aaa)
    if marks[aaa] < mean:
        bad.append(aaa)

# Initializing lists to store names and roll numbers of good and bad performing students
goodstudentsname = []
goodstudentsrollnumber = []
badstudentsname = []
badstudentsrollnumber = []

# Populating lists with names and roll numbers of good and bad performing students
for ggg in good:
    goodstudentsname.append(name[ggg])
    goodstudentsrollnumber.append(rollnumber[ggg])

for bbb in bad:
    badstudentsname.append(name[bbb])
    badstudentsrollnumber.append(rollnumber[bbb])

# Printing the list of good performing students
print("******************")
print("students who are performing well are:")
for x in range(len(good)):
    print(goodstudentsname[x] + "(" + goodstudentsrollnumber[x] + ")")

# Printing the list of bad performing students
print("students who need to improve:")
for x in range(len(bad)):
    print(badstudentsname[x] + "(" + badstudentsrollnumber[x] + ")")
print("******************")

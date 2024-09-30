import numpy as np  # Importing the numpy library for numerical operations
import sys  # Importing the sys module for system-specific parameters and functions

file = sys.argv[1]  # Getting the filename from command line arguments
exam = sys.argv[2]  # Getting the exam name from command line arguments

x = open(file, "r")  # Opening the file in read mode
y = x.read()  # Reading the contents of the file
y = y.replace(",", " ")  # Replacing commas with spaces in the content
y = y.split()  # Splitting the content into a list of words

arr = []  # Initializing an empty list to store student marks

# Looping through the total number of students to extract marks for the specified exam
for x in range(int((len(y) / 3) - 1)):
    arr.append(int(y[5 + x * 3]))  # Extracting student marks for the specified exam

marks = np.array(arr)  # Converting the list of student marks to a numpy array
mean = np.mean(marks)  # Calculating the mean of student marks
median = np.median(marks)  # Calculating the median of student marks
stdev = np.std(marks)  # Calculating the standard deviation of student marks
highestmarks = np.max(marks)  # Finding the highest mark among students
lowestmarks = np.min(marks)  # Finding the lowest mark among students

print("*************")  # Printing a separator
print("exam name :", exam)  # Printing the exam name
print("mean ", mean, sep=":")  # Printing the mean mark
print("median ", median, sep=":")  # Printing the median mark
print("standard deviation ", stdev, sep=":")  # Printing the standard deviation
print("highest mark ", highestmarks, sep=":")  # Printing the highest mark
print("least mark ", lowestmarks, sep=":")  # Printing the lowest mark
print("*************")  # Printing a separator

import numpy as np
import matplotlib.pyplot as plt
import sys
file=sys.argv[1]
x=open(file,"r")
y=x.read()
y=y.replace(","," ")
y=y.split()
students=[]
marks=[]

for p in range(int((len(y) / 3) - 1)):
    students.append(y[3+p*3])
    marks.append(y[5+p*3])


students=np.array(students)
marks=np.array(marks)
marks=marks.astype(float)
mean_marks = np.mean(marks)
median_marks = np.median(marks)
plt.bar(students, marks,width=0.2, color='skyblue' )
plt.axhline(mean_marks, color='orange', linestyle='--', label='Mean Marks')
plt.axhline(median_marks, color='green', linestyle='--', label='Median')
plt.xlabel("Students")
plt.ylabel("Marks")
plt.title("Bar graph of exam asked")
plt.xticks(rotation=90)  # Rotate x-axis labels for better readability
plt.legend()
plt.show()



        
        
        



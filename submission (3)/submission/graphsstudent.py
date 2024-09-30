import numpy as np
import matplotlib.pyplot as plt
import sys
pr="f"
student=sys.argv[1]
total=sys.argv[2]
x=open("main.csv","r")
y=x.read()
y=y.replace(","," ")
y=y.split()
exams=[]
marks=[]
for p in range(int(total)):
    exams.append(y[2+p])
   
mean_marks=[]
for exam in exams:
    file=exam+".csv"
    m = open(file, "r")
    n = m.read()
    n = n.replace(",", " ")
    n = n.split()
    arr = []
    for x in range(int((len(n) / 3) - 1)):
       
        arr.append(int(n[5 + x * 3]))
       
       
    Marks = np.array(arr)
    mean = np.mean(Marks)
    mean_marks.append(mean)
for z in range(len(y)):
    if (student == y[z]):
        for w in range(int(total)):
            pr="t"
            if (y[z+w+2]== "a"):
                marks.append(0)
            if (y[z+w+2]!= "a"):
                marks.append(y[z+w+2])
if pr=="f":
    print("ERROR:there is no such student")
    sys.exit()  
exams=np.array(exams)
marks=np.array(marks)
marks=marks.astype(float)

plt.bar(exams,mean_marks,width=0.5, color='blue',alpha=0.1 ,label="mean of the class") 
plt.bar(exams, marks,width=0.3, color='pink',label="actual score of student")    
plt.xlabel("exams")
plt.ylabel("Marks")
plt.title( student)
plt.xticks(rotation=90)  # Rotate x-axis labels for better readability
plt.legend()
plt.show()


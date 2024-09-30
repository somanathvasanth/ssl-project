import sys
file=sys.argv[1]
x=open(file,"r")
y=x.read()
y=y.replace(","," ")
y=y.split()
for x in range(int(len(y)/3)):
    print(y[3*x],y[3*x+1],y[3*x+2],x+1,sep=",")
myin = open("output.csv","r")
myout = open("emails.txt","w")
#
myin.readline()  # discard header

for line in myin:
    parts = line.split(",")
    myout.write("%s\n" %(parts[1],))

myout.close()

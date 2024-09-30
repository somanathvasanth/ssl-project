#!/bin/bash
             #second

                                    #######TOTAL FUNCTION######

#first total function was written because i used total in the combine function
total() {
      
        x=$(awk -F "," 'NR==1{print $NF}' "main.csv") #finding the last word in the first line of main.csv
#checking if total was done in a before step
        if [[ $x != "total" ]]; then
        #if there was no total done before
        #by using awk doing totalling line wise first inintiating a variable then adding all the marks(if absent considering it as zero) by using for loop starting from i=3 because first two columns are roll number and name.
        #first storing in a temporary file main_temp.csv then renaming it as main.csv by using mv command
            awk -F ',' 'NR==1 {print $0 ",total"; next} {total=0; for(i=3; i<=NF; i++) {if($i != "a") total+=$i} print $0 "," total}' OFS=',' main.csv > main_temp.csv
            mv main_temp.csv main.csv
        else
        
        #if the total is done before this
        #using awk finding total creating a string x and appending the name roll number and marks to it so that we can directly print this string at last before total so we can get in format of csv file
            awk -F ',' 'BEGIN{OFS=","} NR==1 {print $0; next} {total=0; for(i=3; i<NF; i++) {if($i != "a") total+=$i} x=$1; for(i=2; i<NF; i++) {x=x","$i}; print x","total}' main.csv > main_temp.csv
    #first storing in a temporary file main_temp.csv then renaming it as main.csv by using mv command
        mv main_temp.csv main.csv
        fi
   }

                                        ######COMBINE FUNCTION######

combine(){
    #i wrote code for two case if combine was run before or not because code should be a bit different if total was done before and if it is not done before.
if [ -f "main.csv" ]
then
x=$( awk -F "," 'NR==1{print $NF}' "main.csv" ) 
#checking if the total was done before or not by using awk to get the last word of firstline of main.csv
if [[ $x == "total" ]]
#for the case total was done before
then
echo -n "Roll_Number,Name" > main.csv
exams=$(find . -name '*.csv'| sed 's/\.csv//; s/^.\///')
#extracting the name of the exams from the filenames 
#first using find command to get all the files in the pwd ending with .csv after using sed s for removing .csv and removing the path by subtituting them with nothing.
for exam in $exams
do
if [ "$exam" != "main" ]
#wrote condition not equal to main because there is a main.csv file but it is not a exam
then
echo -n ",$exam" >>main.csv
#printing the exam headings -n to print in same line
fi
done
echo >> main.csv
#to get into newline
students=$(awk -F ',' 'FNR>1 {print $1}' *.csv |sort -u)
#extracting students roll numbers from files by using awk and getting them without duplicates by using sort -u.
while read -r studentrollno
#using while loop to go through each roll number at a time and appending marks and name to the roll number.
do
name=$(grep "^$studentrollno," *.csv | head -n 1 |cut -d ',' -f 2)
#extracting students name from the roll numbers we got in previous step by using grep to find sentence having given rollnumber from all csv files 
#we used head to get the first line because there will be roll number in more than one file
#cut is used to get name which is in the second column.
student=("$studentrollno" "$name")
#forming a student array so that we can add marks to it and finaalu add it to the main.csv
for exam in $exams
do
if [ "$exam" != "main" ]
then
marks=$(grep "^$studentrollno," "$exam.csv" | cut -d ',' -f 3 | tr -d '\r')
#extracting marks from files
#without this "tr -d '\r'" i was getting last entry marks of the student in the next line .so i used this command .this command deletes any carriage return characters (\r) from the extracted marks.
#tr -d '\r' will delete any carriage return characters (\r) from the input stream. Carriage return characters are typically used in some systems to indicate the end of a line, but they might not be desired or recognized by other systems or programs, hence the need to remove them.
if [ -z "$marks" ]
then
marks="a"
fi
#if student not there in a file printing "a"
student+=("$marks")
#adding marks to the student array
fi
done
echo "$(IFS=,; echo "${student[*]}")" | tr -d "\r" >>main.csv
#finally adding student array to the main.csv in the format asked
done<<<"$students" #used "<<<" to make the while loop to loop on a variable students instead of file name
#here i am doing total because total was done before combining
total
#here i am exiting because the next part of the code is for the case where the total is not done before
exit 
fi
fi

#this part is for the case where the main.csv is not present before combining code is almost same as the before case except at last total is not done
echo -n "Roll_Number,Name" > main.csv
exams=$(find . -name '*.csv'| sed 's/\.csv//; s/^.\///')
#extracting the name of the exams from the filenames
for exam in $exams
do
if [ "$exam" != "main" ]
then
echo -n ",$exam" >>main.csv
#printing the exam headings -n to print in same line
fi
done
echo >> main.csv
#to get into newline
students=$(awk -F ',' 'FNR>1 {print $1}' *.csv |sort -u)
#extracting students roll numbers from files without duplicates by using sort -u
while read -r studentrollno
do
name=$(grep "^$studentrollno," *.csv | head -n 1 |cut -d ',' -f 2)
#extracting students name from the roll numbers we got in previous step
student=("$studentrollno" "$name")
#forming a student array so that we can add marks to it and finaalu add it to the main.csv
for exam in $exams
do
if [ "$exam" != "main" ]
then
marks=$(grep "^$studentrollno," "$exam.csv" | cut -d ',' -f 3 | tr -d '\r')
#extracting marks from files
#without this "tr -d '\r'" i was getting last entry marks of the student in the next line .so i used this command .this command deletes any carriage return characters (\r) from the extracted marks.
if [ -z "$marks" ]
then
marks="a"
fi
#if student not there i  file printing "a"
student+=("$marks")
#adding marks to the student array
fi
done
echo "$(IFS=,; echo "${student[*]}")" | tr -d "\r" >>main.csv
#finally adding student array to the main.csv in the format asked
done<<<"$students"

}
#total upload combine total

                                 #######UPLOAD FUNCTION#######
upload(){

if [ ! -f "$1" ]
then
echo "Error :file not found"
#checking if the file in the path provided exists or not
exit 1
fi
cp "$1" .
#copying the file if it exists to the pwd
echo "uploaded file in current directory"

}
#checking the $1 of the command in the terminal to know which function to perform
if [[ $1 == "upload" ]]
then
upload "$2"
fi
if [[ $1 == "combine" ]]
then
combine
echo "successfully combined"
fi
if [[ $1 == "total" ]]; then
if [ ! -f "main.csv" ]
#total funtion needs main.csv so if msin.csv not present running combine function
then
combine
fi
total
echo "successfully added total"
fi

                   #######           ######GIT COMMANDS######             ######
#to create a hidden file in the home directory to store the previous hash and remote directory name
REPO_DATA_FILE="$HOME/.git_repo_data"
                                
                                ######git_init function#######

#git_init function initiates a remote directory
git_init(){    
    if [ -z "$1" ]; then
        echo "ERROR: No second argument provided" 
        #the directory is not given giving error
        exit 1
    fi

    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        #if the given directory doesnot exist creating the directory by using mkdir command -p to create the needed parent directories also
    fi

    echo "$1" > "$REPO_DATA_FILE"  # Store the remote repository directory path in a file
    echo "initial" >> "$REPO_DATA_FILE"  # writing the second line as "initial" to record that no commits are performed before for this remote directory will be used in git_commit
    
}
#checks if $1 is git_init to perform that function
if [ "$1" == "git_init" ]; then
    git_init "$2"
fi
                            #######git_commit function#######
git_commit(){
   
    remotedir=$(head -n 1 "$REPO_DATA_FILE")  # Read the remote repository directory path from the file
    prevhash=$(tail -n 1 "$REPO_DATA_FILE")    # Read the prevhash from the file
    if [ -z "$1" ]; then
        echo "Error: Commit message not provided."
        exit 1
    fi
    commit_message="$1"
    local hash=$(openssl rand -hex 8) #generating a hash by using this command
    commitdirectory="$remotedir/commits/$hash"
     #creating a directory named wih the hash value in the commits folder in the remote directory for storing the present copy of directory if commit is performed
    mkdir -p "$commitdirectory"
    #copying present directory to that remote direcory
    cp -r ./* "$commitdirectory/"
    echo "hash value: $hash date&time:$(date) commit message: $commit_message" >> "$remotedir/.git_log"
    #storing hash value and commit message in the .git_log file
    if [ "$prevhash" != "initial" ]; then
    #checking if it is first commit or not because we can't track modified files for the first commit.
       
        modified_files1=$(diff -rq "$remotedir/commits/$hash" "$remotedir/commits/$prevhash"|grep "^Only "|awk '{print $NF}')
        
        modified_files2=$(diff -rq $remotedir/commits/$hash $remotedir/commits/$prevhash|grep "Files"|awk -F "/" '{print $NF}'|awk '{print $1}')
        #finding modified files by using    diff command i will give the file modified in a certian format by comparing pres directoryn with prev hash directory
        #then using awk to get the name of the modified file with out any paths 
        #if the file is modified in a folder present in the present directory the diff gives output in a different format so wrote that if condition to get the modified files 
        
if [ ! -z "$modified_files1" ] #checks if it is empty or not and prints added or deleted files
then
echo "Files that are added or deleted:"
        echo "$modified_files1"
    fi
      if [ ! -z "$modified_files2" ] #checks if it is empty or not and prints modified files.
then
echo "Modified files:"
        echo "$modified_files2"
fi
if [  -z "$modified_files1" ] 
then
 if [  -z "$modified_files2" ]
then
echo "no modified files"
fi
fi
         #printing modified files
    fi
    echo "$hash" >> "$REPO_DATA_FILE"  # Update pr evhash in the file by adding the latest hash at the last of the file
}
if [ "$1" == "git_commit" ]; then
     if [[ ! -f "$REPO_DATA_FILE" ]]
   then
   echo "ERROR:remote repository not initialized. Please run git_init first."
   exit
    fi
   if [[ -f "$REPO_DATA_FILE" ]]
   then
   remotedir=$(head -n 1 "$REPO_DATA_FILE")
    fi
    if [ ! -f "$remotedir/.git_log" ]
    then
    touch "$remotedir/.git_log" #creating .git_log file if it doeant exist ie if it is the first commit
    fi
    git_commit "$3"
    echo "**Successfully committed**"
    fi
                                #######git_checkout function#########
git_checkout(){
if [ ! -f "$REPO_DATA_FILE" ]
#checking if the git_init is run before or not.
then
echo "ERROR :please run git_init before you run git_checkout"
exit 
fi
remotedirectory=$(head -n 1 "$REPO_DATA_FILE") #getting the remotedirectory
if [ -z "$1" ]
#checking if the commit hash or commit message is provided or not
then
echo "ERROR:commit message or hash value is not provided"
exit
fi
if [ "$1" != "-m" ]
#checking if it is commirt hash or commit message if commit message then there will be -m
then
matches=$(grep -E "$1" "$remotedirectory/.git_log" | awk '{print $3}')
#if it is not complete hash then finding the full commit hash by using grep through .git_log file. 
#using awk to print only the hash value from the output of grep.
numberofmatches=$(echo "$matches" | wc -l)
#for checking if more than one hash value match with the prefix provided finding the number of matches
if [ -z "$matches" ]
#if matches is empty then it means no matches.
then
echo "Error:no commit id found with given prefix or hash id"
exit
elif [ "$numberofmatches" -gt 1 ]
#if more than one commit hash matches with the given prefix
then
echo "Error:multiple commits found with the given prefix.Please provide a longer prefix or the full hash value."
exit
else
commit_id="$matches"
fi
commit_directory="$remotedirectory/commits/$commit_id"
#after finding the commit id assigning a variable commit_directory which stores the directory which is the required checkout directory.
rm -r ./*
cp -r "$commit_directory"/* .
#checking out the required commit's directory by using cp
echo "checked out succesfully"
fi

 if [ "$1" == "-m" ]
 #the case where the commit message is provided.
 then
matches=$(grep ": $2$" "$remotedirectory/.git_log" | awk '{print $3}')
numberofmatches=$(echo "$matches" | wc -l)
#matches and numberofmatches are similar to the before case
#except here we are using commit message to find the commit hash.
#the remaining code is same as the before case 
if [ -z "$matches" ]
then
echo "Error:no commit id found with given commit message"
exit
elif [ "$numberofmatches" -gt 1 ]
then
echo "Error:multiple commits found with the given commit message"
exit
else
commit_id="$matches"
fi
commit_directory="$remotedirectory/commits/$commit_id"
rm -r ./*
cp -r "$commit_directory"/* .
echo "checked out succesfully"
fi
}
#checking if we should call git_checkout function
if [[ "$1" == "git_checkout" ]]
then
git_checkout "$2" "$3" #giving the second and third arguments to the function.
fi

                        #######git_diff function(customization)#######

git_diff(){
    # Check if the repository data file exists
    if [ ! -f "$REPO_DATA_FILE" ]; then
        echo "ERROR: please run git_init before you run git_checkout"
        exit 
    fi
    
    # Retrieve the remote directory from the repository data file
    remotedirectory=$(head -n 1 "$REPO_DATA_FILE")
    
    # Check if both commit IDs are provided
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Usage: bash git_diff <commitid> <commitid>"
        exit
    fi
    
    echo " "
    echo "The differences are:"
    echo " "
    
    # Find the full commit hash for the first provided commit ID
    matches=$(grep -E "$1" "$remotedirectory/.git_log" | awk '{print $3}')
    numberofmatches=$(echo "$matches" | wc -l)
    
    # Check if there are no matches or multiple matches for the first commit ID
    if [ -z "$matches" ]; then
        echo "Error: no commit ID found with the given prefix or hash ID for the first commit"
        exit
    elif [ "$numberofmatches" -gt 1 ]; then
        echo "Error: multiple commits found with the given prefix for the first commit. Please provide a longer prefix or the full hash value."
        exit
    else
        commit1="$matches"
    fi
    
    # Find the full commit hash for the second provided commit ID
    matches=$(grep -E "$2" "$remotedirectory/.git_log" | awk '{print $3}')
    numberofmatches=$(echo "$matches" | wc -l)
    
    # Check if there are no matches or multiple matches for the second commit ID
    if [ -z "$matches" ]; then
        echo "Error: no commit ID found with the given prefix or hash ID for the second commit"
        exit
    elif [ "$numberofmatches" -gt 1 ]; then
        echo "Error: multiple commits found with the given prefix for the second commit. Please provide a longer prefix or the full hash value."
        exit
    else
        commit2="$matches"
    fi
    
    # Perform a unified diff between the commits
    diff -u "$remotedirectory/commits/$commit1" "$remotedirectory/commits/$commit2"
}

# Check if the first argument is "git_diff" and call the function with provided commit IDs
if [ "$1" == "git_diff" ]; then
    git_diff "$2" "$3"
fi

                     #######GIT_CLEAN function(customization)########
#if git_init is initialized and if you want to remove the before assigned remoted directory and deletes commits and .git_log file.
git_clean(){
     if [ ! -f "$REPO_DATA_FILE" ] #checks if this "$REPO_DATA_FILE file" exists.it will exist if git is initialized.
    then
    echo "nothing to clean"
    exit
    fi
    if [ -f "$REPO_DATA_FILE" ] 
    then
    remotedir=$(head -n 1 "$REPO_DATA_FILE") #gets remote directory
    rm -r "$remotedir/commits" #removes commits
    rm "$remotedir/.git_log" #removes .git_log file
    rm "$REPO_DATA_FILE" #removes $REPO_DATA_FILE file
    echo "cleaned"
    fi
   }
   #checks arguments and calls git_clean function
if [[ "$1" == "git_clean" ]]
then
git_clean
fi

                        ######git_log function(customization)#######
git_log() {
    # Check if the repository data file exists. If not, display an error and exit.
    if [ ! -f "$REPO_DATA_FILE" ]; then 
        echo "remote directory not initialized"
        exit
    fi
    # If the repository data file exists, proceed to check for git log file and display its contents.
    if [ -f "$REPO_DATA_FILE" ]; then
        remotedir=$(head -n 1 "$REPO_DATA_FILE") # Get the remote directory path.
        
        # Check if the git log file exists in the remote directory.
        if [ -f "$remotedir/.git_log" ]; then
            echo " "
            echo "Details about commits:"
            cat "$remotedir/.git_log" # Display the contents of the git log file.
            exit
        fi
        # If no git log file exists, inform the user that no commits have been performed.
        echo "There is nothing to show because no commits have been performed."
    fi
}

# Check if the first argument passed is "git_log" and call the function if it matches.
if [[ $1 == "git_log" ]]; then
    git_log
fi

                            ######UPDATE FUNCTION######
update(){
 #asking the user to give the roll number and exam for which he wants to change marks.  
    echo "enter students roll number:"
    read studentrollnumber #reading the roll number.
    studentnewrollnumber=$(echo "$studentrollnumber" | awk '{print toupper($0)}') #if the roll number is given in small letters converting it to capital.
    echo "enter the exam u want to change marks:"
        read exam #reading the exam.
         p="f" #this variable is created to check if any students rol nu mber not matches.
    if [ ! -f $exam.csv ]
    #checking if the provided exam exists and giving corresponding error.
    then
    echo "ERROR:no such exam exists"
    exit
    fi
    echo "enter the updated marks:"
    read updated_marks # reading the updated marks.
    
  x=$exam.csv  
    # assingning file name of the exam to x
    if [ -f "temp101232.csv" ]
    #checking if temp101232.csv exists and creating .this file used in the next part of the code
    then
    rm temp101232.csv 
    fi
   
    while read -r line
    #reading line by line from examfile
    do
    if [ ! -z "$line" ]
    then
   
    IFS="," read -r a b c <<<"$line"
    #reading the roll number name marks from the line using read <<<.
    
    anew=$(echo "$a" | awk '{print toupper($0)}') #converting roll number to uppercase for comparing.
if [ "$studentnewrollnumber" == "$anew" ]
#checking if any students roll number provided matches with those in the file.
then
let "c=$updated_marks"
#changing marks to the updated marks. 
p="t" #changing the f to t if some roll number matches.
fi
#first appending marks in a temp file and then changing its name.
echo "$a,$b,$c">> temp101232.csv
    fi
    done < $x

mv "temp101232.csv" "$exam.csv"

 if [ $p == "f" ]
 #telling the user that no student roll number matches.
 then
 echo "no such student roll number exist"
 else
 echo "successfully updated"
fi
}
#checking if asked to perform update.
if [[ "$1" == "update" ]]
then
update 
#updating in the main.csv if it exists.
if [ -f "main.csv" ]
then
combine
fi
fi
    
                        ######SEARCH FUNTION(customization)#######
search(){
   echo "enter the roll number:"
   read rollnumber
   if [ ! -f "main.csv" ]
   #we need main.csv for next step if not there creating using combine totla and deleting it at the end.
   then
   combine
   total
   #asking user to type the roll number of student
   y=$(awk -F "," 'NR==1{print $0}' main.csv)
    x=$(awk -F "," -v roll="$rollnumber" 'NR>1{if( $1 == roll )print $0}' main.csv)
    #using awk to get the exam names and marks of the student.
if [ -z "$x" ] 
#checking if the student roll number exists and reporting error.
then
echo "ERROR:no such student exists"
exit
fi
if [ -z "$x" ] 
then
echo "ERROR:no such student exists"
exit
fi
echo "$y"
echo "$x"
rm main.csv
exit
fi
#code is similar to the abive this is for the case where main.csv is already present.
total
y=$(awk -F "," 'NR==1{print $0}' main.csv)
    x=$(awk -F "," -v roll="$rollnumber" 'NR>1{if( $1 == roll )print $0}' main.csv)
if [ -z "$x" ] 
then
echo "ERROR:no such student exists"
exit
fi
echo "$y"
echo "$x"
}
#checking if 1 st argument is search to run the search function.
if [[ "$1" == "search" ]]
then
search
fi
                            ######STATISTICS FUNCTION(customization)######
statistics(){

    # Ask the user which exam's statistics they want, or if they want statistics for all exams.
    echo "Which exam's statistics do you want? (If you want statistics for all, type 'all')"
    read exam # Read user input for the exam name or 'all'

    # If the user wants statistics for all exams
    if [ "$exam" == "all" ]; then
    echo "The statistics af all the exams are"
    echo "*************"
        for t in *.csv
        do
        if [ $t != main.csv ]
        then
        ppp=$(basename $t .csv)
        python3 statistics.py $t $ppp
        fi
        done
        echo "*************"
        exit
    fi

    # If the user wants statistics for a specific exam
    if [ ! -f "$exam.csv" ]; then
        # If the specified exam CSV file doesn't exist, display an error and exit
        echo "ERROR: There is no exam of that name. Please check the name."
        exit
    fi
    
    # Loop through each CSV file in the directory
    for x in *.csv; do
        ppp=$(basename $x .csv) # Extract the exam name from the CSV filename
        # Check if the current file name matches the specified exam
        if [ "$exam" == "$ppp" ]; then
        echo "             Statistics"
            python3 statistics.py $x $ppp # Call Python script to calculate statistics for the exam
        fi
    done
}

# Check if the first argument passed to the script is "statistics", and if so, call the statistics function
if [[ $1 == "statistics" ]]; then
    statistics
fi

                            #######graphs function(customization)#######

graphs(){
    # Prompt the user to choose the type of graph: exam-wise or student-wise
    echo "Do you want the graph with respect to students or with respect to exams?"
    echo "Type 'exam' if you want exam-wise or 'student' if you want student-wise"
    read ans
    
    # Check if the input is valid
    if [ $ans != "exam" ] && [ $ans != "student" ]; then
        echo "Error: Wrong input. Please enter either 'exam' or 'student'."
        exit
    fi

    # If the user wants an exam-wise graph
    if [ $ans == "exam" ]; then
        echo "Which exam graph do you want?"
        read exam 
        
        # Check if the specified exam CSV file exists
        if [ ! -f "$exam.csv" ]; then
            echo "ERROR: There is no exam of that name. Please check the name."
            exit
        fi
        
        # Open the graph for the specified exam
        echo "The graph will open now"
        python3 graphsexam.py $exam.csv 
    fi

    # If the user wants a student-wise graph
    if [ $ans == "student" ]; then
        echo "Type the roll number of the student:"
        read student
        
        # Check if main.csv exists
        if [ -f "main.csv" ]; then
            # Count the total number of exams
            total=0
            for x in *.csv; do
                # Increment the counter for each exam file (excluding main.csv)
                if [ $x != "main.csv" ]; then
                    let "total=total+1"
                fi
            done
            
            # Generate the student-wise graph
            python3 graphsstudent.py $student $total
        fi
    fi
}

# Check if the first argument passed to the script is "graphs", and if so, call the graphs function
if [[ $1 == "graphs" ]]; then
    combine #main.csv is needed so if it is not there it will create here.
    graphs
fi
                            #########add_a_student function (customization)#########

# Define a function named add_a_student
add_a_student(){
    # Prompt user to input the name of the exams
    echo "enter the exam name:"
    read examname

    # Check if the CSV file for the exam exists
    if [ ! -f $examname.csv ]
    then
        # If the file does not exist, display an error message and exit
        echo "ERROR: no such exam exists"
        exit
    fi

    # Prompt user to input the student's roll number
    echo "enter students roll number:"
    read rollnumber

    # Convert roll number to uppercase to remove case sensitivity of roll number
    studentnewrollnumber=$(echo "$rollnumber" | awk '{print toupper($0)}')

    # Loop through each line in the CSV file
    while read -r line
    do
        # Split the line into three fields separated by commas
        IFS="," read a b c <<< $line

        # Convert the first field (roll number) to uppercase to remove case sensitivity of roll number 
        newa=$(echo "$a" | awk '{print toupper($0)}')

        # Check if a student with the same roll number already exists
        if [ $newa == $studentnewrollnumber ]
        then
            # If a student with the same roll number exists, display a message and exit
            echo "a student already exists of that roll number. Do you want to update his marks? Use ./submission update for it"
            exit
        fi
    done < $examname.csv

    # If no student with the same roll number exists, prompt user to input student's name
    echo "enter student's name:"
    read name

    # Prompt user to input student's marks
    echo "enter marks of the student:"
    read marks

    # Append student's information (roll number, name, marks) to the CSV file
    echo "$rollnumber,$name,$marks" >> $examname.csv
}

# Check if the first argument passed to the script is "add_a_student"
if [[ "$1" == "add_a_student" ]]
then
    # If the argument matches, call the add_a_student function
    add_a_student
fi

                        #########remove_a_student function (customization)#########

# Define a function named remove_a_student
remove_a_student(){
    # Prompt user to input the name of the exam
    echo "enter the exam name:"
    read examname

    # Check if the CSV file for the exam exists
    if [ ! -f $examname.csv ]
    then
        # If the file does not exist, display an error message and exit
        echo "ERROR: no such exam exists"
        exit
    fi

    # Prompt user to input the student's roll number
    echo "enter students roll number:"
    read rollnumber

    # Initialize a variable to keep track of whether the student was found
    check="f"

    # Convert roll number to uppercase
    studentnewrollnumber=$(echo "$rollnumber" | awk '{print toupper($0)}')

    # Loop through each line in the CSV file
    while read -r line
    do
        # Split the line into three fields separated by commas
        IFS="," read a b c <<< $line

        # Convert the first field (roll number) to uppercase
        newa=$(echo "$a" | awk '{print toupper($0)}')

        # Check if the current line's roll number matches the input roll number
        if [ $newa == $studentnewrollnumber ]
        then
            # If a match is found, set the check variable to indicate the student was found
            check="t"
        fi

        # If the current line's roll number does not match the input roll number, write it to temp.csv
        if [ $newa != $studentnewrollnumber ]
        then
            echo "$a,$b,$c" >> temp.csv
        fi
    done < $examname.csv

    # Replace the original CSV file with temp.csv
    mv temp.csv $examname.csv

    # If no student with the provided roll number was found, display a message
    if [ $check == "f" ]
    then
        echo "no such student exists to remove."
    fi
}

# Check if the first argument passed to the script is "remove_a_student"
if [[ "$1" == "remove_a_student" ]]
then
    # If the argument matches, call the remove_a_student function
    remove_a_student
fi

                    ########top_performer function (customization)#########

# Define a Bash function to find the top performer in a given exam CSV file
top_performer(){
    # Prompt the user to input the name of the exam
    echo "Enter the exam name:"
    read examname

    # Check if the CSV file for the exam exists
    if [ ! -f $examname.csv ]
    then
        # If the file does not exist, display an error message and exit
        echo "ERROR: No such exam file exists"
        exit
    fi
    
    # Call the Python script to find the top performer in the specified exam CSV file
    python3 top_performer.py $examname.csv
}

# Check if the first argument matches the command "top_performer"
if [[ "$1" == "top_performer" ]]
then
    # If the argument matches, call the top_performer function
    top_performer
fi

                            ########leaderboard function(customization)########

# Define a function to generate the leaderboard
leaderboard(){
    # Prompt the user to enter the exam name
    echo "enter the exam name:"
    read examname

    # Check if the CSV file for the exam exists
    if [ ! -f $examname.csv ]
    then
        # If the file does not exist, display an error message and exit
        echo "ERROR: no such exam exists"
        exit
    fi

    # Extract data from the CSV file, sort it by marks, and save to a temporary file
    tail -n +2 $examname.csv | sort -r -n -t "," -k3 > temp.csv

    # Display information about the exam and the leaderboard header
    echo "****************************"
    echo "exam name: $examname"
    echo "       LEADERBOARD"
    echo "Roll number,Name,Marks,Rank"

    # Call a Python script to calculate ranks and display the leaderboard
    python3 rank.py temp.csv

    # Remove the temporary file
    rm temp.csv
}

# Check if the script is invoked with the argument "leaderboard"
if [[ "$1" == "leaderboard" ]]
then
    # If the argument matches, call the leaderboard function
    leaderboard
fi

                          ########overview function(customization)########

# Define a function to generate an overview of the exam
overview(){
    # Prompt the user to enter the exam name
    echo "enter the exam name:"
    read examname
    # Check if the CSV file for the exam exists
    if [ ! -f $examname.csv ]
    then
        # If the file does not exist, display an error message and exit
        echo "ERROR: no such exam exists"
        exit
    fi
    # Display an overview of the exam using a Python script
    echo "Here is the overview of $examname"
    python3 overview.py $examname.csv
}

# Check if the script is invoked with the argument "overview"
if [[ "$1" == "overview" ]]
then
    # If the argument matches, call the overview function
    overview
fi


import sys

# Check if a CSV filename is provided as the first argument
if len(sys.argv) != 2:
    print("Usage: python script.py <csv_filename>")  # Print usage instructions
    sys.exit(1)  # Exit the script if the filename is missing or incorrect

# Get the CSV filename from command line argument
csv_file_path = sys.argv[1]

# Open the CSV file for reading
file = open(csv_file_path, 'r')

# Skip header line
header_line = file.readline()

# Initialize variables to store top performer details
top_performer_roll = ""  # Initialize top performer roll number
top_performer_name = ""  # Initialize top performer name
top_performer_marks = None  # Initialize top performer marks as None initially

# Read each line of the CSV file
line = file.readline()
while line:
    # Split the line into roll number, name, and marks
    roll_number, name, marks_str = line.strip().split(',')
    marks = float(marks_str)  # Convert marks to float

    # Check if current student has higher marks than current top performer or if no top performer is set yet
    if top_performer_marks is None or marks > top_performer_marks:
        top_performer_roll = roll_number  # Update top performer roll number
        top_performer_name = name  # Update top performer name
        top_performer_marks = marks  # Update top performer marks

    # Read the next line
    line = file.readline()

# Close the file
file.close()

# Print details of top performer
print("Top Performer:")
print("Roll Number:", top_performer_roll)  # Print top performer roll number
print("Name:", top_performer_name)  # Print top performer name
print("Marks:", top_performer_marks)  # Print top performer marks

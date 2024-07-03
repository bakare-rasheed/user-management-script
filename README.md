# user-management-script
Overview
This project provides a Bash script, create_users.sh, designed to automate the process of creating users and groups on a Linux system. The script reads a text file containing employee usernames and group names, sets up home directories with appropriate permissions, generates random passwords for the users, and logs all actions.

Features
Automatic User and Group Creation: Creates users and their respective groups as specified in an input file.
Home Directory Setup: Sets up home directories with proper permissions and ownership.
Password Generation: Generates random passwords for each user.
Logging: Logs all actions to /var/log/user_management.log.
Secure Password Storage: Stores generated passwords securely in /var/secure/user_passwords.csv.
Requirements
Linux-based operating system (Ubuntu preferred)
openssl for password generation


Usage
Clone the Repository:
git clone https://github.com/bakare-rasheed/user-management-script.git
cd user-management-script.git

Prepare the Input File:
Create a users.txt file with the following format:
username;group1,group2,group3
Bakare;sudo,dev,www-data
Rasheed;sudo
Abiola;dev,www-data

Run the Script:
Make the script executable and run it with the users.txt file as an argument:
chmod +x create_users.sh
sudo ./create_users.sh users.txt

Script Details
The create_users.sh script performs the following steps:

Reads the users.txt file line by line.
For each user:
Creates a personal group with the same name as the user.
Creates the user and assigns them to their personal group.
Generates a random password and sets it for the user.
Sets up the user's home directory with appropriate permissions.
Assigns the user to additional groups as specified.
Logs all actions to /var/log/user_management.log.
Stores the generated passwords in /var/secure/user_passwords.csv.
Files
create_users.sh: The main script for creating users and groups.
users.txt: Input file containing usernames and group names.
README.md: This documentation file.
Logging and Security
Log File: All actions performed by the script are logged in /var/log/user_management.log.
Password Storage: User passwords are stored securely in /var/secure/user_passwords.csv with restricted access.

Troubleshooting
If you encounter any issues, check the log file for details:
sudo cat /var/log/user_management.log

Common issues:

Group or User Already Exists: The script will skip creating users or groups if they already exist.
Permission Denied: Ensure you run the script with sudo to have the necessary permissions for user and group creation.
Contribution
Feel free to fork this repository, make improvements, and submit pull requests. Contributions are welcome!

HNG Internship
HNG Premium


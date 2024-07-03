#!/bin/bash

# Log file and secure password storage
LOG_FILE="/var/log/user_management.log"
PASSWORD_FILE="/var/secure/user_passwords.csv"

# Check if the input file is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <user-file>"
  exit 1
fi

USER_FILE="$1"

# Ensure the log file and password file exist
touch "$LOG_FILE"
mkdir -p /var/secure
touch "$PASSWORD_FILE"
chmod 600 "$PASSWORD_FILE"

# Process each line in the user file
while IFS=';' read -r username groups; do
  # Ignore empty lines
  [ -z "$username" ] && continue

  # Remove leading and trailing whitespace from the groups
  groups=$(echo "$groups" | xargs)

  # Create a personal group with the same name as the user
  if ! getent group "$username" > /dev/null; then
    groupadd "$username"
    echo "$(date) - Group $username created." >> "$LOG_FILE"
  fi

  # Create the user if they don't exist
  if ! id -u "$username" > /dev/null 2>&1; then
    useradd -m -g "$username" "$username"
    echo "$(date) - User $username created with groups: $groups" >> "$LOG_FILE"

    # Generate a random password
    password=$(openssl rand -base64 12)
    echo "$username:$password" | chpasswd
    echo "$username,$password" >> "$PASSWORD_FILE"
    echo "$(date) - Password set for $username" >> "$LOG_FILE"

    # Set the correct permissions for the home directory
    chown -R "$username:$username" "/home/$username"
    chmod 700 "/home/$username"
    echo "$(date) - Permissions set for /home/$username" >> "$LOG_FILE"
  else
    echo "$(date) - User $username already exists. Skipping creation." >> "$LOG_FILE"
  fi

  # Add the user to the additional groups if specified
  IFS=',' read -r -a group_array <<< "$groups"
  for group in "${group_array[@]}"; do
    if ! getent group "$group" > /dev/null; then
      groupadd "$group"
      echo "$(date) - Group $group created." >> "$LOG_FILE"
    fi
    usermod -aG "$group" "$username"
    echo "$(date) - User $username added to group $group" >> "$LOG_FILE"
  done
done < "$USER_FILE"

echo "User creation process completed. Check the log file for details: $LOG_FILE"

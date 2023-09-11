#!/bin/bash

# Check if the script is run as the "altschool" user on the Master node
if [ "$MASTER_USER" != "altschool" ]; then
  echo "Please run this script as the 'altschool' user on the Master node."
  exit 1
fi

# Define the Slave node's IP address
SLAVE_IP="192.168.56.18" 

# Perform the data transfer from the Master to the Slave node
rsync -avz /mnt/altschool/ altschool@"192.168.56.18":/mnt/altschool/slave/

# Check if the rsync command was successful
if [ $? -eq 0 ]; then
  echo "Data transfer completed successfully."
else
  echo "Data transfer encountered an error."
fi
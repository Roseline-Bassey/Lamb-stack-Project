#!/bin/bash

# Define the username
newuser="altschool"

# Create a user 
sudo useradd -m -s /bin/bash "$newuser"

# Grant root (sudo) privileges to the user
sudo usermod -aG sudo "$newuser"

echo "User $newuser created with root privileges."
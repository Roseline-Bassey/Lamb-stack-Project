#!/bin/bash

ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa

# Copy the public key to the Slave node
ssh-copy-id -i ~/.ssh/id_rsa.pub altschool@192.168.56.18

ssh altschool@192.168.56.18 "echo SSH connection established successfully."
#!/bin/bash

# Run the ps command and store the output in a variable
process_list=$(ps aux)

# Display the process list
echo "Currently running processes:"
echo "$process_list"
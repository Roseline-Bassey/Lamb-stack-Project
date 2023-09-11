# Define variables
MASTER_USER="altschool"
SLAVE_IP="192.168.56.18" 

# Generate an SSH key pair for the Master user
sudo -u "$MASTER_USER" ssh-keygen -t rsa -b 4096 -N "" -f /home/"$MASTER_USER"/.ssh/id_rsa

# Copy the public key to the Slave node
sudo -u "$MASTER_USER" ssh-copy-id "$MASTER_USER"@"192.168.56.18"


# Configure SSH on the Slave node to allow key-based authentication
ssh_config="/etc/ssh/sshd_config"
sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' "$ssh_config"
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' "$ssh_config"

# Restart SSH on the Slave node to apply the configuration changes
systemctl restart ssh
# installing nginx
apt update
apt install nginx-y
sudo ufw allow 'Nginx HTTP'
sudo ufw status

#starting nginx load-balancer
systemctl start nginx
systemctl enable nginx

# Configure Nginx as a Load Balancer
cat <<EOL > /etc/nginx/nginx.conf
http {
    upstream backend {
        # Load Balancing method
        least_conn;

        # Backend servers
        server 192.168.56.17:80 weight=1 max_fails=2 fail_timeout=30s;
        server 192.168.56.18:80 weight=1 max_fails=2 fail_timeout=30s;
    }

    server {
        listen 80;

        location / {
            proxy_pass http://backend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }
}
EOL

# Restart Nginx
systemctl restart nginx

echo "Nginx has been configured as a load balancer for your LAMP stack."

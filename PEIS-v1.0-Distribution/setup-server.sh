#!/bin/bash
# PEIS Assessment Tool - Automated Server Setup Script
# For Ubuntu 20.04/22.04 LTS

echo "🚀 PEIS Assessment Server Setup Starting..."
echo "=========================================="

# Update system
echo "📦 Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install Nginx
echo "🌐 Installing Nginx web server..."
sudo apt install nginx -y

# Install additional tools
echo "🔧 Installing additional tools..."
sudo apt install certbot python3-certbot-nginx htop curl wget unzip -y

# Configure firewall
echo "🔒 Configuring firewall..."
sudo ufw allow 'Nginx Full'
sudo ufw allow ssh
sudo ufw --force enable

# Start and enable Nginx
echo "▶️ Starting Nginx service..."
sudo systemctl start nginx
sudo systemctl enable nginx

# Create PEIS directory
echo "📁 Creating PEIS web directory..."
sudo mkdir -p /var/www/peis
sudo chown -R www-data:www-data /var/www/peis
sudo chmod -R 755 /var/www/peis

# Create Nginx configuration for PEIS
echo "⚙️ Creating Nginx configuration..."
sudo tee /etc/nginx/sites-available/peis > /dev/null <<EOF
server {
    listen 80;
    server_name _;
    root /var/www/peis;
    index emotional-intelligence-scale.html index.html;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;

    # Main location
    location / {
        try_files \$uri \$uri/ =404;
    }

    # Cache static files
    location ~* \.(css|js|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
        access_log off;
    }

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/css application/javascript text/javascript application/json text/xml application/xml;

    # Security - hide server version
    server_tokens off;

    # Prevent access to sensitive files
    location ~ /\. {
        deny all;
        access_log off;
        log_not_found off;
    }
}
EOF

# Enable PEIS site
echo "🔗 Enabling PEIS site..."
sudo ln -sf /etc/nginx/sites-available/peis /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

# Test Nginx configuration
echo "🧪 Testing Nginx configuration..."
sudo nginx -t

if [ $? -eq 0 ]; then
    echo "✅ Nginx configuration is valid"
    sudo systemctl reload nginx
else
    echo "❌ Nginx configuration error!"
    exit 1
fi

# Create upload script
echo "📤 Creating file upload helper..."
sudo tee /usr/local/bin/upload-peis > /dev/null <<'EOF'
#!/bin/bash
# PEIS File Upload Helper

if [ "$#" -ne 1 ]; then
    echo "Usage: upload-peis <path-to-peis-files>"
    echo "Example: upload-peis /home/user/PEIS-v1.0-Distribution"
    exit 1
fi

SOURCE_DIR="$1"

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Directory $SOURCE_DIR does not exist"
    exit 1
fi

echo "Uploading PEIS files from $SOURCE_DIR to /var/www/peis/"
sudo cp -r "$SOURCE_DIR"/* /var/www/peis/
sudo chown -R www-data:www-data /var/www/peis/
sudo chmod -R 755 /var/www/peis/

echo "✅ PEIS files uploaded successfully!"
echo "🌐 Access your assessment at: http://$(curl -s ifconfig.me)/emotional-intelligence-scale.html"
EOF

sudo chmod +x /usr/local/bin/upload-peis

# Create SSL setup script
echo "🔐 Creating SSL setup helper..."
sudo tee /usr/local/bin/setup-ssl > /dev/null <<'EOF'
#!/bin/bash
# PEIS SSL Certificate Setup

if [ "$#" -ne 1 ]; then
    echo "Usage: setup-ssl <your-domain.com>"
    echo "Example: setup-ssl peis.yoursite.com"
    exit 1
fi

DOMAIN="$1"

echo "Setting up SSL certificate for $DOMAIN..."

# Update Nginx config with domain
sudo sed -i "s/server_name _;/server_name $DOMAIN www.$DOMAIN;/" /etc/nginx/sites-available/peis
sudo nginx -t && sudo systemctl reload nginx

# Get SSL certificate
sudo certbot --nginx -d "$DOMAIN" -d "www.$DOMAIN" --non-interactive --agree-tos --email admin@$DOMAIN

# Setup auto-renewal
(crontab -l 2>/dev/null; echo "0 12 * * * /usr/bin/certbot renew --quiet") | crontab -

echo "✅ SSL certificate installed for $DOMAIN"
echo "🔒 Your site is now accessible at: https://$DOMAIN"
EOF

sudo chmod +x /usr/local/bin/setup-ssl

# Create status check script
echo "📊 Creating status check script..."
sudo tee /usr/local/bin/peis-status > /dev/null <<'EOF'
#!/bin/bash
# PEIS Server Status Check

echo "🖥️  PEIS Assessment Server Status"
echo "================================="

# Server info
echo "📍 Server IP: $(curl -s ifconfig.me)"
echo "🕒 Uptime: $(uptime -p)"
echo "💾 Disk Usage: $(df -h / | awk 'NR==2{printf "%s/%s (%s)", $3,$2,$5}')"
echo "🧠 Memory Usage: $(free -h | awk 'NR==2{printf "%s/%s (%.2f%%)", $3,$2,$3*100/$2}')"

echo ""
echo "🌐 Web Server Status:"
systemctl is-active --quiet nginx && echo "✅ Nginx: Running" || echo "❌ Nginx: Stopped"

echo ""
echo "🔒 SSL Certificate Status:"
if [ -d "/etc/letsencrypt/live" ] && [ "$(ls -A /etc/letsencrypt/live)" ]; then
    for cert in /etc/letsencrypt/live/*/cert.pem; do
        domain=$(basename $(dirname $cert))
        expiry=$(openssl x509 -enddate -noout -in $cert | cut -d= -f2)
        echo "✅ $domain: Valid until $expiry"
    done
else
    echo "⚠️  No SSL certificates found"
fi

echo ""
echo "📁 PEIS Files:"
if [ -f "/var/www/peis/emotional-intelligence-scale.html" ]; then
    echo "✅ PEIS assessment files are installed"
    echo "🌐 Access at: http://$(curl -s ifconfig.me)/emotional-intelligence-scale.html"
else
    echo "⚠️  PEIS files not found. Run: upload-peis <path-to-files>"
fi

echo ""
echo "📊 Recent Access Logs (last 10 entries):"
sudo tail -n 10 /var/log/nginx/access.log | grep -v "\.css\|\.js\|\.png\|\.jpg\|\.ico" || echo "No recent access logs"
EOF

sudo chmod +x /usr/local/bin/peis-status

# Get server IP
SERVER_IP=$(curl -s ifconfig.me)

# Final setup summary
echo ""
echo "🎉 PEIS Assessment Server Setup Complete!"
echo "=========================================="
echo ""
echo "📍 Server IP: $SERVER_IP"
echo "🌐 Nginx Status: $(systemctl is-active nginx)"
echo "🔒 Firewall Status: $(sudo ufw status | head -1)"
echo ""
echo "📋 Next Steps:"
echo "1. Upload PEIS files: upload-peis /path/to/PEIS-v1.0-Distribution"
echo "2. Setup domain (optional): Point your domain to $SERVER_IP"
echo "3. Setup SSL (optional): setup-ssl your-domain.com"
echo "4. Check status anytime: peis-status"
echo ""
echo "🔧 Useful Commands:"
echo "• peis-status          - Check server status"
echo "• upload-peis <path>   - Upload PEIS files"
echo "• setup-ssl <domain>   - Setup SSL certificate"
echo "• sudo systemctl reload nginx - Reload web server"
echo ""
echo "📖 Documentation: See SERVER-DEPLOYMENT.md for detailed instructions"
echo ""
echo "✅ Your PEIS assessment server is ready!"
# 🖥️ Server Deployment Guide for PEIS

## Overview
The PEIS assessment tool is a static web application that can be deployed on any web server. No database or server-side processing required.

---

## Option 1: VPS/Cloud Server (Recommended for Professional Use)

### Popular VPS Providers:
- **DigitalOcean** - $5-10/month
- **Linode** - $5-10/month  
- **Vultr** - $3.50-6/month
- **AWS EC2** - $3-15/month
- **Google Cloud** - $5-20/month

### Step-by-Step VPS Deployment:

#### 1. Create VPS Instance
```bash
# Choose Ubuntu 22.04 LTS
# Minimum specs: 1GB RAM, 1 CPU, 25GB storage
# Enable SSH access
```

#### 2. Connect to Server
```bash
# Windows (use PuTTY or PowerShell)
ssh root@your-server-ip

# Or use built-in SSH
ssh -i your-key.pem ubuntu@your-server-ip
```

#### 3. Install Web Server (Nginx)
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Nginx
sudo apt install nginx -y

# Start and enable Nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Check status
sudo systemctl status nginx
```

#### 4. Configure Firewall
```bash
# Allow HTTP and HTTPS
sudo ufw allow 'Nginx Full'
sudo ufw allow ssh
sudo ufw enable
```

#### 5. Upload PEIS Files
```bash
# Remove default files
sudo rm -rf /var/www/html/*

# Upload your files (use SCP, SFTP, or file manager)
# Copy all files from PEIS-v1.0-Distribution to /var/www/html/
```

#### 6. Set Permissions
```bash
# Set proper ownership
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/
```

#### 7. Configure Domain (Optional)
```bash
# Edit Nginx config
sudo nano /etc/nginx/sites-available/default

# Add your domain name
server_name your-domain.com www.your-domain.com;
```

#### 8. Enable HTTPS (SSL Certificate)
```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx -y

# Get SSL certificate
sudo certbot --nginx -d your-domain.com -d www.your-domain.com

# Auto-renewal
sudo crontab -e
# Add: 0 12 * * * /usr/bin/certbot renew --quiet
```

---

## Option 2: Shared Hosting (Easiest)

### Popular Providers:
- **Bluehost** - $3-5/month
- **SiteGround** - $4-6/month
- **HostGator** - $3-5/month
- **GoDaddy** - $3-7/month

### Steps:
1. **Purchase hosting plan** with cPanel access
2. **Access File Manager** in cPanel
3. **Navigate to public_html** folder
4. **Upload all PEIS files** from distribution folder
5. **Extract files** if uploaded as ZIP
6. **Set permissions** to 644 for files, 755 for folders
7. **Access via your domain** or temporary URL

---

## Option 3: Apache Server Setup

### Install Apache (Ubuntu/Debian):
```bash
# Install Apache
sudo apt update
sudo apt install apache2 -y

# Start Apache
sudo systemctl start apache2
sudo systemctl enable apache2

# Upload files to /var/www/html/
sudo rm -rf /var/www/html/*
# Copy PEIS files here

# Set permissions
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/
```

### Configure Virtual Host:
```bash
# Create config file
sudo nano /etc/apache2/sites-available/peis.conf

# Add configuration:
<VirtualHost *:80>
    ServerName your-domain.com
    DocumentRoot /var/www/html
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

# Enable site
sudo a2ensite peis.conf
sudo systemctl reload apache2
```

---

## Option 4: Docker Deployment

### Create Dockerfile:
```dockerfile
FROM nginx:alpine

# Copy PEIS files
COPY PEIS-v1.0-Distribution/ /usr/share/nginx/html/

# Expose port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
```

### Deploy with Docker:
```bash
# Build image
docker build -t peis-assessment .

# Run container
docker run -d -p 80:80 --name peis peis-assessment

# Or with custom port
docker run -d -p 8080:80 --name peis peis-assessment
```

---

## Option 5: Windows IIS Server

### Steps:
1. **Enable IIS** in Windows Features
2. **Open IIS Manager**
3. **Create new website**:
   - Site name: PEIS Assessment
   - Physical path: C:\inetpub\wwwroot\peis
   - Port: 80 (or custom)
4. **Copy PEIS files** to physical path
5. **Set permissions** for IIS_IUSRS
6. **Access via localhost** or server IP

---

## 🔧 Server Configuration Tips

### Nginx Configuration (`/etc/nginx/sites-available/default`):
```nginx
server {
    listen 80;
    server_name your-domain.com;
    root /var/www/html;
    index emotional-intelligence-scale.html;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;

    # Cache static files
    location ~* \.(css|js|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Gzip compression
    gzip on;
    gzip_types text/css application/javascript text/javascript;
}
```

### Apache Configuration (`.htaccess`):
```apache
# Security headers
Header always set X-Frame-Options "SAMEORIGIN"
Header always set X-Content-Type-Options "nosniff"
Header always set X-XSS-Protection "1; mode=block"

# Cache static files
<FilesMatch "\.(css|js|png|jpg|jpeg|gif|ico|svg)$">
    ExpiresActive On
    ExpiresDefault "access plus 1 year"
</FilesMatch>

# Gzip compression
<IfModule mod_deflate.c>
    AddOutputFilterByType DEFLATE text/css
    AddOutputFilterByType DEFLATE application/javascript
    AddOutputFilterByType DEFLATE text/javascript
</IfModule>
```

---

## 🔒 Security Considerations

### Essential Security Measures:
1. **HTTPS/SSL Certificate** - Always use encrypted connections
2. **Firewall Configuration** - Only allow necessary ports
3. **Regular Updates** - Keep server software updated
4. **Access Logs** - Monitor who accesses the assessment
5. **Backup Strategy** - Regular automated backups

### Professional Use Requirements:
- **HIPAA Compliance** - If handling patient data
- **Access Control** - Restrict to qualified professionals
- **Data Privacy** - Ensure local processing only
- **Professional Licensing** - Verify user qualifications

---

## 📊 Monitoring & Analytics

### Server Monitoring:
```bash
# Install monitoring tools
sudo apt install htop iotop nethogs -y

# Check server resources
htop                    # CPU/Memory usage
df -h                   # Disk space
nginx -t                # Test Nginx config
systemctl status nginx  # Service status
```

### Web Analytics (Optional):
- **Google Analytics** - Add tracking code
- **Server Logs** - Analyze access patterns
- **Uptime Monitoring** - Services like UptimeRobot

---

## 🚀 Quick Server Setup Script

### Automated Ubuntu Setup:
```bash
#!/bin/bash
# PEIS Server Setup Script

# Update system
sudo apt update && sudo apt upgrade -y

# Install Nginx
sudo apt install nginx certbot python3-certbot-nginx -y

# Configure firewall
sudo ufw allow 'Nginx Full'
sudo ufw allow ssh
sudo ufw --force enable

# Create web directory
sudo mkdir -p /var/www/peis
sudo chown -R $USER:$USER /var/www/peis

echo "Server setup complete!"
echo "Upload PEIS files to /var/www/peis/"
echo "Configure domain in /etc/nginx/sites-available/default"
```

---

## 💡 Recommended Setup for Professional Use

### Best Configuration:
1. **VPS with Ubuntu 22.04**
2. **Nginx web server**
3. **SSL certificate (Let's Encrypt)**
4. **Custom domain name**
5. **Regular automated backups**
6. **Monitoring and logging**

### Estimated Costs:
- **VPS**: $5-10/month
- **Domain**: $10-15/year
- **SSL**: Free (Let's Encrypt)
- **Total**: ~$70-135/year

This provides a professional, secure, and reliable platform for the PEIS assessment tool accessible to qualified professionals worldwide.
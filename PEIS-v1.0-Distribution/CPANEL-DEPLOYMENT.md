# 🎛️ cPanel Deployment Guide for PEIS

## Quick cPanel Deployment (5 Minutes!)

Since you have cPanel access, deploying PEIS is incredibly simple. Follow these steps:

---

## Step 1: Access cPanel File Manager

1. **Login to your cPanel** (usually at yoursite.com/cpanel)
2. **Find "File Manager"** in the Files section
3. **Click File Manager** to open

---

## Step 2: Navigate to Public Directory

1. **Navigate to `public_html`** folder (this is your website's root)
2. **Optional**: Create a subdirectory like `peis` or `assessment` if you want the tool at yoursite.com/peis/

---

## Step 3: Upload PEIS Files

### Option A: Upload Individual Files
1. **Click "Upload"** button in File Manager
2. **Select all files** from your `PEIS-v1.0-Distribution` folder:
   - `emotional-intelligence-scale.html`
   - `emotional-intelligence-scale.css`
   - `emotional-intelligence-scale.js`
   - `README.md`
   - `LICENSE.txt`
   - `CHANGELOG.md`
   - `ONLINE-DEPLOYMENT.md`
   - `install-peis.bat`
   - `run-emotional-intelligence-evaluation.bat`
   - `docs/` folder (upload this folder too)
3. **Wait for upload** to complete

### Option B: Upload as ZIP (Recommended)
1. **Create ZIP file** of your `PEIS-v1.0-Distribution` folder on your computer
2. **Upload the ZIP file** using File Manager
3. **Right-click the ZIP file** in cPanel
4. **Select "Extract"** to unzip all files
5. **Delete the ZIP file** after extraction

---

## Step 4: Set File Permissions

1. **Select all uploaded files** (Ctrl+A or Cmd+A)
2. **Right-click** and choose "Permissions"
3. **Set permissions**:
   - **Files**: 644 (Owner: Read/Write, Group: Read, Public: Read)
   - **Folders**: 755 (Owner: Read/Write/Execute, Group: Read/Execute, Public: Read/Execute)
4. **Check "Recurse into subdirectories"**
5. **Click "Change Permissions"**

---

## Step 5: Test Your Deployment

1. **Open your browser**
2. **Navigate to**: `https://yoursite.com/emotional-intelligence-scale.html`
   - Or if you created a subfolder: `https://yoursite.com/peis/emotional-intelligence-scale.html`
3. **Verify the assessment loads** properly
4. **Test a few questions** to ensure functionality

---

## 🔧 cPanel-Specific Optimizations

### Enable Gzip Compression
1. **Find ".htaccess"** file in public_html (create if doesn't exist)
2. **Add this code**:
```apache
# Enable Gzip Compression
<IfModule mod_deflate.c>
    AddOutputFilterByType DEFLATE text/css
    AddOutputFilterByType DEFLATE application/javascript
    AddOutputFilterByType DEFLATE text/javascript
    AddOutputFilterByType DEFLATE text/html
</IfModule>

# Cache Static Files
<FilesMatch "\.(css|js|png|jpg|jpeg|gif|ico|svg)$">
    ExpiresActive On
    ExpiresDefault "access plus 1 year"
    Header append Cache-Control "public"
</FilesMatch>

# Security Headers
Header always set X-Frame-Options "SAMEORIGIN"
Header always set X-Content-Type-Options "nosniff"
Header always set X-XSS-Protection "1; mode=block"
```

### Create Custom Error Pages (Optional)
1. **Create `404.html`** in public_html:
```html
<!DOCTYPE html>
<html>
<head>
    <title>Page Not Found - PEIS Assessment</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; padding: 50px; }
        .error { color: #e74c3c; }
    </style>
</head>
<body>
    <h1 class="error">404 - Page Not Found</h1>
    <p>The page you're looking for doesn't exist.</p>
    <a href="/emotional-intelligence-scale.html">Go to PEIS Assessment</a>
</body>
</html>
```

2. **Add to .htaccess**:
```apache
ErrorDocument 404 /404.html
```

---

## 🔒 Security Setup in cPanel

### Password Protection (Optional)
If you want to restrict access to qualified professionals:

1. **Go to cPanel → "Password Protect Directories"**
2. **Select your PEIS directory**
3. **Enable password protection**
4. **Create authorized users**
5. **Set strong passwords**

### SSL Certificate
1. **Go to cPanel → "SSL/TLS"**
2. **Enable "Force HTTPS Redirect"**
3. **Install SSL certificate** (usually free with most hosts)

---

## 📊 Analytics Setup

### Google Analytics (Optional)
1. **Create Google Analytics account**
2. **Get tracking code**
3. **Edit `emotional-intelligence-scale.html`**
4. **Add tracking code** before `</head>` tag:
```html
<!-- Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=GA_TRACKING_ID"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'GA_TRACKING_ID');
</script>
```

---

## 🚀 Quick Setup Checklist

- [ ] **Login to cPanel**
- [ ] **Open File Manager**
- [ ] **Navigate to public_html**
- [ ] **Upload PEIS files** (ZIP method recommended)
- [ ] **Extract files** if uploaded as ZIP
- [ ] **Set permissions** (644 for files, 755 for folders)
- [ ] **Test website** at yoursite.com/emotional-intelligence-scale.html
- [ ] **Add .htaccess optimizations** (optional)
- [ ] **Enable SSL/HTTPS** (recommended)
- [ ] **Setup password protection** (if needed)

---

## 📱 Mobile Optimization

The PEIS assessment is already mobile-responsive, but you can verify:

1. **Test on mobile devices**
2. **Check tablet compatibility**
3. **Verify touch interactions work**
4. **Ensure text is readable**

---

## 🔍 Troubleshooting Common cPanel Issues

### Files Not Loading
- **Check file permissions** (644 for files, 755 for folders)
- **Verify file paths** are correct
- **Check for typos** in filenames

### CSS/JavaScript Not Working
- **Clear browser cache**
- **Check file permissions**
- **Verify .htaccess** isn't blocking files

### 500 Internal Server Error
- **Check .htaccess syntax**
- **Review error logs** in cPanel
- **Verify file permissions**

### Assessment Not Functioning
- **Check JavaScript console** for errors
- **Verify all files uploaded** correctly
- **Test in different browsers**

---

## 📞 Support Resources

### cPanel Documentation
- **File Manager Guide**: Available in cPanel help
- **Error Logs**: cPanel → Metrics → Error Logs
- **Bandwidth Usage**: Monitor in cPanel stats

### PEIS-Specific Help
- **User Manual**: `docs/USER-MANUAL.md`
- **Technical Issues**: Check browser console
- **Professional Support**: Contact for enterprise needs

---

## 🎯 Professional Deployment Tips

### For Clinical Use
1. **Use HTTPS** (SSL certificate)
2. **Regular backups** via cPanel
3. **Monitor access logs**
4. **Keep documentation updated**

### For Educational Institutions
1. **Password protect** if needed
2. **Setup subdomain** (peis.yourschool.edu)
3. **Integrate with LMS** if possible
4. **Train staff** on administration

### For Research Projects
1. **Document deployment** details
2. **Setup analytics** for usage tracking
3. **Regular data exports**
4. **Version control** for updates

---

## ✅ Success!

Once deployed, your PEIS assessment will be:
- ✅ **Accessible worldwide** at your domain
- ✅ **Mobile-friendly** and responsive
- ✅ **Secure** with HTTPS encryption
- ✅ **Professional** and ready for clinical use
- ✅ **HIPAA/FERPA compliant** (no data transmission)

**Your assessment URL**: `https://yoursite.com/emotional-intelligence-scale.html`

The PEIS tool is now live and ready for qualified professionals to use!
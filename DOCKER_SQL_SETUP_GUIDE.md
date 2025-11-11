# 🐳 Docker SQL Server Setup Guide

Complete guide to set up SQL Server in Docker and run the TempahanPhotoStudio database.

---

## 📋 Prerequisites

- Docker Desktop installed and running
- SQL Server Management Studio (SSMS) or Azure Data Studio (recommended for Mac)

---

## 🚀 Step 1: Run SQL Server in Docker

### For macOS/Linux:

```bash
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=YourStrong@Passw0rd" \
   -p 1433:1433 --name sqlserver \
   -d mcr.microsoft.com/mssql/server:2022-latest
```

### For Windows PowerShell:

```powershell
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=YourStrong@Passw0rd" `
   -p 1433:1433 --name sqlserver `
   -d mcr.microsoft.com/mssql/server:2022-latest
```

### Important Notes:
- **Password Requirements:** Must be at least 8 characters including uppercase, lowercase, numbers, and symbols
- **Port:** 1433 (SQL Server default port)
- **Container Name:** sqlserver (you can change this)

---

## ✅ Step 2: Verify SQL Server is Running

```bash
docker ps
```

You should see your `sqlserver` container running.

### Check Logs (if needed):
```bash
docker logs sqlserver
```

---

## 🔧 Step 3: Connect to SQL Server

### Option A: Using Azure Data Studio (Recommended for Mac)

1. **Download Azure Data Studio:**
   - Visit: https://aka.ms/azuredatastudio
   - Download and install

2. **Create New Connection:**
   - Click "New Connection"
   - **Server:** `localhost,1433` or `127.0.0.1,1433`
   - **Authentication type:** SQL Login
   - **User name:** `sa`
   - **Password:** `YourStrong@Passw0rd` (the one you set)
   - Click **Connect**

### Option B: Using SQL Server Management Studio (Windows)

1. Open SSMS
2. **Server name:** `localhost,1433`
3. **Authentication:** SQL Server Authentication
4. **Login:** `sa`
5. **Password:** Your password
6. Click **Connect**

---

## 📁 Step 4: Run the Database Setup

### Method 1: Using Azure Data Studio / SSMS

1. Open `COMPLETE_DATABASE_SETUP.sql` file
2. Make sure you're connected to your Docker SQL Server
3. Click **Run** or press `F5`
4. Wait for completion (should take ~10 seconds)

### Method 2: Using Command Line (sqlcmd)

First, install sqlcmd if you haven't:

**macOS:**
```bash
brew install sqlcmd
```

**Then run:**
```bash
sqlcmd -S localhost,1433 -U sa -P 'YourStrong@Passw0rd' \
  -i COMPLETE_DATABASE_SETUP.sql
```

---

## ✅ Step 5: Verify Database is Created

### Using GUI:
- Refresh the database list
- You should see **TempahanPhotoStudio** database

### Using SQL Query:
```sql
SELECT name FROM sys.databases WHERE name = 'TempahanPhotoStudio';
```

### Check Tables:
```sql
USE TempahanPhotoStudio;
GO

SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
```

You should see:
- bookings
- feedback
- packages
- sub_packages
- users

---

## 🔌 Step 6: Update Android App Connection

Update `ConnectionClass.java` in your Android app:

```java
// For Docker SQL Server on the SAME machine as Android Emulator
String ip = "10.0.2.2";  // Special IP for emulator to access host
String db = "TempahanPhotoStudio";
String username = "sa";
String password = "YourStrong@Passw0rd";  // Your Docker SQL password
String port = "1433";
```

### Important IP Addresses:

| Scenario | IP Address to Use |
|----------|-------------------|
| Android Emulator on same computer | `10.0.2.2` |
| Physical Android device on same WiFi | Your computer's local IP (e.g., `192.168.1.100`) |
| Remote server | Server's IP address or domain |

### To find your local IP (for physical device):

**macOS/Linux:**
```bash
ifconfig | grep "inet " | grep -v 127.0.0.1
```

**Windows:**
```cmd
ipconfig
```
Look for "IPv4 Address"

---

## 🎯 Default Login Credentials

After running the setup, you can use these accounts:

### Admin Account:
- **Email:** admin@photostudio.com
- **Password:** admin123
- **Role:** Admin

### Sample Customer Accounts:
- **Email:** ahmad@gmail.com | **Password:** password123
- **Email:** siti@gmail.com | **Password:** password123
- **Email:** ali@gmail.com | **Password:** password123

---

## 🛠️ Useful Docker Commands

### Start SQL Server (if stopped):
```bash
docker start sqlserver
```

### Stop SQL Server:
```bash
docker stop sqlserver
```

### Restart SQL Server:
```bash
docker restart sqlserver
```

### View SQL Server logs:
```bash
docker logs sqlserver -f
```

### Remove SQL Server container (⚠️ This deletes all data):
```bash
docker stop sqlserver
docker rm sqlserver
```

### Access SQL Server bash (for debugging):
```bash
docker exec -it sqlserver bash
```

---

## 📊 Database Summary

### Tables Created:
1. **users** - User accounts (Admin and Customers)
2. **packages** - Photography and Videography packages
3. **sub_packages** - Detailed package options with pricing
4. **bookings** - Customer bookings
5. **feedback** - Customer reviews

### Sample Data Included:
- ✅ 1 Admin user
- ✅ 3 Sample customers
- ✅ 12 Packages (7 Photography + 5 Videography)
- ✅ 26 Sub-packages with pricing
- ✅ 3 Sample feedback entries

---

## 🔍 Testing the Connection

### Test Query:
```sql
USE TempahanPhotoStudio;

-- View all packages
SELECT * FROM packages;

-- View all sub-packages with prices
SELECT p.package_name, sp.sub_package_name, sp.price 
FROM packages p
JOIN sub_packages sp ON p.id = sp.package_id
ORDER BY p.category, p.package_name;

-- View all users
SELECT id, name, email, role FROM users;
```

---

## ⚠️ Troubleshooting

### Issue: "Cannot connect to SQL Server"
**Solution:**
- Check Docker is running: `docker ps`
- Verify SQL Server container is running
- Try restarting: `docker restart sqlserver`
- Check firewall isn't blocking port 1433

### Issue: "Login failed for user 'sa'"
**Solution:**
- Verify password is correct
- Make sure password meets requirements (8+ chars, uppercase, lowercase, numbers, symbols)
- Try removing and recreating container with correct password

### Issue: Android app can't connect (10.0.2.2)
**Solution:**
- Make sure you're using Android Emulator (not physical device)
- For physical device, use your computer's local IP address
- Check SQL Server is allowing remote connections
- Verify port 1433 is not blocked

### Issue: "Database already exists" error
**Solution:**
The setup script automatically drops and recreates the database. If you get errors:
```sql
USE master;
ALTER DATABASE TempahanPhotoStudio SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE TempahanPhotoStudio;
GO
```
Then run the setup script again.

---

## 🔐 Security Notes

### For Development:
- ✅ Default passwords are fine for local development
- ✅ Docker container is only accessible on localhost by default

### For Production:
- ⚠️ Change the SA password to a strong unique password
- ⚠️ Create a dedicated database user (not sa)
- ⚠️ Use environment variables for passwords
- ⚠️ Enable SSL/TLS encryption
- ⚠️ Implement proper firewall rules

---

## 📚 Additional Resources

- **Azure Data Studio:** https://aka.ms/azuredatastudio
- **SQL Server Docker:** https://hub.docker.com/_/microsoft-mssql-server
- **sqlcmd Utility:** https://docs.microsoft.com/en-us/sql/tools/sqlcmd-utility

---

## ✅ Quick Start Checklist

- [ ] Docker Desktop installed and running
- [ ] SQL Server container running in Docker
- [ ] Azure Data Studio or SSMS installed
- [ ] Connected to SQL Server successfully
- [ ] Ran `COMPLETE_DATABASE_SETUP.sql`
- [ ] Verified database and tables exist
- [ ] Updated `ConnectionClass.java` with correct connection details
- [ ] Tested app connection

---

**Last Updated:** November 11, 2025  
**Database Name:** TempahanPhotoStudio  
**SQL Server Version:** 2022 (Docker)


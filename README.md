# 📸 TempahanPhotoStudio - Photo & Video Booking System

An Android mobile application for managing photography and videography studio bookings.

## 🎯 What is This?

**TempahanPhotoStudio** (Tempahan = Booking in Malay) is a complete booking management system that allows:

- **Customers** to browse and book photography/videography packages
- **Admins** to manage packages, bookings, and customer requests
- **Real-time** overlap prevention to avoid double bookings
- **Comprehensive** feedback system for customer reviews

## 🚀 Quick Start

### Prerequisites
- Android Studio
- Microsoft SQL Server
- Android SDK 24+ (Android 7.0 or higher)
- SQL Server with JTDS driver support

### Database Setup
1. Install Microsoft SQL Server
2. Create database named `TempahanPhotoStudio`
3. Run SQL scripts in this order:
   ```
   sql_files/database_setup.sql
   sql_files/create_users_table.sql
   sql_files/create_package_subpackage_tables.sql
   sql_files/create_bookings_table.sql
   sql_files/create_feedback_table.sql
   sql_files/add_photography_packages_to_database.sql
   sql_files/add_videography_data.sql
   sql_files/create_admin_user.sql
   ```

### Application Setup
1. Open project in Android Studio
2. Update database connection in `ConnectionClass.java`:
   - Change IP address (default: `10.0.2.2` for emulator)
   - Update username and password (default: `sa` / `12345`)
3. Sync Gradle
4. Run on emulator or physical device

## 📁 Project Structure

```
TempahanPhotoStudio/
├── app/                          # Android application code
│   ├── src/main/java/           # Java source files
│   │   ├── Activities/          # UI screens
│   │   ├── Models/              # Data models
│   │   ├── Adapters/            # RecyclerView adapters
│   │   └── ConnectionClass.java # Database operations
│   └── src/main/res/            # Resources (layouts, drawables)
├── sql_files/                   # All SQL scripts (116 files)
│   └── README.md               # SQL files documentation
├── PROJECT_ANALYSIS.md          # Complete project analysis
├── SQL_FILES_REFERENCE.md       # SQL files reference guide
├── SQL_FILES_LIST.txt          # Alphabetical SQL file list
└── README.md                   # This file
```

## ✨ Key Features

### 👥 User Management
- User registration and login
- Role-based access (User/Admin)
- Profile management with images
- Session management

### 📦 Package Management
- Photography packages
- Videography packages
- Sub-packages with pricing
- Package CRUD operations (Admin)

### 📅 Booking System
- Browse available packages
- Select date and time
- Real-time overlap prevention
- Booking status tracking (Paid/Unpaid/Cancelled/Completed)
- Invoice generation
- Payment method selection

### 📊 Admin Dashboard
- View all bookings
- Confirm/reject bookings
- Manage packages and sub-packages
- View customer information

### 💬 Feedback System
- Customer reviews and ratings
- Public feedback display
- Star rating system

## 🗄️ Database Schema

### Main Tables
- **users** - User accounts and profiles
- **packages** - Main service packages
- **sub_packages** - Detailed package options
- **bookings** - Booking records
- **feedback** - Customer reviews

## 📱 Screenshots

The app includes:
- Modern Material Design UI
- Gradient backgrounds
- Bottom navigation
- Card-based layouts
- Responsive design

## 🔧 Technology Stack

- **Language:** Java
- **Platform:** Android SDK (Min: 24, Target: 35)
- **Database:** Microsoft SQL Server
- **Database Driver:** JTDS 1.3.1
- **Image Loading:** Glide 4.16.0
- **UI:** Material Design Components

## 📚 Documentation

- **[PROJECT_ANALYSIS.md](PROJECT_ANALYSIS.md)** - Complete project overview and architecture
- **[SQL_FILES_REFERENCE.md](SQL_FILES_REFERENCE.md)** - Detailed SQL files guide
- **[SQL_FILES_LIST.txt](SQL_FILES_LIST.txt)** - All SQL files listing
- **[sql_files/README.md](sql_files/README.md)** - SQL files directory guide

## 🛠️ Development

### Key Components

1. **ConnectionClass.java** - Centralized database operations
2. **UserSessionManager.java** - Session management
3. **Models/** - Data structures for all entities
4. **Adapters/** - RecyclerView adapters for lists

### Activities (Screens)

- Login & Registration
- Dashboard (User/Admin)
- Package browsing
- Booking creation
- Booking history
- Profile management
- Feedback viewing

## 📊 SQL Files Organization

All **116 SQL files** have been organized into `sql_files/` directory:

- 5 Database setup files
- 11 Table creation files
- 12 Photography package files
- 4 Videography package files
- 7 Sub-package files
- 11 Price management files
- 13 User management files
- 16 Booking management files
- 6 Overlap prevention files
- 3 Feedback system files
- 15 Testing & debugging files
- 8 Data verification files
- 6 Table maintenance files

## 🔐 Security Notes

- Default database credentials are for development only
- Change passwords in production
- Review all SQL scripts before production deployment
- Implement proper password hashing in production

## 🚀 Future Enhancements

Potential improvements:
- Payment gateway integration
- Push notifications
- Email confirmations
- Multi-language support
- Advanced reporting
- Calendar view
- SMS notifications

## 👨‍💻 Developer

**Package:** com.kelasandroidappsirhafizee.tempahanphotostudio  
**Type:** Educational/Portfolio Project

## 📞 Support

For detailed information:
1. Read the [PROJECT_ANALYSIS.md](PROJECT_ANALYSIS.md)
2. Check [SQL_FILES_REFERENCE.md](SQL_FILES_REFERENCE.md)
3. Review code comments in source files

## 📝 License

Educational Project

---

**Last Updated:** November 11, 2025  
**Version:** 1.0  
**Status:** Active Development


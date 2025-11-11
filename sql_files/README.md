# SQL Files Directory

This directory contains **116 SQL files** for the TempahanPhotoStudio database.

## 📁 Purpose

All SQL scripts for database setup, table creation, data management, testing, and debugging for the Photo & Video Studio Booking System.

## 📚 Documentation

For detailed information about these files, please refer to:

- **[../PROJECT_ANALYSIS.md](../PROJECT_ANALYSIS.md)** - Complete project analysis and overview
- **[../SQL_FILES_REFERENCE.md](../SQL_FILES_REFERENCE.md)** - Detailed SQL files reference with categories
- **[../SQL_FILES_LIST.txt](../SQL_FILES_LIST.txt)** - Complete alphabetical listing of all files

## 🚀 Quick Start

To set up the database from scratch, run these files in order:

1. `database_setup.sql`
2. `create_users_table.sql`
3. `create_package_subpackage_tables.sql`
4. `create_bookings_table.sql`
5. `create_feedback_table.sql`
6. `add_photography_packages_to_database.sql`
7. `add_videography_data.sql`
8. `create_admin_user.sql`

## 📊 File Categories

- **Database Setup** (5 files) - Initial database creation
- **Table Creation** (11 files) - Create all tables
- **Photography Packages** (12 files) - Photography package management
- **Videography Packages** (4 files) - Videography package management
- **Sub-Packages** (7 files) - Sub-package management
- **Price Management** (11 files) - Price and amount handling
- **User Management** (13 files) - User accounts and profiles
- **Booking Management** (16 files) - Booking system
- **Overlap Prevention** (6 files) - Prevent double bookings
- **Feedback System** (3 files) - Customer reviews
- **Testing & Debugging** (15 files) - Testing scripts
- **Data Verification** (8 files) - Data integrity checks
- **Table Maintenance** (6 files) - Table modifications

## 🗄️ Database: TempahanPhotoStudio

**Database Server:** Microsoft SQL Server  
**Default Connection:**
- Host: `10.0.2.2` (Android emulator)
- Port: `1433`
- Username: `sa`
- Password: `12345`

## ⚠️ Important Notes

- Files prefixed with `test_` are for testing purposes only
- Files prefixed with `fix_` are for correcting issues
- Files prefixed with `debug_` are for debugging
- Files prefixed with `create_` create new database objects
- Files prefixed with `drop_` or `delete_` will remove data/tables

## 📝 Naming Convention

- **add_** - Add new data or columns
- **check_** - Verify data or structure
- **create_** - Create new tables or objects
- **debug_** - Debug specific issues
- **delete_** - Delete tables or data
- **drop_** - Drop tables or columns
- **fix_** - Fix existing issues
- **test_** - Test functionality
- **update_** - Update existing data
- **verify_** - Verify data integrity

## 🔐 Security Notes

- These scripts contain development database credentials
- Change default passwords in production
- Review scripts before executing in production environments
- Some scripts will drop tables and delete data

## 📞 Support

For questions or issues, refer to the main project documentation in the parent directory.

---

*Last Updated: November 11, 2025*
*Total Files: 116*


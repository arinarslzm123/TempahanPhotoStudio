# SQL Files Reference - TempahanPhotoStudio

This document provides a categorized reference for all 116 SQL files in the `sql_files/` directory.

---

## 📁 File Categories

### 🗄️ **Database Setup & Initialization** (5 files)

| File | Purpose |
|------|---------|
| `database_setup.sql` | Main database setup script |
| `complete_database_setup.sql` | Complete database initialization with all tables |
| `quick_database_setup.sql` | Quick setup for rapid deployment |
| `individual_table_queries.sql` | Individual table creation queries |
| `check_database_schema.sql` | Verify database schema structure |

---

### 📊 **Table Creation** (11 files)

| File | Purpose |
|------|---------|
| `users_table.sql` | Create users table |
| `packages_table.sql` | Create packages table |
| `sub_packages_table.sql` | Create sub-packages table |
| `bookings_table.sql` | Create bookings table |
| `create_users_table.sql` | Users table with constraints |
| `create_bookings_table.sql` | Bookings table with foreign keys |
| `create_feedback_table.sql` | Feedback/reviews table |
| `create_package_subpackage_tables.sql` | Both package tables |
| `create_complete_package_subpackage_system.sql` | Complete package system |
| `create_clean_tables.sql` | Clean table creation (drop if exists) |
| `create_videography_sub_package_table.sql` | Videography specific sub-packages |

---

### 📦 **Package Management - Photography** (12 files)

| File | Purpose |
|------|---------|
| `add_photography_packages.sql` | Add photography packages |
| `add_photography_packages_to_database.sql` | Insert photography data |
| `add_photography_packages_quick.sql` | Quick photography package insert |
| `fix_photography_packages_correct.sql` | Fix photography package data |
| `fix_photography_packages_now.sql` | Immediate photography fixes |
| `fix_photography_database.sql` | Repair photography database issues |
| `check_photography_data.sql` | Verify photography data |
| `test_photography_packages.sql` | Test photography packages |
| `check_and_fix_photography_packages.sql` | Check and repair photography |
| `fix_wrong_package_data.sql` | Fix incorrect package data |
| `drop_wrong_packages.sql` | Remove incorrect packages |
| `update_existing_packages.sql` | Update existing package records |

---

### 🎥 **Package Management - Videography** (4 files)

| File | Purpose |
|------|---------|
| `add_videography_data.sql` | Add videography package data |
| `add_videography_packages_first.sql` | Initial videography packages |
| `setup_videography_database.sql` | Setup videography database |
| `videography_database_setup.sql` | Complete videography setup |

---

### 📋 **Sub-Package Management** (7 files)

| File | Purpose |
|------|---------|
| `add_subpackages_for_existing_packages.sql` | Add sub-packages to packages |
| `add_subpackages_for_package_17.sql` | Add sub-packages for package ID 17 |
| `add_subpackages_if_missing.sql` | Add missing sub-packages |
| `check_subpackages_issue.sql` | Check for sub-package problems |
| `check_duplicate_sub_packages.sql` | Find duplicate sub-packages |
| `remove_duplicate_sub_packages.sql` | Remove duplicate sub-packages |
| `delete_package_subpackage_tables.sql` | Delete package/sub-package tables |

---

### 💰 **Price Management** (11 files)

| File | Purpose |
|------|---------|
| `add_price_columns.sql` | Add price columns to tables |
| `add_price_columns_to_database.sql` | Add price columns with data migration |
| `add_price_column_to_packages.sql` | Add price to packages table |
| `simple_add_price_columns.sql` | Simple price column addition |
| `quick_fix_price_columns.sql` | Quick fix for price columns |
| `update_existing_price_data.sql` | Update existing price data |
| `fix_all_total_amount_columns.sql` | Fix total_amount columns |
| `fix_packages_total_amount.sql` | Fix packages total_amount |
| `fix_sub_packages_total_amount.sql` | Fix sub-packages total_amount |
| `update_database_to_total_amount.sql` | Migrate to total_amount field |
| `test_database_columns.sql` | Test database column structure |

---

### 👤 **User Management** (13 files)

| File | Purpose |
|------|---------|
| `create_admin_user.sql` | Create admin user account |
| `simple_user_setup.sql` | Simple user table setup |
| `comprehensive_user_setup.sql` | Complete user setup with data |
| `ensure_user_data.sql` | Ensure user data exists |
| `insert_sample_user.sql` | Insert sample user for testing |
| `check_user_data.sql` | Verify user data |
| `add_phone_number_to_users_table.sql` | Add phone_number column |
| `add_profile_image_column.sql` | Add profile_image column |
| `fix_user_roles_and_profile.sql` | Fix user roles and profile data |
| `test_user_registration.sql` | Test user registration |
| `test_simple_registration.sql` | Simple registration test |
| `test_registration_process.sql` | Full registration process test |
| `verify_registration_connection.sql` | Verify registration connection |

---

### 📅 **Booking Management** (16 files)

| File | Purpose |
|------|---------|
| `test_booking_functionality.sql` | Test booking features |
| `test_updated_booking_functionality.sql` | Test updated booking features |
| `test_booking_database_insert.sql` | Test booking insertion |
| `test_booking_constructor_fix.sql` | Test booking constructor |
| `test_booking_activity_debug.sql` | Debug booking activity |
| `test_all_booking_methods.sql` | Test all booking methods |
| `test_booking_retrieval.sql` | Test booking retrieval |
| `verify_booking_flow.sql` | Verify complete booking flow |
| `test_admin_approval_workflow.sql` | Test admin approval |
| `test_admin_confirm_booking.sql` | Test admin confirm |
| `test_new_booking_pending_status.sql` | Test pending status |
| `verify_admin_booking_actions.sql` | Verify admin actions |
| `test_user_specific_bookings.sql` | Test user-specific bookings |
| `test_user_specific_bookings_debug.sql` | Debug user bookings |
| `test_user_specific_bookings_final.sql` | Final user bookings test |
| `debug_user_specific_bookings.sql` | Debug user bookings |

---

### ⚠️ **Overlap Prevention System** (6 files)

| File | Purpose |
|------|---------|
| `check_overlapping_bookings.sql` | Check for overlapping bookings |
| `test_overlapping_check_directly.sql` | Direct overlap check test |
| `fix_existing_overlapping_bookings.sql` | Fix existing overlaps |
| `add_unique_constraint_for_overlapping.sql` | Add unique constraints |
| `add_database_trigger_prevent_overlapping.sql` | Add trigger for overlap prevention |
| `normalize_and_add_unique_constraint.sql` | Normalize and add constraints |

---

### 💬 **Feedback System** (3 files)

| File | Purpose |
|------|---------|
| `create_feedback_table.sql` | Create feedback table |
| `feedback_table_queries.sql` | Feedback table queries |
| `check_and_remove_duplicate_feedback.sql` | Remove duplicate feedback |

---

### 🧪 **Testing & Debugging** (15 files)

| File | Purpose |
|------|---------|
| `test_database_connection.sql` | Test database connectivity |
| `test_database_connection_and_bookings.sql` | Test connection and bookings |
| `test_and_fix_database.sql` | Test and fix database issues |
| `test_user_login_profile_flow.sql` | Test login and profile flow |
| `test_user_profile_display.sql` | Test profile display |
| `test_package_subpackage_selection_flow.sql` | Test package selection |
| `test_date_format.sql` | Test date formats |
| `test_date_conversion_manual.sql` | Manual date conversion test |
| `test_name_field.sql` | Test name field |
| `test_packages_database.sql` | Test packages database |
| `test_packages_display.sql` | Test package display |
| `debug_database_error.sql` | Debug database errors |
| `debug_database_packages.sql` | Debug package issues |
| `debug_package_subpackage_matching.sql` | Debug package-subpackage matching |
| `view_complete_booking_data.sql` | View complete booking data |

---

### ✅ **Data Verification** (8 files)

| File | Purpose |
|------|---------|
| `verify_database_data.sql` | Verify all database data |
| `check_database_structure.sql` | Check database structure |
| `check_package_ids.sql` | Verify package IDs |
| `check_package_subpackage_relationship.sql` | Check package-subpackage relationships |
| `check_packages_table_structure.sql` | Verify packages table structure |
| `fix_database_issues.sql` | Fix general database issues |
| `complete_packages_database_fix.sql` | Complete package database fix |
| `fix_packages_table_structure.sql` | Fix packages table structure |

---

### 🗑️ **Table Maintenance** (6 files)

| File | Purpose |
|------|---------|
| `drop_tables.sql` | Drop all tables |
| `simple_delete_tables.sql` | Simple table deletion |
| `delete_tables_with_foreign_keys.sql` | Delete tables with foreign keys |
| `drop_columns_with_constraints.sql` | Drop columns with constraints |
| `drop_columns_and_create_tables.sql` | Drop columns and recreate |
| `update_packages_table_structure.sql` | Update packages table structure |

---

## 📈 File Statistics

- **Total SQL Files:** 116
- **Database Setup:** 5 files
- **Table Creation:** 11 files
- **Photography Packages:** 12 files
- **Videography Packages:** 4 files
- **Sub-Packages:** 7 files
- **Price Management:** 11 files
- **User Management:** 13 files
- **Booking Management:** 16 files
- **Overlap Prevention:** 6 files
- **Feedback System:** 3 files
- **Testing & Debugging:** 15 files
- **Data Verification:** 8 files
- **Table Maintenance:** 6 files

---

## 🔑 Key SQL Patterns Used

### 1. **Table Creation Pattern**
```sql
CREATE TABLE table_name (
    id INT IDENTITY(1,1) PRIMARY KEY,
    column_name DATATYPE,
    created_at DATETIME DEFAULT GETDATE()
);
```

### 2. **Foreign Key Pattern**
```sql
ALTER TABLE child_table 
ADD CONSTRAINT FK_name 
FOREIGN KEY (column_id) 
REFERENCES parent_table(id);
```

### 3. **Overlap Prevention Pattern**
```sql
SELECT COUNT(*) FROM bookings 
WHERE event_date = ? 
AND event_time = ? 
AND status NOT IN ('Cancelled', 'Completed');
```

### 4. **Data Migration Pattern**
```sql
-- Add column
ALTER TABLE table_name ADD column_name DATATYPE;

-- Update existing data
UPDATE table_name SET column_name = value WHERE condition;
```

### 5. **Testing Pattern**
```sql
-- Check data
SELECT * FROM table_name WHERE condition;

-- Verify count
SELECT COUNT(*) FROM table_name;

-- Check relationships
SELECT * FROM table1 t1
JOIN table2 t2 ON t1.id = t2.foreign_id;
```

---

## 🚀 Quick Start SQL Sequence

To set up the database from scratch, run these files in order:

1. `sql_files/database_setup.sql` - Create database
2. `sql_files/create_users_table.sql` - Create users table
3. `sql_files/create_package_subpackage_tables.sql` - Create package tables
4. `sql_files/create_bookings_table.sql` - Create bookings table
5. `sql_files/create_feedback_table.sql` - Create feedback table
6. `sql_files/add_photography_packages_to_database.sql` - Add photography packages
7. `sql_files/add_videography_data.sql` - Add videography packages
8. `sql_files/create_admin_user.sql` - Create admin account
9. `sql_files/insert_sample_user.sql` - Add sample user (optional)

---

## 🛠️ Common SQL Commands Reference

### Check All Tables
```sql
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE';
```

### View Table Structure
```sql
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'table_name';
```

### Check Foreign Keys
```sql
SELECT 
    fk.name AS FK_Name,
    tp.name AS Parent_Table,
    cp.name AS Parent_Column,
    tr.name AS Referenced_Table,
    cr.name AS Referenced_Column
FROM sys.foreign_keys AS fk
INNER JOIN sys.tables AS tp ON fk.parent_object_id = tp.object_id
INNER JOIN sys.foreign_key_columns AS fkc ON fk.object_id = fkc.constraint_object_id
INNER JOIN sys.columns AS cp ON fkc.parent_column_id = cp.column_id AND fkc.parent_object_id = cp.object_id
INNER JOIN sys.tables AS tr ON fk.referenced_object_id = tr.object_id
INNER JOIN sys.columns AS cr ON fkc.referenced_column_id = cr.column_id AND fkc.referenced_object_id = cr.object_id;
```

### Reset Identity Column
```sql
DBCC CHECKIDENT ('table_name', RESEED, 0);
```

---

## 📝 Notes

- All SQL files are designed for **Microsoft SQL Server**
- Files prefixed with `test_` are for testing purposes
- Files prefixed with `fix_` are for correcting issues
- Files prefixed with `debug_` are for debugging
- Files prefixed with `check_` are for verification
- Files prefixed with `add_` are for adding new data/columns
- Files prefixed with `create_` are for creating new tables/objects

---

## ⚡ SQL Best Practices Used

1. **Primary Keys:** All tables use `IDENTITY(1,1)` for auto-increment
2. **Foreign Keys:** Proper relationships between tables
3. **Timestamps:** `created_at` columns use `DATETIME DEFAULT GETDATE()`
4. **Data Types:** Appropriate use of INT, NVARCHAR, DECIMAL, DATETIME
5. **Constraints:** Unique constraints for email, overlap prevention
6. **Indexing:** Primary keys automatically indexed
7. **Normalization:** Proper table relationships (1-to-many, many-to-many)
8. **Transactions:** Used in complex operations
9. **Error Handling:** Try-catch in stored procedures
10. **Documentation:** Comments in SQL files

---

*All SQL files are located in: `/Applications/XAMPP/xamppfiles/htdocs/java/TempahanPhotoStudio/sql_files/`*

*Last Updated: November 11, 2025*


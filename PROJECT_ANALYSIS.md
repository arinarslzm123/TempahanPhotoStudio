# TempahanPhotoStudio - Project Analysis

## 📸 Project Overview

**TempahanPhotoStudio** is an Android mobile application for managing photo and videography studio bookings. It's a complete booking management system that allows customers to book photography and videography services, and administrators to manage those bookings.

**Application Name:** TempahanPhotoStudio (Tempahan = Booking in Malay)  
**Package:** `com.kelasandroidappsirhafizee.tempahanphotostudio`  
**Platform:** Android (Java)  
**Database:** Microsoft SQL Server (using JTDS driver)  
**Min SDK:** 24 (Android 7.0)  
**Target SDK:** 35 (Android 15)

---

## 🎯 Main Features

### 1. **User Authentication System**
- User registration with name, email, phone number, and password
- Login system with email and password validation
- Role-based access (User and Admin roles)
- User profile management with profile image support
- Session management

### 2. **Package Management System**
- **Two Package Categories:**
  - Photography packages
  - Videography packages
- **Package Structure:**
  - Main packages with categories (event type, duration)
  - Sub-packages with detailed pricing, descriptions, and media
- **Admin Features:**
  - Add, edit, and delete packages
  - Add, edit, and delete sub-packages
  - Manage package pricing and details

### 3. **Booking System**
- Browse available photography and videography packages
- View package details and sub-package options
- Select date and time for events
- Real-time overlapping booking prevention
- Booking status tracking:
  - **Paid** - Confirmed and paid bookings
  - **Unpaid** - Pending payment
  - **Cancelled** - Cancelled bookings
  - **Completed** - Finished events
- Payment method selection
- Invoice generation
- Notes and special requirements

### 4. **Booking Management**
- **User Features:**
  - View booking history with tabs:
    - Upcoming bookings
    - Past bookings
  - View detailed booking information
  - Cancel bookings
  - Generate and view invoices
  
- **Admin Features:**
  - View all bookings from all users
  - Confirm bookings (set to Paid)
  - Update booking status
  - View booking details with customer information

### 5. **Feedback System**
- Users can submit feedback/reviews
- Rating system (star ratings)
- Comments/testimonials
- Public feedback display for all users
- Timestamped feedback entries

### 6. **Overlap Prevention System**
- Prevents double-booking of the same date and time
- Multi-format date handling (YYYY-MM-DD, DD/MM/YYYY)
- Multi-format time handling (HH:mm, HHmm)
- Database-level validation
- Real-time availability checking
- Excludes cancelled and completed bookings from overlap checks

### 7. **Profile Management**
- View and update user profile
- Upload profile images
- Display user information (name, email, phone)
- Role-based UI (different views for Admin and User)

---

## 📊 Database Structure

### Core Tables:

1. **users**
   - id (INT, PRIMARY KEY, IDENTITY)
   - name (NVARCHAR)
   - email (NVARCHAR, UNIQUE)
   - password (NVARCHAR)
   - phone_number (NVARCHAR)
   - role (NVARCHAR) - 'User' or 'Admin'
   - profile_image (NVARCHAR)
   - created_at (DATETIME)

2. **packages**
   - id (INT, PRIMARY KEY, IDENTITY)
   - package_name (NVARCHAR)
   - event (NVARCHAR)
   - duration (NVARCHAR)
   - category (NVARCHAR) - 'Photography' or 'Videography'
   - created_at (DATETIME)

3. **sub_packages**
   - id (INT, PRIMARY KEY, IDENTITY)
   - package_id (INT, FOREIGN KEY → packages.id)
   - sub_package_name (NVARCHAR)
   - price (DECIMAL)
   - description (NVARCHAR)
   - duration (NVARCHAR)
   - media (NVARCHAR)
   - created_at (DATETIME)

4. **bookings**
   - id (INT, PRIMARY KEY, IDENTITY)
   - user_id (INT, FOREIGN KEY → users.id)
   - package_id (INT, FOREIGN KEY → packages.id)
   - sub_package_id (INT, FOREIGN KEY → sub_packages.id)
   - booking_date (NVARCHAR)
   - event_date (NVARCHAR)
   - event_time (NVARCHAR)
   - status (NVARCHAR) - 'Paid', 'Unpaid', 'Cancelled', 'Completed'
   - total_amount (DECIMAL)
   - payment_method (NVARCHAR)
   - payment_status (NVARCHAR) - 'Paid', 'Unpaid'
   - notes (NVARCHAR)
   - created_at (DATETIME)

5. **feedback**
   - id (INT, PRIMARY KEY, IDENTITY)
   - user_id (INT, FOREIGN KEY → users.id)
   - name (NVARCHAR)
   - comment (NVARCHAR)
   - rating (FLOAT)
   - created_at (DATETIME)

---

## 🗂️ SQL Files Organization

All 116 SQL files have been organized into the `sql_files/` folder. Here's the categorization:

### Database Setup Files (5 files)
- `database_setup.sql` - Main database setup
- `complete_database_setup.sql` - Complete initialization
- `quick_database_setup.sql` - Quick setup script
- `individual_table_queries.sql` - Individual table queries
- `check_database_schema.sql` - Schema verification

### Table Creation Files (10 files)
- `create_users_table.sql` - Users table
- `create_bookings_table.sql` - Bookings table
- `create_feedback_table.sql` - Feedback table
- `create_package_subpackage_tables.sql` - Package and sub-package tables
- `create_complete_package_subpackage_system.sql` - Complete package system
- `create_clean_tables.sql` - Clean table creation
- `create_videography_sub_package_table.sql` - Videography sub-packages
- `users_table.sql` - Users table definition
- `packages_table.sql` - Packages table definition
- `sub_packages_table.sql` - Sub-packages table definition
- `bookings_table.sql` - Bookings table definition

### Package Management Files (23 files)
- Photography package files (12):
  - `add_photography_packages.sql`
  - `add_photography_packages_to_database.sql`
  - `add_photography_packages_quick.sql`
  - `fix_photography_packages_correct.sql`
  - `fix_photography_packages_now.sql`
  - `fix_photography_database.sql`
  - `check_photography_data.sql`
  - `test_photography_packages.sql`
  - `check_and_fix_photography_packages.sql`
  - `fix_wrong_package_data.sql`
  - `drop_wrong_packages.sql`
  - `update_existing_packages.sql`

- Videography package files (4):
  - `add_videography_data.sql`
  - `add_videography_packages_first.sql`
  - `setup_videography_database.sql`
  - `videography_database_setup.sql`

- Sub-package files (7):
  - `add_subpackages_for_existing_packages.sql`
  - `add_subpackages_for_package_17.sql`
  - `add_subpackages_if_missing.sql`
  - `check_subpackages_issue.sql`
  - `check_duplicate_sub_packages.sql`
  - `remove_duplicate_sub_packages.sql`
  - `delete_package_subpackage_tables.sql`

### Price Management Files (11 files)
- `add_price_columns.sql`
- `add_price_columns_to_database.sql`
- `add_price_column_to_packages.sql`
- `simple_add_price_columns.sql`
- `quick_fix_price_columns.sql`
- `update_existing_price_data.sql`
- `fix_all_total_amount_columns.sql`
- `fix_packages_total_amount.sql`
- `fix_sub_packages_total_amount.sql`
- `update_database_to_total_amount.sql`
- `test_database_columns.sql`

### User Management Files (13 files)
- `create_admin_user.sql`
- `simple_user_setup.sql`
- `comprehensive_user_setup.sql`
- `ensure_user_data.sql`
- `insert_sample_user.sql`
- `check_user_data.sql`
- `add_phone_number_to_users_table.sql`
- `add_profile_image_column.sql`
- `fix_user_roles_and_profile.sql`
- `test_user_registration.sql`
- `test_simple_registration.sql`
- `test_registration_process.sql`
- `verify_registration_connection.sql`

### Booking Management Files (16 files)
- `test_booking_functionality.sql`
- `test_updated_booking_functionality.sql`
- `test_booking_database_insert.sql`
- `test_booking_constructor_fix.sql`
- `test_booking_activity_debug.sql`
- `test_all_booking_methods.sql`
- `test_booking_retrieval.sql`
- `verify_booking_flow.sql`
- `test_admin_approval_workflow.sql`
- `test_admin_confirm_booking.sql`
- `test_new_booking_pending_status.sql`
- `verify_admin_booking_actions.sql`
- `test_user_specific_bookings.sql`
- `test_user_specific_bookings_debug.sql`
- `test_user_specific_bookings_final.sql`
- `debug_user_specific_bookings.sql`

### Overlap Prevention Files (6 files)
- `check_overlapping_bookings.sql`
- `test_overlapping_check_directly.sql`
- `fix_existing_overlapping_bookings.sql`
- `add_unique_constraint_for_overlapping.sql`
- `add_database_trigger_prevent_overlapping.sql`
- `normalize_and_add_unique_constraint.sql`

### Feedback System Files (3 files)
- `create_feedback_table.sql`
- `feedback_table_queries.sql`
- `check_and_remove_duplicate_feedback.sql`

### Testing & Debugging Files (15 files)
- `test_database_connection.sql`
- `test_database_connection_and_bookings.sql`
- `test_and_fix_database.sql`
- `test_user_login_profile_flow.sql`
- `test_user_profile_display.sql`
- `test_package_subpackage_selection_flow.sql`
- `test_date_format.sql`
- `test_date_conversion_manual.sql`
- `test_name_field.sql`
- `test_packages_database.sql`
- `test_packages_display.sql`
- `debug_database_error.sql`
- `debug_database_packages.sql`
- `debug_package_subpackage_matching.sql`
- `view_complete_booking_data.sql`

### Data Verification Files (8 files)
- `verify_database_data.sql`
- `check_database_structure.sql`
- `check_package_ids.sql`
- `check_package_subpackage_relationship.sql`
- `check_packages_table_structure.sql`
- `fix_database_issues.sql`
- `complete_packages_database_fix.sql`
- `fix_packages_table_structure.sql`

### Table Maintenance Files (6 files)
- `drop_tables.sql`
- `simple_delete_tables.sql`
- `delete_tables_with_foreign_keys.sql`
- `drop_columns_with_constraints.sql`
- `drop_columns_and_create_tables.sql`
- `update_packages_table_structure.sql`

---

## 🏗️ Application Architecture

### Activities (Screens)

1. **Splash.java** - Splash screen (Launch screen)
2. **Login.java** - User login
3. **Register.java** - New user registration
4. **MainActivity.java** - Main entry point
5. **Dashboard.java** - Admin dashboard
6. **bottom_navigation.java** - Bottom navigation container

#### Package Management Screens
7. **ListPackageActivity.java** - List all packages (Admin)
8. **AddEditPackageActivity.java** - Add/Edit packages (Admin)
9. **ListSubPackageActivity.java** - List sub-packages (Admin)
10. **AddEditSubPackageActivity.java** - Add/Edit sub-packages (Admin)
11. **DetailSubPackageActivity.java** - View sub-package details
12. **VideographyPackageActivity.java** - Browse videography packages

#### Booking Screens
13. **BookingActivity.java** - Create new booking
14. **HistoryActivity.java** - Admin booking management
15. **UserBookingHistoryActivity.java** - User booking history
16. **InvoiceActivity.java** - View/Generate invoice
17. **PaymentActivity.java** - Payment processing

#### User Management Screens
18. **ProfileActivity.java** - User profile management
19. **FeedbackActivity.java** - View/Submit feedback

### Models (Data Classes)

1. **UserModel.java** - User data
2. **PackageModel.java** - Package data
3. **SubPackageModel.java** - Sub-package data
4. **BookingModel.java** - Booking data
5. **BookingDetailsModel.java** - Extended booking info
6. **FeedbackModel.java** - Feedback data

### Adapters (RecyclerView)

1. **PackageAdapter.java** - Display packages
2. **SubPackageAdapter.java** - Display sub-packages
3. **VideographyPackageAdapter.java** - Display videography packages
4. **BookingHistoryAdapter.java** - Display booking history (Admin)
5. **UserBookingAdapter.java** - Display user bookings
6. **FeedbackAdapter.java** - Display feedback

### Core Classes

1. **ConnectionClass.java** - Database connection and all CRUD operations
2. **UserSessionManager.java** - Session management

---

## 🔐 Key Technical Features

### Database Connection
- Uses **JTDS driver** for SQL Server connectivity
- Connection string: `jdbc:jtds:sqlserver://10.0.2.2:1433;databaseName=TempahanPhotoStudio`
- Default credentials: username: `sa`, password: `12345`
- Android emulator IP: `10.0.2.2` (maps to host's localhost)

### Overlap Prevention
- Multi-layer validation:
  1. Client-side checking
  2. Database query validation
  3. Final atomic check before insert
- Handles multiple date/time formats
- Trims whitespace for accurate comparison
- Excludes cancelled/completed bookings

### Image Handling
- Profile image upload support
- Package media storage
- Uses Glide library for image loading
- FileProvider for secure file sharing

### User Experience
- Material Design UI components
- RecyclerView for efficient list display
- Modern gradient backgrounds
- Responsive layouts
- Bottom navigation for easy access

---

## 📱 User Flows

### Customer Flow:
1. Register/Login
2. Browse Photography or Videography packages
3. Select a package and sub-package
4. Choose date and time (with overlap prevention)
5. Review booking details
6. Confirm booking
7. View invoice
8. Proceed to payment
9. View booking history
10. Submit feedback

### Admin Flow:
1. Login as Admin
2. View dashboard
3. Manage packages (Add/Edit/Delete)
4. Manage sub-packages (Add/Edit/Delete)
5. View all bookings
6. Confirm/Reject bookings
7. Update booking status
8. View customer information

---

## 🔧 Technology Stack

- **Language:** Java
- **Platform:** Android SDK 24-35
- **Database:** Microsoft SQL Server
- **Database Driver:** JTDS 1.3.1
- **Image Loading:** Glide 4.16.0
- **UI Components:** Material Design Components
- **Build System:** Gradle
- **IDE:** Android Studio

---

## 📝 Development Notes

### Database Evolution
The project shows extensive database development with:
- Multiple iterations of table structures
- Price column additions and fixes
- Overlap prevention implementations
- Feedback system integration
- User profile enhancements

### Testing
Comprehensive testing files indicate:
- Thorough testing of all features
- Debug queries for troubleshooting
- Data verification scripts
- Migration testing

### Code Quality
- Well-structured with clear separation of concerns
- Comprehensive error handling
- Extensive debug logging
- Resource cleanup (proper closing of database connections)

---

## 🎨 UI Highlights

- Modern Material Design
- Gradient backgrounds
- Circular profile images
- Card-based layouts
- Bottom navigation
- Tab layouts (Upcoming/Past bookings)
- Rating stars for feedback
- Custom drawables and icons

---

## 🚀 Deployment

The application connects to a local SQL Server database, suitable for:
- Development and testing
- Local network deployment
- Can be modified to connect to remote SQL Server for production

---

## 📈 Future Enhancement Possibilities

Based on the codebase structure:
1. Payment gateway integration (ToyyibPay mentioned in workspace)
2. Push notifications for booking confirmations
3. Image gallery for completed events
4. Multi-language support (already has Malay elements)
5. Calendar view for availability
6. Email confirmations
7. SMS notifications
8. Advanced reporting for admins
9. Booking history export
10. Customer analytics

---

## 📞 Contact & Attribution

**Developer:** kelasandroidappsirhafizee  
**Project:** TempahanPhotoStudio  
**Type:** Educational/Portfolio Project

---

*Generated: November 11, 2025*


# 🤖 Expert System - Separate Login Setup Guide

## Overview

Your Expert System now has a **independent login system** with full access control. The Expert is a system-level actor with separate credentials from regular users.

---

## ✅ What's Been Deployed

### Files Created:
- ✅ **expert_login.jsp** - Expert authentication page
- ✅ **expert_dashboard.jsp** - Expert control panel
- ✅ **ExpertServlet.java** - Authentication handler
- ✅ **ExpertDAO.java** - Database access layer

### Files Updated:
- ✅ **web.xml** - Added Expert servlet mapping

### Compilation Status:
- ✅ ExpertDAO.class - Compiled
- ✅ ExpertServlet.class - Compiled
- ✅ JSP files deployed to Tomcat

### Current Status:
- ✅ Expert login interface accessible
- ✅ Web.xml configured correctly
- ⏳ **Database tables pending setup** (manual SQL needed)

---

## 🗄️ Database Setup Required

### Option 1: Using phpMyAdmin (Easiest)

1. Open phpMyAdmin: http://localhost/phpmyadmin
2. Select database: `emovault`
3. Click **SQL** tab
4. Copy and paste the SQL below
5. Click **Go**

### Option 2: Using MySQL Command Line

```bash
cd C:\xampp\mysql\bin
mysql -u root -p emovault
-- Then paste the SQL below
```

### Option 3: Using MySQL Workbench

1. Connect to localhost:3306
2. Open Query tab  
3. Paste SQL below
4. Execute

---

## 📋 SQL Code to Execute

Copy and run this SQL code in your MySQL client:

```sql
-- Create expert_accounts table
CREATE TABLE IF NOT EXISTS expert_accounts (
    expert_id INT PRIMARY KEY AUTO_INCREMENT,
    expert_uid VARCHAR(50) UNIQUE NOT NULL,
    expert_name VARCHAR(100) NOT NULL,
    role VARCHAR(50) DEFAULT 'EXPERT',
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100),
    is_active TINYINT DEFAULT 1,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    INDEX idx_uid (expert_uid),
    INDEX idx_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create expert_activity_log table
CREATE TABLE IF NOT EXISTS expert_activity_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    expert_id INT NOT NULL,
    action VARCHAR(100) NOT NULL,
    details TEXT,
    ip_address VARCHAR(45),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (expert_id) REFERENCES expert_accounts(expert_id) ON DELETE CASCADE,
    INDEX idx_expert (expert_id),
    INDEX idx_action (action),
    INDEX idx_date (created_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default Expert account
-- Password: expert123 (PLEASE CHANGE THIS IMMEDIATELY)
INSERT INTO expert_accounts (expert_uid, expert_name, role, password_hash, email)
VALUES (
    'expert_main',
    'Expert System Admin',
    'ADMIN',
    '$2a$10$t.b5RLmTCcREE.bCdQQK.eVbGjKhC27p1CwPvEEzOgNeqCB.bLJ7m',
    'expert@emovault.local'
);

-- Log system initialization
INSERT INTO expert_activity_log (expert_id, action, details, ip_address)
SELECT expert_id, 'SYSTEM_INIT', 'Expert system initialized', '127.0.0.1'
FROM expert_accounts WHERE expert_uid = 'expert_main' LIMIT 1;
```

This SQL will:
- ✅ Create `expert_accounts` table for Expert credentials
- ✅ Create `expert_activity_log` table for action tracking
- ✅ Insert default Expert account (expert_main / expert123)
- ✅ Log system initialization

---

## 🚀 Next Steps After Database Setup

### 1. Access Expert Login Page
```
http://localhost:8080/EmoVault/expert_login.jsp
```

### 2. Login with Default Credentials
```
Expert ID: expert_main
Password: expert123
```

### 3. ⚠️ IMPORTANT: Change Default Password Immediately
After first login, change the password for security

### 4. Access Expert Dashboard
```
http://localhost:8080/EmoVault/expert_dashboard
```

---

## 📊 Expert System Architecture

```
┌─────────────────────────────────────────┐
│      Expert Login Page                  │
│   (expert_login.jsp)                   │
│  • Form for Expert ID + Password        │
│  • Separate from user login             │
│  • Session-based authentication         │
└──────────────┬──────────────────────────┘
               │ POST /expert_login
               ↓
┌─────────────────────────────────────────┐
│      ExpertServlet                      │
│  • Validates credentials                │
│  • Creates Expert session               │
│  • Handles logout                       │
│  • Redirects to dashboard               │
└──────────────┬──────────────────────────┘
               │ Query Database
               ↓
┌─────────────────────────────────────────┐
│      ExpertDAO                          │
│  • Queries expert_accounts table        │
│  • Verifies password hash               │
│  • Logs activity                        │
│  • Updates last login                   │
└──────────────┬──────────────────────────┘
               │
               ↓
┌─────────────────────────────────────────┐
│      MySQL Database                     │
│  • expert_accounts (authentication)     │
│  • expert_activity_log (audit trail)    │
└─────────────────────────────────────────┘
```

---

## 🔐 Security Features

### Authentication:
- ✅ Separate login from regular users
- ✅ Password hashing with bcrypt
- ✅ Session-based access control
- ✅ Activity logging for audit trail
- ✅ Remember-me cookie support (30 days)

### Access Control:
- ✅ Expert ID required
- ✅ Password verification
- ✅ Session timeout (30 minutes default)
- ✅ User IP tracking
- ✅ Action logging

### Database:
- ✅ expert_accounts table with proper indexes
- ✅ expert_activity_log for tracking
- ✅ Foreign key constraints
- ✅ Timestamps on all records

---

## 📝 Expert Servlet Endpoints

| URL | Method | Purpose |
|-----|--------|---------|
| `/expert_login` | POST | Handle Expert login |
| `/expert_login?action=logout` | GET | Logout Expert |
| `/expert_dashboard` | GET | Expert control panel |

---

## 📄 Verification Checklist

After setting up the database, verify:

- [ ] Navigate to http://localhost:8080/EmoVault/expert_login.jsp
- [ ] Expert login page loads without errors  
- [ ] Page displays "🤖 Expert System" header
- [ ] Form has Expert ID and Password fields
- [ ] Submit button is visible
- [ ] Run the SQL code to create tables
- [ ] Try logging in with expert_main / expert123
- [ ] Successfully redirected to expert_dashboard
- [ ] Dashboard shows Expert interface
- [ ] Logout button works correctly
- [ ] Returned to expert_login.jsp after logout

---

## 🔑 Default Credentials

**⚠️ WARNING: Change immediately after first login!**

```
Expert ID:  expert_main
Password:   expert123 (temporary)
Email:      expert@emovault.local
Role:       ADMIN
```

---

## 📜 Table Schemas

### expert_accounts
```
Field            | Type         | Details
-----------------+--------------+----------------------------------
expert_id        | INT          | PRIMARY KEY, AUTO_INCREMENT
expert_uid       | VARCHAR(50)  | UNIQUE, Expert username
expert_name      | VARCHAR(100) | Display name
role             | VARCHAR(50)  | ADMIN / EXPERT / ANALYST
password_hash    | VARCHAR(255) | Bcrypt hash (salted)
email            | VARCHAR(100) | Contact email
is_active        | TINYINT      | 0=disabled, 1=enabled
created_date     | TIMESTAMP    | Account creation time
last_login       | TIMESTAMP    | Last login time
```

### expert_activity_log
```
Field            | Type         | Details
-----------------+--------------+----------------------------------
log_id           | INT          | PRIMARY KEY, AUTO_INCREMENT
expert_id        | INT          | FK → expert_accounts
action           | VARCHAR(100) | LOGIN, LOGOUT, CREATE, UPDATE, etc.
details          | TEXT         | Action-specific details
ip_address       | VARCHAR(45)  | IPv4 or IPv6 address
created_date     | TIMESTAMP    | Action timestamp
```

---

## 🛠️ Troubleshooting

### Issue: "Expert login page not found"
**Solution:** Ensure expert_login.jsp is deployed to:
```
C:\xampp\tomcat\webapps\EmoVault\expert_login.jsp
```

### Issue: "Cannot find symbol" error when compiling
**Solution:** Ensure all Java files are in correct package structure:
```
src/com/emovault/servlet/ExpertServlet.java
src/com/emovault/dao/ExpertDAO.java
```

### Issue: Servlet not recognized
**Solution:** Verify web.xml has Expert servlet mapping:
```xml
<servlet-mapping>
    <servlet-name>ExpertServlet</servlet-name>
    <url-pattern>/expert_login</url-pattern>
</servlet-mapping>
```

### Issue: "Database connection failed"
**Solution:** Run the SQL code to create tables via phpMyAdmin:
```
http://localhost/phpmyadmin
```

### Issue: "Login fails with correct credentials"
**Solution:** 
1. Verify expert_accounts table exists
2. Check default Expert record was inserted
3. Verify password hash matches (check table directly)

---

## 📚 Related Features

The Expert System integrates with:
- ✅ Dashboard - Shows expert insights
- ✅ Habits - Generates expert suggestions  
- ✅ Patterns - Analyzes with expert rules
- ✅ Alerts - Expert-generated alerts
- ✅ Users - Separate Expert session from users

---

## ✨ Features Coming in Phase 2

- [ ] Expert settings panel
- [ ] Rule customization UI
- [ ] Suggestion history
- [ ] Performance analytics
- [ ] Multi-Expert support
- [ ] Role-based permissions
- [ ] Advanced audit logs

---

## 🎯 Quick Summary

1. **Database Setup:** Run the SQL code provided above
2. **Access Portal:** http://localhost:8080/EmoVault/expert_login.jsp
3. **Login:** expert_main / expert123
4. **Dashboard:** Full Expert control panel
5. **Separate:** Expert has independent login from regular users
6. **Secure:** Password-protected with activity logging

---

**Status: ✅ READY TO USE** (after database setup)

For more details, see the deployment documentation files.

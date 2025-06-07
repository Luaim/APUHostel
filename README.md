# APU Hostel Visitor Verification System

An enterprise-level, multi-tier web application developed for Asia Pacific University (APU) to manage and verify hostel visitors securely. The system streamlines visitor approvals and verification processes while providing dashboards and reporting for different user roles.

## 🚀 Features

### 👤 Authentication & Roles
- Role-based login: Managing Staff, Residents, Security Staff
- SHA-256 hashed password security
- Login lockout after multiple failed attempts

### 🏢 Managing Staff
- Manage all users (add, edit, delete staff/residents)
- Approve, reject, or delete visitor requests
- Generate visual reports (pie charts) by gender, status, etc.

### 🧍 Residents
- Register and manage profiles
- Submit visitor requests with auto-generated verification codes
- View request status and history

### 🛡️ Security Staff
- Verify visitor entries using verification codes
- Maintain visitor logs
- Edit personal profile

### 📊 Extra Functionalities
- Graphical reports with live data
- Verification code generator (5-digit unique code)
- Profile picture upload (with default fallback)
- Secure session handling and access control

---

## 🧱 Tech Stack

| Layer         | Technology |
|--------------|------------|
| Frontend     | JSP, HTML, CSS, JavaScript, jQuery, AJAX |
| Backend      | Servlets, EJB (Enterprise Java Beans), JDBC |
| Database     | MS SQL Server |
| Server       | GlassFish 7.0.9 |
| IDE          | NetBeans 24 |
| JDK          | JDK 23 (compiled to run on JDK 11 for GlassFish compatibility) |

---

## 🗂️ Project Structure

```
APUHostelSystem/
├── APUHostelSystem-ejb/          # EJB module (Business tier)
├── APUHostelSystem-war/          # Web module (JSPs, Servlets, CSS)
│   ├── web/Login/                # Login pages
│   ├── web/Residents/            # Resident pages
│   ├── web/ManagingStaff/        # Admin pages
│   ├── web/SecurityStaff/        # Security pages
│   └── web/uploads/              # Profile picture storage
├── src/java/servlet/             # Servlets
├── src/java/db/                  # DBConnection
└── SQLQuery2.sql                 # Database schema & queries
```

---
## 🗃️ Database Schema

- **Users**: Manages all user accounts and roles
- **Visitor_Requests**: Tracks submitted visitor entries
- **Requests_Log**: Approval/rejection records
- **Activity_Logs**: Visitor verification events

---

## 🛠️ Setup Instructions

1. Clone this repository:
   ```bash
   git clone https://github.com/Luaim/APUHostel.git
   ```
2. Open in **NetBeans 24**
3. Set JDK to **JDK 23**
4. Deploy to **GlassFish 7.0.9**
5. Import database from `SQLQuery2.sql` into **MS SQL Server**
6. Update DB connection string in `DBConnection.java` if needed

---

## 📜 License

This project is for academic purposes at APU. Feel free to explore, adapt, and improve upon it.

---

## 🙌 Author

**Luai **  
TP070855 | Asia Pacific University  
`Enterprise Programming for Distributed Application (CT027-3-3-EPDA)`

# 🎨 EmoVault - Emotional Intelligence & Personal Growth System

A **streamlined, beginner-friendly** Java web application for logging and tracking emotions. Built with modern gradient UI design and clean MVC architecture.

## ✨ Features (Phase 1)

- ✅ **User Authentication**: Register and login with email/password
- ✅ **Emotional Logging**: Record emotions with trigger, mood, intensity (1-10), and coping response
- ✅ **Modern Gradient UI**: Beautiful purple/pink/teal/orange theme with soft rounded cards
- ✅ **Session Management**: Secure HTTP session-based authentication (30-min timeout)
- ✅ **Form Validation**: Client-side (JavaScript) and server-side (Java) validation
- ✅ **Mobile Responsive**: Works seamlessly on desktop, tablet, and mobile devices

## 🛠️ Technology Stack

| Component | Technology |
|-----------|-----------|
| **Backend** | Java (JDK 8+) - Servlets & JSP |
| **Frontend** | JSP, HTML5, CSS3 (Custom Gradients) |
| **Database** | MySQL 5.7+ |
| **Server** | Apache Tomcat 9+ |
| **IDE** | VS Code |
| **Architecture** | MVC Pattern |
| **Security** | MD5 password hashing, SQL PreparedStatements |

## 📁 Project Structure

```
EmoVault/
├── src/com/emovault/
│   ├── dao/
│   │   ├── UserDAO.java           # User database operations
│   │   └── EmotionDAO.java        # Emotion entry operations
│   ├── servlet/
│   │   ├── RegisterServlet.java   # Registration controller
│   │   ├── LoginServlet.java      # Login controller
│   │   └── EmotionServlet.java    # Emotion logging controller
│   └── util/
│       ├── DBConnection.java      # JDBC connection utility
│       └── PasswordUtil.java      # Password hashing utility
│
├── WebContent/
│   ├── assets/css/
│   │   └── style.css              # Modern gradient theme
│   ├── login.jsp                  # Login page
│   ├── register.jsp               # Registration page
│   ├── emotion.jsp                # Emotion logging page
│   └── WEB-INF/
│       └── web.xml                # Servlet mappings
│
└── database/
    └── emovault_schema.sql        # MySQL schema (2 tables)
```

## 🚀 Setup Instructions

### Prerequisites

- **Java**: JDK 8 or higher
- **MySQL**: 5.7 or higher
- **Apache Tomcat**: 9.0 or higher
- **VS Code** (optional), or any Java-supporting IDE

### Step 1️⃣: Database Setup

Open MySQL CLI or Workbench and execute:

```sql
DROP DATABASE IF EXISTS emovault;
CREATE DATABASE emovault;
USE emovault;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE emotion_entries (
    entry_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    trigger VARCHAR(255) NOT NULL,
    mood VARCHAR(50) NOT NULL,
    intensity INT NOT NULL CHECK (intensity >= 1 AND intensity <= 10),
    response TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Insert demo user
INSERT INTO users (name, email, password) VALUES (
    'Demo User',
    'demo@emovault.com',
    '202cb962ac59075b964b07152d234b70'
);
```

### Step 2️⃣: Add MySQL JDBC Driver

1. Download [MySQL Connector/J](https://dev.mysql.com/downloads/connector/j/)
2. Extract the JAR file
3. Copy `mysql-connector-java-x.x.x.jar` to `WebContent/WEB-INF/lib/`

### Step 3️⃣: Configure Database Connection

Edit `src/com/emovault/util/DBConnection.java`:

```java
private static final String URL = "jdbc:mysql://localhost:3306/emovault";
private static final String USER = "root";
private static final String PASSWORD = ""; // Your MySQL password (if any)
```

### Step 4️⃣: Deploy to Tomcat

**Option A: Direct Copy**
```bash
# Copy WebContent folder to Tomcat
cp -r EmoVault/WebContent/* $TOMCAT_HOME/webapps/EmoVault/
cp -r EmoVault/src/com $TOMCAT_HOME/webapps/EmoVault/WEB-INF/classes/
```

**Option B: Create and Deploy WAR**
```bash
# Create WAR file
cd EmoVault/WebContent
jar cvf ../EmoVault.war *
cd ..

# Copy to Tomcat
cp EmoVault.war $TOMCAT_HOME/webapps/
```

**Option C: VS Code with Tomcat Extension**
1. Install "Tomcat for Java" extension
2. Right-click `WebContent` folder
3. Select "Run on Tomcat"

### Step 5️⃣: Start Tomcat

Windows:
```bash
%TOMCAT_HOME%\bin\catalina.bat start
```

Linux/Mac:
```bash
$TOMCAT_HOME/bin/catalina.sh start
```

### Step 6️⃣: Access Application

Open your browser and navigate to:
```
http://localhost:8080/EmoVault/login.jsp
```

**Demo Credentials**:
# Linux/Mac
$TOMCAT_HOME/bin/startup.sh

# Windows
$TOMCAT_HOME\bin\startup.bat
```

### Step 8: Access Application

Open browser and navigate to:
- **Home**: `http://localhost:8080/EmoVault/`
- **Login**: `http://localhost:8080/EmoVault/jsp/login.jsp`

## Default Credentials

A demo user is created automatically:
- **Username**: demouser
- **Password**: demo123
- **Email**: demo@emovault.com

## Core Modules Implemented

### 1. Authentication Module ✓
- User Registration
- User Login
- Session Management
- Logout

**Files**: 
- `LoginServlet`
- `login.jsp`
- `UserDAO`, `UserService`

## 🔌 API Endpoints

### Authentication Endpoints

#### **POST** `/register` - Register New User
```
Form Parameters:
- name: User full name (required)
- email: Email address (required, must be unique)
- password: Password (min 6 characters)
- confirmPassword: Confirm password (must match)

Response:
- Success: Redirect to /login.jsp
- Error: Display error message on register.jsp
```

#### **POST** `/login` - User Login
```
Form Parameters:
- email: Email address (required)
- password: Password (required)

Session Variables Set:
- userId: Integer (user_id from database)
- userEmail: String (user email)
- userName: String (user name)

Response:
- Success: Redirect to /emotion.jsp
- Error: Display error on login.jsp
```

#### **GET** `/login?action=logout` - Logout User
```
Response:
- Clears session
- Redirect to /login.jsp
```

### Emotion Logging Endpoints

#### **POST** `/emotion` - Save Emotion Entry
```
Form Parameters:
- trigger: What triggered the emotion (min 3 chars)
- mood: One of [Happy, Sad, Angry, Anxious, Calm, Frustrated]
- intensity: Integer 1-10
- response: How user coped (min 10 chars)

Session Required:
- userId (automatic check - redirects to login if missing)

Response:
- Success: Display success message, allow new entry
- Error: Display error message
```

#### **GET** `/emotion.jsp` - Emotion Logging Page
```
Session Required:
- userId (redirects to login if not authenticated)

Displays:
- Emotion entry form
- User greeting with name
- Logout button
```

---

## 2. Emotional Logging Module ✓
- Log emotions with mood, intensity, trigger, response
- View emotion history
- Basic pattern detection
- Analytics (average intensity, most frequent trigger)

**Files**:
- `EmotionEntryServlet`
- `emotional-logging.jsp`
- `emotion-history.jsp`
- `EmotionDAO`, `EmotionService`

### 3. Dashboard ✓
- Overview of all modules
- Quick links to features
- User profile information

**Files**:
- `dashboard.jsp`

### 4. Additional Modules (To Implement)

- **Diary Module**: `diary.jsp`
- **Habit Tracker**: `habits.jsp`, `HabitDAO`, `HabitService`
- **Risk Alerts**: `alerts.jsp`, `RiskAlertDAO`
- **Resilience Score**: `resilience.jsp`, `ResilienceScoreDAO`
- **Decision Support**: `decisions.jsp`, `DecisionDAO`
- **Time Capsule**: `time-capsule.jsp`, `TimeCapsuleDAO`

## Database Schema Overview

### Core Tables

| Table | Purpose |
|-------|---------|
| `users` | User accounts and profiles |
| `emotions` | Emotional entries |
| `diary_entries` | Free-form diary entries |
| `emotional_patterns` | Detected patterns |
| `regrets` | Regret tracking |
| `habits` | Habit definitions |
| `habit_logs` | Daily habit completion |
| `risk_alerts` | Generated alerts |
| `decisions` | Decision records |
| `conflicts` | Conflict resolution tracking |
| `time_capsules` | Future goals/messages |
| `resilience_scores` | Emotional resilience metrics |
| `suggestions` | Expert recommendations |
| `user_sessions` | Session tracking |
| `audit_logs` | System audit logs |

## REST API Endpoints (Servlets)

All endpoints use POST/GET methods via servlet mappings:

### Authentication
- `POST /login?action=login` - User login
- `POST /login?action=register` - User registration
- `GET /login?action=logout` - User logout

### Emotion Management
- `POST /emotion?action=log` - Log new emotion
- `GET /emotion?action=list` - View emotion history
- `POST /emotion?action=update` - Update emotion
- `POST /emotion?action=delete` - Delete emotion

## Key Classes

### Models
- `User` - User profile and authentication
- `Emotion` - Single emotion entry
- `DiaryEntry` - Diary entry
- `Habit` - Habit definition
- `Regret` - Regret entry
- `ResilienceScore` - Emotional resilience score

### Services
- `UserService` - User management business logic
- `EmotionService` - Emotion tracking and analysis

### DAOs
- `UserDAO` - User database operations
- `EmotionDAO` - Emotion database operations

### Utilities
- `DatabaseConnection` - MySQL connection pool
- `PasswordUtil` - Password hashing and verification
- `ValidationUtil` - Input validation

## Usage Examples

### Log an Emotion
1. Navigate to "Emotional Logging"
2. Select mood (happy, sad, angry, etc.)
3. Set intensity (1-10 scale)
4. Describe trigger (what caused the emotion)
5. Explain response (how you reacted)
6. Add optional notes
7. Click "Save Emotion Entry"

### View Emotion History
1. Go to "My Emotions"
2. View all logged emotions with timestamps
3. See statistics (average intensity, common triggers)
4. View detected patterns



## 🎨 UI Features

### Color Palette
```css
Primary Gradient: #667eea → #764ba2 (Purple)
Secondary Gradient: #f093fb → #f5576c (Pink to Red)
Accent Gradient: #4facfe → #00f2fe (Blue to Cyan)
Warm Gradient: #fa709a → #fee140 (Pink to Yellow)
```

### Design Elements
- Soft rounded corners (10-20px border-radius)
- Smooth shadows and transitions
- Mobile responsive layout
- Animated form submissions
- Interactive mood selector with radio buttons
- Intensity slider (1-10) with color gradient
- Premium minimal aesthetic
- Gen Z friendly but professional

---

## 📋 Form Validation

### Registration Form
```
✓ Name: Non-empty string
✓ Email: Valid email format, must be unique (checked server-side)
✓ Password: Minimum 6 characters
✓ Confirm Password: Must exactly match password field
✓ Client-side validation with real-time password match feedback
```

### Login Form
```
✓ Email: Valid email format
✓ Password: Non-empty
✓ Client-side validation with required field checks
```

### Emotion Logging Form
```
✓ Trigger: Non-empty (3+ characters)
✓ Mood: Must select one option
✓ Intensity: Integer between 1-10 (validated with HTML range)
✓ Response: Non-empty (10+ characters)
```

---

## 🔐 Security Features

- **SQL Injection Prevention**: All database queries use `PreparedStatement`
- **Password Hashing**: MD5 encryption (for college project; BCrypt recommended for production)
- **Session Management**: HttpSession with 30-minute timeout
- **Input Validation**: Both client-side (JavaScript) and server-side (Java)
- **Email Uniqueness**: Database UNIQUE constraint prevents duplicates
- **HTTPS Ready**: web.xml configured with session cookie security

---

## 🗄️ Database Details

### Users Table
```sql
user_id (INT, PK)
name (VARCHAR 100)
email (VARCHAR 100, UNIQUE)
password (VARCHAR 255)
created_at (TIMESTAMP)
updated_at (TIMESTAMP)
```

### Emotion Entries Table
```sql
entry_id (INT, PK)
user_id (INT, FK → users)
trigger (VARCHAR 255)
mood (VARCHAR 50)
intensity (INT, 1-10 range)
response (TEXT)
created_at (TIMESTAMP)
```

---

## 🛠️ Troubleshooting

| Issue | Solution |
|-------|----------|
| "No suitable driver found" | Ensure MySQL JAR is in `WEB-INF/lib/` |
| "404 Not Found" | Check JSP files are in `WebContent/`, not subdirectories |
| "Access denied for user" | Verify MySQL credentials in `DBConnection.java` |
| "CSS not loading" | Check file paths use `${pageContext.request.contextPath}` |
| "Session not persisting" | Enable cookies in browser, check 30-min timeout |
| "Password always fails" | Verify demo user exists with correct MD5 hash |

---

## 📚 DAO Methods Reference

### UserDAO
```java
registerUser(String name, String email, String password)
  → Returns: int (user_id) on success, -1 on failure
  
authenticateUser(String email, String password)
  → Returns: int (user_id) on success, -1 on failure
  
getUserName(int userId)
  → Returns: String (user name)
  
isEmailExists(String email)
  → Returns: boolean (true if email already registered)
```

### EmotionDAO
```java
saveEmotion(int userId, String trigger, String mood, int intensity, String response)
  → Returns: boolean (success/failure)
  
getUserEmotions(int userId)
  → Returns: List<Map<String, Object>> (all emotion entries for user)
  
getEmotionCount(int userId)
  → Returns: int (total emotion entries)
  
getMostFrequentMood(int userId)
  → Returns: String (most common mood)
```

---

## 🚀 Performance Tips

- Database indexes on `email` column for faster login
- Connection pooling in `DBConnection.java`
- Use `${pageContext.request.contextPath}` for dynamic path resolution
- CSS gradients are GPU-accelerated (no performance impact)
- JSP pages can be pre-compiled with Tomcat

---

## 📈 Future Enhancements (Phase 2+)

- **Emotion Analytics Dashboard**: Charts and statistics
- **Pattern Detection**: Automated mood pattern analysis
- **Habit Formation**: Create corrective habits
- **Regret Minimizer**: Learn from past mistakes
- **Risk Alerts**: Behavioral pattern warnings
- **Decision Support**: Historical data-driven recommendations
- **Time Capsule**: Store future goals and messages
- **Resilience Score**: Emotional stability metrics
- **Mobile App**: React Native or Flutter version

---

## 📝 Database Backup & Recovery

### Backup
```bash
mysqldump -u root emovault > emovault_backup.sql
```

### Restore
```bash
mysql -u root < emovault_backup.sql
```

---

## 👨‍💻 Development Workflow

1. **Create DAO** in `src/com/emovault/dao/`
2. **Create Servlet** in `src/com/emovault/servlet/`
3. **Add servlet mapping** to `web.xml`
4. **Create JSP page** in `WebContent/`
5. **Test locally** on Tomcat
6. **Deploy** to production server

---

## 📄 Important Files

| File | Purpose |
|------|---------|
| `DBConnection.java` | JDBC connection management |
| `PasswordUtil.java` | MD5 password hashing |
| `UserDAO.java` | User database operations |
| `EmotionDAO.java` | Emotion entry operations |
| `RegisterServlet.java` | Registration handler |
| `LoginServlet.java` | Login & session handler |
| `EmotionServlet.java` | Emotion logging handler |
| `style.css` | Modern gradient UI theme |
| `web.xml` | Tomcat configuration & servlet mappings |
| `emovault_schema.sql` | Database schema setup |

---

## 🔗 Useful Resources

- [Apache Tomcat Documentation](https://tomcat.apache.org/)
- [MySQL Documentation](https://dev.mysql.com/doc/)
- [Java Servlet & JSP Guide](https://docs.oracle.com/cd/E21764_01/web.1111/e13712/)
- [JDBC API Reference](https://docs.oracle.com/javase/8/docs/technotes/guides/jdbc/)
- [HTML5 Form Validation](https://developer.mozilla.org/en-US/docs/Learn/Forms/Form_validation)

---

## 💻 Sample Login Flow

```
1. User visits /login.jsp
2. Enters email & password
3. Form submits to LoginServlet (POST /login)
4. LoginServlet validates credentials
5. On success:
   - Create HttpSession
   - Set userId, userEmail, userName attributes
   - Redirect to /emotion.jsp
6. emotion.jsp checks session (userId exists)
7. Displays greeting and emotion form
8. User logs emotion entries
9. EmotionServlet saves to database
10. User can logout via /login?action=logout
```

---

## 🎓 Learning Outcomes

This project teaches:
- **Java Web Development**: Servlets, JSP, Sessions
- **Database Design**: Schema, relationships, constraints
- **Security**: Password hashing, SQL injection prevention
- **MVC Architecture**: Clean separation of concerns
- **Frontend**: HTML5, CSS3 gradients, JavaScript validation
- **Deployment**: Tomcat, WAR files, server configuration

---

**Created for educational purposes - Suitable for college mini-projects** 💜

**Ready to Deploy and Customize!** 🚀

# EmoVault Setup & Deployment Guide

## Quick Start (5 Steps)

### 1. Database Setup (2 minutes)
```sql
-- Open MySQL Command Line or Workbench
mysql -u root -p

-- Execute the schema
source D:\itsme\Workk\EmoVault\database\emovault_schema.sql

-- Verify
USE emovault;
SHOW TABLES;
SELECT * FROM users; -- Should show demo user
```

### 2. Configure Database Connection (1 minute)

Edit: `src/com/emovault/utils/DatabaseConnection.java`

```java
private static final String DB_URL = "jdbc:mysql://localhost:3306/emovault";
private static final String DB_USER = "root";  // Your MySQL username
private static final String DB_PASSWORD = ""; // Your MySQL password
```

### 3. Download and Add MySQL JDBC Driver (2 minutes)

1. Download: https://dev.mysql.com/downloads/connector/j/
2. Extract: `mysql-connector-java-8.0.xx-bin.jar`
3. Place in: `WebContent/WEB-INF/lib/`

### 4. Compile Java Code (3 minutes)

Using command prompt in project directory:

```bash
# Windows
mkdir build
cd src
javac -d ..\build -cp ".;..\WebContent\WEB-INF\lib\mysql-connector-java-8.0.xx-bin.jar" com\emovault\models\*.java com\emovault\dao\*.java com\emovault\services\*.java com\emovault\servlets\*.java com\emovault\utils\*.java com\emovault\listeners\*.java

# Or simply copy the src folder to your IDE and build there
```

### 5. Deploy to Tomcat (2 minutes)

**Option A: Copy entire WebContent folder**
```bash
Copy: D:\itsme\Workk\EmoVault\WebContent
To:   C:\Tomcat\webapps\EmoVault\
```

**Option B: Using IDE (VS Code, Eclipse, IntelliJ)**
1. Configure Tomcat Server Runtime
2. Deploy application
3. Run on server

**Option C: Create WAR and deploy**
```bash
# In project directory
jar cvf EmoVault.war -C WebContent .
jar uf EmoVault.war -C build .

# Copy to Tomcat
copy EmoVault.war C:\Tomcat\webapps\
```

## Starting Tomcat

### Windows
```bash
# Start Tomcat
C:\Tomcat\bin\startup.bat

# After application works, stop using:
C:\Tomcat\bin\shutdown.bat
```

### Linux/Mac
```bash
# Start Tomcat
/opt/tomcat/bin/startup.sh

# Stop Tomcat
/opt/tomcat/bin/shutdown.sh
```

### Check if Running
- Tomcat: `http://localhost:8080/manager/html`
- Application: `http://localhost:8080/EmoVault/`

## Accessing the Application

1. **Home Page**: `http://localhost:8080/EmoVault/`
2. **Login Page**: `http://localhost:8080/EmoVault/jsp/login.jsp`
3. **Demo Credentials**:
   - Username: `demouser`
   - Password: `demo123`

## Verify Installation

### Step 1: Check Database
```sql
USE emovault;
SELECT COUNT(*) FROM users; -- Should return 1
SELECT * FROM users; -- Should show demouser
```

### Step 2: Check File Structure
```
EmoVault/
├── src/ (compiled to build/)
├── WebContent/
│   ├── WEB-INF/
│   │   ├── web.xml ✓
│   │   └── lib/ (contains mysql-connector-java-*.jar) ✓
│   ├── jsp/ (all JSP files) ✓
│   ├── css/style.css ✓
│   └── index.html ✓
├── database/emovault_schema.sql ✓
└── README.md ✓
```

### Step 3: Verify in Tomcat
- Check: `C:\Tomcat\webapps\EmoVault\` exists
- Check: All files copied correctly
- Check: Tomcat logs show no errors

### Step 4: Test Application
1. Open `http://localhost:8080/EmoVault/`
2. Login with demouser / demo123
3. Navigate to "Emotional Logging"
4. Log a test emotion
5. View emotion history

## Troubleshooting

### Issue: "Cannot connect to database"

**Solution**:
```
1. Verify MySQL is running
   - Windows: Check Services or Run: mysql --version
   - Linux: sudo service mysql status

2. Test connection:
   mysql -h localhost -u root -p
   
3. Create database if not exists:
   source database/emovault_schema.sql
   
4. Update DatabaseConnection.java with correct credentials

5. Verify mysql-connector-java-*.jar is in lib folder
```

### Issue: "HTTP 404 - Page not found"

**Solution**:
```
1. Check application deployed to Tomcat:
   Should be at: C:\Tomcat\webapps\EmoVault\
   
2. Restart Tomcat

3. Check URL:
   Correct: http://localhost:8080/EmoVault/
   Wrong: http://localhost:8080/EmoVault.war
   
4. Check Tomcat logs: C:\Tomcat\logs\catalina.out
```

### Issue: "Invalid username or password"

**Solution**:
```
1. Verify demo user in database:
   USE emovault;
   SELECT * FROM users;
   
2. If not found, re-run schema:
   source database/emovault_schema.sql
   
3. Try credentials:
   Username: demouser
   Password: demo123
   
4. Check password hashing in PasswordUtil.java
   Hash of "demo123" should be: e807f1fcf82d132f9bb018ca6738a19f
```

### Issue: "500 Internal Server Error"

**Solution**:
```
1. Check Tomcat logs:
   C:\Tomcat\logs\catalina.out
   C:\Tomcat\logs\catalina.{date}.log
   
2. Check that all classes compiled successfully

3. Verify all imports in Java files are correct

4. Check database connection configuration

5. Check that JSP files syntax is correct
```

### Issue: "ClassNotFoundException: com.mysql.cj.jdbc.Driver"

**Solution**:
```
1. Download MySQL Connector/J from:
   https://dev.mysql.com/downloads/connector/j/
   
2. Extract the JAR file
   
3. Place in: WebContent/WEB-INF/lib/
   
4. Restart Tomcat
   
5. File should be named:
   mysql-connector-java-8.0.33.jar (or similar version)
```

## Project Structure Verification

```
D:\itsme\Workk\EmoVault\
│
├── src\com\emovault\
│   ├── models\
│   │   ├── User.java ✓
│   │   ├── Emotion.java ✓
│   │   ├── DiaryEntry.java ✓
│   │   ├── Habit.java ✓
│   │   ├── Regret.java ✓
│   │   └── ResilienceScore.java ✓
│   ├── dao\
│   │   ├── UserDAO.java ✓
│   │   └── EmotionDAO.java ✓
│   ├── services\
│   │   ├── UserService.java ✓
│   │   └── EmotionService.java ✓
│   ├── servlets\
│   │   ├── LoginServlet.java ✓
│   │   └── EmotionEntryServlet.java ✓
│   ├── utils\
│   │   ├── DatabaseConnection.java ✓
│   │   ├── PasswordUtil.java ✓
│   │   └── ValidationUtil.java ✓
│   └── listeners\
│       └── ApplicationListener.java ✓
│
├── WebContent\
│   ├── WEB-INF\
│   │   ├── web.xml ✓
│   │   └── lib\
│   │       └── mysql-connector-java-8.0.33.jar
│   ├── jsp\
│   │   ├── login.jsp ✓
│   │   ├── dashboard.jsp ✓
│   │   ├── emotional-logging.jsp ✓
│   │   ├── emotion-history.jsp ✓
│   │   ├── error.jsp ✓
│   │   └── (future modules)
│   ├── css\
│   │   └── style.css ✓
│   ├── js\
│   │   └── (JavaScript files)
│   ├── index.html ✓
│   └── images\
│
├── database\
│   └── emovault_schema.sql ✓
│
├── config\
│   └── DBConfig.properties ✓
│
├── docs\
│   └── (documentation)
│
└── README.md ✓
```

## Files Checklist

### Java Classes (12 files)
- [x] User.java
- [x] Emotion.java
- [x] DiaryEntry.java
- [x] Habit.java
- [x] Regret.java
- [x] ResilienceScore.java
- [x] UserDAO.java
- [x] EmotionDAO.java
- [x] UserService.java
- [x] EmotionService.java
- [x] LoginServlet.java
- [x] EmotionEntryServlet.java
- [x] ApplicationListener.java

### Utility Classes (3 files)
- [x] DatabaseConnection.java
- [x] PasswordUtil.java
- [x] ValidationUtil.java

### JSP Pages (6 files)
- [x] login.jsp
- [x] dashboard.jsp
- [x] emotional-logging.jsp
- [x] emotion-history.jsp
- [x] error.jsp
- [x] index.html

### Configuration Files (3 files)
- [x] web.xml
- [x] DBConfig.properties
- [x] MySQL schema (emovault_schema.sql)

### Documentation (2 files)
- [x] README.md
- [x] SETUP_GUIDE.md (this file)

### CSS & Assets (1 file)
- [x] style.css

## IDE Setup (VS Code)

### Install Extensions
1. Extension Pack for Java
2. Tomcat for Java
3. MySQL

### Configure Build Path
1. Create `.classpath` file in project root
2. Configure Tomcat server runtime
3. Set build output to `build/` folder

## IDE Setup (Eclipse)

### Create Dynamic Web Project
1. File → New → Dynamic Web Project
2. Project name: EmoVault
3. Target runtime: Apache Tomcat
4. Configure build path to include mysql-connector JAR
5. Copy files from src/ and WebContent/

## IDE Setup (IntelliJ IDEA)

### Create Web Application
1. File → New → Project
2. Choose "Java Enterprise"
3. Select "Web Application"
4. Configure Tomcat as application server
5. Configure artifacts for deployment

## Performance Tips

1. **Enable Compression in web.xml**:
```xml
<init-param>
    <param-name>useLookups</param-name>
    <param-value>false</param-value>
</init-param>
```

2. **Database Connection Pooling**: Implement HikariCP or Apache DBCP

3. **Caching**: Add Redis/Memcached for session storage

4. **JSP Precompilation**: Pre-compile JSPs before deployment

## Security Hardening

1. **Change Default Credentials**: Don't use demo password
2. **Enable HTTPS**: Configure Tomcat for SSL/TLS
3. **Implement BCrypt**: Replace MD5 with BCrypt for passwords
4. **Add CSRF Protection**: Implement CSRF tokens
5. **SQL Injection**: Already using PreparedStatements (good!)
6. **XSS Prevention**: Add output encoding in JSPs

## Next Steps

1. ✅ Complete setup and test
2. ⬜ Add more modules (diary, habits, etc.)
3. ⬜ Implement advanced pattern detection
4. ⬜ Add analytics dashboard
5. ⬜ Implement mobile app
6. ⬜ Add AI recommendations
7. ⬜ Deploy to cloud (AWS, Azure, GCP)

---

For detailed information, see README.md

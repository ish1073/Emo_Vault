# 🚀 Quick Start Guide - EmoVault

## ⚡ 5-Minute Setup

Follow these steps to get EmoVault running on your local machine.

---

## Step 1: MySQL Database Setup (2 minutes)

### Open MySQL and run:

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

INSERT INTO users (name, email, password) VALUES (
    'Demo User',
    'demo@emovault.com',
    '202cb962ac59075b964b07152d234b70'
);
```

✅ **Done!** You have created the database and a demo user.

---

## Step 2: Add MySQL Driver (1 minute)

1. Download: [MySQL Connector/J](https://dev.mysql.com/downloads/connector/j/)
2. Extract the JAR file (e.g., `mysql-connector-java-8.0.33.jar`)
3. Copy it to: `WebContent/WEB-INF/lib/`

✅ **Done!** JDBC driver is in place.

---

## Step 3: Deploy to Tomcat (2 minutes)

### Option A: Direct Folder Copy
```bash
# Copy the entire WebContent folder to Tomcat
cp -r d:/itsme/Workk/EmoVault/WebContent/* %TOMCAT_HOME%/webapps/EmoVault/

# Copy Java classes to WEB-INF
xcopy d:\itsme\Workk\EmoVault\src\com %TOMCAT_HOME%\webapps\EmoVault\WEB-INF\classes\com /E /I
```

### Option B: Deploy via VS Code
1. Install "Tomcat for Java" extension
2. Right-click on `WebContent` folder
3. Click "Run on Tomcat"

✅ **Done!** Application deployed.

---

## Step 4: Access Application

1. **Start Tomcat**:
   - Windows: `%TOMCAT_HOME%\bin\catalina.bat start`
   - Linux/Mac: `$TOMCAT_HOME/bin/catalina.sh start`

2. **Open Browser**:
   ```
   http://localhost:8080/EmoVault/login.jsp
   ```

3. **Login with Demo Account**:
   - 📧 Email: `demo@emovault.com`
   - 🔑 Password: `test123`

✅ **You're in!** 🎉

---

## 📝 What You Can Do

1. **Login** with the demo account above
2. **Create a new account** by filling the registration form
3. **Log emotions** by filling:
   - What triggered the emotion
   - Mood selection (Happy, Sad, Angry, Anxious, Calm, Frustrated)
   - Intensity level (1-10 slider)
   - How you responded/coped
4. **View your entries** (coming soon in Phase 2)
5. **Logout** when done

---

## 🛠️ Troubleshooting

### Problem: "404 Not Found"
**Solution**: Ensure JSP files are in `WebContent/` root, not `WebContent/jsp/`

### Problem: "Cannot connect to database"
**Solution**: 
- Verify MySQL is running
- Check credentials in `src/com/emovault/util/DBConnection.java`:
  ```java
  private static final String URL = "jdbc:mysql://localhost:3306/emovault";
  private static final String USER = "root";
  private static final String PASSWORD = "";
  ```

### Problem: "No suitable driver found"
**Solution**: MySQL JDBC JAR must be in `WebContent/WEB-INF/lib/`

### Problem: "Login always fails"
**Solution**: Check MySQL has the demo user:
```sql
USE emovault;
SELECT * FROM users;
```
Should show: `demo@emovault.com` with password hash `202cb962ac59075b964b07152d234b70`

---

## 📚 Project Structure

```
EmoVault/
├── src/com/emovault/
│   ├── dao/           → UserDAO.java, EmotionDAO.java
│   ├── servlet/       → LoginServlet, RegisterServlet, EmotionServlet
│   └── util/          → DBConnection.java, PasswordUtil.java
├── WebContent/
│   ├── login.jsp
│   ├── register.jsp
│   ├── emotion.jsp
│   ├── assets/css/style.css
│   └── WEB-INF/web.xml
└── database/
    └── emovault_schema.sql
```

---

## 🎨 Features Ready to Use

✅ **Registration** - Create new accounts with email validation  
✅ **Login** - Secure authentication with session management  
✅ **Emotion Logging** - Record emotions with mood, intensity, trigger, response  
✅ **Modern UI** - Beautiful gradient theme (Purple → Pink → Teal → Orange)  
✅ **Mobile Responsive** - Works on desktop, tablet, and mobile  
✅ **Form Validation** - Client-side and server-side validation  
✅ **Session Management** - 30-minute timeout for security  

---

## 🔐 Security

- ✅ SQL Injection Prevention (PreparedStatements)
- ✅ Password Hashing (MD5 for college, BCrypt recommended for production)
- ✅ Session Security (HttpOnly cookies)
- ✅ Input Validation (Both client & server)
- ✅ Email Uniqueness (Database constraint)

---

## 📞 Next Steps

1. **Test the application** with demo account
2. **Create your own account** to verify registration
3. **Log some emotion entries** to test the logging feature
4. **Explore the code** to understand the architecture
5. **Read README.md** for detailed documentation

---

## 💡 Tips

- The password "test123" hashes to `202cb962ac59075b964b07152d234b70` (MD5)
- All form inputs are validated on both client and server
- Emotions are saved to database with timestamp
- Session expires after 30 minutes of inactivity
- You can customize the color theme in `style.css`

---

## 🚀 Ready?

Go ahead and start the application! 

```
http://localhost:8080/EmoVault/login.jsp
```

**Welcome to EmoVault!** 💜

---

**Questions?** Refer to the detailed [README.md](README.md) for complete documentation.

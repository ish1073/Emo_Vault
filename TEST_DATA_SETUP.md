# ✨ EmoVault Test Data Setup Guide

## Quick Start - 2 Steps to See Features Working

### Step 1: Create Test Data
1. **Go to this URL in your browser:**
   ```
   http://localhost:8080/EmoVault/setup-test-data
   ```

2. **Wait for the setup to complete** - You'll see a success message with login credentials

### Step 2: Log In and Explore
1. **Log in with these test credentials:**
   - Email: `testuser@example.com`
   - Password: `test123`

2. **Now you can access:**
   - 🧠 **Behavior Analyzer** - Shows emotional insights based on your emotion logs
   - ⏰ **Time Capsule** - View past reflections on time capsules
   - 📊 **Analytics & Reports** - See charts of your emotional patterns
   - 📔 **Diary** - View past diary entries
   - 🎯 **Habits** - Track your habits

---

## What Gets Created

The test data setup creates:

### Emotions (8 entries)
- Various emotions (Happy, Sad, Stressed, Excited, etc.)
- Spanning the past 8 days
- With different intensity levels

### Time Capsules (3 capsules)
- ✅ 2 opened capsules WITH reflections
- 🔒 1 locked capsule (unlocks in 60 days)
- All with sample reflection data

### Reflections
- Test reflections showing:
  - What changed since opening
  - Your current mood
  - Achievement status

### Diary Entries (5 entries)
- Sample diary entries with moods
- Different dates across the week

### Habits (4 habits)
- Morning Meditation (7-day streak)
- Evening Exercise (3-day streak)
- Journaling (5-day streak)
- Reading (inactive)

### Regrets (3 regrets)
- Sample regrets with lessons learned
- Tagged by category (communication, health, relationships)

---

## Accessing Each Feature

### 🧠 Behavior Analyzer
1. Log in with test credentials
2. Click "Behavior Analyzer" in the sidebar
3. See:
   - Your dominant emotion
   - Risk level assessment
   - Detected behavior patterns
   - Personalized suggestions

**Why it works:** Test data includes 8 emotions from the past week - analyzer needs minimum 3 entries in the past 30 days.

### ⏰ Time Capsule
1. Log in with test credentials
2. Click "Time Capsule" in the sidebar
3. See:
   - **Opened Capsules** section showing past reflections
   - **Ready to Open** section for capsules you can open
   - **Locked Capsules** section for future capsules

4. To add your own reflection:
   - Click "Add Reflection" on any opened capsule
   - Fill in the reflection form
   - Submit

### 📊 Analytics & Reports
1. Log in with test credentials
2. Click "Analytics" in the sidebar
3. See charts of:
   - Emotion distribution (pie chart)
   - Emotion trends over time (line chart)
   - Summary statistics

---

## Troubleshooting

### "Not enough data yet" message on Behavior Analyzer
- ✅ This means you need at least 3 emotion entries
- ✅ The test data setup should create 8 entries automatically
- If still seeing this: Run the test data setup again

### Can't see past reflections
- ✅ Make sure you're logged in
- ✅ Go to Time Capsule section
- ✅ Look for "Opened Capsules" at the bottom
- ✅ Reflections show in the reflection section of each opened capsule

### Database password issues
- If setup fails due to database errors:
  1. Ensure XAMPP MySQL is running
  2. Check MySQL is on port 3306
  3. Verify database name is `emovault_db`
  4. Try the setup again

---

## Creating Real Data

After testing with test data, you can create your own:

1. **Log out of test account**
2. **Register your own account** via the Register page
3. **Start logging emotions** in the Emotion Log
4. **Add diary entries** in Diary
5. **Create time capsules** in Time Capsule
6. **Wait 3+ days** for Behavior Analyzer to start working

---

## Database Reset

To clear test data and start fresh:
1. Delete the test user from the users table
2. Or: Drop the entire database and recreate it
3. Run the setup again

---

## Additional Notes

- **Test data is all sample/demo data** - No personal information
- **You can add more emotions** by logging them in the Emotion section
- **Reflections are saved** once you submit the form
- **Data persists** even after logout - it's in the database
- **You can create multiple test accounts** with different usernames

---

**Need help?** Check the browser console (F12) for any error messages, or verify Tomcat is running with the correct database connection.

#!/usr/bin/env python3
"""
EmoVault Test Data Setup Script
Populates database with sample data for testing
Usage: python setup_test_data.py
"""

import mysql.connector
import sys
from datetime import datetime, timedelta

# Database configuration
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': 'Password123',
    'database': 'emovault_db',
    'port': 3306
}

def create_connection():
    """Create database connection"""
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        return conn
    except mysql.connector.Error as err:
        if err.errno == 2003:
            print("❌ Error: Cannot connect to MySQL")
            print("   - Ensure XAMPP is running")
            print("   - Check MySQL is on port 3306")
        else:
            print(f"❌ Database error: {err}")
        sys.exit(1)

def get_or_create_user(conn, cursor):
    """Get or create test user"""
    email = "testuser@example.com"
    
    # Check if user exists
    cursor.execute("SELECT user_id FROM users WHERE email = %s", (email,))
    result = cursor.fetchone()
    
    if result:
        user_id = result[0]
        print(f"✓ Found existing user: {email} (ID: {user_id})")
        return user_id
    
    # Create new user
    cursor.execute(
        "INSERT INTO users (name, email, password) VALUES (%s, %s, %s)",
        ("Test User", email, "test123")
    )
    conn.commit()
    user_id = cursor.lastrowid
    print(f"✓ Created new user: {email} (ID: {user_id})")
    return user_id

def create_emotions(conn, cursor, user_id):
    """Create test emotion entries"""
    moods = ["Stressed", "Happy", "Sad", "Excited", "Calm", "Anxious", "Peaceful", "Frustrated"]
    intensities = [7, 8, 6, 9, 4, 6, 5, 8]
    
    for i, (mood, intensity) in enumerate(zip(moods, intensities)):
        created_at = datetime.now() - timedelta(days=i)
        cursor.execute(
            "INSERT INTO emotions (user_id, mood, intensity, trigger, response, created_at) VALUES (%s, %s, %s, %s, %s, %s)",
            (user_id, mood, intensity, f"Trigger {i+1}", f"Response {i+1}", created_at)
        )
    
    conn.commit()
    print(f"✓ Created 8 emotion entries")

def create_capsules(conn, cursor, user_id):
    """Create test time capsules with reflections"""
    # Capsule 1 - opened with reflection
    cursor.execute(
        """INSERT INTO time_capsules 
        (user_id, message, goal, mood, target_date, opened, reflection, reflection_mood, achievement_status, opened_at) 
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)""",
        (
            user_id,
            "Achieve better work-life balance",
            "Improve daily routine",
            "Hopeful",
            datetime.now() - timedelta(days=30),
            True,
            "I've made good progress! Started better routine and feel less stressed.",
            "Grateful",
            "Partially",
            datetime.now() - timedelta(days=5)
        )
    )
    
    # Capsule 2 - locked
    cursor.execute(
        """INSERT INTO time_capsules 
        (user_id, message, goal, mood, target_date, opened) 
        VALUES (%s, %s, %s, %s, %s, %s)""",
        (
            user_id,
            "Build presentation confidence",
            "Overcome presentation anxiety",
            "Determined",
            datetime.now() + timedelta(days=60),
            False
        )
    )
    
    # Capsule 3 - opened with reflection
    cursor.execute(
        """INSERT INTO time_capsules 
        (user_id, message, goal, mood, target_date, opened, reflection, reflection_mood, achievement_status, opened_at) 
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)""",
        (
            user_id,
            "Build meditation habit",
            "Daily 10-minute meditation",
            "Peaceful",
            datetime.now() - timedelta(days=15),
            True,
            "Successfully meditating 5 days a week. Feeling more peaceful.",
            "Peaceful",
            "Achieved",
            datetime.now() - timedelta(days=10)
        )
    )
    
    conn.commit()
    print(f"✓ Created 3 time capsules with reflections")

def create_diary(conn, cursor, user_id):
    """Create test diary entries"""
    entries = [
        ("Monday Reflection", "Started week with energy. Completed meditation.", "Hopeful"),
        ("Productive Day", "Had amazing day at work. Positive feedback!", "Excited"),
        ("Challenging Moments", "Had conflicts but resolved them. Better now.", "Calm"),
        ("Weekend Peace", "Relaxing weekend with family. Recharged!", "Peaceful"),
        ("New Insights", "Realized exercise helps my stress. Need more!", "Calm")
    ]
    
    for i, (title, content, mood) in enumerate(entries):
        created_at = datetime.now() - timedelta(days=i)
        cursor.execute(
            "INSERT INTO diary_entries (user_id, title, content, mood, created_at) VALUES (%s, %s, %s, %s, %s)",
            (user_id, title, content, mood, created_at)
        )
    
    conn.commit()
    print(f"✓ Created 5 diary entries")

def create_habits(conn, cursor, user_id):
    """Create test habits"""
    habits = [
        ("Morning Meditation", 7, True, 85.0),
        ("Evening Exercise", 3, True, 65.0),
        ("Journaling", 5, True, 75.0),
        ("Reading", 0, False, 45.0)
    ]
    
    for i, (title, streak, active, score) in enumerate(habits):
        created_at = datetime.now() - timedelta(days=10*(i+1))
        cursor.execute(
            "INSERT INTO habits (user_id, title, streak, is_active, consistency_score, created_at) VALUES (%s, %s, %s, %s, %s, %s)",
            (user_id, title, streak, active, score, created_at)
        )
    
    conn.commit()
    print(f"✓ Created 4 habits")

def create_regrets(conn, cursor, user_id):
    """Create test regrets"""
    regrets = [
        ("Postponed important meeting", "Communication delays cause problems", "communication"),
        ("Skipped exercise for 3 days", "Exercise helps with stress", "health"),
        ("Said something hurtful", "Take a break before responding", "relationships")
    ]
    
    for i, (desc, lesson, tag) in enumerate(regrets):
        created_date = datetime.now() - timedelta(days=(i+1)*2)
        cursor.execute(
            "INSERT INTO regrets (user_id, description, lesson_learned, tag, created_date) VALUES (%s, %s, %s, %s, %s)",
            (user_id, desc, lesson, tag, created_date)
        )
    
    conn.commit()
    print(f"✓ Created 3 regrets")

def main():
    """Main setup function"""
    print("\n" + "="*50)
    print("EmoVault Test Data Setup")
    print("="*50 + "\n")
    
    # Connect to database
    print("Connecting to database...")
    conn = create_connection()
    cursor = conn.cursor()
    
    try:
        # Create test user
        user_id = get_or_create_user(conn, cursor)
        
        # Create test data
        print("\nCreating test data...")
        create_emotions(conn, cursor, user_id)
        create_capsules(conn, cursor, user_id)
        create_diary(conn, cursor, user_id)
        create_habits(conn, cursor, user_id)
        create_regrets(conn, cursor, user_id)
        
        print("\n" + "="*50)
        print("✅ Test data created successfully!")
        print("="*50 + "\n")
        
        print("LOGIN CREDENTIALS:")
        print("  Email: testuser@example.com")
        print("  Password: test123\n")
        
        print("You can now:")
        print("  1. Log in to EmoVault")
        print("  2. Go to Behavior Analyzer to see insights")
        print("  3. Go to Time Capsule to see reflections")
        print("  4. Go to Analytics for charts")
        
    except Exception as e:
        print(f"\n❌ Error: {e}")
        sys.exit(1)
    finally:
        cursor.close()
        conn.close()

if __name__ == "__main__":
    main()

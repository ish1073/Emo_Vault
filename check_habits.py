import mysql.connector
from mysql.connector import errorcode

try:
    cnx = mysql.connector.connect(
        host="localhost",
        user="emovault_user",
        password="emovault123",
        database="emovault_db"
    )
    
    cursor = cnx.cursor()
    
    # Check if habits table exists
    cursor.execute("SHOW TABLES LIKE 'habits'")
    if cursor.fetchone():
        print("✓ Habits table exists")
        
        # Get all habits
        cursor.execute("SELECT habit_id, user_id, name, description, is_active, created_date FROM habits LIMIT 10")
        habits = cursor.fetchall()
        
        print(f"\n✓ Found {len(habits)} habits in database")
        
        if habits:
            print("\nHabits in database:")
            print("-" * 80)
            for habit in habits:
                print(f"ID: {habit[0]}, User: {habit[1]}, Name: {habit[2]}, Active: {habit[4]}")
        else:
            print("⚠ No habits found in database")
    else:
        print("✗ Habits table does not exist!")
        
    cursor.close()
    cnx.close()
    
except mysql.connector.Error as err:
    if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        print("✗ Something is wrong with your user name or password")
    elif err.errno == errorcode.ER_BAD_DB_ERROR:
        print("✗ Database does not exist")
    else:
        print(f"✗ Error: {err}")
except Exception as e:
    print(f"✗ Unexpected error: {e}")

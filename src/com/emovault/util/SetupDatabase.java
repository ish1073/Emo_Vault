package com.emovault.util;

import java.sql.*;

public class SetupDatabase {
    public static void main(String[] args) {
        try {
            // Load MySQL driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Connect to database
            String url = "jdbc:mysql://localhost:3306/emovault";
            String user = "root";
            String password = "";
            
            Connection conn = DriverManager.getConnection(url, user, password);
            System.out.println("✓ Connected to database");
            
            // Create tables
            createTables(conn);
            
            conn.close();
            System.out.println("✓ Database setup complete!");
            
        } catch (Exception e) {
            System.err.println("✗ Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private static void createTables(Connection conn) throws SQLException {
        Statement stmt = conn.createStatement();
        
        // Create regrets table
        stmt.execute("CREATE TABLE IF NOT EXISTS regrets (" +
                "regret_id INT PRIMARY KEY AUTO_INCREMENT," +
                "user_id INT NOT NULL," +
                "description VARCHAR(500) NOT NULL," +
                "lesson_learned VARCHAR(500)," +
                "tag VARCHAR(50) NOT NULL," +
                "created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                "FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE," +
                "INDEX (user_id)," +
                "INDEX (tag))");
        System.out.println("✓ Created regrets table");
        
        // Create habits table
        stmt.execute("CREATE TABLE IF NOT EXISTS habits (" +
                "habit_id INT PRIMARY KEY AUTO_INCREMENT," +
                "user_id INT NOT NULL," +
                "name VARCHAR(200) NOT NULL," +
                "description VARCHAR(500)," +
                "suggested_by_tag VARCHAR(50)," +
                "is_active BOOLEAN DEFAULT TRUE," +
                "created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                "FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE," +
                "INDEX (user_id))");
        System.out.println("✓ Created habits table");
        
        // Create habit_logs table
        stmt.execute("CREATE TABLE IF NOT EXISTS habit_logs (" +
                "log_id INT PRIMARY KEY AUTO_INCREMENT," +
                "habit_id INT NOT NULL," +
                "completed_date DATE NOT NULL," +
                "is_completed BOOLEAN DEFAULT TRUE," +
                "FOREIGN KEY (habit_id) REFERENCES habits(habit_id) ON DELETE CASCADE," +
                "UNIQUE KEY unique_habit_date (habit_id, completed_date)," +
                "INDEX (completed_date))");
        System.out.println("✓ Created habit_logs table");
        
        // Create alerts table
        stmt.execute("CREATE TABLE IF NOT EXISTS alerts (" +
                "alert_id INT PRIMARY KEY AUTO_INCREMENT," +
                "user_id INT NOT NULL," +
                "alert_type VARCHAR(50) NOT NULL," +
                "message VARCHAR(500) NOT NULL," +
                "is_read BOOLEAN DEFAULT FALSE," +
                "created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                "FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE," +
                "INDEX (user_id)," +
                "INDEX (is_read))");
        System.out.println("✓ Created alerts table");
        
        stmt.close();
    }
}

package com.emovault.util;

import java.sql.*;

public class DatabaseInitializer {
    
    /**
     * Initialize database tables - convenience method for servlets
     * Gets connection and initializes all required tables
     */
    public static boolean initializeDatabase() {
        Connection connection = null;
        try {
            connection = DBConnection.getConnection();
            if (connection != null) {
                return initializeTables(connection);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        return false;
    }
    
    /**
     * Initialize all required tables for new modules
     * Called on application startup
     */
    public static boolean initializeTables(Connection connection) {
        try {
            DatabaseMetaData dbmd = connection.getMetaData();
            
            // Check and create regrets table
            if (!tableExists(dbmd, "regrets")) {
                createRegretsTable(connection);
            }
            
            // Check and create habits table
            if (!tableExists(dbmd, "habits")) {
                createHabitsTable(connection);
            }
            
            // Check and create habit_logs table
            if (!tableExists(dbmd, "habit_logs")) {
                createHabitLogsTable(connection);
            }
            
            // Check and create alerts table
            if (!tableExists(dbmd, "alerts")) {
                createAlertsTable(connection);
            }
            
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    private static boolean tableExists(DatabaseMetaData dbmd, String tableName) throws SQLException {
        ResultSet rs = dbmd.getTables(null, null, tableName, null);
        boolean exists = rs.next();
        rs.close();
        return exists;
    }
    
    private static void createRegretsTable(Connection connection) throws SQLException {
        String sql = "CREATE TABLE regrets (" +
                "regret_id INT PRIMARY KEY AUTO_INCREMENT," +
                "user_id INT NOT NULL," +
                "description VARCHAR(500) NOT NULL," +
                "lesson_learned VARCHAR(500)," +
                "tag VARCHAR(50) NOT NULL," +
                "created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                "FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE," +
                "INDEX (user_id)," +
                "INDEX (tag)" +
                ")";
        try (Statement stmt = connection.createStatement()) {
            stmt.execute(sql);
            System.out.println("✓ Created regrets table");
        }
    }
    
    private static void createHabitsTable(Connection connection) throws SQLException {
        String sql = "CREATE TABLE habits (" +
                "habit_id INT PRIMARY KEY AUTO_INCREMENT," +
                "user_id INT NOT NULL," +
                "name VARCHAR(200) NOT NULL," +
                "description VARCHAR(500)," +
                "suggested_by_tag VARCHAR(50)," +
                "is_active BOOLEAN DEFAULT TRUE," +
                "created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                "FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE," +
                "INDEX (user_id)" +
                ")";
        try (Statement stmt = connection.createStatement()) {
            stmt.execute(sql);
            System.out.println("✓ Created habits table");
        }
    }
    
    private static void createHabitLogsTable(Connection connection) throws SQLException {
        String sql = "CREATE TABLE habit_logs (" +
                "log_id INT PRIMARY KEY AUTO_INCREMENT," +
                "habit_id INT NOT NULL," +
                "completed_date DATE NOT NULL," +
                "is_completed BOOLEAN DEFAULT TRUE," +
                "FOREIGN KEY (habit_id) REFERENCES habits(habit_id) ON DELETE CASCADE," +
                "UNIQUE KEY unique_habit_date (habit_id, completed_date)," +
                "INDEX (completed_date)" +
                ")";
        try (Statement stmt = connection.createStatement()) {
            stmt.execute(sql);
            System.out.println("✓ Created habit_logs table");
        }
    }
    
    private static void createAlertsTable(Connection connection) throws SQLException {
        String sql = "CREATE TABLE alerts (" +
                "alert_id INT PRIMARY KEY AUTO_INCREMENT," +
                "user_id INT NOT NULL," +
                "alert_type VARCHAR(50) NOT NULL," +
                "message VARCHAR(500) NOT NULL," +
                "is_read BOOLEAN DEFAULT FALSE," +
                "created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                "FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE," +
                "INDEX (user_id)," +
                "INDEX (is_read)" +
                ")";
        try (Statement stmt = connection.createStatement()) {
            stmt.execute(sql);
            System.out.println("✓ Created alerts table");
        }
    }
}

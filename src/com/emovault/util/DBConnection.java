package com.emovault.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Database Connection Utility
 * Handles MySQL connection setup for EmoVault application
 */
public class DBConnection {
    
    //MySQL Configuration - XAMPP MySQL 8.0
    private static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    // Try multiple connection strategies for XAMPP compatibility
    private static final String[] DB_URLS = {
        "jdbc:mysql://localhost:3306/emovault_db?user=emovault_user&password=emovault123&useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true",
        "jdbc:mysql://127.0.0.1:3306/emovault_db?user=emovault_user&password=emovault123&useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true",
        "jdbc:mysql://localhost:3306/emovault_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true"
    };
    private static final String DB_USER = "emovault_user";
    private static final String DB_PASSWORD = "emovault123";
    
    /**
     * Get connection to database
     * @return Connection object
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName(JDBC_DRIVER);
            
            // Try each connection strategy
            SQLException lastError = null;
            for (String url : DB_URLS) {
                try {
                    System.out.println("[DBConnection] Attempting: " + url);
                    Connection conn = DriverManager.getConnection(url);
                    System.out.println("[DBConnection] Connection successful!");
                    return conn;
                } catch (SQLException e) {
                    System.err.println("[DBConnection] Failed: " + e.getMessage());
                    lastError = e;
                }
            }
            
            // If all failed, throw the last error
            if (lastError != null) {
                throw lastError;
            }
            
            throw new SQLException("Could not establish database connection");
            
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found!");
            e.printStackTrace();
            throw new SQLException("Database driver not found");
        }
    }
    
    /**
     * Close database connection
     * @param conn Connection to close
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}

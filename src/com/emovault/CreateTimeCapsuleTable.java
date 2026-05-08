package com.emovault;

import com.emovault.util.DBConnection;
import java.sql.Connection;
import java.sql.Statement;

public class CreateTimeCapsuleTable {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection()) {
            Statement stmt = conn.createStatement();
            
            String createTableSQL = "CREATE TABLE IF NOT EXISTS time_capsules (" +
                "capsule_id INT PRIMARY KEY AUTO_INCREMENT," +
                "user_id INT NOT NULL," +
                "message LONGTEXT NOT NULL," +
                "goal VARCHAR(500)," +
                "mood VARCHAR(100)," +
                "target_date TIMESTAMP NOT NULL," +
                "opened BOOLEAN DEFAULT 0," +
                "reflection LONGTEXT," +
                "reflection_mood VARCHAR(100)," +
                "achievement_status VARCHAR(50)," +
                "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                "opened_at TIMESTAMP NULL," +
                "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE," +
                "INDEX (user_id)," +
                "INDEX (target_date)" +
                ")";
            
            stmt.executeUpdate(createTableSQL);
            System.out.println("[CreateTimeCapsuleTable] ✓ Time Capsule table created successfully!");
            
        } catch (Exception e) {
            System.err.println("[CreateTimeCapsuleTable] Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}

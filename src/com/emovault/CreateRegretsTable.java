package com.emovault;

import com.emovault.util.DBConnection;
import java.sql.Connection;
import java.sql.Statement;

public class CreateRegretsTable {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection()) {
            Statement stmt = conn.createStatement();
            
            String createTableSQL = "CREATE TABLE IF NOT EXISTS regrets (" +
                "regret_id INT PRIMARY KEY AUTO_INCREMENT," +
                "user_id INT NOT NULL," +
                "description VARCHAR(500) NOT NULL," +
                "lesson_learned VARCHAR(500)," +
                "tag VARCHAR(50) NOT NULL," +
                "created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE," +
                "INDEX (user_id)," +
                "INDEX (tag)" +
                ")";
            
            stmt.executeUpdate(createTableSQL);
            System.out.println("[CreateRegretsTable] ✓ Regrets table created successfully!");
            
        } catch (Exception e) {
            System.err.println("[CreateRegretsTable] Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}

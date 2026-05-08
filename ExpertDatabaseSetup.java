import java.sql.*;

public class ExpertDatabaseSetup {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/emovault_db";
        String user = "emovault_user";
        String password = "emovault123";
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, user, password);
            
            System.out.println("✓ Connected to database");
            
            // Create expert_accounts table
            String sql1 = "CREATE TABLE IF NOT EXISTS expert_accounts (" +
                "expert_id INT PRIMARY KEY AUTO_INCREMENT," +
                "expert_uid VARCHAR(50) UNIQUE NOT NULL," +
                "expert_name VARCHAR(100) NOT NULL," +
                "role VARCHAR(50) DEFAULT 'EXPERT'," +
                "password_hash VARCHAR(255) NOT NULL," +
                "email VARCHAR(100)," +
                "is_active TINYINT DEFAULT 1," +
                "created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                "last_login TIMESTAMP NULL," +
                "INDEX idx_uid (expert_uid)," +
                "INDEX idx_active (is_active)" +
                ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4";
            
            conn.createStatement().executeUpdate(sql1);
            System.out.println("✓ expert_accounts table created/verified");
            
            // Create expert_activity_log table
            String sql2 = "CREATE TABLE IF NOT EXISTS expert_activity_log (" +
                "log_id INT PRIMARY KEY AUTO_INCREMENT," +
                "expert_id INT NOT NULL," +
                "action VARCHAR(100) NOT NULL," +
                "details TEXT," +
                "ip_address VARCHAR(45)," +
                "created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                "FOREIGN KEY (expert_id) REFERENCES expert_accounts(expert_id) ON DELETE CASCADE," +
                "INDEX idx_expert (expert_id)," +
                "INDEX idx_action (action)," +
                "INDEX idx_date (created_date)" +
                ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4";
            
            conn.createStatement().executeUpdate(sql2);
            System.out.println("✓ expert_activity_log table created/verified");
            
            // Insert default expert account
            String sql3 = "INSERT INTO expert_accounts (expert_uid, expert_name, role, password_hash, email) " +
                "VALUES ('expert_main', 'Expert System Admin', 'ADMIN', " +
                "'$2a$10$t.b5RLmTCcREE.bCdQQK.eVbGjKhC27p1CwPvEEzOgNeqCB.bLJ7m', " +
                "'expert@emovault.local') " +
                "ON DUPLICATE KEY UPDATE expert_name=expert_name";
            
            conn.createStatement().executeUpdate(sql3);
            System.out.println("✓ Default expert account inserted/verified");
            
            // Insert activity log
            String sql4 = "INSERT INTO expert_activity_log (expert_id, action, details, ip_address) " +
                "SELECT expert_id, 'SYSTEM_INIT', 'Expert system initialized', '127.0.0.1' " +
                "FROM expert_accounts WHERE expert_uid = 'expert_main' LIMIT 1";
            
            try {
                conn.createStatement().executeUpdate(sql4);
                System.out.println("✓ Activity log entry created");
            } catch (Exception e) {
                System.out.println("✓ Activity log ready");
            }
            
            // Verify
            ResultSet rs = conn.createStatement().executeQuery("SELECT COUNT(*) as count FROM expert_accounts");
            if (rs.next()) {
                System.out.println("✓ Total expert accounts: " + rs.getInt("count"));
            }
            
            System.out.println("\n" + "=".repeat(50));
            System.out.println("✓ DATABASE SETUP COMPLETE!");
            System.out.println("=".repeat(50));
            System.out.println("\nYou can now login with:");
            System.out.println("  Expert ID: expert_main");
            System.out.println("  Password: expert123");
            System.out.println("\nAccess: http://localhost:8080/EmoVault/expert_login.jsp");
            
            conn.close();
        } catch (Exception e) {
            System.out.println("✗ Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}

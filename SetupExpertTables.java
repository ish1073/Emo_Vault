import java.sql.*;

public class SetupExpertTables {
    public static void main(String[] args) {
        Connection conn = null;
        try {
            // Load MySQL driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Try different connection strings with credentials in URL
            String[] connectionStrings = {
                "jdbc:mysql://127.0.0.1:3306/emovault?user=root&password=&useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true",
                "jdbc:mysql://localhost:3306/emovault?user=root&password=&useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true",
                "jdbc:mysql://localhost:3306/emovault?useSSL=false&serverTimezone=UTC"
            };
            
            for (String url : connectionStrings) {
                try {
                    // Credentials in URL string
                    conn = DriverManager.getConnection(url);
                    System.out.println("✓ Connected to database");
                    break;
                } catch (Exception e) {
                    // Continue to next connection string
                    System.out.println("  Trying next connection method...");
                }
            }
            
            if (conn == null) {
                System.err.println("Failed to connect to database. Please check MySQL is running.");
                System.exit(1);
            }
            
            Statement stmt = conn.createStatement();
            
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
            
            stmt.execute(sql1);
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
            
            stmt.execute(sql2);
            System.out.println("✓ expert_activity_log table created/verified");
            
            // Check if default expert account exists
            ResultSet rs = stmt.executeQuery("SELECT expert_id FROM expert_accounts WHERE expert_uid = 'expert_main' LIMIT 1");
            
            if (!rs.next()) {
                // Default password hash for 'expert123'
                String hash = "$2a$10$t.b5RLmTCcREE.bCdQQK.eVbGjKhC27p1CwPvEEzOgNeqCB.bLJ7m";
                String insertSQL = "INSERT INTO expert_accounts (expert_uid, expert_name, role, password_hash, email) " +
                    "VALUES ('expert_main', 'Expert System Admin', 'ADMIN', '" + hash + "', 'expert@emovault.local')";
                stmt.execute(insertSQL);
                System.out.println("✓ Default Expert account created");
                System.out.println("  ID: expert_main");
                System.out.println("  Password: expert123 (CHANGE THIS AFTER LOGIN!)");
            } else {
                System.out.println("ℹ Default Expert account already exists");
            }
            
            stmt.close();
            conn.close();
            
            System.out.println("\n✓ Expert System database setup complete!");
            System.out.println("\nNEXT STEPS:");
            System.out.println("1. Access http://localhost:8080/EmoVault/expert_login.jsp");
            System.out.println("2. Login with:");
            System.out.println("   Expert ID: expert_main");
            System.out.println("   Password: expert123");
            System.out.println("3. Change the password immediately!");
            
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}

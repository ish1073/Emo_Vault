import java.sql.*;

public class TestConnection {
    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("Loading driver successful");
            
            String url = "jdbc:mysql://127.0.0.1:3306/?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
            Connection conn = DriverManager.getConnection(url, "root", "");
            System.out.println("Connection successful!");
            
            // Create database if not exists
            Statement stmt = conn.createStatement();
            stmt.execute("CREATE DATABASE IF NOT EXISTS emovault");
            System.out.println("Database created/verified");
            
            // Test table creation
            stmt.execute("USE emovault");
            stmt.execute("CREATE TABLE IF NOT EXISTS users (" +
                "user_id INT AUTO_INCREMENT PRIMARY KEY," +
                "name VARCHAR(100) NOT NULL," +
                "email VARCHAR(100) UNIQUE NOT NULL," +
                "password VARCHAR(255) NOT NULL" +
                ")");
            System.out.println("Users table created/verified");
            
            // Insert demo user
            stmt.execute("INSERT IGNORE INTO users (user_id, name, email, password) VALUES " +
                "(1, 'Demo User', 'demo@emovault.com', '202cb962ac59075b964b07152d234b70')");
            System.out.println("Demo user created/verified");
            
            // Check data
            ResultSet rs = stmt.executeQuery("SELECT * FROM users WHERE email = 'demo@emovault.com'");
            if (rs.next()) {
                System.out.println("Found user: " + rs.getString("email") + " with hash: " + rs.getString("password"));
            }
            
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

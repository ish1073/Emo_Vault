import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.*;

public class DiagnoseLogin {
    
    public static String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] messageDigest = md.digest(password.getBytes());
            StringBuilder hexString = new StringBuilder();
            for (byte b : messageDigest) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/emovault_db";
        String user = "emovault_user";
        String password = "emovault123";
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, user, password);
            
            System.out.println("✓ Connected to database\n");
            
            // 1. Check if users table exists
            System.out.println("=== DATABASE STRUCTURE ===");
            String checkTableSQL = "SHOW TABLES LIKE 'users'";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(checkTableSQL);
            
            if (rs.next()) {
                System.out.println("✓ 'users' table EXISTS");
            } else {
                System.out.println("✗ 'users' table DOES NOT EXIST");
                System.out.println("Creating users table...");
                String createTableSQL = "CREATE TABLE users (" +
                    "user_id INT PRIMARY KEY AUTO_INCREMENT, " +
                    "name VARCHAR(100) NOT NULL, " +
                    "email VARCHAR(100) UNIQUE NOT NULL, " +
                    "password VARCHAR(255) NOT NULL, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)";
                stmt.executeUpdate(createTableSQL);
                System.out.println("✓ Table created");
            }
            
            // 2. Check what's in the users table
            System.out.println("\n=== USERS IN DATABASE ===");
            String selectSQL = "SELECT user_id, name, email, password FROM users";
            rs = stmt.executeQuery(selectSQL);
            
            if (rs.next()) {
                System.out.println("Found users:");
                do {
                    System.out.println("  ID: " + rs.getInt("user_id"));
                    System.out.println("  Name: " + rs.getString("name"));
                    System.out.println("  Email: " + rs.getString("email"));
                    System.out.println("  Password Hash: " + rs.getString("password"));
                    System.out.println();
                } while (rs.next());
            } else {
                System.out.println("✗ No users found in database!");
            }
            
            // 3. Test password hashing
            System.out.println("=== PASSWORD VERIFICATION TEST ===");
            String testPassword = "test123";
            String expectedHash = hashPassword(testPassword);
            System.out.println("Test Password: " + testPassword);
            System.out.println("MD5 Hash: " + expectedHash);
            
            // 4. Try to authenticate
            System.out.println("\n=== ATTEMPTING LOGIN ===");
            String testEmail = "test@emovault.com";
            String authSQL = "SELECT user_id, password FROM users WHERE email = ?";
            PreparedStatement pstmt = conn.prepareStatement(authSQL);
            pstmt.setString(1, testEmail);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                String storedHash = rs.getString("password");
                System.out.println("Email: " + testEmail);
                System.out.println("Stored Hash: " + storedHash);
                System.out.println("Input Hash: " + expectedHash);
                System.out.println("Match: " + expectedHash.equals(storedHash));
            } else {
                System.out.println("✗ User NOT FOUND with email: " + testEmail);
                System.out.println("\nInserting test user...");
                String insertSQL = "INSERT INTO users (name, email, password) VALUES (?, ?, ?)";
                pstmt = conn.prepareStatement(insertSQL);
                pstmt.setString(1, "Test User");
                pstmt.setString(2, testEmail);
                pstmt.setString(3, expectedHash);
                pstmt.executeUpdate();
                System.out.println("✓ Test user inserted");
                System.out.println("\nEmail: " + testEmail);
                System.out.println("Password: " + testPassword);
            }
            
            conn.close();
        } catch (Exception e) {
            System.out.println("✗ Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}

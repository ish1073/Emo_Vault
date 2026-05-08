import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.*;

public class CreateTestUser {
    
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
            
            System.out.println("✓ Connected to database");
            
            // Create test user
            String testEmail = "test@emovault.com";
            String testPassword = "test123";
            String testName = "Test User";
            
            // Try to insert the user (with duplicate key handling)
            String insertSQL = "INSERT INTO users (name, email, password) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE password = password";
            PreparedStatement insertStmt = conn.prepareStatement(insertSQL);
            insertStmt.setString(1, testName);
            insertStmt.setString(2, testEmail);
            insertStmt.setString(3, hashPassword(testPassword));
            
            int rowsInserted = insertStmt.executeUpdate();
            
            if (rowsInserted > 0) {
                System.out.println("✓ Test user created/verified!");
            } else {
                System.out.println("✓ Test user already exists");
            }
            
            System.out.println("\n" + "=".repeat(50));
            System.out.println("LOGIN CREDENTIALS");
            System.out.println("=".repeat(50));
            System.out.println("Email:    " + testEmail);
            System.out.println("Password: " + testPassword);
            System.out.println("=".repeat(50));
            System.out.println("\nAccess: http://localhost:8080/EmoVault/login.jsp");
            
            conn.close();
        } catch (Exception e) {
            System.out.println("✗ Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}

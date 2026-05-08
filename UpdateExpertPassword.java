import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.*;

public class UpdateExpertPassword {
    
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
            
            // Generate MD5 hash for password "expert123"
            String passwordToHash = "expert123";
            String md5Hash = hashPassword(passwordToHash);
            System.out.println("MD5 hash of 'expert123': " + md5Hash);
            
            // Update the expert_accounts table with the MD5 hash
            String updateSQL = "UPDATE expert_accounts SET password_hash = ? WHERE expert_uid = 'expert_main'";
            PreparedStatement stmt = conn.prepareStatement(updateSQL);
            stmt.setString(1, md5Hash);
            int rowsUpdated = stmt.executeUpdate();
            
            if (rowsUpdated > 0) {
                System.out.println("✓ Expert password hash updated successfully");
            } else {
                System.out.println("✗ No rows updated - expert_main may not exist");
            }
            
            // Verify the update
            String verifySQL = "SELECT expert_uid, password_hash FROM expert_accounts WHERE expert_uid = 'expert_main'";
            ResultSet rs = conn.createStatement().executeQuery(verifySQL);
            if (rs.next()) {
                System.out.println("\n✓ Updated expert account:");
                System.out.println("  Expert UID: " + rs.getString("expert_uid"));
                System.out.println("  Password Hash: " + rs.getString("password_hash"));
            }
            
            System.out.println("\n" + "=".repeat(50));
            System.out.println("✓ PASSWORD UPDATE COMPLETE!");
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

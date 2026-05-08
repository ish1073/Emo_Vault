import java.sql.*;

public class CheckTableStructure {
    
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/emovault_db";
        String user = "emovault_user";
        String password = "emovault123";
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, user, password);
            
            System.out.println("✓ Connected to database\n");
            
            // Get table structure
            System.out.println("=== USERS TABLE STRUCTURE ===");
            String descSQL = "DESCRIBE users";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(descSQL);
            
            while (rs.next()) {
                System.out.println("Column: " + rs.getString("Field") + " | Type: " + rs.getString("Type"));
            }
            
            // Try different column names
            System.out.println("\n=== TRYING TO READ ALL DATA ===");
            String selectSQL = "SELECT * FROM users LIMIT 5";
            rs = stmt.executeQuery(selectSQL);
            ResultSetMetaData rsmd = rs.getMetaData();
            
            System.out.println("Available columns: ");
            for (int i = 1; i <= rsmd.getColumnCount(); i++) {
                System.out.println("  - " + rsmd.getColumnName(i));
            }
            
            System.out.println("\nData in users table:");
            while (rs.next()) {
                for (int i = 1; i <= rsmd.getColumnCount(); i++) {
                    System.out.println(rsmd.getColumnName(i) + ": " + rs.getObject(i));
                }
                System.out.println();
            }
            
            conn.close();
        } catch (Exception e) {
            System.out.println("✗ Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}

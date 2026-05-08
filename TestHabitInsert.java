import java.sql.*;

public class TestHabitInsert {
    public static void main(String[] args) throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/emovault_db?user=emovault_user&password=emovault123&useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
        Connection conn = DriverManager.getConnection(url);
        
        System.out.println("✓ Database connection successful!");
        
        // Test 0: List all tables
        System.out.println("\n=== Tables in Database ===");
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SHOW TABLES");
        while (rs.next()) {
            System.out.println("  - " + rs.getString(1));
        }
        
        // Test 1: Check if any habits exist
        System.out.println("\n=== Current Habits ===");
        try {
            rs = stmt.executeQuery("SELECT * FROM habits LIMIT 10");
            int count = 0;
            while (rs.next()) {
                count++;
                System.out.println("ID: " + rs.getInt("habit_id") + ", User: " + rs.getInt("user_id") + 
                                 ", Name: " + rs.getString("name") + ", Active: " + rs.getBoolean("is_active"));
            }
            System.out.println("Total habits found: " + count);
        } catch (SQLException e) {
            System.out.println("✗ ERROR: Habits table does not exist!");
            System.out.println("  Message: " + e.getMessage());
            conn.close();
            return;
        }
        
        // Test 2: Try to insert a test habit
        System.out.println("\n=== Testing INSERT ===");
        String insertSQL = "INSERT INTO habits (user_id, name, description, is_active, created_date) VALUES (?, ?, ?, ?, NOW())";
        PreparedStatement pstmt = conn.prepareStatement(insertSQL);
        pstmt.setInt(1, 1);  // Test with user_id = 1
        pstmt.setString(2, "Test Habit - " + System.currentTimeMillis());
        pstmt.setString(3, "This is a test habit for diagnostics");
        pstmt.setBoolean(4, true);
        
        int rowsAffected = pstmt.executeUpdate();
        System.out.println("INSERT executed - Rows affected: " + rowsAffected);
        
        if (rowsAffected > 0) {
            System.out.println("✓ INSERT successful!");
            
            // Verify the insert
            System.out.println("\n=== Verifying INSERT ===");
            rs = stmt.executeQuery("SELECT * FROM habits WHERE user_id = 1 ORDER BY created_date DESC LIMIT 1");
            if (rs.next()) {
                System.out.println("✓ Test habit found in database:");
                System.out.println("  ID: " + rs.getInt("habit_id"));
                System.out.println("  Name: " + rs.getString("name"));
                System.out.println("  Created: " + rs.getTimestamp("created_date"));
            }
        } else {
            System.out.println("✗ INSERT failed - No rows affected");
        }
        
        conn.close();
        System.out.println("\n✓ Test complete!");
    }
}

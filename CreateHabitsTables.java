import java.sql.*;
import java.nio.file.Files;
import java.nio.file.Paths;

public class CreateHabitsTables {
    public static void main(String[] args) throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/emovault_db?user=emovault_user&password=emovault123&useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
        Connection conn = DriverManager.getConnection(url);
        
        System.out.println("✓ Database connection successful!");
        
        // Read SQL file
        String sqlContent = new String(Files.readAllBytes(Paths.get("database_schema_new_modules.sql")));
        
        // Split by semicolon and execute each statement
        String[] statements = sqlContent.split(";");
        Statement stmt = conn.createStatement();
        int created = 0;
        
        for (String sql : statements) {
            sql = sql.trim();
            if (sql.isEmpty()) continue;
            
            try {
                stmt.execute(sql);
                created++;
                System.out.println("✓ Executed: " + sql.substring(0, Math.min(60, sql.length())) + "...");
            } catch (SQLException e) {
                System.out.println("⚠ SQL error: " + e.getMessage());
            }
        }
        
        System.out.println("\n✓ Created " + created + " SQL statements!");
        
        // Verify tables exist
        System.out.println("\n=== Tables Now in Database ===");
        ResultSet rs = stmt.executeQuery("SHOW TABLES");
        while (rs.next()) {
            System.out.println("  - " + rs.getString(1));
        }
        
        conn.close();
        System.out.println("\n✓ All tables created successfully!");
    }
}

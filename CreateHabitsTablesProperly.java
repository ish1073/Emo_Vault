import java.sql.*;

public class CreateHabitsTablesProperly {
    public static void main(String[] args) throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/emovault_db?user=emovault_user&password=emovault123&useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
        Connection conn = DriverManager.getConnection(url);
        
        System.out.println("✓ Database connection successful!");
        
        Statement stmt = conn.createStatement();
        
        // Check users table structure
        System.out.println("\n=== Users Table Structure ===");
        ResultSet rs = stmt.executeQuery("DESC users");
        while (rs.next()) {
            System.out.println(rs.getString("Field") + " (" + rs.getString("Type") + ")");
        }
        
        // Create HABITS table
        System.out.println("\n=== Creating Habits Table ===");
        String createHabits = "CREATE TABLE IF NOT EXISTS habits (" +
            "habit_id INT PRIMARY KEY AUTO_INCREMENT," +
            "user_id INT NOT NULL," +
            "name VARCHAR(200) NOT NULL," +
            "description VARCHAR(500)," +
            "suggested_by_tag VARCHAR(50)," +
            "is_active BOOLEAN DEFAULT TRUE," +
            "created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
            "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE," +
            "INDEX (user_id)" +
            ")";
        
        try {
            stmt.execute(createHabits);
            System.out.println("✓ Habits table created!");
        } catch (SQLException e) {
            System.out.println("⚠ Habits table error: " + e.getMessage());
        }
        
        // Create HABIT_LOGS table
        System.out.println("\n=== Creating Habit_Logs Table ===");
        String createHabitLogs = "CREATE TABLE IF NOT EXISTS habit_logs (" +
            "log_id INT PRIMARY KEY AUTO_INCREMENT," +
            "habit_id INT NOT NULL," +
            "completed_date DATE NOT NULL," +
            "is_completed BOOLEAN DEFAULT TRUE," +
            "FOREIGN KEY (habit_id) REFERENCES habits(habit_id) ON DELETE CASCADE," +
            "UNIQUE KEY unique_habit_date (habit_id, completed_date)," +
            "INDEX (completed_date)" +
            ")";
        
        try {
            stmt.execute(createHabitLogs);
            System.out.println("✓ Habit_logs table created!");
        } catch (SQLException e) {
            System.out.println("⚠ Habit_logs table error: " + e.getMessage());
        }
        
        // Verify tables exist
        System.out.println("\n=== Tables Now in Database ===");
        rs = stmt.executeQuery("SHOW TABLES");
        while (rs.next()) {
            System.out.println("  - " + rs.getString(1));
        }
        
        conn.close();
        System.out.println("\n✓ Done!");
    }
}

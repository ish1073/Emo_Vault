import java.sql.*;
import java.time.LocalDate;

public class TestStreakCalculation {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/emovault_db";
        String username = "root";
        String password = "";
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, username, password);
            
            // Get all users and their habits
            String userQuery = "SELECT DISTINCT user_id FROM habits LIMIT 5";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(userQuery);
            
            while (rs.next()) {
                int userId = rs.getInt("user_id");
                testUserHabits(conn, userId);
            }
            
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    private static void testUserHabits(Connection conn, int userId) {
        try {
            String habitQuery = "SELECT habit_id, name FROM habits WHERE user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(habitQuery);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            System.out.println("\n=== User " + userId + " ===");
            
            while (rs.next()) {
                int habitId = rs.getInt("habit_id");
                String name = rs.getString("name");
                int streak = calculateStreak(conn, habitId);
                
                System.out.println("Habit: " + name + " (ID:" + habitId + ") - Streak: " + streak);
                
                // Show recent logs
                String logsQuery = "SELECT completed_date, is_completed FROM habit_logs WHERE habit_id = ? ORDER BY completed_date DESC LIMIT 5";
                PreparedStatement logsStmt = conn.prepareStatement(logsQuery);
                logsStmt.setInt(1, habitId);
                ResultSet logsRs = logsStmt.executeQuery();
                
                System.out.println("  Recent logs:");
                while (logsRs.next()) {
                    Date date = logsRs.getDate("completed_date");
                    boolean isCompleted = logsRs.getBoolean("is_completed");
                    System.out.println("    - " + date + ": " + (isCompleted ? "DONE" : "NOT DONE"));
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    private static int calculateStreak(Connection conn, int habitId) {
        try {
            String query = "SELECT completed_date FROM habit_logs WHERE habit_id = ? AND is_completed = 1 ORDER BY completed_date DESC LIMIT 100";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, habitId);
            ResultSet rs = stmt.executeQuery();
            
            LocalDate today = LocalDate.now();
            int streak = 0;
            LocalDate expectedDate = today;
            
            while (rs.next()) {
                LocalDate completedDate = rs.getDate("completed_date").toLocalDate();
                if (completedDate.equals(expectedDate)) {
                    streak++;
                    expectedDate = expectedDate.minusDays(1);
                } else if (completedDate.isBefore(expectedDate)) {
                    break;
                }
            }
            
            return streak;
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }
}

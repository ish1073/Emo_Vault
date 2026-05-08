package com.emovault.servlet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.emovault.util.DBConnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

/**
 * Test Data Setup Servlet
 * Creates test data for demonstrating EmoVault features
 * Access: http://localhost:8080/EmoVault/setup-test-data
 */
public class SetupTestDataServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            out.println("<html><head><meta charset='UTF-8'><title>Test Data Setup</title>");
            out.println("<style>body { font-family: Arial; margin: 20px; } .success { color: green; } .error { color: red; } .info { color: blue; }</style>");
            out.println("</head><body>");
            out.println("<h1>EmoVault Test Data Setup</h1>");
            out.println("<div id='log' style='border: 1px solid #ccc; padding: 10px; height: 400px; overflow-y: auto;'>");
            out.flush();
            
            // Create database connection
            try (Connection conn = DBConnection.getConnection()) {
                out.println("<p class='info'>✓ Database connection established</p>");
                out.flush();
                
                // Get or create test user
                int userId = getOrCreateTestUser(conn, out);
                out.println("<p class='info'>✓ Test user ID: " + userId + "</p>");
                out.flush();
                
                // Create test data
                createTestEmotions(conn, userId, out);
                out.println("<p class='info'>✓ Created 8 test emotion entries</p>");
                out.flush();
                
                createTestCapsules(conn, userId, out);
                out.println("<p class='info'>✓ Created time capsules with reflections</p>");
                out.flush();
                
                createTestDiaryEntries(conn, userId, out);
                out.println("<p class='info'>✓ Created 5 diary entries</p>");
                out.flush();
                
                createTestHabits(conn, userId, out);
                out.println("<p class='info'>✓ Created 4 habits</p>");
                out.flush();
                
                createTestRegrets(conn, userId, out);
                out.println("<p class='info'>✓ Created 3 regrets</p>");
                out.flush();
                
                out.println("</div>");
                out.println("<hr>");
                out.println("<h2 class='success'>✓ Test data created successfully!</h2>");
                out.println("<h3>LOGIN CREDENTIALS:</h3>");
                out.println("<p>Email: <strong>testuser@example.com</strong></p>");
                out.println("<p>Password: <strong>test123</strong></p>");
                out.println("<hr>");
                out.println("<h3>You can now:</h3>");
                out.println("<ol>");
                out.println("<li><a href='login.jsp'>Log in with test credentials</a></li>");
                out.println("<li>Go to <strong>Behavior Analyzer</strong> to see emotional insights</li>");
                out.println("<li>Go to <strong>Time Capsule</strong> to see reflections</li>");
                out.println("<li>Go to <strong>Analytics & Reports</strong> for charts</li>");
                out.println("</ol>");
                
            } catch (SQLException e) {
                out.println("<p class='error'>✗ Database error: " + e.getMessage() + "</p>");
                e.printStackTrace(out);
            }
            
            out.println("</body></html>");
            
        } finally {
            out.close();
        }
    }
    
    private int getOrCreateTestUser(Connection conn, PrintWriter out) throws SQLException {
        // Check if user exists
        String checkSql = "SELECT user_id FROM users WHERE email = ?";
        try (PreparedStatement stmt = conn.prepareStatement(checkSql)) {
            stmt.setString(1, "testuser@example.com");
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("user_id");
            }
        }
        
        // Create test user
        String insertSql = "INSERT INTO users (name, email, password) VALUES (?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, "Test User");
            stmt.setString(2, "testuser@example.com");
            stmt.setString(3, "test123");
            stmt.executeUpdate();
            
            ResultSet generatedKeys = stmt.getGeneratedKeys();
            if (generatedKeys.next()) {
                return generatedKeys.getInt(1);
            }
        }
        return -1;
    }
    
    private void createTestEmotions(Connection conn, int userId, PrintWriter out) throws SQLException {
        String sql = "INSERT INTO emotions (user_id, mood, intensity, trigger, response, created_at) VALUES (?, ?, ?, ?, ?, ?)";
        
        String[] moods = {"Stressed", "Happy", "Sad", "Excited", "Calm", "Anxious", "Peaceful", "Frustrated"};
        int[] intensities = {7, 8, 6, 9, 4, 6, 5, 8};
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (int i = 0; i < moods.length; i++) {
                stmt.setInt(1, userId);
                stmt.setString(2, moods[i]);
                stmt.setInt(3, intensities[i]);
                stmt.setString(4, "Trigger " + (i+1));
                stmt.setString(5, "Response " + (i+1));
                stmt.setTimestamp(6, new Timestamp(System.currentTimeMillis() - (i * 86400000L)));
                stmt.addBatch();
            }
            stmt.executeBatch();
        }
    }
    
    private void createTestCapsules(Connection conn, int userId, PrintWriter out) throws SQLException {
        String sql = "INSERT INTO time_capsules (user_id, message, goal, mood, target_date, opened, reflection, reflection_mood, achievement_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            // Capsule 1 - opened with reflection
            stmt.setInt(1, userId);
            stmt.setString(2, "I want to achieve better work-life balance");
            stmt.setString(3, "Improve routine");
            stmt.setString(4, "Hopeful");
            stmt.setDate(5, new java.sql.Date(System.currentTimeMillis() - 30*86400000L));
            stmt.setBoolean(6, true);
            stmt.setString(7, "I've made progress! Started better routine and feel less stressed.");
            stmt.setString(8, "Grateful");
            stmt.setString(9, "Partially");
            stmt.addBatch();
            
            // Capsule 2 - locked
            stmt.setInt(1, userId);
            stmt.setString(2, "Build presentation confidence");
            stmt.setString(3, "Overcome anxiety");
            stmt.setString(4, "Determined");
            stmt.setDate(5, new java.sql.Date(System.currentTimeMillis() + 60*86400000L));
            stmt.setBoolean(6, false);
            stmt.setString(7, null);
            stmt.setString(8, null);
            stmt.setString(9, null);
            stmt.addBatch();
            
            // Capsule 3 - opened with reflection
            stmt.setInt(1, userId);
            stmt.setString(2, "Build meditation habit");
            stmt.setString(3, "10-minute daily meditation");
            stmt.setString(4, "Peaceful");
            stmt.setDate(5, new java.sql.Date(System.currentTimeMillis() - 15*86400000L));
            stmt.setBoolean(6, true);
            stmt.setString(7, "Successfully meditating 5 days a week. Feeling more peaceful.");
            stmt.setString(8, "Peaceful");
            stmt.setString(9, "Achieved");
            stmt.addBatch();
            
            stmt.executeBatch();
        }
    }
    
    private void createTestDiaryEntries(Connection conn, int userId, PrintWriter out) throws SQLException {
        String sql = "INSERT INTO diary_entries (user_id, title, content, mood, created_at) VALUES (?, ?, ?, ?, ?)";
        
        String[] titles = {"Monday Reflection", "Productive Day", "Challenging Moments", "Weekend Peace", "New Insights"};
        String[] moods = {"Hopeful", "Excited", "Calm", "Peaceful", "Calm"};
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (int i = 0; i < titles.length; i++) {
                stmt.setInt(1, userId);
                stmt.setString(2, titles[i]);
                stmt.setString(3, "Sample diary entry content for " + titles[i]);
                stmt.setString(4, moods[i]);
                stmt.setTimestamp(5, new Timestamp(System.currentTimeMillis() - (i * 86400000L)));
                stmt.addBatch();
            }
            stmt.executeBatch();
        }
    }
    
    private void createTestHabits(Connection conn, int userId, PrintWriter out) throws SQLException {
        String sql = "INSERT INTO habits (user_id, title, streak, is_active, consistency_score, created_at) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setString(2, "Morning Meditation");
            stmt.setInt(3, 7);
            stmt.setBoolean(4, true);
            stmt.setDouble(5, 85.0);
            stmt.setTimestamp(6, new Timestamp(System.currentTimeMillis() - 10*86400000L));
            stmt.addBatch();
            
            stmt.setInt(1, userId);
            stmt.setString(2, "Evening Exercise");
            stmt.setInt(3, 3);
            stmt.setBoolean(4, true);
            stmt.setDouble(5, 65.0);
            stmt.setTimestamp(6, new Timestamp(System.currentTimeMillis() - 15*86400000L));
            stmt.addBatch();
            
            stmt.setInt(1, userId);
            stmt.setString(2, "Journaling");
            stmt.setInt(3, 5);
            stmt.setBoolean(4, true);
            stmt.setDouble(5, 75.0);
            stmt.setTimestamp(6, new Timestamp(System.currentTimeMillis() - 20*86400000L));
            stmt.addBatch();
            
            stmt.setInt(1, userId);
            stmt.setString(2, "Reading");
            stmt.setInt(3, 0);
            stmt.setBoolean(4, false);
            stmt.setDouble(5, 45.0);
            stmt.setTimestamp(6, new Timestamp(System.currentTimeMillis() - 30*86400000L));
            stmt.addBatch();
            
            stmt.executeBatch();
        }
    }
    
    private void createTestRegrets(Connection conn, int userId, PrintWriter out) throws SQLException {
        String sql = "INSERT INTO regrets (user_id, description, lesson_learned, tag, created_date) VALUES (?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setString(2, "Postponed important meeting");
            stmt.setString(3, "Communication delays cause problems");
            stmt.setString(4, "communication");
            stmt.setDate(5, new java.sql.Date(System.currentTimeMillis() - 7*86400000L));
            stmt.addBatch();
            
            stmt.setInt(1, userId);
            stmt.setString(2, "Skipped exercise for 3 days");
            stmt.setString(3, "Exercise helps with stress");
            stmt.setString(4, "health");
            stmt.setDate(5, new java.sql.Date(System.currentTimeMillis() - 5*86400000L));
            stmt.addBatch();
            
            stmt.setInt(1, userId);
            stmt.setString(2, "Said something hurtful");
            stmt.setString(3, "Take a break before responding");
            stmt.setString(4, "relationships");
            stmt.setDate(5, new java.sql.Date(System.currentTimeMillis() - 3*86400000L));
            stmt.addBatch();
            
            stmt.executeBatch();
        }
    }
}

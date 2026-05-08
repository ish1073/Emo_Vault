import java.sql.*;

/**
 * Creates test data for EmoVault to demonstrate Behavior Analyzer and Reflections
 */
public class CreateTestData {
    
    public static void main(String[] args) {
        // Update these with your database credentials
        String dbUrl = "jdbc:mysql://localhost:3306/emovault";
        String dbUser = "root";
        String dbPassword = "Password123";
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
            
            System.out.println("✓ Database connected!");
            
            // Get or create test user
            int userId = getOrCreateTestUser(conn);
            System.out.println("✓ Test user ID: " + userId);
            
            // Create test emotions (at least 3 for analyzer to work)
            createTestEmotions(conn, userId);
            System.out.println("✓ Created 8 test emotion entries");
            
            // Create test time capsules
            createTestCapsules(conn, userId);
            System.out.println("✓ Created 3 test time capsules");
            
            // Create test reflections on capsules
            createTestReflections(conn, userId);
            System.out.println("✓ Added reflections to time capsules");
            
            // Create test diary entries
            createTestDiaryEntries(conn, userId);
            System.out.println("✓ Created 5 test diary entries");
            
            // Create test habits
            createTestHabits(conn, userId);
            System.out.println("✓ Created 4 test habits");
            
            // Create test regrets
            createTestRegrets(conn, userId);
            System.out.println("✓ Created 3 test regrets");
            
            conn.close();
            
            System.out.println("\n✅ Test data created successfully!");
            System.out.println("\n📝 LOGIN CREDENTIALS:");
            System.out.println("   Email: testuser@example.com");
            System.out.println("   Password: test123");
            System.out.println("\n🔍 You can now:");
            System.out.println("   1. Go to Behavior Analyzer to see insights");
            System.out.println("   2. Go to Time Capsule to see reflections");
            System.out.println("   3. Go to Analytics for charts");
            
        } catch (Exception e) {
            System.err.println("❌ Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private static int getOrCreateTestUser(Connection conn) throws SQLException {
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
            stmt.setString(3, "test123"); // In real app, this would be hashed
            stmt.executeUpdate();
            
            ResultSet generatedKeys = stmt.getGeneratedKeys();
            if (generatedKeys.next()) {
                return generatedKeys.getInt(1);
            }
        }
        return -1;
    }
    
    private static void createTestEmotions(Connection conn, int userId) throws SQLException {
        String sql = "INSERT INTO emotions (user_id, mood, intensity, trigger, response, created_at) VALUES (?, ?, ?, ?, ?, ?)";
        
        String[] moods = {"Stressed", "Happy", "Sad", "Excited", "Calm", "Anxious", "Peaceful", "Frustrated"};
        int[] intensities = {7, 8, 6, 9, 4, 6, 5, 8};
        String[] triggers = {"Work deadline", "Good news", "Sad news", "Achievement", "Meditation", "Work issue", "Nature walk", "Traffic"};
        String[] responses = {"Took a break", "Celebrated", "Talked to friend", "Shared joy", "Relaxed", "Exercised", "Enjoyed moment", "Took a walk"};
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (int i = 0; i < moods.length; i++) {
                stmt.setInt(1, userId);
                stmt.setString(2, moods[i]);
                stmt.setInt(3, intensities[i]);
                stmt.setString(4, triggers[i]);
                stmt.setString(5, responses[i]);
                stmt.setTimestamp(6, new Timestamp(System.currentTimeMillis() - (i * 86400000))); // Different dates
                stmt.addBatch();
            }
            stmt.executeBatch();
        }
    }
    
    private static void createTestCapsules(Connection conn, int userId) throws SQLException {
        String sql = "INSERT INTO time_capsules (user_id, message, goal, mood, target_date, opened) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            // Capsule 1 - Already opened (ready for reflection)
            stmt.setInt(1, userId);
            stmt.setString(2, "I want to achieve better work-life balance this quarter");
            stmt.setString(3, "Improve daily routine and stress management");
            stmt.setString(4, "Hopeful");
            stmt.setDate(5, new java.sql.Date(System.currentTimeMillis() - 30*86400000));
            stmt.setBoolean(6, true);
            stmt.addBatch();
            
            // Capsule 2 - Locked
            stmt.setInt(1, userId);
            stmt.setString(2, "I hope to be more confident in presentations");
            stmt.setString(3, "Overcome presentation anxiety");
            stmt.setString(4, "Determined");
            stmt.setDate(5, new java.sql.Date(System.currentTimeMillis() + 60*86400000));
            stmt.setBoolean(6, false);
            stmt.addBatch();
            
            // Capsule 3 - Already opened with reflection
            stmt.setInt(1, userId);
            stmt.setString(2, "I want to build a meditation habit");
            stmt.setString(3, "Daily 10-minute meditation for mental peace");
            stmt.setString(4, "Peaceful");
            stmt.setDate(5, new java.sql.Date(System.currentTimeMillis() - 15*86400000));
            stmt.setBoolean(6, true);
            stmt.addBatch();
            
            stmt.executeBatch();
        }
    }
    
    private static void createTestReflections(Connection conn, int userId) throws SQLException {
        // Get the first opened capsule
        String getCapsuleSql = "SELECT capsule_id FROM time_capsules WHERE user_id = ? AND opened = true LIMIT 1";
        int capsuleId = -1;
        
        try (PreparedStatement stmt = conn.prepareStatement(getCapsuleSql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                capsuleId = rs.getInt("capsule_id");
            }
        }
        
        if (capsuleId != -1) {
            String updateSql = "UPDATE time_capsules SET reflection = ?, reflection_mood = ?, achievement_status = ?, opened_at = ? WHERE capsule_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(updateSql)) {
                stmt.setString(1, "I've made good progress! I've started implementing a better morning routine and have been more mindful of my work hours. While not perfect, I can see the difference in my stress levels. I'm committed to continuing this journey.");
                stmt.setString(2, "Grateful");
                stmt.setString(3, "Partially");
                stmt.setTimestamp(4, new Timestamp(System.currentTimeMillis() - 5*86400000));
                stmt.setInt(5, capsuleId);
                stmt.executeUpdate();
            }
        }
    }
    
    private static void createTestDiaryEntries(Connection conn, int userId) throws SQLException {
        String sql = "INSERT INTO diary_entries (user_id, title, content, mood, created_at) VALUES (?, ?, ?, ?, ?)";
        
        String[] titles = {"Monday Reflection", "Productive Day", "Challenging Moments", "Weekend Peace", "New Insights"};
        String[] contents = {
            "Started the week with renewed energy and focus. Managed to complete my meditation practice this morning.",
            "Had an amazing day at work. Completed three important projects and received positive feedback from team.",
            "Today was tough. Had conflicts with a coworker but we resolved it by evening. Feeling better now.",
            "Spent the weekend with family. Very relaxing and rejuvenating. Feel recharged for the week ahead.",
            "Realized that my stress levels are directly connected to how much I exercise. Need to prioritize fitness."
        };
        String[] moods = {"Hopeful", "Excited", "Calm", "Peaceful", "Calm"};
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (int i = 0; i < titles.length; i++) {
                stmt.setInt(1, userId);
                stmt.setString(2, titles[i]);
                stmt.setString(3, contents[i]);
                stmt.setString(4, moods[i]);
                stmt.setTimestamp(5, new Timestamp(System.currentTimeMillis() - (i * 86400000)));
                stmt.addBatch();
            }
            stmt.executeBatch();
        }
    }
    
    private static void createTestHabits(Connection conn, int userId) throws SQLException {
        String sql = "INSERT INTO habits (user_id, title, streak, is_active, consistency_score, created_at) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            // Habit 1
            stmt.setInt(1, userId);
            stmt.setString(2, "Morning Meditation");
            stmt.setInt(3, 7); // 7 day streak
            stmt.setBoolean(4, true);
            stmt.setDouble(5, 85.0);
            stmt.setTimestamp(6, new Timestamp(System.currentTimeMillis() - 10*86400000));
            stmt.addBatch();
            
            // Habit 2
            stmt.setInt(1, userId);
            stmt.setString(2, "Evening Exercise");
            stmt.setInt(3, 3);
            stmt.setBoolean(4, true);
            stmt.setDouble(5, 65.0);
            stmt.setTimestamp(6, new Timestamp(System.currentTimeMillis() - 15*86400000));
            stmt.addBatch();
            
            // Habit 3
            stmt.setInt(1, userId);
            stmt.setString(2, "Journaling");
            stmt.setInt(3, 5);
            stmt.setBoolean(4, true);
            stmt.setDouble(5, 75.0);
            stmt.setTimestamp(6, new Timestamp(System.currentTimeMillis() - 20*86400000));
            stmt.addBatch();
            
            // Habit 4
            stmt.setInt(1, userId);
            stmt.setString(2, "Reading");
            stmt.setInt(3, 0);
            stmt.setBoolean(4, false);
            stmt.setDouble(5, 45.0);
            stmt.setTimestamp(6, new Timestamp(System.currentTimeMillis() - 30*86400000));
            stmt.addBatch();
            
            stmt.executeBatch();
        }
    }
    
    private static void createTestRegrets(Connection conn, int userId) throws SQLException {
        String sql = "INSERT INTO regrets (user_id, description, lesson_learned, tag, created_date) VALUES (?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            // Regret 1
            stmt.setInt(1, userId);
            stmt.setString(2, "Postponed important meeting by a week, causing miscommunication");
            stmt.setString(3, "Communication delays can create more problems. Better to address issues directly.");
            stmt.setString(4, "communication");
            stmt.setDate(5, new java.sql.Date(System.currentTimeMillis() - 7*86400000));
            stmt.addBatch();
            
            // Regret 2
            stmt.setInt(1, userId);
            stmt.setString(2, "Skipped exercise for 3 days due to stress");
            stmt.setString(3, "Exercise actually helps with stress management. Don't skip when stressed.");
            stmt.setString(4, "health");
            stmt.setDate(5, new java.sql.Date(System.currentTimeMillis() - 5*86400000));
            stmt.addBatch();
            
            // Regret 3
            stmt.setInt(1, userId);
            stmt.setString(2, "Said something hurtful in anger");
            stmt.setString(3, "Take a break before responding in anger. Words matter.");
            stmt.setString(4, "relationships");
            stmt.setDate(5, new java.sql.Date(System.currentTimeMillis() - 3*86400000));
            stmt.addBatch();
            
            stmt.executeBatch();
        }
    }
}

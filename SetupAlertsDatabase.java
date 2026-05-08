import java.sql.*;

public class SetupAlertsDatabase {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/emovault_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
        String user = "emovault_user";
        String password = "emovault123";
        
        String[] sqlStatements = {
            // Drop existing tables if needed
            "DROP TABLE IF EXISTS alerts",
            "DROP TABLE IF EXISTS user_alert_preferences",
            
            // Create alerts table
            "CREATE TABLE alerts (" +
            "    alert_id VARCHAR(50) PRIMARY KEY," +
            "    user_id INT NOT NULL," +
            "    alert_type VARCHAR(50) NOT NULL," +
            "    priority VARCHAR(20) NOT NULL DEFAULT 'MEDIUM'," +
            "    title VARCHAR(200) NOT NULL," +
            "    message TEXT NOT NULL," +
            "    related_data_id VARCHAR(50)," +
            "    action_url VARCHAR(200)," +
            "    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
            "    dismissed_at TIMESTAMP NULL," +
            "    is_dismissed BOOLEAN DEFAULT FALSE," +
            "    INDEX idx_user_alerts (user_id, is_dismissed)," +
            "    INDEX idx_created_at (created_at)," +
            "    INDEX idx_alert_type (alert_type)" +
            ")",
            
            // Create user preferences table
            "CREATE TABLE user_alert_preferences (" +
            "    preference_id VARCHAR(50) PRIMARY KEY," +
            "    user_id INT NOT NULL UNIQUE," +
            "    emotional_risk_enabled BOOLEAN DEFAULT TRUE," +
            "    behavioral_pattern_enabled BOOLEAN DEFAULT TRUE," +
            "    habit_disruption_enabled BOOLEAN DEFAULT TRUE," +
            "    time_sensitive_enabled BOOLEAN DEFAULT TRUE," +
            "    insight_enabled BOOLEAN DEFAULT FALSE," +
            "    min_sensitivity INT DEFAULT 2," +
            "    email_notifications_enabled BOOLEAN DEFAULT FALSE," +
            "    quiet_hours_start TIME," +
            "    quiet_hours_end TIME," +
            "    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
            ")",
            
            // Create indexes
            "CREATE INDEX idx_alerts_user_dismissed ON alerts(user_id, is_dismissed)",
            "CREATE INDEX idx_alerts_user_type ON alerts(user_id, alert_type)",
            "CREATE INDEX idx_alerts_priority ON alerts(priority)",
            "CREATE INDEX idx_preferences_user ON user_alert_preferences(user_id)"
        };
        
        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            System.out.println("✅ Connected to database");
            
            for (String sql : sqlStatements) {
                try {
                    Statement stmt = conn.createStatement();
                    stmt.execute(sql);
                    System.out.println("✅ Executed: " + sql.substring(0, Math.min(50, sql.length())) + "...");
                } catch (SQLSyntaxErrorException e) {
                    // Index might already exist, that's okay
                    if (!e.getMessage().contains("already exists")) {
                        System.err.println("❌ Error: " + e.getMessage());
                    } else {
                        System.out.println("ℹ️ Index already exists (skipped)");
                    }
                }
            }
            
            System.out.println("\n✅ Alerts database schema created successfully!");
            
        } catch (Exception e) {
            System.err.println("❌ Database connection failed: " + e.getMessage());
            e.printStackTrace();
        }
    }
}

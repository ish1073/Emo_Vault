# Alerts Module - Technical Implementation Guide

## 📦 Module Architecture

### **Core Classes**

#### 1. **Alert.java** (Model/Entity)
```java
package com.emovault.model;

import java.time.LocalDateTime;

public class Alert {
    private String alertId;
    private String userId;
    private AlertType alertType;
    private AlertPriority priority;
    private String title;
    private String message;
    private String relatedDataId;      // emotion/habit/regret entry ID
    private String actionUrl;           // where user should navigate
    private LocalDateTime createdAt;
    private LocalDateTime dismissedAt;
    private boolean isDismissed;
    private LocalDateTime userSeenAt;
    
    // Constructors, getters, setters
}

public enum AlertType {
    EMOTIONAL_RISK("Emotional Risk"),
    BEHAVIORAL_PATTERN("Behavioral Pattern"),
    HABIT_DISRUPTION("Habit Disruption"),
    TIME_SENSITIVE("Time Sensitive"),
    INSIGHT("Insight");
    
    private String displayName;
    
    AlertType(String displayName) {
        this.displayName = displayName;
    }
}

public enum AlertPriority {
    CRITICAL(4, "FF4444"),   // Red
    HIGH(3, "FFA500"),       // Orange
    MEDIUM(2, "FFFF00"),     // Yellow
    LOW(1, "4499FF");        // Blue
    
    private int level;
    private String color;
}
```

---

#### 2. **AlertSystem.java** (Core Service)
```java
package com.emovault.service;

import com.emovault.model.*;
import com.emovault.dao.*;
import com.emovault.util.*;
import java.util.*;
import java.time.LocalDateTime;

public class AlertSystem {
    private EmotionDAO emotionDAO;
    private DiaryDAO diaryDAO;
    private HabitDAO habitDAO;
    private RegretDAO regretDAO;
    private AlertDAO alertDAO;
    private RiskAnalyzer riskAnalyzer;
    private AlertRepository alertRepository;
    
    public AlertSystem() {
        this.emotionDAO = new EmotionDAO();
        this.diaryDAO = new DiaryDAO();
        this.habitDAO = new HabitDAO();
        this.regretDAO = new RegretDAO();
        this.alertDAO = new AlertDAO();
        this.riskAnalyzer = new RiskAnalyzer();
        this.alertRepository = new AlertRepository();
    }
    
    /**
     * Main method: Analyze user data and generate relevant alerts
     */
    public List<Alert> analyzeUserAndGenerateAlerts(User user) {
        List<Alert> alerts = new ArrayList<>();
        
        // Run all alert detection methods
        Alert emotionalAlert = detectEmotionalRiskAlert(user);
        if (emotionalAlert != null) {
            alerts.add(emotionalAlert);
        }
        
        Alert behaviorAlert = detectBehaviorPatternAlert(user);
        if (behaviorAlert != null) {
            alerts.add(behaviorAlert);
        }
        
        Alert habitAlert = detectHabitDisruptionAlert(user);
        if (habitAlert != null) {
            alerts.add(habitAlert);
        }
        
        Alert timeAlert = detectTimeSensitiveAlert(user);
        if (timeAlert != null) {
            alerts.add(timeAlert);
        }
        
        Alert insightAlert = detectInsightAlert(user);
        if (insightAlert != null) {
            alerts.add(insightAlert);
        }
        
        // Apply filtering: user preferences, frequency control, etc.
        List<Alert> filteredAlerts = applyUserPreferences(alerts, user);
        filteredAlerts = controlAlertFrequency(filteredAlerts, user);
        
        // Store and deliver alerts
        for (Alert alert : filteredAlerts) {
            alertRepository.save(alert);
            deliverAlert(alert, user);
        }
        
        return filteredAlerts;
    }
    
    /**
     * ALERT TYPE 1: Emotional Risk Detection
     * Triggers: High stress, anxiety, mood drops
     */
    private Alert detectEmotionalRiskAlert(User user) {
        List<Emotion> recentEmotions = emotionDAO.getLastNEmotions(user.getId(), 5);
        
        // Check for sustained high stress (stress > 8 for 3+ days)
        long highStressCount = recentEmotions.stream()
            .filter(e -> e.getIntensity() > 8)
            .count();
        
        if (highStressCount >= 3) {
            return createAlert(
                user.getId(),
                AlertType.EMOTIONAL_RISK,
                AlertPriority.HIGH,
                "⚠️ High Stress Pattern Detected",
                "Your stress levels have been consistently high this week. " +
                "Consider trying a coping strategy or taking a break.",
                null,
                "/emotion" // action URL
            );
        }
        
        // Check for mood decline
        double averageMood = recentEmotions.stream()
            .mapToDouble(Emotion::getMoodScore)
            .average()
            .orElse(5);
        
        if (averageMood < 3) {
            return createAlert(
                user.getId(),
                AlertType.EMOTIONAL_RISK,
                AlertPriority.HIGH,
                "🔴 Low Mood Alert",
                "Your mood has been consistently low. This might be a good " +
                "time to reach out to someone or try coping strategies.",
                null,
                "/emotion"
            );
        }
        
        return null;
    }
    
    /**
     * ALERT TYPE 2: Behavioral Pattern Detection
     * Triggers: Repeated regrets, procrastination patterns
     */
    private Alert detectBehaviorPatternAlert(User user) {
        Map<String, Integer> regretCounts = getRegretPatterns(user);
        
        // Find repeated regrets
        for (String regret : regretCounts.keySet()) {
            int count = regretCounts.get(regret);
            if (count >= 3) {
                return createAlert(
                    user.getId(),
                    AlertType.BEHAVIORAL_PATTERN,
                    AlertPriority.MEDIUM,
                    "📊 Pattern Detected",
                    String.format("You've mentioned \"%s\" %d times this week. " +
                        "This might be worth exploring in your diary.", 
                        regret, count),
                    null,
                    "/diary"
                );
            }
        }
        
        return null;
    }
    
    /**
     * ALERT TYPE 3: Habit Disruption Detection
     * Triggers: Streak broken, habit not logged
     */
    private Alert detectHabitDisruptionAlert(User user) {
        List<Habit> activeHabits = habitDAO.getActiveHabits(user.getId());
        
        for (Habit habit : activeHabits) {
            int daysSinceLogged = getDaysSinceLastLogged(habit);
            
            // If habit not logged for 2+ days and was actively tracked
            if (daysSinceLogged >= 2 && habit.getStreak() > 0) {
                return createAlert(
                    user.getId(),
                    AlertType.HABIT_DISRUPTION,
                    AlertPriority.MEDIUM,
                    "🔥 Streak Interrupted",
                    String.format("Your \"%s\" streak of %d days has been broken. " +
                        "Ready to start fresh today?",
                        habit.getName(), habit.getStreak()),
                    habit.getHabitId(),
                    "/habit"
                );
            }
        }
        
        return null;
    }
    
    /**
     * ALERT TYPE 4: Time-Sensitive Events
     * Triggers: Time capsule ready, milestones, scheduled events
     */
    private Alert detectTimeSensitiveAlert(User user) {
        // Check for time capsules ready to open
        List<TimeCapsule> readyCapsules = getReadyTimeCapsules(user);
        
        if (!readyCapsules.isEmpty()) {
            TimeCapsule capsule = readyCapsules.get(0);
            return createAlert(
                user.getId(),
                AlertType.TIME_SENSITIVE,
                AlertPriority.MEDIUM,
                "📬 Time Capsule Ready",
                String.format("Your time capsule \"%s\" from %s is ready to open!",
                    capsule.getTitle(), capsule.getCreatedDate()),
                capsule.getId(),
                "/timecapsule"
            );
        }
        
        return null;
    }
    
    /**
     * ALERT TYPE 5: Expert Insights
     * Triggers: Pattern analysis reveals actionable insight
     */
    private Alert detectInsightAlert(User user) {
        PatternInsight insight = riskAnalyzer.analyzePatterns(user.getId());
        
        if (insight != null && insight.isActionable()) {
            return createAlert(
                user.getId(),
                AlertType.INSIGHT,
                AlertPriority.LOW,
                "💡 Insight Found",
                insight.getMessage(),
                null,
                "/expert"
            );
        }
        
        return null;
    }
    
    /**
     * Apply user preferences and filtering rules
     */
    private List<Alert> applyUserPreferences(List<Alert> alerts, User user) {
        UserAlertPreferences prefs = getUserPreferences(user.getId());
        
        return alerts.stream()
            .filter(alert -> prefs.isAlertTypeEnabled(alert.getAlertType()))
            .filter(alert -> alert.getPriority().getLevel() >= prefs.getMinSensitivity())
            .filter(alert -> !shouldSuppressDuplicate(alert, user))
            .collect(Collectors.toList());
    }
    
    /**
     * Control alert frequency to avoid notification fatigue
     */
    private List<Alert> controlAlertFrequency(List<Alert> alerts, User user) {
        // Don't send more than 3 alerts per day
        if (alerts.size() > 3) {
            // Keep only highest priority alerts
            return alerts.stream()
                .sorted((a, b) -> b.getPriority().getLevel() - a.getPriority().getLevel())
                .limit(3)
                .collect(Collectors.toList());
        }
        
        return alerts;
    }
    
    /**
     * Deliver alert to user via notification system
     */
    private void deliverAlert(Alert alert, User user) {
        UserAlertPreferences prefs = getUserPreferences(user.getId());
        
        // Send via email if enabled
        if (prefs.isEmailNotificationsEnabled()) {
            sendEmailNotification(alert, user);
        }
        
        // Send via in-app notification
        sendInAppNotification(alert, user);
    }
    
    /**
     * Check if alert should be suppressed (duplicate, snoozed, etc.)
     */
    private boolean shouldSuppressDuplicate(Alert alert, User user) {
        LocalDateTime oneDayAgo = LocalDateTime.now().minusDays(1);
        
        List<Alert> recentAlerts = alertRepository.findAlertsSince(
            user.getId(), 
            alert.getAlertType(), 
            oneDayAgo
        );
        
        return !recentAlerts.isEmpty();
    }
    
    /**
     * Helper: Create alert object
     */
    private Alert createAlert(String userId, AlertType type, AlertPriority priority,
                             String title, String message, String relatedDataId, 
                             String actionUrl) {
        Alert alert = new Alert();
        alert.setAlertId(generateAlertId());
        alert.setUserId(userId);
        alert.setAlertType(type);
        alert.setPriority(priority);
        alert.setTitle(title);
        alert.setMessage(message);
        alert.setRelatedDataId(relatedDataId);
        alert.setActionUrl(actionUrl);
        alert.setCreatedAt(LocalDateTime.now());
        alert.setIsDismissed(false);
        
        return alert;
    }
    
    // Helper methods
    private Map<String, Integer> getRegretPatterns(User user) {
        List<Regret> recentRegrets = regretDAO.getLastNRegrets(user.getId(), 10);
        Map<String, Integer> patterns = new HashMap<>();
        
        for (Regret regret : recentRegrets) {
            String description = regret.getDescription();
            patterns.put(description, patterns.getOrDefault(description, 0) + 1);
        }
        
        return patterns;
    }
    
    private int getDaysSinceLastLogged(Habit habit) {
        LocalDateTime lastLogged = habitDAO.getLastLogDate(habit.getHabitId());
        return (int) ChronoUnit.DAYS.between(lastLogged, LocalDateTime.now());
    }
    
    private List<TimeCapsule> getReadyTimeCapsules(User user) {
        // Implementation depends on TimeCapsule module
        return new ArrayList<>();
    }
    
    private String generateAlertId() {
        return "ALERT_" + System.currentTimeMillis();
    }
}
```

---

#### 3. **AlertDAO.java** (Database Access)
```java
package com.emovault.dao;

import com.emovault.model.*;
import com.emovault.util.DBConnection;
import java.sql.*;
import java.util.*;
import java.time.LocalDateTime;

public class AlertDAO {
    
    public void saveAlert(Alert alert) {
        String sql = "INSERT INTO alerts (alert_id, user_id, alert_type, priority, title, " +
                     "message, related_data_id, action_url, created_at, is_dismissed) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, alert.getAlertId());
            stmt.setString(2, alert.getUserId());
            stmt.setString(3, alert.getAlertType().name());
            stmt.setString(4, alert.getPriority().name());
            stmt.setString(5, alert.getTitle());
            stmt.setString(6, alert.getMessage());
            stmt.setString(7, alert.getRelatedDataId());
            stmt.setString(8, alert.getActionUrl());
            stmt.setTimestamp(9, Timestamp.valueOf(alert.getCreatedAt()));
            stmt.setBoolean(10, alert.isDismissed());
            
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public List<Alert> getUnreadAlerts(String userId) {
        String sql = "SELECT * FROM alerts WHERE user_id = ? AND is_dismissed = false " +
                     "ORDER BY created_at DESC";
        
        List<Alert> alerts = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                alerts.add(mapResultSetToAlert(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return alerts;
    }
    
    public void dismissAlert(String alertId) {
        String sql = "UPDATE alerts SET is_dismissed = true, dismissed_at = ? " +
                     "WHERE alert_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setString(2, alertId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    private Alert mapResultSetToAlert(ResultSet rs) throws SQLException {
        Alert alert = new Alert();
        alert.setAlertId(rs.getString("alert_id"));
        alert.setUserId(rs.getString("user_id"));
        alert.setAlertType(AlertType.valueOf(rs.getString("alert_type")));
        alert.setPriority(AlertPriority.valueOf(rs.getString("priority")));
        alert.setTitle(rs.getString("title"));
        alert.setMessage(rs.getString("message"));
        alert.setRelatedDataId(rs.getString("related_data_id"));
        alert.setActionUrl(rs.getString("action_url"));
        alert.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        alert.setIsDismissed(rs.getBoolean("is_dismissed"));
        
        return alert;
    }
}
```

---

#### 4. **AlertServlet.java** (HTTP Handler)
```java
package com.emovault.servlet;

import com.emovault.model.*;
import com.emovault.service.*;
import com.emovault.dao.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/alerts")
public class AlertServlet extends HttpServlet {
    private AlertSystem alertSystem;
    private AlertDAO alertDAO;
    
    @Override
    public void init() {
        this.alertSystem = new AlertSystem();
        this.alertDAO = new AlertDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Get unread alerts
        List<Alert> alerts = alertDAO.getUnreadAlerts(user.getId());
        request.setAttribute("alerts", alerts);
        
        // Forward to alerts view
        request.getRequestDispatcher("alerts.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("dismiss".equals(action)) {
            String alertId = request.getParameter("alert_id");
            alertDAO.dismissAlert(alertId);
            response.setStatus(HttpServletResponse.SC_OK);
        }
    }
}
```

---

## 📊 Database Schema

```sql
CREATE TABLE alerts (
    alert_id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL,
    alert_type VARCHAR(50) NOT NULL,
    priority VARCHAR(20) NOT NULL,
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    related_data_id VARCHAR(50),
    action_url VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dismissed_at TIMESTAMP,
    is_dismissed BOOLEAN DEFAULT false,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    INDEX idx_user_alerts (user_id, is_dismissed),
    INDEX idx_created_at (created_at)
);

CREATE TABLE user_alert_preferences (
    preference_id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL UNIQUE,
    emotional_risk_enabled BOOLEAN DEFAULT true,
    behavioral_pattern_enabled BOOLEAN DEFAULT true,
    habit_disruption_enabled BOOLEAN DEFAULT true,
    time_sensitive_enabled BOOLEAN DEFAULT true,
    insight_enabled BOOLEAN DEFAULT false,
    min_sensitivity INT DEFAULT 2,
    email_notifications_enabled BOOLEAN DEFAULT false,
    quiet_hours_start TIME,
    quiet_hours_end TIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
```

---

## 🔄 Integration Workflow

```
1. User completes diary/emotion/habit entry
           ↓
2. Trigger point: AlertSystem.analyzeUserAndGenerateAlerts()
           ↓
3. Run 5 detection methods (risk, behavior, habit, time, insight)
           ↓
4. Filter alerts (user prefs, frequency control)
           ↓
5. Save to database
           ↓
6. Deliver via notification system
           ↓
7. Display on dashboard & alert history
           ↓
8. User dismisses/acts on alert
```

---

## 🧪 Testing Checklist

- [ ] Emotional risk alert triggers correctly on sustained high stress
- [ ] Behavioral pattern alert detects repeated regrets
- [ ] Habit disruption alert notifies on streak break
- [ ] Time-sensitive alerts trigger at correct times
- [ ] Alert frequency limits work (max 3/day)
- [ ] Duplicate suppression prevents same alert twice
- [ ] User preferences are respected
- [ ] Dismissed alerts don't reappear
- [ ] Alert data is persisted correctly
- [ ] Notification delivery works (email, in-app)

---

**Version:** 1.0  
**Implementation Status:** ✅ Ready to Code

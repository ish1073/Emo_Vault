# Alerts Module - Quick Reference Guide

## 🎯 At a Glance

**Purpose:** Real-time notification system for emotional patterns, behavioral risks, and time-sensitive events.

**Key Principle:** "Meaningful, not frequent" - Every alert should answer: What happened? Why matters? What to do?

---

## 📊 Alert Types Quick Lookup

| Type | Trigger | Example | Icon |
|------|---------|---------|------|
| **EMOTIONAL_RISK** | Sustained high stress, low mood | "Stress > 8 for 3+ days" | ⚠️ |
| **BEHAVIORAL_PATTERN** | Repeated regrets, procrastination | "Mentioned X 3+ times/week" | 📊 |
| **HABIT_DISRUPTION** | Streak broken, habit missed | "12-day meditation streak broken" | 🔥 |
| **TIME_SENSITIVE** | Time capsule ready, milestones | "Time capsule ready to open" | 📬 |
| **INSIGHT** | Expert analysis, actionable finding | "Exercise correlates with mood" | 💡 |

---

## 🔧 Implementation Checklist

### Phase 1: Core Infrastructure
- [ ] Create `Alert.java` entity class
- [ ] Create `AlertType` and `AlertPriority` enums
- [ ] Create `alerts` and `user_alert_preferences` database tables
- [ ] Create `AlertDAO.java` for database operations
- [ ] Create `AlertRepository.java` for query abstraction

### Phase 2: Business Logic
- [ ] Create `AlertSystem.java` service class
- [ ] Implement emotional risk detection
- [ ] Implement behavioral pattern detection
- [ ] Implement habit disruption detection
- [ ] Implement time-sensitive event detection
- [ ] Implement expert insight detection

### Phase 3: Integration
- [ ] Create `AlertServlet.java` HTTP handler
- [ ] Create `alerts.jsp` display view
- [ ] Integrate with notification system
- [ ] Add alert preferences UI
- [ ] Add alert history functionality

### Phase 4: Testing & Refinement
- [ ] Unit test each alert detection method
- [ ] Integration tests with real data
- [ ] User acceptance testing
- [ ] Performance optimization

---

## 💻 Key Code Snippets

### **Trigger Alert Detection (Main Entry Point)**
```java
// Called when user completes any action
User user = getCurrentUser();
List<Alert> alerts = alertSystem.analyzeUserAndGenerateAlerts(user);
// Alerts automatically filtered, stored, and delivered
```

### **Create a New Alert Type**
```java
// 1. Add to AlertType enum
public enum AlertType {
    NEW_TYPE("Description");
}

// 2. Create detection method in AlertSystem
private Alert detectNewTypeAlert(User user) {
    // Your logic here
    if (condition) {
        return createAlert(
            user.getId(),
            AlertType.NEW_TYPE,
            AlertPriority.HIGH,
            "Title",
            "Message body",
            relatedDataId,
            "/action-url"
        );
    }
    return null;
}

// 3. Add to main analysis method
alerts.add(detectNewTypeAlert(user));
```

### **Access Alert History**
```java
// Get all unread alerts for user
List<Alert> unread = alertDAO.getUnreadAlerts(userId);

// Get alerts by type
List<Alert> riskAlerts = alertDAO.getAlertsByType(userId, AlertType.EMOTIONAL_RISK);

// Get alerts from last 7 days
List<Alert> recent = alertDAO.getAlertsSince(userId, LocalDateTime.now().minusDays(7));
```

### **User Dismisses Alert**
```java
// User clicks "Dismiss" button
alertDAO.dismissAlert(alertId);

// Alert no longer shows in unread alerts
// Stored in history for analytics
```

---

## 📱 User Preference Settings

```java
UserAlertPreferences {
    // Enable/disable by type
    boolean emotionalRiskEnabled;
    boolean behavioralPatternEnabled;
    boolean habitDisruptionEnabled;
    boolean timeSensitiveEnabled;
    boolean insightEnabled;
    
    // Frequency control
    int minSensitivity;  // 1=LOW, 2=MEDIUM, 3=HIGH, 4=CRITICAL
    int maxAlertsPerDay; // Default: 3
    
    // Delivery
    boolean emailNotificationsEnabled;
    LocalTime quietHoursStart;
    LocalTime quietHoursEnd;
}
```

---

## 🔗 Integration Points

### **From Other Modules**
- **Emotion Module** → Provides stress levels, mood data
- **Habit Module** → Provides streak info, completion data
- **Regret Module** → Provides regret entries for pattern analysis
- **Diary Module** → Provides reflection data
- **Expert System** → Provides insights and recommendations

### **To Other Modules**
- **Dashboard** → Shows alert badges, count, summary
- **Notification System** → Delivers alerts via email/push
- **Analytics** → Alert statistics and effectiveness
- **User Settings** → Alert preference management

---

## 🧪 Testing Guide

### **Unit Test Example**
```java
@Test
public void testEmotionalRiskAlertTriggersOn3DaysHighStress() {
    User user = createTestUser();
    addEmotionEntries(user, 9, 8, 8, 9, 8); // 5 high-stress entries
    
    Alert alert = alertSystem.detectEmotionalRiskAlert(user);
    
    assertNotNull(alert);
    assertEquals(AlertType.EMOTIONAL_RISK, alert.getAlertType());
    assertEquals(AlertPriority.HIGH, alert.getPriority());
}
```

### **Integration Test Example**
```java
@Test
public void testFullAlertWorkflow() {
    User user = createTestUser();
    
    // User adds emotion entries
    emotionDAO.addEmotion(user.getId(), 9, "work stress");
    emotionDAO.addEmotion(user.getId(), 8, "work stress");
    emotionDAO.addEmotion(user.getId(), 8, "work stress");
    
    // Trigger analysis
    List<Alert> alerts = alertSystem.analyzeUserAndGenerateAlerts(user);
    
    // Verify alert was created and stored
    assertEquals(1, alerts.size());
    Alert savedAlert = alertDAO.getUnreadAlerts(user.getId()).get(0);
    assertNotNull(savedAlert);
}
```

---

## 📈 Performance Considerations

### **Optimization Tips**
1. **Cache** user preferences to avoid database hits
2. **Batch** alert analysis for multiple users
3. **Index** database queries on user_id, created_at
4. **Schedule** alert analysis during off-peak hours
5. **Limit** frequency checks to recent data (last 30 days)

### **Scalability**
- Run alert analysis asynchronously via job queue
- Use database indexing for fast queries
- Implement alert deduplication at application level
- Archive old alerts to reduce table size

---

## 🐛 Common Issues & Solutions

| Issue | Cause | Solution |
|-------|-------|----------|
| Too many alerts | Frequency control not working | Check `controlAlertFrequency()` logic |
| Alerts not appearing | User preferences disabled it | Check `UserAlertPreferences` table |
| Duplicate alerts | No suppression logic | Add to `shouldSuppressDuplicate()` |
| Performance slow | Too much data analysis | Limit to recent entries only |
| Notifications not sent | Delivery system down | Check notification service logs |

---

## 📚 Database Queries

### **Find High-Risk Users**
```sql
SELECT u.user_id, COUNT(*) as alert_count
FROM users u
LEFT JOIN alerts a ON u.user_id = a.user_id
WHERE a.priority = 'CRITICAL'
  AND a.created_at > DATE_SUB(NOW(), INTERVAL 7 DAY)
GROUP BY u.user_id
HAVING alert_count > 2;
```

### **Get User's Alert Statistics**
```sql
SELECT alert_type, COUNT(*) as count
FROM alerts
WHERE user_id = ? 
  AND created_at > DATE_SUB(NOW(), INTERVAL 30 DAY)
GROUP BY alert_type;
```

### **Find Most Dismissed Alert Types**
```sql
SELECT alert_type, COUNT(*) as dismissed_count
FROM alerts
WHERE is_dismissed = true
  AND dismissed_at > DATE_SUB(NOW(), INTERVAL 30 DAY)
GROUP BY alert_type
ORDER BY dismissed_count DESC;
```

---

## 🚀 Deployment Checklist

- [ ] Database tables created and indexed
- [ ] AlertSystem service integrated into startup
- [ ] Notification system configured
- [ ] Alert preferences UI added to settings
- [ ] alerts.jsp deployed
- [ ] AlertServlet mapped in web.xml
- [ ] Logging configured for alert generation
- [ ] Backup strategy for alert history
- [ ] Email templates ready
- [ ] Error handling and recovery in place

---

## 📖 Module Documentation Files

1. **ALERTS_MODULE_DEFINITION.md** - High-level specification
2. **ALERTS_IMPLEMENTATION_GUIDE.md** - Code implementation
3. **alerts.jsp** - UI for alert display
4. **ALERTS_QUICK_REFERENCE.md** - This file

---

## 🔗 Related Documentation

- **Expert System:** `EXPERT_SYSTEM_IMPLEMENTATION.md`
- **Risk Analyzer:** See `RiskAnalyzer.java`
- **Dashboard:** `dashboard.jsp`
- **Notification System:** See `NotificationService.java`

---

## 💡 Pro Tips

1. **Start simple:** Implement emotional risk alerts first, add others gradually
2. **Test with data:** Use real user data to validate alert triggers
3. **User feedback:** Iterate based on user input on alert relevance
4. **Monitor metrics:** Track which alerts users find most helpful
5. **Iterate:** Refine threshold values based on real usage patterns

---

**Last Updated:** April 20, 2026  
**Status:** ✅ Ready for Development  
**Questions?** Refer to main module definition document

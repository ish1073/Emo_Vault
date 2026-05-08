# EmoVault Alerts Module - Definition & Specification

## 📋 Module Overview

The **Alerts Module** is a real-time guidance system that monitors user emotional patterns, behavioral trends, and system events to deliver **meaningful, actionable notifications** that help users stay aware of their mental health status and take timely corrective actions.

**Module Name:** `AlertSystem` / `AlertModule`  
**Primary Responsibility:** Pattern detection, risk assessment, and user notification  
**Trigger Type:** Rule-based, event-driven, and scheduled analysis  

---

## 🎯 Core Responsibilities

### 1. **Risk Detection & Notification**
- Monitor emotional state trends for high-risk patterns (e.g., sustained high stress)
- Detect repeated negative emotional cycles
- Identify escalating anxiety or depression signals
- Alert users before emotional states become critical

### 2. **Behavioral Pattern Monitoring**
- Track regret frequency and intensity
- Monitor habit streak disruptions
- Identify procrastination or avoidance patterns
- Detect behavioral regression or negative trends

### 3. **System Event Management**
- Notify users of time-capsule messages ready to open
- Remind users about habit tracking deadlines
- Prompt diary reflections when patterns suggest need
- Schedule wellness check-in reminders

### 4. **Actionable Recommendations**
- Suggest coping strategies based on detected patterns
- Recommend habit adjustments or habit tracking focus
- Propose diary entries or reflections
- Offer expert system insights when available

---

## 📢 Alert Types & Triggers

### **Type 1: Emotional Risk Alerts**
**When to Trigger:**
- Stress level > 8 for 3+ consecutive entries
- Anxiety indicators increasing for 5+ consecutive days
- Mood dropping below 3 for sustained period
- Negative emotional state in critical time windows (work, social settings)

**Alert Message Example:**
```
⚠️ STRESS ALERT
Your stress levels have been consistently high this week. 
Consider taking a break or trying a coping strategy.
→ View coping strategies
```

---

### **Type 2: Behavioral Pattern Alerts**
**When to Trigger:**
- Same regret logged 3+ times in past week
- Habit streak broken after 7+ consecutive days
- Habit completion rate dropping below 50%
- Repeated procrastination patterns detected

**Alert Message Example:**
```
📊 BEHAVIOR PATTERN DETECTED
You've mentioned "perfectionism stress" 4 times this week.
This might be worth exploring deeper in your diary.
→ Start a reflection
```

---

### **Type 3: Habit Disruption Alerts**
**When to Trigger:**
- Active habit not logged for 2+ scheduled days
- Habit completion streak broken
- Multiple habit failures in same day
- Habit frequency dropped significantly

**Alert Message Example:**
```
🔥 STREAK BROKEN
Your "Morning Meditation" streak ended at 12 days.
Ready to start a new one?
→ Log today's habit
```

---

### **Type 4: Time-Sensitive Alerts**
**When to Trigger:**
- Time capsule message ready to open
- Scheduled reminder time reached
- Diary milestone reached (e.g., 100 entries)
- Week/month review due

**Alert Message Example:**
```
📬 TIME CAPSULE READY
A message from your past self is ready to open!
Message date: March 20, 2026
→ Open message
```

---

### **Type 5: Expert System Insights**
**When to Trigger:**
- Pattern analysis reveals actionable insight
- Expert system recommendation generated
- Risk mitigation strategy available
- Behavioral breakthrough opportunity detected

**Alert Message Example:**
```
💡 INSIGHT FROM ANALYSIS
Your data shows exercise strongly correlates with better mood.
Consider increasing exercise frequency.
→ View full insight
```

---

## ✅ Alert Characteristics

### **Meaningfulness**
- ✅ Based on real pattern analysis, not arbitrary rules
- ✅ Personalized to user's specific data and history
- ✅ Avoid generic or templated messages
- ✅ Only alert when threshold for concern is clearly met

### **Frequency Control**
- ✅ Maximum 2-3 alerts per day (avoid notification fatigue)
- ✅ Group similar alerts (e.g., multiple habit failures → single alert)
- ✅ No duplicate alerts within 24 hours
- ✅ Respect user's alert preferences and quiet hours

### **Clarity & Actionability**
- ✅ Clear, concise message (max 2-3 sentences)
- ✅ Specific insight or observation (not vague warnings)
- ✅ Immediate next action available (button/link)
- ✅ Context provided (when, what, why)

### **Relevance**
- ✅ Only show alerts user has enabled
- ✅ Respect user's alert sensitivity settings
- ✅ Consider time of day and context
- ✅ Prioritize critical alerts over informational ones

---

## 🔗 Integration Points

### **Data Sources**
- **Emotion Module:** Recent emotion entries and trends
- **Diary Module:** Diary entries and reflection data
- **Habit Module:** Habit completion and streak data
- **Regret Module:** Regret entries and patterns
- **Expert System:** Pattern analysis and insights
- **RiskAnalyzer:** Risk scoring and assessment

### **Output Destinations**
- **Dashboard:** Alert badges and summary counts
- **Notification System:** Push/email notifications
- **Alert History:** Persistent log of all alerts
- **User Preferences:** User alert customization

### **Data Flow**
```
Emotion/Diary/Habit/Regret Data
         ↓
    Rule Engine (AlertSystem)
         ↓
    Pattern Analysis & Risk Assessment
         ↓
    Alert Generation & Filtering
         ↓
    Notification & Storage
         ↓
    User Dashboard & History
```

---

## 🎲 Alert Triggering Logic

### **Rule-Based Engine**
Each alert type has defined rules:

```
IF (condition1 AND condition2 AND NOT suppression_rule) THEN
  Generate Alert(type, priority, message, action)
ENDIF
```

### **Threshold Examples**

| Metric | Threshold | Action |
|--------|-----------|--------|
| Consecutive high stress | 3+ days with stress > 8 | Trigger emotional risk alert |
| Regret repetition | Same regret 3+ times/week | Trigger behavioral pattern alert |
| Habit streak break | Active habit not logged 2+ days | Trigger disruption alert |
| Alert frequency | 3+ alerts same type/day | Suppress duplicates, group instead |
| User snooze window | Alert dismissed by user | Suppress similar alerts for 24h |

---

## 📊 Alert Priority Levels

### **CRITICAL (Red)**
- High suicide/self-harm risk indicators
- Severe escalating mental health crisis
- **Action:** Immediate notification + emergency resources

### **HIGH (Orange)**
- Sustained dangerous emotional states (stress > 9)
- Repeated self-destructive patterns
- **Action:** Urgent notification, recommended professional help

### **MEDIUM (Yellow)**
- Concerning patterns requiring attention
- Habit disruptions, behavioral changes
- **Action:** Standard notification, suggested actions

### **LOW (Blue)**
- Informational alerts, reminders, insights
- Positive progress and milestones
- **Action:** Standard notification, optional action

---

## 💾 Alert Storage & History

### **Alert Data Structure**
```java
Alert {
  - alertId (unique)
  - userId (owner)
  - alertType (enum: RISK, BEHAVIOR, HABIT, TIME_SENSITIVE, INSIGHT)
  - priority (enum: CRITICAL, HIGH, MEDIUM, LOW)
  - title (short alert title)
  - message (alert body)
  - relatedDataId (emotion/habit/regret entry)
  - actionUrl (where to go next)
  - createdAt (timestamp)
  - dismissedAt (timestamp or null)
  - isDismissed (boolean)
  - userSeenAt (timestamp or null)
}
```

### **Retention Policy**
- Keep all alerts for 90 days
- Archive dismissed alerts after 30 days
- Maintain alert history in Dashboard view

---

## 🛠️ Implementation Architecture

### **AlertSystem Class Responsibilities**
1. **Monitoring:** Periodically analyze user data
2. **Detection:** Apply rule-based logic to detect conditions
3. **Generation:** Create alert objects with appropriate content
4. **Filtering:** Apply suppression/frequency rules
5. **Delivery:** Send alerts via notification system
6. **Storage:** Persist alerts to database

### **Key Methods**
```java
// Core methods
public Alert generateEmotionalRiskAlert(User user)
public Alert generateBehaviorPatternAlert(User user)
public Alert generateHabitDisruptionAlert(User user)
public Alert generateTimeSensitiveAlert(User user)
public Alert generateInsightAlert(User user)

// Support methods
public List<Alert> getPendingAlerts(User user)
public void dismissAlert(Alert alert)
public void snoozeAlert(Alert alert, Duration duration)
public List<Alert> getAlertHistory(User user, int days)
public void applyUserPreferences(Alert alert, User user)
```

---

## 🎛️ User Customization Options

### **Alert Preferences**
- [ ] Enable/disable by alert type
- [ ] Set alert frequency (low, normal, high sensitivity)
- [ ] Define quiet hours (no alerts between X and Y)
- [ ] Set minimum risk threshold before alerting
- [ ] Choose notification method (in-app, email, SMS)

### **Preference Defaults**
- Emotional Risk Alerts: **Enabled**
- Behavioral Pattern Alerts: **Enabled**
- Habit Disruption Alerts: **Enabled**
- Time-Sensitive Alerts: **Enabled**
- Insight Alerts: **Disabled** (user can enable)

---

## 📈 Success Metrics

### **Quantitative Metrics**
- Alert precision: % of alerts user finds relevant
- Alert timeliness: % of alerts delivered before crisis point
- User engagement: % of users acting on alerts
- Dismissal rate: % of alerts dismissed (target: <30%)

### **Qualitative Metrics**
- User feedback on alert helpfulness
- Correlation between alerts and positive behavioral change
- User satisfaction with alert timing and frequency

---

## 🔒 Safety & Privacy Considerations

### **Data Handling**
- Only use user's own data for alert generation
- Never share alert content with other users
- Encrypt sensitive alert information
- Comply with data retention policies

### **Ethical Considerations**
- Avoid accusatory or shame-inducing language
- Prioritize user autonomy (user chooses actions)
- Don't create alert dependency
- Balance guidance with user control

### **Crisis Handling**
- For critical risk alerts, include mental health resources
- Provide emergency contact information
- Recommend professional help when appropriate
- Log critical alerts for safety review

---

## 📝 Example Alert Scenarios

### **Scenario 1: Sustained Stress Pattern**
```
Last 5 entries:
- Day 1: Stress 8
- Day 2: Stress 8
- Day 3: Stress 9
- Day 4: Stress 8
- Day 5: Stress 8

→ Alert generated: "Your stress has been consistently high"
Priority: MEDIUM
Action: "View stress management strategies"
```

### **Scenario 2: Repeated Regret**
```
Past week entries:
- "Didn't exercise again" (3x)
- "Yelled at family" (2x)
- "Procrastinated work" (1x)

→ Alert generated: "You've mentioned 'didn't exercise' 3 times"
Priority: MEDIUM
Action: "Start a reflection on exercise barriers"
```

### **Scenario 3: Habit Streak Broken**
```
Habit: "Morning Meditation"
Streak: 12 days (broken)
Missed: 2 days in a row

→ Alert generated: "Your meditation streak ended at 12 days"
Priority: LOW
Action: "Log today's meditation"
```

### **Scenario 4: Time Capsule Ready**
```
Time Capsule: "Recovery Plan"
Original date: March 15, 2026
Target date: April 20, 2026 (TODAY)
Status: READY TO OPEN

→ Alert generated: "Time capsule 'Recovery Plan' is ready to open"
Priority: MEDIUM
Action: "Open time capsule"
```

---

## 🚀 Future Enhancements

1. **ML-Based Prediction:** Predict emotional crises before they occur
2. **Peer Alerts:** Anonymous alerts comparing patterns to anonymous peer data
3. **Pro-Active Suggestions:** AI suggests habits or activities before crisis
4. **Wearable Integration:** Combine alerts with fitness/health device data
5. **Therapist Alerts:** Optional shared alerts with mental health professional
6. **Ambient Notifications:** Subtle reminders (e.g., color-changing device)

---

## 📚 Related Modules

- **Emotion Module:** Source of emotional state data
- **Expert System:** Provides insights and recommendations
- **Risk Analyzer:** Performs risk assessment
- **Dashboard:** Displays alerts to users
- **Notification System:** Delivers alerts to users
- **User Preferences:** Manages alert customization

---

## ✨ Module Philosophy

> *"The Alerts Module is not a nagging system, but a compassionate guide that helps users see themselves clearly and act wisely. Every alert should answer three questions: (1) What happened? (2) Why does it matter? (3) What can you do about it?"*

---

**Version:** 1.0  
**Last Updated:** April 20, 2026  
**Status:** ✅ Defined & Ready for Implementation

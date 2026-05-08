# EmoVault - Behavior Analyzer Testing & Demo Guide

## FIXES COMPLETED ✅

### 1. Reflection Visibility Issue - FIXED
**Problem**: Reflections entered in Time Capsule weren't being saved or displayed in past reflections.

**Solution Applied**:
- Added proper form action attributes to both create and reflect forms in `timecapsule.jsp`
- Forms now properly route to `${pageContext.request.contextPath}/timecapsule` servlet
- All POST forms (delete, open, create, reflect) now have correct action URLs

**Files Modified**:
- `/WebContent/timecapsule.jsp` - Added action attributes to all forms

**How to Test**:
1. Navigate to Time Capsule module
2. Click "+ Create New Capsule"
3. Fill in message, goal, mood, and target date (today or future)
4. Click "🔐 Seal Capsule"
5. You should see success message ✓
6. Once target date is reached, click "🎁 Open Capsule"
7. Click "Add Reflection" button
8. Fill in reflection text, mood, and achievement status
9. Click "Save Reflection"
10. Your reflection should now be visible in the opened capsule card

---

## BEHAVIOR ANALYZER & ANALYTICS IMPLEMENTATION

### Architecture Updated

#### BehaviorAnalysisDAO - COMPLETE
Now includes comprehensive queries for:
- ✅ Emotion statistics (frequency, average intensity)
- ✅ Emotion distribution (pie chart data)
- ✅ Mood trends (line chart data)
- ✅ Negative emotion counting
- ✅ Regret analysis
- ✅ Habit consistency metrics
- ✅ Diary entry analysis
- ✅ Data sufficiency checking

#### BehaviorAnalysisEngine - READY
Rule-based analysis engine that implements:
- ✅ Dominant emotion detection
- ✅ Risk level assessment (Low/Medium/High)
- ✅ Behavior loop detection
- ✅ Pattern matching for procrastination, isolation, reactive behavior
- ✅ Personalized suggestions based on emotion and risk
- ✅ Habit consistency insights

#### Display Pages
- `behavior_analyzer.jsp` - Shows individual insights
- `analytics.jsp` - Shows comprehensive charts and reports

---

## HOW TO TEST: Complete Workflow

### Prerequisites
1. Ensure Tomcat is running
2. Database connection is active
3. User is logged in

### Test Scenario 1: High Risk (Stress + Procrastination)
**Goal**: Demonstrate high-risk detection with behavior loop

**Step-by-Step**:
1. Log in to EmoVault
2. **Add Emotions** (Emotion Logging Module):
   - Add 8 emotion logs with "Stressed" mood
   - Intensity: 8-10 for each
   - Triggers: "Deadline approaching", "Too much work", "Can't focus"
   - Add 3 more with "Anxious" (intensity 7-9)
   - Add 2 with "Frustrated" (intensity 6-8)

3. **Add Regrets** (Reflections/Regrets Module):
   - Add regret: "I delayed starting the project"
   - Tag: "Procrastination"
   - Add regret: "I procrastinated and now rushing"
   - Tag: "Procrastination"
   - Add regret: "Didn't plan ahead"
   - Tag: "Planning"

4. **Habit Status**:
   - If you have a "Daily Planning" habit, make sure streak is broken (0)

5. **Check Behavior Analyzer**:
   - Expected Output:
     - ✓ Dominant Emotion: Stressed
     - ✓ Risk Level: **HIGH** (red badge)
     - ✓ Pattern: "Stress → Procrastination → Regret"
     - ✓ Suggestions:
       - 🧘 Stress management meditation
       - ⏰ Pomodoro Technique
       - ✅ Break tasks into steps
       - 🏗️ Reactivate planning habit

**Expected UI Display**:
```
┌─────────────────────────────────────┐
│  📊 BEHAVIOR ANALYZER               │
├─────────────────────────────────────┤
│ Dominant Emotion: 😰 Stressed       │
│ Risk Level: 🔴 HIGH                │
├─────────────────────────────────────┤
│ Pattern Detected:                   │
│ Stress → Procrastination → Regret   │
├─────────────────────────────────────┤
│ Suggestions:                        │
│ • Consider daily meditation         │
│ • Try Pomodoro Technique            │
│ • Break large tasks down            │
│ • Reactivate a habit                │
└─────────────────────────────────────┘
```

---

### Test Scenario 2: Low Risk (Positive & Active)
**Goal**: Demonstrate low-risk detection with positive patterns

**Step-by-Step**:
1. Create NEW TEST USER (or clear previous data)

2. **Add Emotions** (Positive Mix):
   - Add 10 logs with "Happy" mood (intensity 7-8)
   - Add 5 logs with "Calm" mood (intensity 6-7)
   - Add 3 logs with "Excited" mood (intensity 8-9)
   - Add only 1 log with "Sad" (intensity 3)
   - Add 1 log with "Anxious" (intensity 4)

3. **No Regrets**:
   - Don't add any regret entries

4. **Active Habits**:
   - Create a "Daily Exercise" habit with streak: 15 days
   - Create a "Meditation" habit with streak: 8 days
   - Consistency score: 80+

5. **Check Behavior Analyzer**:
   - Expected Output:
     - ✓ Dominant Emotion: Happy
     - ✓ Risk Level: **LOW** (green badge)
     - ✓ Pattern: "Positive momentum maintained"
     - ✓ Suggestions:
       - ✨ Keep up with joyful activities
       - 🎯 Consider setting new growth goals
       - 🤝 Help others with your positive energy

---

### Test Scenario 3: Medium Risk (Mixed Emotions)
**Goal**: Demonstrate medium-risk detection with balanced patterns

**Step-by-Step**:
1. Create NEW TEST USER

2. **Mixed Emotions**:
   - Add 5 "Happy" logs (intensity 6-7)
   - Add 3 "Calm" logs (intensity 6)
   - Add 2 "Anxious" logs (intensity 6-7)
   - Add 2 "Sad" logs (intensity 5)
   - Add 1 "Stressed" log (intensity 5)

3. **Some Regrets**:
   - Add 1 regret: "Didn't follow through on promise"
   - Add 1 regret: "Skipped one workout this week"

4. **Mixed Habit Status**:
   - 1 active habit (e.g., Exercise, streak 5)
   - 1 broken habit (e.g., Reading, streak 0)

5. **Check Behavior Analyzer**:
   - Expected Output:
     - ✓ Dominant Emotion: Calm
     - ✓ Risk Level: **MEDIUM** (orange badge)
     - ✓ Pattern: "Inconsistent emotional patterns"
     - ✓ Suggestions:
       - 📅 Establish consistent routines
       - 🏗️ Reactivate broken habit
       - 📝 Regular journaling for stability

---

## ANALYTICS & REPORTS PAGE FEATURES

### Charts & Visualizations

#### 1. Emotional Distribution (Pie Chart)
Shows % breakdown of moods in last 30 days
```
Happy:     35%
Calm:      30%
Anxious:   20%
Sad:       10%
Stressed:   5%
```

#### 2. Mood Intensity Trend (Line Chart)
X-axis: Dates (last 30 days)
Y-axis: Average intensity (1-10)
Shows trend line to visualize patterns

#### 3. Habit Progress Cards
- Total Habits: 5
- Active Streaks: 3
- Consistency Score: 78%
- Best Streak: "Daily Exercise" (25 days)

#### 4. Repeated Regret Insight
- Most Common Regret Type: "Procrastination"
- Frequency: 3 occurrences
- Related Emotions: Stress, Anxiety
- Suggested Action: Build anti-procrastination habit

#### 5. Summary Insight Card
Generates a combined paragraph like:
> "Over the past 30 days, you've experienced mostly calm and happy moments with an average mood intensity of 6.8/10. However, you show signs of stress before deadlines with 3 procrastination-related regrets. To improve, consider implementing the Pomodoro technique and building a planning habit. Your positive habit streaks are a great sign of consistency!"

---

## DYNAMIC BEHAVIOR - TESTING

### How Updates Work
1. User adds new emotion log → Analyzer recalculates
2. User adds regret → Pattern detection updates
3. User logs habit → Consistency metrics change
4. User writes diary → Content analysis updates

### Testing Dynamic Updates
1. Open Behavior Analyzer page
2. Note the current Dominant Emotion and Risk Level
3. Go to Emotion Logging
4. Add 5 "Stressed" emotions with intensity 9
5. Refresh Behavior Analyzer page
6. **Expected**: Dominant Emotion should change, Risk Level should increase

---

## TROUBLESHOOTING CHECKLIST

### If Reflections Still Don't Show
- [ ] Verify form action URLs point to `/timecapsule` servlet
- [ ] Check browser console for JavaScript errors
- [ ] Ensure TimeCapsuleServlet is correctly mapped in web.xml
- [ ] Verify database has `reflection`, `reflection_mood`, and `achievement_status` columns in `time_capsules` table

### If Behavior Analyzer Shows "Insufficient Data"
- [ ] Add at least 3 emotion logs in last 30 days
- [ ] System requires minimum 3 data points for analysis
- [ ] Check database connectivity

### If Charts Don't Load
- [ ] Verify Chart.js library is loaded (check analytics.jsp)
- [ ] Check browser console for chart initialization errors
- [ ] Ensure data is being passed from servlet correctly

### If Analytics Page is Blank
- [ ] Verify user is logged in (session.getAttribute("userId"))
- [ ] Check servlet is forwarding to analytics.jsp
- [ ] Verify database queries return data (check logs)

---

## DATABASE QUERIES TO VERIFY

Run these queries in MySQL to check your data:

```sql
-- Check emotion entries
SELECT COUNT(*) as emotions_count, 
       AVG(intensity) as avg_intensity,
       GROUP_CONCAT(DISTINCT mood) as moods
FROM emotions 
WHERE user_id = 1 
AND created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY);

-- Check regrets
SELECT COUNT(*) as regret_count,
       GROUP_CONCAT(DISTINCT tag) as tags
FROM regrets
WHERE user_id = 1
AND created_date >= DATE_SUB(NOW(), INTERVAL 30 DAY);

-- Check habits
SELECT COUNT(*) as total_habits,
       SUM(CASE WHEN is_active = 1 THEN 1 ELSE 0 END) as active_habits,
       AVG(streak) as avg_streak
FROM habits
WHERE user_id = 1;

-- Check reflections
SELECT COUNT(*) as opened_capsules,
       SUM(CASE WHEN reflection IS NOT NULL THEN 1 ELSE 0 END) as with_reflections
FROM time_capsules
WHERE user_id = 1;
```

---

## SAMPLE DATA SETUP SCRIPT

Use this to quickly populate test data:

```sql
-- Add test emotions (Scenario 1: High Risk)
INSERT INTO emotions (user_id, mood, intensity, trigger, response, created_at)
VALUES 
(1, 'Stressed', 8, 'Deadline approaching', 'Tried to focus', NOW() - INTERVAL 5 DAY),
(1, 'Stressed', 9, 'Too much work', 'Felt overwhelmed', NOW() - INTERVAL 4 DAY),
(1, 'Anxious', 7, 'Project deadline', 'Started late', NOW() - INTERVAL 3 DAY),
(1, 'Stressed', 8, 'Time running out', 'Panicked', NOW() - INTERVAL 2 DAY),
(1, 'Frustrated', 6, 'Still behind', 'Gave up momentarily', NOW() - INTERVAL 1 DAY);

-- Add test regrets
INSERT INTO regrets (user_id, description, lesson_learned, tag, created_date)
VALUES
(1, 'Delayed starting the project', 'Should have started earlier', 'Procrastination', NOW() - INTERVAL 4 DAY),
(1, 'Procrastinated on important task', 'Causing stress', 'Procrastination', NOW() - INTERVAL 2 DAY),
(1, 'Didnt plan ahead properly', 'Need better planning', 'Planning', NOW() - INTERVAL 1 DAY);
```

---

## SUCCESS CRITERIA ✅

Your implementation is successful when:

1. **Reflections Feature**
   - [ ] Time capsule reflections save correctly
   - [ ] Reflections display in opened capsule cards
   - [ ] Mood comparison (then vs now) shows correctly

2. **Behavior Analyzer**
   - [ ] Shows dominant emotion correctly
   - [ ] Risk level changes based on data (Low/Med/High)
   - [ ] Behavior patterns are detected accurately
   - [ ] Suggestions are relevant and helpful

3. **Analytics Page**
   - [ ] Charts render correctly (pie + line)
   - [ ] Data updates when new entries are added
   - [ ] Summary insights are meaningful
   - [ ] All metrics are calculated accurately

4. **Dynamic Updates**
   - [ ] Adding new emotion updates analyzer
   - [ ] Adding regret affects pattern detection
   - [ ] Habit changes affect suggestions
   - [ ] No manual refresh needed (auto-update via AJAX optional)

---

## DEPLOYMENT CHECKLIST

Before going live:

- [ ] Recompile all Java files: `.\compile.bat`
- [ ] Restart Tomcat: `.\startup.bat` from tomcat\bin
- [ ] Test all three scenarios above
- [ ] Verify database tables exist with correct columns
- [ ] Check console logs for any errors
- [ ] Test in multiple browsers (Chrome, Firefox, Safari)
- [ ] Verify mobile responsiveness
- [ ] Backup database before deployment

---

## SUPPORT & NEXT STEPS

### If Issues Arise
1. Check Tomcat logs in `xampp/tomcat/logs/`
2. Check browser console (F12) for JavaScript errors
3. Verify database connectivity with DBConnection test
4. Review all compilation errors in console output

### Future Enhancements
- [ ] Add real-time AJAX updates without page refresh
- [ ] Export analytics as PDF reports
- [ ] Add predictive alerts for high-risk emotions
- [ ] Implement machine learning for pattern prediction
- [ ] Add recommendation engine for habits
- [ ] Create mobile app for on-the-go logging

---

**Last Updated**: May 4, 2026
**Status**: ✅ Ready for Testing
**Version**: 2.0 - Complete Behavior Analyzer Implementation

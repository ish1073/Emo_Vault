# Expert System Testing Checklist

## Pre-Test Setup
- [ ] Tomcat is running (status: RUNNING ✅)
- [ ] EmoVault is accessible at http://localhost:8080/EmoVault
- [ ] Test account ready: demo@emovault.com / test123
- [ ] Browser cache cleared (Ctrl+Shift+Delete)

---

## Test Scenario 1: Dashboard Expert Insights

### Steps:
1. Login to EmoVault with test account
2. Navigate to Dashboard (/EmoVault/dashboard)
3. Check if emotions exist in database

### Expected Results:
- [ ] Dashboard loads without errors
- [ ] Pattern insights are displayed
- [ ] Expert suggestions appear as insight cards
- [ ] Emojis are visible for each insight (💡, ⚠️, ✨, etc.)
- [ ] No console errors in browser

### Verification:
- [ ] At least one insight card showing expert suggestion
- [ ] Suggestion contains actionable advice
- [ ] Risk alerts displayed with ⚠️ emoji

---

## Test Scenario 2: Habit Page Expert Section

### Steps:
1. From Dashboard, click "Habits" in navbar
2. Navigate to /EmoVault/habit

### Expected Results:
- [ ] Habit page loads successfully
- [ ] Expert Suggestions section appears at top
- [ ] Expert suggestion text is visible
- [ ] Recommendations grid displays below suggestion

### Verification:
- [ ] Section shows "🤖 Expert Suggestions" header
- [ ] Contains actionable habit-building advice
- [ ] Recommendations show as cards in grid layout

### Test Cases:

#### Case A: No Habits Exist
- [ ] Expert suggestion should be: "💡 Try starting tasks 15 minutes earlier..."
- [ ] Recommendations grid shows 5 items

#### Case B: With Active Habits (< 3)
- [ ] Expert suggestion should be habit-building focused
- [ ] Suggestions encourage forming one more habit

#### Case C: With Active Habits (≥ 3)
- [ ] Expert suggestion should be: "💡 Try starting tasks 15 minutes earlier..."
- [ ] Suggests focus on procrastination management

---

## Test Scenario 3: Emotion Pattern Recognition

### Steps:
1. Go to Emotions page (/EmoVault/emotion.jsp)
2. Create 3+ emotion entries with:
   - Mood: "sad" or "angry"
   - Intensity: 8 or higher
   - Trigger: Any common trigger

3. Navigate back to Dashboard

### Expected Results:
- [ ] Pattern detected: "High stress detected X times"
- [ ] Expert generates corresponding risk alert
- [ ] Alert includes severity level
- [ ] Suggestion for managing stress appears

### Verification:
- [ ] Dashboard shows both pattern and expert alert
- [ ] Cards properly styled with emojis
- [ ] Alert provides actionable next steps

---

## Test Scenario 4: Quick Mood Advice

### Steps:
1. Create emotions with different moods:
   - Happy
   - Sad
   - Anxious
   - Tired

2. Navigate to Dashboard

### Expected Results:
- [ ] Each mood shows specific quick advice
- [ ] Happy: References capturing feeling
- [ ] Sad: References allowing emotions
- [ ] Anxious: References addressing uncertainty
- [ ] Tired: References rest importance

### Verification:
- [ ] Mood-specific advice matches mood type
- [ ] Appropriate emojis used (✨, 💙, 🌬️, 😴, etc.)
- [ ] All advice is constructive and helpful

---

## Test Scenario 5: Risk Alert Generation

### Steps:
1. Create regret entries with same tag (e.g., "procrastination") 3+ times
2. Create high-intensity emotions 5+ times
3. Navigate to Dashboard

### Expected Results:
- [ ] Risk alerts generated for repeated patterns
- [ ] Severity levels indicated
- [ ] Actionable recommendations included
- [ ] User prompted to take action

### Verification:
- [ ] Dashboard shows at least one risk alert
- [ ] Alert includes pattern identification
- [ ] Suggestion is specific to pattern type

---

## Test Scenario 6: Expert Recommendations Functionality

### Steps:
1. Navigate to Habits page
2. Scroll to "Recommended Actions" section
3. Verify each recommendation

### Expected Results:
- [ ] Recommendations display in grid format
- [ ] Each recommendation is unique
- [ ] All recommendations are relevant to habits
- [ ] Text is readable with proper styling

### Verification:
- [ ] 5 recommendations visible
- [ ] Examples:
  - "✅ Log your emotions daily..."
  - "✅ Identify and track your triggers..."
  - "✅ Build one habit at a time..."
  - "✅ Review weekly patterns..."
  - "✅ Act on expert suggestions..."

---

## Test Scenario 7: Performance & Stability

### Steps:
1. Refresh Dashboard multiple times
2. Navigate between pages
3. Create new emotion and check updates
4. Check browser console for errors

### Expected Results:
- [ ] All pages load within 2 seconds
- [ ] No JavaScript errors in console
- [ ] Expert suggestions appear consistently
- [ ] No layout shifts or rendering issues
- [ ] Mobile view responsive (if testing)

### Verification:
- [ ] F12 Console shows no errors
- [ ] Network tab shows successful requests
- [ ] All CSS loaded correctly
- [ ] Responsive on different screen sizes

---

## Test Scenario 8: Edge Cases

### Test Case: Empty Database
- [ ] Dashboard shows: "Start logging emotions to see patterns emerge!"
- [ ] No crash when accessing expert features

### Test Case: Single Emotion Entry
- [ ] Dashboard displays with limited insights
- [ ] No null pointer exceptions
- [ ] Expert section still visible

### Test Case: Rapid Page Navigation
- [ ] Click through Dashboard → Habit → Dashboard
- [ ] Check that expert suggestions are still visible
- [ ] No lingering data from previous pages

---

## Browser Compatibility Testing

- [ ] Chrome/Edge (Chromium): ✅ (Primary)
- [ ] Firefox: ⚠ (Optional)
- [ ] Safari: ⚠ (Optional)
- [ ] Mobile Safari: ⚠ (Optional)

---

## Performance Metrics

| Metric | Target | Status |
|--------|--------|--------|
| Dashboard Load Time | < 2s | ⏳ |
| Expert Suggestion Generation | < 100ms | ⏳ |
| Emoji Rendering | All visible | ⏳ |
| CSS Styling | All applied | ⏳ |
| No JavaScript Errors | 0 errors | ⏳ |

---

## Regression Testing

### Existing Features (Ensure Not Broken):
- [ ] Login still works
- [ ] Emotion logging functional
- [ ] Diary entries work
- [ ] Regret tracking works
- [ ] Alert system works
- [ ] Dashboard patterns display
- [ ] Navigation bar functional
- [ ] Logout works
- [ ] Session timeout works

---

## Sign-Off Checklist

- [ ] All test scenarios passed
- [ ] No critical bugs found
- [ ] Performance acceptable
- [ ] Expert suggestions relevant and helpful
- [ ] UI/UX intuitive
- [ ] Mobile responsive (if tested)
- [ ] Documentation complete
- [ ] Ready for production

---

## Test Results Summary

**Date:** _______________
**Tester:** _______________
**Build Version:** Expert System v1.0
**Status:** ⏳ Pending / ✅ Passed / ❌ Failed

### Issues Found:
(List any issues discovered during testing)

### Sign-Off:
- [ ] Approved for Production
- [ ] Approve with Minor Issues
- [ ] Reject - Requires Fixes

---

## Notes for Next Session

1. If Expert suggestions not showing:
   - Check that Expert.class is in Tomcat
   - Verify PatternDetector is calling generateExpertInsights()
   - Check HabitServlet is setting request attributes

2. For UI improvements:
   - Consider adding Expert preference settings
   - Could add "Dismiss" button for suggestions
   - Could add feedback on suggestion usefulness

3. For future phases:
   - Consider caching expert suggestions
   - Could add rule editor UI
   - Could track which suggestions users find helpful

---

**This checklist ensures Expert System is working correctly across all components.**

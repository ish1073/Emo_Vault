package com.emovault.util;

import java.util.*;

/**
 * Expert Class - Rule-based Expert System
 * Generates insights, suggestions, and risk alerts based on detected patterns
 * This is a system-level component (NOT a user)
 */
public class Expert {
    private List<String> suggestions;
    private List<String> riskRules;
    private List<String> insights;

    public Expert() {
        this.suggestions = new ArrayList<>();
        this.riskRules = new ArrayList<>();
        this.insights = new ArrayList<>();
    }

    /**
     * Generate suggestion based on detected issue
     * @param issue The detected issue (e.g., "procrastination", "overthinking")
     * @return Suggestion string
     */
    public String generateSuggestion(String issue) {
        if (issue == null || issue.trim().isEmpty()) {
            return null;
        }

        String issue_lower = issue.toLowerCase();

        // Procrastination issues
        if (issue_lower.contains("procrastin")) {
            return "💡 Try starting tasks 15 minutes earlier than usual. Break them into smaller steps.";
        }

        // Overthinking issues
        if (issue_lower.contains("overthin") || issue_lower.contains("rumination")) {
            return "💡 Practice the 5-minute rule: If you can't solve it in 5 minutes, take a break and return later.";
        }

        // High stress issues
        if (issue_lower.contains("stress") || issue_lower.contains("anxiety")) {
            return "💡 Take a 10-minute break. Practice deep breathing or go for a short walk.";
        }

        // Perfectionism
        if (issue_lower.contains("perfect")) {
            return "💡 Aim for 'good enough'. Done is better than perfect. Progress over perfection.";
        }

        // Avoidance
        if (issue_lower.contains("avoid")) {
            return "💡 Face one small uncomfortable task today. Start with just 10 minutes.";
        }

        // Low motivation
        if (issue_lower.contains("motiv") || issue_lower.contains("low energy")) {
            return "💡 Connect each task to your 'why'. Remember why it matters to you.";
        }

        // Social anxiety
        if (issue_lower.contains("social") || issue_lower.contains("interaction")) {
            return "💡 Start small: Engage in one brief positive interaction today.";
        }

        // Sleep/tiredness
        if (issue_lower.contains("sleep") || issue_lower.contains("tired")) {
            return "💡 Establish a consistent sleep schedule. Aim for 7-9 hours daily.";
        }

        // Default suggestion
        return "💡 Take a moment to reflect. What small change could help right now?";
    }

    /**
     * Define or analyze risk based on detected pattern
     * @param pattern The detected pattern
     * @return Risk alert message
     */
    public String defineRiskRule(String pattern) {
        if (pattern == null || pattern.trim().isEmpty()) {
            return null;
        }

        String pattern_lower = pattern.toLowerCase();

        // Burnout risk
        if (pattern_lower.contains("stress") && pattern_lower.contains("repeated")) {
            return "⚠️ RISK ALERT: Repeated high stress detected. Risk of burnout increasing. Consider taking scheduled breaks.";
        }

        // Negative mood spiral
        if (pattern_lower.contains("sad") || pattern_lower.contains("angry")) {
            return "⚠️ RISK ALERT: Negative mood cycle detected. Practice gratitude or reach out to someone.";
        }

        // Isolation risk
        if (pattern_lower.contains("alone") || pattern_lower.contains("isolated")) {
            return "⚠️ RISK ALERT: Prolonged isolation detected. Reach out to friends or family today.";
        }

        // Decision paralysis
        if (pattern_lower.contains("overthink") && pattern_lower.contains("procrastin")) {
            return "⚠️ RISK ALERT: Analysis paralysis detected. Make a decision with 70% information. Perfect decisions don't exist.";
        }

        // Unhealthy coping
        if (pattern_lower.contains("avoidance")) {
            return "⚠️ RISK ALERT: Prolonged avoidance detected. Avoiding problems makes them grow. Face one today.";
        }

        // Habit breaking
        if (pattern_lower.contains("habit") && pattern_lower.contains("broken")) {
            return "⚠️ RISK ALERT: Habit streak broken. It's okay. What matters is restarting today.";
        }

        // Sleep deprivation
        if (pattern_lower.contains("low sleep") || pattern_lower.contains("insomnia")) {
            return "⚠️ RISK ALERT: Sleep deprivation detected. Poor sleep affects all emotions. Prioritize rest tonight.";
        }

        return null;
    }

    /**
     * Generate comprehensive insight from emotional and behavioral data
     * @param triggerData Trigger information
     * @param moodData Mood information
     * @param behaviorData Behavior patterns
     * @return Expert insight string
     */
    public String generateInsight(String triggerData, String moodData, String behaviorData) {
        StringBuilder insight = new StringBuilder();

        if (triggerData != null && !triggerData.isEmpty()) {
            insight.append("📌 Key Trigger: ").append(triggerData).append("\n");
        }

        if (moodData != null && !moodData.isEmpty()) {
            insight.append("😊 Mood Pattern: ").append(moodData).append("\n");
        }

        if (behaviorData != null && !behaviorData.isEmpty()) {
            insight.append("🎯 Behavior: ").append(behaviorData).append("\n");
        }

        if (insight.length() == 0) {
            insight.append("📊 Continue logging to see personalized insights.");
        }

        return insight.toString();
    }

    /**
     * Generate quick advice for a specific emotion/mood
     * @param mood The user's current mood
     * @return Quick advice string
     */
    public String getQuickAdvice(String mood) {
        if (mood == null || mood.trim().isEmpty()) {
            return null;
        }

        String mood_lower = mood.toLowerCase();

        if (mood_lower.contains("happy") || mood_lower.contains("excited")) {
            return "✨ Awesome mood! Capture this feeling. What made today great?";
        }

        if (mood_lower.contains("sad")) {
            return "💙 It's okay to feel sad. Allow yourself 15 minutes to feel, then engage in something positive.";
        }

        if (mood_lower.contains("angry") || mood_lower.contains("frustrated")) {
            return "🔥 Channel that energy! Do something physical - exercise, work on a project, or clean.";
        }

        if (mood_lower.contains("anxious") || mood_lower.contains("worried")) {
            return "🌬️ Anxiety thrives on uncertainty. Write down your concerns and tackle one today.";
        }

        if (mood_lower.contains("tired") || mood_lower.contains("exhausted")) {
            return "😴 Rest is productive. Take a nap, meditate, or slow down your day.";
        }

        if (mood_lower.contains("calm") || mood_lower.contains("peaceful")) {
            return "🧘 Hold onto this peace. This is your baseline. Return here when stressed.";
        }

        if (mood_lower.contains("neutral") || mood_lower.contains("okay")) {
            return "➡️ Steady state. A good time to build habits or plan ahead.";
        }

        return "🎯 How can you improve your mood by 1% right now?";
    }

    /**
     * Score the severity of a pattern (1-5 scale)
     * @param pattern The pattern to evaluate
     * @return Severity score (1=low, 5=critical)
     */
    public int assessSeverity(String pattern) {
        if (pattern == null || pattern.trim().isEmpty()) {
            return 1;
        }

        String pattern_lower = pattern.toLowerCase();

        if (pattern_lower.contains("burnout") || pattern_lower.contains("crisis")) {
            return 5;
        }

        if (pattern_lower.contains("repeated") && (pattern_lower.contains("stress") || pattern_lower.contains("negative"))) {
            return 4;
        }

        if (pattern_lower.contains("overthink") || pattern_lower.contains("procrastin")) {
            return 3;
        }

        if (pattern_lower.contains("trigger")) {
            return 2;
        }

        return 1;
    }

    /**
     * Get expert recommendations as a list
     * @return List of recommendations
     */
    public List<String> getRecommendations() {
        List<String> recommendations = new ArrayList<>();
        recommendations.add("✅ Log your emotions daily for patterns to emerge");
        recommendations.add("✅ Identify and track your triggers");
        recommendations.add("✅ Build one habit at a time");
        recommendations.add("✅ Review weekly patterns on your dashboard");
        recommendations.add("✅ Act on expert suggestions when relevant");
        return recommendations;
    }

    // Getters
    public List<String> getSuggestions() {
        return suggestions;
    }

    public void addSuggestion(String suggestion) {
        this.suggestions.add(suggestion);
    }

    public List<String> getRiskRules() {
        return riskRules;
    }

    public void addRiskRule(String rule) {
        this.riskRules.add(rule);
    }

    public List<String> getInsights() {
        return insights;
    }

    public void addInsight(String insight) {
        this.insights.add(insight);
    }

    public void clearAll() {
        this.suggestions.clear();
        this.riskRules.clear();
        this.insights.clear();
    }
}

package com.emovault.servlet;

import com.emovault.dao.*;
import com.emovault.model.*;
import com.emovault.util.DBConnection;
import com.emovault.util.RiskAnalyzer;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

/**
 * AnalyticsServlet - Handles analytics page requests with real data
 * Provides habit streak, consistency, and other analytics data from actual database
 */
public class AnalyticsServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Prevent browser caching
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        
        // Check session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            // Redirect to login if not authenticated
            response.sendRedirect("login.jsp");
            return;
        }
        
        Integer userId = (Integer) session.getAttribute("userId");
        
        Connection connection = null;
        try {
            connection = DBConnection.getConnection();
        } catch (Exception e) {
            request.setAttribute("error", "Database connection failed");
            request.getRequestDispatcher("analytics.jsp").forward(request, response);
            return;
        }
        
        if (connection == null) {
            request.setAttribute("error", "Database connection failed");
            request.getRequestDispatcher("analytics.jsp").forward(request, response);
            return;
        }
        
        try {
            HabitDAO habitDAO = new HabitDAO(connection);
            AnalyticsDAO analyticsDAO = new AnalyticsDAO();
            RiskAnalyzer analyzer = new RiskAnalyzer(connection);
            
            // ========== REAL HABIT DATA ==========
            // Get all habits for user with stats
            List<Habit> habits = habitDAO.getHabitsWithStats(userId);
            
            // Calculate habit statistics from real data
            int totalHabits = habits.size();
            int maxStreak = 0;
            int longestStreak = 0;
            double avgConsistency = 0.0;
            int totalCompletions = 0;
            int habitsCompletedToday = 0;
            
            for (Habit habit : habits) {
                int streak = habit.getCurrentStreak();
                if (streak > maxStreak) {
                    maxStreak = streak;
                }
                
                // Calculate longest streak ever for this habit
                int longestForHabit = habitDAO.calculateLongestStreak(habit.getHabitId());
                if (longestForHabit > longestStreak) {
                    longestStreak = longestForHabit;
                }
                
                avgConsistency += habit.getConsistencyScore();
                totalCompletions += habitDAO.getTotalCompletions(habit.getHabitId());
            }
            
            if (totalHabits > 0) {
                avgConsistency = avgConsistency / totalHabits;
            }
            
            // Get today's habit completion count
            habitsCompletedToday = habitDAO.getHabitsCompletedCount(userId, LocalDate.now());
            
            // Get missed days count
            int missedDays = habitDAO.getMissedDaysCount(userId);
            
            // Get regrets count for repeated mistakes
            int repeatedMistakes = analyzer.getRegretsCount(userId);
            
            // ========== ANALYTICS DATA FROM DATABASE ==========
            // Get emotional distribution from real data
            Map<String, Integer> emotionalDistribution = analyticsDAO.getMoodDistribution(userId);
            if (emotionalDistribution.isEmpty()) {
                emotionalDistribution.put("Happy", 0);
                emotionalDistribution.put("Calm", 0);
                emotionalDistribution.put("Sad", 0);
                emotionalDistribution.put("Anxious", 0);
            }
            
            // Get mood trend from real data (last 30 days)
            List<Map<String, Object>> moodTrend = analyticsDAO.getMoodTrend(userId);
            if (moodTrend.isEmpty()) {
                // Provide empty list - JSP will handle no data case
                moodTrend = new ArrayList<>();
            }
            
            // Get risk summary from real data
            Map<String, Integer> riskSummary = new HashMap<>();
            riskSummary.put("Low Risk", 0);
            riskSummary.put("Medium Risk", 0);
            riskSummary.put("High Risk", 0);
            
            // Calculate risk distribution from recent emotions
            String query = "SELECT COUNT(*) as count FROM emotion_entries WHERE user_id = ? " +
                          "AND created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY) " +
                          "AND intensity <= 3 GROUP BY intensity";
            // This would need a proper implementation, using placeholder for now
            
            // ========== HABIT ANALYTICS DATA ==========
            // Get weekly completion trend (last 8 weeks)
            List<Map<String, Object>> weeklyTrend = habitDAO.getWeeklyCompletionTrend(userId, 8);
            
            // Get monthly consistency trend (last 6 months)
            List<Map<String, Object>> monthlyTrend = habitDAO.getMonthlyConsistencyTrend(userId, 6);
            
            // Get best performing habits
            List<Map<String, Object>> bestHabits = habitDAO.getBestPerformingHabits(userId, 5);
            
            // Get streak growth data
            List<Map<String, Object>> streakGrowth = habitDAO.getStreakGrowthOverTime(userId, 3);
            
            // Get completion heatmap for current month
            Map<String, Integer> heatmapData = habitDAO.getCompletionHeatmap(userId);
            
            // ========== STATISTICS ==========
            Map<String, Integer> statistics = new HashMap<>();
            statistics.put("totalEmotions", analyticsDAO.getTotalEmotionEntries(userId));
            statistics.put("totalDecisions", 0); // Would need decision tracking
            statistics.put("totalHabits", totalHabits);
            statistics.put("totalRegrets", repeatedMistakes);
            statistics.put("totalCompletions", totalCompletions);
            statistics.put("missedDays", missedDays);
            
            // ========== GENERATE INSIGHTS ==========
            String insightSummary = generateInsightSummary(maxStreak, avgConsistency, 
                                                          habitsCompletedToday, totalHabits, missedDays);
            
            // ========== SET ALL REQUEST ATTRIBUTES ==========
            // Core habit stats
            request.setAttribute("habitStreak", maxStreak);
            request.setAttribute("habitConsistency", avgConsistency);
            request.setAttribute("longestStreak", longestStreak);
            request.setAttribute("repeatedMistakes", repeatedMistakes);
            request.setAttribute("insightSummary", insightSummary);
            request.setAttribute("missedDays", missedDays);
            
            // Statistics map
            request.setAttribute("statistics", statistics);
            
            // Charts data
            request.setAttribute("emotionalDistribution", emotionalDistribution);
            request.setAttribute("moodTrend", moodTrend);
            request.setAttribute("riskSummary", riskSummary);
            
            // Habit analytics data
            request.setAttribute("weeklyTrend", weeklyTrend);
            request.setAttribute("monthlyTrend", monthlyTrend);
            request.setAttribute("bestHabits", bestHabits);
            request.setAttribute("streakGrowth", streakGrowth);
            request.setAttribute("heatmapData", heatmapData);
            
            // Habit details for insight boxes
            request.setAttribute("habitsCompletedToday", habitsCompletedToday);
            request.setAttribute("totalCompletions", totalCompletions);
            
            // Forward to analytics.jsp
            request.getRequestDispatcher("analytics.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error in AnalyticsServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error loading analytics data");
            request.getRequestDispatcher("analytics.jsp").forward(request, response);
        } finally {
            try {
                connection.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    
    /**
     * Generate insight summary based on user data
     */
    private String generateInsightSummary(int maxStreak, double avgConsistency, 
                                         int habitsCompletedToday, int totalHabits, int missedDays) {
        StringBuilder summary = new StringBuilder();
        
        // Streak insights
        if (maxStreak >= 21) {
            summary.append("Excellent work! You've built a strong habit streak of ").append(maxStreak).append(" days. ");
        } else if (maxStreak >= 7) {
            summary.append("Great progress! Your ").append(maxStreak).append("-day streak shows growing consistency. ");
        } else if (maxStreak > 0) {
            summary.append("You're building momentum with a ").append(maxStreak).append("-day streak. Keep going! ");
        } else {
            summary.append("Start tracking your habits to build consistency. ");
        }
        
        // Consistency insights
        if (avgConsistency >= 80) {
            summary.append("Your consistency rate of ").append(String.format("%.0f", avgConsistency)).append("% is outstanding! ");
        } else if (avgConsistency >= 50) {
            summary.append("Your ").append(String.format("%.0f", avgConsistency)).append("% consistency shows good progress. ");
        } else if (totalHabits > 0) {
            summary.append("Focus on building consistency. Current rate: ").append(String.format("%.0f", avgConsistency)).append("%. ");
        }
        
        // Today's progress
        if (totalHabits > 0 && habitsCompletedToday == totalHabits) {
            summary.append("All ").append(totalHabits).append(" habits completed today - excellent discipline!");
        } else if (totalHabits > 0 && habitsCompletedToday > 0) {
            summary.append(habitsCompletedToday).append(" of ").append(totalHabits).append(" habits completed today. ");
        }
        
        // Missed days insight
        if (missedDays > 3) {
            summary.append("You've missed ").append(missedDays).append(" days this month. Try to stay consistent!");
        }
        
        return summary.toString();
    }
}

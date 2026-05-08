package com.emovault.servlet;

import com.emovault.dao.AnalyticsDAO;
import com.emovault.dao.BehaviorAnalysisDAO;
import com.emovault.model.BehaviorAnalysis;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

public class AnalyticsServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Prevent browser caching
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        
        // Check session
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        // For demo/testing, use userId 1 if not logged in
        if (userId == null) {
            userId = 1; // Default test user
        }
        
        try {
            AnalyticsDAO analyticsDAO = new AnalyticsDAO();
            
            // Get all analytics data
            Map<String, Integer> moodDistribution = analyticsDAO.getMoodDistribution(userId);
            List<Map<String, Object>> moodTrend = analyticsDAO.getMoodTrend(userId);
            String dominantMood = analyticsDAO.getDominantMood(userId);
            double avgIntensity = analyticsDAO.getAverageIntensity(userId);
            String riskLevel = analyticsDAO.getRiskLevel(userId);
            Map<String, Object> repeatedRegret = analyticsDAO.getMostRepeatedRegret(userId);
            List<Map<String, Object>> habitProgress = analyticsDAO.getHabitProgress(userId);
            int totalEntries = analyticsDAO.getTotalEmotionEntries(userId);
            String commonTag = analyticsDAO.getMostCommonTag(userId);
            
            // Get behavior analyzer insights
            BehaviorAnalysisDAO behaviorDAO = new BehaviorAnalysisDAO();
            BehaviorAnalysis behaviorAnalysis = behaviorDAO.analyzeBehavior(userId);
            
            // Convert data to JSON strings for JavaScript
            StringBuilder moodLabels = new StringBuilder();
            StringBuilder moodCounts = new StringBuilder();
            List<String> moods = new ArrayList<>(moodDistribution.keySet());
            for (int i = 0; i < moods.size(); i++) {
                moodLabels.append("\"").append(moods.get(i)).append("\"");
                moodCounts.append(moodDistribution.get(moods.get(i)));
                if (i < moods.size() - 1) {
                    moodLabels.append(",");
                    moodCounts.append(",");
                }
            }
            
            StringBuilder trendDates = new StringBuilder();
            StringBuilder trendIntensities = new StringBuilder();
            for (int i = 0; i < moodTrend.size(); i++) {
                Map<String, Object> entry = moodTrend.get(i);
                trendDates.append("\"").append(entry.get("date")).append("\"");
                trendIntensities.append(entry.get("intensity"));
                if (i < moodTrend.size() - 1) {
                    trendDates.append(",");
                    trendIntensities.append(",");
                }
            }
            
            // Set request attributes
            request.setAttribute("moodDistribution", moodDistribution);
            request.setAttribute("moodTrend", moodTrend);
            request.setAttribute("dominantMood", dominantMood);
            request.setAttribute("avgIntensity", avgIntensity);
            request.setAttribute("riskLevel", riskLevel);
            request.setAttribute("repeatedRegret", repeatedRegret);
            request.setAttribute("habitProgress", habitProgress);
            request.setAttribute("totalEntries", totalEntries);
            request.setAttribute("commonTag", commonTag);
            request.setAttribute("behaviorAnalysis", behaviorAnalysis);
            
            response.setContentType("text/html; charset=UTF-8");
            PrintWriter out = response.getWriter();
            
            // Safely get values, use defaults if null
            String mood = dominantMood != null ? dominantMood : "Mixed";
            String risk = riskLevel != null ? riskLevel : "Unknown";
            String regretTheme = "Unknown";
            int regretCount = 0;
            if (repeatedRegret != null && !repeatedRegret.isEmpty()) {
                regretTheme = (String) repeatedRegret.getOrDefault("lesson_learned", "Unknown");
                regretCount = ((Number) repeatedRegret.getOrDefault("count", 0)).intValue();
            }
            String topTag = commonTag != null ? commonTag : "General";
            String habitStreak = "0";
            String habitName = "None";
            int habitConsistency = 0;
            if (habitProgress != null && !habitProgress.isEmpty()) {
                Map<String, Object> topHabit = habitProgress.get(0);
                habitStreak = topHabit.get("streak").toString();
                habitName = (String) topHabit.get("title");
                habitConsistency = ((Number) topHabit.get("consistency")).intValue();
            }
            
            // HTML response with original color theme + sidebar matching dashboard
            out.println("<!DOCTYPE html>");
            out.println("<html lang='en'><head>");
            out.println("<meta charset='UTF-8'>");
            out.println("<meta name='viewport' content='width=device-width, initial-scale=1.0'>");
            out.println("<title>Analytics & Reports - EmoVault</title>");
            out.println("<style>");
            out.println(":root {");
            out.println("  --color-english-violet: #5D4E63;");
            out.println("  --color-pale-dogwood: #E8D4F1;");
            out.println("  --color-puce: #BF7185;");
            out.println("  --space-md: 12px;");
            out.println("  --space-lg: 16px;");
            out.println("  --space-sm: 8px;");
            out.println("  --space-xs: 4px;");
            out.println("  --space-2xl: 32px;");
            out.println("  --radius-md: 6px;");
            out.println("  --transition-fast: 0.3s;");
            out.println("}");
            out.println("* { margin: 0; padding: 0; box-sizing: border-box; }");
            out.println("body { font-family: 'Inter', 'Segoe UI', sans-serif; background: #FBF8F3; }");
            out.println(".dashboard-layout { display: grid; grid-template-columns: 260px 1fr; min-height: 100vh; gap: 0; }");
            out.println(".dashboard-sidebar { background: var(--color-english-violet); padding: var(--space-lg); overflow-y: auto; box-shadow: 0 4px 12px rgba(0,0,0,0.15); position: relative; }");
            out.println(".sidebar-logo { color: var(--color-pale-dogwood); font-size: 1.5rem; font-weight: 700; margin-bottom: var(--space-2xl); display: flex; align-items: center; gap: var(--space-md); }");
            out.println(".sidebar-close { position: absolute; top: 16px; right: 16px; background: none; border: none; color: var(--color-pale-dogwood); font-size: 1.5rem; cursor: pointer; padding: 4px; border-radius: 4px; transition: all 0.3s; }");
            out.println(".sidebar-close:hover { background: rgba(191, 113, 133, 0.2); }");
            out.println(".sidebar-nav { list-style: none; margin-top: 20px; }");
            out.println(".nav-item { margin-bottom: var(--space-sm); }");
            out.println(".nav-link { display: flex; align-items: center; gap: var(--space-md); padding: var(--space-md) var(--space-lg); color: var(--color-pale-dogwood); text-decoration: none; border-radius: var(--radius-md); transition: all var(--transition-fast); font-weight: 600; }");
            out.println(".nav-link:hover { background: rgba(191, 113, 133, 0.2); color: var(--color-pale-dogwood); }");
            out.println(".nav-link.active { background: var(--color-puce); color: #FFF; }");
            out.println(".sidebar-separator { border: none; border-top: 1px solid rgba(191, 113, 133, 0.3); margin: var(--space-2xl) 0; }");
            out.println(".user-profile { display: flex; align-items: center; gap: var(--space-md); margin-top: var(--space-xl); }");
            out.println(".user-avatar { width: 44px; height: 44px; border-radius: 50%; background: linear-gradient(135deg, #BF7185, #8B5A6B); display: flex; align-items: center; justify-content: center; color: #FFF; font-weight: 700; font-size: 1.2rem; flex-shrink: 0; }");
            out.println(".user-info { flex: 1; }");
            out.println(".user-name { color: var(--color-pale-dogwood); font-weight: 600; }");
            out.println(".user-settings { color: #B8B0C3; font-size: 0.8rem; }");
            out.println(".dashboard-main { background: linear-gradient(135deg, #E6D4BF 0%, #FBF8F3 100%); padding: var(--space-lg); padding: 40px 20px; overflow-y: auto; }");
            out.println(".container { max-width: 1400px; margin: 0 auto; }");
            out.println(".page-header { background: white; border-radius: 12px; padding: 30px; margin-bottom: 40px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }");
            out.println(".page-header h1 { color: #877499; font-size: 2.2em; margin: 0; }");
            out.println(".overview-cards { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; margin-bottom: 40px; }");
            out.println(".card { background: white; border-radius: 12px; padding: 24px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); border-left: 4px solid #679F9F; }");
            out.println(".card-label { color: #999; font-size: 0.85em; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 8px; }");
            out.println(".card-value { color: #679F9F; font-size: 2.2em; font-weight: 700; margin-bottom: 8px; }");
            out.println(".card-detail { color: #999; font-size: 0.9em; }");
            out.println(".insights { background: white; border-radius: 12px; padding: 30px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }");
            out.println(".insights h2 { color: #877499; margin-bottom: 20px; }");
            out.println(".insights-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 20px; }");
            out.println(".insight-box { background: #F5F0E8; padding: 20px; border-radius: 8px; border-left: 4px solid #679F9F; }");
            out.println(".insight-box h3 { color: #877499; margin-bottom: 10px; }");
            out.println(".insight-box p { color: #555; line-height: 1.6; }");
            out.println(".insight-box ul { margin-left: 20px; color: #555; }");
            out.println("@media (max-width: 768px) { .dashboard-layout { grid-template-columns: 1fr; } .dashboard-sidebar { order: 2; } .dashboard-main { order: 1; } }");
            out.println("</style></head><body>");
            out.println("<div class='dashboard-layout'>");
            out.println("<div class='dashboard-sidebar'>");
            out.println("<button class='sidebar-close' onclick='console.log(\"Close sidebar\")'>✕</button>");
            out.println("<div class='sidebar-logo'>💜 EmoVault</div>");
            out.println("<ul class='sidebar-nav'>");
            out.println("<li class='nav-item'><a href='dashboard_complete.jsp' class='nav-link'><span>🏠</span><span>Dashboard</span></a></li>");
            out.println("<li class='nav-item'><a href='emotion_new.jsp' class='nav-link'><span>😊</span><span>Emotions</span></a></li>");
            out.println("<li class='nav-item'><a href='diary_complete.jsp' class='nav-link'><span>📔</span><span>Diary</span></a></li>");
            out.println("<li class='nav-item'><a href='behavior_complete.jsp' class='nav-link'><span>🧠</span><span>Behavior</span></a></li>");
            out.println("<li class='nav-item'><a href='regret_complete.jsp' class='nav-link'><span>😞</span><span>Regrets</span></a></li>");
            out.println("<li class='nav-item'><a href='habit_complete.jsp' class='nav-link'><span>🔁</span><span>Habits</span></a></li>");
            out.println("<li class='nav-item'><a href='decision_complete.jsp' class='nav-link'><span>🎯</span><span>Decisions</span></a></li>");
            out.println("<li class='nav-item'><a href='timecapsule_complete.jsp' class='nav-link'><span>⏳</span><span>Time Capsule</span></a></li>");
            out.println("<li class='nav-item'><a href='analytics' class='nav-link active'><span>📊</span><span>Analytics</span></a></li>");
            out.println("</ul>");
            out.println("<hr class='sidebar-separator'>");
            out.println("<div class='user-profile'>");
            out.println("<div class='user-avatar'>👤</div>");
            out.println("<div class='user-info'>");
            out.println("<div class='user-name'>Sarah</div>");
            out.println("<div class='user-settings'>Settings</div>");
            out.println("</div>");
            out.println("</div>");
            out.println("</div>");
            out.println("<div class='dashboard-main'>");
            out.println("<div class='container'>");
            out.println("<div class='page-header'><h1>📊 Analytics & Reports</h1></div>");
            out.println("<div class='overview-cards'>");
            out.println("<div class='card'><div class='card-label'>Emotions Logged</div><div class='card-value'>" + totalEntries + "</div><div class='card-detail'>total entries</div></div>");
            out.println("<div class='card'><div class='card-label'>Dominant Mood</div><div class='card-value'>" + mood + "</div><div class='card-detail'>most frequent</div></div>");
            out.println("<div class='card'><div class='card-label'>Risk Level</div><div class='card-value'>" + risk + "</div><div class='card-detail'>assessment</div></div>");
            out.println("<div class='card'><div class='card-label'>Habit Streak</div><div class='card-value'>" + habitStreak + "</div><div class='card-detail'>days consistent</div></div>");
            out.println("</div>");
            out.println("<div class='insights'><h2>💡 Key Insights</h2>");
            out.println("<div class='insights-grid'>");
            out.println("<div class='insight-box'><h3>😊 Emotional Pattern</h3><p>Your most frequent emotion was <strong>" + mood + "</strong>. Continue activities that bring you these positive feelings!</p></div>");
            out.println("<div class='insight-box'><h3>🔄 Regrets & Lessons</h3><p>You've logged <strong>" + regretCount + " regrets</strong>. Most common theme: <strong>" + regretTheme + "</strong>.</p></div>");
            out.println("<div class='insight-box'><h3>✅ Habit Progress</h3><p>Your habit streak: <strong>" + habitStreak + " days</strong>! <strong>" + habitName + "</strong> - <strong>" + habitConsistency + "%</strong>.</p></div>");
            out.println("<div class='insight-box'><h3>📈 Mood Trends</h3><p>Average intensity: <strong>" + String.format("%.1f", avgIntensity) + "/10</strong>. " + (avgIntensity > 7 ? "Monitor well-being." : "Managing emotions well!") + "</p></div>");
            out.println("<div class='insight-box'><h3>🎯 Recommendations</h3><ul><li>Continue <strong>" + habitName + "</strong></li><li>Reflect on <strong>" + regretTheme + "</strong></li><li>Track <strong>" + topTag + "</strong> emotions</li></ul></div>");
            out.println("<div class='insight-box'><h3>📊 Next Steps</h3><ul><li>Maintain habit consistency</li><li>Log emotions daily</li><li>Review weekly</li></ul></div>");
            out.println("</div></div>");
            out.println("</div></div>");
            out.println("</div>");
            out.println("</body></html>");
            
            
        } catch (Exception e) {
            System.err.println("Error in AnalyticsServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error generating analytics");
        }
    }
}


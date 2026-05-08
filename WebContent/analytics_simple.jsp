<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Analytics & Reports - EmoVault</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/design-system.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #E6D4BF 0%, #FBF8F3 100%);
            min-height: 100vh;
            display: flex;
        }
        .sidebar-wrapper { width: 280px; }
        .main-content {
            flex: 1;
            padding: 40px 30px;
            overflow-y: auto;
        }
        .container { max-width: 1200px; margin: 0 auto; width: 100%; }
        .header { background: white; padding: 30px; border-radius: 12px; margin-bottom: 30px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .header h1 { color: #877499; font-size: 2em; margin-bottom: 10px; }
        .cards { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 30px; margin-bottom: 30px; }
        .card { background: white; padding: 24px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); border-left: 4px solid #679F9F; min-height: 140px; }
        .card-label { color: #999; font-size: 0.85em; text-transform: uppercase; margin-bottom: 10px; }
        .card-value { color: #679F9F; font-size: 2.2em; font-weight: bold; }
        .card-detail { color: #999; font-size: 0.9em; margin-top: 5px; }
        .insight-box { background: white; padding: 24px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); margin-bottom: 20px; }
        .insight-box h3 { color: #877499; margin-bottom: 15px; }
        .insight-box p { color: #2D4729; line-height: 1.6; }
        .empty-state { background: white; padding: 40px; border-radius: 12px; text-align: center; color: #999; }
    </style>
</head>
<body>
    <div class="sidebar-wrapper"><%@ include file="components/sidebar.jsp" %></div>
    <div class="main-content">
    <%
        Integer userId = (Integer) session.getAttribute("userId");
        String userName = (String) session.getAttribute("userName");
        
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        Map<String, Object> analytics = (Map<String, Object>) request.getAttribute("analytics");
        if (analytics == null) {
            analytics = new HashMap();
        }
        
        Map<String, Integer> statistics = (Map<String, Integer>) analytics.get("statistics");
        if (statistics == null) statistics = new HashMap();
        
        String insightSummary = (String) analytics.get("insightSummary");
        if (insightSummary == null) insightSummary = "No data available yet";
        
        Integer habitStreak = (Integer) analytics.get("habitStreak");
        if (habitStreak == null) habitStreak = 0;
        
        Double habitConsistency = (Double) analytics.get("habitConsistency");
        if (habitConsistency == null) habitConsistency = 0.0;
    %>
    
    <div class="container">
        <div class="header">
            <h1>📊 Analytics & Reports</h1>
            <p>Last 30 days</p>
            <p style="margin-top: 20px; color: #666;">Hello, <strong><%= userName != null ? userName : "User" %></strong></p>
        </div>
        
        <div class="cards">
            <div class="card">
                <div class="card-label">Total Emotions</div>
                <div class="card-value"><%= statistics.get("totalEmotions") != null ? statistics.get("totalEmotions") : 0 %></div>
                <div class="card-detail">Logged this month</div>
            </div>
            
            <div class="card">
                <div class="card-label">Total Decisions</div>
                <div class="card-value"><%= statistics.get("totalDecisions") != null ? statistics.get("totalDecisions") : 0 %></div>
                <div class="card-detail">Analyzed choices</div>
            </div>
            
            <div class="card">
                <div class="card-label">Habit Streak</div>
                <div class="card-value"><%= habitStreak %></div>
                <div class="card-detail">Consecutive days</div>
            </div>
            
            <div class="card">
                <div class="card-label">Habit Consistency</div>
                <div class="card-value"><%= String.format("%.1f", habitConsistency) %>%</div>
                <div class="card-detail">Completion rate</div>
            </div>
        </div>
        
        <div class="insight-box">
            <h3>💡 Key Insight</h3>
            <p><%= insightSummary %></p>
        </div>
        
        <div style="text-align: center; margin-top: 30px;">
            <p style="color: #999; font-size: 0.9em;">More detailed visualizations coming soon</p>
        </div>
        </div>
    </div>
    </div>
    
    <script>
        console.log('Analytics dashboard loaded for user <%= userId %>');
    </script>
</body>
</html>

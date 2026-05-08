<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.emovault.model.EmotionPattern" %>
<%@ page import="java.util.List" %>

<%
    Integer userId = (Integer) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");
    
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    EmotionPattern pattern = (EmotionPattern) request.getAttribute("pattern");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - EmoVault</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css">
    <style>
        .dashboard-wrapper {
            min-height: 100vh;
            background-color: var(--color-coconut);
            padding: var(--spacing-lg) 0;
        }
        
        .dashboard-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 var(--spacing-lg);
        }
        
        .dashboard-header {
            text-align: center;
            margin-bottom: var(--spacing-2xl);
        }
        
        .dashboard-header h1 {
            font-size: var(--font-size-3xl);
            color: var(--color-sage);
            margin-bottom: var(--spacing-sm);
        }
        
        .dashboard-header p {
            color: var(--color-text-light);
            font-size: var(--font-size-md);
        }
        
        .insights-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: var(--spacing-lg);
            margin-bottom: var(--spacing-2xl);
        }
        
        .insight-card {
            background-color: var(--color-honey);
            border-radius: var(--radius-lg);
            padding: var(--spacing-lg);
            box-shadow: var(--shadow-sm);
            border-left: 4px solid var(--color-sage);
            transition: all var(--transition-normal);
        }
        
        .insight-card:hover {
            box-shadow: var(--shadow-md);
            transform: translateY(-2px);
        }
        
        .insight-icon {
            font-size: var(--font-size-2xl);
            margin-bottom: var(--spacing-md);
            display: block;
        }
        
        .insight-text {
            color: var(--color-text-dark);
            font-size: var(--font-size-base);
            line-height: 1.8;
            color: var(--color-text-light);
        }
        
        .stats-section {
            background-color: var(--color-peach);
            border-radius: var(--radius-lg);
            padding: var(--spacing-xl);
            margin-bottom: var(--spacing-lg);
            box-shadow: var(--shadow-sm);
            border-left: 4px solid var(--color-blush);
        }
        
        .stats-section h2 {
            color: var(--color-sage);
            margin-bottom: var(--spacing-lg);
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: var(--spacing-lg);
        }
        
        .stat-item {
            background-color: var(--color-honey);
            padding: var(--spacing-lg);
            border-radius: var(--radius-md);
            text-align: center;
            box-shadow: var(--shadow-sm);
        }
        
        .stat-value {
            font-size: var(--font-size-3xl);
            font-weight: 700;
            color: var(--color-sage);
            margin-bottom: var(--spacing-sm);
        }
        
        .stat-label {
            font-size: var(--font-size-sm);
            color: var(--color-text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .triggers-section {
            background-color: var(--color-avocado);
            border-radius: var(--radius-lg);
            padding: var(--spacing-xl);
            margin-bottom: var(--spacing-lg);
            box-shadow: var(--shadow-sm);
            border-left: 4px solid #999;
        }
        
        .triggers-section h2 {
            color: var(--color-sage);
            margin-bottom: var(--spacing-lg);
        }
        
        .trigger-item {
            background-color: var(--color-honey);
            padding: var(--spacing-md) var(--spacing-lg);
            border-radius: var(--radius-md);
            margin-bottom: var(--spacing-md);
            border-left: 3px solid var(--color-sage);
            color: var(--color-text-dark);
        }
        
        .trigger-item:last-child {
            margin-bottom: 0;
        }
        
        .recommendations-section {
            background: linear-gradient(135deg, rgba(129, 130, 99, 0.05), rgba(194, 195, 149, 0.05));
            border-radius: var(--radius-lg);
            padding: var(--spacing-xl);
            margin-bottom: var(--spacing-lg);
            border-left: 4px solid var(--color-sage);
        }
        
        .recommendations-section h2 {
            color: var(--color-sage);
            margin-bottom: var(--spacing-lg);
        }
        
        .recommendation-item {
            padding: var(--spacing-md) 0;
            border-bottom: 1px solid var(--color-oat);
            color: var(--color-text-light);
        }
        
        .recommendation-item:last-child {
            border-bottom: none;
        }
        
        .empty-state {
            text-align: center;
            padding: var(--spacing-2xl);
            background-color: var(--color-honey);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-sm);
        }
        
        .empty-emoji {
            font-size: var(--font-size-3xl);
            margin-bottom: var(--spacing-md);
        }
        
        .empty-state h3 {
            color: var(--color-sage);
            margin-bottom: var(--spacing-md);
        }
        
        .empty-state p {
            color: var(--color-text-light);
            margin-bottom: var(--spacing-lg);
        }
        
        .action-buttons {
            display: flex;
            justify-content: center;
            gap: var(--spacing-lg);
            margin-top: var(--spacing-xl);
            flex-wrap: wrap;
        }
        
        .dashboard-button {
            padding: var(--spacing-md) var(--spacing-lg);
            border-radius: var(--radius-md);
            text-decoration: none;
            font-weight: 600;
            transition: all var(--transition-normal);
            display: inline-block;
            cursor: pointer;
            border: none;
        }
        
        .dashboard-button-primary {
            background-color: var(--color-sage);
            color: white;
        }
        
        .dashboard-button-primary:hover {
            background-color: #6d6e54;
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }
        
        .dashboard-button-secondary {
            background-color: var(--color-avocado);
            color: var(--color-sage);
            border: 2px solid var(--color-sage);
        }
        
        .dashboard-button-secondary:hover {
            background-color: #b0b380;
            transform: translateY(-2px);
        }
        
        @media (max-width: 768px) {
            .insights-grid {
                grid-template-columns: 1fr;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .dashboard-button {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <div class="navbar">
        <div class="navbar-brand">💝 EmoVault</div>
        <div class="navbar-menu">
            <a href="${pageContext.request.contextPath}/emotion.jsp">Emotions</a>
            <a href="${pageContext.request.contextPath}/diary">Diary</a>
            <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
            <span style="color: var(--color-text-dark); font-size: var(--font-size-sm);">
                Welcome, <strong><%= userName %></strong>
            </span>
            <a href="javascript:void(0)" onclick="logout()" style="color: var(--color-error);">Logout</a>
        </div>
    </div>
    
    <div class="dashboard-wrapper">
        <div class="dashboard-container">
            <div class="dashboard-header">
                <h1>📊 Your Emotional Dashboard</h1>
                <p>Understand your emotional patterns and discover insights about yourself</p>
            </div>
            
            <% if (pattern != null && pattern.getInsights() != null && !pattern.getInsights().isEmpty()) { %>
                
                <!-- Insights Section -->
                <div class="insights-grid">
                    <% for (String insight : pattern.getInsights()) { %>
                        <div class="insight-card">
                            <span class="insight-icon">
                                <% 
                                    if (insight.contains("😊")) out.print("😊");
                                    else if (insight.contains("⚠️")) out.print("⚠️");
                                    else if (insight.contains("😰")) out.print("😰");
                                    else if (insight.contains("🔄")) out.print("🔄");
                                    else if (insight.contains("💭")) out.print("💭");
                                    else out.print("💡");
                                %>
                            </span>
                            <div class="insight-text"><%= insight %></div>
                        </div>
                    <% } %>
                </div>
                
                <!-- Statistics Section -->
                <div class="stats-section">
                    <h2>📈 Quick Statistics</h2>
                    <div class="stats-grid">
                        <div class="stat-item">
                            <div class="stat-value"><%= pattern.getTotalEmotions() %></div>
                            <div class="stat-label">Total Emotions Logged</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-value"><%= pattern.getFrequentMood() != null ? pattern.getFrequentMood() : "—" %></div>
                            <div class="stat-label">Most Frequent Mood</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-value"><%= pattern.getHighStressCount() %></div>
                            <div class="stat-label">High Stress Incidents</div>
                        </div>
                    </div>
                </div>
                
                <!-- Repeated Triggers Section -->
                <% if (pattern.getRepeatedTriggers() != null && !pattern.getRepeatedTriggers().isEmpty()) { %>
                    <div class="triggers-section">
                        <h2>🎯 Your Common Triggers</h2>
                        <% for (String trigger : pattern.getRepeatedTriggers()) { %>
                            <div class="trigger-item"><%= trigger %></div>
                        <% } %>
                    </div>
                <% } %>
                
                <!-- Recommendations Section -->
                <div class="recommendations-section">
                    <h2>💡 Wellbeing Recommendations</h2>
                    <div class="recommendation-item">
                        <strong>Keep a Daily Journal</strong> — Record not just emotions but also what precedes them to identify patterns faster.
                    </div>
                    <div class="recommendation-item">
                        <strong>Practice Mindfulness</strong> — Spend 10 minutes daily in meditation or breathing exercises to manage stress.
                    </div>
                    <div class="recommendation-item">
                        <strong>Identify Your Triggers</strong> — Understand what causes specific emotions so you can develop coping strategies.
                    </div>
                    <div class="recommendation-item">
                        <strong>Build a Support System</strong> — Share your feelings with trusted friends or consider speaking with a counselor.
                    </div>
                    <div class="recommendation-item">
                        <strong>Take Regular Breaks</strong> — When overwhelmed, step away and engage in activities that bring you joy.
                    </div>
                </div>
                
            <% } else { %>
                <div class="empty-state">
                    <div class="empty-emoji">📭</div>
                    <h3>No Pattern Data Available Yet</h3>
                    <p>Start logging your emotions and writing diary entries to see personalized insights about your emotional patterns.</p>
                    
                    <div class="action-buttons">
                        <a href="${pageContext.request.contextPath}/emotion.jsp" class="dashboard-button dashboard-button-primary">
                            ➕ Log Your First Emotion
                        </a>
                        <a href="${pageContext.request.contextPath}/diary" class="dashboard-button dashboard-button-secondary">
                            ✍️ Write a Diary Entry
                        </a>
                    </div>
                </div>
            <% } %>
            
            <!-- Action Buttons -->
            <% if (pattern != null && pattern.getInsights() != null && !pattern.getInsights().isEmpty()) { %>
                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/emotion.jsp" class="dashboard-button dashboard-button-primary">
                        ➕ Log New Emotion
                    </a>
                    <a href="${pageContext.request.contextPath}/diary" class="dashboard-button dashboard-button-primary">
                        ✍️ Write in Diary
                    </a>
                    <button class="dashboard-button dashboard-button-secondary" onclick="location.reload();">
                        🔄 Refresh Insights
                    </button>
                </div>
            <% } %>
        </div>
    </div>
    
    <script>
        function logout() {
            if (confirm('Are you sure you want to logout?')) {
                window.location.href = '${pageContext.request.contextPath}/logout.jsp';
            }
        }
    </script>
</body>
</html>

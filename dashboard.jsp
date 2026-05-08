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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/design-system.css">
    <style>
        .dashboard-wrapper {
            min-height: 100vh;
            background: var(--gradient-bg-primary);
            padding: var(--space-lg) 0;
        }
        
        .dashboard-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 var(--space-lg);
        }
        
        .dashboard-header {
            text-align: center;
            margin-bottom: var(--space-2xl);
            animation: fade-in-up 0.6s ease-out;
        }
        
        .dashboard-header h1 {
            font-size: var(--font-size-3xl);
            background: var(--gradient-accent);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: var(--space-md);
        }
        
        .dashboard-header p {
            color: rgba(255, 255, 255, 0.8);
            font-size: var(--font-size-lg);
        }
        
        .insights-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: var(--space-lg);
            margin-bottom: var(--space-2xl);
        }
        
        .insight-card {
            background: rgba(255, 255, 255, 0.04);
            backdrop-filter: blur(10px);
            border-radius: var(--radius-lg);
            padding: var(--space-lg);
            box-shadow: 0 0 15px rgba(202, 169, 243, 0.08);
            border: 1px solid rgba(202, 169, 243, 0.2);
            transition: all var(--transition-base);
            animation: fade-in-up 0.6s ease-out forwards;
        }
        
        .insight-card:hover {
            box-shadow: 0 0 25px rgba(202, 169, 243, 0.15);
            transform: translateY(-4px);
            background: rgba(255, 255, 255, 0.06);
        }
        
        .insight-icon {
            font-size: var(--font-size-2xl);
            margin-bottom: var(--space-md);
            display: block;
        }
        
        .insight-text {
            color: rgba(255, 255, 255, 0.8);
            font-size: var(--font-size-base);
            line-height: 1.8;
        }
        
        .stats-section {
            background: rgba(202, 169, 243, 0.08);
            border-radius: var(--radius-lg);
            padding: var(--space-xl);
            margin-bottom: var(--space-lg);
            box-shadow: 0 0 20px rgba(202, 169, 243, 0.1);
            border: 1px solid rgba(202, 169, 243, 0.2);
        }
        
        .stats-section h2 {
            color: var(--color-phlox);
            margin-bottom: var(--space-lg);
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: var(--space-lg);
        }
        
        .stat-item {
            background: rgba(255, 255, 255, 0.04);
            padding: var(--space-lg);
            border-radius: var(--radius-md);
            text-align: center;
            box-shadow: 0 0 10px rgba(202, 169, 243, 0.05);
            border: 1px solid rgba(202, 169, 243, 0.15);
        }
        
        .stat-value {
            font-size: var(--font-size-3xl);
            font-weight: 700;
            color: var(--color-phlox);
            margin-bottom: var(--space-sm);
        }
        
        .stat-label {
            font-size: var(--font-size-sm);
            color: rgba(255, 255, 255, 0.6);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .triggers-section {
            background: rgba(179, 122, 212, 0.06);
            border-radius: var(--radius-lg);
            padding: var(--space-xl);
            margin-bottom: var(--space-lg);
            box-shadow: 0 0 15px rgba(179, 122, 212, 0.08);
            border: 1px solid rgba(179, 122, 212, 0.2);
        }
        
        .triggers-section h2 {
            color: var(--color-verbena);
            margin-bottom: var(--space-lg);
        }
        
        .trigger-item {
            background: rgba(255, 255, 255, 0.03);
            padding: var(--space-md) var(--space-lg);
            border-radius: var(--radius-md);
            margin-bottom: var(--space-md);
            border-left: 3px solid var(--color-phlox);
            color: rgba(255, 255, 255, 0.8);
        }
        
        .trigger-item:last-child {
            margin-bottom: 0;
        }
        
        .recommendations-section {
            background: rgba(255, 255, 255, 0.02);
            border-radius: var(--radius-lg);
            padding: var(--space-xl);
            margin-bottom: var(--space-lg);
            border: 1px solid rgba(255, 255, 255, 0.08);
        }
        
        .recommendations-section h2 {
            color: var(--color-phlox);
            margin-bottom: var(--space-lg);
        }
        
        .recommendation-item {
            padding: var(--space-md) 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
            color: rgba(255, 255, 255, 0.8);
        }
        
        .recommendation-item:last-child {
            border-bottom: none;
        }
        
        .empty-state {
            text-align: center;
            padding: var(--space-2xl);
            background: rgba(255, 255, 255, 0.04);
            border-radius: var(--radius-lg);
            box-shadow: 0 0 15px rgba(202, 169, 243, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .empty-emoji {
            font-size: var(--font-size-3xl);
            margin-bottom: var(--space-md);
        }
        
        .empty-state h3 {
            color: var(--color-phlox);
            margin-bottom: var(--space-md);
        }
        
        .empty-state p {
            color: rgba(255, 255, 255, 0.8);
            margin-bottom: var(--space-lg);
        }
        
        .action-buttons {
            display: flex;
            justify-content: center;
            gap: var(--space-lg);
            margin-top: var(--space-xl);
            flex-wrap: wrap;
        }
        
        .dashboard-button {
            padding: var(--space-md) var(--space-lg);
            border-radius: var(--radius-lg);
            text-decoration: none;
            font-weight: var(--font-weight-semibold);
            transition: all var(--transition-base);
            display: inline-block;
            cursor: pointer;
            border: none;
        }
        
        .dashboard-button-primary {
            background: var(--gradient-btn);
            color: white;
            box-shadow: 0 0 20px rgba(202, 169, 243, 0.3);
        }
        
        .dashboard-button-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 0 30px rgba(202, 169, 243, 0.5);
        }
        
        .dashboard-button-secondary {
            background: rgba(202, 169, 243, 0.15);
            color: var(--color-phlox);
            border: 1px solid rgba(202, 169, 243, 0.3);
        }
        
        .dashboard-button-secondary:hover {
            background: rgba(202, 169, 243, 0.25);
            transform: translateY(-2px);
            box-shadow: 0 0 15px rgba(202, 169, 243, 0.2);
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
            <a href="${pageContext.request.contextPath}/regret">Regrets</a>
            <a href="${pageContext.request.contextPath}/habit">Habits</a>
            <a href="${pageContext.request.contextPath}/alert">Alerts</a>
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

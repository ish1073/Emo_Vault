<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.emovault.model.BehaviorAnalysis" %>
<%@ page import="java.util.List" %>

<%
    Integer userId = (Integer) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");
    
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    BehaviorAnalysis analysis = (BehaviorAnalysis) request.getAttribute("analysis");
    if (analysis == null) {
        analysis = new BehaviorAnalysis();
    }
    
    // Risk level colors
    String riskColor = "Low".equals(analysis.getRiskLevel()) ? "#4CAF50" :
                       "Medium".equals(analysis.getRiskLevel()) ? "#FF9800" : "#E74C3C";
    String riskBg = "Low".equals(analysis.getRiskLevel()) ? "rgba(76, 175, 80, 0.1)" :
                    "Medium".equals(analysis.getRiskLevel()) ? "rgba(255, 152, 0, 0.1)" : "rgba(231, 76, 60, 0.1)";
    
    // Emotion emoji mapping
    java.util.Map<String, String> emotionEmoji = new java.util.HashMap<>();
    emotionEmoji.put("Happy", "😊");
    emotionEmoji.put("Sad", "😢");
    emotionEmoji.put("Stressed", "😰");
    emotionEmoji.put("Anxious", "😟");
    emotionEmoji.put("Angry", "😠");
    emotionEmoji.put("Calm", "😌");
    emotionEmoji.put("Excited", "🤩");
    emotionEmoji.put("Peaceful", "🕊️");
    emotionEmoji.put("Depressed", "💔");
    emotionEmoji.put("Grateful", "🙏");
    emotionEmoji.put("Neutral", "😐");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Behavior Analyzer - EmoVault</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Lora:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/design-system.css">
    <style>
        body {
            background: var(--gradient-bg-primary);
            margin: 0;
            padding: 0;
        }

        main {
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 250px;
            flex-shrink: 0;
        }

        .main-content {
            flex: 1;
            padding: var(--space-2xl);
        }

        .container {
            max-width: 1200px;
        }
        
        /* Page Header */
        .page-header {
            margin-bottom: var(--space-3xl);
            animation: fade-in-up 0.6s ease-out;
        }
        
        .page-title {
            font-size: var(--font-size-3xl);
            color: var(--color-heather);
            margin-bottom: var(--space-sm);
            font-family: var(--font-secondary);
            font-weight: var(--font-weight-bold);
        }
        
        .page-subtitle {
            font-size: var(--font-size-base);
            color: #2D4729;
        }
        
        /* Status Bar */
        .status-bar {
            background: var(--color-white);
            border-radius: var(--radius-lg);
            padding: var(--space-lg);
            margin-bottom: var(--space-2xl);
            box-shadow: var(--shadow-md);
            border: 1px solid rgba(230, 212, 191, 0.3);
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: var(--space-lg);
            animation: fade-in-up 0.8s ease-out;
        }
        
        .status-item {
            display: flex;
            align-items: center;
            gap: var(--space-md);
        }
        
        .status-label {
            font-size: var(--font-size-sm);
            color: var(--color-azur);
            font-weight: var(--font-weight-medium);
        }
        
        .status-value {
            font-size: var(--font-size-xl);
            font-weight: var(--font-weight-bold);
            color: var(--color-heather);
        }
        
        .status-emoji {
            font-size: 1.8rem;
        }
        
        /* Insights Grid - Floating Layout */
        .insights-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: var(--space-2xl);
            margin-bottom: var(--space-3xl);
        }
        
        /* Insight Card */
        .insight-card {
            position: relative;
            background: var(--color-white);
            border-radius: var(--radius-xl);
            padding: var(--space-2xl);
            box-shadow: var(--shadow-md);
            border: 2px solid transparent;
            background-clip: padding-box;
            transition: all 0.4s ease;
            animation: fade-in-up 0.8s ease-out;
            animation-fill-mode: both;
        }
        
        .insight-card:nth-child(1) { animation-delay: 0.1s; }
        .insight-card:nth-child(2) { animation-delay: 0.2s; }
        .insight-card:nth-child(3) { animation-delay: 0.3s; }
        
        .insight-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            border-radius: var(--radius-xl);
            padding: 2px;
            background: linear-gradient(135deg, #679F9F, #877499);
            z-index: -1;
        }
        
        .insight-card:hover {
            transform: translateY(-8px);
            box-shadow: var(--shadow-lg);
        }
        
        .insight-card-header {
            display: flex;
            align-items: center;
            gap: var(--space-md);
            margin-bottom: var(--space-lg);
        }
        
        .insight-icon {
            font-size: 2.5rem;
            line-height: 1;
        }
        
        .insight-title {
            font-size: var(--font-size-lg);
            font-weight: var(--font-weight-bold);
            color: var(--color-heather);
            margin: 0;
        }
        
        .insight-content {
            font-size: var(--font-size-base);
            color: #2D4729;
            line-height: var(--line-height-normal);
        }
        
        /* Dominant Emotion Card */
        .card-emotion {
            grid-column: 1;
        }
        
        .emotion-value {
            font-size: 2rem;
            font-weight: var(--font-weight-bold);
            color: var(--color-viridian);
            margin-top: var(--space-md);
            display: flex;
            align-items: center;
            gap: var(--space-md);
        }
        
        .emotion-emoji {
            font-size: 2.5rem;
        }
        
        .emotion-intensity {
            display: block;
            font-size: var(--font-size-sm);
            color: var(--color-warm-gray);
            margin-top: var(--space-sm);
            font-weight: normal;
        }
        
        /* Risk Level Card */
        .card-risk {
            grid-column: 2;
        }
        
        .risk-badge {
            display: inline-block;
            padding: var(--space-md) var(--space-lg);
            border-radius: var(--radius-full);
            font-weight: var(--font-weight-bold);
            font-size: var(--font-size-lg);
            margin-top: var(--space-md);
        }
        
        .risk-high {
            background: rgba(231, 76, 60, 0.15);
            color: #E74C3C;
            border: 2px solid #E74C3C;
        }
        
        .risk-medium {
            background: rgba(255, 152, 0, 0.15);
            color: #FF9800;
            border: 2px solid #FF9800;
        }
        
        .risk-low {
            background: rgba(76, 175, 80, 0.15);
            color: #4CAF50;
            border: 2px solid #4CAF50;
        }
        
        /* Pattern Card */
        .card-pattern {
            grid-column: 3;
        }
        
        .pattern-text {
            background: linear-gradient(135deg, rgba(103, 159, 159, 0.1), rgba(135, 116, 153, 0.1));
            border-left: 4px solid var(--color-viridian);
            padding: var(--space-lg);
            border-radius: var(--radius-md);
            margin-top: var(--space-md);
            font-style: italic;
            color: #2D4729;
            font-weight: var(--font-weight-medium);
        }
        
        /* Suggestions Section */
        .suggestions-section {
            margin-top: var(--space-3xl);
        }
        
        .section-title {
            font-size: var(--font-size-2xl);
            font-weight: var(--font-weight-bold);
            color: var(--color-heather);
            margin-bottom: var(--space-xl);
            display: flex;
            align-items: center;
            gap: var(--space-md);
        }
        
        .section-title::before {
            content: '✨';
            font-size: 1.8rem;
        }
        
        /* Suggestion Items */
        .suggestions-list {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: var(--space-lg);
        }
        
        .suggestion-item {
            background: var(--color-white);
            border-radius: var(--radius-lg);
            padding: var(--space-lg);
            box-shadow: var(--shadow-md);
            border-left: 4px solid var(--color-viridian);
            transition: all 0.3s ease;
            animation: fade-in-up 0.8s ease-out;
        }
        
        .suggestion-item:hover {
            transform: translateX(8px);
            box-shadow: var(--shadow-lg);
            border-left-color: var(--color-heather);
        }
        
        .suggestion-text {
            font-size: var(--font-size-base);
            color: #2D4729;
            line-height: var(--line-height-normal);
            margin: 0;
        }
        
        /* Data Info */
        .data-info {
            background: linear-gradient(135deg, rgba(230, 212, 191, 0.3), rgba(103, 159, 159, 0.1));
            border-radius: var(--radius-lg);
            padding: var(--space-lg);
            margin-top: var(--space-2xl);
            font-size: var(--font-size-sm);
            color: #2D4729;
            text-align: center;
        }
        
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: var(--space-3xl);
            color: #2D4729;
        }
        
        .empty-state-icon {
            font-size: 3rem;
            margin-bottom: var(--space-lg);
        }
        
        .empty-state-text {
            font-size: var(--font-size-lg);
            margin-bottom: var(--space-md);
            color: #2D4729;
            font-weight: var(--font-weight-semibold);
        }
        
        /* Responsive */
        @media (max-width: 1024px) {
            .insights-container {
                grid-template-columns: 1fr;
            }
            
            .card-emotion, .card-risk, .card-pattern {
                grid-column: 1;
            }
        }
        
        @media (max-width: 768px) {
            .page-title {
                font-size: var(--font-size-2xl);
            }
            
            .suggestions-list {
                grid-template-columns: 1fr;
            }
            
            .status-bar {
                flex-direction: column;
                align-items: flex-start;
            }
        }
    </style>
</head>
<body>
    <main>
        <jsp:include page="components/sidebar.jsp"><jsp:param name="currentPage" value="behavior_analyzer"/></jsp:include>
        <div class="main-content">
            <div class="container">
                <!-- Page Header -->
                <div class="page-header">
                    <h1 class="page-title">🧠 Behavior Insights</h1>
                    <p class="page-subtitle">Smart analysis of your emotional patterns and habits</p>
                </div>
                
                <!-- Check if analysis has data -->
                <% if (analysis.getTotalDataPoints() < 3) { %>
                    <div class="empty-state">
                        <div class="empty-state-icon">📊</div>
                        <div class="empty-state-text">Not enough data yet</div>
                        <p style="color: #2D4729; margin-top: var(--space-md);">
                            Log more emotions, diary entries, and habits to see behavioral insights.
                            <br><br>
                            <small style="color: #2D4729;">Minimum 3 emotions required for analysis</small>
                        </p>
                    </div>
                <% } else { %>
                    
                    <!-- Status Bar -->
                    <div class="status-bar">
                        <div class="status-item">
                            <span class="status-label">Analysis Based On:</span>
                            <span class="status-value"><%= analysis.getTotalDataPoints() %> Emotions</span>
                        </div>
                        <div class="status-item">
                            <span class="status-label">Negative Emotions:</span>
                            <span class="status-value"><%= analysis.getNegativeEmotionCount() %></span>
                        </div>
                        <div class="status-item">
                            <span class="status-label">Intensity Avg:</span>
                            <span class="status-value"><%= String.format("%.1f", analysis.getEmotionIntensityAverage()) %>/10</span>
                        </div>
                    </div>
                    
                    <!-- Insight Cards -->
                    <div class="insights-container">
                        
                        <!-- Dominant Emotion Card -->
                        <div class="insight-card card-emotion">
                            <div class="insight-card-header">
                                <div class="insight-icon"><%= emotionEmoji.getOrDefault(analysis.getDominantEmotion(), "😐") %></div>
                                <h3 class="insight-title">Dominant Emotion</h3>
                            </div>
                            <div class="insight-content">
                                Your most frequent emotion over the last 30 days
                            </div>
                            <div class="emotion-value">
                                <span><%= analysis.getDominantEmotion() %></span>
                                <span class="emotion-emoji"><%= emotionEmoji.getOrDefault(analysis.getDominantEmotion(), "😐") %></span>
                            </div>
                            <small class="emotion-intensity">Based on your logged emotions</small>
                        </div>
                        
                        <!-- Risk Level Card -->
                        <div class="insight-card card-risk">
                            <div class="insight-card-header">
                                <div class="insight-icon">⚠️</div>
                                <h3 class="insight-title">Risk Assessment</h3>
                            </div>
                            <div class="insight-content">
                                Your emotional wellness status
                            </div>
                            <div class="risk-badge risk-<%= analysis.getRiskLevel().toLowerCase() %>">
                                <%= analysis.getRiskLevel() %>
                            </div>
                        </div>
                        
                        <!-- Behavior Pattern Card -->
                        <div class="insight-card card-pattern">
                            <div class="insight-card-header">
                                <div class="insight-icon">🔄</div>
                                <h3 class="insight-title">Behavior Pattern</h3>
                            </div>
                            <div class="pattern-text">
                                <%= analysis.getDetectedBehaviorLoop() %>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Suggestions Section -->
                    <div class="suggestions-section">
                        <h2 class="section-title">Personalized Suggestions</h2>
                        <div class="suggestions-list">
                            <% 
                                List<String> suggestions = analysis.getSuggestions();
                                if (suggestions != null && !suggestions.isEmpty()) {
                                    for (String suggestion : suggestions) {
                            %>
                                <div class="suggestion-item">
                                    <p class="suggestion-text"><%= suggestion %></p>
                                </div>
                            <%
                                    }
                                } else {
                            %>
                                <p style="grid-column: 1/-1; color: var(--color-warm-gray); text-align: center;">No suggestions at this time.</p>
                            <%
                                }
                            %>
                        </div>
                    </div>
                    
                    <!-- Data Info -->
                    <div class="data-info">
                        <strong>📈 Analysis Period:</strong> Last 30 days | 
                        <strong>🔄 Last Updated:</strong> Just now | 
                        <strong>💡 Data Sources:</strong> Emotions, Diary, Regrets, Habits
                    </div>
                    
                <% } %>
            </div>
        </div>
    </main>
</body>
</html>

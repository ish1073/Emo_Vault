<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>

<%
    Integer expertId = (Integer) session.getAttribute("expertId");
    String expertName = (String) session.getAttribute("expertName");

    if (expertId == null) {
        response.sendRedirect(request.getContextPath() + "/expert_login.jsp");
        return;
    }
    
    // Safe null handling for display
    if (expertName == null) {
        expertName = "Expert";
    }
    
    // Get system stats with safe defaults
    Map<String, Object> systemStats = (Map<String, Object>) request.getAttribute("systemStats");
    if (systemStats == null) {
        systemStats = new HashMap<>();
    }
    
    String totalUsers = systemStats.get("totalUsers") != null ? systemStats.get("totalUsers").toString() : "0";
    String activeWeek = systemStats.get("activeWeek") != null ? systemStats.get("activeWeek").toString() : "0";
    String totalEntries = systemStats.get("totalEntries") != null ? systemStats.get("totalEntries").toString() : "0";
    String avgCheckIn = systemStats.get("avgCheckIn") != null ? systemStats.get("avgCheckIn").toString() : "0";
    
    // Get trend summary
    Map<String, Object> trendSummary = (Map<String, Object>) request.getAttribute("trendSummary");
    if (trendSummary == null) {
        trendSummary = new HashMap<>();
    }
    
    String trend = trendSummary.get("trend") != null ? trendSummary.get("trend").toString() : "stable";
    String peakTime = trendSummary.get("peakActivityTime") != null ? trendSummary.get("peakActivityTime").toString() : "Not enough data";
    
    // Get collections with safe defaults
    List<Map<String, Object>> highRiskUsers = (List<Map<String, Object>>) request.getAttribute("highRiskUsers");
    List<Map<String, Object>> recentSpikes = (List<Map<String, Object>>) request.getAttribute("recentSpikes");
    List<Map<String, Object>> recentAlerts = (List<Map<String, Object>>) request.getAttribute("recentAlerts");
    Map<String, Integer> commonEmotions = (Map<String, Integer>) request.getAttribute("commonEmotions");
    List<Map<String, Object>> attentionUsers = (List<Map<String, Object>>) request.getAttribute("attentionUsers");
    
    if (highRiskUsers == null) highRiskUsers = new ArrayList<>();
    if (recentSpikes == null) recentSpikes = new ArrayList<>();
    if (recentAlerts == null) recentAlerts = new ArrayList<>();
    if (commonEmotions == null) commonEmotions = new LinkedHashMap<>();
    if (attentionUsers == null) attentionUsers = new ArrayList<>();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Expert Dashboard - EmoVault</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/design-system.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            background: var(--gradient-bg-primary);
            margin: 0;
            padding: 0;
        }

        .expert-layout {
            display: flex;
            min-height: 100vh;
        }

        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: var(--space-2xl);
            transition: margin-left 0.3s ease-in-out, width 0.3s ease-in-out;
        }

        .section-header {
            margin-bottom: var(--space-2xl);
            animation: fade-in-up 0.6s ease-out;
        }

        .section-title {
            font-size: var(--font-size-3xl);
            color: var(--color-heather);
            margin-bottom: var(--space-sm);
            font-family: var(--font-secondary);
        }

        .section-subtitle {
            font-size: var(--font-size-base);
            color: var(--color-warm-gray);
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: var(--space-lg);
            margin-bottom: var(--space-2xl);
        }

        .stat-card {
            background: var(--color-white);
            border-radius: var(--radius-2xl);
            padding: var(--space-xl);
            box-shadow: var(--shadow-lg);
            border: 1px solid rgba(230, 212, 191, 0.3);
            animation: fade-in-up 0.6s ease-out;
        }

        .stat-label {
            font-size: var(--font-size-sm);
            color: var(--color-warm-gray);
            margin-bottom: var(--space-sm);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .stat-value {
            font-size: var(--font-size-3xl);
            color: var(--color-viridian);
            font-weight: var(--font-weight-bold);
        }

        .stat-trend {
            font-size: var(--font-size-sm);
            margin-top: var(--space-sm);
            display: flex;
            align-items: center;
            gap: var(--space-xs);
        }

        .trend-up { color: #e74c3c; }
        .trend-down { color: #27ae60; }
        .trend-stable { color: var(--color-warm-gray); }

        .content-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: var(--space-xl);
            margin-bottom: var(--space-2xl);
        }

        .card {
            background: var(--color-white);
            border-radius: var(--radius-2xl);
            padding: var(--space-xl);
            box-shadow: var(--shadow-lg);
            border: 1px solid rgba(230, 212, 191, 0.3);
            animation: fade-in-up 0.6s ease-out;
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: var(--space-lg);
        }

        .card-title {
            font-size: var(--font-size-xl);
            color: var(--color-heather);
            font-weight: var(--font-weight-semibold);
        }

        .card-badge {
            background: var(--color-cream);
            color: var(--color-viridian);
            padding: var(--space-xs) var(--space-md);
            border-radius: var(--radius-lg);
            font-size: var(--font-size-sm);
            font-weight: var(--font-weight-medium);
        }

        .alert-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .alert-item {
            padding: var(--space-md);
            border-radius: var(--radius-lg);
            margin-bottom: var(--space-sm);
            background: var(--color-cream);
            border-left: 4px solid var(--color-candy);
            transition: transform 0.2s ease;
        }

        .alert-item:hover {
            transform: translateX(4px);
        }

        .alert-item:last-child {
            margin-bottom: 0;
        }

        .alert-user {
            font-weight: var(--font-weight-semibold);
            color: var(--color-heather);
        }

        .alert-message {
            font-size: var(--font-size-sm);
            color: var(--color-warm-gray);
            margin-top: var(--space-xs);
        }

        .alert-time {
            font-size: var(--font-size-xs);
            color: var(--color-warm-gray);
            margin-top: var(--space-xs);
            opacity: 0.7;
        }

        .alert-severity {
            display: inline-block;
            padding: 2px 8px;
            border-radius: var(--radius-sm);
            font-size: var(--font-size-xs);
            font-weight: var(--font-weight-medium);
            margin-left: var(--space-sm);
        }

        .severity-high {
            background: #ffebee;
            color: #c62828;
        }

        .severity-medium {
            background: #fff3e0;
            color: #e65100;
        }

        .severity-low {
            background: #e8f5e9;
            color: #2e7d32;
        }

        .user-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .user-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: var(--space-md);
            border-radius: var(--radius-lg);
            margin-bottom: var(--space-sm);
            background: var(--color-cream);
            transition: transform 0.2s ease;
        }

        .user-item:hover {
            transform: translateX(4px);
        }

        .user-item:last-child {
            margin-bottom: 0;
        }

        .user-info {
            display: flex;
            flex-direction: column;
        }

        .user-name {
            font-weight: var(--font-weight-semibold);
            color: var(--color-heather);
        }

        .user-detail {
            font-size: var(--font-size-sm);
            color: var(--color-warm-gray);
        }

        .user-metric {
            text-align: right;
        }

        .metric-value {
            font-size: var(--font-size-lg);
            font-weight: var(--font-weight-bold);
            color: var(--color-candy);
        }

        .metric-label {
            font-size: var(--font-size-xs);
            color: var(--color-warm-gray);
        }

        .chart-container {
            position: relative;
            height: 300px;
            margin-top: var(--space-lg);
        }

        .insights-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: var(--space-lg);
            margin-bottom: var(--space-2xl);
        }

        .insight-card {
            background: var(--color-white);
            border-radius: var(--radius-xl);
            padding: var(--space-lg);
            box-shadow: var(--shadow-md);
            border-left: 4px solid var(--color-candy);
        }

        .insight-label {
            font-size: var(--font-size-sm);
            color: var(--color-warm-gray);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: var(--space-sm);
        }

        .insight-value {
            font-size: var(--font-size-xl);
            color: var(--color-heather);
            font-weight: var(--font-weight-semibold);
        }

        .header-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: var(--space-xl);
        }

        .user-greeting {
            color: var(--color-warm-gray);
            font-size: var(--font-size-base);
        }

        .logout-btn {
            background: var(--color-cream);
            color: var(--color-heather);
            border: 2px solid var(--color-heather);
            padding: var(--space-sm) var(--space-lg);
            border-radius: var(--radius-lg);
            cursor: pointer;
            font-weight: var(--font-weight-medium);
            transition: all var(--transition-base);
        }

        .logout-btn:hover {
            background: var(--color-sandstone);
        }

        .empty-state {
            text-align: center;
            padding: var(--space-2xl);
            color: var(--color-warm-gray);
        }

        .empty-state-icon {
            font-size: 3rem;
            margin-bottom: var(--space-md);
        }

        @media (max-width: 1024px) {
            .content-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: var(--space-lg);
            }

            .header-bar {
                flex-direction: column;
                gap: var(--space-lg);
            }

            .dashboard-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="expert-layout">
        <!-- Expert Sidebar -->
        <jsp:include page="components/expert-sidebar.jsp">
            <jsp:param name="currentPage" value="expert_dashboard" />
        </jsp:include>

        <!-- Main Content -->
        <div class="main-content">
            <div class="header-bar">
                <div>
                    <h1 class="section-title">🧠 Expert Dashboard</h1>
                    <p class="user-greeting">Welcome back, <%= expertName %></p>
                </div>
                <form action="${pageContext.request.contextPath}/expert" method="post" style="margin: 0;">
                    <input type="hidden" name="action" value="logout">
                    <button type="submit" class="logout-btn">🚪 Logout</button>
                </form>
            </div>

            <!-- Key Statistics -->
            <div class="dashboard-grid">
                <div class="stat-card">
                    <div class="stat-label">Total Users</div>
                    <div class="stat-value"><%= totalUsers %></div>
                    <div class="stat-trend trend-stable">
                        <span>All registered users</span>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Active This Week</div>
                    <div class="stat-value"><%= activeWeek %></div>
                    <div class="stat-trend">
                        <span>Users with activity in 7 days</span>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Total Entries Logged</div>
                    <div class="stat-value"><%= totalEntries %></div>
                    <div class="stat-trend">
                        <span>Emotions, diary, habits, reflections</span>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Avg. Daily Check-in</div>
                    <div class="stat-value"><%= avgCheckIn %>%</div>
                    <div class="stat-trend <%= "increasing".equals(trend) ? "trend-up" : "decreasing".equals(trend) ? "trend-down" : "trend-stable" %>">
                        <span>Trend: <%= trend.toUpperCase() %></span>
                    </div>
                </div>
            </div>

            <!-- Main Content Grid -->
            <div class="content-grid">
                <!-- Left Column -->
                <div>
                    <!-- High Risk Users -->
                    <div class="card" style="margin-bottom: var(--space-xl);">
                        <div class="card-header">
                            <h3 class="card-title">⚠️ High Risk Users</h3>
                            <span class="card-badge"><%= highRiskUsers.size() %> users</span>
                        </div>
                        <% if (highRiskUsers.isEmpty()) { %>
                            <div class="empty-state">
                                <div class="empty-state-icon">✅</div>
                                <p>No users currently at high risk</p>
                            </div>
                        <% } else { %>
                            <ul class="user-list">
                                <% for (Map<String, Object> user : highRiskUsers) { %>
                                    <li class="user-item">
                                        <div class="user-info">
                                            <span class="user-name"><%= user.get("username") != null ? user.get("username") : "Unknown" %></span>
                                            <span class="user-detail">
                                                <%= user.get("highIntensityCount") != null ? user.get("highIntensityCount") : 0 %> high intensity | 
                                                <%= user.get("negativeEmotionCount") != null ? user.get("negativeEmotionCount") : 0 %> negative emotions
                                            </span>
                                        </div>
                                        <div class="user-metric">
                                            <div class="metric-value"><%= user.get("avgIntensity") != null ? String.format("%.1f", user.get("avgIntensity")) : "0.0" %></div>
                                            <div class="metric-label">Avg Intensity</div>
                                        </div>
                                    </li>
                                <% } %>
                            </ul>
                        <% } %>
                    </div>

                    <!-- Recent Emotional Spikes -->
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">📈 Recent Emotional Spikes</h3>
                            <span class="card-badge">Last 24 hours</span>
                        </div>
                        <% if (recentSpikes.isEmpty()) { %>
                            <div class="empty-state">
                                <div class="empty-state-icon">😊</div>
                                <p>No emotional spikes detected</p>
                            </div>
                        <% } else { %>
                            <ul class="alert-list">
                                <% for (Map<String, Object> spike : recentSpikes) { %>
                                    <li class="alert-item">
                                        <div class="alert-user">
                                            <%= spike.get("username") != null ? spike.get("username") : "Unknown" %>
                                            <span class="alert-severity severity-high">Intensity: <%= spike.get("intensity") != null ? spike.get("intensity") : 0 %></span>
                                        </div>
                                        <div class="alert-message">
                                            <%= spike.get("mood") != null ? spike.get("mood") : "Unknown" %> - Trigger: <%= spike.get("trigger") != null ? spike.get("trigger") : "Not specified" %>
                                        </div>
                                        <div class="alert-time">
                                            <%= spike.get("createdAt") != null ? spike.get("createdAt") : "" %>
                                        </div>
                                    </li>
                                <% } %>
                            </ul>
                        <% } %>
                    </div>
                </div>

                <!-- Right Column -->
                <div>
                    <!-- Recent Alerts -->
                    <div class="card" style="margin-bottom: var(--space-xl);">
                        <div class="card-header">
                            <h3 class="card-title">🔔 Recent Alerts</h3>
                            <span class="card-badge"><%= recentAlerts.size() %></span>
                        </div>
                        <% if (recentAlerts.isEmpty()) { %>
                            <div class="empty-state">
                                <div class="empty-state-icon">🔔</div>
                                <p>No recent alerts</p>
                            </div>
                        <% } else { %>
                            <ul class="alert-list">
                                <% for (Map<String, Object> alert : recentAlerts) { %>
                                    <li class="alert-item">
                                        <div class="alert-user">
                                            <%= alert.get("username") != null ? alert.get("username") : "Unknown" %>
                                            <span class="alert-severity severity-<%= alert.get("severity") != null ? alert.get("severity") : "low" %>"><%= alert.get("severity") != null ? alert.get("severity") : "LOW" %></span>
                                        </div>
                                        <div class="alert-message"><%= alert.get("message") != null ? alert.get("message") : "" %></div>
                                        <div class="alert-time"><%= alert.get("createdAt") != null ? alert.get("createdAt") : "" %></div>
                                    </li>
                                <% } %>
                            </ul>
                        <% } %>
                    </div>

                    <!-- Emotional Distribution -->
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">💭 Emotional Distribution</h3>
                            <span class="card-badge">Last 7 days</span>
                        </div>
                        <div class="chart-container">
                            <canvas id="emotionChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Bottom Insights -->
            <div class="insights-grid">
                <div class="insight-card">
                    <div class="insight-label">Peak Activity Time</div>
                    <div class="insight-value"><%= peakTime %></div>
                </div>
                <div class="insight-card">
                    <div class="insight-label">Users Needing Attention</div>
                    <div class="insight-value"><%= attentionUsers.size() %></div>
                </div>
                <div class="insight-card">
                    <div class="insight-label">Active Rules</div>
                    <div class="insight-value"><%= request.getAttribute("ruleCount") %></div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Emotion Distribution Chart
        const emotionCtx = document.getElementById('emotionChart').getContext('2d');
        
        // Build chart data from server-side map
        const emotionLabels = [];
        const emotionData = [];
        
        <% for (Map.Entry<String, Integer> entry : commonEmotions.entrySet()) { %>
            emotionLabels.push('<%= entry.getKey() %>');
            emotionData.push(<%= entry.getValue() %>);
        <% } %>
        
        new Chart(emotionCtx, {
            type: 'doughnut',
            data: {
                labels: emotionLabels,
                datasets: [{
                    data: emotionData,
                    backgroundColor: [
                        '#E18299',
                        '#679F9F',
                        '#E6D4BF',
                        '#877499',
                        '#2D4729',
                        '#C9B5D5',
                        '#9B59B6',
                        '#1ABC9C'
                    ]
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });
    </script>
</body>
</html>
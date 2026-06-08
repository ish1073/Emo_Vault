<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>

<%
    Integer expertId = (Integer) session.getAttribute("expertId");
    String expertName = (String) session.getAttribute("expertName");

    if (expertId == null) {
        response.sendRedirect(request.getContextPath() + "/expert_login.jsp");
        return;
    }
    
    if (expertName == null) {
        expertName = "Expert";
    }
    
    Map<String, Object> systemStats = (Map<String, Object>) request.getAttribute("systemStats");
    Map<String, Object> trendSummary = (Map<String, Object>) request.getAttribute("trendSummary");
    Map<String, Integer> commonEmotions = (Map<String, Integer>) request.getAttribute("commonEmotions");
    List<Map<String, Object>> weeklyTrends = (List<Map<String, Object>>) request.getAttribute("weeklyTrends");
    List<Map<String, Object>> engagementTrends = (List<Map<String, Object>>) request.getAttribute("engagementTrends");
    List<Map<String, Object>> intensityTrends = (List<Map<String, Object>>) request.getAttribute("intensityTrends");
    Map<String, Object> categoryAnalytics = (Map<String, Object>) request.getAttribute("categoryAnalytics");
    int timeframe = (Integer) request.getAttribute("timeframe");
    
    if (systemStats == null) systemStats = new HashMap<>();
    if (trendSummary == null) trendSummary = new HashMap<>();
    if (commonEmotions == null) commonEmotions = new LinkedHashMap<>();
    if (weeklyTrends == null) weeklyTrends = new ArrayList<>();
    if (engagementTrends == null) engagementTrends = new ArrayList<>();
    if (intensityTrends == null) intensityTrends = new ArrayList<>();
    if (categoryAnalytics == null) categoryAnalytics = new HashMap<>();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Analytics & Trends - EmoVault Expert</title>
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
            transition: margin-left 0.3s ease-in-out;
        }

        .section-title {
            font-size: var(--font-size-3xl);
            color: var(--color-heather);
            margin-bottom: var(--space-sm);
            font-family: var(--font-secondary);
        }

        .user-greeting {
            color: var(--color-warm-gray);
            font-size: var(--font-size-base);
        }

        .header-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: var(--space-xl);
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

        .timeframe-selector {
            display: flex;
            gap: var(--space-md);
            margin-bottom: var(--space-xl);
        }

        .timeframe-btn {
            background: var(--color-white);
            color: var(--color-heather);
            border: 2px solid var(--color-cream);
            padding: var(--space-sm) var(--space-lg);
            border-radius: var(--radius-lg);
            cursor: pointer;
            font-weight: var(--font-weight-medium);
            transition: all var(--transition-base);
            text-decoration: none;
        }

        .timeframe-btn:hover {
            border-color: var(--color-viridian);
        }

        .timeframe-btn.active {
            background: var(--color-viridian);
            color: white;
            border-color: var(--color-viridian);
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: var(--space-lg);
            margin-bottom: var(--space-2xl);
        }

        .stat-card {
            background: var(--color-white);
            border-radius: var(--radius-2xl);
            padding: var(--space-xl);
            box-shadow: var(--shadow-lg);
            border: 1px solid rgba(230, 212, 191, 0.3);
            text-align: center;
        }

        .stat-value {
            font-size: var(--font-size-3xl);
            color: var(--color-viridian);
            font-weight: var(--font-weight-bold);
        }

        .stat-label {
            font-size: var(--font-size-sm);
            color: var(--color-warm-gray);
            margin-top: var(--space-sm);
        }

        .charts-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: var(--space-xl);
            margin-bottom: var(--space-2xl);
        }

        .chart-card {
            background: var(--color-white);
            border-radius: var(--radius-2xl);
            padding: var(--space-xl);
            box-shadow: var(--shadow-lg);
            border: 1px solid rgba(230, 212, 191, 0.3);
        }

        .chart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: var(--space-lg);
        }

        .chart-title {
            font-size: var(--font-size-xl);
            color: var(--color-heather);
            font-weight: var(--font-weight-semibold);
        }

        .chart-container {
            position: relative;
            height: 300px;
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

        .trend-indicator {
            display: inline-block;
            padding: 2px 8px;
            border-radius: var(--radius-sm);
            font-size: var(--font-size-xs);
            font-weight: var(--font-weight-medium);
            margin-left: var(--space-sm);
        }

        .trend-up {
            background: #ffebee;
            color: #c62828;
        }

        .trend-down {
            background: #e8f5e9;
            color: #2e7d32;
        }

        .trend-stable {
            background: #e3f2fd;
            color: #1565c0;
        }

        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: var(--space-lg);
            }

            .charts-grid {
                grid-template-columns: 1fr;
            }

            .timeframe-selector {
                flex-wrap: wrap;
            }
        }
    </style>
</head>
<body>
    <div class="expert-layout">
        <!-- Expert Sidebar -->
        <jsp:include page="components/expert-sidebar.jsp">
            <jsp:param name="currentPage" value="analytics" />
        </jsp:include>

        <!-- Main Content -->
        <div class="main-content">
            <div class="header-bar">
                <div>
                    <h1 class="section-title">📈 Analytics & Trends</h1>
                    <p class="user-greeting">Welcome back, <%= expertName %></p>
                </div>
                <form action="${pageContext.request.contextPath}/expert" method="post" style="margin: 0;">
                    <input type="hidden" name="action" value="logout">
                    <button type="submit" class="logout-btn">🚪 Logout</button>
                </form>
            </div>

            <!-- Timeframe Selector -->
            <div class="timeframe-selector">
                <a href="${pageContext.request.contextPath}/expert/analytics?timeframe=7" 
                   class="timeframe-btn <%= timeframe == 7 ? "active" : "" %>">7 Days</a>
                <a href="${pageContext.request.contextPath}/expert/analytics?timeframe=14" 
                   class="timeframe-btn <%= timeframe == 14 ? "active" : "" %>">14 Days</a>
                <a href="${pageContext.request.contextPath}/expert/analytics?timeframe=30" 
                   class="timeframe-btn <%= timeframe == 30 ? "active" : "" %>">30 Days</a>
            </div>

            <!-- System Stats -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-value"><%= systemStats.get("totalUsers") %></div>
                    <div class="stat-label">Total Users</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value"><%= systemStats.get("activeWeek") %></div>
                    <div class="stat-label">Active This Week</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value"><%= systemStats.get("totalEntries") %></div>
                    <div class="stat-label">Total Entries</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value"><%= systemStats.get("avgCheckIn") %>%</div>
                    <div class="stat-label">Daily Check-in Rate</div>
                </div>
            </div>

            <!-- Trend Summary -->
            <div class="insights-grid">
                <div class="insight-card">
                    <div class="insight-label">Emotional Trend</div>
                    <div class="insight-value">
                        <%= trendSummary.get("trend") %>
                        <span class="trend-indicator trend-<%= trendSummary.get("trend") %>">
                            <%= trendSummary.get("trend").equals("increasing") ? "↑" : trendSummary.get("trend").equals("decreasing") ? "↓" : "→" %>
                        </span>
                    </div>
                </div>
                <div class="insight-card">
                    <div class="insight-label">Avg Intensity (Current Week)</div>
                    <div class="insight-value"><%= trendSummary.get("currentAvgIntensity") != null ? String.format("%.1f", trendSummary.get("currentAvgIntensity")) : "N/A" %></div>
                </div>
                <div class="insight-card">
                    <div class="insight-label">Peak Activity Time</div>
                    <div class="insight-value"><%= trendSummary.get("peakActivityTime") %></div>
                </div>
            </div>

            <!-- Charts -->
            <div class="charts-grid">
                <!-- Engagement Trends Chart -->
                <div class="chart-card">
                    <div class="chart-header">
                        <h3 class="chart-title">User Engagement Trends</h3>
                    </div>
                    <div class="chart-container">
                        <canvas id="engagementChart"></canvas>
                    </div>
                </div>

                <!-- Intensity Trends Chart -->
                <div class="chart-card">
                    <div class="chart-header">
                        <h3 class="chart-title">Emotional Intensity Trends</h3>
                    </div>
                    <div class="chart-container">
                        <canvas id="intensityChart"></canvas>
                    </div>
                </div>

                <!-- Emotion Distribution Chart -->
                <div class="chart-card">
                    <div class="chart-header">
                        <h3 class="chart-title">Emotion Distribution</h3>
                    </div>
                    <div class="chart-container">
                        <canvas id="emotionChart"></canvas>
                    </div>
                </div>

                <!-- Triggers Chart -->
                <div class="chart-card">
                    <div class="chart-header">
                        <h3 class="chart-title">Common Emotional Triggers</h3>
                    </div>
                    <div class="chart-container">
                        <canvas id="triggersChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Engagement Trends Chart
        const engagementCtx = document.getElementById('engagementChart').getContext('2d');
        const engagementLabels = [];
        const engagementUsers = [];
        const engagementEntries = [];
        
        <% for (Map<String, Object> trend : engagementTrends) { %>
            engagementLabels.push('<%= trend.get("date") %>');
            engagementUsers.push(<%= trend.get("activeUsers") %>);
            engagementEntries.push(<%= trend.get("totalEntries") %>);
        <% } %>
        
        new Chart(engagementCtx, {
            type: 'line',
            data: {
                labels: engagementLabels,
                datasets: [{
                    label: 'Active Users',
                    data: engagementUsers,
                    borderColor: '#679F9F',
                    backgroundColor: 'rgba(103, 159, 159, 0.1)',
                    tension: 0.4
                }, {
                    label: 'Total Entries',
                    data: engagementEntries,
                    borderColor: '#E18299',
                    backgroundColor: 'rgba(225, 130, 153, 0.1)',
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { position: 'bottom' }
                }
            }
        });

        // Intensity Trends Chart
        const intensityCtx = document.getElementById('intensityChart').getContext('2d');
        const intensityLabels = [];
        const avgIntensity = [];
        const maxIntensity = [];
        const minIntensity = [];
        
        <% for (Map<String, Object> trend : intensityTrends) { %>
            intensityLabels.push('<%= trend.get("date") %>');
            avgIntensity.push(<%= trend.get("avgIntensity") %>);
            maxIntensity.push(<%= trend.get("maxIntensity") %>);
            minIntensity.push(<%= trend.get("minIntensity") %>);
        <% } %>
        
        new Chart(intensityCtx, {
            type: 'line',
            data: {
                labels: intensityLabels,
                datasets: [{
                    label: 'Average Intensity',
                    data: avgIntensity,
                    borderColor: '#E18299',
                    backgroundColor: 'rgba(225, 130, 153, 0.1)',
                    tension: 0.4
                }, {
                    label: 'Max Intensity',
                    data: maxIntensity,
                    borderColor: '#e74c3c',
                    backgroundColor: 'rgba(231, 76, 60, 0.1)',
                    tension: 0.4
                }, {
                    label: 'Min Intensity',
                    data: minIntensity,
                    borderColor: '#27ae60',
                    backgroundColor: 'rgba(39, 174, 96, 0.1)',
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { position: 'bottom' }
                }
            }
        });

        // Emotion Distribution Chart
        const emotionCtx = document.getElementById('emotionChart').getContext('2d');
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
                        '#E18299', '#679F9F', '#E6D4BF', '#877499', 
                        '#2D4729', '#C9B5D5', '#9B59B6', '#1ABC9C'
                    ]
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { position: 'bottom' }
                }
            }
        });

        // Triggers Chart
        const triggersCtx = document.getElementById('triggersChart').getContext('2d');
        const triggerLabels = [];
        const triggerData = [];
        
        <% 
        List<Map<String, Object>> triggers = (List<Map<String, Object>>) categoryAnalytics.get("triggers");
        if (triggers != null) {
            for (Map<String, Object> trigger : triggers) { 
        %>
            triggerLabels.push('<%= trigger.get("name") %>');
            triggerData.push(<%= trigger.get("count") %>);
        <% 
            } 
        } 
        %>
        
        new Chart(triggersCtx, {
            type: 'bar',
            data: {
                labels: triggerLabels,
                datasets: [{
                    label: 'Occurrences',
                    data: triggerData,
                    backgroundColor: '#679F9F'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false }
                }
            }
        });
    </script>
</body>
</html>
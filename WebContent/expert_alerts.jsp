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
    
    List<Map<String, Object>> alerts = (List<Map<String, Object>>) request.getAttribute("alerts");
    Map<String, Integer> alertStats = (Map<String, Integer>) request.getAttribute("alertStats");
    List<Map<String, Object>> emotionalSpikes = (List<Map<String, Object>>) request.getAttribute("emotionalSpikes");
    List<Map<String, Object>> highRiskUsers = (List<Map<String, Object>>) request.getAttribute("highRiskUsers");
    String currentFilter = (String) request.getAttribute("currentFilter");
    
    if (alerts == null) alerts = new ArrayList<>();
    if (alertStats == null) alertStats = new HashMap<>();
    if (emotionalSpikes == null) emotionalSpikes = new ArrayList<>();
    if (highRiskUsers == null) highRiskUsers = new ArrayList<>();
    if (currentFilter == null) currentFilter = "all";
    
    int totalAlerts = alertStats.get("total") != null ? alertStats.get("total") : 0;
    int highCount = alertStats.get("high") != null ? alertStats.get("high") : 0;
    int mediumCount = alertStats.get("medium") != null ? alertStats.get("medium") : 0;
    int lowCount = alertStats.get("low") != null ? alertStats.get("low") : 0;
    int resolvedCount = alertStats.get("resolved") != null ? alertStats.get("resolved") : 0;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Emotional Risk Alerts - EmoVault Expert</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/design-system.css">
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

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
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
            font-weight: var(--font-weight-bold);
        }

        .stat-label {
            font-size: var(--font-size-sm);
            color: var(--color-warm-gray);
            margin-top: var(--space-sm);
        }

        .stat-value.high { color: #e74c3c; }
        .stat-value.medium { color: #e65100; }
        .stat-value.low { color: #2e7d32; }
        .stat-value.resolved { color: var(--color-viridian); }

        .filter-bar {
            display: flex;
            gap: var(--space-md);
            margin-bottom: var(--space-xl);
        }

        .filter-btn {
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

        .filter-btn:hover {
            border-color: var(--color-viridian);
        }

        .filter-btn.active {
            background: var(--color-viridian);
            color: white;
            border-color: var(--color-viridian);
        }

        .content-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: var(--space-xl);
        }

        .card {
            background: var(--color-white);
            border-radius: var(--radius-2xl);
            padding: var(--space-xl);
            box-shadow: var(--shadow-lg);
            border: 1px solid rgba(230, 212, 191, 0.3);
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
            border-left: 4px solid;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .alert-item:last-child {
            margin-bottom: 0;
        }

        .alert-severity-high { border-left-color: #e74c3c; }
        .alert-severity-medium { border-left-color: #e65100; }
        .alert-severity-low { border-left-color: #2e7d32; }

        .alert-content {
            flex: 1;
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

        .alert-actions {
            display: flex;
            gap: var(--space-sm);
            align-items: center;
        }

        .severity-badge {
            display: inline-block;
            padding: 2px 8px;
            border-radius: var(--radius-sm);
            font-size: var(--font-size-xs);
            font-weight: var(--font-weight-medium);
            text-transform: capitalize;
        }

        .severity-badge.high { background: #ffebee; color: #c62828; }
        .severity-badge.medium { background: #fff3e0; color: #e65100; }
        .severity-badge.low { background: #e8f5e9; color: #2e7d32; }

        .resolve-btn {
            background: var(--color-viridian);
            color: white;
            border: none;
            padding: var(--space-xs) var(--space-md);
            border-radius: var(--radius-md);
            cursor: pointer;
            font-size: var(--font-size-sm);
            font-weight: var(--font-weight-medium);
            transition: all var(--transition-base);
        }

        .resolve-btn:hover {
            background: var(--color-candy);
        }

        .resolved-badge {
            background: #e8f5e9;
            color: #2e7d32;
            padding: var(--space-xs) var(--space-md);
            border-radius: var(--radius-md);
            font-size: var(--font-size-sm);
            font-weight: var(--font-weight-medium);
        }

        .side-panel {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .side-item {
            padding: var(--space-md);
            border-radius: var(--radius-lg);
            margin-bottom: var(--space-sm);
            background: var(--color-cream);
        }

        .side-item:last-child {
            margin-bottom: 0;
        }

        .side-title {
            font-weight: var(--font-weight-semibold);
            color: var(--color-heather);
        }

        .side-meta {
            font-size: var(--font-size-sm);
            color: var(--color-warm-gray);
            margin-top: var(--space-xs);
        }

        .empty-state {
            text-align: center;
            padding: var(--space-2xl);
            color: var(--color-warm-gray);
        }

        .empty-state-icon {
            font-size: 2rem;
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

            .stats-grid {
                grid-template-columns: 1fr 1fr;
            }

            .filter-bar {
                flex-wrap: wrap;
            }
        }
    </style>
</head>
<body>
    <div class="expert-layout">
        <!-- Expert Sidebar -->
        <jsp:include page="components/expert-sidebar.jsp">
            <jsp:param name="currentPage" value="alerts" />
        </jsp:include>

        <!-- Main Content -->
        <div class="main-content">
            <div class="header-bar">
                <div>
                    <h1 class="section-title">⚠️ Emotional Risk Alerts</h1>
                    <p class="user-greeting">Welcome back, <%= expertName %></p>
                </div>
                <form action="${pageContext.request.contextPath}/expert" method="post" style="margin: 0;">
                    <input type="hidden" name="action" value="logout">
                    <button type="submit" class="logout-btn">🚪 Logout</button>
                </form>
            </div>

            <!-- Stats -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-value high"><%= totalAlerts %></div>
                    <div class="stat-label">Total Alerts</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value high"><%= highCount %></div>
                    <div class="stat-label">High Severity</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value medium"><%= mediumCount %></div>
                    <div class="stat-label">Medium Severity</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value low"><%= lowCount %></div>
                    <div class="stat-label">Low Severity</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value resolved"><%= resolvedCount %></div>
                    <div class="stat-label">Resolved</div>
                </div>
            </div>

            <!-- Filter Bar -->
            <div class="filter-bar">
                <a href="${pageContext.request.contextPath}/expert/alerts?filter=all" 
                   class="filter-btn <%= "all".equals(currentFilter) ? "active" : "" %>">All</a>
                <a href="${pageContext.request.contextPath}/expert/alerts?filter=high" 
                   class="filter-btn <%= "high".equals(currentFilter) ? "active" : "" %>">High</a>
                <a href="${pageContext.request.contextPath}/expert/alerts?filter=medium" 
                   class="filter-btn <%= "medium".equals(currentFilter) ? "active" : "" %>">Medium</a>
                <a href="${pageContext.request.contextPath}/expert/alerts?filter=low" 
                   class="filter-btn <%= "low".equals(currentFilter) ? "active" : "" %>">Low</a>
            </div>

            <div class="content-grid">
                <!-- Alerts List -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">Recent Alerts</h3>
                        <span><%= alerts.size() %> alerts</span>
                    </div>
                    <% if (alerts.isEmpty()) { %>
                        <div class="empty-state">
                            <div class="empty-state-icon">✅</div>
                            <p>No alerts in this category</p>
                        </div>
                    <% } else { %>
                        <ul class="alert-list">
                            <% for (Map<String, Object> alert : alerts) { %>
                                <li class="alert-item alert-severity-<%= alert.get("severity") %>">
                                    <div class="alert-content">
                                        <div class="alert-user">
                                            <%= alert.get("username") %>
                                            <span class="severity-badge <%= alert.get("severity") %>"><%= alert.get("severity") %></span>
                                        </div>
                                        <div class="alert-message"><%= alert.get("message") %></div>
                                        <div class="alert-time"><%= alert.get("createdAt") %></div>
                                    </div>
                                    <div class="alert-actions">
                                        <% if (!(Boolean)alert.get("isResolved")) { %>
                                            <form action="${pageContext.request.contextPath}/expert/alerts" method="post" style="margin: 0;">
                                                <input type="hidden" name="action" value="resolve">
                                                <input type="hidden" name="alertId" value="<%= alert.get("alertId") %>">
                                                <button type="submit" class="resolve-btn">Mark Resolved</button>
                                            </form>
                                        <% } else { %>
                                            <span class="resolved-badge">✓ Resolved</span>
                                        <% } %>
                                    </div>
                                </li>
                            <% } %>
                        </ul>
                    <% } %>
                </div>

                <!-- Side Panel -->
                <div>
                    <!-- Emotional Spikes -->
                    <div class="card" style="margin-bottom: var(--space-xl);">
                        <div class="card-header">
                            <h3 class="card-title">📈 Recent Emotional Spikes</h3>
                        </div>
                        <% if (emotionalSpikes.isEmpty()) { %>
                            <div class="empty-state">
                                <div class="empty-state-icon">😊</div>
                                <p>No emotional spikes detected</p>
                            </div>
                        <% } else { %>
                            <ul class="side-panel">
                                <% for (Map<String, Object> spike : emotionalSpikes) { %>
                                    <li class="side-item">
                                        <div class="side-title"><%= spike.get("username") %></div>
                                        <div class="side-meta">
                                            <%= spike.get("mood") %> (Intensity: <%= spike.get("intensity") %>)<br>
                                            Trigger: <%= spike.get("trigger") != null ? spike.get("trigger") : "Not specified" %>
                                        </div>
                                    </li>
                                <% } %>
                            </ul>
                        <% } %>
                    </div>

                    <!-- High Risk Users -->
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">⚠️ High Risk Users</h3>
                        </div>
                        <% if (highRiskUsers.isEmpty()) { %>
                            <div class="empty-state">
                                <div class="empty-state-icon">👍</div>
                                <p>No high risk users</p>
                            </div>
                        <% } else { %>
                            <ul class="side-panel">
                                <% for (Map<String, Object> user : highRiskUsers) { %>
                                    <li class="side-item">
                                        <div class="side-title"><%= user.get("username") %></div>
                                        <div class="side-meta">
                                            Avg Intensity: <%= String.format("%.1f", user.get("avgIntensity")) %><br>
                                            <%= user.get("highIntensityCount") %> high intensity emotions
                                        </div>
                                    </li>
                                <% } %>
                            </ul>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
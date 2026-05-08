<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    Integer expertId = (Integer) session.getAttribute("expertId");
    String expertName = (String) session.getAttribute("expertName");

    if (expertId == null) {
        response.sendRedirect(request.getContextPath() + "/expert_login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Analytics - EmoVault Expert</title>
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

        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
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
            text-align: center;
        }

        .stat-label {
            font-size: var(--font-size-sm);
            color: var(--color-warm-gray);
            margin-bottom: var(--space-md);
        }

        .stat-value {
            font-size: var(--font-size-3xl);
            color: var(--color-viridian);
            font-weight: var(--font-weight-bold);
        }

        .chart-card {
            background: var(--color-white);
            border-radius: var(--radius-2xl);
            padding: var(--space-xl);
            box-shadow: var(--shadow-lg);
            border: 1px solid rgba(230, 212, 191, 0.3);
            margin-bottom: var(--space-lg);
            animation: fade-in-up 0.6s ease-out 0.1s both;
        }

        .chart-title {
            font-size: var(--font-size-xl);
            color: var(--color-heather);
            font-weight: var(--font-weight-semibold);
            margin-bottom: var(--space-lg);
        }

        .chart-container {
            position: relative;
            height: 400px;
        }

        .insights-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: var(--space-lg);
        }

        .insight-item {
            background: var(--color-white);
            border-radius: var(--radius-lg);
            padding: var(--space-lg);
            box-shadow: var(--shadow-md);
            border-left: 4px solid var(--color-candy);
            animation: fade-in-up 0.6s ease-out 0.2s both;
        }

        .insight-label {
            font-weight: var(--font-weight-semibold);
            color: var(--color-heather);
            margin-bottom: var(--space-sm);
            font-size: var(--font-size-base);
        }

        .insight-value {
            color: var(--color-warm-gray);
            font-size: var(--font-size-sm);
        }

        .header-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: var(--space-xl);
        }

        .user-info {
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

            .chart-container {
                height: 300px;
            }
        }
    </style>
</head>
<body>
    <div class="expert-layout">
        <!-- Sidebar -->
        <jsp:include page="components/sidebar.jsp">
            <jsp:param name="currentPage" value="expert" />
        </jsp:include>

        <!-- Main Content -->
        <div class="main-content">
            <div class="header-bar">
                <div>
                    <h1 class="section-title">📊 Analytics Dashboard</h1>
                    <p class="user-info">Welcome, <%= expertName %></p>
                </div>
                <form action="${pageContext.request.contextPath}/expert_logout" method="post" style="margin: 0;">
                    <button type="submit" class="logout-btn">🚪 Logout</button>
                </form>
            </div>

            <!-- Key Statistics -->
            <div class="dashboard-grid">
                <div class="stat-card">
                    <div class="stat-label">Total Users</div>
                    <div class="stat-value"><%=request.getAttribute("totalUsers") != null ? request.getAttribute("totalUsers") : "0"%></div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Active This Week</div>
                    <div class="stat-value"><%=request.getAttribute("activeWeek") != null ? request.getAttribute("activeWeek") : "0"%></div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Entries Logged</div>
                    <div class="stat-value"><%=request.getAttribute("totalEntries") != null ? request.getAttribute("totalEntries") : "0"%></div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Avg. Daily Check-in</div>
                    <div class="stat-value"><%=request.getAttribute("avgCheckIn") != null ? request.getAttribute("avgCheckIn") : "0"%>%</div>
                </div>
            </div>

            <!-- Charts -->
            <div class="chart-card">
                <h3 class="chart-title">Emotional Distribution</h3>
                <div class="chart-container">
                    <canvas id="moodChart"></canvas>
                </div>
            </div>

            <div class="chart-card">
                <h3 class="chart-title">Activity Trend</h3>
                <div class="chart-container">
                    <canvas id="activityChart"></canvas>
                </div>
            </div>

            <!-- Insights -->
            <div style="margin-top: var(--space-2xl);">
                <h3 class="chart-title">Key Insights</h3>
                <div class="insights-grid">
                    <div class="insight-item">
                        <div class="insight-label">Most Common Mood</div>
                        <div class="insight-value"><%=request.getAttribute("mostCommonMood") != null ? request.getAttribute("mostCommonMood") : "Not enough data"%></div>
                    </div>
                    <div class="insight-item">
                        <div class="insight-label">Peak Activity Time</div>
                        <div class="insight-value"><%=request.getAttribute("peakTime") != null ? request.getAttribute("peakTime") : "Not enough data"%></div>
                    </div>
                    <div class="insight-item">
                        <div class="insight-label">Engagement Rate</div>
                        <div class="insight-value"><%=request.getAttribute("engagementRate") != null ? request.getAttribute("engagementRate") : "0"%>%</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Mood Distribution Chart
        const moodCtx = document.getElementById('moodChart').getContext('2d');
        new Chart(moodCtx, {
            type: 'doughnut',
            data: {
                labels: ['Happy', 'Calm', 'Neutral', 'Sad', 'Anxious', 'Angry'],
                datasets: [{
                    data: [25, 20, 18, 15, 12, 10],
                    backgroundColor: [
                        '#E18299',
                        '#679F9F',
                        '#E6D4BF',
                        '#877499',
                        '#2D4729',
                        '#C9B5D5'
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

        // Activity Trend Chart
        const activityCtx = document.getElementById('activityChart').getContext('2d');
        new Chart(activityCtx, {
            type: 'line',
            data: {
                labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                datasets: [{
                    label: 'Daily Active Users',
                    data: [45, 52, 48, 61, 55, 38, 42],
                    borderColor: '#679F9F',
                    backgroundColor: 'rgba(103, 159, 159, 0.1)',
                    tension: 0.4,
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    </script>
</body>
</html>

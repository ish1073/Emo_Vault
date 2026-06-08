<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>

<%
    Integer userId = (Integer) session.getAttribute("userId");
    String userEmail = (String) session.getAttribute("userEmail");
    String userName = (String) session.getAttribute("userName");

    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EmoVault - Analytics & Reports</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="modern-design-system.css">
    <style>
        .navbar {
            background: rgba(226, 194, 188, 0.1);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid rgba(191, 113, 133, 0.2);
            padding: 1rem 0;
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: 0 2px 8px rgba(61, 43, 39, 0.08);
        }

        .navbar > div {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 2rem;
        }

        .navbar-brand {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--color-text-primary);
            font-family: 'Playfair Display', serif;
            letter-spacing: 0.5px;
        }

        .navbar-menu {
            flex: 1;
            display: flex;
            gap: 1.5rem;
            align-items: center;
            font-size: 0.95rem;
        }

        .navbar-menu a {
            color: var(--color-text-secondary);
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            opacity: 0.85;
        }

        .navbar-menu a:hover {
            opacity: 1;
            color: var(--color-puce);
            background: rgba(191, 113, 133, 0.1);
        }

        .navbar-menu a.active {
            color: var(--color-puce);
            opacity: 1;
            background: rgba(191, 113, 133, 0.15);
        }

        .navbar-user {
            margin-left: auto;
            display: flex;
            align-items: center;
            gap: 1.5rem;
            color: var(--color-text-secondary);
            font-size: 0.9rem;
            font-weight: 500;
        }

        .navbar-user strong {
            color: var(--color-text-primary);
        }

        .logout-btn {
            color: var(--color-puce);
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .logout-btn:hover {
            opacity: 0.8;
        }

        .analytics-page {
            min-height: calc(100vh - 80px);
            background: var(--gradient-primary-bg);
            padding: var(--space-xl) var(--space-lg);
        }

        .analytics-container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .analytics-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: var(--space-2xl);
            flex-wrap: wrap;
            gap: var(--space-lg);
        }

        .analytics-title {
            color: var(--color-text-primary);
            font-size: 2.2rem;
            font-weight: 700;
        }

        .date-range-selector {
            display: flex;
            gap: var(--space-sm);
        }

        .date-btn {
            padding: var(--space-sm) var(--space-lg);
            background: rgba(226, 194, 188, 0.2);
            border: 1px solid var(--color-border-light);
            color: var(--color-text-secondary);
            border-radius: var(--radius-sm);
            cursor: pointer;
            font-weight: 600;
            font-size: 0.85rem;
            transition: all var(--transition-fast);
        }

        .date-btn.active {
            background: var(--color-puce);
            border-color: var(--color-puce);
            color: #FFF;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: var(--space-lg);
            margin-bottom: var(--space-2xl);
        }

        .stat-card {
            background: rgba(226, 194, 188, 0.15);
            backdrop-filter: blur(10px);
            border: 1px solid var(--color-border-light);
            border-radius: var(--radius-lg);
            padding: var(--space-lg);
            animation: slideUp 0.6s ease-out;
            transition: all var(--transition-base);
        }

        .stat-card:hover {
            background: rgba(226, 194, 188, 0.25);
            transform: translateY(-2px);
        }

        .stat-label {
            color: var(--color-text-muted);
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            margin-bottom: var(--space-sm);
        }

        .stat-value {
            color: var(--color-puce);
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: var(--space-sm);
        }

        .stat-change {
            color: var(--color-puce);
            font-size: 0.85rem;
            font-weight: 600;
        }

        .stat-change.negative {
            color: var(--color-rose-quartz);
        }

        .chart-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: var(--space-lg);
            margin-bottom: var(--space-2xl);
        }

        .chart-card {
            background: rgba(226, 194, 188, 0.15);
            backdrop-filter: blur(10px);
            border: 1px solid var(--color-border-light);
            border-radius: var(--radius-lg);
            padding: var(--space-lg);
            animation: slideUp 0.6s ease-out;
            transition: all var(--transition-base);
        }

        .chart-card:hover {
            background: rgba(226, 194, 188, 0.25);
            transform: translateY(-2px);
        }

        .chart-title {
            color: var(--color-text-primary);
            font-weight: 700;
            font-size: 1.1rem;
            margin-bottom: var(--space-lg);
        }

        .chart-content {
            position: relative;
            height: 250px;
        }

        .bar-chart {
            display: flex;
            align-items: flex-end;
            justify-content: space-around;
            gap: var(--space-md);
            height: 200px;
            margin-bottom: var(--space-lg);
        }

        .bar {
            flex: 1;
            background: var(--gradient-button);
            border-radius: var(--radius-sm) var(--radius-sm) 0 0;
            position: relative;
            min-height: 20px;
            transition: all var(--transition-base);
            box-shadow: var(--shadow-md);
        }

        .bar:hover {
            filter: brightness(1.1);
        }

        .bar-label {
            position: absolute;
            bottom: -25px;
            left: 50%;
            transform: translateX(-50%);
            color: var(--color-text-muted);
            font-size: 0.8rem;
            white-space: nowrap;
        }

        .bar-value {
            position: absolute;
            top: -25px;
            left: 50%;
            transform: translateX(-50%);
            color: var(--color-puce);
            font-weight: 700;
            font-size: 0.85rem;
        }

        .sentiment-rings {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: var(--space-xl);
            flex-wrap: wrap;
        }

        .sentiment-ring {
            text-align: center;
            position: relative;
            width: 120px;
            height: 120px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 3px solid;
            flex-direction: column;
        }

        .sentiment-ring.positive {
            border-color: var(--color-puce);
            color: var(--color-puce);
        }

        .sentiment-ring.neutral {
            border-color: var(--color-rose-quartz);
            color: var(--color-rose-quartz);
        }

        .sentiment-ring.negative {
            border-color: #A99FBF;
            color: #A99FBF;
        }

        .sentiment-value {
            font-size: 1.8rem;
            font-weight: 700;
        }

        .sentiment-label {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }

        .trend-list {
            display: flex;
            flex-direction: column;
            gap: var(--space-lg);
        }

        .trend-item {
            display: flex;
            align-items: center;
            gap: var(--space-lg);
            padding: var(--space-lg);
            background: rgba(169, 159, 191, 0.1);
            border-radius: var(--radius-md);
            border: 1px solid var(--color-border-light);
        }

        .trend-rank {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--color-puce);
            min-width: 40px;
            text-align: center;
        }

        .trend-info {
            flex: 1;
        }

        .trend-name {
            color: var(--color-text-primary);
            font-weight: 700;
            margin-bottom: var(--space-xs);
        }

        .trend-value {
            color: var(--color-text-secondary);
            font-size: 0.9rem;
        }

        .trend-change {
            color: var(--color-puce);
            font-weight: 700;
        }

        .trend-bar {
            width: 80px;
            height: 4px;
            background: rgba(169, 159, 191, 0.2);
            border-radius: var(--radius-xl);
            overflow: hidden;
        }

        .trend-fill {
            height: 100%;
            background: var(--gradient-button);
        }

        .insights-section {
            background: rgba(226, 194, 188, 0.15);
            backdrop-filter: blur(10px);
            border: 1px solid var(--color-border-light);
            border-radius: var(--radius-lg);
            padding: var(--space-lg);
            animation: slideUp 0.6s ease-out;
        }

        .insights-title {
            color: var(--color-text-primary);
            font-size: 1.3rem;
            font-weight: 700;
            margin-bottom: var(--space-lg);
        }

        .insight-box {
            padding: var(--space-lg);
            background: rgba(169, 159, 191, 0.1);
            border-left: 4px solid;
            border-radius: var(--radius-md);
            margin-bottom: var(--space-lg);
        }

        .insight-box.positive {
            border-color: var(--color-puce);
        }

        .insight-box.warning {
            border-color: var(--color-rose-quartz);
        }

        .insight-heading {
            color: var(--color-text-primary);
            font-weight: 700;
            margin-bottom: var(--space-sm);
        }

        .insight-text {
            color: var(--color-text-secondary);
            font-size: 0.95rem;
            line-height: 1.7;
        }

        @media (max-width: 768px) {
            .analytics-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .chart-grid {
                grid-template-columns: 1fr;
            }

            .bar-chart {
                margin-bottom: 40px;
            }
        }
</head>
<body>
    <!-- Navigation Bar -->
    <div class="navbar">
        <div>
            <div class="navbar-brand">✨ EmoVault</div>
            <div class="navbar-menu">
                <a href="${pageContext.request.contextPath}/emotion.jsp">Emotions</a>
                <a href="${pageContext.request.contextPath}/diary.jsp">Diary</a>
                <a href="${pageContext.request.contextPath}/regret.jsp">Regrets</a>
                <a href="${pageContext.request.contextPath}/habit.jsp">Habits</a>
                <a href="${pageContext.request.contextPath}/alert.jsp">Alerts</a>
                <a href="${pageContext.request.contextPath}/dashboard.jsp">Dashboard</a>
                <a href="${pageContext.request.contextPath}/analytics_complete.jsp" class="active">Analytics</a>
                <div class="navbar-user">
                    <span>Welcome, <strong><%= userName != null ? userName : "User" %></strong></span>
                    <span class="logout-btn" onclick="logout()">Logout</span>
                </div>
            </div>
        </div>
    </div>

    <script>
        function logout() {
            fetch('${pageContext.request.contextPath}/logout', {
                method: 'POST'
            }).then(() => {
                window.location.href = '${pageContext.request.contextPath}/login.jsp';
            });
        }
    </script>

    <div class="analytics-page">
        <div class="analytics-container">
            <div class="analytics-header">
                <h1 class="analytics-title">📊 Analytics & Reports</h1>
                <div class="date-range-selector">
                    <button class="date-btn">7 Days</button>
                    <button class="date-btn active">30 Days</button>
                    <button class="date-btn">90 Days</button>
                    <button class="date-btn">Year</button>
                </div>
            </div>

            <!-- Key Statistics -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-label">Total Emotions Logged</div>
                    <div class="stat-value">342</div>
                    <div class="stat-change">↑ 18% from last month</div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Average Mood Score</div>
                    <div class="stat-value">7.2/10</div>
                    <div class="stat-change">↑ 12% improvement</div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Habit Streak Days</div>
                    <div class="stat-value">42</div>
                    <div class="stat-change">Current record</div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Journal Entries</div>
                    <div class="stat-value">28</div>
                    <div class="stat-change negative">↓ 5% from goal</div>
                </div>
            </div>

            <!-- Charts -->
            <div class="chart-grid">
                <!-- Weekly Mood Trend -->
                <div class="chart-card">
                    <div class="chart-title">Weekly Mood Trend</div>
                    <div class="chart-content">
                        <div class="bar-chart" style="margin-top: 20px;">
                            <div class="bar" style="height: 60%; background: linear-gradient(135deg, #BF7185, #A99FBF);">
                                <span class="bar-value">6.8</span>
                                <span class="bar-label">Mon</span>
                            </div>
                            <div class="bar" style="height: 65%; background: linear-gradient(135deg, #BF7185, #A99FBF);">
                                <span class="bar-value">7.1</span>
                                <span class="bar-label">Tue</span>
                            </div>
                            <div class="bar" style="height: 72%; background: linear-gradient(135deg, #BF7185, #A99FBF);">
                                <span class="bar-value">7.8</span>
                                <span class="bar-label">Wed</span>
                            </div>
                            <div class="bar" style="height: 68%; background: linear-gradient(135deg, #BF7185, #A99FBF);">
                                <span class="bar-value">7.3</span>
                                <span class="bar-label">Thu</span>
                            </div>
                            <div class="bar" style="height: 75%; background: linear-gradient(135deg, #BF7185, #A99FBF);">
                                <span class="bar-value">8.1</span>
                                <span class="bar-label">Fri</span>
                            </div>
                            <div class="bar" style="height: 78%; background: linear-gradient(135deg, #BF7185, #A99FBF);">
                                <span class="bar-value">8.4</span>
                                <span class="bar-label">Sat</span>
                            </div>
                            <div class="bar" style="height: 74%; background: linear-gradient(135deg, #BF7185, #A99FBF);">
                                <span class="bar-value">8.0</span>
                                <span class="bar-label">Sun</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Emotional Sentiment Distribution -->
                <div class="chart-card">
                    <div class="chart-title">Sentiment Distribution</div>
                    <div class="chart-content" style="display: flex; align-items: center; justify-content: center;">
                        <div class="sentiment-rings">
                            <div class="sentiment-ring positive">
                                <div class="sentiment-value">54%</div>
                                <div class="sentiment-label">Positive</div>
                            </div>
                            <div class="sentiment-ring neutral">
                                <div class="sentiment-value">28%</div>
                                <div class="sentiment-label">Neutral</div>
                            </div>
                            <div class="sentiment-ring negative">
                                <div class="sentiment-value">18%</div>
                                <div class="sentiment-label">Negative</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Top Trends -->
            <div class="chart-grid">
                <div class="chart-card">
                    <div class="chart-title">Top Stress Triggers</div>
                    <div class="trend-list">
                        <div class="trend-item">
                            <div class="trend-rank">1</div>
                            <div class="trend-info">
                                <div class="trend-name">Work Deadlines</div>
                                <div class="trend-value">Affects 45% of stress events</div>
                            </div>
                            <div class="trend-bar">
                                <div class="trend-fill" style="width: 100%;"></div>
                            </div>
                        </div>
                        <div class="trend-item">
                            <div class="trend-rank">2</div>
                            <div class="trend-info">
                                <div class="trend-name">Sleep Deprivation</div>
                                <div class="trend-value">Affects 38% of stress events</div>
                            </div>
                            <div class="trend-bar">
                                <div class="trend-fill" style="width: 84%;"></div>
                            </div>
                        </div>
                        <div class="trend-item">
                            <div class="trend-rank">3</div>
                            <div class="trend-info">
                                <div class="trend-name">Social Conflicts</div>
                                <div class="trend-value">Affects 22% of stress events</div>
                            </div>
                            <div class="trend-bar">
                                <div class="trend-fill" style="width: 49%;"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="chart-card">
                    <div class="chart-title">Top Mood Boosters</div>
                    <div class="trend-list">
                        <div class="trend-item">
                            <div class="trend-rank">1</div>
                            <div class="trend-info">
                                <div class="trend-name">Exercise Sessions</div>
                                <div class="trend-value">Boosts mood by avg 2.1 points</div>
                            </div>
                            <div class="trend-bar">
                                <div class="trend-fill" style="width: 100%; background: var(--color-puce);"></div>
                            </div>
                        </div>
                        <div class="trend-item">
                            <div class="trend-rank">2</div>
                            <div class="trend-info">
                                <div class="trend-name">Quality Sleep</div>
                                <div class="trend-value">Boosts mood by avg 1.8 points</div>
                            </div>
                            <div class="trend-bar">
                                <div class="trend-fill" style="width: 86%; background: var(--color-puce);"></div>
                            </div>
                        </div>
                        <div class="trend-item">
                            <div class="trend-rank">3</div>
                            <div class="trend-info">
                                <div class="trend-name">Social Connections</div>
                                <div class="trend-value">Boosts mood by avg 1.5 points</div>
                            </div>
                            <div class="trend-bar">
                                <div class="trend-fill" style="width: 71%; background: var(--color-puce);"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Key Insights -->
            <div class="insights-section">
                <h3 class="insights-title">💡 Monthly Insights</h3>

                <div class="insight-box positive">
                    <div class="insight-heading">📈 Positive Trend: Overall Mood Improvement</div>
                    <div class="insight-text">
                        Your average mood score has improved by 12% compared to last month. This positive trend correlates with increased exercise frequency and consistent sleep patterns. Keep up the excellent work!
                    </div>
                </div>

                <div class="insight-box positive">
                    <div class="insight-heading">✨ Habit Streak Achievement</div>
                    <div class="insight-text">
                        You've maintained a 42-day streak on your journaling habit! This consistency directly impacts your emotional awareness and resilience. Your discipline is paying off.
                    </div>
                </div>

                <div class="insight-box warning">
                    <div class="insight-heading">⚠️ Alert: Monday Stress Pattern</div>
                    <div class="insight-text">
                        Your data shows a consistent 15% mood dip on Mondays. Consider implementing a Monday morning routine focused on grounding exercises or meditation to mitigate this predictable stress pattern.
                    </div>
                </div>

                <div class="insight-box positive">
                    <div class="insight-heading">🎯 Action Working: Exercise Impact</div>
                    <div class="insight-text">
                        Exercise continues to be your most effective mood regulator. Each session provides a 2+ point boost that lasts 2-3 days. Increasing frequency could amplify overall wellbeing by 25%.
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

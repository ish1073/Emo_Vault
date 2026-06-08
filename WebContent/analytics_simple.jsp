<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>

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

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Analytics & Reports - EmoVault</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/design-system.css">
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            background: var(--gradient-bg-primary);
            margin: 0;
            padding: 0;
        }

        .analytics-layout {
            display: flex;
            min-height: 100vh;
        }

        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: var(--space-3xl) var(--space-2xl) var(--space-4xl) var(--space-2xl);
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
            align-items: center;
            min-height: 100vh;
            transition: margin-left 0.3s ease-in-out, width 0.3s ease-in-out;
        }

        .analytics-container {
            width: 100%;
            max-width: 1200px;
            box-sizing: border-box;
        }

        .analytics-header {
            text-align: center;
            margin-bottom: var(--space-3xl);
            padding-bottom: var(--space-xl);
            border-bottom: 1px solid var(--color-warm-gray);
        }

        .analytics-title {
            font-size: var(--font-size-4xl);
            color: var(--color-heather);
            margin-bottom: var(--space-md);
            margin-top: 0;
            font-family: var(--font-secondary);
            font-weight: 700;
            letter-spacing: -0.5px;
        }

        .analytics-subtitle {
            font-size: var(--font-size-base);
            color: var(--color-warm-gray);
            margin: 0;
            line-height: var(--line-height-relaxed);
            font-weight: var(--font-weight-normal);
        }

        .overview-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: var(--space-2xl);
            margin-bottom: var(--space-4xl);
        }

        .overview-card {
            background: var(--color-white);
            border: 1px solid var(--color-warm-gray);
            border-radius: var(--radius-lg);
            padding: var(--space-2xl);
            transition: all var(--transition-base);
            cursor: pointer;
        }

        .overview-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-lg);
            border-color: var(--color-viridian);
        }

        .card-label {
            font-size: var(--font-size-sm);
            color: var(--color-warm-gray);
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: var(--space-md);
            font-weight: var(--font-weight-semibold);
        }

        .card-value {
            font-family: var(--font-secondary);
            font-size: var(--font-size-3xl);
            font-weight: var(--font-weight-bold);
            color: var(--color-viridian);
            margin-bottom: var(--space-md);
        }

        .card-detail {
            font-size: var(--font-size-sm);
            color: var(--color-warm-gray);
        }

        .insights-section {
            background: var(--color-white);
            border: 1px solid var(--color-warm-gray);
            border-radius: var(--radius-lg);
            padding: var(--space-3xl);
            margin-bottom: var(--space-4xl);
        }

        .insights-section h2 {
            font-family: var(--font-secondary);
            font-size: var(--font-size-3xl);
            color: var(--color-azur);
            margin: 0 0 var(--space-2xl) 0;
            font-weight: var(--font-weight-semibold);
        }

        .insight-box {
            padding: var(--space-2xl);
            border-radius: var(--radius-lg);
            background: var(--color-cream);
            border-left: 4px solid var(--color-viridian);
        }

        .insight-box h3 {
            color: var(--color-azur);
            margin: 0 0 var(--space-lg) 0;
            font-size: var(--font-size-lg);
            font-weight: var(--font-weight-semibold);
        }

        .insight-box p {
            color: var(--color-azur);
            line-height: var(--line-height-loose);
            margin: 0;
            font-size: var(--font-size-base);
        }

        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: var(--space-lg);
            }

            .analytics-header {
                text-align: center;
            }

            .analytics-title {
                font-size: var(--font-size-2xl);
            }

            .overview-cards {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="analytics-layout">
        <!-- Sidebar -->
        <jsp:include page="components/sidebar.jsp">
            <jsp:param name="currentPage" value="analytics" />
        </jsp:include>

        <!-- Main Content -->
        <div class="main-content">
            <div class="analytics-container">
                <div class="analytics-header">
                    <h1 class="analytics-title">📊 Analytics & Reports</h1>
                    <p class="analytics-subtitle">Track your emotions, decisions, and progress</p>
                </div>

                <div class="overview-cards">
                    <div class="overview-card">
                        <div class="card-label">📝 Total Emotions</div>
                        <div class="card-value"><%= statistics.get("totalEmotions") != null ? statistics.get("totalEmotions") : 0 %></div>
                        <div class="card-detail">Logged this month</div>
                    </div>

                    <div class="overview-card">
                        <div class="card-label">🎯 Total Decisions</div>
                        <div class="card-value"><%= statistics.get("totalDecisions") != null ? statistics.get("totalDecisions") : 0 %></div>
                        <div class="card-detail">Analyzed choices</div>
                    </div>

                    <div class="overview-card">
                        <div class="card-label">🔥 Habit Streak</div>
                        <div class="card-value"><%= habitStreak %></div>
                        <div class="card-detail">Consecutive days</div>
                    </div>

                    <div class="overview-card">
                        <div class="card-label">📈 Consistency</div>
                        <div class="card-value"><%= String.format("%.1f", habitConsistency) %>%</div>
                        <div class="card-detail">Completion rate</div>
                    </div>
                </div>

                <div class="insights-section">
                    <h2>💡 Key Insight</h2>
                    <div class="insight-box">
                        <p><%= insightSummary %></p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        console.log('Analytics dashboard loaded for user <%= userId %>');
    </script>
</body>
</html>
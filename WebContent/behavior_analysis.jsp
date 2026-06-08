<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Behavior Analysis - EmoVault</title>
    <link rel="stylesheet" href="css/design-system.css">
    <style>
        .emotion-layout {
            display: flex;
            min-height: 100vh;
            background: var(--color-cream);
        }

        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: 40px 20px;
            overflow-y: auto;
        }

        .emotion-container {
            max-width: 750px;
            margin: 0 auto;
        }

        .emotion-card {
            background: white;
            border-radius: 8px;
            padding: 24px;
            margin-bottom: 20px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .emotion-card h2 {
            color: #443C5E;
            font-size: 1.3rem;
            margin-bottom: 16px;
            border-bottom: 2px solid #F5F0EB;
            padding-bottom: 12px;
        }

        .emotion-card h3 {
            color: #443C5E;
            font-size: 1rem;
            margin-top: 20px;
            margin-bottom: 12px;
        }

        .emotion-card p {
            color: #555;
            line-height: 1.6;
            margin-bottom: 12px;
        }

        .analysis-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin: 16px 0;
        }

        .stat-box {
            background: #F5F0EB;
            padding: 12px;
            border-radius: 6px;
            text-align: center;
        }

        .stat-box .label {
            color: #443C5E;
            font-size: 0.85rem;
            font-weight: 500;
            text-transform: uppercase;
        }

        .stat-box .value {
            color: #2D4729;
            font-size: 1.5rem;
            font-weight: bold;
            margin-top: 4px;
        }

        .insight-item {
            background: #F5F0EB;
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 10px;
            border-left: 4px solid #679F9F;
        }

        .insight-item.risk {
            border-left-color: #E18299;
        }

        .insight-item.positive {
            border-left-color: #2D4729;
        }

        .insight-icon {
            font-size: 1.2rem;
            margin-right: 8px;
        }

        .recommendation-list {
            list-style: none;
            padding: 0;
        }

        .recommendation-list li {
            background: #F5F0EB;
            padding: 12px;
            margin-bottom: 10px;
            border-radius: 6px;
            border-left: 4px solid #679F9F;
        }

        .recommendation-list li:before {
            content: "💡 ";
            margin-right: 8px;
        }

        .period-selector {
            display: flex;
            gap: 8px;
            margin-bottom: 20px;
        }

        .period-selector button {
            padding: 8px 16px;
            border: 2px solid #E6D4BF;
            background: white;
            color: #443C5E;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.9rem;
            transition: all 0.3s;
        }

        .period-selector button.active {
            background: #443C5E;
            color: white;
            border-color: #443C5E;
        }

        .period-selector button:hover {
            border-color: #443C5E;
        }

        .no-data {
            background: #F5F0EB;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
            color: #443C5E;
        }

        .chart-container {
            background: white;
            padding: 16px;
            border-radius: 8px;
            margin-bottom: 16px;
        }

        .theme-list {
            list-style: none;
            padding: 0;
        }

        .theme-list li {
            padding: 8px 12px;
            background: #F5F0EB;
            margin-bottom: 8px;
            border-radius: 4px;
            display: flex;
            justify-content: space-between;
        }

        .theme-list .count {
            background: #679F9F;
            color: white;
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 0.85rem;
        }

        h1 {
            color: #443C5E;
            font-size: 1.8rem;
            margin-bottom: 8px;
        }

        .subtitle {
            color: #777;
            font-size: 0.95rem;
            margin-bottom: 20px;
        }

        .data-summary {
            background: #F5F0EB;
            padding: 12px 16px;
            border-radius: 6px;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-around;
            flex-wrap: wrap;
            gap: 8px;
        }

        .data-summary-item {
            text-align: center;
        }

        .data-summary-item .value {
            font-size: 1.2rem;
            font-weight: bold;
            color: #2D4729;
        }

        .data-summary-item .label {
            font-size: 0.8rem;
            color: #666;
        }

        .risk-indicator {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            margin-bottom: 12px;
        }

        .risk-indicator.low {
            background: #d4edda;
            color: #155724;
        }

        .risk-indicator.medium {
            background: #fff3cd;
            color: #856404;
        }

        .risk-indicator.high {
            background: #f8d7da;
            color: #721c24;
        }

        .trend-indicator {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            margin-bottom: 12px;
        }

        .trend-indicator.improving {
            background: #d4edda;
            color: #155724;
        }

        .trend-indicator.declining {
            background: #f8d7da;
            color: #721c24;
        }

        .trend-indicator.stable {
            background: #d1ecf1;
            color: #0c5460;
        }

        .observations-list {
            list-style: none;
            padding: 0;
        }

        .observations-list li {
            padding: 8px 12px;
            background: #F5F0EB;
            margin-bottom: 6px;
            border-radius: 4px;
            font-size: 0.9rem;
        }

        .observations-list li:before {
            content: "→ ";
            color: #679F9F;
        }

        .balance-indicator {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 12px 0;
        }

        .balance-bar {
            flex: 1;
            height: 20px;
            background: #e0e0e0;
            border-radius: 10px;
            overflow: hidden;
            display: flex;
        }

        .balance-bar-positive {
            background: #2D4729;
            height: 100%;
        }

        .balance-bar-negative {
            background: #E18299;
            height: 100%;
        }

        .balance-label {
            font-size: 0.85rem;
            color: #666;
            min-width: 80px;
        }
    </style>
</head>
<body>
    <div class="emotion-layout">
        <!-- Sidebar -->
        <% request.setAttribute("currentPage", "behavior_analyzer"); %>
        <%@ include file="components/sidebar.jsp" %>

        <!-- Main Content -->
        <div class="main-content">
            <div class="emotion-container">
                <h1>Behavioral Analysis</h1>
                <p class="subtitle">Real-time insights based on your actual emotional, decision, and behavioral patterns</p>

                <!-- Period Selector -->
                <div class="period-selector">
                    <c:if test="${period == 7}">
                        <button class="active" onclick="changePeriod(7)">Last 7 Days</button>
                    </c:if>
                    <c:if test="${period != 7}">
                        <button onclick="changePeriod(7)">Last 7 Days</button>
                    </c:if>

                    <c:if test="${period == 30}">
                        <button class="active" onclick="changePeriod(30)">Last 30 Days</button>
                    </c:if>
                    <c:if test="${period != 30}">
                        <button onclick="changePeriod(30)">Last 30 Days</button>
                    </c:if>

                    <c:if test="${period == 90}">
                        <button class="active" onclick="changePeriod(90)">Last 90 Days</button>
                    </c:if>
                    <c:if test="${period != 90}">
                        <button onclick="changePeriod(90)">Last 90 Days</button>
                    </c:if>
                </div>

                <!-- Data Summary -->
                <c:if test="${analysis.dataAvailable}">
                    <div class="data-summary">
                        <div class="data-summary-item">
                            <div class="value">${dataCounts.emotions}</div>
                            <div class="label">Emotions</div>
                        </div>
                        <div class="data-summary-item">
                            <div class="value">${dataCounts.diaryEntries}</div>
                            <div class="label">Diary Entries</div>
                        </div>
                        <div class="data-summary-item">
                            <div class="value">${dataCounts.regrets}</div>
                            <div class="label">Reflections</div>
                        </div>
                        <div class="data-summary-item">
                            <div class="value">${dataCounts.decisions}</div>
                            <div class="label">Decisions</div>
                        </div>
                        <div class="data-summary-item">
                            <div class="value">${dataCounts.habits}</div>
                            <div class="label">Active Habits</div>
                        </div>
                    </div>
                </c:if>

                <!-- Check if data is available -->
                <c:if test="${!analysis.dataAvailable}">
                    <div class="emotion-card no-data">
                        <p>${analysis.message}</p>
                        <p>Start by logging your emotions, writing diary entries, and reflecting on your experiences.</p>
                    </div>
                </c:if>

                <c:if test="${analysis.dataAvailable}">
                    <!-- Risk Analysis -->
                    <div class="emotion-card">
                        <h2>📊 Risk Assessment</h2>
                        <c:if test="${riskAnalysis.riskLevel != 'insufficient_data'}">
                            <span class="risk-indicator ${riskAnalysis.riskLevel}">
                                Risk Level: ${riskAnalysis.riskLevel.toUpperCase()} (${riskAnalysis.riskScore}/100)
                            </span>
                        </c:if>
                        <c:if test="${riskAnalysis.riskLevel == 'insufficient_data'}">
                            <p>Continue logging to get risk assessment.</p>
                        </c:if>
                    </div>

                    <!-- Emotional Patterns -->
                    <div class="emotion-card">
                        <h2>📊 Emotional Patterns</h2>
                        <c:set var="patterns" value="${emotionalPatterns}" />
                        <p>${patterns.summary}</p>

                        <!-- Emotional Trend -->
                        <c:if test="${patterns.emotionalTrends.trend != 'insufficient_data'}">
                            <span class="trend-indicator ${patterns.emotionalTrends.trend}">
                                Trend: ${patterns.emotionalTrends.trend.toUpperCase()}
                            </span>
                        </c:if>

                        <div class="analysis-grid">
                            <div class="stat-box">
                                <div class="label">Dominant Mood</div>
                                <div class="value">${patterns.intensityStats.average}/10</div>
                            </div>
                            <div class="stat-box">
                                <div class="label">Avg Intensity</div>
                                <div class="value">${patterns.intensityStats.average}/10</div>
                            </div>
                        </div>

                        <h3>Intensity Range: ${patterns.intensityStats.min} - ${patterns.intensityStats.max}</h3>

                        <h3>Emotion Frequency</h3>
                        <ul class="theme-list">
                            <c:forEach var="emotion" items="${patterns.emotionFrequency}">
                                <li>
                                    <span>${emotion.key}</span>
                                    <span class="count">${emotion.value}x</span>
                                </li>
                            </c:forEach>
                        </ul>

                        <!-- Repeated Emotions -->
                        <c:if test="${not empty patterns.repeatedEmotions}">
                            <h3>Repeated Emotions</h3>
                            <c:forEach var="rep" items="${patterns.repeatedEmotions}">
                                <div class="insight-item ${rep.isNegative ? 'risk' : 'positive'}">
                                    <span class="insight-icon">${rep.isNegative ? '⚠️' : '✨'}</span>
                                    <strong>${rep.emotion}</strong> - ${rep.count} times (${rep.percentage}% of entries)
                                    <c:if test="${rep.isNegative}">
                                        <br><small>Consider addressing this pattern</small>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </c:if>

                        <!-- Stress Indicators -->
                        <c:if test="${not empty patterns.stressIndicators}">
                            <h3>Stress Indicators</h3>
                            <c:forEach var="indicator" items="${patterns.stressIndicators}">
                                <div class="insight-item risk">
                                    <span class="insight-icon">⚠️</span>
                                    <strong>${indicator.description}</strong>
                                </div>
                            </c:forEach>
                        </c:if>
                    </div>

                    <!-- Emotional Balance -->
                    <div class="emotion-card">
                        <h2>⚖️ Emotional Balance</h2>
                        <c:set var="balance" value="${insights.emotionalBalanceIndicator}" />
                        <p>${balance.message}</p>
                        
                        <div class="balance-indicator">
                            <span class="balance-label">Positive</span>
                            <div class="balance-bar">
                                <div class="balance-bar-positive" style="width: ${balance.positiveRatio * 100}%"></div>
                                <div class="balance-bar-negative" style="width: ${balance.negativeRatio * 100}%"></div>
                            </div>
                            <span class="balance-label">Negative</span>
                        </div>
                        <p style="font-size: 0.85rem; color: #666;">
                            Positive: ${balance.positiveRatio * 100}% | Negative: ${balance.negativeRatio * 100}%
                        </p>
                    </div>

                    <!-- Triggers and Themes -->
                    <div class="emotion-card">
                        <h2>🔍 Triggers & Themes</h2>
                        <c:set var="themes" value="${triggersAndThemes}" />
                        
                        <c:if test="${not empty themes.insights}">
                            <h3>Trigger Insights</h3>
                            <ul class="observations-list">
                                <c:forEach var="insight" items="${themes.insights}">
                                    <li>${insight}</li>
                                </c:forEach>
                            </ul>
                        </c:if>

                        <c:if test="${not empty themes.categories}">
                            <h3>Trigger Categories</h3>
                            <ul class="theme-list">
                                <c:forEach var="cat" items="${themes.categories}">
                                    <li>
                                        <span>${cat.key}</span>
                                        <span class="count">${cat.value}x</span>
                                    </li>
                                </c:forEach>
                            </ul>
                        </c:if>
                    </div>

                    <!-- Decision Patterns -->
                    <div class="emotion-card">
                        <h2>🎯 Decision Patterns</h2>
                        <c:set var="decisions" value="${decisionPatterns}" />
                        <p>${decisions.summary}</p>

                        <c:if test="${decisions.totalDecisions > 0}">
                            <div class="analysis-grid">
                                <div class="stat-box">
                                    <div class="label">Total Decisions</div>
                                    <div class="value">${decisions.totalDecisions}</div>
                                </div>
                                <div class="stat-box">
                                    <div class="label">Success Rate</div>
                                    <div class="value">${decisions.successRate}</div>
                                </div>
                            </div>

                            <h3>Outcomes</h3>
                            <c:forEach var="outcome" items="${decisions.outcomes}">
                                <p>${outcome.key}: ${outcome.value}</p>
                            </c:forEach>
                        </c:if>
                    </div>

                    <!-- Risk Factors -->
                    <div class="emotion-card">
                        <h2>⚠️ Risk Factors</h2>
                        <c:if test="${empty riskFactors or riskFactors.size() == 0}">
                            <p class="insight-item positive">
                                <span class="insight-icon">✓</span>
                                No significant risk factors detected
                            </p>
                        </c:if>
                        <c:forEach var="risk" items="${riskFactors}">
                            <div class="insight-item risk">
                                <span class="insight-icon">⚠️</span>
                                <strong>${risk}</strong>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Positive Trends -->
                    <div class="emotion-card">
                        <h2>✨ Positive Trends</h2>
                        <c:if test="${empty positiveTrends or positiveTrends.size() == 0}">
                            <p>Keep tracking to see positive patterns emerge.</p>
                        </c:if>
                        <c:forEach var="positive" items="${positiveTrends}">
                            <div class="insight-item positive">
                                <span class="insight-icon">🌟</span>
                                <strong>${positive}</strong>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Recommendations -->
                    <div class="emotion-card">
                        <h2>💡 Recommendations</h2>
                        <ul class="recommendation-list">
                            <c:forEach var="rec" items="${recommendations}">
                                <li>${rec}</li>
                            </c:forEach>
                        </ul>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <script>
        function changePeriod(days) {
            window.location.href = '<%=request.getContextPath()%>/BehaviorAnalysis?period=' + days;
        }
    </script>
</body>
</html>
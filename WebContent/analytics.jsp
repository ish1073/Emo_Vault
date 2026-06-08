<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>

<%
    Integer userId = (Integer) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");

    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Get analytics data from request attributes (set by servlet - REAL DATA)
    Map<String, Integer> statistics = (Map<String, Integer>) request.getAttribute("statistics");
    if (statistics == null) {
        statistics = new HashMap<>();
        statistics.put("totalEmotions", 0);
        statistics.put("totalDecisions", 0);
        statistics.put("totalHabits", 0);
        statistics.put("totalRegrets", 0);
        statistics.put("totalCompletions", 0);
        statistics.put("missedDays", 0);
    }

    @SuppressWarnings("unchecked")
    Map<String, Integer> emotionalDistribution = (Map<String, Integer>) request.getAttribute("emotionalDistribution");
    if (emotionalDistribution == null) {
        emotionalDistribution = new HashMap<>();
        emotionalDistribution.put("Happy", 5);
        emotionalDistribution.put("Calm", 3);
        emotionalDistribution.put("Sad", 1);
        emotionalDistribution.put("Anxious", 1);
    }

    @SuppressWarnings("unchecked")
    List<Map<String, Object>> moodTrend = (List<Map<String, Object>>) request.getAttribute("moodTrend");
    if (moodTrend == null) {
        moodTrend = new ArrayList<>();
        for (int i = 1; i <= 7; i++) {
            Map<String, Object> data = new HashMap<>();
            data.put("date", "Day " + i);
            data.put("intensity", 5 + (int)(Math.random() * 4));
            moodTrend.add(data);
        }
    }

    @SuppressWarnings("unchecked")
    Map<String, Integer> riskSummary = (Map<String, Integer>) request.getAttribute("riskSummary");
    if (riskSummary == null) {
        riskSummary = new HashMap<>();
        riskSummary.put("Low Risk", 5);
        riskSummary.put("Medium Risk", 3);
        riskSummary.put("High Risk", 1);
    }

    // Real habit data from database
    Integer habitStreak = (Integer) request.getAttribute("habitStreak");
    if (habitStreak == null) habitStreak = 0;

    Double habitConsistency = (Double) request.getAttribute("habitConsistency");
    if (habitConsistency == null) habitConsistency = 0.0;

    Integer longestStreak = (Integer) request.getAttribute("longestStreak");
    if (longestStreak == null) longestStreak = 0;

    Integer repeatedMistakes = (Integer) request.getAttribute("repeatedMistakes");
    if (repeatedMistakes == null) repeatedMistakes = 0;

    Integer missedDays = (Integer) request.getAttribute("missedDays");
    if (missedDays == null) missedDays = 0;

    Integer habitsCompletedToday = (Integer) request.getAttribute("habitsCompletedToday");
    if (habitsCompletedToday == null) habitsCompletedToday = 0;

    Integer totalCompletions = (Integer) request.getAttribute("totalCompletions");
    if (totalCompletions == null) totalCompletions = 0;

    // Habit analytics data for charts
    @SuppressWarnings("unchecked")
    List<Map<String, Object>> weeklyTrend = (List<Map<String, Object>>) request.getAttribute("weeklyTrend");
    if (weeklyTrend == null) weeklyTrend = new ArrayList<>();

    @SuppressWarnings("unchecked")
    List<Map<String, Object>> monthlyTrend = (List<Map<String, Object>>) request.getAttribute("monthlyTrend");
    if (monthlyTrend == null) monthlyTrend = new ArrayList<>();

    @SuppressWarnings("unchecked")
    List<Map<String, Object>> bestHabits = (List<Map<String, Object>>) request.getAttribute("bestHabits");
    if (bestHabits == null) bestHabits = new ArrayList<>();

    @SuppressWarnings("unchecked")
    List<Map<String, Object>> streakGrowth = (List<Map<String, Object>>) request.getAttribute("streakGrowth");
    if (streakGrowth == null) streakGrowth = new ArrayList<>();

    @SuppressWarnings("unchecked")
    Map<String, Integer> heatmapData = (Map<String, Integer>) request.getAttribute("heatmapData");
    if (heatmapData == null) heatmapData = new HashMap<>();

    String insightSummary = (String) request.getAttribute("insightSummary");
    if (insightSummary == null) {
        insightSummary = "Your emotional well-being shows positive trends. Continue tracking your emotions and habits for deeper insights.";
    }

    String insightForCSV = (String) request.getAttribute("insightForCSV");
    if (insightForCSV == null) {
        insightForCSV = insightSummary;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Analytics & Reports - EmoVault</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/design-system.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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

        /* Overview Cards */
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

        /* Charts Section */
        .charts-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: var(--space-3xl);
            margin-bottom: var(--space-4xl);
        }

        .chart-card {
            background: var(--color-white);
            border: 1px solid var(--color-warm-gray);
            border-radius: var(--radius-lg);
            padding: var(--space-2xl);
            transition: all var(--transition-base);
        }

        .chart-card:hover {
            box-shadow: var(--shadow-lg);
            border-color: var(--color-viridian);
        }

        .chart-card h3 {
            font-family: var(--font-secondary);
            font-size: var(--font-size-2xl);
            color: var(--color-azur);
            margin: 0 0 var(--space-2xl) 0;
            font-weight: var(--font-weight-semibold);
        }

        .chart-container {
            position: relative;
            height: 300px;
            margin-bottom: var(--space-lg);
        }

        .chart-label {
            font-size: var(--font-size-sm);
            color: var(--color-warm-gray);
            text-align: center;
        }

        /* Insights Section */
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

        .insight-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: var(--space-2xl);
        }

        .insight-box {
            padding: var(--space-2xl);
            border-radius: var(--radius-lg);
            background: var(--color-cream);
            border-left: 4px solid var(--color-viridian);
        }

        .insight-box h4 {
            color: var(--color-azur);
            margin: 0 0 var(--space-lg) 0;
            font-size: var(--font-size-lg);
            font-weight: var(--font-weight-semibold);
        }

        .insight-box p {
            color: var(--color-azur);
            line-height: var(--line-height-loose);
            margin: 0;
            font-size: var(--font-size-sm);
        }

        /* Summary Insight */
        .summary-insight {
            background: linear-gradient(135deg, var(--color-viridian) 0%, var(--color-candy) 100%);
            color: white;
            padding: var(--space-2xl);
            border-radius: var(--radius-lg);
            margin: var(--space-2xl) 0;
            font-size: var(--font-size-base);
            line-height: var(--line-height-loose);
            font-weight: var(--font-weight-medium);
        }

        /* Report Generation */
        .report-section {
            background: var(--color-white);
            border: 1px solid var(--color-warm-gray);
            border-radius: var(--radius-lg);
            padding: var(--space-2xl);
            text-align: center;
        }

        .report-section h3 {
            font-family: var(--font-secondary);
            color: var(--color-azur);
            margin-bottom: var(--space-lg);
            font-size: var(--font-size-2xl);
        }

        .report-section p {
            color: var(--color-warm-gray);
            margin-bottom: var(--space-xl);
        }

        .report-btn {
            background: linear-gradient(135deg, var(--color-viridian) 0%, var(--color-candy) 100%);
            color: white;
            border: none;
            padding: var(--space-md) var(--space-xl);
            border-radius: var(--radius-lg);
            font-size: var(--font-size-base);
            cursor: pointer;
            transition: all var(--transition-base);
            margin: var(--space-sm);
            font-weight: var(--font-weight-medium);
        }

        .report-btn:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }

        /* Responsive */
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

            .charts-section {
                grid-template-columns: 1fr;
            }

            .chart-container {
                height: 250px;
            }

            .overview-cards {
                grid-template-columns: 1fr;
            }

            .insight-grid {
                grid-template-columns: 1fr;
            }
        }

        .no-data {
            text-align: center;
            color: var(--color-warm-gray);
            padding: var(--space-3xl) var(--space-xl);
            font-style: italic;
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
                    <p class="analytics-subtitle">Track your emotions, decisions, and progress over time</p>
                </div>

                <!-- Overview Cards - Real-time Habit Data -->
                <div class="overview-cards">
                    <div class="overview-card">
                        <div class="card-label">📝 Total Emotions</div>
                        <div class="card-value"><%= statistics.get("totalEmotions") %></div>
                        <div class="card-detail">Logged total</div>
                    </div>

                    <div class="overview-card">
                        <div class="card-label">🎯 Habits Completed</div>
                        <div class="card-value"><%= habitsCompletedToday %></div>
                        <div class="card-detail">today</div>
                    </div>

                    <div class="overview-card">
                        <div class="card-label">🔥 Current Streak</div>
                        <div class="card-value"><%= habitStreak %></div>
                        <div class="card-detail">days in a row</div>
                    </div>

                    <div class="overview-card">
                        <div class="card-label">📈 Consistency</div>
                        <div class="card-value"><%= String.format("%.1f", habitConsistency) %>%</div>
                        <div class="card-detail">average rate</div>
                    </div>

                    <div class="overview-card">
                        <div class="card-label">🏆 Longest Streak</div>
                        <div class="card-value"><%= longestStreak %></div>
                        <div class="card-detail">all time best</div>
                    </div>

                    <div class="overview-card">
                        <div class="card-label">✅ Total Completions</div>
                        <div class="card-value"><%= totalCompletions %></div>
                        <div class="card-detail">all time</div>
                    </div>
                </div>

                <!-- Charts Section -->
                <div class="charts-section">
                    <!-- Emotional Distribution Chart -->
                    <div class="chart-card">
                        <h3>🎭 Emotional Distribution</h3>
                        <div class="chart-container">
                            <canvas id="distributionChart"></canvas>
                        </div>
                        <div class="chart-label">Distribution of emotions logged</div>
                    </div>

                    <!-- Mood Trend Chart -->
                    <div class="chart-card">
                        <h3>📈 Mood Trend</h3>
                        <div class="chart-container">
                            <canvas id="trendChart"></canvas>
                        </div>
                        <div class="chart-label">Intensity over time (scale 1-10)</div>
                    </div>

                    <!-- Risk Summary Chart -->
                    <div class="chart-card">
                        <h3>⚠️ Risk Summary</h3>
                        <div class="chart-container">
                            <canvas id="riskChart"></canvas>
                        </div>
                        <div class="chart-label">Distribution of decision risks</div>
                    </div>
                </div>

                <!-- Insights Section -->
                <div class="insights-section">
                    <h2>💡 Key Insights</h2>

                    <!-- Summary Insight -->
                    <div class="summary-insight">
                        <%= insightSummary %>
                    </div>

                    <div class="insight-grid">
                        <!-- Emotion Insight -->
                        <div class="insight-box">
                            <h4>😊 Emotional Pattern</h4>
                            <p>
                                Your most frequent emotion this month was
                                <strong><%
                                    String topEmotion = "Mixed";
                                    int maxCount = 0;
                                    for (java.util.Map.Entry<String, Integer> entry : emotionalDistribution.entrySet()) {
                                        if (entry.getValue() > maxCount) {
                                            maxCount = entry.getValue();
                                            topEmotion = entry.getKey();
                                        }
                                    }
                                    out.print(topEmotion);
                                %></strong>.
                                Monitor your emotional triggers and patterns.
                            </p>
                        </div>

                        <!-- Regret Analysis -->
                        <div class="insight-box">
                            <h4>🔄 Reflection Pattern</h4>
                            <p>
                                You have logged <strong><%= repeatedMistakes %></strong> reflections this month.
                                <% if (repeatedMistakes > 5) { %>
                                    This is higher than average - consider identifying patterns.
                                <% } else if (repeatedMistakes > 0) { %>
                                    Work on addressing these recurring issues.
                                <% } else { %>
                                    Great! You're reflecting on your choices positively.
                                <% } %>
                            </p>
                        </div>

                        <!-- Habit Analysis -->
                        <div class="insight-box">
                            <h4>✅ Habit Progress</h4>
                            <p>
                                <% if (habitStreak > 20) { %>
                                    Excellent! Your current streak of <strong><%= habitStreak %></strong> days shows great dedication.
                                    <% if (longestStreak > habitStreak) { %>
                                        Your all-time best is <strong><%= longestStreak %></strong> days!
                                    <% } %>
                                <% } else if (habitStreak > 7) { %>
                                    Good job! You have a <strong><%= habitStreak %></strong>-day streak. Keep it going!
                                <% } else if (habitStreak > 0) { %>
                                    You're building momentum with a <strong><%= habitStreak %></strong>-day streak.
                                <% } else { %>
                                    Start tracking habits to build consistency and improve your well-being.
                                <% } %>
                            </p>
                        </div>

                        <!-- Missed Days Analysis -->
                        <div class="insight-box">
                            <h4>📅 Consistency Check</h4>
                            <p>
                                <% if (missedDays > 5) { %>
                                    You've missed <strong><%= missedDays %></strong> days this month. Try to stay more consistent!
                                <% } else if (missedDays > 0) { %>
                                    You've missed <strong><%= missedDays %></strong> days this month. Keep pushing!
                                <% } else { %>
                                    Perfect! You haven't missed any days this month. Excellent consistency!
                                <% } %>
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Report Generation -->
                <div class="report-section">
                    <h3>📄 Generate Reports</h3>
                    <p>Export your analytics data for deeper analysis or sharing with professionals</p>
                    <button class="report-btn" onclick="generatePDFReport()">📥 Download PDF Report</button>
                    <button class="report-btn" onclick="generateCSVReport()">📊 Export as CSV</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Emotional Distribution Chart
        const distCtx = document.getElementById('distributionChart').getContext('2d');
        const emotionData = {
            <%
                for (Map.Entry<String, Integer> entry : emotionalDistribution.entrySet()) {
                    out.print("'" + entry.getKey() + "': " + entry.getValue() + ",");
                }
            %>
        };

        new Chart(distCtx, {
            type: 'doughnut',
            data: {
                labels: Object.keys(emotionData),
                datasets: [{
                    data: Object.values(emotionData),
                    backgroundColor: [
                        '#679F9F',
                        '#877499',
                        '#E18299',
                        '#2D4729'
                    ],
                    borderColor: '#fff',
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            color: '#4A3F47',
                            font: { size: 12 }
                        }
                    }
                }
            }
        });

        // Mood Trend Chart
        const trendCtx = document.getElementById('trendChart').getContext('2d');
        const trendData = [
            <%
                for (Map<String, Object> data : moodTrend) {
                    out.print("{date: '" + data.get("date") + "', intensity: " + data.get("intensity") + "},");
                }
            %>
        ];

        const trendLabels = trendData.map(d => d.date);
        const trendValues = trendData.map(d => d.intensity);

        new Chart(trendCtx, {
            type: 'line',
            data: {
                labels: trendLabels,
                datasets: [{
                    label: 'Mood Intensity',
                    data: trendValues,
                    borderColor: '#679F9F',
                    backgroundColor: 'rgba(103, 159, 159, 0.1)',
                    tension: 0.4,
                    fill: true,
                    pointRadius: 4,
                    pointHoverRadius: 6,
                    pointBackgroundColor: '#679F9F'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: true,
                        labels: {
                            color: '#4A3F47',
                            font: { size: 12 }
                        }
                    }
                },
                scales: {
                    y: {
                        min: 0,
                        max: 10,
                        ticks: {
                            color: '#888'
                        },
                        grid: {
                            color: 'rgba(0,0,0,0.05)'
                        }
                    },
                    x: {
                        ticks: {
                            color: '#888'
                        },
                        grid: {
                            color: 'rgba(0,0,0,0.05)'
                        }
                    }
                }
            }
        });

        // Risk Summary Chart
        const riskCtx = document.getElementById('riskChart').getContext('2d');
        const riskData = {
            <%
                for (Map.Entry<String, Integer> entry : riskSummary.entrySet()) {
                    out.print("'" + entry.getKey() + "': " + entry.getValue() + ",");
                }
            %>
        };

        new Chart(riskCtx, {
            type: 'bar',
            data: {
                labels: Object.keys(riskData),
                datasets: [{
                    label: 'Number of Decisions',
                    data: Object.values(riskData),
                    backgroundColor: [
                        '#4CAF50',
                        '#FFC107',
                        '#F44336'
                    ],
                    borderRadius: 6,
                    borderSkipped: false
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: true,
                        labels: {
                            color: '#4A3F47',
                            font: { size: 12 }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            color: '#888'
                        },
                        grid: {
                            color: 'rgba(0,0,0,0.05)'
                        }
                    },
                    x: {
                        ticks: {
                            color: '#888'
                        },
                        grid: {
                            color: 'rgba(0,0,0,0.05)'
                        }
                    }
                }
            }
        });

        // Report Generation Functions
        function generatePDFReport() {
            alert('PDF report generation will be available soon. Currently available: CSV export');
        }

        function generateCSVReport() {
            const csvContent = [
                ['EmoVault Analytics Report', new Date().toLocaleDateString()],
                [],
                ['Statistics'],
                ['Total Emotions', '<%= statistics.get("totalEmotions") %>'],
                ['Total Decisions', '<%= statistics.get("totalDecisions") %>'],
                ['Total Habits', '<%= statistics.get("totalHabits") %>'],
                ['Total Reflections', '<%= statistics.get("totalRegrets") %>'],
                [],
                ['Habit Progress'],
                ['Current Streak', '<%= habitStreak %> days'],
                ['Consistency', '<%= String.format("%.1f", habitConsistency) %>%'],
                [],
                ['Key Insight'],
                ['<%= insightForCSV %>']
            ].map(row => row.join(',')).join('\n');

            const blob = new Blob([csvContent], { type: 'text/csv' });
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = 'emovault-analytics-' + new Date().toISOString().split('T')[0] + '.csv';
            a.click();
            window.URL.revokeObjectURL(url);
        }
    </script>
</body>
</html>
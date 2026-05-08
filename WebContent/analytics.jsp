<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Analytics & Reports - EmoVault</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/design-system.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: var(--font-family, 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif);
            background: linear-gradient(135deg, var(--color-sandstone, #E6D4BF) 0%, var(--color-cream, #FBF8F3) 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .analytics-container {
            max-width: 1400px;
            margin: 0 auto;
        }
        
        .page-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 40px;
            padding: 20px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .page-header h1 {
            color: var(--color-heather, #877499);
            font-size: 2.5em;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .page-header .date-range {
            color: #666;
            font-size: 0.9em;
        }
        
        /* Overview Cards */
        .overview-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        
        .overview-card {
            background: white;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border-left: 4px solid var(--color-viridian, #679F9F);
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .overview-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0,0,0,0.12);
        }
        
        .overview-card .card-label {
            color: #999;
            font-size: 0.85em;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 8px;
        }
        
        .overview-card .card-value {
            color: var(--color-viridian, #679F9F);
            font-size: 2.2em;
            font-weight: 700;
            margin-bottom: 8px;
        }
        
        .overview-card .card-detail {
            color: #999;
            font-size: 0.9em;
        }
        
        /* Charts Section */
        .charts-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 30px;
            margin-bottom: 40px;
        }
        
        .chart-card {
            background: white;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        
        .chart-card h3 {
            color: var(--color-heather, #877499);
            margin-bottom: 20px;
            font-size: 1.3em;
        }
        
        .chart-container {
            position: relative;
            height: 300px;
            margin-bottom: 15px;
        }
        
        /* Insights Section */
        .insights-section {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            margin-bottom: 40px;
        }
        
        .insights-section h2 {
            color: var(--color-heather, #877499);
            margin-bottom: 20px;
            font-size: 1.5em;
        }
        
        .insight-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }
        
        .insight-box {
            padding: 20px;
            border-radius: 8px;
            background: var(--color-sandstone, #E6D4BF);
            border-left: 4px solid var(--color-viridian, #679F9F);
        }
        
        .insight-box h4 {
            color: var(--color-heather, #877499);
            margin-bottom: 10px;
            font-size: 1.1em;
        }
        
        .insight-box p {
            color: #555;
            line-height: 1.6;
        }
        
        /* Summary Insight */
        .summary-insight {
            background: linear-gradient(135deg, var(--color-viridian, #679F9F), #5a8a8a);
            color: white;
            padding: 30px;
            border-radius: 12px;
            margin: 20px 0;
            font-size: 1.1em;
            line-height: 1.8;
            font-weight: 500;
        }
        
        /* Risk Badge */
        .risk-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: 600;
            margin: 2px;
        }
        
        .risk-low {
            background: #d4edda;
            color: #155724;
        }
        
        .risk-medium {
            background: #fff3cd;
            color: #856404;
        }
        
        .risk-high {
            background: #f8d7da;
            color: #721c24;
        }
        
        /* Report Generation */
        .report-section {
            background: white;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            text-align: center;
        }
        
        .report-section h3 {
            color: var(--color-heather, #877499);
            margin-bottom: 15px;
        }
        
        .report-btn {
            background: linear-gradient(135deg, var(--color-viridian, #679F9F), #5a8a8a);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 8px;
            font-size: 1em;
            cursor: pointer;
            transition: all 0.3s ease;
            margin: 5px;
        }
        
        .report-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 16px rgba(103, 159, 159, 0.3);
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .page-header {
                flex-direction: column;
                text-align: center;
            }
            
            .page-header h1 {
                font-size: 1.8em;
                justify-content: center;
            }
            
            .charts-section {
                grid-template-columns: 1fr;
            }
            
            .chart-container {
                height: 250px;
            }
        }
        
        .no-data {
            text-align: center;
            color: #999;
            padding: 40px 20px;
            font-style: italic;
        }
    </style>
</head>
<body>
    <%
        Integer userId = (Integer) session.getAttribute("userId");
        String userName = (String) session.getAttribute("userName");
        
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        @SuppressWarnings("unchecked")
        Map<String, Object> analytics = (Map<String, Object>) request.getAttribute("analytics");
        
        if (analytics == null) {
            analytics = new java.util.HashMap<>();
        }
        
        @SuppressWarnings("unchecked")
        Map<String, Integer> emotionalDistribution = (Map<String, Integer>) analytics.getOrDefault("emotionalDistribution", new java.util.HashMap<>());
        
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> moodTrend = (List<Map<String, Object>>) analytics.getOrDefault("moodTrend", new java.util.ArrayList<>());
        
        @SuppressWarnings("unchecked")
        Map<String, Integer> riskSummary = (Map<String, Integer>) analytics.getOrDefault("riskSummary", new java.util.HashMap<>());
        
        @SuppressWarnings("unchecked")
        Map<String, Integer> statistics = (Map<String, Integer>) analytics.getOrDefault("statistics", new java.util.HashMap<>());
        
        String insightSummary = (String) analytics.getOrDefault("insightSummary", "No data available yet");
        String topRegret = (String) analytics.getOrDefault("topRegret", "None");
        Integer repeatedMistakes = (Integer) analytics.getOrDefault("repeatedMistakes", 0);
        Integer habitStreak = (Integer) analytics.getOrDefault("habitStreak", 0);
        Double habitConsistency = (Double) analytics.getOrDefault("habitConsistency", 0.0);
        
        // Prepare CSV-safe versions
        String insightForCSV = insightSummary != null ? insightSummary.replace("\"", "\"\"") : "";
    %>
    
    <div class="analytics-container">
        <!-- Page Header -->
        <div class="page-header">
            <div>
                <h1>📊 Analytics & Reports</h1>
                <p class="date-range">Last 30 days</p>
            </div>
            <div style="color: #666;">
                Hello, <strong><%= userName != null ? userName : "User" %></strong>
            </div>
        </div>
        
        <!-- Overview Cards -->
        <div class="overview-cards">
            <div class="overview-card">
                <div class="card-label">Total Emotions</div>
                <div class="card-value"><%= statistics.get("totalEmotions") %></div>
                <div class="card-detail">Logged this month</div>
            </div>
            
            <div class="overview-card">
                <div class="card-label">Total Decisions</div>
                <div class="card-value"><%= statistics.get("totalDecisions") %></div>
                <div class="card-detail">Analyzed choices</div>
            </div>
            
            <div class="overview-card">
                <div class="card-label">Habit Streak</div>
                <div class="card-value"><%= habitStreak %></div>
                <div class="card-detail">days in a row</div>
            </div>
            
            <div class="overview-card">
                <div class="card-label">Habit Consistency</div>
                <div class="card-value"><%= String.format("%.1f", habitConsistency) %>%</div>
                <div class="card-detail">of days tracked</div>
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
                <div style="font-size: 0.9em; color: #666; text-align: center;">
                    Distribution of emotions logged
                </div>
            </div>
            
            <!-- Mood Trend Chart -->
            <div class="chart-card">
                <h3>📈 Mood Trend</h3>
                <div class="chart-container">
                    <canvas id="trendChart"></canvas>
                </div>
                <div style="font-size: 0.9em; color: #666; text-align: center;">
                    Intensity over time (scale 1-10)
                </div>
            </div>
            
            <!-- Risk Summary Chart -->
            <div class="chart-card">
                <h3>⚠️ Risk Summary</h3>
                <div class="chart-container">
                    <canvas id="riskChart"></canvas>
                </div>
                <div style="font-size: 0.9em; color: #666; text-align: center;">
                    Distribution of decision risks
                </div>
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
                        <strong><%= emotionalDistribution.entrySet().stream()
                            .max(java.util.Map.Entry.comparingByValue())
                            .map(e -> e.getKey())
                            .orElse("Mixed") %></strong>.
                        Monitor your emotional triggers and patterns.
                    </p>
                </div>
                
                <!-- Regret Analysis -->
                <div class="insight-box">
                    <h4>🔄 Regret Pattern</h4>
                    <p>
                        You have logged <strong><%= repeatedMistakes %></strong> regrets this month.
                        <%if (repeatedMistakes > 5) {%>
                            This is higher than average - consider identifying patterns.
                        <%} else if (repeatedMistakes > 0) {%>
                            Work on addressing these recurring issues.
                        <%} else {%>
                            Great! You're reflecting on your choices positively.
                        <%}%>
                    </p>
                </div>
                
                <!-- Habit Analysis -->
                <div class="insight-box">
                    <h4>✅ Habit Progress</h4>
                    <p>
                        <%if (habitStreak > 20) {%>
                            Excellent! Your current streak of <strong><%= habitStreak %></strong> days shows great dedication.
                        <%} else if (habitStreak > 7) {%>
                            Good job! You have a <strong><%= habitStreak %></strong>-day streak. Keep it going!
                        <%} else if (habitStreak > 0) {%>
                            You're building momentum with a <strong><%= habitStreak %></strong>-day streak.
                        <%} else {%>
                            Start tracking habits to build consistency and improve your well-being.
                        <%}%>
                    </p>
                </div>
            </div>
        </div>
        
        <!-- Report Generation -->
        <div class="report-section" style="margin-bottom: 40px;">
            <h3>📄 Generate Reports</h3>
            <p style="color: #666; margin-bottom: 20px;">
                Export your analytics data for deeper analysis or sharing with professionals
            </p>
            <button class="report-btn" onclick="generatePDFReport()">📥 Download PDF Report</button>
            <button class="report-btn" onclick="generateCSVReport()">📊 Export as CSV</button>
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
                        position: 'bottom'
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
                        display: true
                    }
                },
                scales: {
                    y: {
                        min: 0,
                        max: 10
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
                        display: true
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true
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
                ['Total Regrets', '<%= statistics.get("totalRegrets") %>'],
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

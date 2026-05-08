<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EmoVault - Analytics & Reports</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="emovault-complete-ui.css">
    <style>
        .analytics-page {
            min-height: 100vh;
            background: var(--color-van-dyke);
            padding: var(--space-xl);
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
            color: var(--color-pale-dogwood);
            font-size: 2.2rem;
        }

        .date-range-selector {
            display: flex;
            gap: var(--space-sm);
        }

        .date-btn {
            padding: var(--space-sm) var(--space-lg);
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            color: var(--color-pale-dogwood);
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
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: var(--space-lg);
            animation: slideUp 0.6s ease-out;
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
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: var(--space-lg);
            animation: slideUp 0.6s ease-out;
        }

        .chart-title {
            color: var(--color-pale-dogwood);
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
            background: var(--glass-overlay);
            border-radius: var(--radius-md);
            border: 1px solid var(--glass-border);
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
            color: var(--color-pale-dogwood);
            font-weight: 700;
            margin-bottom: var(--space-xs);
        }

        .trend-value {
            color: var(--color-text-soft);
            font-size: 0.9rem;
        }

        .trend-change {
            color: var(--color-puce);
            font-weight: 700;
        }

        .trend-bar {
            width: 80px;
            height: 4px;
            background: var(--glass-overlay);
            border-radius: var(--radius-xl);
            overflow: hidden;
        }

        .trend-fill {
            height: 100%;
            background: var(--gradient-button);
        }

        .insights-section {
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: var(--space-lg);
            animation: slideUp 0.6s ease-out;
        }

        .insights-title {
            color: var(--color-pale-dogwood);
            font-size: 1.3rem;
            font-weight: 700;
            margin-bottom: var(--space-lg);
        }

        .insight-box {
            padding: var(--space-lg);
            background: var(--glass-overlay);
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
            color: var(--color-pale-dogwood);
            font-weight: 700;
            margin-bottom: var(--space-sm);
        }

        .insight-text {
            color: var(--color-text-soft);
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
    </style>
</head>
<body>
    <header style="background: var(--color-english-violet); padding: var(--space-lg); margin-bottom: var(--space-xl);">
        <a href="dashboard_complete.jsp" style="color: var(--color-pale-dogwood); text-decoration: none; font-weight: 700; display: flex; align-items: center; gap: var(--space-sm); width: fit-content;">
            <span>← Back to Dashboard</span>
        </a>
    </header>
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

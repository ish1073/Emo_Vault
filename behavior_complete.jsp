<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EmoVault - Behavior Analyzer</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="emovault-complete-ui.css">
    <style>
        .analyzer-page {
            min-height: 100vh;
            background: linear-gradient(135deg, #443C5E 0%, #3D2B27 100%);
            padding: var(--space-xl);
        }

        .analyzer-container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .analyzer-header {
            text-align: center;
            margin-bottom: var(--space-2xl);
        }

        .analyzer-title {
            color: var(--color-pale-dogwood);
            font-size: 2.2rem;
            margin-bottom: var(--space-md);
        }

        .analyzer-subtitle {
            color: var(--color-text-soft);
            font-size: 1rem;
        }

        .analyzer-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: var(--space-lg);
            margin-bottom: var(--space-2xl);
        }

        .insight-card {
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: var(--space-lg);
            transition: all var(--transition-base);
            animation: slideUp 0.6s ease-out;
        }

        .insight-card:hover {
            transform: translateY(-8px);
            border-color: var(--color-puce);
            box-shadow: var(--shadow-glow);
        }

        .insight-header {
            display: flex;
            align-items: center;
            gap: var(--space-md);
            margin-bottom: var(--space-lg);
            padding-bottom: var(--space-lg);
            border-bottom: 1px solid var(--glass-border);
        }

        .insight-icon {
            font-size: 2rem;
        }

        .insight-title {
            color: var(--color-pale-dogwood);
            font-size: 1.2rem;
            font-weight: 700;
            margin: 0;
        }

        .insight-content {
            color: var(--color-text-soft);
            line-height: 1.8;
            font-size: 0.95rem;
        }

        .risk-indicator {
            display: flex;
            align-items: center;
            gap: var(--space-md);
            margin-top: var(--space-lg);
            padding: var(--space-md);
            border-radius: var(--radius-md);
            background: rgba(191, 113, 133, 0.1);
            border-left: 4px solid var(--color-puce);
        }

        .risk-level {
            font-weight: 700;
            color: var(--color-puce);
            text-transform: uppercase;
            font-size: 0.85rem;
        }

        .risk-text {
            color: var(--color-text-soft);
            font-size: 0.9rem;
        }

        .pattern-card {
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: var(--space-lg);
            margin-bottom: var(--space-lg);
            animation: slideUp 0.6s ease-out;
        }

        .pattern-title {
            color: var(--color-pale-dogwood);
            font-size: 1.3rem;
            margin-bottom: var(--space-lg);
            font-weight: 700;
        }

        .pattern-list {
            list-style: none;
        }

        .pattern-item {
            padding: var(--space-md) 0;
            border-bottom: 1px solid var(--glass-border);
            color: var(--color-text-soft);
            display: flex;
            align-items: flex-start;
            gap: var(--space-md);
        }

        .pattern-item:last-child {
            border-bottom: none;
        }

        .pattern-indicator {
            display: inline-block;
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: var(--color-puce);
            margin-top: 6px;
            flex-shrink: 0;
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
            font-size: 1.3rem;
            margin-bottom: var(--space-lg);
            font-weight: 700;
        }

        .pie-chart {
            display: flex;
            justify-content: center;
            gap: var(--space-xl);
            flex-wrap: wrap;
            margin: var(--space-lg) 0;
        }

        .pie-segment {
            text-align: center;
        }

        .pie-color {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            margin: 0 auto var(--space-md);
            box-shadow: var(--shadow-md);
        }

        .pie-label {
            color: var(--color-text-soft);
            font-size: 0.9rem;
        }

        .pie-value {
            color: var(--color-pale-dogwood);
            font-weight: 700;
            font-size: 1rem;
        }

        .recommendation {
            background: linear-gradient(135deg, rgba(191, 113, 133, 0.15) 0%, rgba(169, 159, 191, 0.1) 100%);
            border: 2px solid var(--color-puce);
            border-radius: var(--radius-md);
            padding: var(--space-lg);
            margin-top: var(--space-xl);
        }

        .recommendation-title {
            color: var(--color-puce);
            font-weight: 700;
            margin-bottom: var(--space-md);
            text-transform: uppercase;
            font-size: 0.9rem;
            letter-spacing: 0.5px;
        }

        .recommendation-text {
            color: var(--color-text-soft);
            line-height: 1.8;
        }
    </style>
</head>
<body>
    <header style="background: linear-gradient(135deg, #443C5E 0%, #3D2B27 100%); padding: var(--space-lg); margin-bottom: var(--space-xl);">
        <a href="dashboard_complete.jsp" style="color: var(--color-pale-dogwood); text-decoration: none; font-weight: 700; display: flex; align-items: center; gap: var(--space-sm); width: fit-content;">
            <span>← Back to Dashboard</span>
        </a>
    </header>
    <div class="analyzer-page">
        <div class="analyzer-container">
            <div class="analyzer-header">
                <h1 class="analyzer-title">🧠 Behavior Analyzer</h1>
                <p class="analyzer-subtitle">AI-powered insights into your emotional patterns and behavioral trends</p>
            </div>

            <!-- Key Insights -->
            <div class="analyzer-grid">
                <div class="insight-card">
                    <div class="insight-header">
                        <span class="insight-icon">📊</span>
                        <h3 class="insight-title">Mood Distribution</h3>
                    </div>
                    <p class="insight-content">Your primary emotions over the past 30 days reveal a balanced emotional state with increased positivity on weekends.</p>
                    <div class="risk-indicator">
                        <span class="risk-level">✓ Healthy</span>
                        <span class="risk-text">Well-balanced emotional range</span>
                    </div>
                </div>

                <div class="insight-card">
                    <div class="insight-header">
                        <span class="insight-icon">⚡</span>
                        <h3 class="insight-title">Stress Triggers</h3>
                    </div>
                    <p class="insight-content">Work-related stressors appear on Mondays and Fridays. Meeting deadlines correlates with anxiety spikes.</p>
                    <div class="risk-indicator" style="background: rgba(169, 159, 191, 0.1); border-left-color: var(--color-rose-quartz);">
                        <span class="risk-level" style="color: var(--color-rose-quartz);">⚠ Moderate</span>
                        <span class="risk-text">Manageable with intervention</span>
                    </div>
                </div>

                <div class="insight-card">
                    <div class="insight-header">
                        <span class="insight-icon">🎯</span>
                        <h3 class="insight-title">Behavioral Patterns</h3>
                    </div>
                    <p class="insight-content">You tend to journal more during evening hours. Exercise positively impacts your mood for 2-3 days after.</p>
                    <div class="risk-indicator">
                        <span class="risk-level">✓ Optimal</span>
                        <span class="risk-text">Strong self-awareness habits</span>
                    </div>
                </div>
            </div>

            <!-- Detailed Patterns -->
            <div class="pattern-card">
                <h3 class="pattern-title">📈 Identified Patterns</h3>
                <ul class="pattern-list">
                    <li class="pattern-item">
                        <span class="pattern-indicator"></span>
                        <div>
                            <strong style="color: var(--color-pale-dogwood);">Monday Effect:</strong> Mood drops 15% on Mondays, particularly in morning hours
                        </div>
                    </li>
                    <li class="pattern-item">
                        <span class="pattern-indicator" style="background: var(--color-rose-quartz);"></span>
                        <div>
                            <strong style="color: var(--color-pale-dogwood);">Exercise Impact:</strong> 40-minute workouts increase happiness levels for 48 hours
                        </div>
                    </li>
                    <li class="pattern-item">
                        <span class="pattern-indicator"></span>
                        <div>
                            <strong style="color: var(--color-pale-dogwood);">Sleep Correlation:</strong> Less than 6 hours of sleep strongly correlates with irritability
                        </div>
                    </li>
                    <li class="pattern-item">
                        <span class="pattern-indicator" style="background: var(--color-rose-quartz);"></span>
                        <div>
                            <strong style="color: var(--color-pale-dogwood);">Social Interaction:</strong> Quality time with friends boosts mood for 3-5 days
                        </div>
                    </li>
                </ul>
            </div>

            <!-- Charts -->
            <div class="chart-card">
                <h3 class="chart-title">Emotion Breakdown (Last 30 Days)</h3>
                <div class="pie-chart">
                    <div class="pie-segment">
                        <div class="pie-color" style="background: #BF7185;"></div>
                        <div class="pie-label">Happy</div>
                        <div class="pie-value">35%</div>
                    </div>
                    <div class="pie-segment">
                        <div class="pie-color" style="background: #443C5E;"></div>
                        <div class="pie-label">Calm</div>
                        <div class="pie-value">28%</div>
                    </div>
                    <div class="pie-segment">
                        <div class="pie-color" style="background: #A99FBF;"></div>
                        <div class="pie-label">Anxious</div>
                        <div class="pie-value">22%</div>
                    </div>
                    <div class="pie-segment">
                        <div class="pie-color" style="background: #E2C2BC;"></div>
                        <div class="pie-label">Sad</div>
                        <div class="pie-value">15%</div>
                    </div>
                </div>

                <div class="recommendation">
                    <div class="recommendation-title">💡 Recommendation</div>
                    <div class="recommendation-text">
                        Based on your patterns, consider implementing a Monday morning routine that includes exercise and meditation. This could offset the weekly stress drop. Additionally, prioritize consistent sleep schedules to maintain emotional stability throughout the week.
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

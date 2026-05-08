<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EmoVault - Expert Module</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="emovault-complete-ui.css">
    <style>
        .expert-page {
            min-height: 100vh;
            background: linear-gradient(135deg, #443C5E 0%, #3D2B27 100%);
            padding: var(--space-xl);
        }

        .expert-container {
            max-width: 1100px;
            margin: 0 auto;
        }

        .expert-header {
            text-align: center;
            margin-bottom: var(--space-2xl);
        }

        .expert-title {
            color: var(--color-pale-dogwood);
            font-size: 2.2rem;
            margin-bottom: var(--space-md);
        }

        .expert-subtitle {
            color: var(--color-text-soft);
            font-size: 1rem;
        }

        .expert-status {
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: var(--space-lg);
            margin-bottom: var(--space-2xl);
            display: flex;
            align-items: center;
            gap: var(--space-lg);
            animation: slideUp 0.6s ease-out;
        }

        .status-indicator {
            width: 20px;
            height: 20px;
            border-radius: 50%;
            background: var(--color-puce);
            box-shadow: var(--shadow-glow);
            animation: pulse 2s ease-in-out infinite;
        }

        .status-text {
            flex: 1;
        }

        .status-title {
            color: var(--color-pale-dogwood);
            font-weight: 700;
            margin-bottom: var(--space-xs);
        }

        .status-desc {
            color: var(--color-text-soft);
            font-size: 0.9rem;
        }

        .suggestion-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: var(--space-lg);
            margin-bottom: var(--space-2xl);
        }

        .suggestion-card {
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: var(--space-lg);
            transition: all var(--transition-base);
            animation: slideUp 0.6s ease-out;
            position: relative;
            overflow: hidden;
        }

        .suggestion-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: var(--gradient-button);
            transform: scaleY(0);
            transform-origin: top;
            transition: transform var(--transition-base);
        }

        .suggestion-card:hover {
            transform: translateY(-8px);
            border-color: var(--color-puce);
            box-shadow: var(--shadow-glow);
        }

        .suggestion-card:hover::before {
            transform: scaleY(1);
        }

        .suggestion-header {
            display: flex;
            align-items: flex-start;
            gap: var(--space-md);
            margin-bottom: var(--space-lg);
        }

        .suggestion-icon {
            font-size: 2rem;
            flex-shrink: 0;
        }

        .suggestion-info {
            flex: 1;
        }

        .suggestion-title {
            color: var(--color-pale-dogwood);
            font-weight: 700;
            font-size: 1.1rem;
            margin-bottom: var(--space-sm);
        }

        .suggestion-category {
            display: inline-block;
            padding: var(--space-xs) var(--space-sm);
            background: var(--color-rose-quartz);
            color: #FFF;
            border-radius: var(--radius-sm);
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }

        .suggestion-desc {
            color: var(--color-text-soft);
            font-size: 0.95rem;
            line-height: 1.7;
            margin: var(--space-lg) 0;
        }

        .confidence-bar {
            margin-bottom: var(--space-lg);
        }

        .confidence-label {
            display: flex;
            justify-content: space-between;
            color: var(--color-text-muted);
            font-size: 0.85rem;
            margin-bottom: var(--space-sm);
        }

        .confidence-progress {
            height: 6px;
            background: var(--glass-overlay);
            border-radius: var(--radius-xl);
            overflow: hidden;
            border: 1px solid var(--glass-border);
        }

        .confidence-fill {
            height: 100%;
            background: var(--gradient-button);
            border-radius: var(--radius-xl);
        }

        .suggestion-actions {
            display: flex;
            gap: var(--space-sm);
            margin-top: var(--space-lg);
        }

        .btn-adopt {
            flex: 1;
            padding: var(--space-sm) var(--space-md);
            background: var(--color-puce);
            color: #FFF;
            border: none;
            border-radius: var(--radius-sm);
            font-weight: 600;
            font-size: 0.85rem;
            cursor: pointer;
            transition: all var(--transition-fast);
        }

        .btn-adopt:hover {
            transform: scale(1.05);
            box-shadow: var(--shadow-glow);
        }

        .btn-learn {
            flex: 1;
            padding: var(--space-sm) var(--space-md);
            background: transparent;
            color: var(--color-rose-quartz);
            border: 1px solid var(--color-rose-quartz);
            border-radius: var(--radius-sm);
            font-weight: 600;
            font-size: 0.85rem;
            cursor: pointer;
            transition: all var(--transition-fast);
        }

        .btn-learn:hover {
            background: var(--color-rose-quartz);
            color: #FFF;
        }

        .expert-insights {
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

        .insight-item {
            padding: var(--space-md) 0;
            border-bottom: 1px solid var(--glass-border);
            display: flex;
            gap: var(--space-md);
            color: var(--color-text-soft);
        }

        .insight-item:last-child {
            border-bottom: none;
        }

        .insight-marker {
            color: var(--color-puce);
            font-weight: 700;
            flex-shrink: 0;
        }

        .insight-text {
            line-height: 1.7;
        }
    </style>
</head>
<body>
    <header style="background: linear-gradient(135deg, #443C5E 0%, #3D2B27 100%); padding: var(--space-lg); margin-bottom: var(--space-xl);">
        <a href="dashboard_complete.jsp" style="color: var(--color-pale-dogwood); text-decoration: none; font-weight: 700; display: flex; align-items: center; gap: var(--space-sm); width: fit-content;">
            <span>← Back to Dashboard</span>
        </a>
    </header>
    <div class="expert-page">
        <div class="expert-container">
            <div class="expert-header">
                <h1 class="expert-title">🤖 Expert AI Module</h1>
                <p class="expert-subtitle">Personalized recommendations powered by emotional intelligence analysis</p>
            </div>

            <!-- Status -->
            <div class="expert-status">
                <div class="status-indicator"></div>
                <div class="status-text">
                    <div class="status-title">AI Analysis Complete</div>
                    <div class="status-desc">Processed 342 emotions, 45 behaviors, and 28 patterns. Ready to suggest interventions.</div>
                </div>
            </div>

            <!-- Suggestions Grid -->
            <div class="suggestion-grid">
                <!-- Suggestion 1 -->
                <div class="suggestion-card">
                    <div class="suggestion-header">
                        <div class="suggestion-icon">🧘</div>
                        <div class="suggestion-info">
                            <div class="suggestion-title">Mindfulness Practice</div>
                            <span class="suggestion-category">Mental Health</span>
                        </div>
                    </div>

                    <div class="suggestion-desc">
                        Based on your stress patterns, implementing a 10-minute daily meditation practice could reduce anxiety by 30% within 4 weeks.
                    </div>

                    <div class="confidence-bar">
                        <div class="confidence-label">
                            <span>Confidence Level</span>
                            <span>92%</span>
                        </div>
                        <div class="confidence-progress">
                            <div class="confidence-fill" style="width: 92%;"></div>
                        </div>
                    </div>

                    <div class="suggestion-actions">
                        <button class="btn-adopt">✓ Adopt</button>
                        <button class="btn-learn">Learn More</button>
                    </div>
                </div>

                <!-- Suggestion 2 -->
                <div class="suggestion-card">
                    <div class="suggestion-header">
                        <div class="suggestion-icon">🏃</div>
                        <div class="suggestion-info">
                            <div class="suggestion-title">Exercise Routine</div>
                            <span class="suggestion-category">Wellness</span>
                        </div>
                    </div>

                    <div class="suggestion-desc">
                        Your emotional data suggests moderate-intensity exercise 4x weekly could improve overall mood stability and sleep quality.
                    </div>

                    <div class="confidence-bar">
                        <div class="confidence-label">
                            <span>Confidence Level</span>
                            <span>87%</span>
                        </div>
                        <div class="confidence-progress">
                            <div class="confidence-fill" style="width: 87%;"></div>
                        </div>
                    </div>

                    <div class="suggestion-actions">
                        <button class="btn-adopt">✓ Adopt</button>
                        <button class="btn-learn">Learn More</button>
                    </div>
                </div>

                <!-- Suggestion 3 -->
                <div class="suggestion-card">
                    <div class="suggestion-header">
                        <div class="suggestion-icon">💭</div>
                        <div class="suggestion-info">
                            <div class="suggestion-title">Cognitive Reframing</div>
                            <span class="suggestion-category">Psychology</span>
                        </div>
                    </div>

                    <div class="suggestion-desc">
                        Your thought patterns show recurring negative self-talk. Cognitive reframing techniques could shift perspective by 60% after 6 weeks.
                    </div>

                    <div class="confidence-bar">
                        <div class="confidence-label">
                            <span>Confidence Level</span>
                            <span>88%</span>
                        </div>
                        <div class="confidence-progress">
                            <div class="confidence-fill" style="width: 88%;"></div>
                        </div>
                    </div>

                    <div class="suggestion-actions">
                        <button class="btn-adopt">✓ Adopt</button>
                        <button class="btn-learn">Learn More</button>
                    </div>
                </div>

                <!-- Suggestion 4 -->
                <div class="suggestion-card">
                    <div class="suggestion-header">
                        <div class="suggestion-icon">🌙</div>
                        <div class="suggestion-info">
                            <div class="suggestion-title">Sleep Optimization</div>
                            <span class="suggestion-category">Wellness</span>
                        </div>
                    </div>

                    <div class="suggestion-desc">
                        Your emotional stability drops 25% after poor sleep. Consistent sleep schedule could improve baseline mood by 18%.
                    </div>

                    <div class="confidence-bar">
                        <div class="confidence-label">
                            <span>Confidence Level</span>
                            <span>94%</span>
                        </div>
                        <div class="confidence-progress">
                            <div class="confidence-fill" style="width: 94%;"></div>
                        </div>
                    </div>

                    <div class="suggestion-actions">
                        <button class="btn-adopt">✓ Adopt</button>
                        <button class="btn-learn">Learn More</button>
                    </div>
                </div>

                <!-- Suggestion 5 -->
                <div class="suggestion-card">
                    <div class="suggestion-header">
                        <div class="suggestion-icon">👥</div>
                        <div class="suggestion-info">
                            <div class="suggestion-title">Social Connection</div>
                            <span class="suggestion-category">Relationships</span>
                        </div>
                    </div>

                    <div class="suggestion-desc">
                        Data shows you're most emotionally stable after social interaction. Scheduling weekly meaningful connections is recommended.
                    </div>

                    <div class="confidence-bar">
                        <div class="confidence-label">
                            <span>Confidence Level</span>
                            <span>85%</span>
                        </div>
                        <div class="confidence-progress">
                            <div class="confidence-fill" style="width: 85%;"></div>
                        </div>
                    </div>

                    <div class="suggestion-actions">
                        <button class="btn-adopt">✓ Adopt</button>
                        <button class="btn-learn">Learn More</button>
                    </div>
                </div>

                <!-- Suggestion 6 -->
                <div class="suggestion-card">
                    <div class="suggestion-header">
                        <div class="suggestion-icon">🎯</div>
                        <div class="suggestion-info">
                            <div class="suggestion-title">Goal Setting</div>
                            <span class="suggestion-category">Development</span>
                        </div>
                    </div>

                    <div class="suggestion-desc">
                        Setting achievable micro-goals could provide motivation boosts and improve emotional resilience during challenging periods.
                    </div>

                    <div class="confidence-bar">
                        <div class="confidence-label">
                            <span>Confidence Level</span>
                            <span>81%</span>
                        </div>
                        <div class="confidence-progress">
                            <div class="confidence-fill" style="width: 81%;"></div>
                        </div>
                    </div>

                    <div class="suggestion-actions">
                        <button class="btn-adopt">✓ Adopt</button>
                        <button class="btn-learn">Learn More</button>
                    </div>
                </div>
            </div>

            <!-- Key Insights -->
            <div class="expert-insights">
                <h3 class="insights-title">📊 AI-Generated Insights</h3>

                <div class="insight-item">
                    <span class="insight-marker">→</span>
                    <div class="insight-text">Your emotional baseline improved by 23% over the last 30 days, indicating positive momentum in your wellness journey.</div>
                </div>

                <div class="insight-item">
                    <span class="insight-marker">→</span>
                    <div class="insight-text">Monday mornings show consistent stress spikes. Pre-planning your week on Sunday could mitigate 40% of Monday anxiety.</div>
                </div>

                <div class="insight-item">
                    <span class="insight-marker">→</span>
                    <div class="insight-text">You respond exceptionally well to exercise. Even 20 minutes of movement positively impacts your mood for 2-3 days afterward.</div>
                </div>

                <div class="insight-item">
                    <span class="insight-marker">→</span>
                    <div class="insight-text">Social interactions are your strongest emotional regulator. Prioritizing meaningful connections will yield maximum wellbeing gains.</div>
                </div>

                <div class="insight-item">
                    <span class="insight-marker">→</span>
                    <div class="insight-text">You show resilience patterns after setbacks. Building on these natural coping mechanisms could strengthen emotional stability by 35%.</div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

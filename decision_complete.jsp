<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EmoVault - Decision & Conflict Navigator</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="emovault-complete-ui.css">
    <style>
        .decision-page {
            min-height: 100vh;
            background: linear-gradient(135deg, #443C5E 0%, #3D2B27 100%);
            padding: var(--space-xl);
        }

        .decision-container {
            max-width: 1100px;
            margin: 0 auto;
        }

        .decision-header {
            text-align: center;
            margin-bottom: var(--space-2xl);
        }

        .decision-title {
            color: var(--color-pale-dogwood);
            font-size: 2.2rem;
            margin-bottom: var(--space-md);
        }

        .decision-subtitle {
            color: var(--color-text-soft);
            font-size: 1rem;
        }

        .decision-scenario {
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: var(--space-xl);
            margin-bottom: var(--space-2xl);
            animation: slideUp 0.6s ease-out;
        }

        .scenario-header {
            margin-bottom: var(--space-lg);
        }

        .scenario-title {
            color: var(--color-pale-dogwood);
            font-weight: 700;
            font-size: 1.4rem;
            margin-bottom: var(--space-sm);
        }

        .scenario-context {
            color: var(--color-text-soft);
            line-height: 1.8;
            font-size: 0.95rem;
        }

        .comparison-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: var(--space-lg);
            margin-bottom: var(--space-xl);
        }

        .option-card {
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            border: 2px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: var(--space-lg);
            transition: all var(--transition-base);
            animation: slideUp 0.6s ease-out;
            position: relative;
            overflow: hidden;
        }

        .option-card:hover {
            transform: translateY(-8px);
            border-color: var(--color-puce);
            box-shadow: var(--shadow-glow);
        }

        .option-card.recommended {
            border-color: var(--color-puce);
            background: rgba(191, 113, 133, 0.1);
        }

        .option-card.recommended::after {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 120px;
            height: 120px;
            background: radial-gradient(circle, var(--color-puce) 0%, transparent 70%);
            opacity: 0.1;
            pointer-events: none;
        }

        .option-badge {
            display: inline-block;
            padding: var(--space-xs) var(--space-sm);
            background: var(--color-puce);
            color: #FFF;
            border-radius: var(--radius-sm);
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            margin-bottom: var(--space-lg);
        }

        .option-name {
            color: var(--color-pale-dogwood);
            font-weight: 700;
            font-size: 1.3rem;
            margin-bottom: var(--space-lg);
        }

        .pros-cons {
            margin-bottom: var(--space-lg);
        }

        .pros-title, .cons-title {
            color: var(--color-pale-dogwood);
            font-weight: 700;
            font-size: 0.95rem;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            margin-bottom: var(--space-md);
        }

        .pros-title {
            color: var(--color-puce);
        }

        .cons-title {
            color: var(--color-rose-quartz);
        }

        .pros-list, .cons-list {
            list-style: none;
            margin-bottom: var(--space-lg);
        }

        .pro-item, .con-item {
            padding: var(--space-sm) 0;
            color: var(--color-text-soft);
            display: flex;
            gap: var(--space-md);
            align-items: flex-start;
        }

        .pro-icon, .con-icon {
            flex-shrink: 0;
            margin-top: 4px;
        }

        .pro-icon {
            color: var(--color-puce);
            font-weight: 700;
        }

        .con-icon {
            color: var(--color-rose-quartz);
            font-weight: 700;
        }

        .impact-score {
            padding: var(--space-lg);
            background: var(--glass-overlay);
            border-radius: var(--radius-md);
            border: 1px solid var(--glass-border);
        }

        .impact-label {
            color: var(--color-text-muted);
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            margin-bottom: var(--space-sm);
        }

        .impact-bar {
            height: 8px;
            background: var(--glass-overlay);
            border-radius: var(--radius-xl);
            overflow: hidden;
            border: 1px solid var(--glass-border);
            margin-bottom: var(--space-md);
        }

        .impact-fill {
            height: 100%;
            background: var(--gradient-button);
        }

        .impact-details {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: var(--space-md);
        }

        .impact-metric {
            text-align: center;
        }

        .metric-value {
            color: var(--color-puce);
            font-weight: 700;
            font-size: 1.3rem;
        }

        .metric-text {
            color: var(--color-text-muted);
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }

        .recommendation-box {
            background: linear-gradient(135deg, rgba(191, 113, 133, 0.15) 0%, rgba(169, 159, 191, 0.1) 100%);
            border: 2px solid var(--color-puce);
            border-radius: var(--radius-lg);
            padding: var(--space-lg);
            animation: slideUp 0.6s ease-out;
        }

        .rec-title {
            color: var(--color-puce);
            font-weight: 700;
            font-size: 1rem;
            text-transform: uppercase;
            letter-spacing: 0.4px;
            margin-bottom: var(--space-md);
            display: flex;
            align-items: center;
            gap: var(--space-sm);
        }

        .rec-content {
            color: var(--color-text-soft);
            line-height: 1.8;
            font-size: 0.95rem;
        }

        .action-buttons {
            display: flex;
            gap: var(--space-lg);
            margin-top: var(--space-xl);
            flex-wrap: wrap;
        }

        .btn-choose {
            flex: 1;
            min-width: 200px;
            padding: var(--space-lg) var(--space-xl);
            background: var(--color-puce);
            color: #FFF;
            border: none;
            border-radius: var(--radius-md);
            font-weight: 700;
            cursor: pointer;
            font-size: 0.95rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            transition: all var(--transition-base);
            box-shadow: var(--shadow-glow);
        }

        .btn-choose:hover {
            transform: translateY(-4px);
            box-shadow: 0 0 40px rgba(191, 113, 133, 0.5);
        }

        .btn-reconsider {
            flex: 1;
            min-width: 200px;
            padding: var(--space-lg) var(--space-xl);
            background: transparent;
            color: var(--color-rose-quartz);
            border: 2px solid var(--color-rose-quartz);
            border-radius: var(--radius-md);
            font-weight: 700;
            cursor: pointer;
            font-size: 0.95rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            transition: all var(--transition-base);
        }

        .btn-reconsider:hover {
            background: var(--color-rose-quartz);
            color: #FFF;
        }

        @media (max-width: 768px) {
            .comparison-grid {
                grid-template-columns: 1fr;
            }

            .action-buttons {
                flex-direction: column;
            }

            .btn-choose, .btn-reconsider {
                min-width: auto;
            }
        }
    </style>
</head>
<body>
    <header style="background: linear-gradient(135deg, #443C5E 0%, #3D2B27 100%); padding: var(--space-lg); margin-bottom: var(--space-xl);">
        <a href="dashboard_complete.jsp" style="color: var(--color-pale-dogwood); text-decoration: none; font-weight: 700; display: flex; align-items: center; gap: var(--space-sm); width: fit-content;">
            <span>← Back to Dashboard</span>
        </a>
    </header>
    <div class="decision-page">
        <div class="decision-container">
            <div class="decision-header">
                <h1 class="decision-title">🎯 Decision & Conflict Navigator</h1>
                <p class="decision-subtitle">AI-assisted decision making for life's important choices</p>
            </div>

            <div class="decision-scenario">
                <div class="scenario-header">
                    <div class="scenario-title">Should I Change Jobs?</div>
                    <div class="scenario-context">
                        You've been offered a position at a new company with 25% higher salary but more demanding responsibilities. Your current role is comfortable but stagnant. Let's analyze both paths.
                    </div>
                </div>
            </div>

            <div class="comparison-grid">
                <!-- Option A: New Job -->
                <div class="option-card recommended">
                    <span class="option-badge">Recommended by AI</span>

                    <div class="option-name">✓ Option A: Accept New Job</div>

                    <div class="pros-cons">
                        <div class="pros-title">Advantages</div>
                        <ul class="pros-list">
                            <li class="pro-item">
                                <span class="pro-icon">+</span>
                                <span>Career growth and skill development</span>
                            </li>
                            <li class="pro-item">
                                <span class="pro-icon">+</span>
                                <span>25% salary increase improves financial security</span>
                            </li>
                            <li class="pro-item">
                                <span class="pro-icon">+</span>
                                <span>Fresh environment reduces stagnation</span>
                            </li>
                            <li class="pro-item">
                                <span class="pro-icon">+</span>
                                <span>New challenge boosts motivation and engagement</span>
                            </li>
                            <li class="pro-item">
                                <span class="pro-icon">+</span>
                                <span>Stronger resume for future opportunities</span>
                            </li>
                        </ul>
                    </div>

                    <div class="pros-cons">
                        <div class="cons-title">Considerations</div>
                        <ul class="cons-list">
                            <li class="con-item">
                                <span class="con-icon">-</span>
                                <span>Initial stress from adjustment period (6-8 weeks)</span>
                            </li>
                            <li class="con-item">
                                <span class="con-icon">-</span>
                                <span>Higher workload may impact work-life balance</span>
                            </li>
                            <li class="con-item">
                                <span class="con-icon">-</span>
                                <span>Leaving established relationships and network</span>
                            </li>
                            <li class="con-item">
                                <span class="con-icon">-</span>
                                <span>Company culture uncertainty</span>
                            </li>
                        </ul>
                    </div>

                    <div class="impact-score">
                        <div class="impact-label">Long-term Impact Score</div>
                        <div class="impact-bar">
                            <div class="impact-fill" style="width: 78%;"></div>
                        </div>
                        <div class="impact-details">
                            <div class="impact-metric">
                                <div class="metric-value">+32%</div>
                                <div class="metric-text">Growth Potential</div>
                            </div>
                            <div class="impact-metric">
                                <div class="metric-value">-18%</div>
                                <div class="metric-text">Stability Impact</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Option B: Stay -->
                <div class="option-card">
                    <span class="option-badge" style="background: var(--color-rose-quartz);">Less Optimal</span>

                    <div class="option-name">✗ Option B: Stay at Current Job</div>

                    <div class="pros-cons">
                        <div class="pros-title">Advantages</div>
                        <ul class="pros-list">
                            <li class="pro-item">
                                <span class="pro-icon">+</span>
                                <span>Comfortable, predictable work environment</span>
                            </li>
                            <li class="pro-item">
                                <span class="pro-icon">+</span>
                                <span>Established relationships with colleagues</span>
                            </li>
                            <li class="pro-item">
                                <span class="pro-icon">+</span>
                                <span>No adjustment stress or learning curve</span>
                            </li>
                            <li class="pro-item">
                                <span class="pro-icon">+</span>
                                <span>Better work-life balance (currently)</span>
                            </li>
                            <li class="pro-item">
                                <span class="pro-icon">+</span>
                                <span>Known salary and benefits</span>
                            </li>
                        </ul>
                    </div>

                    <div class="pros-cons">
                        <div class="cons-title">Considerations</div>
                        <ul class="cons-list">
                            <li class="con-item">
                                <span class="con-icon">-</span>
                                <span>Career stagnation continues</span>
                            </li>
                            <li class="con-item">
                                <span class="con-icon">-</span>
                                <span>Missing financial growth opportunity</span>
                            </li>
                            <li class="con-item">
                                <span class="con-icon">-</span>
                                <span>Declining motivation and engagement</span>
                            </li>
                            <li class="con-item">
                                <span class="con-icon">-</span>
                                <span>Reduced marketability over time</span>
                            </li>
                            <li class="con-item">
                                <span class="con-icon">-</span>
                                <span>Possible regret about missed opportunity</span>
                            </li>
                        </ul>
                    </div>

                    <div class="impact-score">
                        <div class="impact-label">Long-term Impact Score</div>
                        <div class="impact-bar">
                            <div class="impact-fill" style="width: 35%; background: var(--color-rose-quartz);"></div>
                        </div>
                        <div class="impact-details">
                            <div class="impact-metric">
                                <div class="metric-value">-12%</div>
                                <div class="metric-text">Growth Potential</div>
                            </div>
                            <div class="impact-metric">
                                <div class="metric-value">+45%</div>
                                <div class="metric-text">Stability Factor</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="recommendation-box">
                <div class="rec-title">
                    <span>💡 AI Recommendation</span>
                </div>
                <div class="rec-content">
                    <p><strong>Accept the new position.</strong> Based on your emotional patterns and career trajectory data, you thrive on growth and challenge. Your anxiety about job transitions typically diminishes after 4-6 weeks, and the long-term happiness gains outweigh short-term discomfort. The salary increase also provides financial security you've expressed valuing. Recommend negotiating flexible work arrangements to maintain some work-life balance during the transition.</p>
                </div>
            </div>

            <div class="action-buttons">
                <button class="btn-choose">✓ Choose Option A</button>
                <button class="btn-reconsider">⟲ Reconsider</button>
            </div>
        </div>
    </div>
</body>
</html>

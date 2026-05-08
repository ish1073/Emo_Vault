<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Date" %>
<%
    Integer expertId = (Integer) session.getAttribute("expertId");
    String expertName = (String) session.getAttribute("expertName");
    String expertRole = (String) session.getAttribute("expertRole");
    
    if (expertId == null) {
        response.sendRedirect(request.getContextPath() + "/expert_login.jsp?error=expired");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Expert Dashboard - EmoVault</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/design-system.css">
    <style>
        body { background: linear-gradient(135deg, var(--color-sandstone) 0%, var(--color-off-white) 100%); }
        .expert-dashboard-wrapper { min-height: 100vh; }
        .expert-navbar { background: rgba(230, 212, 191, 0.6); backdrop-filter: var(--backdrop-glass); padding: var(--spacing-lg) 0; position: sticky; top: 0; z-index: var(--z-sticky); }
        .expert-navbar-container { max-width: 1400px; margin: 0 auto; padding: 0 var(--spacing-xl); display: flex; justify-content: space-between; align-items: center; }
        .expert-navbar-brand { display: flex; align-items: center; gap: var(--spacing-md); font-family: var(--font-serif); font-size: var(--font-h3); font-weight: 700; color: var(--color-heather); text-decoration: none; }
        .expert-navbar-brand:hover { opacity: 0.85; }
        .expert-navbar-menu { display: flex; align-items: center; gap: var(--spacing-xl); }
        .expert-navbar-menu a { color: var(--color-azur); text-decoration: none; font-size: 14px; font-weight: 500; transition: all var(--transition-normal); padding: var(--spacing-sm) var(--spacing-md); border-radius: var(--radius-md); }
        .expert-navbar-menu a:hover, .expert-navbar-menu a.active { background: rgba(103, 159, 159, 0.1); color: var(--color-viridian); }
        .expert-navbar-user { display: flex; align-items: center; gap: var(--spacing-lg); color: var(--color-heather); font-size: 13px; }
        .expert-navbar-user .user-info { text-align: right; }
        .user-name { font-weight: 600; font-size: 14px; }
        .user-role { font-size: 12px; opacity: 0.7; }
        .logout-btn { background: rgba(135, 116, 153, 0.15); color: var(--color-heather); border: 1px solid rgba(135, 116, 153, 0.3); padding: var(--spacing-sm) var(--spacing-md); border-radius: var(--radius-lg); font-size: 12px; cursor: pointer; transition: all var(--transition-normal); text-decoration: none; display: inline-block; font-weight: 600; }
        .logout-btn:hover { background: rgba(135, 116, 153, 0.25); border-color: rgba(135, 116, 153, 0.5); }
        .expert-dashboard-container { max-width: 1400px; margin: 0 auto; padding: var(--spacing-3xl) var(--spacing-xl); }
        .dashboard-header { margin-bottom: var(--spacing-3xl); }
        .dashboard-title { font-family: var(--font-serif); font-size: var(--font-h1); color: var(--color-heather); margin-bottom: var(--spacing-md); font-weight: 700; }
        .dashboard-subtitle { font-size: 16px; color: var(--color-azur); line-height: var(--line-height-normal); }
        .expert-cards-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: var(--spacing-2xl); margin-bottom: var(--spacing-3xl); }
        .expert-card { background: rgba(230, 212, 191, 0.6); backdrop-filter: var(--backdrop-glass); border-left: 4px solid var(--color-candy); border-radius: var(--radius-xl); padding: var(--spacing-2xl); border: 1px solid rgba(135, 116, 153, 0.2); box-shadow: var(--shadow-medium); transition: all var(--transition-normal); animation: slideInUp 0.6s ease; }
        .expert-card:hover { transform: translateY(-4px); box-shadow: var(--shadow-large); }
        .card-icon { font-size: 32px; margin-bottom: var(--spacing-md); }
        .card-title { font-family: var(--font-serif); font-size: 18px; font-weight: 700; color: var(--color-heather); margin-bottom: var(--spacing-sm); }
        .card-description { font-size: 13px; color: var(--color-azur); line-height: var(--line-height-normal); margin-bottom: var(--spacing-md); }
        .card-stat { font-size: 28px; font-weight: 700; color: var(--color-viridian); margin: var(--spacing-lg) 0; }
        .card-link { display: inline-block; color: var(--color-heather); text-decoration: none; font-size: 13px; font-weight: 600; transition: all var(--transition-normal); }
        .card-link:hover { color: var(--color-candy); }
        .content-section { background: rgba(230, 212, 191, 0.6); backdrop-filter: var(--backdrop-glass); border-radius: var(--radius-xl); padding: var(--spacing-2xl); box-shadow: var(--shadow-medium); margin-bottom: var(--spacing-2xl); border: 1px solid rgba(135, 116, 153, 0.2); animation: slideInUp 0.6s ease; }
        .section-title { font-family: var(--font-serif); font-size: 22px; font-weight: 700; color: var(--color-heather); margin-bottom: var(--spacing-2xl); padding-bottom: var(--spacing-lg); border-bottom: 2px solid var(--color-candy); }
        .info-box { background: rgba(135, 116, 153, 0.1); border-left: 4px solid var(--color-candy); padding: var(--spacing-lg); border-radius: var(--radius-lg); margin: var(--spacing-lg) 0; font-size: 13px; line-height: var(--line-height-loose); color: var(--color-azur); }
        .feature-list { list-style: none; padding: 0; }
        .feature-list li { padding: var(--spacing-md) 0; padding-left: 25px; position: relative; color: var(--color-azur); font-size: 14px; line-height: var(--line-height-normal); }
        .feature-list li::before { content: '✓'; position: absolute; left: 0; color: var(--color-candy); font-weight: 700; }
        .action-buttons { display: flex; gap: var(--spacing-lg); flex-wrap: wrap; margin-top: var(--spacing-2xl); }
        .btn-primary, .btn-secondary { padding: var(--spacing-md) var(--spacing-xl); border: none; border-radius: var(--radius-lg); font-size: 14px; font-weight: 600; cursor: pointer; text-decoration: none; display: inline-block; transition: all var(--transition-normal); text-transform: uppercase; letter-spacing: 0.5px; }
        .btn-primary { background: var(--color-viridian); color: white; }
        .btn-primary:hover { background: linear-gradient(135deg, var(--color-viridian) 0%, var(--color-azur) 100%); transform: translateY(-2px); box-shadow: var(--shadow-large); }
        .btn-secondary { background: rgba(135, 116, 153, 0.2); color: var(--color-heather); border: 2px solid var(--color-candy); }
        .btn-secondary:hover { background: rgba(135, 116, 153, 0.3); transform: translateY(-2px); }
        @media (max-width: 768px) { .expert-cards-grid { grid-template-columns: 1fr; } .dashboard-title { font-size: 28px;
            }

            .expert-navbar-menu {
                gap: 15px;
                font-size: 12px;
            }
        }
    </style>
</head>
<body>
    <div class="expert-dashboard-wrapper">
        <!-- Expert Navbar -->
        <div class="expert-navbar">
            <div class="expert-navbar-container">
                <div class="expert-navbar-brand">
                    🤖 EmoVault Expert System
                </div>
                <div class="expert-navbar-menu">
                    <a href="${pageContext.request.contextPath}/expert_dashboard" class="active">Dashboard</a>
                    <a href="${pageContext.request.contextPath}/expert_analytics">Analytics</a>
                    <a href="${pageContext.request.contextPath}/expert_rules">Rules Manager</a>
                    <a href="${pageContext.request.contextPath}/expert_settings">Settings</a>
                </div>
                <div class="expert-navbar-user">
                    <div class="user-info">
                        <div class="user-name"><%= expertName != null ? expertName : "Expert" %></div>
                        <div class="user-role"><%= expertRole != null ? expertRole : "System" %></div>
                    </div>
                    <form method="POST" action="${pageContext.request.contextPath}/expert_login" style="margin: 0;">
                        <input type="hidden" name="action" value="logout">
                        <button type="submit" class="logout-btn">Logout</button>
                    </form>
                </div>
            </div>
        </div>

        <!-- Dashboard Content -->
        <div class="expert-dashboard-container">
            <!-- Header -->
            <div class="dashboard-header">
                <h1 class="dashboard-title">🎯 Expert System Dashboard</h1>
                <p class="dashboard-subtitle">Monitor and manage emotional intelligence insights across the EmoVault platform</p>
            </div>

            <!-- Quick Stats -->
            <div class="expert-cards-grid">
                <div class="expert-card">
                    <div class="card-icon">📊</div>
                    <div class="card-title">Active Users</div>
                    <div class="card-description">Users with recent emotional entries</div>
                    <div class="card-stat">—</div>
                    <a href="#" class="card-link">View Users →</a>
                </div>

                <div class="expert-card">
                    <div class="card-icon">⚠️</div>
                    <div class="card-title">Risk Alerts</div>
                    <div class="card-description">High-priority pattern detections</div>
                    <div class="card-stat">—</div>
                    <a href="#" class="card-link">View Alerts →</a>
                </div>

                <div class="expert-card">
                    <div class="card-icon">🔄</div>
                    <div class="card-title">Pattern Analysis</div>
                    <div class="card-description">Emotional and behavioral patterns</div>
                    <div class="card-stat">—</div>
                    <a href="#" class="card-link">View Patterns →</a>
                </div>

                <div class="expert-card">
                    <div class="card-icon">💡</div>
                    <div class="card-title">Suggestions</div>
                    <div class="card-description">Expert-generated insights</div>
                    <div class="card-stat">—</div>
                    <a href="#" class="card-link">Manage Rules →</a>
                </div>
            </div>

            <!-- Welcome Section -->
            <div class="content-section">
                <h2 class="section-title">👋 Welcome to the Expert System</h2>
                
                <p style="margin-bottom: 20px; color: var(--color-text-light); line-height: 1.8;">
                    You are now logged into the Expert System - a rule-based intelligence engine designed to provide 
                    actionable insights and suggestions to EmoVault users. As an Expert System administrator, you have 
                    access to comprehensive analytics, pattern detection, and system management features.
                </p>

                <div class="info-box">
                    <strong>ℹ️ System Status:</strong> Expert System is active and monitoring user patterns in real-time. 
                    The system generates suggestions based on detected emotional trends and behavioral patterns.
                </div>

                <h3 style="margin-top: 30px; margin-bottom: 15px; color: var(--color-sage); font-weight: 600;">
                    📋 Your Expert System Features:
                </h3>

                <ul class="feature-list">
                    <li><strong>Dashboard:</strong> Real-time overview of system metrics and user patterns</li>
                    <li><strong>Analytics:</strong> Detailed analysis of emotional trends, patterns, and user behaviors</li>
                    <li><strong>Rules Manager:</strong> Create, edit, and manage expert suggestion rules</li>
                    <li><strong>Risk Alerts:</strong> Monitor high-priority risk detections and patterns</li>
                    <li><strong>User Insights:</strong> View aggregated data about user emotional states</li>
                    <li><strong>Activity Logs:</strong> Track all expert system actions and recommendations</li>
                    <li><strong>Settings:</strong> Configure system parameters and preferences</li>
                    <li><strong>Reports:</strong> Generate comprehensive pattern analysis reports</li>
                </ul>

                <div class="info-box" style="margin-top: 25px; border-left-color: var(--color-avocado);">
                    <strong>🔒 Privacy & Security:</strong> All user data is handled securely. The Expert System only 
                    analyzes patterns and generates suggestions - no personal data is disclosed in reports.
                </div>

                <h3 style="margin-top: 30px; margin-bottom: 15px; color: var(--color-sage); font-weight: 600;">
                    🚀 Quick Actions:
                </h3>

                <div class="action-buttons">
                    <a href="#" class="btn-primary">📊 View Analytics</a>
                    <a href="#" class="btn-primary">⚠️ Check Alerts</a>
                    <a href="#" class="btn-secondary">⚙️ Configure Rules</a>
                </div>
            </div>

            <!-- Expert System Info -->
            <div class="content-section">
                <h2 class="section-title">ℹ️ About the Expert System</h2>
                
                <p style="margin-bottom: 15px; color: var(--color-text-light); line-height: 1.8;">
                    The Expert System is an intelligent, rule-based engine designed to help users understand their 
                    emotional patterns and make better decisions about their mental health. Unlike machine learning systems, 
                    the Expert System uses predefined rules and heuristics to generate suggestions and alerts.
                </p>

                <div class="info-box">
                    <strong>🎯 Core Principles:</strong><br>
                    • Rule-based (not ML) - Transparent and explainable<br>
                    • Pattern detection - Identifies recurring behaviors<br>
                    • Risk assessment - Evaluates severity levels<br>
                    • Actionable insights - Provides specific recommendations<br>
                    • User-centric - Focuses on user wellbeing<br>
                </div>

                <h3 style="margin-top: 20px; margin-bottom: 15px; color: var(--color-sage); font-weight: 600;">
                    🔧 System Capabilities:
                </h3>

                <ul class="feature-list">
                    <li>Detects 8+ issue types (procrastination, stress, overthinking, etc.)</li>
                    <li>Generates 7+ risk alert categories with severity levels</li>
                    <li>Provides mood-specific advice for 7 mood types</li>
                    <li>Analyzes behavioral patterns from emotion entries</li>
                    <li>Tracks habit formation and consistency</li>
                    <li>Monitors user engagement and progression</li>
                    <li>Generates comprehensive pattern reports</li>
                    <li>Supports multi-language suggestions (future)</li>
                </ul>

                <div class="info-box" style="border-left-color: #4a90e2;">
                    <strong>📚 Documentation:</strong> For more information about managing the Expert System, 
                    refer to the Administrator Guide in your system documentation.
                </div>
            </div>
        </div>
    </div>
</body>
</html>

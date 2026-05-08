<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EmoVault - Sign In</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="modern-design-system.css">
    <style>
        .login-page {
            position: relative;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: var(--space-lg);
            overflow: hidden;
        }

        .login-container {
            position: relative;
            z-index: 10;
            width: 100%;
            max-width: 480px;
        }

        .login-card {
            background: var(--bg-card);
            backdrop-filter: var(--blur-light);
            border: 1px solid var(--color-border-light);
            border-radius: var(--radius-2xl);
            padding: var(--space-3xl);
            animation: slideInCard 0.8s ease-out 0.2s both;
            position: relative;
            overflow: hidden;
            box-shadow: var(--shadow-lg);
        }

        .login-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: var(--gradient-accent);
            border-radius: var(--radius-2xl) var(--radius-2xl) 0 0;
        }

        .login-card::after {
            content: '';
            position: absolute;
            inset: 0;
            background: var(--gradient-card-overlay);
            pointer-events: none;
            border-radius: var(--radius-2xl);
        }

        @keyframes slideInCard {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .login-card > * {
            position: relative;
            z-index: 2;
        }

        .login-header {
            text-align: center;
            margin-bottom: var(--space-xl);
        }

        .login-header h1 {
            font-size: var(--text-3xl);
            font-family: var(--font-secondary);
            color: var(--color-text-primary);
            margin-bottom: var(--space-sm);
            font-weight: var(--fw-bold);
            letter-spacing: -0.5px;
        }

        .login-header .tagline {
            font-size: var(--text-sm);
            color: var(--color-rose-quartz);
            letter-spacing: 1px;
            font-weight: var(--fw-medium);
            text-transform: uppercase;
        }

        .login-title {
            text-align: center;
            color: var(--color-text-primary);
            font-size: var(--text-2xl);
            margin-bottom: var(--space-md);
            font-weight: var(--fw-bold);
            font-family: var(--font-secondary);
        }

        .login-subtitle {
            text-align: center;
            color: var(--color-text-secondary);
            font-size: var(--text-sm);
            margin-bottom: var(--space-2xl);
            line-height: 1.6;
            font-weight: var(--fw-regular);
            opacity: 0.85;
        }

        .form-section {
            margin-bottom: var(--space-lg);
        }

        .form-group {
            margin-bottom: var(--space-lg);
        }

        .form-group label {
            display: block;
            font-size: var(--text-xs);
            font-weight: var(--fw-semibold);
            color: var(--color-text-primary);
            margin-bottom: var(--space-sm);
            text-transform: uppercase;
            letter-spacing: 0.6px;
        }

        .form-group input {
            width: 100%;
            padding: var(--space-md) var(--space-lg);
            font-family: var(--font-primary);
            font-size: var(--text-base);
            background: rgba(226, 194, 188, 0.2);
            border: 1px solid var(--color-border-light);
            border-radius: var(--radius-md);
            color: var(--color-text-secondary);
            transition: all var(--transition-base);
            backdrop-filter: var(--blur-light);
        }

        .form-group input::placeholder {
            color: var(--color-text-muted);
            opacity: 0.7;
        }

        .form-group input:focus {
            outline: none;
            background: rgba(226, 194, 188, 0.3);
            border-color: var(--color-puce);
            box-shadow: 0 0 0 3px rgba(191, 113, 133, 0.15);
            transform: translateY(-2px);
        }

        .checkbox-group {
            display: flex;
            align-items: center;
            gap: var(--space-md);
            margin-bottom: var(--space-lg);
        }

        .checkbox-group input[type="checkbox"] {
            width: 20px;
            height: 20px;
            cursor: pointer;
            accent-color: var(--color-puce);
            transition: all var(--transition-base);
        }

        .checkbox-group input[type="checkbox"]:hover {
            box-shadow: 0 0 0 3px rgba(191, 113, 133, 0.2);
        }

        .checkbox-group label {
            margin: 0;
            font-weight: var(--fw-medium);
            font-size: var(--text-sm);
            color: var(--color-text-secondary);
            cursor: pointer;
        }

        .forgot-password {
            text-align: right;
            margin-bottom: var(--space-lg);
        }

        .forgot-password a {
            font-size: var(--text-xs);
            color: var(--color-puce);
            text-decoration: none;
            font-weight: var(--fw-semibold);
            transition: all var(--transition-base);
            position: relative;
        }

        .forgot-password a:hover {
            color: var(--color-text-primary);
            text-decoration: underline;
        }

        .forgot-password a:focus {
            outline: 2px solid var(--color-puce);
            outline-offset: 2px;
        }

        .login-button {
            width: 100%;
            padding: var(--space-lg) var(--space-xl);
            background: var(--gradient-button);
            color: #FFFFFF;
            border: none;
            border-radius: var(--radius-md);
            font-family: var(--font-primary);
            font-size: var(--text-base);
            font-weight: var(--fw-semibold);
            cursor: pointer;
            transition: all var(--transition-base);
            letter-spacing: 0.6px;
            text-transform: uppercase;
            margin-bottom: var(--space-xl);
            box-shadow: 0 8px 24px rgba(191, 113, 133, 0.3);
            position: relative;
            overflow: hidden;
        }

        .login-button::before {
            content: '';
            position: absolute;
            inset: 0;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.2) 0%, transparent 70%);
            opacity: 0;
            transition: opacity var(--transition-base);
        }

        .login-button:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 32px rgba(191, 113, 133, 0.4);
        }

        .login-button:hover::before {
            opacity: 1;
        }

        .login-button:active {
            transform: translateY(-1px);
            box-shadow: 0 6px 16px rgba(191, 113, 133, 0.3);
        }

        .login-button:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            transform: none;
        }

        .login-footer {
            text-align: center;
            padding-top: var(--space-lg);
            border-top: 1px solid var(--color-border-light);
        }

        .login-footer p {
            color: var(--color-text-secondary);
            font-size: var(--text-sm);
            margin-bottom: var(--space-sm);
            line-height: 1.6;
            opacity: 0.85;
        }

        .login-footer a {
            color: var(--color-puce);
            text-decoration: none;
            font-weight: var(--fw-semibold);
            transition: all var(--transition-base);
            position: relative;
        }

        .login-footer a:hover {
            color: var(--color-text-primary);
            text-decoration: underline;
        }

        .login-footer a:focus {
            outline: 2px solid var(--color-puce);
            outline-offset: 2px;
        }

        .expert-link {
            text-align: center;
            margin-top: var(--space-lg);
            padding-top: var(--space-lg);
            border-top: 1px solid var(--color-border-light);
        }

        .expert-link a {
            display: inline-block;
            font-size: var(--text-xs);
            color: var(--color-rose-quartz);
            text-decoration: none;
            transition: all var(--transition-base);
            font-weight: var(--fw-semibold);
            text-transform: uppercase;
            letter-spacing: 0.6px;
        }

        .expert-link a:hover {
            color: var(--color-puce);
            text-decoration: underline;
            transform: translateY(-2px);
        }

        .expert-link a:focus {
            outline: 2px solid var(--color-puce);
            outline-offset: 2px;
        }

        .alert {
            padding: var(--space-lg);
            border-radius: var(--radius-md);
            margin-bottom: var(--space-xl);
            border-left: 4px solid;
            animation: slideInAlert 0.4s var(--transition-cubic);
            display: flex;
            gap: var(--space-md);
            align-items: flex-start;
        }

        @keyframes slideInAlert {
            from {
                opacity: 0;
                transform: translateX(-20px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .alert-error {
            background: rgba(191, 113, 133, 0.15);
            border-left-color: var(--color-danger);
            color: var(--color-text-secondary);
        }

        .alert-success {
            background: rgba(191, 113, 133, 0.12);
            border-left-color: var(--color-success);
            color: var(--color-text-secondary);
        }

        .alert-warning {
            background: rgba(212, 181, 173, 0.12);
            border-left-color: var(--color-warning);
            color: var(--color-text-secondary);
        }

        @media (max-width: 640px) {
            .login-card {
                padding: var(--space-xl) var(--space-lg);
                border-radius: var(--radius-xl);
            }

            .login-title {
                font-size: var(--text-xl);
            }

            .login-header h1 {
                font-size: var(--text-2xl);
            }

            .login-page {
                padding: var(--space-lg);
            }

            .form-group input {
                padding: var(--space-md) var(--space-lg);
                font-size: var(--text-sm);
            }

            .login-button {
                padding: var(--space-md) var(--space-lg);
            }
        }
    </style>
</head>
<body>
    <div class="login-page">
        <div class="login-container">
            <div class="login-card">
                <!-- Header -->
                <div class="login-header">
                    <h1>✨ EmoVault</h1>
                    <p class="tagline">Your Personal Emotional Wellness Journal</p>
                </div>

                <!-- Main Content -->
                <div>
                    <h2 class="login-title">Welcome Back</h2>
                    <p class="login-subtitle">Sign in to continue your emotional journey of self-reflection and growth.</p>

                    <!-- Error Message -->
                    <% if (request.getAttribute("error") != null) { %>
                        <div class="alert alert-error">
                            <%= request.getAttribute("error") %>
                        </div>
                    <% } %>

                    <!-- Success Message -->
                    <% if (request.getAttribute("success") != null) { %>
                        <div class="alert alert-success">
                            <%= request.getAttribute("success") %>
                        </div>
                    <% } %>

                    <!-- Login Form -->
                    <form action="${pageContext.request.contextPath}/login" method="post" class="form-section">
                        <div class="form-group">
                            <label for="email">Email Address</label>
                            <input 
                                type="email" 
                                id="email" 
                                name="email" 
                                placeholder="your@email.com" 
                                required
                                autocomplete="email">
                        </div>

                        <div class="form-group">
                            <label for="password">Password</label>
                            <input 
                                type="password" 
                                id="password" 
                                name="password" 
                                placeholder="••••••••" 
                                required
                                autocomplete="current-password">
                        </div>

                        <div class="checkbox-group">
                            <input type="checkbox" id="remember" name="remember">
                            <label for="remember">Remember me</label>
                        </div>

                        <div class="forgot-password">
                            <a href="${pageContext.request.contextPath}/forgot-password">Forgot password?</a>
                        </div>

                        <button type="submit" class="login-button">Sign In</button>
                    </form>
                </div>

                <!-- Footer -->
                <div class="login-footer">
                    <p>Don't have an account? <a href="${pageContext.request.contextPath}/register">Create one</a></p>
                    <div class="expert-link">
                        <a href="${pageContext.request.contextPath}/expert_login.jsp">🤖 Expert System Login</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

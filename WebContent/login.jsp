<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EmoVault - Sign In</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/design-system.css">
    <style>
        body {
            background: var(--gradient-bg-primary);
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
            padding: var(--space-3xl) var(--space-lg);
            margin: 0;
        }

        .page-title {
            text-align: center;
            margin-top: var(--space-2xl);
            margin-bottom: var(--space-3xl);
            width: 100%;
        }

        .page-title h1 {
            font-size: var(--font-size-4xl);
            color: var(--color-heather);
            font-family: var(--font-secondary);
            font-weight: 700;
            text-transform: capitalize;
            letter-spacing: -0.5px;
        }

        .login-container {
            width: 100%;
            max-width: 440px;
            animation: fade-in-up 0.8s ease-out;
            margin-bottom: var(--space-3xl);
        }

        .login-card {
            background: var(--color-white);
            border-radius: var(--radius-2xl);
            padding: var(--space-2xl);
            box-shadow: var(--shadow-lg);
            border: 1px solid rgba(230, 212, 191, 0.3);
        }

        .login-header {
            text-align: center;
            margin-bottom: var(--space-2xl);
        }

        .login-header h1 {
            font-size: var(--font-size-3xl);
            color: var(--color-heather);
            margin: 0 0 var(--space-md) 0;
            font-family: var(--font-secondary);
        }

        .login-header .tagline {
            font-size: var(--font-size-sm);
            color: var(--color-warm-gray);
            line-height: var(--line-height-normal);
            margin: 0;
        }

        .alert {
            padding: var(--space-lg);
            border-radius: var(--radius-lg);
            margin-bottom: var(--space-lg);
            border-left: 4px solid;
            animation: fade-in-up 0.4s ease-out;
            font-weight: var(--font-weight-medium);
            font-size: var(--font-size-sm);
        }

        .alert-error {
            background: #FCE4E9;
            border-left-color: var(--color-candy);
            color: #C91D5F;
        }

        .alert-success {
            background: #E8F5E9;
            border-left-color: var(--color-viridian);
            color: #1B5E20;
        }

        .form-group {
            margin-bottom: var(--space-lg);
        }

        .form-group label {
            display: block;
            font-weight: var(--font-weight-medium);
            color: var(--color-heather);
            margin-bottom: var(--space-sm);
            font-size: var(--font-size-sm);
        }

        .form-group input {
            width: 100%;
            padding: var(--space-md) var(--space-lg);
            font-family: var(--font-primary);
            font-size: var(--font-size-base);
            background: var(--color-cream);
            border: 2px solid var(--color-warm-gray);
            border-radius: var(--radius-md);
            color: var(--color-azur);
            transition: all var(--transition-base);
            box-sizing: border-box;
        }

        .form-group input::placeholder {
            color: var(--color-warm-gray);
        }

        .form-group input:focus {
            outline: none;
            background: var(--color-white);
            border-color: var(--color-viridian);
            box-shadow: 0 0 0 3px rgba(103, 159, 159, 0.1);
        }

        .checkbox-group {
            display: flex;
            align-items: center;
            gap: var(--space-md);
            margin-bottom: var(--space-lg);
        }

        .checkbox-group input[type="checkbox"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
            accent-color: var(--color-viridian);
        }

        .checkbox-group label {
            margin: 0;
            font-weight: var(--font-weight-medium);
            font-size: var(--font-size-sm);
            color: var(--color-azur);
            cursor: pointer;
        }

        .forgot-password {
            text-align: right;
            margin-bottom: var(--space-xl);
        }

        .forgot-password a {
            font-size: var(--font-size-sm);
            color: var(--color-viridian);
            text-decoration: none;
            font-weight: var(--font-weight-medium);
            transition: color var(--transition-base);
        }

        .forgot-password a:hover {
            color: var(--color-candy);
        }

        .login-button {
            width: 100%;
            padding: var(--space-md) var(--space-xl);
            background: var(--color-viridian);
            color: white;
            border: none;
            border-radius: var(--radius-lg);
            font-family: var(--font-primary);
            font-size: var(--font-size-base);
            font-weight: var(--font-weight-semibold);
            cursor: pointer;
            transition: all var(--transition-base);
            margin-bottom: var(--space-lg);
            box-shadow: var(--shadow-md);
        }

        .login-button:hover {
            background: #5F8A8A;
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }

        .login-button:active {
            transform: translateY(0);
        }

        .login-footer {
            text-align: center;
            padding-top: var(--space-lg);
            border-top: 1px solid var(--color-warm-gray);
        }

        .login-footer p {
            color: var(--color-azur);
            font-size: var(--font-size-sm);
            margin: 0 0 var(--space-sm) 0;
            line-height: var(--line-height-normal);
        }

        .login-footer a {
            color: var(--color-viridian);
            text-decoration: none;
            font-weight: var(--font-weight-semibold);
            transition: color var(--transition-base);
        }

        .login-footer a:hover {
            color: var(--color-candy);
        }

        .expert-link {
            text-align: center;
            margin-top: var(--space-lg);
            padding-top: var(--space-lg);
            border-top: 1px solid var(--color-warm-gray);
        }

        .expert-link a {
            display: inline-block;
            font-size: var(--font-size-sm);
            color: var(--color-heather);
            text-decoration: none;
            transition: color var(--transition-base);
            font-weight: var(--font-weight-medium);
        }

        .expert-link a:hover {
            color: var(--color-candy);
        }

        @media (max-width: 640px) {
            .page-title h1 {
                font-size: var(--font-size-2xl);
                margin-top: var(--space-lg);
            }

            .login-card {
                padding: var(--space-xl);
            }

            .login-header h1 {
                font-size: var(--font-size-2xl);
            }
        }
    </style>
</head>
<body>
    <div class="page-title">
        <h1>Sign In</h1>
    </div>

    <div class="login-container">
        <div class="login-card">
            <div class="login-header">
                <h1>✨ EmoVault</h1>
                <p class="tagline">A personal space for reflection and emotional growth</p>
            </div>

            <% 
                String alertMessage = (String) session.getAttribute("alertMessage");
                String alertType = (String) session.getAttribute("alertType");
                if (alertMessage != null) { 
                    String alertClass = "alert-error";
                    if ("success".equals(alertType)) {
                        alertClass = "alert-success";
                    }
            %>
                <div class="alert <%= alertClass %>">
                    <%= alertMessage %>
                </div>
            <% 
                    session.removeAttribute("alertMessage");
                    session.removeAttribute("alertType");
                }
            %>

            <form action="${pageContext.request.contextPath}/login_handler.jsp" method="post">
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input 
                        type="email" 
                        id="email" 
                        name="email" 
                        placeholder="you@example.com" 
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
                    <a href="#">Forgot password?</a>
                </div>

                <button type="submit" class="login-button">Sign In</button>
            </form>

            <div class="login-footer">
                <p>Don't have an account? <a href="${pageContext.request.contextPath}/register.jsp">Create one</a></p>
                <div class="expert-link">
                    <a href="${pageContext.request.contextPath}/expert_login.jsp">🧠 Expert System Login</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

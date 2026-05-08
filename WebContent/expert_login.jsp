<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Expert System - EmoVault</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/design-system.css">
    <style>
        body {
            background: var(--gradient-bg-primary);
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .login-container {
            width: 100%;
            max-width: 440px;
            padding: var(--space-lg);
        }

        .login-card {
            background: var(--color-white);
            border-radius: var(--radius-2xl);
            padding: var(--space-2xl);
            box-shadow: var(--shadow-lg);
            border: 1px solid rgba(230, 212, 191, 0.3);
            animation: fade-in-up 0.6s ease-out;
        }

        .login-header {
            text-align: center;
            margin-bottom: var(--space-2xl);
        }

        .login-title {
            font-size: var(--font-size-3xl);
            color: var(--color-heather);
            font-family: var(--font-secondary);
            margin-bottom: var(--space-md);
        }

        .login-subtitle {
            font-size: var(--font-size-base);
            color: var(--color-warm-gray);
        }

        .form-group {
            margin-bottom: var(--space-lg);
        }

        .form-label {
            display: block;
            font-weight: var(--font-weight-medium);
            color: var(--color-heather);
            margin-bottom: var(--space-md);
            font-size: var(--font-size-base);
        }

        .form-control {
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

        .form-control::placeholder {
            color: var(--color-warm-gray);
        }

        .form-control:focus {
            outline: none;
            background: var(--color-white);
            border-color: var(--color-viridian);
            box-shadow: 0 0 0 3px rgba(103, 159, 159, 0.1);
        }

        .submit-btn {
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
            box-shadow: var(--shadow-md);
            margin-bottom: var(--space-lg);
        }

        .submit-btn:hover {
            background: #5F8A8A;
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }

        .login-footer {
            text-align: center;
            font-size: var(--font-size-sm);
            color: var(--color-warm-gray);
        }

        .login-footer a {
            color: var(--color-viridian);
            text-decoration: none;
            font-weight: var(--font-weight-medium);
        }

        .error-message {
            background: #FCE4E9;
            border-left: 4px solid var(--color-candy);
            color: #C91D5F;
            padding: var(--space-lg);
            border-radius: var(--radius-lg);
            margin-bottom: var(--space-lg);
        }

        .success-message {
            background: #E8F5E9;
            border-left: 4px solid #4CAF50;
            color: #2E7D32;
            padding: var(--space-lg);
            border-radius: var(--radius-lg);
            margin-bottom: var(--space-lg);
        }

        @media (max-width: 768px) {
            .login-container {
                padding: var(--space-md);
            }

            .login-card {
                padding: var(--space-xl);
            }

            .login-title {
                font-size: var(--font-size-2xl);
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-card">
            <div class="login-header">
                <h1 class="login-title">🧠 Expert System</h1>
                <p class="login-subtitle">Professional Dashboard Access</p>
            </div>

            <% 
                String error = request.getParameter("error");
                if ("invalid".equals(error)) {
            %>
                <div class="error-message">
                    ✗ Invalid Expert ID or Password. Please try again.
                </div>
            <% 
                } else if (request.getAttribute("error") != null) { 
            %>
                <div class="error-message">
                    ✗ <%= request.getAttribute("error") %>
                </div>
            <% 
                } 
            %>

            <form action="${pageContext.request.contextPath}/expert" method="post">
                <input type="hidden" name="action" value="login">
                
                <div class="form-group">
                    <label class="form-label" for="expertId">Expert ID</label>
                    <input type="text" id="expertId" name="expertId" class="form-control" placeholder="e.g., expert_main" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-control" placeholder="Enter your password" required>
                </div>

                <div class="form-group" style="display: flex; align-items: center; gap: var(--space-md); margin-bottom: var(--space-lg);">
                    <input type="checkbox" id="rememberMe" name="rememberMe" value="true" style="width: 18px; height: 18px; cursor: pointer;">
                    <label class="form-label" for="rememberMe" style="margin-bottom: 0; cursor: pointer;">Remember me for 30 days</label>
                </div>

                <button type="submit" class="submit-btn">✓ Login</button>
            </form>

            <div class="login-footer">
                <p>Not an expert? <a href="${pageContext.request.contextPath}/login.jsp">Back to user login</a></p>
            </div>
        </div>
    </div>
</body>
</html>

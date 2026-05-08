<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Redirect if already logged in as Expert
    Integer expertId = (Integer) session.getAttribute("expertId");
    if (expertId != null) {
        response.sendRedirect(request.getContextPath() + "/expert_dashboard");
        return;
    }
    
    String error = request.getParameter("error");
    String message = "";
    if ("invalid".equals(error)) {
        message = "Invalid Expert ID or Password";
    } else if ("expired".equals(error)) {
        message = "Expert session expired. Please login again.";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Expert System - Login - EmoVault</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, var(--color-avocado) 0%, var(--color-sage) 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .expert-login-wrapper {
            width: 100%;
            max-width: 450px;
        }

        .expert-login-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .expert-icon {
            font-size: 60px;
            margin-bottom: 15px;
        }

        .expert-title {
            font-size: 32px;
            color: white;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .expert-subtitle {
            font-size: 14px;
            color: rgba(255, 255, 255, 0.8);
            margin-bottom: 30px;
        }

        .expert-login-card {
            background: white;
            border-radius: 12px;
            padding: 40px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            color: var(--color-sage);
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-input {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 6px;
            font-size: 14px;
            font-family: inherit;
            transition: all 0.3s ease;
        }

        .form-input:focus {
            outline: none;
            border-color: var(--color-sage);
            box-shadow: 0 0 0 3px rgba(129, 130, 99, 0.1);
        }

        .remember-me {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
            color: #666;
            margin-bottom: 25px;
        }

        .remember-me input[type="checkbox"] {
            cursor: pointer;
            width: 16px;
            height: 16px;
            accent-color: var(--color-sage);
        }

        .remember-me label {
            cursor: pointer;
        }

        .login-button {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, var(--color-sage) 0%, #6d6e54 100%);
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .login-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(129, 130, 99, 0.3);
        }

        .login-button:active {
            transform: translateY(0);
        }

        .error-message {
            background: #fee;
            color: #c33;
            padding: 12px 15px;
            border-radius: 6px;
            margin-bottom: 25px;
            border-left: 4px solid #c33;
            font-size: 13px;
        }

        .divider {
            text-align: center;
            margin: 30px 0;
            position: relative;
        }

        .divider::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 1px;
            background: #e0e0e0;
        }

        .divider-text {
            position: relative;
            background: white;
            display: inline-block;
            padding: 0 10px;
            color: #999;
            font-size: 12px;
        }

        .info-section {
            background: #f5f5f5;
            border-radius: 6px;
            padding: 20px;
            margin-top: 30px;
            border-left: 4px solid var(--color-avocado);
        }

        .info-title {
            font-size: 13px;
            font-weight: 700;
            color: var(--color-sage);
            margin-bottom: 10px;
            text-transform: uppercase;
        }

        .info-text {
            font-size: 12px;
            color: #666;
            line-height: 1.6;
        }

        .user-login-link {
            text-align: center;
            margin-top: 30px;
            padding-top: 30px;
            border-top: 1px solid #e0e0e0;
        }

        .user-login-link p {
            font-size: 13px;
            color: #666;
            margin-bottom: 10px;
        }

        .user-login-link a {
            color: var(--color-sage);
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .user-login-link a:hover {
            color: #6d6e54;
            text-decoration: underline;
        }

        @media (max-width: 480px) {
            .expert-login-card {
                padding: 30px 20px;
            }

            .expert-title {
                font-size: 26px;
            }

            .expert-icon {
                font-size: 48px;
            }
        }
    </style>
</head>
<body>
    <div class="expert-login-wrapper">
        <div class="expert-login-header">
            <div class="expert-icon">🤖</div>
            <h1 class="expert-title">Expert System</h1>
            <p class="expert-subtitle">Intelligent Insights & Pattern Analysis</p>
        </div>

        <div class="expert-login-card">
            <% if (!message.isEmpty()) { %>
                <div class="error-message">
                    <%= message %>
                </div>
            <% } %>

            <form method="POST" action="${pageContext.request.contextPath}/expert_login">
                <div class="form-group">
                    <label class="form-label" for="expertId">Expert ID</label>
                    <input type="text" 
                           id="expertId" 
                           name="expertId" 
                           class="form-input" 
                           placeholder="Enter your Expert ID"
                           required
                           autofocus>
                </div>

                <div class="form-group">
                    <label class="form-label" for="password">Password</label>
                    <input type="password" 
                           id="password" 
                           name="password" 
                           class="form-input" 
                           placeholder="Enter your password"
                           required>
                </div>

                <div class="remember-me">
                    <input type="checkbox" id="rememberMe" name="rememberMe" value="true">
                    <label for="rememberMe">Keep me logged in for 30 days</label>
                </div>

                <button type="submit" class="login-button">🔓 Access Expert System</button>
            </form>

            <div class="divider">
                <span class="divider-text">System Access</span>
            </div>

            <div class="info-section">
                <div class="info-title">ℹ️ Expert System Features</div>
                <div class="info-text">
                    ✓ Monitor emotional patterns across users<br>
                    ✓ Analyze behavioral trends & risks<br>
                    ✓ Manage expert rules & suggestions<br>
                    ✓ View comprehensive insights<br>
                    ✓ Generate pattern reports<br>
                    ✓ Risk assessment analytics
                </div>
            </div>

            <div class="user-login-link">
                <p>Regular User?</p>
                <a href="${pageContext.request.contextPath}/login.jsp">← Back to User Login</a>
            </div>
        </div>
    </div>
</body>
</html>

<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EmoVault - Emotional Intelligence & Personal Growth</title>
    <link rel="stylesheet" href="css/emovault-complete-ui.css">
    <style>
        /* Landing Page Specific Styles */
        
        .landing-container {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
        /* Header Navigation */
        .landing-header {
            padding: 1.5rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: rgba(68, 60, 94, 0.5);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(169, 159, 191, 0.2);
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 100;
        }
        
        .logo {
            font-size: 1.8rem;
            font-weight: 700;
            background: linear-gradient(135deg, #E2C2BC 0%, #BF7185 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .logo-icon {
            font-size: 2rem;
        }
        
        .header-buttons {
            display: flex;
            gap: 1rem;
        }
        
        .btn-header {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            font-size: 1rem;
        }
        
        .btn-login {
            background: transparent;
            color: #E2C2BC;
            border: 2px solid #E2C2BC;
        }
        
        .btn-login:hover {
            background: #E2C2BC;
            color: #3D2B27;
        }
        
        .btn-register {
            background: linear-gradient(135deg, #BF7185 0%, #A99FBF 100%);
            color: white;
            border: none;
        }
        
        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(191, 113, 133, 0.4);
        }
        
        /* Main Content (offset for fixed header) */
        .landing-main {
            margin-top: 70px;
            flex: 1;
        }
        
        /* Hero Section */
        .hero {
            min-height: calc(100vh - 70px);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 4rem 2rem;
            text-align: center;
            background: linear-gradient(180deg, rgba(68, 60, 94, 0.3) 0%, rgba(61, 43, 39, 0.5) 100%);
            position: relative;
            overflow: hidden;
        }
        
        .hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: radial-gradient(circle at 15% 40%, rgba(191, 113, 133, 0.15) 0%, transparent 50%),
                        radial-gradient(circle at 85% 70%, rgba(169, 159, 191, 0.1) 0%, transparent 50%);
            pointer-events: none;
        }
        
        .hero-content {
            max-width: 800px;
            animation: fadeInUp 0.8s ease;
            position: relative;
            z-index: 2;
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .hero-title {
            font-size: 4rem;
            font-weight: 800;
            margin-bottom: 1.5rem;
            background: linear-gradient(135deg, #E2C2BC 0%, #BF7185 50%, #A99FBF 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            line-height: 1.2;
        }
        
        .hero-subtitle {
            font-size: 1.3rem;
            color: #D4B5AD;
            margin-bottom: 1rem;
            line-height: 1.8;
        }
        
        .hero-description {
            font-size: 1.1rem;
            color: #BFA7A0;
            margin-bottom: 3rem;
            line-height: 1.8;
        }
        
        .hero-buttons {
            display: flex;
            gap: 1.5rem;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .btn-cta {
            padding: 1rem 2.5rem;
            font-size: 1.1rem;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #BF7185 0%, #A99FBF 100%);
            color: white;
            box-shadow: 0 8px 24px rgba(191, 113, 133, 0.3);
        }
        
        .btn-primary:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 32px rgba(191, 113, 133, 0.4);
        }
        
        .btn-secondary {
            background: transparent;
            color: #E2C2BC;
            border: 2px solid #E2C2BC;
        }
        
        .btn-secondary:hover {
            background: #E2C2BC;
            color: #3D2B27;
            transform: translateY(-4px);
        }
        
        /* Features Section */
        .features {
            padding: 5rem 2rem;
            background: rgba(61, 43, 39, 0.5);
        }
        
        .features-title {
            text-align: center;
            font-size: 2.8rem;
            margin-bottom: 4rem;
            color: #E2C2BC;
            font-weight: 700;
        }
        
        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 2.5rem;
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .feature-card {
            background: linear-gradient(135deg, rgba(226, 194, 188, 0.15) 0%, rgba(191, 113, 133, 0.1) 100%);
            border: 1px solid rgba(169, 159, 191, 0.3);
            padding: 2.5rem;
            border-radius: 16px;
            text-align: center;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
        }
        
        .feature-card:hover {
            transform: translateY(-8px);
            border-color: #BF7185;
            box-shadow: 0 12px 32px rgba(191, 113, 133, 0.2);
        }
        
        .feature-icon {
            font-size: 3.5rem;
            margin-bottom: 1.5rem;
            display: block;
        }
        
        .feature-title {
            font-size: 1.4rem;
            font-weight: 700;
            color: #E2C2BC;
            margin-bottom: 1rem;
        }
        
        .feature-description {
            color: #D4B5AD;
            line-height: 1.8;
            font-size: 1rem;
        }
        
        /* How It Works Section */
        .how-it-works {
            padding: 5rem 2rem;
            background: rgba(68, 60, 94, 0.3);
        }
        
        .how-title {
            text-align: center;
            font-size: 2.8rem;
            margin-bottom: 4rem;
            color: #E2C2BC;
            font-weight: 700;
        }
        
        .steps-container {
            max-width: 1000px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
        }
        
        .step-card {
            background: rgba(226, 194, 188, 0.1);
            padding: 2rem;
            border-radius: 16px;
            border: 1px solid rgba(169, 159, 191, 0.3);
            text-align: center;
            transition: all 0.3s ease;
        }
        
        .step-card:hover {
            transform: translateY(-4px);
            border-color: #A99FBF;
        }
        
        .step-number {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, #BF7185 0%, #A99FBF 100%);
            color: white;
            font-weight: 700;
            font-size: 1.5rem;
            margin: 0 auto 1.5rem;
        }
        
        .step-title {
            font-size: 1.2rem;
            color: #E2C2BC;
            font-weight: 700;
            margin-bottom: 0.75rem;
        }
        
        .step-description {
            color: #D4B5AD;
            line-height: 1.6;
        }
        
        /* CTA Section */
        .cta-section {
            padding: 5rem 2rem;
            background: linear-gradient(135deg, #443C5E 0%, #3D2B27 100%);
            text-align: center;
        }
        
        .cta-title {
            font-size: 2.5rem;
            color: #E2C2BC;
            margin-bottom: 1.5rem;
            font-weight: 700;
        }
        
        .cta-description {
            font-size: 1.1rem;
            color: #D4B5AD;
            margin-bottom: 2.5rem;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }
        
        .cta-buttons {
            display: flex;
            gap: 1.5rem;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        /* Footer */
        .landing-footer {
            padding: 2rem;
            text-align: center;
            border-top: 1px solid rgba(169, 159, 191, 0.2);
            color: #BFA7A0;
            font-size: 0.95rem;
            background: rgba(61, 43, 39, 0.3);
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .landing-header {
                padding: 1rem;
            }
            
            .header-buttons {
                flex-direction: column;
                gap: 0.5rem;
            }
            
            .btn-header {
                padding: 0.6rem 1.2rem;
                font-size: 0.9rem;
            }
            
            .hero-title {
                font-size: 2.5rem;
            }
            
            .hero-subtitle {
                font-size: 1.1rem;
            }
            
            .hero-buttons {
                flex-direction: column;
                gap: 1rem;
            }
            
            .btn-cta {
                width: 100%;
            }
            
            .features-title,
            .how-title {
                font-size: 2rem;
            }
            
            .cta-title {
                font-size: 2rem;
            }
            
            .feature-icon {
                font-size: 2.5rem;
            }
        }
    </style>
</head>
<body>
    <div class="landing-container">
        <!-- Header -->
        <header class="landing-header">
            <div class="logo">
                <span class="logo-icon">💭</span>
                <span>EmoVault</span>
            </div>
            <div class="header-buttons">
                <a href="login.jsp" class="btn-header btn-login">Login</a>
                <a href="register.jsp" class="btn-header btn-register">Register</a>
            </div>
        </header>
        
        <main class="landing-main">
            <!-- Hero Section -->
            <section class="hero">
                <div class="hero-content">
                    <h1 class="hero-title">Transform Your Emotional Journey</h1>
                    <p class="hero-subtitle">Track, understand, and grow with EmoVault</p>
                    <p class="hero-description">
                        Your personal AI-powered companion for emotional wellness. 
                        Log emotions, discover patterns, and unlock insights that lead to lasting personal growth.
                    </p>
                    <div class="hero-buttons">
                        <a href="register.jsp" class="btn-cta btn-primary">Get Started Now</a>
                        <a href="login.jsp" class="btn-cta btn-secondary">Sign In</a>
                    </div>
                </div>
            </section>
            
            <!-- Features Section -->
            <section class="features">
                <h2 class="features-title">What You Can Do With EmoVault</h2>
                <div class="features-grid">
                    <div class="feature-card">
                        <span class="feature-icon">📔</span>
                        <h3 class="feature-title">Emotion Diary</h3>
                        <p class="feature-description">Record emotions with triggers, intensity levels, and coping strategies. Build a personal emotional history.</p>
                    </div>
                    
                    <div class="feature-card">
                        <span class="feature-icon">📊</span>
                        <h3 class="feature-title">Visual Analytics</h3>
                        <p class="feature-description">See your emotional patterns through interactive charts and visualizations. Understand trends over time.</p>
                    </div>
                    
                    <div class="feature-card">
                        <span class="feature-icon">⏰</span>
                        <h3 class="feature-title">Time Capsule</h3>
                        <p class="feature-description">Send messages to your future self. Receive reminders and reflect on your growth journey.</p>
                    </div>
                    
                    <div class="feature-card">
                        <span class="feature-icon">📝</span>
                        <h3 class="feature-title">Habit Tracking</h3>
                        <p class="feature-description">Monitor daily habits and their emotional impact. Build positive routines with insights.</p>
                    </div>
                    
                    <div class="feature-card">
                        <span class="feature-icon">⚠️</span>
                        <h3 class="feature-title">Alert System</h3>
                        <p class="feature-description">Get notified when emotional patterns suggest you might need support. Stay ahead of challenges.</p>
                    </div>
                    
                    <div class="feature-card">
                        <span class="feature-icon">🤖</span>
                        <h3 class="feature-title">Expert Insights</h3>
                        <p class="feature-description">AI-powered recommendations based on your patterns. Get expert advice tailored to your journey.</p>
                    </div>
                </div>
            </section>
            
            <!-- How It Works Section -->
            <section class="how-it-works">
                <h2 class="how-title">How It Works</h2>
                <div class="steps-container">
                    <div class="step-card">
                        <div class="step-number">1</div>
                        <h3 class="step-title">Create Account</h3>
                        <p class="step-description">Sign up in minutes with your email. Your data is secure and private.</p>
                    </div>
                    
                    <div class="step-card">
                        <div class="step-number">2</div>
                        <h3 class="step-title">Log Emotions</h3>
                        <p class="step-description">Record how you're feeling with details about triggers and intensity.</p>
                    </div>
                    
                    <div class="step-card">
                        <div class="step-number">3</div>
                        <h3 class="step-title">Discover Patterns</h3>
                        <p class="step-description">Our system analyzes your entries to reveal emotional patterns and trends.</p>
                    </div>
                    
                    <div class="step-card">
                        <div class="step-number">4</div>
                        <h3 class="step-title">Get Insights</h3>
                        <p class="step-description">Receive expert recommendations and personalized guidance for growth.</p>
                    </div>
                </div>
            </section>
            
            <!-- Final CTA Section -->
            <section class="cta-section">
                <h2 class="cta-title">Ready to Understand Your Emotions?</h2>
                <p class="cta-description">
                    Start your emotional wellness journey today. Join thousands of users who are already 
                    gaining clarity and growing through self-awareness.
                </p>
                <div class="cta-buttons">
                    <a href="register.jsp" class="btn-cta btn-primary">Create Free Account</a>
                    <a href="login.jsp" class="btn-cta btn-secondary">Already Have Account?</a>
                </div>
            </section>
        </main>
        
        <!-- Footer -->
        <footer class="landing-footer">
            <p>&copy; 2026 EmoVault. Your emotional wellness journey matters. Data encrypted and private.</p>
        </footer>
    </div>
</body>
</html>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EmoVault - Emotional Intelligence & Personal Growth</title>
    <link rel="stylesheet" href="css/emovault-complete-ui.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            font-family: var(--font-body);
            background: #FBF8F3;
            color: var(--color-azur);
            overflow-x: hidden;
        }

        /* ===== HERO SECTION ===== */
        .hero {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
            background: linear-gradient(135deg, #FBF8F3 0%, #E6D4BF 25%, #679F9F 75%, #877499 100%);
        }

        .hero-bg {
            position: absolute;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0;
        }

        .blob {
            position: absolute;
            border-radius: 50%;
            filter: blur(40px);
            opacity: 0.3;
            animation: drift 20s ease-in-out infinite;
        }

        .blob-1 {
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, rgba(135, 116, 153, 0.4), transparent);
            top: -50px;
            left: -100px;
            animation-duration: 25s;
        }

        .blob-2 {
            width: 350px;
            height: 350px;
            background: radial-gradient(circle, rgba(103, 159, 159, 0.4), transparent);
            bottom: 100px;
            right: -50px;
            animation-duration: 30s;
            animation-direction: reverse;
        }

        .blob-3 {
            width: 300px;
            height: 300px;
            background: radial-gradient(circle, rgba(225, 130, 153, 0.3), transparent);
            top: 50%;
            left: 10%;
            animation-duration: 28s;
        }

        @keyframes drift {
            0%, 100% {
                transform: translate(0, 0) rotate(0deg);
            }
            33% {
                transform: translate(30px, -30px) rotate(120deg);
            }
            66% {
                transform: translate(-20px, 20px) rotate(240deg);
            }
        }

        /* Floating emotion words */
        .floating-words {
            position: absolute;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0;
        }

        .emotion-word {
            position: absolute;
            font-family: var(--font-heading);
            font-size: 3rem;
            font-weight: 300;
            opacity: 0;
            animation: floatAndFade 8s ease-in-out infinite;
            color: rgba(75, 60, 80, 0.85);
            letter-spacing: 2px;
            white-space: nowrap;
            filter: drop-shadow(0 10px 20px rgba(0, 0, 0, 0.1));
        }

        .emotion-word:nth-child(1) {
            top: 20%;
            left: 5%;
            animation-delay: 0s;
            font-size: 2.5rem;
            color: rgba(160, 60, 90, 0.8);
        }

        .emotion-word:nth-child(2) {
            top: 60%;
            right: 10%;
            animation-delay: 3s;
            font-size: 2rem;
            color: rgba(50, 110, 110, 0.8);
        }

        .emotion-word:nth-child(3) {
            top: 30%;
            right: 20%;
            animation-delay: 5s;
            font-size: 2.2rem;
            color: rgba(75, 60, 80, 0.8);
        }

        .emotion-word:nth-child(4) {
            bottom: 15%;
            left: 15%;
            animation-delay: 2s;
            font-size: 2.3rem;
            color: rgba(50, 110, 110, 0.75);
        }

        .emotion-word:nth-child(5) {
            top: 70%;
            left: 50%;
            animation-delay: 4s;
            font-size: 2rem;
            color: rgba(160, 60, 90, 0.75);
            transform: translateX(-50%);
        }

        @keyframes floatAndFade {
            0% {
                opacity: 0;
                transform: translateY(0) translateX(var(--tx, 0));
            }
            25% {
                opacity: 0.6;
            }
            50% {
                opacity: 0.4;
                transform: translateY(-60px) translateX(var(--tx, 0));
            }
            75% {
                opacity: 0.3;
            }
            100% {
                opacity: 0;
                transform: translateY(-120px) translateX(var(--tx, 0));
            }
        }

        .hero-content {
            position: relative;
            z-index: 10;
            text-align: center;
            max-width: 700px;
            padding: 40px;
            animation: fadeInUp 1.2s ease-out;
        }

        .hero h1 {
            font-family: var(--font-heading);
            font-size: 4.5rem;
            color: white;
            margin-bottom: 20px;
            letter-spacing: -2px;
            text-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            font-weight: 700;
        }

        .hero .subtitle {
            font-size: 1.4rem;
            color: rgba(255, 255, 255, 0.95);
            margin-bottom: 15px;
            font-weight: 300;
            line-height: 1.6;
        }

        .hero .tagline {
            font-size: 1.05rem;
            color: rgba(255, 255, 255, 0.8);
            margin-bottom: 50px;
            font-style: italic;
        }

        .cta-buttons {
            display: flex;
            gap: 20px;
            justify-content: center;
            flex-wrap: wrap;
            animation: fadeInUp 1.4s ease-out;
        }

        .btn {
            padding: 16px 45px;
            border-radius: 50px;
            font-size: 1.05rem;
            font-weight: var(--font-weight-semibold);
            text-decoration: none;
            cursor: pointer;
            border: none;
            transition: all 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
            display: inline-block;
            position: relative;
            overflow: hidden;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.3);
            transform: translate(-50%, -50%);
            transition: width 0.6s, height 0.6s;
        }

        .btn:hover::before {
            width: 300px;
            height: 300px;
        }

        .btn-primary {
            background: linear-gradient(135deg, rgba(103, 159, 159, 0.95), rgba(90, 143, 143, 0.95));
            color: white;
            box-shadow: 0 10px 30px rgba(103, 159, 159, 0.4);
            border: 2px solid rgba(255, 255, 255, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-6px);
            box-shadow: 0 20px 50px rgba(103, 159, 159, 0.6);
            border-color: white;
        }

        .btn-secondary {
            background: rgba(255, 255, 255, 0.95);
            color: var(--color-heather);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
            border: 2px solid white;
        }

        .btn-secondary:hover {
            transform: translateY(-6px);
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.25);
            background: white;
        }

        .btn > span {
            position: relative;
            z-index: 1;
        }

        /* ===== MOOD SELECTOR SECTION ===== */
        .mood-section {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 80px 20px;
            background: white;
            position: relative;
            overflow: hidden;
        }

        .mood-section::before {
            content: '';
            position: absolute;
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, rgba(225, 130, 153, 0.06) 0%, transparent 70%);
            border-radius: 50%;
            bottom: -100px;
            right: 50px;
            animation: drift 25s ease-in-out infinite;
        }

        .mood-content {
            max-width: 900px;
            text-align: center;
            position: relative;
            z-index: 2;
        }

        .mood-question {
            font-family: var(--font-heading);
            font-size: 3rem;
            color: var(--color-heather);
            margin-bottom: 60px;
            font-weight: 700;
            animation: fadeInUp 0.8s ease-out;
        }

        .mood-options {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            gap: 25px;
            margin-bottom: 50px;
            animation: fadeInUp 1s ease-out;
        }

        .mood-btn {
            background: white;
            border: 2px solid var(--color-warm-gray);
            border-radius: 20px;
            padding: 25px 15px;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
            font-size: 2rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .mood-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, rgba(103, 159, 159, 0.1), rgba(135, 116, 153, 0.1));
            opacity: 0;
            transition: opacity 0.3s;
            z-index: -1;
        }

        .mood-btn:hover {
            border-color: var(--color-viridian);
            transform: scale(1.1) translateY(-8px);
            box-shadow: 0 20px 40px rgba(103, 159, 159, 0.2);
        }

        .mood-btn:hover::before {
            opacity: 1;
        }

        .mood-label {
            font-size: 0.9rem;
            color: var(--color-azur);
            margin-top: 8px;
            display: block;
            font-weight: var(--font-weight-medium);
        }

        .mood-response {
            margin-top: 50px;
            padding: 30px;
            background: linear-gradient(135deg, rgba(103, 159, 159, 0.05), rgba(225, 130, 153, 0.05));
            border-radius: 20px;
            border-left: 4px solid var(--color-viridian);
            opacity: 0;
            animation: slideIn 0.6s ease-out forwards;
        }

        .mood-response.hidden {
            display: none;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateX(-30px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .mood-response p {
            font-size: 1.1rem;
            color: var(--color-azur);
            line-height: 1.8;
        }

        /* ===== TRANSFORMATION SECTION ===== */
        .transformation {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 80px 20px;
            background: linear-gradient(135deg, #FBF8F3 0%, #E6D4BF 100%);
            position: relative;
            overflow: hidden;
        }

        .transformation::before {
            content: '';
            position: absolute;
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, rgba(103, 159, 159, 0.08), transparent);
            border-radius: 50%;
            top: 50%;
            right: 5%;
            transform: translateY(-50%);
            animation: pulse-soft 4s ease-in-out infinite;
        }

        @keyframes pulse-soft {
            0%, 100% {
                transform: translateY(-50%) scale(1);
            }
            50% {
                transform: translateY(-50%) scale(1.1);
            }
        }

        .transform-content {
            max-width: 900px;
            position: relative;
            z-index: 2;
        }

        .transform-title {
            font-family: var(--font-heading);
            font-size: 3rem;
            color: var(--color-heather);
            margin-bottom: 50px;
            text-align: center;
            animation: fadeInUp 0.8s ease-out;
        }

        .transform-visual {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 60px;
            margin-bottom: 60px;
        }

        .chaos {
            flex: 1;
            text-align: center;
            animation: fadeInUp 0.8s ease-out;
        }

        .arrow-transform {
            font-size: 3rem;
            color: var(--color-viridian);
            animation: slideRight 1.2s ease-out;
        }

        @keyframes slideRight {
            from {
                opacity: 0;
                transform: translateX(-30px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .clarity {
            flex: 1;
            text-align: center;
            animation: fadeInUp 1s ease-out;
        }

        .chaos-box, .clarity-box {
            width: 200px;
            height: 200px;
            margin: 0 auto 20px;
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 4rem;
        }

        .chaos-box {
            background: linear-gradient(135deg, rgba(225, 130, 153, 0.2), rgba(225, 130, 153, 0.1));
            border: 2px dashed var(--color-candy);
        }

        .clarity-box {
            background: linear-gradient(135deg, rgba(103, 159, 159, 0.2), rgba(103, 159, 159, 0.1));
            border: 2px solid var(--color-viridian);
            box-shadow: 0 20px 60px rgba(103, 159, 159, 0.15);
        }

        .chaos h3, .clarity h3 {
            font-size: 1.5rem;
            color: var(--color-azur);
            margin-top: 20px;
        }

        .transform-text {
            font-size: 1.1rem;
            color: var(--color-azur);
            text-align: center;
            line-height: 1.8;
            animation: fadeInUp 1.2s ease-out;
        }

        /* ===== MODULES SECTION ===== */
        .modules {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 80px 20px;
            background: white;
            position: relative;
            overflow: hidden;
        }

        .modules::before {
            content: '';
            position: absolute;
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, rgba(135, 116, 153, 0.08), transparent);
            border-radius: 50%;
            top: -100px;
            left: 5%;
            animation: drift 28s ease-in-out infinite;
        }

        .modules-container {
            max-width: 1200px;
            position: relative;
            z-index: 2;
        }

        .modules-title {
            font-family: var(--font-heading);
            font-size: 3rem;
            color: var(--color-heather);
            text-align: center;
            margin-bottom: 80px;
            animation: fadeInUp 0.8s ease-out;
        }

        .floating-cards {
            position: relative;
            width: 100%;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 35px;
            perspective: 1200px;
        }

        .module-card {
            position: relative;
            width: 100%;
            min-height: 320px;
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(135, 116, 153, 0.1);
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
            animation: fadeInScale 0.8s ease-out forwards;
        }

        @keyframes fadeInScale {
            from {
                opacity: 0;
                transform: scale(0.8);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
        }

        .module-card:nth-child(1) {
            animation-delay: 0.1s;
            transform: rotate(-3deg);
        }

        .module-card:nth-child(2) {
            animation-delay: 0.2s;
            transform: rotate(2deg);
        }

        .module-card:nth-child(3) {
            animation-delay: 0.3s;
            transform: rotate(-2deg);
        }

        .module-card:nth-child(4) {
            animation-delay: 0.4s;
            transform: rotate(3deg);
        }

        .module-card:nth-child(5) {
            animation-delay: 0.5s;
            transform: rotate(-1deg);
        }

        .module-card:hover {
            transform: translateY(-15px) scale(1.05);
            box-shadow: 0 40px 80px rgba(103, 159, 159, 0.25);
            border-color: var(--color-viridian);
        }

        .module-card:nth-child(1):hover {
            transform: translateY(-15px) scale(1.05) rotate(-3deg);
        }

        .module-card:nth-child(2):hover {
            transform: translateY(-15px) scale(1.05) rotate(2deg);
        }

        .module-card:nth-child(3):hover {
            transform: translateY(-15px) scale(1.05) rotate(-2deg);
        }

        .module-card:nth-child(4):hover {
            transform: translateY(-15px) scale(1.05) rotate(3deg);
        }

        .module-card:nth-child(5):hover {
            transform: translateY(-15px) scale(1.05) rotate(-1deg);
        }

        .module-icon {
            font-size: 3.5rem;
            margin-bottom: 15px;
        }

        .module-title {
            font-family: var(--font-heading);
            font-size: 1.4rem;
            color: var(--color-heather);
            margin-bottom: 15px;
            font-weight: 600;
        }

        .module-description {
            font-size: 0.95rem;
            color: var(--color-azur);
            line-height: 1.6;
            opacity: 0.85;
        }

        /* ===== STATEMENT SECTION ===== */
        .statement {
            min-height: 70vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 80px 20px;
            background: linear-gradient(135deg, var(--color-heather) 0%, var(--color-viridian) 100%);
            position: relative;
            overflow: hidden;
        }

        .statement::before {
            content: '';
            position: absolute;
            width: 700px;
            height: 700px;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.15) 0%, transparent 70%);
            border-radius: 50%;
            top: -200px;
            right: -200px;
        }

        .statement::after {
            content: '';
            position: absolute;
            width: 600px;
            height: 600px;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
            border-radius: 50%;
            bottom: -150px;
            left: -150px;
        }

        .statement-content {
            max-width: 900px;
            text-align: center;
            position: relative;
            z-index: 2;
            animation: fadeInUp 0.8s ease-out;
        }

        .statement h2 {
            font-family: var(--font-heading);
            font-size: 3.5rem;
            color: white;
            line-height: 1.3;
            margin-bottom: 30px;
            text-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            letter-spacing: -1px;
        }

        .statement-highlight {
            display: inline;
            background: linear-gradient(120deg, rgba(255, 255, 255, 0.4) 0%, rgba(255, 255, 255, 0.15) 100%);
            padding: 8px 20px;
            border-radius: 50px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        .statement p {
            font-size: 1.15rem;
            color: rgba(255, 255, 255, 0.9);
            line-height: 1.8;
        }

        /* ===== FINAL CTA SECTION ===== */
        .final-cta {
            min-height: 60vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 80px 20px;
            background: white;
            position: relative;
            overflow: hidden;
        }

        .final-cta::before {
            content: '';
            position: absolute;
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, rgba(225, 130, 153, 0.08), transparent);
            border-radius: 50%;
            bottom: 50px;
            right: 10%;
            animation: drift 26s ease-in-out infinite;
        }

        .final-cta-content {
            position: relative;
            z-index: 2;
            text-align: center;
            animation: fadeInUp 0.8s ease-out;
        }

        .final-cta h2 {
            font-family: var(--font-heading);
            font-size: 2.8rem;
            color: var(--color-heather);
            margin-bottom: 20px;
        }

        .final-cta-subtitle {
            font-size: 1.1rem;
            color: var(--color-azur);
            margin-bottom: 50px;
            opacity: 0.85;
        }

        .final-cta-buttons {
            display: flex;
            gap: 20px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .final-cta .btn {
            padding: 16px 45px;
            font-size: 1.05rem;
        }

        /* ===== FOOTER ===== */
        footer {
            background: var(--color-azur);
            color: white;
            text-align: center;
            padding: 40px;
            font-size: 0.95rem;
            position: relative;
            z-index: 1;
        }

        footer p {
            margin: 0;
            opacity: 0.9;
        }

        /* ===== SCROLL REVEAL ANIMATIONS ===== */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(40px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 768px) {
            .hero h1 {
                font-size: 3rem;
            }

            .hero .subtitle {
                font-size: 1.1rem;
            }

            .emotion-word {
                font-size: 1.8rem !important;
            }

            .cta-buttons {
                flex-direction: column;
            }

            .btn {
                width: 100%;
                padding: 14px 30px;
            }

            .mood-question {
                font-size: 2rem;
            }

            .mood-options {
                grid-template-columns: repeat(3, 1fr);
                gap: 15px;
            }

            .mood-btn {
                padding: 20px 10px;
                font-size: 1.5rem;
            }

            .transform-title {
                font-size: 2rem;
            }

            .transform-visual {
                flex-direction: column;
                gap: 30px;
            }

            .arrow-transform {
                transform: rotate(90deg);
                margin: 20px 0;
            }

            .modules-title {
                font-size: 2rem;
            }

            .floating-cards {
                height: auto;
                display: grid;
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .module-card {
                position: relative;
                left: 0 !important;
                right: 0 !important;
                top: 0 !important;
                bottom: 0 !important;
                transform: none !important;
                width: 100%;
                max-width: 300px;
                margin: 0 auto;
            }

            .module-card:hover {
                transform: translateY(-15px) scale(1.02) !important;
            }

            .statement h2 {
                font-size: 2.2rem;
            }

            .final-cta h2 {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
    <!-- HERO SECTION -->
    <section class="hero">
        <div class="hero-bg">
            <div class="blob blob-1"></div>
            <div class="blob blob-2"></div>
            <div class="blob blob-3"></div>
            
            <div class="floating-words">
                <div class="emotion-word">Stress</div>
                <div class="emotion-word">Regret</div>
                <div class="emotion-word">Overthinking</div>
                <div class="emotion-word">Anxiety</div>
                <div class="emotion-word">Confusion</div>
            </div>
        </div>

        <div class="hero-content">
            <h1>✨ EmoVault</h1>
            <p class="subtitle">Turning emotional chaos into clarity and growth</p>
            <p class="tagline">Your personal space for emotional understanding and transformation</p>
            
            <div class="cta-buttons">
                <a href="register.jsp" class="btn btn-primary"><span>Begin Your Journey</span></a>
                <a href="login.jsp" class="btn btn-secondary"><span>Login</span></a>
            </div>
        </div>
    </section>

    <!-- MOOD SELECTOR SECTION -->
    <section class="mood-section">
        <div class="mood-content">
            <h2 class="mood-question">How are you feeling today?</h2>
            
            <div class="mood-options">
                <button class="mood-btn" onclick="showMoodResponse(0)">
                    <span style="display: block;">😊</span>
                    <span class="mood-label">Happy</span>
                </button>
                <button class="mood-btn" onclick="showMoodResponse(1)">
                    <span style="display: block;">😢</span>
                    <span class="mood-label">Sad</span>
                </button>
                <button class="mood-btn" onclick="showMoodResponse(2)">
                    <span style="display: block;">😰</span>
                    <span class="mood-label">Anxious</span>
                </button>
                <button class="mood-btn" onclick="showMoodResponse(3)">
                    <span style="display: block;">😤</span>
                    <span class="mood-label">Frustrated</span>
                </button>
                <button class="mood-btn" onclick="showMoodResponse(4)">
                    <span style="display: block;">🤔</span>
                    <span class="mood-label">Thoughtful</span>
                </button>
                <button class="mood-btn" onclick="showMoodResponse(5)">
                    <span style="display: block;">😴</span>
                    <span class="mood-label">Tired</span>
                </button>
            </div>

            <div id="mood-response-0" class="mood-response hidden">
                <p>That's wonderful! Keep that energy and use EmoVault to reflect on what makes you happy. Building awareness around joy helps you create more of it.</p>
            </div>
            <div id="mood-response-1" class="mood-response hidden">
                <p>It's okay to feel sad. Emotions are temporary, and understanding them is the first step to feeling better. Track your feelings in EmoVault and watch how they evolve.</p>
            </div>
            <div id="mood-response-2" class="mood-response hidden">
                <p>Anxiety is your mind trying to protect you. Let's understand what's causing it. Use EmoVault to log your worries and discover patterns that help you regain control.</p>
            </div>
            <div id="mood-response-3" class="mood-response hidden">
                <p>Frustration shows you care about something. Instead of pushing it away, let's explore it. EmoVault helps you understand what triggered it and how to respond better.</p>
            </div>
            <div id="mood-response-4" class="mood-response hidden">
                <p>Thoughtfulness is a gift. Explore your thoughts in EmoVault's reflections section. You might discover insights that lead to personal breakthroughs.</p>
            </div>
            <div id="mood-response-5" class="mood-response hidden">
                <p>Rest is important. But if you're always tired, it might be worth exploring why. Track your emotional patterns to understand what drains or energizes you.</p>
            </div>
        </div>
    </section>

    <!-- TRANSFORMATION SECTION -->
    <section class="transformation">
        <div class="transform-content">
            <h2 class="transform-title">From Chaos to Clarity</h2>
            
            <div class="transform-visual">
                <div class="chaos">
                    <div class="chaos-box">🌪️</div>
                    <h3>Scattered emotions, unclear patterns</h3>
                </div>
                
                <div class="arrow-transform">→</div>
                
                <div class="clarity">
                    <div class="clarity-box">✨</div>
                    <h3>Organized insights, clear understanding</h3>
                </div>
            </div>

            <p class="transform-text">
                Every emotion you log, every reflection you write, and every pattern you discover brings you closer to understanding yourself. 
                EmoVault transforms the noise into signal, chaos into clarity.
            </p>
        </div>
    </section>

    <!-- MODULES SECTION -->
    <section class="modules">
        <div class="modules-container">
            <h2 class="modules-title">Your Emotional Toolkit</h2>
            
            <div class="floating-cards">
                <div class="module-card">
                    <div class="module-icon">💭</div>
                    <h3 class="module-title">Emotion Log</h3>
                    <p class="module-description">Capture your feelings, mood intensity, and context. Build awareness of your emotional landscape.</p>
                </div>

                <div class="module-card">
                    <div class="module-icon">📊</div>
                    <h3 class="module-title">Behavior Analysis</h3>
                    <p class="module-description">Discover patterns in your emotional cycles. Get intelligent insights about your wellbeing.</p>
                </div>

                <div class="module-card">
                    <div class="module-icon">📔</div>
                    <h3 class="module-title">Diary</h3>
                    <p class="module-description">Reflect on your day. Write freely and uncover insights through detailed journaling.</p>
                </div>

                <div class="module-card">
                    <div class="module-icon">🌱</div>
                    <h3 class="module-title">Habit Builder</h3>
                    <p class="module-description">Create positive habits aligned with your emotional goals. Track streaks and celebrate progress.</p>
                </div>

                <div class="module-card">
                    <div class="module-icon">⏳</div>
                    <h3 class="module-title">Time Capsules</h3>
                    <p class="module-description">Lock your goals and revisit your emotional journey. Watch yourself grow over time.</p>
                </div>

                <div class="module-card">
                    <div class="module-icon">🎯</div>
                    <h3 class="module-title">Decision Assistant</h3>
                    <p class="module-description">Evaluate your choices using emotional data and past behavior. Get intelligent recommendations.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- STATEMENT SECTION -->
    <section class="statement">
        <div class="statement-content">
            <h2>We don't just <span class="statement-highlight">track emotions</span> — we help you <span class="statement-highlight">understand them deeply</span>.</h2>
            <p>Your feelings are data. Your growth is our mission.</p>
        </div>
    </section>

    <!-- FINAL CTA SECTION -->
    <section class="final-cta">
        <div class="final-cta-content">
            <h2>Ready to understand yourself better?</h2>
            <p class="final-cta-subtitle">Start your transformation today. It only takes a moment.</p>
            
            <div class="final-cta-buttons">
                <a href="register.jsp" class="btn btn-primary"><span>Create Your Account</span></a>
                <a href="login.jsp" class="btn btn-secondary"><span>Already a member? Sign In</span></a>
            </div>
        </div>
    </section>

    <!-- FOOTER -->
    <footer>
        <p>&copy; 2026 EmoVault. Your emotions, your growth, your journey.</p>
    </footer>

    <script>
        // Mood selector functionality
        function showMoodResponse(index) {
            // Hide all responses
            document.querySelectorAll('.mood-response').forEach(el => {
                el.classList.add('hidden');
            });
            
            // Show selected response
            const response = document.getElementById('mood-response-' + index);
            if (response) {
                response.classList.remove('hidden');
                response.style.animation = 'none';
                setTimeout(() => {
                    response.style.animation = 'slideIn 0.6s ease-out';
                }, 10);
            }
        }

        // Scroll reveal animations
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -100px 0px'
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    observer.unobserve(entry.target);
                }
            });
        }, observerOptions);

        // Observe elements for scroll animation
        document.querySelectorAll('.mood-content, .transform-content, .modules-container, .statement-content, .final-cta-content').forEach(el => {
            el.style.opacity = '0';
            observer.observe(el);
        });

        // Smooth scroll to sections
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function(e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({ behavior: 'smooth' });
                }
            });
        });
    </script>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.emovault.model.TimeCapsule" %>
<%
    // Ensure user is logged in
    HttpSession userSession = request.getSession(false);
    Integer userId = (Integer) (userSession != null ? userSession.getAttribute("userId") : null);
    
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Get capsules from request
    List<TimeCapsule> capsules = (List<TimeCapsule>) request.getAttribute("capsules");
    if (capsules == null) {
        capsules = new ArrayList<>();
    }
    
    // Separate capsules by status
    List<TimeCapsule> lockedCapsules = new ArrayList<>();
    List<TimeCapsule> readyCapsules = new ArrayList<>();
    List<TimeCapsule> openedCapsules = new ArrayList<>();
    
    for (TimeCapsule capsule : capsules) {
        if (capsule.isOpened()) {
            openedCapsules.add(capsule);
        } else if (capsule.canBeOpened()) {
            readyCapsules.add(capsule);
        } else {
            lockedCapsules.add(capsule);
        }
    }
    
    // Mood emoji mapping
    java.util.Map<String, String> moodEmoji = new java.util.HashMap<>();
    moodEmoji.put("Happy", "😊");
    moodEmoji.put("Calm", "😌");
    moodEmoji.put("Excited", "🤩");
    moodEmoji.put("Sad", "😢");
    moodEmoji.put("Stressed", "😰");
    moodEmoji.put("Peaceful", "🕊️");
    moodEmoji.put("Energetic", "⚡");
    moodEmoji.put("Grateful", "🙏");
    moodEmoji.put("Hopeful", "🌟");
    moodEmoji.put("Angry", "😠");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Time Capsule - EmoVault</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Lora:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/design-system.css">
    <style>
        body {
            background: var(--gradient-bg-primary);
            margin: 0;
            padding: 0;
        }

        main {
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 250px;
            flex-shrink: 0;
        }

        .main-content {
            flex: 1;
            padding: var(--space-2xl);
        }

        .container {
            max-width: 1200px;
        }
        
        /* Header */
        .page-header {
            margin-bottom: var(--space-3xl);
            animation: fade-in-up 0.6s ease-out;
        }
        
        .page-title {
            font-size: var(--font-size-3xl);
            color: var(--color-heather);
            margin-bottom: var(--space-sm);
            font-family: var(--font-secondary);
            font-weight: var(--font-weight-bold);
        }
        
        .page-subtitle {
            font-size: var(--font-size-base);
            color: var(--color-warm-gray);
        }
        
        /* Message sections */
        .message-bar {
            background: var(--color-white);
            border: 1px solid rgba(230, 212, 191, 0.3);
            border-radius: var(--radius-lg);
            padding: var(--space-md);
            margin-bottom: var(--space-2xl);
            display: none;
            animation: slide-up 0.4s ease-out;
            box-shadow: var(--shadow-md);
        }
        
        .message-bar.show {
            display: flex;
            align-items: center;
            gap: var(--space-md);
        }
        
        .message-bar.success {
            border-color: #4CAF50;
            color: #2d5016;
        }
        
        .message-bar.error {
            border-color: #E18299;
            color: #8b3a3d;
        }
        
        /* Action bar */
        .action-bar {
            display: flex;
            justify-content: flex-start;
            gap: var(--space-md);
            margin-bottom: var(--space-3xl);
            flex-wrap: wrap;
        }
        
        .btn {
            padding: var(--space-md) var(--space-lg);
            border: none;
            border-radius: var(--radius-lg);
            font-size: var(--font-size-base);
            font-weight: var(--font-weight-medium);
            cursor: pointer;
            transition: all var(--transition-base);
            font-family: var(--font-primary);
        }
        
        .btn::before {
            content: '';
            position: absolute;
        }
        
        .btn-primary {
            background: var(--gradient-button);
            color: white;
            box-shadow: var(--shadow-lift);
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-xl);
        }
        
        .btn-secondary {
            background: var(--color-white);
            color: var(--color-azur);
            border: 2px solid var(--color-warm-gray);
        }
        
        .btn-secondary:hover {
            background: var(--color-cream);
            border-color: var(--color-heather);
        }
        
        /* Grid layout - COMPACT */
        .capsules-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            gap: var(--space-xl);
            margin-bottom: var(--space-3xl);
        }
        
        /* Section titles */
        .section-title {
            font-size: var(--font-size-xl);
            font-weight: var(--font-weight-bold);
            color: var(--color-heather);
            margin: var(--space-3xl) 0 var(--space-xl) 0;
            display: flex;
            align-items: center;
            gap: var(--space-md);
            position: relative;
            padding-bottom: var(--space-md);
        }
        
        .section-title::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 50px;
            height: 3px;
            background: var(--gradient-button);
            border-radius: var(--radius-sm);
        }
        
        /* CAPSULE CARD STYLES - COMPACT */
        .capsule-card {
            position: relative;
            min-height: 220px;
            border-radius: var(--radius-xl);
            overflow: hidden;
            cursor: pointer;
            transition: all 0.4s ease;
            animation: fade-in-up 0.6s ease-out;
            background: var(--color-white);
            border: 1px solid rgba(230, 212, 191, 0.3);
            box-shadow: var(--shadow-md);
            display: flex;
            flex-direction: column;
        }
        
        .capsule-card:hover {
            transform: translateY(-6px);
            box-shadow: var(--shadow-lg);
        }
        
        /* Capsule background with gradient */
        .capsule-background {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: var(--gradient-button);
            opacity: 0.85;
            border-radius: var(--radius-xl);
            z-index: 0;
        }
        
        /* Locked capsule styling */
        .capsule-card.locked .capsule-background {
            opacity: 0.5;
            filter: blur(2px);
        }
        
        .capsule-card.locked::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.1);
            z-index: 2;
            pointer-events: none;
            border-radius: var(--radius-xl);
        }
        
        /* Ready capsule (glowing) */
        .capsule-card.ready {
            box-shadow: 0 0 30px rgba(103, 159, 159, 0.5);
            animation: pulse-glow 2s ease-in-out infinite, fade-in-up 0.6s ease-out;
        }
        
        @keyframes pulse-glow {
            0%, 100% {
                box-shadow: 0 0 30px rgba(103, 159, 159, 0.5);
            }
            50% {
                box-shadow: 0 0 50px rgba(103, 159, 159, 0.8);
            }
        }
        
        /* Opened capsule */
        .capsule-card.opened {
            background: rgba(135, 116, 153, 0.1);
            border: 2px solid rgba(135, 116, 153, 0.2);
            box-shadow: var(--shadow-md);
        }
        
        .capsule-card.opened .capsule-background {
            opacity: 0;
        }
        
        /* Glassmorphism effect */
        .capsule-content {
            position: relative;
            z-index: 3;
            flex: 1;
            padding: var(--space-lg);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            color: white;
        }
        
        .capsule-card.opened .capsule-content {
            color: var(--color-azur);
        }
        
        /* Lock icon */
        .lock-icon {
            font-size: 2.5rem;
            margin-bottom: var(--space-sm);
            display: inline-block;
            animation: subtle-float 3s ease-in-out infinite;
        }
        
        @keyframes subtle-float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-3px); }
        }
        
        /* Capsule header */
        .capsule-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: var(--space-sm);
        }
        
        .capsule-date {
            font-size: var(--font-size-sm);
            opacity: 0.9;
            font-weight: var(--font-weight-medium);
        }
        
        .capsule-status {
            font-size: var(--font-size-xs);
            padding: var(--space-xs) var(--space-md);
            background: rgba(255, 255, 255, 0.2);
            border-radius: var(--radius-full);
            font-weight: var(--font-weight-medium);
        }
        
        .capsule-card.opened .capsule-status {
            background: rgba(135, 116, 153, 0.15);
            color: var(--color-heather);
        }
        
        /* Locked state text */
        .locked-placeholder {
            font-size: 1.3rem;
            font-weight: var(--font-weight-bold);
            opacity: 0.9;
            margin: var(--space-md) 0;
            letter-spacing: 1px;
        }
        
        .locked-message {
            font-size: var(--font-size-sm);
            opacity: 0.85;
            line-height: var(--line-height-normal);
        }
        
        /* Mood display */
        .mood-display {
            display: flex;
            align-items: center;
            gap: var(--space-sm);
            font-size: var(--font-size-base);
            font-weight: var(--font-weight-medium);
            padding: var(--space-sm);
            background: rgba(255, 255, 255, 0.15);
            border-radius: var(--radius-lg);
            width: fit-content;
        }
        
        .mood-emoji {
            font-size: 1.2rem;
        }
        
        .capsule-card.opened .mood-display {
            background: rgba(135, 116, 153, 0.15);
            color: var(--color-heather);
        }
        
        /* Message preview (opened only) */
        .message-preview {
            font-size: var(--font-size-sm);
            line-height: var(--line-height-normal);
            opacity: 0.95;
            margin: var(--space-md) 0;
            font-style: italic;
        }
        
        /* Goal display */
        .goal-display {
            font-size: var(--font-size-sm);
            margin-top: var(--space-md);
            opacity: 0.85;
        }
        
        .goal-label {
            font-weight: var(--font-weight-semibold);
            margin-bottom: var(--space-xs);
        }
        
        /* Button section */
        .capsule-actions {
            display: flex;
            gap: var(--space-sm);
            margin-top: var(--space-md);
            flex-wrap: wrap;
        }
        
        .capsule-btn {
            padding: var(--space-xs) var(--space-md);
            border: none;
            border-radius: var(--radius-lg);
            font-size: var(--font-size-sm);
            font-weight: var(--font-weight-medium);
            cursor: pointer;
            transition: all 0.3s ease;
            flex: 1;
            min-width: 100px;
        }
        
        .capsule-btn-open {
            background: rgba(255, 255, 255, 0.3);
            color: white;
            border: 2px solid rgba(255, 255, 255, 0.4);
        }
        
        .capsule-btn-open:hover {
            background: rgba(255, 255, 255, 0.4);
            transform: scale(1.05);
        }
        
        .capsule-btn-delete {
            background: rgba(225, 87, 89, 0.2);
            color: rgba(255, 255, 255, 0.8);
            border: 1px solid rgba(225, 87, 89, 0.3);
        }
        
        .capsule-btn-delete:hover {
            background: rgba(225, 87, 89, 0.35);
            transform: scale(1.05);
        }
        
        .capsule-card.opened .capsule-btn-delete {
            background: rgba(225, 87, 89, 0.15);
            color: #E18299;
        }
        
        /* Mood comparison */
        .mood-comparison {
            display: flex;
            align-items: center;
            gap: var(--space-lg);
            background: rgba(135, 116, 153, 0.08);
            padding: var(--space-lg);
            border-radius: var(--radius-lg);
            margin-top: var(--space-lg);
        }
        
        .mood-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: var(--space-sm);
            flex: 1;
        }
        
        .mood-item-label {
            font-size: var(--font-size-sm);
            opacity: 0.8;
            font-weight: var(--font-weight-medium);
        }
        
        .mood-item-emoji {
            font-size: 1.5rem;
        }
        
        .mood-arrow {
            font-size: 1.2rem;
            opacity: 0.8;
        }
        
        /* Reflection section */
        .reflection-section {
            background: rgba(135, 116, 153, 0.08);
            border: 1px solid rgba(135, 116, 153, 0.2);
            border-radius: var(--radius-lg);
            padding: var(--space-lg);
            margin-top: var(--space-lg);
        }
        
        .capsule-card.opened .reflection-section {
            background: rgba(135, 116, 153, 0.08);
            border-color: rgba(135, 116, 153, 0.3);
        }
        
        .reflection-title {
            font-size: var(--font-size-base);
            font-weight: var(--font-weight-bold);
            margin-bottom: var(--space-md);
            color: white;
        }
        
        .capsule-card.opened .reflection-title {
            color: var(--color-azur);
        }
        
        /* Empty state */
        .empty-state {
            grid-column: 1 / -1;
            text-align: center;
            padding: var(--space-3xl);
            color: var(--color-warm-gray);
        }
        
        .empty-state-icon {
            font-size: 3rem;
            margin-bottom: var(--space-lg);
            opacity: 0.6;
        }
        
        .empty-state-text {
            font-size: var(--font-size-lg);
            margin-bottom: var(--space-md);
            font-weight: var(--font-weight-medium);
        }
        
        .empty-state-subtext {
            font-size: var(--font-size-base);
            opacity: 0.7;
        }
        
        /* Modals */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.6);
            backdrop-filter: blur(5px);
            animation: fade-in 0.3s ease;
        }
        
        .modal.show {
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .modal-content {
            background: var(--gradient-bg-primary);
            border-radius: var(--radius-2xl);
            padding: var(--space-2xl);
            max-width: 500px;
            width: 90%;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: var(--shadow-xl);
            position: relative;
            animation: slide-up 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
            border: 1px solid rgba(230, 212, 191, 0.3);
        }
        
        @keyframes slide-up {
            from {
                transform: translateY(30px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }
        
        @keyframes fade-in {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        
        @keyframes fade-in-up {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes fade-in-down {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .modal-header {
            font-size: var(--font-size-2xl);
            font-weight: var(--font-weight-bold);
            color: var(--color-heather);
            margin-bottom: var(--space-xl);
            display: flex;
            align-items: center;
            gap: var(--space-md);
        }
        
        .close-btn {
            position: absolute;
            top: var(--space-lg);
            right: var(--space-lg);
            background: none;
            border: none;
            font-size: 1.5rem;
            cursor: pointer;
            color: var(--color-warm-gray);
            transition: all 0.2s;
            padding: var(--space-xs);
        }
        
        .close-btn:hover {
            color: var(--color-azur);
            transform: rotate(90deg);
        }
        
        .form-group {
            margin-bottom: var(--space-lg);
        }
        
        .form-group label {
            display: block;
            font-size: var(--font-size-base);
            font-weight: var(--font-weight-medium);
            color: var(--color-heather);
            margin-bottom: var(--space-md);
            letter-spacing: 0.3px;
        }
        
        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: var(--space-md);
            border: 2px solid var(--color-warm-gray);
            border-radius: var(--radius-md);
            font-size: var(--font-size-base);
            font-family: inherit;
            background: var(--color-cream);
            color: var(--color-azur);
            transition: all 0.3s;
        }
        
        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            outline: none;
            border-color: var(--color-viridian);
            background: var(--color-white);
            box-shadow: 0 0 0 3px rgba(103, 159, 159, 0.1);
        }
        
        .form-group textarea {
            resize: vertical;
            min-height: 100px;
            font-family: 'Lora', serif;
        }
        
        .modal-actions {
            display: flex;
            gap: var(--space-md);
            margin-top: var(--space-xl);
        }
        
        .modal-btn {
            flex: 1;
            padding: var(--space-md) var(--space-lg);
            border: none;
            border-radius: var(--radius-lg);
            font-size: var(--font-size-base);
            font-weight: var(--font-weight-medium);
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .modal-btn-submit {
            background: var(--gradient-button);
            color: white;
            box-shadow: var(--shadow-lift);
        }
        
        .modal-btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-xl);
        }
        
        .modal-btn-cancel {
            background: var(--color-white);
            color: var(--color-azur);
            border: 2px solid var(--color-warm-gray);
        }
        
        .modal-btn-cancel:hover {
            background: var(--color-cream);
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .page-title {
                font-size: var(--font-size-2xl);
            }
            
            .page-subtitle {
                font-size: var(--font-size-sm);
            }
            
            .capsules-grid {
                grid-template-columns: 1fr;
                gap: var(--space-lg);
            }
            
            .action-bar {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
            }
            
            .modal-content {
                padding: var(--space-xl);
            }
            
            .section-title {
                font-size: var(--font-size-lg);
            }
        }
        /* Sidebar layout */
        main {
            display: flex;
            min-height: 100vh;
        }
        
        .sidebar {
            width: 250px;
            flex-shrink: 0;
        }
        
        .main-content {
            flex: 1;
            padding: 40px;
        }
    </style>
</head>
<body>
    <main>
        <jsp:include page="components/sidebar.jsp"><jsp:param name="currentPage" value="timecapsule"/></jsp:include>
        <div class="main-content">
    <div class="container">
        <!-- Page Header -->
        <div class="page-header">
            <h1 class="page-title">⏳ Time Capsule</h1>
            <p class="page-subtitle">A message to your future self</p>
        </div>
        
        <!-- Messages -->
        <%
            String success = (String) request.getAttribute("success");
            String error = (String) request.getAttribute("error");
        %>
        <% if (success != null && !success.isEmpty()) { %>
            <div class="message-bar success show"><%= success %></div>
        <% } %>
        <% if (error != null && !error.isEmpty()) { %>
            <div class="message-bar error show"><%= error %></div>
        <% } %>
        
        <!-- Action Bar -->
        <div class="action-bar">
            <button class="btn btn-primary" onclick="openCreateModal()">+ Create New Capsule</button>
        </div>
        
        <!-- Locked Capsules Section -->
        <% if (!lockedCapsules.isEmpty()) { %>
            <h2 class="section-title">🔒 Locked Capsules</h2>
            <div class="capsules-grid">
                <% for (TimeCapsule capsule : lockedCapsules) { %>
                    <div class="capsule-card locked">
                        <div class="capsule-background"></div>
                        <div class="capsule-content">
                            <div>
                                <div class="lock-icon">🔒</div>
                                <div class="locked-placeholder">CONTENT LOCKED</div>
                                <div class="locked-message">This capsule will open on <strong><%= capsule.getTargetDate() %></strong></div>
                            </div>
                            <div class="capsule-actions">
                                <form method="POST" action="${pageContext.request.contextPath}/timecapsule" style="width: 100%; display: flex; gap: 10px;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="capsuleId" value="<%= capsule.getCapsuleId() %>">
                                    <button type="submit" class="capsule-btn capsule-btn-delete" onclick="return confirm('Delete this capsule?')">🗑️ Delete</button>
                                </form>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
        
        <!-- Ready to Open Section -->
        <% if (!readyCapsules.isEmpty()) { %>
            <h2 class="section-title">🎁 Ready to Open</h2>
            <div class="capsules-grid">
                <% for (TimeCapsule capsule : readyCapsules) { %>
                    <div class="capsule-card ready">
                        <div class="capsule-background"></div>
                        <div class="capsule-content">
                            <div>
                                <div class="capsule-header">
                                    <div class="capsule-date">Created: <%= capsule.getCreatedAt() %></div>
                                </div>
                                <div class="locked-placeholder">Ready to Open! 🎉</div>
                                <p class="locked-message">Click the button below to open your capsule and reveal your message.</p>
                            </div>
                            <div class="capsule-actions">
                                <form method="POST" action="${pageContext.request.contextPath}/timecapsule" style="width: 100%; display: flex; gap: 10px;">
                                    <input type="hidden" name="action" value="open">
                                    <input type="hidden" name="capsuleId" value="<%= capsule.getCapsuleId() %>">
                                    <button type="submit" class="capsule-btn capsule-btn-open">🎁 Open Capsule</button>
                                </form>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
        
        <!-- Opened Capsules Section -->
        <% if (!openedCapsules.isEmpty()) { %>
            <h2 class="section-title">💎 Opened Capsules</h2>
            <div class="capsules-grid">
                <% for (TimeCapsule capsule : openedCapsules) { %>
                    <div class="capsule-card opened">
                        <div class="capsule-background"></div>
                        <div class="capsule-content">
                            <div>
                                <div class="capsule-header">
                                    <div class="capsule-date">Opened: <%= capsule.getOpenedAt() %></div>
                                    <div class="capsule-status">OPENED</div>
                                </div>
                                
                                <!-- Message -->
                                <p class="message-preview"><%= capsule.getMessage() %></p>
                                
                                <!-- Goal -->
                                <% if (capsule.getGoal() != null && !capsule.getGoal().isEmpty()) { %>
                                    <div class="goal-display">
                                        <div class="goal-label">📍 Goal:</div>
                                        <%= capsule.getGoal() %>
                                    </div>
                                <% } %>
                                
                                <!-- Mood comparison -->
                                <% if (capsule.getMood() != null && capsule.getReflectionMood() != null) { %>
                                    <div class="mood-comparison">
                                        <div class="mood-item">
                                            <div class="mood-item-label">Then</div>
                                            <div class="mood-item-emoji"><%= moodEmoji.getOrDefault(capsule.getMood(), "😌") %></div>
                                            <div style="font-size: 0.85rem; text-align: center;"><%= capsule.getMood() %></div>
                                        </div>
                                        <div class="mood-arrow">→</div>
                                        <div class="mood-item">
                                            <div class="mood-item-label">Now</div>
                                            <div class="mood-item-emoji"><%= moodEmoji.getOrDefault(capsule.getReflectionMood(), "😌") %></div>
                                            <div style="font-size: 0.85rem; text-align: center;"><%= capsule.getReflectionMood() %></div>
                                        </div>
                                    </div>
                                <% } %>
                            </div>
                            
                            <!-- Reflection Section -->
                            <div class="reflection-section">
                                <% if (capsule.getReflection() != null && !capsule.getReflection().isEmpty()) { %>
                                    <div class="reflection-title">✨ Your Reflection</div>
                                    <p style="font-size: 0.95rem; line-height: 1.6; margin-bottom: 15px;"><%= capsule.getReflection() %></p>
                                    <div style="font-size: 0.9rem; margin-bottom: 10px;">
                                        <strong>Achievement Status:</strong>
                                        <span style="margin-left: 8px;">
                                            <% 
                                                String status = capsule.getAchievementStatus();
                                                String statusIcon = "";
                                                if ("Achieved".equals(status)) statusIcon = "✓";
                                                else if ("Partially".equals(status)) statusIcon = "◐";
                                                else statusIcon = "✕";
                                            %>
                                            <%= statusIcon %> <%= status != null ? status : "Not Set" %>
                                        </span>
                                    </div>
                                <% } else { %>
                                    <button class="btn btn-secondary" onclick="openReflectionModal(<%= capsule.getCapsuleId() %>)" style="width: 100%; margin-top: 10px;">Add Reflection</button>
                                <% } %>
                            </div>
                            
                            <div class="capsule-actions">
                                <form method="POST" action="${pageContext.request.contextPath}/timecapsule" style="width: 100%;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="capsuleId" value="<%= capsule.getCapsuleId() %>">
                                    <button type="submit" class="capsule-btn capsule-btn-delete" onclick="return confirm('Delete this capsule?')">🗑️ Delete</button>
                                </form>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
        
        <!-- Empty state -->
        <% if (capsules.isEmpty()) { %>
            <div class="capsules-grid">
                <div class="empty-state">
                    <div class="empty-state-icon">⏳</div>
                    <div class="empty-state-text">No Time Capsules Yet</div>
                    <div class="empty-state-subtext">Create your first capsule to send a message to your future self</div>
                </div>
            </div>
        <% } %>
    </div>
    
    <!-- Create Capsule Modal -->
    <div id="createModal" class="modal" onclick="closeCreateModal(event)">
        <div class="modal-content" onclick="event.stopPropagation()">
            <button class="close-btn" onclick="closeCreateModal()">×</button>
            <div class="modal-header">⏳ Create Capsule</div>
            
            <form method="POST" id="createForm" action="${pageContext.request.contextPath}/timecapsule">
                <input type="hidden" name="action" value="create">
                
                <div class="form-group">
                    <label for="message">Your Message *</label>
                    <textarea id="message" name="message" placeholder="Write a heartfelt message to your future self..." required></textarea>
                </div>
                
                <div class="form-group">
                    <label for="goal">Goal / Promise (optional)</label>
                    <input type="text" id="goal" name="goal" placeholder="What do you want to achieve?">
                </div>
                
                <div class="form-group">
                    <label for="mood">Current Mood *</label>
                    <select id="mood" name="mood" required>
                        <option value="">Select your mood...</option>
                        <option value="Happy">😊 Happy</option>
                        <option value="Calm">😌 Calm</option>
                        <option value="Excited">🤩 Excited</option>
                        <option value="Sad">😢 Sad</option>
                        <option value="Stressed">😰 Stressed</option>
                        <option value="Peaceful">🕊️ Peaceful</option>
                        <option value="Energetic">⚡ Energetic</option>
                        <option value="Grateful">🙏 Grateful</option>
                        <option value="Hopeful">🌟 Hopeful</option>
                        <option value="Angry">😠 Angry</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="targetDate">Open Date *</label>
                    <input type="date" id="targetDate" name="targetDate" required>
                </div>
                
                <div class="modal-actions">
                    <button type="button" class="modal-btn modal-btn-cancel" onclick="closeCreateModal()">Cancel</button>
                    <button type="submit" class="modal-btn modal-btn-submit">🔐 Seal Capsule</button>
                </div>
            </form>
        </div>
    </div>
    
    <!-- Reflection Modal -->
    <div id="reflectionModal" class="modal" onclick="closeReflectionModal(event)">
        <div class="modal-content" onclick="event.stopPropagation()">
            <button class="close-btn" onclick="closeReflectionModal()">×</button>
            <div class="modal-header">✨ Your Reflection</div>
            
            <form method="POST" id="reflectionForm" action="${pageContext.request.contextPath}/timecapsule">
                <input type="hidden" name="action" value="reflect">
                <input type="hidden" id="reflectionCapsuleId" name="capsuleId">
                
                <div class="form-group">
                    <label for="reflection">What changed? *</label>
                    <textarea id="reflection" name="reflection" placeholder="Share your thoughts and feelings about this journey..." required></textarea>
                </div>
                
                <div class="form-group">
                    <label for="reflectionMood">Your Current Mood *</label>
                    <select id="reflectionMood" name="reflectionMood" required>
                        <option value="">Select your mood...</option>
                        <option value="Happy">😊 Happy</option>
                        <option value="Calm">😌 Calm</option>
                        <option value="Excited">🤩 Excited</option>
                        <option value="Sad">😢 Sad</option>
                        <option value="Stressed">😰 Stressed</option>
                        <option value="Peaceful">🕊️ Peaceful</option>
                        <option value="Energetic">⚡ Energetic</option>
                        <option value="Grateful">🙏 Grateful</option>
                        <option value="Hopeful">🌟 Hopeful</option>
                        <option value="Angry">😠 Angry</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="achievementStatus">Achievement Status *</label>
                    <select id="achievementStatus" name="achievementStatus" required>
                        <option value="">Select status...</option>
                        <option value="Achieved">✓ Achieved</option>
                        <option value="Partially">◐ Partially Achieved</option>
                        <option value="Not Achieved">✕ Not Achieved</option>
                    </select>
                </div>
                
                <div class="modal-actions">
                    <button type="button" class="modal-btn modal-btn-cancel" onclick="closeReflectionModal()">Cancel</button>
                    <button type="submit" class="modal-btn modal-btn-submit">Save Reflection</button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        // Modal functionality
        function openCreateModal() {
            document.getElementById('createModal').classList.add('show');
            document.getElementById('message').focus();
        }
        
        function closeCreateModal(event) {
            if (event && event.target !== event.currentTarget) return;
            document.getElementById('createModal').classList.remove('show');
        }
        
        function openReflectionModal(capsuleId) {
            document.getElementById('reflectionCapsuleId').value = capsuleId;
            document.getElementById('reflectionModal').classList.add('show');
            document.getElementById('reflection').focus();
        }
        
        function closeReflectionModal(event) {
            if (event && event.target !== event.currentTarget) return;
            document.getElementById('reflectionModal').classList.remove('show');
        }
        
        // Keyboard shortcuts
        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                closeCreateModal();
                closeReflectionModal();
            }
        });
        
        // Set minimum date to today
        document.getElementById('targetDate').min = new Date().toISOString().split('T')[0];
        
        // Fade out messages after 5 seconds
        document.querySelectorAll('.message-bar').forEach(function(msg) {
            if (msg.classList.contains('show')) {
                setTimeout(function() {
                    msg.style.animation = 'fadeOut 0.5s ease-out forwards';
                }, 5000);
            }
        });
    </script>
        </div>
    </main>
</body>
</html>

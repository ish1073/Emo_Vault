<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.emovault.model.Decision"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Decision Assistant | EmoVault</title>
    <link rel="stylesheet" href="css/design-system.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: var(--font-body);
            background: white;
            color: var(--color-azur);
        }

        main {
            display: flex;
            min-height: 100vh;
        }

        .main-content {
            flex: 1;
            padding: 40px;
            overflow-y: auto;
        }

        .page-header {
            margin-bottom: 50px;
            animation: fadeInUp 0.8s ease-out;
        }

        .page-title {
            font-family: var(--font-heading);
            font-size: 3rem;
            color: var(--color-heather);
            margin-bottom: 15px;
            font-weight: 700;
        }

        .page-subtitle {
            font-size: 1.1rem;
            color: var(--color-azur);
            opacity: 0.85;
        }

        /* ===== CREATE DECISION SECTION ===== */
        .create-decision-container {
            background: linear-gradient(135deg, rgba(103, 159, 159, 0.05), rgba(225, 130, 153, 0.05));
            border-radius: 25px;
            padding: 40px;
            margin-bottom: 50px;
            border: 2px solid rgba(135, 116, 153, 0.15);
            animation: fadeInUp 0.8s ease-out;
        }

        .create-decision-container h2 {
            font-family: var(--font-heading);
            font-size: 1.8rem;
            color: var(--color-heather);
            margin-bottom: 30px;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            font-weight: var(--font-weight-semibold);
            color: var(--color-azur);
            margin-bottom: 10px;
            font-size: 1rem;
        }

        .form-group textarea,
        .form-group input {
            width: 100%;
            padding: 15px;
            border: 2px solid rgba(135, 116, 153, 0.2);
            border-radius: 12px;
            font-family: var(--font-body);
            font-size: 1rem;
            color: var(--color-azur);
            background: white;
            transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
        }

        .form-group textarea:focus,
        .form-group input:focus {
            outline: none;
            border-color: var(--color-viridian);
            box-shadow: 0 0 0 3px rgba(103, 159, 159, 0.1);
        }

        .form-group textarea {
            resize: vertical;
            min-height: 100px;
            font-family: var(--font-body);
        }

        .options-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
        }

        .submit-btn {
            background: linear-gradient(135deg, var(--color-viridian), #5A8F8F);
            color: white;
            padding: 16px 45px;
            border: none;
            border-radius: 50px;
            font-size: 1.05rem;
            font-weight: var(--font-weight-semibold);
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
            box-shadow: 0 10px 30px rgba(103, 159, 159, 0.2);
        }

        .submit-btn:hover {
            transform: translateY(-4px);
            box-shadow: 0 20px 50px rgba(103, 159, 159, 0.3);
        }

        /* ===== ANALYSIS RESULT ===== */
        .analysis-result {
            background: white;
            border-radius: 25px;
            padding: 40px;
            margin-bottom: 50px;
            border: 2px solid rgba(135, 116, 153, 0.15);
            animation: fadeInUp 0.8s ease-out;
        }

        .analysis-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .analysis-header h3 {
            font-family: var(--font-heading);
            font-size: 1.6rem;
            color: var(--color-heather);
            margin-bottom: 10px;
        }

        .situation-text {
            font-size: 1.1rem;
            color: var(--color-azur);
            font-style: italic;
            opacity: 0.9;
        }

        /* ===== OPTIONS COMPARISON ===== */
        .options-comparison {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 40px;
        }

        .option-card {
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.8), rgba(251, 248, 243, 0.8));
            border-radius: 20px;
            padding: 30px;
            border: 2px solid rgba(135, 116, 153, 0.1);
            transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
            position: relative;
            overflow: hidden;
        }

        .option-card.recommended {
            border: 2px solid var(--color-viridian);
            box-shadow: 0 0 0 8px rgba(103, 159, 159, 0.1), 0 20px 50px rgba(103, 159, 159, 0.2);
            background: linear-gradient(135deg, rgba(103, 159, 159, 0.05), rgba(251, 248, 243, 0.9));
        }

        .option-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 50px rgba(135, 116, 153, 0.15);
        }

        .option-label {
            font-family: var(--font-heading);
            font-size: 1.4rem;
            color: var(--color-heather);
            margin-bottom: 15px;
            font-weight: 600;
        }

        .recommended-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: linear-gradient(135deg, var(--color-viridian), #5A8F8F);
            color: white;
            padding: 8px 16px;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: var(--font-weight-semibold);
            box-shadow: 0 5px 15px rgba(103, 159, 159, 0.3);
        }

        .option-text {
            font-size: 1.05rem;
            line-height: 1.6;
            margin-bottom: 20px;
            color: var(--color-azur);
        }

        .risk-indicator {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 20px;
            padding: 15px;
            background: rgba(255, 255, 255, 0.5);
            border-radius: 12px;
        }

        .risk-label {
            font-weight: var(--font-weight-semibold);
            color: var(--color-azur);
            min-width: 60px;
        }

        .risk-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: var(--font-weight-semibold);
            font-size: 0.9rem;
        }

        .risk-low {
            background: rgba(103, 159, 159, 0.2);
            color: #2D6B6B;
        }

        .risk-medium {
            background: rgba(230, 130, 153, 0.2);
            color: #A84860;
        }

        .risk-high {
            background: rgba(225, 130, 153, 0.3);
            color: #B33A5C;
        }

        .emotional-outcome {
            padding: 15px;
            background: linear-gradient(120deg, rgba(103, 159, 159, 0.08), rgba(225, 130, 153, 0.08));
            border-left: 4px solid var(--color-viridian);
            border-radius: 8px;
            font-size: 0.95rem;
            color: var(--color-azur);
            line-height: 1.6;
        }

        /* ===== RECOMMENDATION ===== */
        .recommendation-box {
            background: linear-gradient(135deg, var(--color-heather), #6B5577);
            color: white;
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 40px;
            text-align: center;
            box-shadow: 0 20px 50px rgba(135, 116, 153, 0.25);
            animation: fadeInUp 1s ease-out;
        }

        .recommendation-box h4 {
            font-family: var(--font-heading);
            font-size: 1.4rem;
            margin-bottom: 15px;
        }

        .recommended-text {
            font-size: 1.05rem;
            line-height: 1.6;
            opacity: 0.95;
        }

        .choose-btn {
            margin-top: 20px;
            background: white;
            color: var(--color-heather);
            padding: 12px 30px;
            border: none;
            border-radius: 50px;
            font-weight: var(--font-weight-semibold);
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
        }

        .choose-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
        }

        /* ===== DECISIONS HISTORY ===== */
        .decisions-history {
            margin-top: 60px;
        }

        .history-title {
            font-family: var(--font-heading);
            font-size: 1.8rem;
            color: var(--color-heather);
            margin-bottom: 30px;
            font-weight: 700;
        }

        .decision-item {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 20px;
            border: 2px solid rgba(135, 116, 153, 0.1);
            transition: all 0.3s ease;
        }

        .decision-item:hover {
            box-shadow: 0 10px 30px rgba(135, 116, 153, 0.15);
            border-color: var(--color-viridian);
        }

        .decision-situation {
            font-family: var(--font-heading);
            font-size: 1.1rem;
            color: var(--color-heather);
            margin-bottom: 10px;
            font-weight: 600;
        }

        .decision-options {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin: 15px 0;
            font-size: 0.95rem;
        }

        .decision-option {
            padding: 10px;
            background: rgba(135, 116, 153, 0.05);
            border-radius: 8px;
            color: var(--color-azur);
        }

        .decision-chosen {
            color: var(--color-viridian);
            font-weight: var(--font-weight-semibold);
        }

        .decision-outcome {
            padding: 15px;
            background: rgba(103, 159, 159, 0.05);
            border-left: 4px solid var(--color-viridian);
            border-radius: 8px;
            margin: 15px 0;
            font-size: 0.95rem;
            color: var(--color-azur);
        }

        .decision-date {
            font-size: 0.85rem;
            color: var(--color-azur);
            opacity: 0.7;
        }

        .decision-actions {
            display: flex;
            gap: 15px;
            margin-top: 15px;
        }

        .action-btn {
            padding: 10px 20px;
            border: 2px solid rgba(135, 116, 153, 0.3);
            background: white;
            color: var(--color-azur);
            border-radius: 20px;
            cursor: pointer;
            font-size: 0.9rem;
            font-weight: var(--font-weight-medium);
            transition: all 0.3s ease;
        }

        .action-btn:hover {
            border-color: var(--color-viridian);
            color: var(--color-viridian);
            background: rgba(103, 159, 159, 0.05);
        }

        .delete-btn {
            background: rgba(225, 130, 153, 0.1);
            border-color: rgba(225, 130, 153, 0.5);
            color: #A84860;
        }

        .delete-btn:hover {
            background: rgba(225, 130, 153, 0.2);
            border-color: #A84860;
        }

        .empty-state {
            text-align: center;
            padding: 60px 30px;
            color: var(--color-azur);
            opacity: 0.7;
        }

        .empty-icon {
            font-size: 3rem;
            margin-bottom: 15px;
        }

        /* ===== ANIMATIONS ===== */
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

        /* ===== RESPONSIVE ===== */
        @media (max-width: 1024px) {
            .main-content {
                padding: 30px;
            }

            .page-title {
                font-size: 2rem;
            }

            .options-row,
            .options-comparison {
                grid-template-columns: 1fr;
                gap: 20px;
            }
        }

        @media (max-width: 768px) {
            main {
                flex-direction: column;
            }

            .main-content {
                padding: 20px;
            }

            .page-title {
                font-size: 1.8rem;
            }

            .create-decision-container,
            .analysis-result {
                padding: 20px;
            }

            .decision-options {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <main>
        <jsp:include page="components/sidebar.jsp">
            <jsp:param name="currentPage" value="decision"/>
        </jsp:include>

        <div class="main-content">
            <div class="page-header">
                <h1 class="page-title">🎯 Decision Assistant</h1>
                <p class="page-subtitle">Evaluate your choices using emotional data and past behavior patterns</p>
            </div>

            <!-- CREATE DECISION FORM -->
            <div class="create-decision-container">
                <h2>What decision do you need help with?</h2>
                <form method="POST" action="/EmoVault/decision">
                    <input type="hidden" name="action" value="analyze">

                    <div class="form-group">
                        <label>📋 Situation or Context</label>
                        <textarea name="situation" placeholder="Describe the situation you're facing..." required></textarea>
                    </div>

                    <div class="options-row">
                        <div class="form-group">
                            <label>Option A</label>
                            <input type="text" name="optionA" placeholder="First choice or action..." required>
                        </div>
                        <div class="form-group">
                            <label>Option B</label>
                            <input type="text" name="optionB" placeholder="Second choice or action..." required>
                        </div>
                    </div>

                    <button type="submit" class="submit-btn">Get Recommendation</button>
                </form>
            </div>

            <!-- ANALYSIS RESULT -->
            <% 
                Decision analysis = (Decision) request.getAttribute("analysis");
                if (analysis != null) {
            %>
            <div class="analysis-result">
                <div class="analysis-header">
                    <h3>Your Analysis</h3>
                    <p class="situation-text">📍 <%= analysis.getSituation() %></p>
                </div>

                <!-- OPTIONS COMPARISON -->
                <div class="options-comparison">
                    <!-- OPTION A -->
                    <div class="option-card <%= "A".equals(analysis.getRecommendedOption()) ? "recommended" : "" %>">
                        <% if ("A".equals(analysis.getRecommendedOption())) { %>
                            <div class="recommended-badge">✓ Recommended</div>
                        <% } %>
                        <div class="option-label">Option A</div>
                        <p class="option-text"><%= analysis.getOptionA() %></p>

                        <div class="risk-indicator">
                            <span class="risk-label">Risk:</span>
                            <span class="risk-badge risk-<%= analysis.getRiskLevelA().toLowerCase() %>">
                                <%= analysis.getRiskLevelA() %>
                            </span>
                        </div>

                        <div class="emotional-outcome">
                            <strong>Emotional Outcome:</strong><br>
                            <%= analysis.getEmotionalOutcomeA() %>
                        </div>
                    </div>

                    <!-- OPTION B -->
                    <div class="option-card <%= "B".equals(analysis.getRecommendedOption()) ? "recommended" : "" %>">
                        <% if ("B".equals(analysis.getRecommendedOption())) { %>
                            <div class="recommended-badge">✓ Recommended</div>
                        <% } %>
                        <div class="option-label">Option B</div>
                        <p class="option-text"><%= analysis.getOptionB() %></p>

                        <div class="risk-indicator">
                            <span class="risk-label">Risk:</span>
                            <span class="risk-badge risk-<%= analysis.getRiskLevelB().toLowerCase() %>">
                                <%= analysis.getRiskLevelB() %>
                            </span>
                        </div>

                        <div class="emotional-outcome">
                            <strong>Emotional Outcome:</strong><br>
                            <%= analysis.getEmotionalOutcomeB() %>
                        </div>
                    </div>
                </div>

                <!-- RECOMMENDATION -->
                <div class="recommendation-box">
                    <h4>💡 Our Recommendation</h4>
                    <p class="recommended-text">
                        <strong>Choose Option <%= analysis.getRecommendedOption() %></strong><br><br>
                        <%= analysis.getRecommendation() %>
                    </p>
                    <form method="POST" action="/EmoVault/decision" style="display: inline;">
                        <input type="hidden" name="action" value="record">
                        <input type="hidden" name="decisionId" value="<%= analysis.getDecisionId() %>">
                        <input type="hidden" name="chosenOption" value="<%= analysis.getRecommendedOption() %>">
                        <button type="submit" class="choose-btn">Accept Recommendation</button>
                    </form>
                </div>
            </div>
            <% } %>

            <!-- DECISIONS HISTORY -->
            <div class="decisions-history">
                <h2 class="history-title">📚 Your Decision History</h2>

                <% 
                    List<Decision> decisions = (List<Decision>) request.getAttribute("decisions");
                    if (decisions != null && !decisions.isEmpty()) {
                        for (Decision decision : decisions) {
                %>
                <div class="decision-item">
                    <div class="decision-situation"><%= decision.getSituation() %></div>
                    <div class="decision-date">Created: <%= decision.getCreatedAt() %></div>

                    <div class="decision-options">
                        <div class="decision-option">
                            <strong>A:</strong> <%= decision.getOptionA() %>
                            <% if ("A".equals(decision.getChosenOption())) { %>
                                <div class="decision-chosen">✓ Chosen</div>
                            <% } %>
                        </div>
                        <div class="decision-option">
                            <strong>B:</strong> <%= decision.getOptionB() %>
                            <% if ("B".equals(decision.getChosenOption())) { %>
                                <div class="decision-chosen">✓ Chosen</div>
                            <% } %>
                        </div>
                    </div>

                    <% if (decision.getOutcome() != null && !decision.getOutcome().isEmpty()) { %>
                    <div class="decision-outcome">
                        <strong>Outcome:</strong> <%= decision.getOutcome() %>
                    </div>
                    <% } %>

                    <div class="decision-actions">
                        <% if (decision.getOutcome() == null || decision.getOutcome().isEmpty()) { %>
                        <form method="POST" action="/EmoVault/decision" style="display: inline; width: 100%;">
                            <input type="hidden" name="action" value="outcome">
                            <input type="hidden" name="decisionId" value="<%= decision.getDecisionId() %>">
                            <input type="text" name="outcome" placeholder="How did this decision work out?" required style="padding: 10px; border-radius: 20px; border: 2px solid rgba(135, 116, 153, 0.3); flex: 1; margin-right: 10px;">
                            <button type="submit" class="action-btn">Record Outcome</button>
                        </form>
                        <% } %>
                        <form method="POST" action="/EmoVault/decision" style="display: inline;">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="decisionId" value="<%= decision.getDecisionId() %>">
                            <button type="submit" class="action-btn delete-btn" onclick="return confirm('Delete this decision?')">Delete</button>
                        </form>
                    </div>
                </div>
                <% 
                        }
                    } else {
                %>
                <div class="empty-state">
                    <div class="empty-icon">🎯</div>
                    <p>No decisions yet. Start by evaluating your first choice above!</p>
                </div>
                <% } %>
            </div>
        </div>
    </main>
</body>
</html>

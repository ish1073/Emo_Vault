package com.emovault.servlet;

import com.emovault.dao.RuleDAO;
import com.emovault.model.Rule;
import com.emovault.service.ExpertAnalyticsService;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

/**
 * ExpertDashboardServlet - Displays expert dashboard with real-time analytics
 * Now uses actual user data instead of static/hardcoded values
 */
@WebServlet("/expert_dashboard")
public class ExpertDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ExpertAnalyticsService analyticsService = new ExpertAnalyticsService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if expert is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("expertId") == null) {
            response.sendRedirect(request.getContextPath() + "/expert_login.jsp");
            return;
        }

        int expertId = (Integer) session.getAttribute("expertId");

        // Create rules table if needed
        RuleDAO.createRulesTable();

        // Get system statistics from real data
        Map<String, Object> systemStats = analyticsService.getSystemOverview();
        
        // Get emotional trend summary
        Map<String, Object> trendSummary = analyticsService.getEmotionalTrendSummary();
        
        // Get high risk users
        List<Map<String, Object>> highRiskUsers = analyticsService.getHighRiskUsers(5);
        
        // Get recent emotional spikes
        List<Map<String, Object>> recentSpikes = analyticsService.getRecentEmotionalSpikes(10);
        
        // Get users with regret patterns
        List<Map<String, Object>> regretPatternUsers = analyticsService.getUsersWithRegretPatterns(5);
        
        // Get declining habit users
        List<Map<String, Object>> decliningHabitUsers = analyticsService.getDecliningHabitUsers(5);
        
        // Get users needing attention
        List<Map<String, Object>> attentionUsers = analyticsService.getUsersNeedingAttention(10);
        
        // Get recent alerts
        List<Map<String, Object>> recentAlerts = analyticsService.getRecentAlerts(15);
        
        // Get most common emotions
        Map<String, Integer> commonEmotions = analyticsService.getMostCommonEmotions(7);

        // Get expert's rules
        RuleDAO ruleDAO = new RuleDAO();
        List<Rule> rules = ruleDAO.getRulesByExpert(expertId);
        List<Rule> allActiveRules = ruleDAO.getAllActiveRules();

        // Set attributes for JSP
        request.setAttribute("systemStats", systemStats);
        request.setAttribute("trendSummary", trendSummary);
        request.setAttribute("highRiskUsers", highRiskUsers);
        request.setAttribute("recentSpikes", recentSpikes);
        request.setAttribute("regretPatternUsers", regretPatternUsers);
        request.setAttribute("decliningHabitUsers", decliningHabitUsers);
        request.setAttribute("attentionUsers", attentionUsers);
        request.setAttribute("recentAlerts", recentAlerts);
        request.setAttribute("commonEmotions", commonEmotions);
        request.setAttribute("rules", rules);
        request.setAttribute("allActiveRules", allActiveRules);
        request.setAttribute("ruleCount", rules.size());

        request.getRequestDispatcher("expert_dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if expert is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("expertId") == null) {
            response.sendRedirect(request.getContextPath() + "/expert_login.jsp");
            return;
        }

        int expertId = (Integer) session.getAttribute("expertId");
        String action = request.getParameter("action");

        try {
            if ("createRule".equals(action)) {
                handleCreateRule(request, response, expertId);
            } else if ("updateRule".equals(action)) {
                handleUpdateRule(request, response, expertId);
            } else if ("deleteRule".equals(action)) {
                handleDeleteRule(request, response, expertId);
            } else if ("toggleActive".equals(action)) {
                handleToggleActive(request, response, expertId);
            } else {
                response.sendRedirect(request.getContextPath() + "/expert_dashboard");
            }
        } catch (Exception e) {
            System.out.println("Error in ExpertDashboardServlet: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/expert_dashboard");
        }
    }

    /**
     * Handle creating a new rule
     */
    private void handleCreateRule(HttpServletRequest request, HttpServletResponse response,
                                 int expertId) throws ServletException, IOException {
        String title = request.getParameter("title");
        String condition = request.getParameter("condition");
        String conditionValue = request.getParameter("conditionValue");
        String suggestion = request.getParameter("suggestion");
        String triggerEmotion = request.getParameter("triggerEmotion");
        int priority = Integer.parseInt(request.getParameter("priority"));
        String category = request.getParameter("category");

        Rule rule = new Rule(expertId, title, condition, conditionValue, suggestion, triggerEmotion, priority, category);

        RuleDAO ruleDAO = new RuleDAO();
        int ruleId = ruleDAO.createRule(rule);

        if (ruleId > 0) {
            System.out.println("✓ Rule created with ID: " + ruleId);
        }

        response.sendRedirect(request.getContextPath() + "/expert_dashboard");
    }

    /**
     * Handle updating a rule
     */
    private void handleUpdateRule(HttpServletRequest request, HttpServletResponse response,
                                 int expertId) throws ServletException, IOException {
        int ruleId = Integer.parseInt(request.getParameter("ruleId"));

        RuleDAO ruleDAO = new RuleDAO();
        Rule rule = ruleDAO.getRuleById(ruleId);

        if (rule != null && rule.getExpertId() == expertId) {
            rule.setTitle(request.getParameter("title"));
            rule.setCondition(request.getParameter("condition"));
            rule.setConditionValue(request.getParameter("conditionValue"));
            rule.setSuggestion(request.getParameter("suggestion"));
            rule.setTriggerEmotion(request.getParameter("triggerEmotion"));
            rule.setPriority(Integer.parseInt(request.getParameter("priority")));
            rule.setCategory(request.getParameter("category"));

            ruleDAO.updateRule(rule);
            System.out.println("✓ Rule " + ruleId + " updated");
        }

        response.sendRedirect(request.getContextPath() + "/expert_dashboard");
    }

    /**
     * Handle deleting a rule
     */
    private void handleDeleteRule(HttpServletRequest request, HttpServletResponse response,
                                 int expertId) throws ServletException, IOException {
        int ruleId = Integer.parseInt(request.getParameter("ruleId"));

        RuleDAO ruleDAO = new RuleDAO();
        ruleDAO.deleteRule(ruleId, expertId);
        System.out.println("✓ Rule " + ruleId + " deleted");

        response.sendRedirect(request.getContextPath() + "/expert_dashboard");
    }

    /**
     * Handle toggling rule active status
     */
    private void handleToggleActive(HttpServletRequest request, HttpServletResponse response,
                                   int expertId) throws ServletException, IOException {
        int ruleId = Integer.parseInt(request.getParameter("ruleId"));

        RuleDAO ruleDAO = new RuleDAO();
        Rule rule = ruleDAO.getRuleById(ruleId);

        if (rule != null && rule.getExpertId() == expertId) {
            rule.setActive(!rule.isActive());
            ruleDAO.updateRule(rule);
            System.out.println("✓ Rule " + ruleId + " toggled to " + (rule.isActive() ? "active" : "inactive"));
        }

        response.sendRedirect(request.getContextPath() + "/expert_dashboard");
    }
}
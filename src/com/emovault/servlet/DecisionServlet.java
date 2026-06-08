package com.emovault.servlet;

import com.emovault.model.*;
import com.emovault.dao.*;
import com.emovault.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/decision")
public class DecisionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        int userId = (Integer) session.getAttribute("userId");
        
        // Create decisions table if needed
        DecisionDAO.createDecisionsTable();
        
        // Get all decisions for this user
        DecisionDAO decisionDAO = new DecisionDAO();
        List<Decision> decisions = decisionDAO.getUserDecisions(userId);
        
        request.setAttribute("decisions", decisions);
        request.setAttribute("decisionCount", decisions.size());
        
        request.getRequestDispatcher("decision.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        int userId = (Integer) session.getAttribute("userId");
        
        // Create decisions table if needed
        DecisionDAO.createDecisionsTable();
        
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/decision");
            return;
        }
        
        try {
            if (action.equals("analyze")) {
                handleAnalyze(request, response, userId);
            } else if (action.equals("record")) {
                handleRecord(request, response, userId);
            } else if (action.equals("outcome")) {
                handleOutcome(request, response, userId);
            } else if (action.equals("delete")) {
                handleDelete(request, response, userId);
            } else {
                response.sendRedirect(request.getContextPath() + "/decision");
            }
        } catch (Exception e) {
            System.out.println("Error in DecisionServlet: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/decision");
        }
    }
    
    /**
     * Handle decision analysis
     */
    private void handleAnalyze(HttpServletRequest request, HttpServletResponse response, 
                              int userId) throws ServletException, IOException {
        System.out.println("DEBUG: handleAnalyze called for userId=" + userId);
        
        String situation = request.getParameter("situation");
        String optionA = request.getParameter("optionA");
        String optionB = request.getParameter("optionB");
        
        System.out.println("DEBUG: situation=" + situation);
        System.out.println("DEBUG: optionA=" + optionA);
        System.out.println("DEBUG: optionB=" + optionB);
        
        // Validate input
        if (situation == null || situation.trim().isEmpty() ||
            optionA == null || optionA.trim().isEmpty() ||
            optionB == null || optionB.trim().isEmpty()) {
            System.out.println("DEBUG: Validation failed - redirecting");
            response.sendRedirect(request.getContextPath() + "/decision");
            return;
        }
        
        // Save decision
        DecisionDAO decisionDAO = new DecisionDAO();
        int decisionId = decisionDAO.saveDecision(userId, situation.trim(), optionA.trim(), optionB.trim());
        System.out.println("DEBUG: Decision saved with ID=" + decisionId);
        
        if (decisionId <= 0) {
            System.out.println("DEBUG: Save failed - redirecting");
            response.sendRedirect(request.getContextPath() + "/decision");
            return;
        }
        
        // Analyze decision
        System.out.println("DEBUG: Starting analysis...");
        Decision decision = DecisionAnalysisEngine.analyzeDecision(userId, situation, optionA, optionB);
        System.out.println("DEBUG: Analysis complete");
        decision.setDecisionId(decisionId);
        
        // Set attributes for JSP
        request.setAttribute("analysis", decision);
        request.setAttribute("decisionId", decisionId);
        request.setAttribute("showAnalysis", true);
        
        // Get all decisions to display
        List<Decision> decisions = decisionDAO.getUserDecisions(userId);
        request.setAttribute("decisions", decisions);
        request.setAttribute("decisionCount", decisions.size());
        
        System.out.println("DEBUG: Forwarding to decision.jsp with analysis");
        request.getRequestDispatcher("decision.jsp").forward(request, response);
    }
    
    /**
     * Handle recording chosen option
     */
    private void handleRecord(HttpServletRequest request, HttpServletResponse response, 
                             int userId) throws ServletException, IOException {
        try {
            int decisionId = Integer.parseInt(request.getParameter("decisionId"));
            String chosenOption = request.getParameter("chosenOption");
            
            DecisionDAO decisionDAO = new DecisionDAO();
            decisionDAO.recordChoice(decisionId, userId, chosenOption);
            
            response.sendRedirect(request.getContextPath() + "/decision");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/decision");
        }
    }
    
    /**
     * Handle recording outcome
     */
    private void handleOutcome(HttpServletRequest request, HttpServletResponse response, 
                              int userId) throws ServletException, IOException {
        try {
            int decisionId = Integer.parseInt(request.getParameter("decisionId"));
            String outcome = request.getParameter("outcome");
            
            DecisionDAO decisionDAO = new DecisionDAO();
            decisionDAO.recordOutcome(decisionId, userId, outcome.trim());
            
            response.sendRedirect(request.getContextPath() + "/decision");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/decision");
        }
    }
    
    /**
     * Handle deleting a decision
     */
    private void handleDelete(HttpServletRequest request, HttpServletResponse response, 
                             int userId) throws ServletException, IOException {
        try {
            int decisionId = Integer.parseInt(request.getParameter("decisionId"));
            
            DecisionDAO decisionDAO = new DecisionDAO();
            decisionDAO.deleteDecision(decisionId, userId);
            
            response.sendRedirect(request.getContextPath() + "/decision");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/decision");
        }
    }
}

package com.emovault.servlet;

import com.emovault.model.BehaviorAnalysis;
import com.emovault.util.BehaviorAnalysisEngine;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet for Behavior Analyzer Module
 * Handles analysis requests and forwards to JSP for display
 */
public class BehaviorAnalyzerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Session validation
        HttpSession session = request.getSession(false);
        Integer userId = (Integer) (session != null ? session.getAttribute("userId") : null);
        
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Prevent caching to always show fresh data
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        
        // Perform behavior analysis
        BehaviorAnalysis analysis = BehaviorAnalysisEngine.analyzeBehavior(userId);
        
        // Set attributes for JSP
        request.setAttribute("analysis", analysis);
        
        // Forward to JSP
        request.getRequestDispatcher("behavior_analyzer.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // For now, POST just refreshes the analysis (in case user adds new data)
        doGet(request, response);
    }
}

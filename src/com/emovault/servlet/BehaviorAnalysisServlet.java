package com.emovault.servlet;

import com.emovault.service.BehaviorAnalyzer;
import com.emovault.util.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

/**
 * Behavior Analysis Servlet
 * Serves real behavioral insights based on actual user data analysis
 * Replaces hardcoded/demo behavior analyzer content
 */
@WebServlet("/BehaviorAnalysis")
public class BehaviorAnalysisServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        int userId = (Integer) session.getAttribute("user_id");
        String period = request.getParameter("period");
        if (period == null || period.isEmpty()) {
            period = "30"; // Default to last 30 days
        }
        
        int daysPeriod = Integer.parseInt(period);
        
        // Get real behavior analysis based on actual user data
        Map<String, Object> analysis = BehaviorAnalyzer.analyzeBehavior(userId, daysPeriod);
        
        // Set request attributes for JSP
        request.setAttribute("analysis", analysis);
        request.setAttribute("period", daysPeriod);
        request.setAttribute("emotionalPatterns", analysis.get("emotionalPatterns"));
        request.setAttribute("triggersAndThemes", analysis.get("triggersAndThemes"));
        request.setAttribute("decisionPatterns", analysis.get("decisionPatterns"));
        request.setAttribute("riskFactors", analysis.get("riskFactors"));
        request.setAttribute("positiveTrends", analysis.get("positiveTrends"));
        request.setAttribute("recommendations", analysis.get("recommendations"));
        
        // Forward to behavior analysis JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/behavior_analysis.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

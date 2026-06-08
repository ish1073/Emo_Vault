package com.emovault.servlet;

import com.emovault.service.analysis.BehaviorAnalysisService;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;

/**
 * Servlet for Behavior Analyzer Module
 * Handles analysis requests and forwards to JSP for display
 * Uses the new dynamic BehaviorAnalysisService for real-time insights
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
        
        // Get analysis period from request parameter (default: 30 days)
        int period = 30;
        String periodParam = request.getParameter("period");
        if (periodParam != null) {
            try {
                period = Integer.parseInt(periodParam);
                // Validate period is one of the allowed values
                if (period != 7 && period != 30 && period != 90) {
                    period = 30;
                }
            } catch (NumberFormatException e) {
                period = 30;
            }
        }
        
        // Prevent caching to always show fresh data
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        
        // Perform comprehensive behavior analysis using the new service
        Map<String, Object> analysis = BehaviorAnalysisService.analyzeBehavior(userId, period);
        
        // Set attributes for JSP
        request.setAttribute("analysis", analysis);
        request.setAttribute("period", period);
        
        // Extract nested data for easier JSP access
        if (analysis.containsKey("emotionalPatterns")) {
            request.setAttribute("emotionalPatterns", analysis.get("emotionalPatterns"));
        }
        if (analysis.containsKey("triggersAndThemes")) {
            request.setAttribute("triggersAndThemes", analysis.get("triggersAndThemes"));
        }
        if (analysis.containsKey("decisionPatterns")) {
            request.setAttribute("decisionPatterns", analysis.get("decisionPatterns"));
        }
        if (analysis.containsKey("riskFactors")) {
            request.setAttribute("riskFactors", analysis.get("riskFactors"));
        }
        if (analysis.containsKey("positiveTrends")) {
            request.setAttribute("positiveTrends", analysis.get("positiveTrends"));
        }
        if (analysis.containsKey("recommendations")) {
            request.setAttribute("recommendations", analysis.get("recommendations"));
        }
        if (analysis.containsKey("riskAnalysis")) {
            request.setAttribute("riskAnalysis", analysis.get("riskAnalysis"));
        }
        if (analysis.containsKey("insights")) {
            request.setAttribute("insights", analysis.get("insights"));
        }
        if (analysis.containsKey("dataCounts")) {
            request.setAttribute("dataCounts", analysis.get("dataCounts"));
        }
        
        // Forward to JSP
        request.getRequestDispatcher("behavior_analysis.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // POST just refreshes the analysis (in case user adds new data)
        doGet(request, response);
    }
}
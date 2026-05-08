package com.emovault.servlet;

import com.emovault.dao.DiaryDAO;
import com.emovault.model.DiaryEntry;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * DiaryServlet - Handles diary entry operations
 * GET: Display diary page
 * POST: Save new diary entry
 */
public class DiaryServlet extends HttpServlet {
    private DiaryDAO diaryDAO = new DiaryDAO();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        // Prevent caching to always show fresh data
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);
        
        // Check if user is logged in
        HttpSession session = req.getSession(false);
        Integer userId = (Integer) (session != null ? session.getAttribute("userId") : null);
        
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        
        // Retrieve all diary entries for this user
        List<DiaryEntry> diaries = diaryDAO.getUserDiaries(userId);
        req.setAttribute("diaries", diaries);
        
        // Forward to diary page
        req.getRequestDispatcher("diary.jsp").forward(req, resp);
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        // Prevent caching
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);
        
        // Check if user is logged in
        HttpSession session = req.getSession(false);
        Integer userId = (Integer) (session != null ? session.getAttribute("userId") : null);
        
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        
        // Get form parameters
        String title = req.getParameter("title");
        String content = req.getParameter("content");
        String moodTag = req.getParameter("moodTag");
        
        // Validation
        if (title == null || title.trim().length() < 3) {
            req.setAttribute("error", "Please provide a title (minimum 3 characters)");
            List<DiaryEntry> diaries = diaryDAO.getUserDiaries(userId);
            req.setAttribute("diaries", diaries);
            req.getRequestDispatcher("diary.jsp").forward(req, resp);
            return;
        }
        
        if (content == null || content.trim().length() < 10) {
            req.setAttribute("error", "Please write something meaningful (minimum 10 characters)");
            List<DiaryEntry> diaries = diaryDAO.getUserDiaries(userId);
            req.setAttribute("diaries", diaries);
            req.getRequestDispatcher("diary.jsp").forward(req, resp);
            return;
        }
        
        // Save diary entry
        int entryId = diaryDAO.saveDiaryEntry(userId, title.trim(), content.trim(), moodTag);
        
        // Retrieve and set diaries list for display
        List<DiaryEntry> diaries = diaryDAO.getUserDiaries(userId);
        req.setAttribute("diaries", diaries);
        
        if (entryId > 0) {
            System.out.println("[EmoVault] Diary Entry #" + entryId + " saved for user " + userId);
            req.setAttribute("success", "✨ Diary entry saved successfully!");
        } else {
            req.setAttribute("error", "Failed to save diary entry. Please try again.");
        }
        
        req.getRequestDispatcher("diary.jsp").forward(req, resp);
    }
}

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.emovault.util.DBConnection" %>

<html>
<body>
<h1>Regret Test - Add Sample Entries</h1>

<%
String action = request.getParameter("action");

if ("add".equals(action)) {
    // ADD SAMPLE REGRETS
    try {
        Connection conn = DBConnection.getConnection();
        Statement stmt = conn.createStatement();
        
        // Get the first user (usually user_id = 1)
        ResultSet rs = stmt.executeQuery("SELECT user_id FROM users LIMIT 1");
        int userId = 0;
        if (rs.next()) {
            userId = rs.getInt("user_id");
        }
        
        if (userId > 0) {
            // Add sample regrets
            int rows1 = stmt.executeUpdate(
                "INSERT INTO regrets (user_id, description, lesson_learned, tag) VALUES (" + userId + 
                ", 'I procrastinated on an important project', 'I should have started earlier and broken it into smaller tasks', 'procrastination')"
            );
            
            int rows2 = stmt.executeUpdate(
                "INSERT INTO regrets (user_id, description, lesson_learned, tag) VALUES (" + userId + 
                ", 'Did not communicate my concerns to my team', 'Speaking up early prevents bigger problems later', 'communication')"
            );
            
            int rows3 = stmt.executeUpdate(
                "INSERT INTO regrets (user_id, description, lesson_learned, tag) VALUES (" + userId + 
                ", 'Let stress build up instead of taking breaks', 'Taking short breaks improves overall productivity and well-being', 'stress')"
            );
            
            if (rows1 > 0 || rows2 > 0 || rows3 > 0) {
                out.println("<p style='color: green;'><strong>✓ Successfully added " + (rows1 + rows2 + rows3) + " sample regrets!</strong></p>");
                out.println("<p>Now go to <a href='regret.jsp'>Regret Page</a> to see them in the 'Past Reflections' section.</p>");
            }
        }
        
        stmt.close();
        conn.close();
    } catch (Exception e) {
        out.println("<p style='color: red;'>ERROR: " + e.getMessage() + "</p>");
        e.printStackTrace(out);
    }
} else {
    // CHECK STATUS
    try {
        Connection conn = DBConnection.getConnection();
        if (conn != null) {
            out.println("<p>DB Connected</p>");
            
            // Get first user
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT user_id FROM users LIMIT 1");
            int userId = 0;
            if (rs.next()) {
                userId = rs.getInt("user_id");
            }
            
            if (userId > 0) {
                // Count regrets for this user
                rs = stmt.executeQuery("SELECT COUNT(*) as cnt FROM regrets WHERE user_id = " + userId);
                if (rs.next()) {
                    int count = rs.getInt("cnt");
                    out.println("<p>Regrets for user " + userId + ": " + count + "</p>");
                    
                    if (count == 0) {
                        out.println("<form method='get'><input type='hidden' name='action' value='add'><button type='submit'>Add Sample Regrets</button></form>");
                    } else {
                        out.println("<p style='color: green;'>✓ Regrets already exist!</p>");
                    }
                    
                    // List them
                    out.println("<h3>Current Regrets:</h3>");
                    rs = stmt.executeQuery("SELECT regret_id, description, lesson_learned, tag FROM regrets WHERE user_id = " + userId);
                    out.println("<ul>");
                    while (rs.next()) {
                        out.println("<li><strong>" + rs.getString("description") + "</strong> (Tag: " + rs.getString("tag") + ")</li>");
                        out.println("<li style='margin-left: 20px; color: #666;'>Lesson: " + rs.getString("lesson_learned") + "</li>");
                    }
                    out.println("</ul>");
                }
            }
            
            stmt.close();
            conn.close();
        } else {
            out.println("<p>No connection</p>");
        }
    } catch (Exception e) {
        out.println("<p>ERROR: " + e + "</p>");
    }
}
%>

<hr>
<p><a href="regret.jsp">← Go to Regret Page</a></p>
</body>
</html>

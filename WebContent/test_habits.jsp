<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.emovault.dao.HabitDAO" %>
<%@ page import="com.emovault.model.Habit" %>
<%@ page import="com.emovault.util.DBConnection" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.util.List" %>

<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Habit Debug Test</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .debug-box { background: #f0f0f0; padding: 15px; margin: 10px 0; border: 1px solid #ccc; border-radius: 5px; }
        .success { color: green; }
        .error { color: red; }
        code { background: #fff; padding: 2px 5px; border: 1px solid #ddd; }
        h2 { color: #333; border-bottom: 2px solid #007bff; padding-bottom: 10px; }
    </style>
</head>
<body>
    <h1>🔍 Habit Module Debug Test</h1>
    
    <div class="debug-box">
        <h2>Current User Info</h2>
        <p><strong>User ID:</strong> <%= userId %></p>
        <p><strong>User Name:</strong> <%= session.getAttribute("userName") %></p>
    </div>

    <div class="debug-box">
        <h2>Database Connection Test</h2>
        <%
            Connection conn = null;
            try {
                conn = DBConnection.getConnection();
                if (conn != null) {
                    out.println("<p class='success'>✓ Database connection successful</p>");
                    
                    HabitDAO habitDAO = new HabitDAO(conn);
                    List<Habit> habits = habitDAO.getAllHabitsByUserId(userId);
                    
                    out.println("<h3>Habits Retrieved: " + habits.size() + "</h3>");
                    
                    if (habits.isEmpty()) {
                        out.println("<p class='error'>⚠ No habits found for this user</p>");
                    } else {
                        out.println("<table border='1' cellpadding='10'>");
                        out.println("<tr><th>ID</th><th>Name</th><th>Description</th><th>Active</th><th>Created</th></tr>");
                        for (Habit h : habits) {
                            out.println("<tr>");
                            out.println("<td>" + h.getHabitId() + "</td>");
                            out.println("<td>" + h.getName() + "</td>");
                            out.println("<td>" + h.getDescription() + "</td>");
                            out.println("<td>" + h.isActive() + "</td>");
                            out.println("<td>" + h.getCreatedDate() + "</td>");
                            out.println("</tr>");
                        }
                        out.println("</table>");
                    }
                } else {
                    out.println("<p class='error'>✗ Database connection failed</p>");
                }
            } catch (Exception e) {
                out.println("<p class='error'>✗ Error: " + e.getMessage() + "</p>");
                e.printStackTrace(new java.io.PrintWriter(out));
            } finally {
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (Exception e) {}
                }
            }
        %>
    </div>

    <div class="debug-box">
        <h2>Create Test Habit</h2>
        <%
            if (request.getParameter("createTest") != null) {
                Connection testConn = null;
                try {
                    testConn = DBConnection.getConnection();
                    HabitDAO habitDAO = new HabitDAO(testConn);
                    
                    Habit testHabit = new Habit();
                    testHabit.setUserId(userId);
                    testHabit.setName("TEST_HABIT_" + System.currentTimeMillis());
                    testHabit.setDescription("This is a test habit created on " + new java.util.Date());
                    testHabit.setActive(true);
                    
                    boolean result = habitDAO.addHabit(testHabit);
                    
                    if (result) {
                        out.println("<p class='success'>✓ Test habit created successfully!</p>");
                        out.println("<p>Habit Name: " + testHabit.getName() + "</p>");
                    } else {
                        out.println("<p class='error'>✗ Failed to create test habit</p>");
                    }
                } catch (Exception e) {
                    out.println("<p class='error'>✗ Error creating test habit: " + e.getMessage() + "</p>");
                    e.printStackTrace(new java.io.PrintWriter(out));
                } finally {
                    if (testConn != null) {
                        try {
                            testConn.close();
                        } catch (Exception e) {}
                    }
                }
            }
        %>
        <form method="post">
            <button type="submit" name="createTest" value="true">Create Test Habit</button>
        </form>
    </div>

    <div class="debug-box">
        <h2>Actions</h2>
        <p><a href="<%= request.getContextPath() %>/habit">← Back to Habits Page</a></p>
        <p><a href="<%= request.getContextPath() %>/logout.jsp">Logout</a></p>
    </div>
</body>
</html>

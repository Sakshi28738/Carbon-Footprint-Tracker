package com.cftracker;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class LoginServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // Validate input
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            
            response.sendRedirect("login.jsp?error=Please fill all fields");
            return;
        }
        
        // Attempt login
        int userId = UserDAO.login(username, password);
        
        if (userId != -1) {
            // Login successful - create session
            HttpSession session = request.getSession();
            session.setAttribute("userId", userId);
            session.setAttribute("username", username);
            
            response.sendRedirect("dashboard.jsp");
        } else {
            // Login failed
            response.sendRedirect("login.jsp?error=Invalid username or password");
        }
    }
}
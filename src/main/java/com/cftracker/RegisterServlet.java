package com.cftracker;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class RegisterServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // Validate input
        if (username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            
            response.sendRedirect("register.jsp?error=Please fill all fields");
            return;
        }
        
        // Register user
        if (UserDAO.register(username, email, password)) {
            response.sendRedirect("login.jsp?success=Registration successful! Please login.");
        } else {
            response.sendRedirect("register.jsp?error=Registration failed. Username or email may already exist.");
        }
    }
}
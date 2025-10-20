package com.cftracker;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class AddTripServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp?error=Please login first");
            return;
        }
        
        int userId = (Integer) session.getAttribute("userId");
        String transportMode = request.getParameter("transportMode");
        String distanceStr = request.getParameter("distance");
        String tripDate = request.getParameter("tripDate");
        
        // Validate input
        if (transportMode == null || transportMode.trim().isEmpty() ||
            distanceStr == null || distanceStr.trim().isEmpty() ||
            tripDate == null || tripDate.trim().isEmpty()) {
            
            response.sendRedirect("addTrip.jsp?error=Please fill all fields");
            return;
        }
        
        try {
            double distance = Double.parseDouble(distanceStr);
            
            if (distance <= 0) {
                response.sendRedirect("addTrip.jsp?error=Distance must be greater than 0");
                return;
            }
            
            // Add trip
            if (TripDAO.addTrip(userId, transportMode, distance, tripDate)) {
                response.sendRedirect("dashboard.jsp?success=Trip added successfully");
            } else {
                response.sendRedirect("addTrip.jsp?error=Failed to add trip");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("addTrip.jsp?error=Invalid distance value");
        }
    }
}
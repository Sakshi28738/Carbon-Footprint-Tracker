<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Check if user is logged in
    Integer userId = (Integer) session.getAttribute("userId");
    String username = (String) session.getAttribute("username");
    
    if (userId == null) {
        response.sendRedirect("login.jsp?error=Please login first");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Trip - Carbon Footprint Tracker</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
        }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .header-content {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .header h1 {
            font-size: 24px;
        }
        .back-btn {
            background: rgba(255,255,255,0.2);
            color: white;
            padding: 8px 16px;
            border: 1px solid white;
            border-radius: 5px;
            text-decoration: none;
            font-weight: bold;
            transition: background 0.3s;
        }
        .back-btn:hover {
            background: rgba(255,255,255,0.3);
        }
        .container {
            max-width: 600px;
            margin: 50px auto;
            padding: 0 20px;
        }
        .form-card {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        h2 {
            color: #333;
            margin-bottom: 30px;
            text-align: center;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: bold;
        }
        input[type="number"],
        input[type="date"],
        select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        input:focus,
        select:focus {
            outline: none;
            border-color: #667eea;
        }
        button {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: transform 0.2s;
        }
        button:hover {
            transform: scale(1.02);
        }
        .error {
            background: #f8d7da;
            color: #721c24;
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
        }
        .info-box {
            background: #e7f5ff;
            border-left: 4px solid #1971c2;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        .info-box h4 {
            color: #1971c2;
            margin-bottom: 10px;
        }
        .info-box ul {
            margin-left: 20px;
            color: #495057;
        }
        .info-box li {
            margin-bottom: 5px;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-content">
            <h1>🌍 Add New Trip</h1>
            <a href="dashboard.jsp" class="back-btn">← Back to Dashboard</a>
        </div>
    </div>
    
    <div class="container">
        <div class="form-card">
            <h2>Record Your Journey</h2>
            
            <% 
                String error = request.getParameter("error");
                if (error != null) { 
            %>
                <div class="error"><%= error %></div>
            <% } %>
            
            <div class="info-box">
                <h4>ℹ️ Carbon Emission Factors (kg CO₂ per km)</h4>
                <ul>
                    <li><strong>Car:</strong> 0.21 kg/km</li>
                    <li><strong>Bus:</strong> 0.10 kg/km</li>
                    <li><strong>Train:</strong> 0.04 kg/km</li>
                    <li><strong>Motorcycle:</strong> 0.12 kg/km</li>
                    <li><strong>Flight:</strong> 0.25 kg/km</li>
                    <li><strong>Bike/Walk:</strong> 0.00 kg/km (Eco-friendly! 🌱)</li>
                </ul>
            </div>
            
            <form action="addTrip" method="post">
                <div class="form-group">
                    <label for="transportMode">Transport Mode:</label>
                    <select id="transportMode" name="transportMode" required>
                        <option value="">-- Select Mode --</option>
                        <option value="Car">🚗 Car</option>
                        <option value="Bus">🚌 Bus</option>
                        <option value="Train">🚆 Train</option>
                        <option value="Motorcycle">🏍️ Motorcycle</option>
                        <option value="Bike">🚲 Bicycle</option>
                        <option value="Walk">🚶 Walking</option>
                        <option value="Flight">✈️ Flight</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="distance">Distance (km):</label>
                    <input type="number" id="distance" name="distance" step="0.01" min="0.01" required placeholder="e.g., 15.5">
                </div>
                
                <div class="form-group">
                    <label for="tripDate">Trip Date:</label>
                    <input type="date" id="tripDate" name="tripDate" required max="<%= java.time.LocalDate.now() %>">
                </div>
                
                <button type="submit">➕ Add Trip</button>
            </form>
        </div>
    </div>
</body>
</html>
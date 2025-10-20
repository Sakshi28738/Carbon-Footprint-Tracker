<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.cftracker.TripDAO" %>
<%@ page import="com.cftracker.Trip" %>
<%
    // Check if user is logged in
    Integer userId = (Integer) session.getAttribute("userId");
    String username = (String) session.getAttribute("username");
    
    if (userId == null) {
        response.sendRedirect("login.jsp?error=Please login first");
        return;
    }
    
    // Get user's trips and total carbon footprint
    List<Trip> trips = TripDAO.getTripsByUserId(userId);
    double totalCarbon = TripDAO.getTotalCarbonFootprint(userId);
    
    // Calculate emissions by transport mode
    Map<String, Double> emissionsByMode = new HashMap<>();
    Map<String, Integer> tripsByMode = new HashMap<>();
    
    for (Trip trip : trips) {
        String mode = trip.getTransportMode();
        emissionsByMode.put(mode, emissionsByMode.getOrDefault(mode, 0.0) + trip.getCarbonFootprint());
        tripsByMode.put(mode, tripsByMode.getOrDefault(mode, 0) + 1);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Carbon Footprint Tracker</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
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
        .user-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        .logout-btn {
            background: rgba(255,255,255,0.2);
            color: white;
            padding: 8px 16px;
            border: 1px solid white;
            border-radius: 5px;
            text-decoration: none;
            font-weight: bold;
            transition: background 0.3s;
        }
        .logout-btn:hover {
            background: rgba(255,255,255,0.3);
        }
        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            text-align: center;
        }
        .stat-card h3 {
            color: #666;
            font-size: 14px;
            margin-bottom: 10px;
        }
        .stat-card .value {
            font-size: 32px;
            font-weight: bold;
            color: #667eea;
        }
        .add-trip-btn {
            display: inline-block;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 12px 24px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: bold;
            margin-bottom: 20px;
            transition: transform 0.2s;
        }
        .add-trip-btn:hover {
            transform: scale(1.05);
        }
        
        /* Chart Section */
        .charts-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .chart-card {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .chart-card h3 {
            color: #333;
            margin-bottom: 20px;
            text-align: center;
        }
        .chart-container {
            position: relative;
            height: 300px;
        }
        
        .trips-section {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .trips-section h2 {
            margin-bottom: 20px;
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th {
            background: #f8f9fa;
            padding: 12px;
            text-align: left;
            font-weight: bold;
            color: #555;
            border-bottom: 2px solid #dee2e6;
        }
        td {
            padding: 12px;
            border-bottom: 1px solid #dee2e6;
        }
        tr:hover {
            background: #f8f9fa;
        }
        .no-trips {
            text-align: center;
            padding: 40px;
            color: #999;
        }
        .success {
            background: #d4edda;
            color: #155724;
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .transport-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: bold;
            text-transform: capitalize;
        }
        .badge-car { background: #ffe5e5; color: #c92a2a; }
        .badge-bus { background: #fff3bf; color: #e67700; }
        .badge-train { background: #d3f9d8; color: #2b8a3e; }
        .badge-bike { background: #e7f5ff; color: #1971c2; }
        .badge-walk { background: #e7f5ff; color: #1971c2; }
        .badge-motorcycle { background: #ffe8cc; color: #d9480f; }
        .badge-flight { background: #f3d9fa; color: #862e9c; }
        
        @media (max-width: 768px) {
            .charts-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-content">
            <h1>🌍 Carbon Footprint Tracker</h1>
            <div class="user-info">
                <span>Welcome, <strong><%= username %></strong>!</span>
                <a href="logout" class="logout-btn">Logout</a>
            </div>
        </div>
    </div>
    
    <div class="container">
        <% 
            String success = request.getParameter("success");
            if (success != null) { 
        %>
            <div class="success"><%= success %></div>
        <% } %>
        
        <div class="stats-grid">
            <div class="stat-card">
                <h3>Total Trips</h3>
                <div class="value"><%= trips.size() %></div>
            </div>
            <div class="stat-card">
                <h3>Total Carbon Footprint</h3>
                <div class="value"><%= String.format("%.2f", totalCarbon) %> kg</div>
            </div>
            <div class="stat-card">
                <h3>Average per Trip</h3>
                <div class="value">
                    <%= trips.size() > 0 ? String.format("%.2f", totalCarbon / trips.size()) : "0.00" %> kg
                </div>
            </div>
        </div>
        
        <a href="addTrip.jsp" class="add-trip-btn">➕ Add New Trip</a>
        
        <% if (!trips.isEmpty()) { %>
        <!-- Charts Section -->
        <div class="charts-grid">
            <div class="chart-card">
                <h3>📊 Emissions by Transport Mode</h3>
                <div class="chart-container">
                    <canvas id="emissionsChart"></canvas>
                </div>
            </div>
            <div class="chart-card">
                <h3>🚗 Trip Count by Transport Mode</h3>
                <div class="chart-container">
                    <canvas id="tripsChart"></canvas>
                </div>
            </div>
        </div>
        <% } %>
        
        <div class="trips-section">
            <h2>Your Trips</h2>
            
            <% if (trips.isEmpty()) { %>
                <div class="no-trips">
                    <p>No trips recorded yet. Start tracking your carbon footprint by adding your first trip!</p>
                </div>
            <% } else { %>
                <table>
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Transport Mode</th>
                            <th>Distance (km)</th>
                            <th>Carbon Footprint (kg CO₂)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Trip trip : trips) { 
                            String badgeClass = "badge-" + trip.getTransportMode().toLowerCase();
                        %>
                        <tr>
                            <td><%= trip.getTripDate() %></td>
                            <td>
                                <span class="transport-badge <%= badgeClass %>">
                                    <%= trip.getTransportMode() %>
                                </span>
                            </td>
                            <td><%= String.format("%.2f", trip.getDistance()) %></td>
                            <td><%= String.format("%.2f", trip.getCarbonFootprint()) %></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>
    </div>
    
    <% if (!trips.isEmpty()) { %>
    <script>
        // Prepare data for charts
        const emissionsData = {
            <% 
            boolean first = true;
            for (Map.Entry<String, Double> entry : emissionsByMode.entrySet()) {
                if (!first) out.print(",");
                out.print("'" + entry.getKey() + "': " + entry.getValue());
                first = false;
            }
            %>
        };
        
        const tripsData = {
            <% 
            first = true;
            for (Map.Entry<String, Integer> entry : tripsByMode.entrySet()) {
                if (!first) out.print(",");
                out.print("'" + entry.getKey() + "': " + entry.getValue());
                first = false;
            }
            %>
        };
        
        const labels = Object.keys(emissionsData);
        const emissionsValues = Object.values(emissionsData);
        const tripsValues = Object.values(tripsData);
        
        // Color scheme
        const colors = {
            'Car': '#ff6b6b',
            'Bus': '#ffd43b',
            'Train': '#51cf66',
            'Bike': '#74c0fc',
            'Walk': '#74c0fc',
            'Motorcycle': '#ff8787',
            'Flight': '#da77f2'
        };
        
        const backgroundColors = labels.map(label => colors[label] || '#868e96');
        
        // Emissions Chart (Bar)
        const ctx1 = document.getElementById('emissionsChart').getContext('2d');
        new Chart(ctx1, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'CO₂ Emissions (kg)',
                    data: emissionsValues,
                    backgroundColor: backgroundColors,
                    borderRadius: 8
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        title: {
                            display: true,
                            text: 'kg CO₂'
                        }
                    }
                }
            }
        });
        
        // Trips Chart (Doughnut)
        const ctx2 = document.getElementById('tripsChart').getContext('2d');
        new Chart(ctx2, {
            type: 'doughnut',
            data: {
                labels: labels,
                datasets: [{
                    data: tripsValues,
                    backgroundColor: backgroundColors,
                    borderWidth: 2,
                    borderColor: '#fff'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });
    </script>
    <% } %>
</body>
</html>
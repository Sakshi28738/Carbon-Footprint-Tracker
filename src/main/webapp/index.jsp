<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Welcome - Carbon Footprint Tracker</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .container {
            text-align: center;
            color: white;
            padding: 40px;
        }
        h1 {
            font-size: 48px;
            margin-bottom: 20px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        p {
            font-size: 20px;
            margin-bottom: 40px;
            opacity: 0.9;
        }
        .button-group {
            display: flex;
            gap: 20px;
            justify-content: center;
        }
        .btn {
            padding: 15px 40px;
            font-size: 18px;
            font-weight: bold;
            border: 2px solid white;
            border-radius: 50px;
            text-decoration: none;
            color: white;
            background: rgba(255,255,255,0.1);
            transition: all 0.3s;
            cursor: pointer;
        }
        .btn:hover {
            background: white;
            color: #667eea;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
        }
        .features {
            margin-top: 60px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 30px;
            max-width: 800px;
            margin-left: auto;
            margin-right: auto;
        }
        .feature {
            background: rgba(255,255,255,0.1);
            padding: 20px;
            border-radius: 10px;
            backdrop-filter: blur(10px);
        }
        .feature-icon {
            font-size: 40px;
            margin-bottom: 10px;
        }
        .feature h3 {
            font-size: 18px;
            margin-bottom: 10px;
        }
        .feature p {
            font-size: 14px;
            opacity: 0.8;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🌍 Carbon Footprint Tracker</h1>
        <p>Track your transportation emissions and make a difference for our planet</p>
        
        <div class="button-group">
            <a href="register.jsp" class="btn">Register</a>
            <a href="login.jsp" class="btn">Login</a>
        </div>
        
        <div class="features">
            <div class="feature">
                <div class="feature-icon">📊</div>
                <h3>Track Trips</h3>
                <p>Record your daily transportation and see your impact</p>
            </div>
            <div class="feature">
                <div class="feature-icon">🌱</div>
                <h3>Calculate CO₂</h3>
                <p>Automatic carbon footprint calculation for each trip</p>
            </div>
            <div class="feature">
                <div class="feature-icon">📈</div>
                <h3>View Statistics</h3>
                <p>Monitor your progress and reduce your emissions</p>
            </div>
        </div>
    </div>
</body>
</html>
package com.cftracker;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

public class TripDAO {
    
    // Add a new trip
    public static boolean addTrip(int userId, String transportMode, double distance, String tripDate) {
        try (Connection conn = DBUtil.getConnection()) {
            // Calculate carbon footprint based on transport mode
            double carbonFootprint = calculateCarbonFootprint(transportMode, distance);
            
            String sql = "INSERT INTO trips (user_id, transport_mode, distance, carbon_footprint, trip_date) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setString(2, transportMode);
            stmt.setDouble(3, distance);
            stmt.setDouble(4, carbonFootprint);
            stmt.setDate(5, Date.valueOf(tripDate));
            
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get all trips for a user
    public static List<Trip> getTripsByUserId(int userId) {
        List<Trip> trips = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT * FROM trips WHERE user_id = ? ORDER BY trip_date DESC";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Trip trip = new Trip();
                trip.setId(rs.getInt("id"));
                trip.setUserId(rs.getInt("user_id"));
                trip.setTransportMode(rs.getString("transport_mode"));
                trip.setDistance(rs.getDouble("distance"));
                trip.setCarbonFootprint(rs.getDouble("carbon_footprint"));
                trip.setTripDate(rs.getDate("trip_date").toString());
                trips.add(trip);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return trips;
    }
    
    // Calculate total carbon footprint for a user
    public static double getTotalCarbonFootprint(int userId) {
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT SUM(carbon_footprint) as total FROM trips WHERE user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getDouble("total");
            }
            return 0.0;
        } catch (Exception e) {
            e.printStackTrace();
            return 0.0;
        }
    }
    
    // Calculate carbon footprint based on transport mode (kg CO2 per km)
    private static double calculateCarbonFootprint(String transportMode, double distance) {
        double emissionFactor;
        
        switch (transportMode.toLowerCase()) {
            case "car":
                emissionFactor = 0.21; // kg CO2 per km
                break;
            case "bus":
                emissionFactor = 0.10;
                break;
            case "train":
                emissionFactor = 0.04;
                break;
            case "bike":
            case "bicycle":
                emissionFactor = 0.0;
                break;
            case "walk":
            case "walking":
                emissionFactor = 0.0;
                break;
            case "motorcycle":
                emissionFactor = 0.12;
                break;
            case "flight":
            case "plane":
                emissionFactor = 0.25;
                break;
            default:
                emissionFactor = 0.15; // default
        }
        
        return distance * emissionFactor;
    }
}
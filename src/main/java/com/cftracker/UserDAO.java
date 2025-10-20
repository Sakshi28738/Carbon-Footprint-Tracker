package com.cftracker;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {
    
    // Register new user
    public static boolean register(String username, String email, String password) {
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "INSERT INTO users (username, email, password) VALUES (?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, email);
            stmt.setString(3, password);
            
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Login user - returns user ID if successful, -1 if failed
    public static int login(String username, String password) {
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT id FROM users WHERE username = ? AND password = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("id");
            }
            return -1;
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }
    
    // Get username by user ID
    public static String getUsernameById(int userId) {
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT username FROM users WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getString("username");
            }
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
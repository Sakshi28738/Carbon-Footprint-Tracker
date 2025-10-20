package com.cftracker;

public class Trip {
    private int id;
    private int userId;
    private String transportMode;
    private double distance;
    private double carbonFootprint;
    private String tripDate;
    
    // Constructor
    public Trip() {
    }
    
    // Getters and setters
    public int getId() { 
        return id; 
    }
    
    public void setId(int id) { 
        this.id = id; 
    }
    
    public int getUserId() { 
        return userId; 
    }
    
    public void setUserId(int userId) { 
        this.userId = userId; 
    }
    
    public String getTransportMode() { 
        return transportMode; 
    }
    
    public void setTransportMode(String transportMode) { 
        this.transportMode = transportMode; 
    }
    
    public double getDistance() { 
        return distance; 
    }
    
    public void setDistance(double distance) { 
        this.distance = distance; 
    }
    
    public double getCarbonFootprint() { 
        return carbonFootprint; 
    }
    
    public void setCarbonFootprint(double carbonFootprint) { 
        this.carbonFootprint = carbonFootprint; 
    }
    
    public String getTripDate() { 
        return tripDate; 
    }
    
    public void setTripDate(String tripDate) { 
        this.tripDate = tripDate; 
    }
}
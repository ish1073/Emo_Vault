package com.emovault.model;

import java.sql.Timestamp;

public class Alert {
    private int alertId;
    private int userId;
    private String alertType;
    private String message;
    private boolean isRead;
    private Timestamp createdDate;

    // Constructor
    public Alert() {}

    public Alert(int alertId, int userId, String alertType, String message, boolean isRead, Timestamp createdDate) {
        this.alertId = alertId;
        this.userId = userId;
        this.alertType = alertType;
        this.message = message;
        this.isRead = isRead;
        this.createdDate = createdDate;
    }

    // Getters and Setters
    public int getAlertId() {
        return alertId;
    }

    public void setAlertId(int alertId) {
        this.alertId = alertId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getAlertType() {
        return alertType;
    }

    public void setAlertType(String alertType) {
        this.alertType = alertType;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean read) {
        isRead = read;
    }

    public Timestamp getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }

    @Override
    public String toString() {
        return "Alert{" +
                "alertId=" + alertId +
                ", userId=" + userId +
                ", alertType='" + alertType + '\'' +
                ", message='" + message + '\'' +
                ", isRead=" + isRead +
                ", createdDate=" + createdDate +
                '}';
    }
}

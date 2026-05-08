package com.emovault.model;

import java.time.LocalDateTime;

/**
 * Alert Model - Represents an emotional intelligence alert
 * Covers: Emotional Risk, Behavioral Patterns, Habit Disruption, Time-Sensitive Events, Insights
 */
public class Alert {
    private String alertId;
    private int userId;
    private AlertType alertType;
    private AlertPriority priority;
    private String title;
    private String message;
    private String relatedDataId;
    private String actionUrl;
    private LocalDateTime createdAt;
    private LocalDateTime dismissedAt;
    private boolean isDismissed;
    private LocalDateTime userSeenAt;

    // Constructors
    public Alert() {
    }

    public Alert(String alertId, int userId, AlertType alertType, AlertPriority priority,
                 String title, String message, String actionUrl) {
        this.alertId = alertId;
        this.userId = userId;
        this.alertType = alertType;
        this.priority = priority;
        this.title = title;
        this.message = message;
        this.actionUrl = actionUrl;
        this.createdAt = LocalDateTime.now();
        this.isDismissed = false;
    }

    // Getters and Setters
    public String getAlertId() {
        return alertId;
    }

    public void setAlertId(String alertId) {
        this.alertId = alertId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public AlertType getAlertType() {
        return alertType;
    }

    public void setAlertType(AlertType alertType) {
        this.alertType = alertType;
    }

    public AlertPriority getPriority() {
        return priority;
    }

    public void setPriority(AlertPriority priority) {
        this.priority = priority;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getRelatedDataId() {
        return relatedDataId;
    }

    public void setRelatedDataId(String relatedDataId) {
        this.relatedDataId = relatedDataId;
    }

    public String getActionUrl() {
        return actionUrl;
    }

    public void setActionUrl(String actionUrl) {
        this.actionUrl = actionUrl;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getDismissedAt() {
        return dismissedAt;
    }

    public void setDismissedAt(LocalDateTime dismissedAt) {
        this.dismissedAt = dismissedAt;
    }

    public boolean isDismissed() {
        return isDismissed;
    }

    public void setIsDismissed(boolean dismissed) {
        isDismissed = dismissed;
    }

    public LocalDateTime getUserSeenAt() {
        return userSeenAt;
    }

    public void setUserSeenAt(LocalDateTime userSeenAt) {
        this.userSeenAt = userSeenAt;
    }

    @Override
    public String toString() {
        return "Alert{" +
                "alertId='" + alertId + '\'' +
                ", userId='" + userId + '\'' +
                ", alertType=" + alertType +
                ", priority=" + priority +
                ", title='" + title + '\'' +
                ", createdAt=" + createdAt +
                ", isDismissed=" + isDismissed +
                '}';
    }
}

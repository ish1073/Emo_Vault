package com.emovault.model;

import java.sql.Timestamp;

/**
 * DiaryEntry Model Class
 * Represents a diary entry in the application
 */
public class DiaryEntry {
    private int entryId;
    private int userId;
    private String title;
    private String content;
    private String moodTag;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Constructor
    public DiaryEntry() {
    }
    
    public DiaryEntry(int userId, String title, String content, String moodTag) {
        this.userId = userId;
        this.title = title;
        this.content = content;
        this.moodTag = moodTag;
    }
    
    // Getters and Setters
    public int getEntryId() {
        return entryId;
    }
    
    public void setEntryId(int entryId) {
        this.entryId = entryId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getContent() {
        return content;
    }
    
    public void setContent(String content) {
        this.content = content;
    }
    
    public String getMoodTag() {
        return moodTag;
    }
    
    public void setMoodTag(String moodTag) {
        this.moodTag = moodTag;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    @Override
    public String toString() {
        return "DiaryEntry{" +
                "entryId=" + entryId +
                ", userId=" + userId +
                ", title='" + title + '\'' +
                ", moodTag='" + moodTag + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}

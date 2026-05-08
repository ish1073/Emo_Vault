package com.emovault.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Decision implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int decisionId;
    private int userId;
    private String situation;
    private String optionA;
    private String optionB;
    private String chosenOption; // "A" or "B" or null if undecided
    private String outcome; // User's outcome feedback after choosing
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Analysis results (transient, not stored)
    private String recommendedOption;
    private String recommendation;
    private String riskLevelA;
    private String riskLevelB;
    private String emotionalOutcomeA;
    private String emotionalOutcomeB;
    private String reasoning;
    
    // Constructors
    public Decision() {}
    
    public Decision(int userId, String situation, String optionA, String optionB) {
        this.userId = userId;
        this.situation = situation;
        this.optionA = optionA;
        this.optionB = optionB;
    }
    
    // Getters and Setters
    public int getDecisionId() {
        return decisionId;
    }
    
    public void setDecisionId(int decisionId) {
        this.decisionId = decisionId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getSituation() {
        return situation;
    }
    
    public void setSituation(String situation) {
        this.situation = situation;
    }
    
    public String getOptionA() {
        return optionA;
    }
    
    public void setOptionA(String optionA) {
        this.optionA = optionA;
    }
    
    public String getOptionB() {
        return optionB;
    }
    
    public void setOptionB(String optionB) {
        this.optionB = optionB;
    }
    
    public String getChosenOption() {
        return chosenOption;
    }
    
    public void setChosenOption(String chosenOption) {
        this.chosenOption = chosenOption;
    }
    
    public String getOutcome() {
        return outcome;
    }
    
    public void setOutcome(String outcome) {
        this.outcome = outcome;
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
    
    public String getRecommendedOption() {
        return recommendedOption;
    }
    
    public void setRecommendedOption(String recommendedOption) {
        this.recommendedOption = recommendedOption;
    }
    
    public String getRecommendation() {
        return recommendation;
    }
    
    public void setRecommendation(String recommendation) {
        this.recommendation = recommendation;
    }
    
    public String getRiskLevelA() {
        return riskLevelA;
    }
    
    public void setRiskLevelA(String riskLevelA) {
        this.riskLevelA = riskLevelA;
    }
    
    public String getRiskLevelB() {
        return riskLevelB;
    }
    
    public void setRiskLevelB(String riskLevelB) {
        this.riskLevelB = riskLevelB;
    }
    
    public String getEmotionalOutcomeA() {
        return emotionalOutcomeA;
    }
    
    public void setEmotionalOutcomeA(String emotionalOutcomeA) {
        this.emotionalOutcomeA = emotionalOutcomeA;
    }
    
    public String getEmotionalOutcomeB() {
        return emotionalOutcomeB;
    }
    
    public void setEmotionalOutcomeB(String emotionalOutcomeB) {
        this.emotionalOutcomeB = emotionalOutcomeB;
    }
    
    public String getReasoning() {
        return reasoning;
    }
    
    public void setReasoning(String reasoning) {
        this.reasoning = reasoning;
    }
}

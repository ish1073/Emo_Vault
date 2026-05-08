package com.emovault.model;

public enum AlertType {
    EMOTIONAL_RISK("Emotional Risk"),
    BEHAVIORAL_PATTERN("Behavioral Pattern"),
    HABIT_DISRUPTION("Habit Disruption"),
    TIME_SENSITIVE("Time Sensitive"),
    INSIGHT("Insight");

    private final String displayName;

    AlertType(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}

package com.emovault.model;

public enum AlertPriority {
    CRITICAL(4, "FF4444"),
    HIGH(3, "FFA500"),
    MEDIUM(2, "FFFF00"),
    LOW(1, "4499FF");

    private final int level;
    private final String color;

    AlertPriority(int level, String color) {
        this.level = level;
        this.color = color;
    }

    public int getLevel() {
        return level;
    }

    public String getColor() {
        return color;
    }
}

package com.emovault.dao;

import com.emovault.model.Habit;
import java.sql.*;
import java.util.*;
import java.time.LocalDate;

public class HabitDAO {
    private Connection connection;

    public HabitDAO(Connection connection) {
        this.connection = connection;
    }

    // Create a new habit
    public boolean addHabit(Habit habit) {
        String query = "INSERT INTO habits (user_id, name, description, suggested_by_tag, is_active) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, habit.getUserId());
            stmt.setString(2, habit.getName());
            stmt.setString(3, habit.getDescription());
            stmt.setString(4, habit.getSuggestedByTag());
            stmt.setBoolean(5, habit.isActive());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get all habits for a user
    public List<Habit> getAllHabitsByUserId(int userId) {
        List<Habit> habits = new ArrayList<>();
        String query = "SELECT * FROM habits WHERE user_id = ? ORDER BY created_date DESC";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Habit habit = new Habit(
                    rs.getInt("habit_id"),
                    rs.getInt("user_id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getString("suggested_by_tag"),
                    rs.getBoolean("is_active"),
                    rs.getTimestamp("created_date")
                );
                habit.setCurrentStreak(calculateStreak(rs.getInt("habit_id")));
                habit.setConsistencyScore(calculateConsistencyScore(rs.getInt("habit_id")));
                habits.add(habit);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return habits;
    }

    // Get a habit by ID
    public Habit getHabitById(int habitId) {
        String query = "SELECT * FROM habits WHERE habit_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, habitId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Habit habit = new Habit(
                    rs.getInt("habit_id"),
                    rs.getInt("user_id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getString("suggested_by_tag"),
                    rs.getBoolean("is_active"),
                    rs.getTimestamp("created_date")
                );
                habit.setCurrentStreak(calculateStreak(habitId));
                habit.setConsistencyScore(calculateConsistencyScore(habitId));
                return habit;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Mark habit as completed today
    public boolean completeHabitToday(int habitId) {
        String query = "INSERT INTO habit_logs (habit_id, completed_date, is_completed) VALUES (?, ?, TRUE) ON DUPLICATE KEY UPDATE is_completed = TRUE";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, habitId);
            stmt.setDate(2, Date.valueOf(LocalDate.now()));

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Check if habit was completed today
    public boolean isCompletedToday(int habitId) {
        String query = "SELECT * FROM habit_logs WHERE habit_id = ? AND completed_date = ? AND is_completed = TRUE";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, habitId);
            stmt.setDate(2, Date.valueOf(LocalDate.now()));
            ResultSet rs = stmt.executeQuery();

            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Calculate current streak
    private int calculateStreak(int habitId) {
        String query = "SELECT COUNT(*) as streak FROM habit_logs WHERE habit_id = ? AND is_completed = TRUE ORDER BY completed_date DESC";
        int streak = 0;
        LocalDate today = LocalDate.now();

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, habitId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                // Get consecutive completed days going backwards from today
                String streakQuery = "SELECT completed_date FROM habit_logs WHERE habit_id = ? AND is_completed = TRUE ORDER BY completed_date DESC";
                try (PreparedStatement streakStmt = connection.prepareStatement(streakQuery)) {
                    streakStmt.setInt(1, habitId);
                    ResultSet streakRs = streakStmt.executeQuery();

                    LocalDate expectedDate = today;
                    while (streakRs.next()) {
                        LocalDate completedDate = streakRs.getDate("completed_date").toLocalDate();
                        if (completedDate.equals(expectedDate)) {
                            streak++;
                            expectedDate = expectedDate.minusDays(1);
                        } else {
                            break;
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return streak;
    }

    // Calculate consistency score (percentage of days completed in last 30 days)
    private double calculateConsistencyScore(int habitId) {
        String query = "SELECT COUNT(*) as count FROM habit_logs WHERE habit_id = ? AND is_completed = TRUE AND completed_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, habitId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                int completedDays = rs.getInt("count");
                return (completedDays / 30.0) * 100;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    // Update habit
    public boolean updateHabit(Habit habit) {
        String query = "UPDATE habits SET name = ?, description = ?, is_active = ? WHERE habit_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, habit.getName());
            stmt.setString(2, habit.getDescription());
            stmt.setBoolean(3, habit.isActive());
            stmt.setInt(4, habit.getHabitId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete habit
    public boolean deleteHabit(int habitId) {
        String query = "DELETE FROM habits WHERE habit_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, habitId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}

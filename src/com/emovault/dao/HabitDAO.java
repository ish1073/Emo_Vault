package com.emovault.dao;

import com.emovault.model.Habit;
import java.sql.*;
import java.util.*;

/**
 * HabitDAO - Data Access Object for Habit operations
 */
public class HabitDAO {
    private Connection connection;

    public HabitDAO(Connection connection) {
        this.connection = connection;
    }

    // Add a new habit
    public boolean addHabit(Habit habit) {
        String query = "INSERT INTO habits (user_id, name, description, is_active, created_date) VALUES (?, ?, ?, ?, NOW())";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, habit.getUserId());
            stmt.setString(2, habit.getName());
            stmt.setString(3, habit.getDescription());
            stmt.setBoolean(4, habit.isActive());
            
            int rowsAffected = stmt.executeUpdate();
            System.out.println("[HabitDAO] Insert query executed - Rows affected: " + rowsAffected);
            System.out.println("[HabitDAO] Habit details - Name: " + habit.getName() + ", UserId: " + habit.getUserId() + ", Active: " + habit.isActive());
            
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("[HabitDAO] ✗ Error adding habit: " + e.getMessage());
            System.err.println("[HabitDAO] SQL State: " + e.getSQLState());
            System.err.println("[HabitDAO] Error Code: " + e.getErrorCode());
            e.printStackTrace();
            return false;
        }
    }

    // Get all habits for user
    public List<Habit> getAllHabitsByUserId(int userId) {
        List<Habit> habits = new ArrayList<>();
        String query = "SELECT * FROM habits WHERE user_id = ? ORDER BY created_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            System.out.println("[HabitDAO] Fetching habits for user: " + userId);
            
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Habit habit = new Habit(
                    rs.getInt("habit_id"),
                    rs.getInt("user_id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getBoolean("is_active"),
                    rs.getTimestamp("created_date")
                );
                habits.add(habit);
            }
            System.out.println("[HabitDAO] ✓ Retrieved " + habits.size() + " habits for user " + userId);
        } catch (SQLException e) {
            System.err.println("[HabitDAO] ✗ Error getting habits: " + e.getMessage());
            System.err.println("[HabitDAO] SQL State: " + e.getSQLState());
            e.printStackTrace();
        }
        return habits;
    }

    // Get habit by ID
    public Habit getHabitById(int habitId) {
        String query = "SELECT * FROM habits WHERE habit_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, habitId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new Habit(
                    rs.getInt("habit_id"),
                    rs.getInt("user_id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getBoolean("is_active"),
                    rs.getTimestamp("created_date")
                );
            }
        } catch (SQLException e) {
            System.err.println("[HabitDAO] Error getting habit by ID: " + e.getMessage());
        }
        return null;
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
            System.err.println("[HabitDAO] Error updating habit: " + e.getMessage());
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
            System.err.println("[HabitDAO] Error deleting habit: " + e.getMessage());
            return false;
        }
    }

    // Mark habit as completed today
    public boolean completeHabitToday(int habitId) {
        String query = "INSERT INTO habit_logs (habit_id, completed_date, is_completed) VALUES (?, CURDATE(), 1) ON DUPLICATE KEY UPDATE is_completed = 1";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, habitId);
            System.out.println("[HabitDAO] Marking habit " + habitId + " complete for today");
            int result = stmt.executeUpdate();
            System.out.println("[HabitDAO] Insert/Update result: " + result + " rows affected");
            return result > 0;
        } catch (SQLException e) {
            System.err.println("[HabitDAO] Error completing habit: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Get completed habits for specific date
    public int getHabitsCompletedOnDate(int userId, java.sql.Date date) {
        String query = "SELECT COUNT(*) as count FROM habit_logs hl " +
                      "JOIN habits h ON hl.habit_id = h.habit_id " +
                      "WHERE h.user_id = ? AND hl.completed_date = ? AND hl.is_completed = 1";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            stmt.setDate(2, date);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
            System.err.println("[HabitDAO] Error getting habits completed: " + e.getMessage());
        }
        return 0;
    }

    // Calculate current streak for a habit
    public int calculateCurrentStreak(int habitId) {
        String query = "SELECT COUNT(*) as streak FROM (" +
            "SELECT @row_num := IF(@prev_date = DATE_SUB(completed_date, INTERVAL 1 DAY), @row_num, @row_num + 1) as grp, " +
            "@prev_date := completed_date as completed_date " +
            "FROM habit_logs " +
            "WHERE habit_id = ? AND is_completed = 1 " +
            "ORDER BY completed_date DESC" +
            ") tmp " +
            "WHERE grp = (SELECT @row_num FROM (SELECT @row_num := 0) init LIMIT 1)";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, habitId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int streak = rs.getInt("streak");
                System.out.println("[HabitDAO] Current streak for habit " + habitId + ": " + streak);
                return streak;
            }
        } catch (SQLException e) {
            System.err.println("[HabitDAO] Error calculating streak: " + e.getMessage());
        }
        return 0;
    }

    // Simpler streak calculation - get all completions and count consecutive days
    public int getCurrentStreakSimple(int habitId) {
        String query = "SELECT completed_date FROM habit_logs " +
                      "WHERE habit_id = ? AND is_completed = 1 " +
                      "ORDER BY completed_date DESC " +
                      "LIMIT 100";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, habitId);
            ResultSet rs = stmt.executeQuery();
            
            java.time.LocalDate today = java.time.LocalDate.now();
            int streak = 0;
            java.time.LocalDate expectedDate = today;
            
            while (rs.next()) {
                java.time.LocalDate completedDate = rs.getDate("completed_date").toLocalDate();
                
                // Check if this date matches our expected consecutive date
                if (completedDate.equals(expectedDate)) {
                    streak++;
                    expectedDate = expectedDate.minusDays(1);
                } else if (completedDate.isBefore(expectedDate)) {
                    // Gap found, break the streak
                    break;
                }
            }
            
            System.out.println("[HabitDAO] Calculated streak for habit " + habitId + ": " + streak + " days");
            return streak;
        } catch (SQLException e) {
            System.err.println("[HabitDAO] Error calculating simple streak: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    // Check if habit was completed today
    public boolean isCompletedToday(int habitId) {
        String query = "SELECT 1 FROM habit_logs WHERE habit_id = ? AND completed_date = CURDATE() AND is_completed = 1";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, habitId);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            System.err.println("[HabitDAO] Error checking today's completion: " + e.getMessage());
        }
        return false;
    }

    // Get total completions for a habit
    public int getTotalCompletions(int habitId) {
        String query = "SELECT COUNT(*) as total FROM habit_logs WHERE habit_id = ? AND is_completed = 1";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, habitId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.err.println("[HabitDAO] Error getting total completions: " + e.getMessage());
        }
        return 0;
    }
}


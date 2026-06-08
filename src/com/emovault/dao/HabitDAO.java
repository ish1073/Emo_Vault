package com.emovault.dao;

import com.emovault.model.Habit;
import java.sql.*;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.*;

/**
 * HabitDAO - Data Access Object for Habit operations
 * Handles all habit-related database operations including streak tracking
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

    /**
     * Calculate the current streak for a habit using a reliable Java-based approach.
     * This method fetches all completion dates and counts consecutive days ending today or yesterday.
     * @param habitId The habit ID
     * @return The current streak in days
     */
    public int calculateStreak(int habitId) {
        String query = "SELECT completed_date FROM habit_logs " +
                      "WHERE habit_id = ? AND is_completed = 1 " +
                      "ORDER BY completed_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, habitId);
            ResultSet rs = stmt.executeQuery();
            
            LocalDate today = LocalDate.now();
            int streak = 0;
            LocalDate expectedDate = today;
            boolean foundToday = false;
            
            while (rs.next()) {
                LocalDate completedDate = rs.getDate("completed_date").toLocalDate();
                
                // Check if today is completed
                if (completedDate.equals(today)) {
                    foundToday = true;
                    streak++;
                    expectedDate = today.minusDays(1);
                    continue;
                }
                
                // If we haven't found today, check if yesterday is completed (streak can start from yesterday)
                if (!foundToday && completedDate.equals(today.minusDays(1))) {
                    // Streak starts from yesterday
                    streak++;
                    expectedDate = today.minusDays(2);
                    foundToday = true; // Mark as found since we're counting
                    continue;
                }
                
                // Check if this date matches our expected consecutive date
                if (completedDate.equals(expectedDate)) {
                    streak++;
                    expectedDate = expectedDate.minusDays(1);
                } else if (completedDate.isBefore(expectedDate)) {
                    // Gap found, break the streak
                    break;
                }
                // If date is in the future (shouldn't happen), skip
            }
            
            System.out.println("[HabitDAO] Calculated streak for habit " + habitId + ": " + streak + " days");
            return streak;
        } catch (SQLException e) {
            System.err.println("[HabitDAO] Error calculating streak: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Calculate the longest streak for a habit.
     * @param habitId The habit ID
     * @return The longest streak in days
     */
    public int calculateLongestStreak(int habitId) {
        String query = "SELECT completed_date FROM habit_logs " +
                      "WHERE habit_id = ? AND is_completed = 1 " +
                      "ORDER BY completed_date ASC";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, habitId);
            ResultSet rs = stmt.executeQuery();
            
            int maxStreak = 0;
            int currentStreak = 0;
            LocalDate prevDate = null;
            
            while (rs.next()) {
                LocalDate completedDate = rs.getDate("completed_date").toLocalDate();
                
                if (prevDate == null) {
                    currentStreak = 1;
                } else if (ChronoUnit.DAYS.between(prevDate, completedDate) == 1) {
                    currentStreak++;
                } else if (ChronoUnit.DAYS.between(prevDate, completedDate) == 0) {
                    // Same day, don't increment
                } else {
                    // Gap found, reset streak
                    if (currentStreak > maxStreak) {
                        maxStreak = currentStreak;
                    }
                    currentStreak = 1;
                }
                prevDate = completedDate;
            }
            
            // Check final streak
            if (currentStreak > maxStreak) {
                maxStreak = currentStreak;
            }
            
            System.out.println("[HabitDAO] Longest streak for habit " + habitId + ": " + maxStreak + " days");
            return maxStreak;
        } catch (SQLException e) {
            System.err.println("[HabitDAO] Error calculating longest streak: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Calculate consistency percentage for a habit.
     * Consistency = (total completions / days since creation) * 100
     * @param habitId The habit ID
     * @param createdDate The date the habit was created
     * @return Consistency percentage (0-100)
     */
    public double calculateConsistency(int habitId, Timestamp createdDate) {
        if (createdDate == null) {
            return 0.0;
        }
        
        LocalDate creationDate = createdDate.toLocalDateTime().toLocalDate();
        LocalDate today = LocalDate.now();
        long daysSinceCreation = ChronoUnit.DAYS.between(creationDate, today);
        
        // If habit was created today, return 0 or 100 based on completion
        if (daysSinceCreation == 0) {
            return isCompletedToday(habitId) ? 100.0 : 0.0;
        }
        
        int totalCompletions = getTotalCompletions(habitId);
        double consistency = (double) totalCompletions / daysSinceCreation * 100.0;
        
        // Cap at 100%
        if (consistency > 100.0) {
            consistency = 100.0;
        }
        
        System.out.println("[HabitDAO] Consistency for habit " + habitId + ": " + String.format("%.1f", consistency) + "%");
        return consistency;
    }

    /**
     * Calculate consistency percentage for a habit over the last N days.
     * @param habitId The habit ID
     * @param days Number of days to look back
     * @return Consistency percentage (0-100)
     */
    public double calculateConsistencyLastNDays(int habitId, int days) {
        String query = "SELECT COUNT(*) as count FROM habit_logs " +
                      "WHERE habit_id = ? AND is_completed = 1 " +
                      "AND completed_date >= DATE_SUB(CURDATE(), INTERVAL ? DAY)";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, habitId);
            stmt.setInt(2, days);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                int completions = rs.getInt("count");
                double consistency = (double) completions / days * 100.0;
                
                // Cap at 100%
                if (consistency > 100.0) {
                    consistency = 100.0;
                }
                
                System.out.println("[HabitDAO] Consistency (last " + days + " days) for habit " + habitId + ": " + String.format("%.1f", consistency) + "%");
                return consistency;
            }
        } catch (SQLException e) {
            System.err.println("[HabitDAO] Error calculating consistency: " + e.getMessage());
            e.printStackTrace();
        }
        return 0.0;
    }

    /**
     * Get all habits with their current streaks and consistency for a user.
     * This method populates the Habit objects with calculated values.
     * @param userId The user ID
     * @return List of habits with streak and consistency data
     */
    public List<Habit> getHabitsWithStats(int userId) {
        List<Habit> habits = getAllHabitsByUserId(userId);
        
        for (Habit habit : habits) {
            // Calculate and set streak
            int streak = calculateStreak(habit.getHabitId());
            habit.setCurrentStreak(streak);
            
            // Calculate and set consistency
            double consistency = calculateConsistency(habit.getHabitId(), habit.getCreatedDate());
            habit.setConsistencyScore((int) Math.round(consistency));
        }
        
        return habits;
    }

    /**
     * Check if a habit was completed on a specific date.
     * @param habitId The habit ID
     * @param date The date to check
     * @return true if completed on that date
     */
    public boolean isCompletedOnDate(int habitId, LocalDate date) {
        String query = "SELECT 1 FROM habit_logs WHERE habit_id = ? AND completed_date = ? AND is_completed = 1";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, habitId);
            stmt.setDate(2, java.sql.Date.valueOf(date));
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            System.err.println("[HabitDAO] Error checking completion on date: " + e.getMessage());
        }
        return false;
    }

    /**
     * Get completion history for a habit.
     * @param habitId The habit ID
     * @return Map of dates to completion status
     */
    public Map<LocalDate, Boolean> getCompletionHistory(int habitId) {
        Map<LocalDate, Boolean> history = new HashMap<>();
        String query = "SELECT completed_date, is_completed FROM habit_logs WHERE habit_id = ? ORDER BY completed_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, habitId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                LocalDate date = rs.getDate("completed_date").toLocalDate();
                boolean completed = rs.getBoolean("is_completed");
                history.put(date, completed);
            }
        } catch (SQLException e) {
            System.err.println("[HabitDAO] Error getting completion history: " + e.getMessage());
            e.printStackTrace();
        }
        
        return history;
    }

    /**
     * Get habits completed count for a user on a specific date.
     * @param userId The user ID
     * @param date The date to check
     * @return Number of habits completed
     */
    public int getHabitsCompletedCount(int userId, LocalDate date) {
        String query = "SELECT COUNT(*) as count FROM habit_logs hl " +
                      "JOIN habits h ON hl.habit_id = h.habit_id " +
                      "WHERE h.user_id = ? AND hl.completed_date = ? AND hl.is_completed = 1";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            stmt.setDate(2, java.sql.Date.valueOf(date));
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
            System.err.println("[HabitDAO] Error getting habits completed count: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Get total habits count for a user.
     * @param userId The user ID
     * @return Total number of active habits
     */
    public int getTotalHabitsCount(int userId) {
        String query = "SELECT COUNT(*) as count FROM habits WHERE user_id = ? AND is_active = 1";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
            System.err.println("[HabitDAO] Error getting total habits count: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Get average streak across all habits for a user.
     * @param userId The user ID
     * @return Average streak in days
     */
    public double getAverageStreak(int userId) {
        List<Habit> habits = getAllHabitsByUserId(userId);
        if (habits.isEmpty()) {
            return 0.0;
        }
        
        int totalStreak = 0;
        for (Habit habit : habits) {
            totalStreak += calculateStreak(habit.getHabitId());
        }
        
        return (double) totalStreak / habits.size();
    }

    /**
     * Get average consistency across all habits for a user.
     * @param userId The user ID
     * @return Average consistency percentage
     */
    public double getAverageConsistency(int userId) {
        List<Habit> habits = getAllHabitsByUserId(userId);
        if (habits.isEmpty()) {
            return 0.0;
        }
        
        double totalConsistency = 0.0;
        for (Habit habit : habits) {
            totalConsistency += calculateConsistency(habit.getHabitId(), habit.getCreatedDate());
        }
        
        return totalConsistency / habits.size();
    }

    /**
     * Get weekly completion data for the last N weeks.
     * @param userId The user ID
     * @param weeks Number of weeks to look back
     * @return List of maps with week number and completion count
     */
    public List<Map<String, Object>> getWeeklyCompletionTrend(int userId, int weeks) {
        List<Map<String, Object>> trend = new ArrayList<>();
        String query = "SELECT YEARWEEK(hl.completed_date) as year_week, " +
                      "COUNT(*) as completion_count " +
                      "FROM habit_logs hl " +
                      "JOIN habits h ON hl.habit_id = h.habit_id " +
                      "WHERE h.user_id = ? AND hl.is_completed = 1 " +
                      "AND hl.completed_date >= DATE_SUB(CURDATE(), INTERVAL ? WEEK) " +
                      "GROUP BY YEARWEEK(hl.completed_date) " +
                      "ORDER BY year_week ASC";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, weeks);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> entry = new HashMap<>();
                entry.put("yearWeek", rs.getInt("year_week"));
                entry.put("completionCount", rs.getInt("completion_count"));
                trend.add(entry);
            }
        } catch (SQLException e) {
            System.err.println("[HabitDAO] Error getting weekly trend: " + e.getMessage());
            e.printStackTrace();
        }
        
        return trend;
    }

    /**
     * Get monthly consistency data for the last N months.
     * @param userId The user ID
     * @param months Number of months to look back
     * @return List of maps with month and consistency percentage
     */
    public List<Map<String, Object>> getMonthlyConsistencyTrend(int userId, int months) {
        List<Map<String, Object>> trend = new ArrayList<>();
        String query = "SELECT DATE_FORMAT(hl.completed_date, '%Y-%m') as month_year, " +
                      "COUNT(DISTINCT hl.completed_date) as days_completed, " +
                      "COUNT(DISTINCT h.habit_id) as active_habits " +
                      "FROM habit_logs hl " +
                      "JOIN habits h ON hl.habit_id = h.habit_id " +
                      "WHERE h.user_id = ? AND hl.is_completed = 1 " +
                      "AND hl.completed_date >= DATE_SUB(CURDATE(), INTERVAL ? MONTH) " +
                      "GROUP BY DATE_FORMAT(hl.completed_date, '%Y-%m') " +
                      "ORDER BY month_year ASC";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, months);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> entry = new HashMap<>();
                entry.put("monthYear", rs.getString("month_year"));
                int daysCompleted = rs.getInt("days_completed");
                int activeHabits = rs.getInt("active_habits");
                // Calculate consistency as percentage of days completed vs total days in month
                entry.put("daysCompleted", daysCompleted);
                entry.put("activeHabits", activeHabits);
                trend.add(entry);
            }
        } catch (SQLException e) {
            System.err.println("[HabitDAO] Error getting monthly trend: " + e.getMessage());
            e.printStackTrace();
        }
        
        return trend;
    }

    /**
     * Get completion heatmap data for the current month.
     * @param userId The user ID
     * @return Map of dates to completion count
     */
    public Map<String, Integer> getCompletionHeatmap(int userId) {
        Map<String, Integer> heatmap = new HashMap<>();
        String query = "SELECT hl.completed_date, COUNT(*) as completion_count " +
                      "FROM habit_logs hl " +
                      "JOIN habits h ON hl.habit_id = h.habit_id " +
                      "WHERE h.user_id = ? AND hl.is_completed = 1 " +
                      "AND YEAR(hl.completed_date) = YEAR(CURDATE()) " +
                      "AND MONTH(hl.completed_date) = MONTH(CURDATE()) " +
                      "GROUP BY hl.completed_date " +
                      "ORDER BY hl.completed_date ASC";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                LocalDate date = rs.getDate("completed_date").toLocalDate();
                heatmap.put(date.toString(), rs.getInt("completion_count"));
            }
        } catch (SQLException e) {
            System.err.println("[HabitDAO] Error getting heatmap: " + e.getMessage());
            e.printStackTrace();
        }
        
        return heatmap;
    }

    /**
     * Get best performing habits (highest streaks) for a user.
     * @param userId The user ID
     * @param limit Maximum number of habits to return
     * @return List of maps with habit name and streak
     */
    public List<Map<String, Object>> getBestPerformingHabits(int userId, int limit) {
        List<Map<String, Object>> bestHabits = new ArrayList<>();
        List<Habit> habits = getAllHabitsByUserId(userId);
        
        // Calculate streaks and sort
        List<Map<String, Object>> habitsWithStreaks = new ArrayList<>();
        for (Habit habit : habits) {
            int streak = calculateStreak(habit.getHabitId());
            if (streak > 0) {
                Map<String, Object> entry = new HashMap<>();
                entry.put("name", habit.getName());
                entry.put("streak", streak);
                entry.put("consistency", calculateConsistency(habit.getHabitId(), habit.getCreatedDate()));
                habitsWithStreaks.add(entry);
            }
        }
        
        // Sort by streak descending
        habitsWithStreaks.sort((a, b) -> (int) b.get("streak") - (int) a.get("streak"));
        
        // Limit results
        int resultLimit = Math.min(limit, habitsWithStreaks.size());
        bestHabits.addAll(habitsWithStreaks.subList(0, resultLimit));
        
        return bestHabits;
    }

    /**
     * Get missed days count for the current month.
     * @param userId The user ID
     * @return Number of days with no habit completions
     */
    public int getMissedDaysCount(int userId) {
        String query = "SELECT COUNT(*) as missed_days FROM ( " +
                      "SELECT DISTINCT DATE_SUB(CURDATE(), INTERVAL n DAY) as check_date " +
                      "FROM ( " +
                      "  SELECT a.N + b.N * 10 + 1 as n " +
                      "  FROM (SELECT 0 as N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 " +
                      "        UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a, " +
                      "       (SELECT 0 as N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 " +
                      "        UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b " +
                      ") nums " +
                      "WHERE DATE_SUB(CURDATE(), INTERVAL n DAY) >= DATE_FORMAT(CURDATE(), '%Y-%m-01') " +
                      ") all_dates " +
                      "LEFT JOIN habit_logs hl ON DATE(hl.completed_date) = all_dates.check_date " +
                      "AND hl.is_completed = 1 " +
                      "LEFT JOIN habits h ON hl.habit_id = h.habit_id AND h.user_id = ? " +
                      "WHERE hl.log_id IS NULL";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("missed_days");
            }
        } catch (SQLException e) {
            System.err.println("[HabitDAO] Error getting missed days: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }

    /**
     * Get streak growth data over time.
     * @param userId The user ID
     * @return List of maps with date and best streak on that date
     */
    public List<Map<String, Object>> getStreakGrowthOverTime(int userId, int months) {
        List<Map<String, Object>> growthData = new ArrayList<>();
        String query = "SELECT DATE_FORMAT(hl.completed_date, '%Y-%m-%d') as date, " +
                      "COUNT(*) as daily_completions " +
                      "FROM habit_logs hl " +
                      "JOIN habits h ON hl.habit_id = h.habit_id " +
                      "WHERE h.user_id = ? AND hl.is_completed = 1 " +
                      "AND hl.completed_date >= DATE_SUB(CURDATE(), INTERVAL ? MONTH) " +
                      "GROUP BY DATE_FORMAT(hl.completed_date, '%Y-%m-%d') " +
                      "ORDER BY hl.completed_date ASC";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, months);
            ResultSet rs = stmt.executeQuery();
            
            int runningStreak = 0;
            LocalDate lastDate = null;
            
            while (rs.next()) {
                LocalDate currentDate = rs.getDate("date").toLocalDate();
                int completions = rs.getInt("daily_completions");
                
                // Calculate if streak continued
                if (lastDate != null && ChronoUnit.DAYS.between(lastDate, currentDate) <= 1) {
                    runningStreak += completions;
                } else {
                    runningStreak = completions;
                }
                
                Map<String, Object> entry = new HashMap<>();
                entry.put("date", rs.getString("date"));
                entry.put("streak", runningStreak);
                entry.put("completions", completions);
                growthData.add(entry);
                
                lastDate = currentDate;
            }
        } catch (SQLException e) {
            System.err.println("[HabitDAO] Error getting streak growth: " + e.getMessage());
            e.printStackTrace();
        }
        
        return growthData;
    }

    /**
     * Get today's completion summary for real-time updates.
     * @param userId The user ID
     * @return Map with today's stats
     */
    public Map<String, Object> getTodaySummary(int userId) {
        Map<String, Object> summary = new HashMap<>();
        
        // Get total active habits
        summary.put("totalHabits", getTotalHabitsCount(userId));
        
        // Get completed habits today
        summary.put("completedToday", getHabitsCompletedCount(userId, LocalDate.now()));
        
        // Get best streak
        List<Habit> habits = getAllHabitsByUserId(userId);
        int bestStreak = 0;
        double totalConsistency = 0.0;
        
        for (Habit habit : habits) {
            int streak = calculateStreak(habit.getHabitId());
            if (streak > bestStreak) {
                bestStreak = streak;
            }
            totalConsistency += calculateConsistency(habit.getHabitId(), habit.getCreatedDate());
        }
        
        summary.put("bestStreak", bestStreak);
        summary.put("avgConsistency", habits.isEmpty() ? 0.0 : totalConsistency / habits.size());
        
        return summary;
    }
}


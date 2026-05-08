package com.emovault;

import com.emovault.dao.RegretDAO;
import com.emovault.model.Regret;
import com.emovault.util.DBConnection;
import java.sql.Connection;
import java.util.List;

public class TestRegretEntries {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection()) {
            RegretDAO regretDAO = new RegretDAO(conn);
            
            int userId = 1;
            
            System.out.println("[TestRegretEntries] Testing regret operations...");
            System.out.println("[TestRegretEntries] User ID: " + userId);
            
            // Get all regrets
            System.out.println("\n[TestRegretEntries] Retrieving all regrets...");
            List<Regret> regrets = regretDAO.getAllRegretsByUserId(userId);
            System.out.println("[TestRegretEntries] Total regrets found: " + regrets.size());
            
            if (regrets.size() > 0) {
                System.out.println("[TestRegretEntries] Regrets:");
                for (Regret regret : regrets) {
                    System.out.println("  - ID: " + regret.getRegretId() + 
                                     ", Description: " + regret.getDescription() + 
                                     ", Tag: " + regret.getTag());
                }
            } else {
                System.out.println("[TestRegretEntries] No regrets found for user " + userId);
            }
            
            // Save a test regret
            System.out.println("\n[TestRegretEntries] Saving test regret...");
            Regret newRegret = new Regret();
            newRegret.setUserId(userId);
            newRegret.setDescription("Test regret description");
            newRegret.setLessonLearned("This is a test lesson learned");
            newRegret.setTag("learning");
            
            boolean saved = regretDAO.addRegret(newRegret);
            System.out.println("[TestRegretEntries] Save result: " + saved);
            
            // Get regrets again
            System.out.println("\n[TestRegretEntries] Retrieving regrets again...");
            regrets = regretDAO.getAllRegretsByUserId(userId);
            System.out.println("[TestRegretEntries] Total regrets after save: " + regrets.size());
            
            if (regrets.size() > 0) {
                System.out.println("[TestRegretEntries] Latest regret:");
                Regret latest = regrets.get(0);
                System.out.println("  - ID: " + latest.getRegretId() + 
                                 ", Description: " + latest.getDescription() + 
                                 ", Lesson: " + latest.getLessonLearned());
            }
            
        } catch (Exception e) {
            System.err.println("[TestRegretEntries] Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}

package com.emovault;

import com.emovault.dao.DiaryDAO;
import com.emovault.model.DiaryEntry;
import java.util.List;

public class TestDiaryEntries {
    public static void main(String[] args) {
        DiaryDAO diaryDAO = new DiaryDAO();
        
        // Test with user ID 1 (assuming user 1 exists)
        int userId = 1;
        
        System.out.println("[TestDiaryEntries] Testing diary operations...");
        System.out.println("[TestDiaryEntries] User ID: " + userId);
        
        // Test: Get all diaries for user
        System.out.println("\n[TestDiaryEntries] Retrieving all diaries...");
        List<DiaryEntry> diaries = diaryDAO.getUserDiaries(userId);
        System.out.println("[TestDiaryEntries] Total entries found: " + diaries.size());
        
        if (diaries.size() > 0) {
            System.out.println("[TestDiaryEntries] Diaries:");
            for (DiaryEntry entry : diaries) {
                System.out.println("  - ID: " + entry.getEntryId() + 
                                 ", Title: " + entry.getTitle() + 
                                 ", Created: " + entry.getCreatedAt());
            }
        } else {
            System.out.println("[TestDiaryEntries] No diaries found for user " + userId);
        }
        
        // Test: Save a test entry
        System.out.println("\n[TestDiaryEntries] Saving test entry...");
        int newEntryId = diaryDAO.saveDiaryEntry(userId, "Test Entry", "This is a test diary entry content.", "happy");
        System.out.println("[TestDiaryEntries] New entry ID: " + newEntryId);
        
        // Test: Get diaries again to see if new entry appears
        System.out.println("\n[TestDiaryEntries] Retrieving diaries again...");
        diaries = diaryDAO.getUserDiaries(userId);
        System.out.println("[TestDiaryEntries] Total entries after save: " + diaries.size());
        
        if (diaries.size() > 0) {
            System.out.println("[TestDiaryEntries] Latest entry:");
            DiaryEntry latest = diaries.get(0);
            System.out.println("  - ID: " + latest.getEntryId() + 
                             ", Title: " + latest.getTitle() + 
                             ", Content: " + latest.getContent());
        }
    }
}

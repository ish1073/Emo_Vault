package com.emovault;

import com.emovault.util.DBConnection;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.Statement;

public class AddTimeCapsuleMoodColumns {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection()) {
            Statement stmt = conn.createStatement();
            
            // Check if mood column exists
            DatabaseMetaData dbMeta = conn.getMetaData();
            ResultSet columns = dbMeta.getColumns(null, null, "time_capsules", "mood");
            
            if (!columns.next()) {
                System.out.println("[AddTimeCapsuleMoodColumns] Adding mood column...");
                String addMoodSQL = "ALTER TABLE time_capsules ADD COLUMN mood VARCHAR(100) AFTER goal";
                stmt.executeUpdate(addMoodSQL);
                System.out.println("[AddTimeCapsuleMoodColumns] ✓ mood column added");
            } else {
                System.out.println("[AddTimeCapsuleMoodColumns] mood column already exists");
            }
            
            // Check if reflection_mood column exists
            columns = dbMeta.getColumns(null, null, "time_capsules", "reflection_mood");
            
            if (!columns.next()) {
                System.out.println("[AddTimeCapsuleMoodColumns] Adding reflection_mood column...");
                String addReflectionMoodSQL = "ALTER TABLE time_capsules ADD COLUMN reflection_mood VARCHAR(100) AFTER reflection";
                stmt.executeUpdate(addReflectionMoodSQL);
                System.out.println("[AddTimeCapsuleMoodColumns] ✓ reflection_mood column added");
            } else {
                System.out.println("[AddTimeCapsuleMoodColumns] reflection_mood column already exists");
            }
            
            System.out.println("[AddTimeCapsuleMoodColumns] ✓ All mood columns are ready!");
            
        } catch (Exception e) {
            System.err.println("[AddTimeCapsuleMoodColumns] Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}

package com.emovault;

import com.emovault.util.DBConnection;
import java.sql.*;

public class TestTableStructure {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection()) {
            DatabaseMetaData metadata = conn.getMetaData();
            
            System.out.println("[TestTableStructure] Checking diary_entries table...");
            ResultSet columns = metadata.getColumns(null, null, "diary_entries", null);
            
            System.out.println("[TestTableStructure] Columns in diary_entries table:");
            while (columns.next()) {
                String columnName = columns.getString("COLUMN_NAME");
                String dataType = columns.getString("TYPE_NAME");
                int columnSize = columns.getInt("COLUMN_SIZE");
                String isNullable = columns.getString("IS_NULLABLE");
                String remarks = columns.getString("REMARKS");
                
                System.out.println("  - " + columnName + " (" + dataType + 
                                 ", nullable: " + isNullable + ", size: " + columnSize + ")");
            }
            
            // Try to select all records
            System.out.println("\n[TestTableStructure] Attempting SELECT *...");
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM diary_entries LIMIT 1");
            
            if (rs.next()) {
                System.out.println("[TestTableStructure] First record found!");
                ResultSetMetaData rsmd = rs.getMetaData();
                int colCount = rsmd.getColumnCount();
                System.out.println("[TestTableStructure] Number of columns: " + colCount);
                for (int i = 1; i <= colCount; i++) {
                    System.out.println("  - " + rsmd.getColumnName(i) + " (" + rsmd.getColumnTypeName(i) + ")");
                }
            } else {
                System.out.println("[TestTableStructure] No records found");
            }
            
        } catch (SQLException e) {
            System.err.println("[TestTableStructure] Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}

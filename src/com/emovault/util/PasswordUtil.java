package com.emovault.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Password Utility Class
 * Handles password hashing (MD5) - suitable for college projects
 * Note: In production, use BCrypt
 */
public class PasswordUtil {
    
    /**
     * Hash password using MD5
     * @param password plain text password
     * @return hashed password
     */
    public static String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] messageDigest = md.digest(password.getBytes());
            StringBuilder hexString = new StringBuilder();
            for (byte b : messageDigest) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * Verify password against hash
     * @param password plain text password
     * @param hash stored hash
     * @return true if password matches
     */
    public static boolean verifyPassword(String password, String hash) {
        String hashedInput = hashPassword(password);
        return hashedInput != null && hashedInput.equals(hash);
    }
}

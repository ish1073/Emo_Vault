import java.security.MessageDigest;

public class TestMD5 {
    
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
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public static void main(String[] args) {
        String password = "test123";
        String hash = hashPassword(password);
        
        System.out.println("Password: " + password);
        System.out.println("MD5 Hash: " + hash);
        System.out.println("Expected: cc03e747a6afbbcbf8be7668acfebee5");
        System.out.println("Match: " + hash.equals("cc03e747a6afbbcbf8be7668acfebee5"));
    }
}

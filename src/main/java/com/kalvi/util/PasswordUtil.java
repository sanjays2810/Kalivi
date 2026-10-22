package com.kalvi.util;

import org.mindrot.jbcrypt.BCrypt;

/** BCrypt password hashing - passwords are never stored in plain text. */
public final class PasswordUtil {
    private PasswordUtil() {}
    public static String hash(String plain) { return BCrypt.hashpw(plain, BCrypt.gensalt(10)); }
    public static boolean verify(String plain, String hash) {
        try { return plain != null && hash != null && BCrypt.checkpw(plain, hash); }
        catch (IllegalArgumentException e) { return false; }
    }
}

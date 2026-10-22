package com.kalvi.util;

import java.util.regex.Pattern;

/** Server-side input validation (never trust only browser validation). */
public final class ValidationUtil {
    private static final Pattern EMAIL = Pattern.compile("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    private static final Pattern MOBILE = Pattern.compile("^[6-9][0-9]{9}$");
    private ValidationUtil() {}

    public static boolean blank(String s) { return s == null || s.trim().isEmpty(); }
    public static String trim(String s) { return s == null ? "" : s.trim(); }
    public static boolean isEmail(String s) { return s != null && EMAIL.matcher(s).matches(); }
    public static boolean isMobile(String s) { return s != null && MOBILE.matcher(s).matches(); }
    /** At least 8 chars, one letter and one digit. */
    public static boolean strongPassword(String s) {
        return s != null && s.length() >= 8 && s.matches(".*[A-Za-z].*") && s.matches(".*[0-9].*");
    }
    public static int toInt(String s, int fallback) {
        try { return Integer.parseInt(s.trim()); } catch (Exception e) { return fallback; }
    }
    public static double toDouble(String s, double fallback) {
        try { return Double.parseDouble(s.trim()); } catch (Exception e) { return fallback; }
    }
}

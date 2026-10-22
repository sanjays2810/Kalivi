package com.kalvi.util;

import com.kalvi.model.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

/** Convenience accessors for the logged-in user. */
public final class SessionUtil {
    public static final String USER = "user";
    private SessionUtil() {}

    public static User currentUser(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return s == null ? null : (User) s.getAttribute(USER);
    }
    public static boolean isStudent(HttpServletRequest req) {
        User u = currentUser(req);
        return u != null && "STUDENT".equals(u.getRole());
    }
    public static boolean isAdmin(HttpServletRequest req) {
        User u = currentUser(req);
        return u != null && "ADMIN".equals(u.getRole());
    }
    /** Returns the student id or 0 when nobody (or an admin) is logged in. */
    public static int studentId(HttpServletRequest req) { return isStudent(req) ? currentUser(req).getId() : 0; }

    /** Creates a fresh session after login (prevents session fixation) and keeps the chosen language. */
    public static void login(HttpServletRequest req, User user) {
        HttpSession old = req.getSession(false);
        Object lang = old == null ? null : old.getAttribute("lang");
        if (old != null) old.invalidate();
        HttpSession s = req.getSession(true);
        user.setPasswordHash(null);
        s.setAttribute(USER, user);
        if (lang != null) s.setAttribute("lang", lang);
        s.setMaxInactiveInterval(30 * 60);
    }
}

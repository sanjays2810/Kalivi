package com.kalvi.util;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/** One-time messages (shown once after a redirect) and friendly error forwarding. */
public final class Flash {
    private Flash() {}

    public static void success(HttpServletRequest req, String msg) { set(req, "success", msg); }
    public static void error(HttpServletRequest req, String msg) { set(req, "danger", msg); }

    private static void set(HttpServletRequest req, String type, String msg) {
        req.getSession(true).setAttribute("flashType", type);
        req.getSession(true).setAttribute("flashMsg", msg);
    }

    /** Forwards to error.jsp with a user-friendly message (no stack trace). */
    public static void fail(HttpServletRequest req, HttpServletResponse resp, int status, String message)
            throws ServletException, IOException {
        resp.setStatus(status);
        req.setAttribute("errorTitle", status == 404 ? "Not found" : status == 403 ? "Access denied" : "Something went wrong");
        req.setAttribute("errorMessage", message);
        req.getRequestDispatcher("/error.jsp").forward(req, resp);
    }
}

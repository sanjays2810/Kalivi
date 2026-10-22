package com.kalvi.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/** Invalidates the session (student or admin). */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession s = req.getSession(false);
        boolean admin = s != null && s.getAttribute("user") != null && "ADMIN".equals(((com.kalvi.model.User) s.getAttribute("user")).getRole());
        if (s != null) s.invalidate();
        resp.sendRedirect(req.getContextPath() + (admin ? "/admin/login" : "/login") + "?msg=out");
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException { doGet(req, resp); }
}

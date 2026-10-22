package com.kalvi.controller.admin;

import com.kalvi.dao.UserDAO;
import com.kalvi.model.User;
import com.kalvi.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/** Separate admin login (/admin/login). */
@WebServlet("/admin/login")
public class AdminLoginServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (SessionUtil.isAdmin(req)) { resp.sendRedirect(req.getContextPath() + "/admin/dashboard"); return; }
        String msg = req.getParameter("msg");
        if ("expired".equals(msg)) req.setAttribute("info", "Session expired. Please login again.");
        else if ("out".equals(msg)) req.setAttribute("info", "You have been logged out.");
        req.getRequestDispatcher("/WEB-INF/views/admin/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = ValidationUtil.trim(req.getParameter("email"));
        User user = ValidationUtil.isEmail(email) ? userDAO.findByEmail(email) : null;
        if (user == null || !"ADMIN".equals(user.getRole()) || !PasswordUtil.verify(req.getParameter("password"), user.getPasswordHash())) {
            req.setAttribute("error", "Invalid admin email or password.");
            req.getRequestDispatcher("/WEB-INF/views/admin/login.jsp").forward(req, resp);
            return;
        }
        SessionUtil.login(req, user);
        resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
    }
}

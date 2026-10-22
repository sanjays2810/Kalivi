package com.kalvi.controller.admin;

import com.kalvi.dao.UserDAO;
import com.kalvi.model.User;
import com.kalvi.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/** Admin settings: change own password (/admin/settings). */
@WebServlet("/admin/settings")
public class AdminSettingsServlet extends HttpServlet {
    private final UserDAO dao = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/admin/settings.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User admin = dao.findById(SessionUtil.currentUser(req).getId());
        String current = req.getParameter("currentPassword"), np = req.getParameter("newPassword");
        String error = null;
        if (!PasswordUtil.verify(current, admin.getPasswordHash())) error = "Current password is incorrect.";
        else if (!ValidationUtil.strongPassword(np)) error = "New password must be at least 8 characters with a letter and a number.";
        else if (!np.equals(req.getParameter("confirmPassword"))) error = "New passwords do not match.";
        if (error != null) { req.setAttribute("error", error); doGet(req, resp); return; }
        dao.updatePassword(admin.getId(), PasswordUtil.hash(np));
        Flash.success(req, "Password changed successfully.");
        resp.sendRedirect(req.getContextPath() + "/admin/settings");
    }
}

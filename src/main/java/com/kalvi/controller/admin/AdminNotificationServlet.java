package com.kalvi.controller.admin;

import com.kalvi.dao.NotificationDAO;
import com.kalvi.model.Notification;
import com.kalvi.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/** Notification CRUD (/admin/notifications). */
@WebServlet("/admin/notifications")
public class AdminNotificationServlet extends HttpServlet {
    private final NotificationDAO dao = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("new".equals(action)) { req.setAttribute("item", new Notification()); req.setAttribute("formMode", true); }
        else if ("edit".equals(action)) {
            Notification n = dao.findById(ValidationUtil.toInt(req.getParameter("id"), -1));
            if (n == null) { Flash.fail(req, resp, 404, "Notification not found."); return; }
            req.setAttribute("item", n); req.setAttribute("formMode", true);
        } else req.setAttribute("items", dao.latest(100));
        req.getRequestDispatcher("/WEB-INF/views/admin/notifications.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if ("delete".equals(req.getParameter("action"))) {
            dao.delete(ValidationUtil.toInt(req.getParameter("id"), -1));
            Flash.success(req, "Notification deleted.");
            resp.sendRedirect(req.getContextPath() + "/admin/notifications");
            return;
        }
        Notification n = new Notification();
        n.setId(ValidationUtil.toInt(req.getParameter("id"), 0));
        n.setTitle(ValidationUtil.trim(req.getParameter("title")));
        n.setMessage(ValidationUtil.trim(req.getParameter("message")));
        n.setDemo("on".equals(req.getParameter("demo")));
        if (n.getTitle().isEmpty() || n.getMessage().isEmpty()) {
            req.setAttribute("errors", java.util.List.of("Title and message are required."));
            req.setAttribute("item", n); req.setAttribute("formMode", true);
            req.getRequestDispatcher("/WEB-INF/views/admin/notifications.jsp").forward(req, resp);
            return;
        }
        if (n.getId() > 0) { dao.update(n); Flash.success(req, "Notification updated."); } else { dao.create(n); Flash.success(req, "Notification published."); }
        resp.sendRedirect(req.getContextPath() + "/admin/notifications");
    }
}

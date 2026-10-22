package com.kalvi.controller.admin;

import com.kalvi.dao.ResourceDAO;
import com.kalvi.model.Resource;
import com.kalvi.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/** Resource CRUD (/admin/resources). */
@WebServlet("/admin/resources")
public class AdminResourceServlet extends HttpServlet {
    private final ResourceDAO dao = new ResourceDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("new".equals(action)) { req.setAttribute("item", new Resource()); req.setAttribute("formMode", true); }
        else if ("edit".equals(action)) {
            Resource r = dao.findById(ValidationUtil.toInt(req.getParameter("id"), -1));
            if (r == null) { Flash.fail(req, resp, 404, "Resource not found."); return; }
            req.setAttribute("item", r); req.setAttribute("formMode", true);
        } else req.setAttribute("items", dao.findAll(null, null));
        req.getRequestDispatcher("/WEB-INF/views/admin/resources.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if ("delete".equals(req.getParameter("action"))) {
            dao.delete(ValidationUtil.toInt(req.getParameter("id"), -1));
            Flash.success(req, "Resource deleted.");
            resp.sendRedirect(req.getContextPath() + "/admin/resources");
            return;
        }
        Resource r = new Resource();
        r.setId(ValidationUtil.toInt(req.getParameter("id"), 0));
        r.setTitle(ValidationUtil.trim(req.getParameter("title")));
        r.setDescription(ValidationUtil.trim(req.getParameter("description")));
        r.setCategory(ValidationUtil.trim(req.getParameter("category")));
        r.setLink(ValidationUtil.trim(req.getParameter("link")));
        if (r.getTitle().isEmpty() || !Options.RESOURCE_CATEGORIES.contains(r.getCategory()) || !r.getLink().matches("^https?://.+")) {
            req.setAttribute("errors", java.util.List.of("Title, category and a valid link (http:// or https://) are required."));
            req.setAttribute("item", r); req.setAttribute("formMode", true);
            req.getRequestDispatcher("/WEB-INF/views/admin/resources.jsp").forward(req, resp);
            return;
        }
        if (r.getId() > 0) { dao.update(r); Flash.success(req, "Resource updated."); } else { dao.create(r); Flash.success(req, "Resource added."); }
        resp.sendRedirect(req.getContextPath() + "/admin/resources");
    }
}

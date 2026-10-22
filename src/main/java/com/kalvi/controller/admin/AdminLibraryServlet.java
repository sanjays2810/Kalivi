package com.kalvi.controller.admin;

import com.kalvi.dao.LibraryDAO;
import com.kalvi.model.Library;
import com.kalvi.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/** Library CRUD (/admin/libraries). */
@WebServlet("/admin/libraries")
public class AdminLibraryServlet extends HttpServlet {
    private final LibraryDAO dao = new LibraryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("new".equals(action)) { req.setAttribute("item", new Library()); req.setAttribute("formMode", true); }
        else if ("edit".equals(action)) {
            Library l = dao.findById(ValidationUtil.toInt(req.getParameter("id"), -1));
            if (l == null) { Flash.fail(req, resp, 404, "Library not found."); return; }
            req.setAttribute("item", l); req.setAttribute("formMode", true);
        } else req.setAttribute("items", dao.search(null, null));
        req.getRequestDispatcher("/WEB-INF/views/admin/libraries.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if ("delete".equals(req.getParameter("action"))) {
            dao.delete(ValidationUtil.toInt(req.getParameter("id"), -1));
            Flash.success(req, "Library deleted.");
            resp.sendRedirect(req.getContextPath() + "/admin/libraries");
            return;
        }
        Library l = new Library();
        l.setId(ValidationUtil.toInt(req.getParameter("id"), 0));
        l.setName(ValidationUtil.trim(req.getParameter("name")));
        l.setDistrict(ValidationUtil.trim(req.getParameter("district")));
        l.setLocation(ValidationUtil.trim(req.getParameter("location")));
        l.setAddress(ValidationUtil.trim(req.getParameter("address")));
        l.setContact(ValidationUtil.trim(req.getParameter("contact")));
        l.setFacilities(ValidationUtil.trim(req.getParameter("facilities")));
        l.setOpeningHours(ValidationUtil.trim(req.getParameter("openingHours")));
        l.setDemo("on".equals(req.getParameter("demo")));
        if (l.getName().isEmpty() || !Options.DISTRICTS.contains(l.getDistrict()) || l.getAddress().isEmpty()) {
            req.setAttribute("errors", java.util.List.of("Name, district and address are required."));
            req.setAttribute("item", l); req.setAttribute("formMode", true);
            req.getRequestDispatcher("/WEB-INF/views/admin/libraries.jsp").forward(req, resp);
            return;
        }
        if (l.getId() > 0) { dao.update(l); Flash.success(req, "Library updated."); } else { dao.create(l); Flash.success(req, "Library added."); }
        resp.sendRedirect(req.getContextPath() + "/admin/libraries");
    }
}

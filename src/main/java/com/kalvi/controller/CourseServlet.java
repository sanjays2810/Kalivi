package com.kalvi.controller;

import com.kalvi.dao.CourseDAO;
import com.kalvi.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/** Course listing with search, filters and pagination (/courses). */
@WebServlet("/courses")
public class CourseServlet extends HttpServlet {
    private static final int PAGE_SIZE = 9;
    private final CourseDAO courseDAO = new CourseDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Map<String, String> filters = new HashMap<>();
        for (String k : new String[]{"q", "category", "group", "duration", "field", "interest"}) filters.put(k, req.getParameter(k));
        int page = Math.max(1, com.kalvi.util.ValidationUtil.toInt(req.getParameter("page"), 1));
        long total = courseDAO.countSearch(filters);
        int pages = (int) Math.max(1, Math.ceil(total / (double) PAGE_SIZE));
        page = Math.min(page, pages);

        // query string without "page" so pagination links can keep the active filters
        StringBuilder qs = new StringBuilder();
        for (Map.Entry<String, String> e : filters.entrySet())
            if (e.getValue() != null && !e.getValue().isBlank())
                qs.append('&').append(e.getKey()).append('=').append(java.net.URLEncoder.encode(e.getValue(), "UTF-8"));

        req.setAttribute("courses", courseDAO.search(filters, page, PAGE_SIZE));
        req.setAttribute("total", total);
        req.setAttribute("page", page);
        req.setAttribute("pages", pages);
        req.setAttribute("qs", qs.toString());
        req.setAttribute("categories", courseDAO.categories());
        req.setAttribute("durations", courseDAO.distinct("duration"));
        req.setAttribute("fields", courseDAO.distinct("career_field"));
        int sid = SessionUtil.studentId(req);
        if (sid > 0) req.setAttribute("savedIds", courseDAO.savedIds(sid));
        req.getRequestDispatcher("/WEB-INF/views/courses.jsp").forward(req, resp);
    }
}

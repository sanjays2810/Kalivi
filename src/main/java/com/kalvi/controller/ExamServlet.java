package com.kalvi.controller;

import com.kalvi.dao.ExamDAO;
import com.kalvi.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/** Government exam list with search and eligibility filters (/exams). */
@WebServlet("/exams")
public class ExamServlet extends HttpServlet {
    private final ExamDAO examDAO = new ExamDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Map<String, String> filters = new HashMap<>();
        for (String k : new String[]{"q", "category", "department", "qualification", "age"}) filters.put(k, req.getParameter(k));
        req.setAttribute("exams", examDAO.search(filters));
        req.setAttribute("categories", examDAO.categories());
        req.setAttribute("departments", examDAO.departments());
        req.setAttribute("upcoming", examDAO.upcomingDates(5));
        int sid = SessionUtil.studentId(req);
        if (sid > 0) req.setAttribute("savedIds", examDAO.savedIds(sid));
        req.getRequestDispatcher("/WEB-INF/views/exams.jsp").forward(req, resp);
    }
}

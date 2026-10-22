package com.kalvi.controller;

import com.kalvi.dao.ExamDAO;
import com.kalvi.model.GovernmentExam;
import com.kalvi.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/** Single exam page with dates and centers (/exam?id=). */
@WebServlet("/exam")
public class ExamDetailsServlet extends HttpServlet {
    private final ExamDAO examDAO = new ExamDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        GovernmentExam e = examDAO.findById(ValidationUtil.toInt(req.getParameter("id"), -1));
        if (e == null) { Flash.fail(req, resp, 404, "Exam not found. It may have been removed."); return; }
        req.setAttribute("exam", e);
        req.setAttribute("dates", examDAO.dates(e.getId()));
        req.setAttribute("centers", examDAO.centers(e.getId()));
        int sid = SessionUtil.studentId(req);
        if (sid > 0) req.setAttribute("savedIds", examDAO.savedIds(sid));
        req.getRequestDispatcher("/WEB-INF/views/exam-details.jsp").forward(req, resp);
    }
}

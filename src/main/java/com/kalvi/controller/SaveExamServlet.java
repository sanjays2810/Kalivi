package com.kalvi.controller;

import com.kalvi.dao.ExamDAO;
import com.kalvi.util.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/** POST /student/save-exam - toggles a saved exam. */
@WebServlet("/student/save-exam")
public class SaveExamServlet extends HttpServlet {
    private final ExamDAO dao = new ExamDAO();
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int examId = ValidationUtil.toInt(req.getParameter("examId"), -1);
        if (dao.findById(examId) == null) Flash.error(req, "Exam not found.");
        else Flash.success(req, dao.toggleSaved(SessionUtil.studentId(req), examId) ? "Exam saved." : "Exam removed from saved list.");
        resp.sendRedirect(safeBack(req));
    }

    /** Redirect target: the Referer if it belongs to this application, otherwise the dashboard. */
    static String safeBack(HttpServletRequest req) {
        String ref = req.getHeader("Referer");
        String base = req.getScheme() + "://" + req.getServerName();
        if (ref != null && ref.startsWith(base) && ref.contains(req.getContextPath())) return ref;
        return req.getContextPath() + "/student/dashboard";
    }
}

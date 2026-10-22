package com.kalvi.controller;

import com.kalvi.dao.*;
import com.kalvi.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/** Saved courses, exams and roadmaps (/student/saved). POST action=deleteRoadmap removes one roadmap. */
@WebServlet("/student/saved")
public class SavedServlet extends HttpServlet {
    private final CourseDAO courseDAO = new CourseDAO();
    private final ExamDAO examDAO = new ExamDAO();
    private final RecommendationDAO recDAO = new RecommendationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int sid = SessionUtil.studentId(req);
        req.setAttribute("savedCourses", courseDAO.savedBy(sid));
        req.setAttribute("savedExams", examDAO.savedBy(sid));
        req.setAttribute("roadmaps", recDAO.findByStudent(sid));
        req.setAttribute("savedIds", courseDAO.savedIds(sid));
        req.setAttribute("examSaved", examDAO.savedIds(sid));
        req.getRequestDispatcher("/WEB-INF/views/saved.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        recDAO.delete(ValidationUtil.toInt(req.getParameter("id"), -1), SessionUtil.studentId(req));
        Flash.success(req, "Roadmap deleted.");
        resp.sendRedirect(req.getContextPath() + "/student/saved");
    }
}

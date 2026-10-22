package com.kalvi.controller;

import com.kalvi.dao.*;
import com.kalvi.model.CareerRecommendation;
import com.kalvi.model.Student;
import com.kalvi.service.CareerRecommendationService;
import com.kalvi.service.RoadmapResult;
import com.kalvi.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/** Personalised student dashboard (/student/dashboard). */
@WebServlet("/student/dashboard")
public class DashboardServlet extends HttpServlet {
    private final StudentDAO studentDAO = new StudentDAO();
    private final CourseDAO courseDAO = new CourseDAO();
    private final ExamDAO examDAO = new ExamDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO();
    private final RecommendationDAO recommendationDAO = new RecommendationDAO();
    private final CareerRecommendationService service = new CareerRecommendationService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int sid = SessionUtil.studentId(req);
        Student student = studentDAO.findByUserId(sid);
        if (student == null) { resp.sendRedirect(req.getContextPath() + "/logout"); return; }
        RoadmapResult rec = service.build(student);
        List<CareerRecommendation> roadmaps = recommendationDAO.findByStudent(sid);

        req.setAttribute("student", student);
        req.setAttribute("rec", rec);
        req.setAttribute("savedCourses", courseDAO.savedBy(sid));
        req.setAttribute("savedExams", examDAO.savedBy(sid));
        req.setAttribute("upcoming", examDAO.upcomingDates(6));
        req.setAttribute("upcomingCount", examDAO.countUpcomingDates());
        req.setAttribute("notifications", notificationDAO.latest(5));
        req.setAttribute("latestRoadmap", roadmaps.isEmpty() ? null : roadmaps.get(0));
        req.setAttribute("courseSaved", courseDAO.savedIds(sid));
        req.setAttribute("examSaved", examDAO.savedIds(sid));
        req.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(req, resp);
    }
}

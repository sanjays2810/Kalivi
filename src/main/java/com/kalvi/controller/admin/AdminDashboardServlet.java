package com.kalvi.controller.admin;

import com.kalvi.dao.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/** Admin statistics: /admin/dashboard (cards + charts) and /admin/reports (tables). */
@WebServlet({"/admin/dashboard", "/admin/reports"})
public class AdminDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        StudentDAO students = new StudentDAO();
        CourseDAO courses = new CourseDAO();
        ExamDAO exams = new ExamDAO();
        req.setAttribute("totalStudents", students.count());
        req.setAttribute("totalCourses", courses.count());
        req.setAttribute("totalExams", exams.count());
        req.setAttribute("totalResources", new ResourceDAO().count());
        req.setAttribute("totalLibraries", new LibraryDAO().count());
        req.setAttribute("byGroup", students.countByGroup());
        req.setAttribute("byCategory", courses.countByCategory());
        req.setAttribute("byExamCategory", exams.countByCategory());
        boolean reports = req.getServletPath().endsWith("reports");
        if (reports) req.setAttribute("byDistrict", students.countByDistrict());
        req.getRequestDispatcher(reports ? "/WEB-INF/views/admin/reports.jsp" : "/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }
}

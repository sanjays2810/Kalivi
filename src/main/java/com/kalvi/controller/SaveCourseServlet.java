package com.kalvi.controller;

import com.kalvi.dao.CourseDAO;
import com.kalvi.util.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/** POST /student/save-course - toggles a saved course, then returns to the page the student came from. */
@WebServlet("/student/save-course")
public class SaveCourseServlet extends HttpServlet {
    private final CourseDAO dao = new CourseDAO();
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int courseId = ValidationUtil.toInt(req.getParameter("courseId"), -1);
        if (dao.findById(courseId) == null) Flash.error(req, "Course not found.");
        else Flash.success(req, dao.toggleSaved(SessionUtil.studentId(req), courseId) ? "Course saved." : "Course removed from saved list.");
        resp.sendRedirect(SaveExamServlet.safeBack(req));
    }
}

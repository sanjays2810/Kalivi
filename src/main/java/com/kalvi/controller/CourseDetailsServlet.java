package com.kalvi.controller;

import com.kalvi.dao.CourseDAO;
import com.kalvi.model.Course;
import com.kalvi.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/** Single course page (/course?id=). */
@WebServlet("/course")
public class CourseDetailsServlet extends HttpServlet {
    private final CourseDAO courseDAO = new CourseDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Course c = courseDAO.findById(ValidationUtil.toInt(req.getParameter("id"), -1));
        if (c == null) { Flash.fail(req, resp, 404, "Course not found. It may have been removed."); return; }
        req.setAttribute("course", c);
        int sid = SessionUtil.studentId(req);
        if (sid > 0) req.setAttribute("savedIds", courseDAO.savedIds(sid));
        req.getRequestDispatcher("/WEB-INF/views/course-details.jsp").forward(req, resp);
    }
}

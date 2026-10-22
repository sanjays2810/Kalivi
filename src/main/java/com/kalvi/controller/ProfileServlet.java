package com.kalvi.controller;

import com.kalvi.dao.StudentDAO;
import com.kalvi.model.Student;
import com.kalvi.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/** View / update the student's 12th details and interests (/student/profile). */
@WebServlet("/student/profile")
public class ProfileServlet extends HttpServlet {
    private final StudentDAO dao = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("student", dao.findByUserId(SessionUtil.studentId(req)));
        req.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Student s = StudentForm.read(req);
        s.setUserId(SessionUtil.studentId(req));
        Student old = dao.findByUserId(s.getUserId());
        s.setEmail(old.getEmail());                       // email cannot be changed here
        List<String> errors = StudentForm.validate(s);
        if (!errors.isEmpty()) {
            req.setAttribute("errors", errors);
            req.setAttribute("student", s);
            req.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(req, resp);
            return;
        }
        dao.updateProfile(s);
        SessionUtil.currentUser(req).setFullName(s.getFullName());
        Flash.success(req, "Profile updated. Your recommendations have been refreshed.");
        resp.sendRedirect(req.getContextPath() + "/student/dashboard");
    }
}

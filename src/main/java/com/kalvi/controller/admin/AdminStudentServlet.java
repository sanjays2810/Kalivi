package com.kalvi.controller.admin;

import com.kalvi.dao.*;
import com.kalvi.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/** View and remove registered students (/admin/students). */
@WebServlet("/admin/students")
public class AdminStudentServlet extends HttpServlet {
    private final StudentDAO studentDAO = new StudentDAO();
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("students", studentDAO.findAll());
        req.getRequestDispatcher("/WEB-INF/views/admin/students.jsp").forward(req, resp);
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = ValidationUtil.toInt(req.getParameter("id"), -1);
        if (studentDAO.findByUserId(id) != null) { new UserDAO().delete(id); Flash.success(req, "Student deleted."); }
        resp.sendRedirect(req.getContextPath() + "/admin/students");
    }
}

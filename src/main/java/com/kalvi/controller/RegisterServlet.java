package com.kalvi.controller;

import com.kalvi.dao.StudentDAO;
import com.kalvi.dao.UserDAO;
import com.kalvi.model.Student;
import com.kalvi.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/** Student registration. */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Student s = StudentForm.read(req);
        List<String> errors = StudentForm.validate(s);
        String password = req.getParameter("password");
        if (!ValidationUtil.isEmail(s.getEmail())) errors.add("Enter a valid email address.");
        if (!ValidationUtil.strongPassword(password)) errors.add("Password must be at least 8 characters with a letter and a number.");
        else if (!password.equals(req.getParameter("confirmPassword"))) errors.add("Passwords do not match.");
        if (errors.isEmpty() && userDAO.emailExists(s.getEmail())) errors.add("Email already registered. Please login instead.");

        if (!errors.isEmpty()) {
            req.setAttribute("errors", errors);
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
            return;
        }
        studentDAO.register(s, PasswordUtil.hash(password));
        Flash.success(req, "Registration successful! Please login with your email and password.");
        resp.sendRedirect(req.getContextPath() + "/login");
    }
}

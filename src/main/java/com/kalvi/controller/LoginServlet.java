package com.kalvi.controller;

import com.kalvi.dao.UserDAO;
import com.kalvi.model.User;
import com.kalvi.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/** Student login. */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (SessionUtil.isStudent(req)) { resp.sendRedirect(req.getContextPath() + "/student/dashboard"); return; }
        String msg = req.getParameter("msg");
        if ("expired".equals(msg)) req.setAttribute("info", "Your session has expired. Please login again.");
        else if ("login".equals(msg)) req.setAttribute("info", "Please login to continue.");
        else if ("out".equals(msg)) req.setAttribute("info", "You have been logged out.");
        req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = ValidationUtil.trim(req.getParameter("email"));
        String password = req.getParameter("password");
        User user = ValidationUtil.isEmail(email) ? userDAO.findByEmail(email) : null;
        if (user == null || !"STUDENT".equals(user.getRole()) || !PasswordUtil.verify(password, user.getPasswordHash())) {
            req.setAttribute("error", "Invalid email or password.");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
            return;
        }
        SessionUtil.login(req, user);
        resp.sendRedirect(req.getContextPath() + "/student/dashboard");
    }
}

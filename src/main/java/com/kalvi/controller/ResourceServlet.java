package com.kalvi.controller;

import com.kalvi.dao.ResourceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/** Educational resources (/resources). */
@WebServlet("/resources")
public class ResourceServlet extends HttpServlet {
    private final ResourceDAO dao = new ResourceDAO();
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("resources", dao.findAll(req.getParameter("category"), req.getParameter("q")));
        req.getRequestDispatcher("/WEB-INF/views/resources.jsp").forward(req, resp);
    }
}

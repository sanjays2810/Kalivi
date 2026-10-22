package com.kalvi.controller;

import com.kalvi.dao.LibraryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/** Nearby libraries / learning centres, searchable by district (/libraries). */
@WebServlet("/libraries")
public class LibraryServlet extends HttpServlet {
    private final LibraryDAO dao = new LibraryDAO();
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("libraries", dao.search(req.getParameter("district"), req.getParameter("q")));
        req.getRequestDispatcher("/WEB-INF/views/libraries.jsp").forward(req, resp);
    }
}

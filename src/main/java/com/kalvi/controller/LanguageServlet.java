package com.kalvi.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/** /lang?code=en|ta - stores the chosen language in the session and returns to the previous page. */
@WebServlet("/lang")
public class LanguageServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String code = req.getParameter("code");
        if ("en".equals(code) || "ta".equals(code)) req.getSession(true).setAttribute("lang", code);
        String back = req.getHeader("Referer");
        resp.sendRedirect(back != null && back.contains(req.getServerName()) ? back : req.getContextPath() + "/");
    }
}

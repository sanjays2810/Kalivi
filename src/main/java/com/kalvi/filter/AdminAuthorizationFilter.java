package com.kalvi.filter;

import com.kalvi.util.SessionUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/** Protects /admin/* : only an ADMIN may pass (except the admin login page itself). */
@WebFilter("/admin/*")
public class AdminAuthorizationFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        resp.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
        if ("/admin/login".equals(req.getServletPath()) || SessionUtil.isAdmin(req)) {
            chain.doFilter(request, response);
            return;
        }
        if (SessionUtil.isStudent(req)) {            // a student tried to open the admin area
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Unauthorized access");
            return;
        }
        boolean expired = req.getRequestedSessionId() != null && !req.isRequestedSessionIdValid();
        resp.sendRedirect(req.getContextPath() + "/admin/login?msg=" + (expired ? "expired" : "login"));
    }
}

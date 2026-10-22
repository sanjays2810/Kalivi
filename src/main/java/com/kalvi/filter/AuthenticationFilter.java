package com.kalvi.filter;

import com.kalvi.util.SessionUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/** Protects /student/* : only a logged-in STUDENT may pass. */
@WebFilter("/student/*")
public class AuthenticationFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        if (!SessionUtil.isStudent(req)) {
            boolean expired = req.getRequestedSessionId() != null && !req.isRequestedSessionIdValid();
            resp.sendRedirect(req.getContextPath() + "/login?msg=" + (expired ? "expired" : "login"));
            return;
        }
        resp.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");   // back button must not show private pages after logout
        chain.doFilter(request, response);
    }
}

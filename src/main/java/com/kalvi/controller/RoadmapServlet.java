package com.kalvi.controller;

import com.kalvi.dao.RecommendationDAO;
import com.kalvi.dao.StudentDAO;
import com.kalvi.model.Student;
import com.kalvi.service.CareerRecommendationService;
import com.kalvi.service.RoadmapResult;
import com.kalvi.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/** Career roadmap form + result (/roadmap). Anyone can generate a roadmap; logged-in students also get it saved. */
@WebServlet("/roadmap")
public class RoadmapServlet extends HttpServlet {
    private final StudentDAO studentDAO = new StudentDAO();
    private final RecommendationDAO recommendationDAO = new RecommendationDAO();
    private final CareerRecommendationService service = new CareerRecommendationService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int sid = SessionUtil.studentId(req);
        Student profile = sid > 0 ? studentDAO.findByUserId(sid) : null;
        req.setAttribute("form", profile);               // pre-fill the form from the saved profile
        if (profile != null && "1".equals(req.getParameter("auto"))) {   // "Build from my profile" shortcut
            generate(req, resp, profile, sid);
            return;
        }
        req.getRequestDispatcher("/WEB-INF/views/roadmap.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Student input = StudentForm.read(req);
        List<String> errors = new java.util.ArrayList<>();
        if (!Options.GROUPS.contains(input.getGroup12())) errors.add("Select your 12th group.");
        if (input.getMarks() < 0 || input.getMarks() > 100) errors.add("12th marks must be between 0 and 100.");
        if (!Options.SECTORS.contains(input.getSectorPreference())) input.setSectorPreference("Both");
        int sid = SessionUtil.studentId(req);
        if (sid > 0) {                                   // keep DOB (used for exam age checks) from the saved profile
            Student saved = studentDAO.findByUserId(sid);
            if (saved != null) { input.setDob(saved.getDob()); if (ValidationUtil.blank(input.getDistrict())) input.setDistrict(saved.getDistrict()); }
        }
        if (!errors.isEmpty()) {
            req.setAttribute("errors", errors);
            req.setAttribute("form", input);
            req.getRequestDispatcher("/WEB-INF/views/roadmap.jsp").forward(req, resp);
            return;
        }
        generate(req, resp, input, sid);
    }

    private void generate(HttpServletRequest req, HttpServletResponse resp, Student input, int sid) throws ServletException, IOException {
        RoadmapResult result = service.build(input);
        if (sid > 0 && !result.getSteps().isEmpty() && !result.getTopCourseName().isEmpty()) {
            recommendationDAO.save(sid, input.getPreferredCareer() == null ? "" : input.getPreferredCareer(),
                    result.getTopCourseName(), result.stepsAsText());
            req.setAttribute("savedMsg", true);
        }
        req.setAttribute("form", input);
        req.setAttribute("result", result);
        req.getRequestDispatcher("/WEB-INF/views/roadmap.jsp").forward(req, resp);
    }
}

package com.kalvi.controller.admin;

import com.kalvi.dao.ExamDAO;
import com.kalvi.model.GovernmentExam;
import com.kalvi.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;

/**
 * Government exam CRUD plus exam dates and exam centers (/admin/exams).
 * POST actions: save, delete, addDate, deleteDate, addCenter, deleteCenter.
 */
@WebServlet("/admin/exams")
public class AdminExamServlet extends HttpServlet {
    private final ExamDAO dao = new ExamDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("new".equals(action)) {
            GovernmentExam e = new GovernmentExam();
            e.setDemo(false);
            req.setAttribute("exam", e);
            req.setAttribute("formMode", true);
        } else if ("edit".equals(action)) {
            GovernmentExam e = dao.findById(ValidationUtil.toInt(req.getParameter("id"), -1));
            if (e == null) { Flash.fail(req, resp, 404, "Exam not found."); return; }
            req.setAttribute("exam", e);
            req.setAttribute("dates", dao.dates(e.getId()));
            req.setAttribute("centers", dao.centers(e.getId()));
            req.setAttribute("formMode", true);
        } else {
            req.setAttribute("exams", dao.findAll());
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/exams.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = ValidationUtil.trim(req.getParameter("action"));
        int examId = ValidationUtil.toInt(req.getParameter("examId"), 0);
        String back = req.getContextPath() + "/admin/exams?action=edit&id=" + examId;
        switch (action) {
            case "delete" -> {
                dao.delete(ValidationUtil.toInt(req.getParameter("id"), -1));
                Flash.success(req, "Exam deleted.");
                resp.sendRedirect(req.getContextPath() + "/admin/exams");
            }
            case "addDate" -> {
                try {
                    java.sql.Date d = java.sql.Date.valueOf(LocalDate.parse(req.getParameter("eventDate")));
                    String name = ValidationUtil.trim(req.getParameter("eventName"));
                    if (name.isEmpty() || dao.findById(examId) == null) throw new IllegalArgumentException();
                    dao.addDate(examId, name, d, "on".equals(req.getParameter("official")));
                    Flash.success(req, "Date added.");
                } catch (RuntimeException e) {
                    if (e instanceof DataAccessException) throw e;
                    Flash.error(req, "Enter an event name and a valid date.");
                }
                resp.sendRedirect(back);
            }
            case "deleteDate" -> { dao.deleteDate(ValidationUtil.toInt(req.getParameter("id"), -1)); Flash.success(req, "Date removed."); resp.sendRedirect(back); }
            case "addCenter" -> {
                String name = ValidationUtil.trim(req.getParameter("centerName"));
                String district = ValidationUtil.trim(req.getParameter("district"));
                if (name.isEmpty() || !Options.DISTRICTS.contains(district) || dao.findById(examId) == null) Flash.error(req, "Enter a center name and select a district.");
                else { dao.addCenter(examId, district, name, ValidationUtil.trim(req.getParameter("address"))); Flash.success(req, "Center added."); }
                resp.sendRedirect(back);
            }
            case "deleteCenter" -> { dao.deleteCenter(ValidationUtil.toInt(req.getParameter("id"), -1)); Flash.success(req, "Center removed."); resp.sendRedirect(back); }
            default -> save(req, resp);
        }
    }

    private void save(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        GovernmentExam e = new GovernmentExam();
        e.setId(ValidationUtil.toInt(req.getParameter("id"), 0));
        e.setName(ValidationUtil.trim(req.getParameter("name")));
        e.setDepartment(ValidationUtil.trim(req.getParameter("department")));
        e.setCategory(ValidationUtil.trim(req.getParameter("category")));
        String q = ValidationUtil.trim(req.getParameter("qualification"));
        e.setQualification(q);
        e.setQualificationRank("10th".equals(q) ? 10 : "Degree".equals(q) ? 15 : 12);
        e.setMinAge(ValidationUtil.toInt(req.getParameter("minAge"), 0));
        e.setMaxAge(ValidationUtil.toInt(req.getParameter("maxAge"), 0));
        e.setEligibility(ValidationUtil.trim(req.getParameter("eligibility")));
        e.setAgeLimit(ValidationUtil.trim(req.getParameter("ageLimit")));
        e.setApplicationProcess(ValidationUtil.trim(req.getParameter("applicationProcess")));
        e.setRegistrationInfo(ValidationUtil.trim(req.getParameter("registrationInfo")));
        e.setExamPattern(ValidationUtil.trim(req.getParameter("examPattern")));
        e.setSyllabus(ValidationUtil.trim(req.getParameter("syllabus")));
        e.setSelectionProcess(ValidationUtil.trim(req.getParameter("selectionProcess")));
        e.setInstructions(ValidationUtil.trim(req.getParameter("instructions")));
        e.setOfficialUrl(ValidationUtil.trim(req.getParameter("officialUrl")));
        e.setInterestTags(ValidationUtil.trim(req.getParameter("interestTags")));
        e.setDemo("on".equals(req.getParameter("demo")));
        boolean urlOk = e.getOfficialUrl().isEmpty() || e.getOfficialUrl().matches("^https?://.+");
        if (e.getName().isEmpty() || e.getDepartment().isEmpty() || e.getCategory().isEmpty() || !Options.QUALIFICATIONS.contains(q)
                || !urlOk || e.getMinAge() < 0 || e.getMaxAge() < 0) {
            req.setAttribute("errors", java.util.List.of("Name, department, category and qualification are required; the official URL must start with http:// or https://."));
            req.setAttribute("exam", e);
            req.setAttribute("formMode", true);
            if (e.getId() > 0) { req.setAttribute("dates", dao.dates(e.getId())); req.setAttribute("centers", dao.centers(e.getId())); }
            req.getRequestDispatcher("/WEB-INF/views/admin/exams.jsp").forward(req, resp);
            return;
        }
        if (e.getId() > 0) {
            dao.update(e);
            Flash.success(req, "Exam updated. Last-updated date refreshed.");
            resp.sendRedirect(req.getContextPath() + "/admin/exams?action=edit&id=" + e.getId());
        } else {
            int id = dao.create(e);
            Flash.success(req, "Exam added. Now add its dates and centers.");
            resp.sendRedirect(req.getContextPath() + "/admin/exams?action=edit&id=" + id);
        }
    }
}

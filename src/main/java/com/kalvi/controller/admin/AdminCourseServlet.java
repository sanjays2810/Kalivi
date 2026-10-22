package com.kalvi.controller.admin;

import com.kalvi.dao.CourseDAO;
import com.kalvi.model.Course;
import com.kalvi.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/** Course CRUD (/admin/courses). GET: list, ?action=new, ?action=edit&id=. POST: action=save | delete. */
@WebServlet("/admin/courses")
public class AdminCourseServlet extends HttpServlet {
    private final CourseDAO dao = new CourseDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        req.setAttribute("categories", dao.categories());
        if ("new".equals(action)) {
            req.setAttribute("course", new Course());
            req.setAttribute("formMode", true);
        } else if ("edit".equals(action)) {
            Course c = dao.findById(ValidationUtil.toInt(req.getParameter("id"), -1));
            if (c == null) { Flash.fail(req, resp, 404, "Course not found."); return; }
            req.setAttribute("course", c);
            req.setAttribute("formMode", true);
        } else {
            req.setAttribute("courses", dao.findAll());
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/courses.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if ("delete".equals(req.getParameter("action"))) {
            dao.delete(ValidationUtil.toInt(req.getParameter("id"), -1));
            Flash.success(req, "Course deleted.");
            resp.sendRedirect(req.getContextPath() + "/admin/courses");
            return;
        }
        Course c = new Course();
        c.setId(ValidationUtil.toInt(req.getParameter("id"), 0));
        c.setName(ValidationUtil.trim(req.getParameter("name")));
        c.setCategoryId(ValidationUtil.toInt(req.getParameter("categoryId"), 0));
        c.setDuration(ValidationUtil.trim(req.getParameter("duration")));
        c.setEligibility(ValidationUtil.trim(req.getParameter("eligibility")));
        c.setRequiredGroups(ValidationUtil.trim(req.getParameter("requiredGroups")));
        c.setAdmissionRequirements(ValidationUtil.trim(req.getParameter("admissionRequirements")));
        c.setCareerOpportunities(ValidationUtil.trim(req.getParameter("careerOpportunities")));
        c.setHigherStudies(ValidationUtil.trim(req.getParameter("higherStudies")));
        c.setJobOpportunities(ValidationUtil.trim(req.getParameter("jobOpportunities")));
        c.setGovernmentOpportunities(ValidationUtil.trim(req.getParameter("governmentOpportunities")));
        c.setSkills(ValidationUtil.trim(req.getParameter("skills")));
        c.setDescription(ValidationUtil.trim(req.getParameter("description")));
        c.setCareerField(ValidationUtil.trim(req.getParameter("careerField")));
        c.setInterestTags(ValidationUtil.trim(req.getParameter("interestTags")));
        c.setMinMarks(ValidationUtil.toDouble(req.getParameter("minMarks"), 0));
        c.setDemo("on".equals(req.getParameter("demo")));
        if (c.getName().isEmpty() || c.getCategoryId() <= 0 || c.getDuration().isEmpty() || c.getRequiredGroups().isEmpty()
                || c.getMinMarks() < 0 || c.getMinMarks() > 100) {
            req.setAttribute("errors", java.util.List.of("Name, category, duration and required groups are mandatory; minimum marks must be 0-100."));
            req.setAttribute("course", c);
            req.setAttribute("formMode", true);
            req.setAttribute("categories", dao.categories());
            req.getRequestDispatcher("/WEB-INF/views/admin/courses.jsp").forward(req, resp);
            return;
        }
        if (c.getId() > 0) { dao.update(c); Flash.success(req, "Course updated."); }
        else { dao.create(c); Flash.success(req, "Course added."); }
        resp.sendRedirect(req.getContextPath() + "/admin/courses");
    }
}

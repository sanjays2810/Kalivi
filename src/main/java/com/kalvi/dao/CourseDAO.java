package com.kalvi.dao;

import com.kalvi.model.Course;
import com.kalvi.model.CourseCategory;
import com.kalvi.util.Jdbc;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/** Data access for courses, categories and saved courses. */
public class CourseDAO {
    private static final String SELECT = "SELECT c.*, cat.name AS category_name FROM courses c "
            + "JOIN course_categories cat ON cat.id = c.category_id ";

    static Course map(ResultSet rs) throws SQLException {
        return new Course(rs.getInt("id"), rs.getString("name"), rs.getInt("category_id"), rs.getString("category_name"),
                rs.getString("duration"), rs.getString("eligibility"), rs.getString("required_groups"),
                rs.getString("admission_requirements"), rs.getString("career_opportunities"), rs.getString("higher_studies"),
                rs.getString("job_opportunities"), rs.getString("government_opportunities"), rs.getString("skills"),
                rs.getString("description"), rs.getString("career_field"), rs.getString("interest_tags"),
                rs.getDouble("min_marks"), rs.getBoolean("is_demo"), rs.getTimestamp("last_updated"));
    }

    /** Builds the dynamic WHERE clause from the filter map (q, category, group, duration, field, interest). */
    private String where(Map<String, String> f, List<Object> params) {
        StringBuilder w = new StringBuilder(" WHERE 1=1");
        String q = f.get("q");
        if (q != null && !q.isBlank()) {
            w.append(" AND (c.name LIKE ? OR c.description LIKE ? OR c.skills LIKE ? OR c.career_opportunities LIKE ?)");
            for (int i = 0; i < 4; i++) params.add("%" + q.trim() + "%");
        }
        String cat = f.get("category");
        if (cat != null && cat.matches("\\d+")) { w.append(" AND c.category_id = ?"); params.add(Integer.parseInt(cat)); }
        String grp = f.get("group");
        if (grp != null && !grp.isBlank()) { w.append(" AND (c.required_groups LIKE ? OR c.required_groups = 'Any')"); params.add("%" + grp + "%"); }
        String dur = f.get("duration");
        if (dur != null && !dur.isBlank()) { w.append(" AND c.duration = ?"); params.add(dur); }
        String field = f.get("field");
        if (field != null && !field.isBlank()) { w.append(" AND c.career_field = ?"); params.add(field); }
        String interest = f.get("interest");
        if (interest != null && !interest.isBlank()) { w.append(" AND c.interest_tags LIKE ?"); params.add("%" + interest + "%"); }
        return w.toString();
    }

    public List<Course> search(Map<String, String> filters, int page, int pageSize) {
        List<Object> p = new ArrayList<>();
        String sql = SELECT + where(filters, p) + " ORDER BY c.name LIMIT ? OFFSET ?";
        p.add(pageSize);
        p.add((page - 1) * pageSize);
        return Jdbc.query(sql, CourseDAO::map, p.toArray());
    }

    public long countSearch(Map<String, String> filters) {
        List<Object> p = new ArrayList<>();
        return Jdbc.count("SELECT COUNT(*) FROM courses c" + where(filters, p), p.toArray());
    }

    public List<Course> findAll() { return Jdbc.query(SELECT + "ORDER BY c.name", CourseDAO::map); }
    public Course findById(int id) { return Jdbc.queryOne(SELECT + "WHERE c.id = ?", CourseDAO::map, id); }
    public long count() { return Jdbc.count("SELECT COUNT(*) FROM courses"); }

    public List<CourseCategory> categories() {
        return Jdbc.query("SELECT * FROM course_categories ORDER BY id",
                rs -> new CourseCategory(rs.getInt("id"), rs.getString("name"), rs.getString("description")));
    }

    public Set<String> distinct(String column) {   // column is chosen by code (never user input)
        if (!column.equals("duration") && !column.equals("career_field")) throw new IllegalArgumentException(column);
        return new LinkedHashSet<>(Jdbc.query("SELECT DISTINCT " + column + " FROM courses WHERE " + column
                + " <> '' ORDER BY 1", rs -> rs.getString(1)));
    }

    public Map<String, Long> countByCategory() {
        return StudentDAO.grouped("SELECT cat.name, COUNT(c.id) FROM course_categories cat LEFT JOIN courses c "
                + "ON c.category_id = cat.id GROUP BY cat.name ORDER BY 2 DESC");
    }

    public void create(Course c) {
        Jdbc.insert("INSERT INTO courses(name,category_id,duration,eligibility,required_groups,admission_requirements,"
                        + "career_opportunities,higher_studies,job_opportunities,government_opportunities,skills,description,"
                        + "career_field,interest_tags,min_marks,is_demo) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
                c.getName(), c.getCategoryId(), c.getDuration(), c.getEligibility(), c.getRequiredGroups(),
                c.getAdmissionRequirements(), c.getCareerOpportunities(), c.getHigherStudies(), c.getJobOpportunities(),
                c.getGovernmentOpportunities(), c.getSkills(), c.getDescription(), c.getCareerField(), c.getInterestTags(),
                c.getMinMarks(), c.isDemo());
    }

    public void update(Course c) {
        Jdbc.update("UPDATE courses SET name=?,category_id=?,duration=?,eligibility=?,required_groups=?,admission_requirements=?,"
                        + "career_opportunities=?,higher_studies=?,job_opportunities=?,government_opportunities=?,skills=?,"
                        + "description=?,career_field=?,interest_tags=?,min_marks=?,is_demo=? WHERE id=?",
                c.getName(), c.getCategoryId(), c.getDuration(), c.getEligibility(), c.getRequiredGroups(),
                c.getAdmissionRequirements(), c.getCareerOpportunities(), c.getHigherStudies(), c.getJobOpportunities(),
                c.getGovernmentOpportunities(), c.getSkills(), c.getDescription(), c.getCareerField(), c.getInterestTags(),
                c.getMinMarks(), c.isDemo(), c.getId());
    }

    public void delete(int id) { Jdbc.update("DELETE FROM courses WHERE id = ?", id); }

    // ---- saved courses ----
    public List<Course> savedBy(int studentId) {
        return Jdbc.query(SELECT + "JOIN saved_courses sc ON sc.course_id = c.id WHERE sc.student_id = ? ORDER BY sc.saved_at DESC",
                CourseDAO::map, studentId);
    }
    public Set<Integer> savedIds(int studentId) {
        return new LinkedHashSet<>(Jdbc.query("SELECT course_id FROM saved_courses WHERE student_id = ?",
                rs -> rs.getInt(1), studentId));
    }
    /** Saves the course, or removes it if it was already saved. Returns true when now saved. */
    public boolean toggleSaved(int studentId, int courseId) {
        if (Jdbc.update("DELETE FROM saved_courses WHERE student_id = ? AND course_id = ?", studentId, courseId) > 0) return false;
        Jdbc.update("INSERT INTO saved_courses(student_id,course_id) VALUES(?,?)", studentId, courseId);
        return true;
    }
}

package com.kalvi.dao;

import com.kalvi.model.ExamCenter;
import com.kalvi.model.ExamDate;
import com.kalvi.model.GovernmentExam;
import com.kalvi.util.Jdbc;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/** Data access for government exams, their dates, centers and saved exams. */
public class ExamDAO {
    static GovernmentExam map(ResultSet rs) throws SQLException {
        return new GovernmentExam(rs.getInt("id"), rs.getString("name"), rs.getString("department"), rs.getString("category"),
                rs.getString("qualification"), rs.getInt("qualification_rank"), rs.getInt("min_age"), rs.getInt("max_age"),
                rs.getString("eligibility"), rs.getString("age_limit"), rs.getString("application_process"),
                rs.getString("registration_info"), rs.getString("exam_pattern"), rs.getString("syllabus"),
                rs.getString("selection_process"), rs.getString("instructions"), rs.getString("official_url"),
                rs.getString("interest_tags"), rs.getBoolean("is_demo"), rs.getTimestamp("last_updated"));
    }

    static ExamDate mapDate(ResultSet rs) throws SQLException {
        return new ExamDate(rs.getInt("id"), rs.getInt("exam_id"), rs.getString("exam_name"), rs.getString("event_name"),
                rs.getDate("event_date"), rs.getBoolean("is_official"));
    }

    /** Filters: q, category, department, qualification (10th/12th/Diploma/Degree), age, eligibleOnlyRank. */
    public List<GovernmentExam> search(Map<String, String> f) {
        StringBuilder sql = new StringBuilder("SELECT * FROM government_exams WHERE 1=1");
        List<Object> p = new ArrayList<>();
        if (notBlank(f.get("q"))) {
            sql.append(" AND (name LIKE ? OR department LIKE ? OR eligibility LIKE ? OR syllabus LIKE ?)");
            for (int i = 0; i < 4; i++) p.add("%" + f.get("q").trim() + "%");
        }
        if (notBlank(f.get("category"))) { sql.append(" AND category = ?"); p.add(f.get("category")); }
        if (notBlank(f.get("department"))) { sql.append(" AND department = ?"); p.add(f.get("department")); }
        if (notBlank(f.get("qualification"))) {
            // a student holding qualification X can apply to exams that need X or lower
            int rank = switch (f.get("qualification")) { case "10th" -> 10; case "12th", "Diploma" -> 12; default -> 15; };
            sql.append(" AND qualification_rank <= ?"); p.add(rank);
        }
        if (notBlank(f.get("age")) && f.get("age").matches("\\d{1,2}")) {
            sql.append(" AND min_age <= ? AND (max_age = 0 OR max_age >= ?)");
            int age = Integer.parseInt(f.get("age"));
            p.add(age); p.add(age);
        }
        sql.append(" ORDER BY name");
        return Jdbc.query(sql.toString(), ExamDAO::map, p.toArray());
    }

    private static boolean notBlank(String s) { return s != null && !s.isBlank(); }

    public List<GovernmentExam> findAll() { return Jdbc.query("SELECT * FROM government_exams ORDER BY name", ExamDAO::map); }
    public GovernmentExam findById(int id) { return Jdbc.queryOne("SELECT * FROM government_exams WHERE id = ?", ExamDAO::map, id); }
    public long count() { return Jdbc.count("SELECT COUNT(*) FROM government_exams"); }
    public Set<String> categories() { return distinct("category"); }
    public Set<String> departments() { return distinct("department"); }

    private Set<String> distinct(String col) {   // col is a constant from this class
        return new LinkedHashSet<>(Jdbc.query("SELECT DISTINCT " + col + " FROM government_exams ORDER BY 1", rs -> rs.getString(1)));
    }

    public Map<String, Long> countByCategory() {
        return StudentDAO.grouped("SELECT category, COUNT(*) FROM government_exams GROUP BY category ORDER BY 2 DESC");
    }

    public int create(GovernmentExam e) {
        return (int) Jdbc.insert("INSERT INTO government_exams(name,department,category,qualification,qualification_rank,min_age,max_age,"
                        + "eligibility,age_limit,application_process,registration_info,exam_pattern,syllabus,selection_process,"
                        + "instructions,official_url,interest_tags,is_demo) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
                e.getName(), e.getDepartment(), e.getCategory(), e.getQualification(), e.getQualificationRank(), e.getMinAge(),
                e.getMaxAge(), e.getEligibility(), e.getAgeLimit(), e.getApplicationProcess(), e.getRegistrationInfo(),
                e.getExamPattern(), e.getSyllabus(), e.getSelectionProcess(), e.getInstructions(), e.getOfficialUrl(),
                e.getInterestTags(), e.isDemo());
    }

    public void update(GovernmentExam e) {
        Jdbc.update("UPDATE government_exams SET name=?,department=?,category=?,qualification=?,qualification_rank=?,min_age=?,max_age=?,"
                        + "eligibility=?,age_limit=?,application_process=?,registration_info=?,exam_pattern=?,syllabus=?,"
                        + "selection_process=?,instructions=?,official_url=?,interest_tags=?,is_demo=? WHERE id=?",
                e.getName(), e.getDepartment(), e.getCategory(), e.getQualification(), e.getQualificationRank(), e.getMinAge(),
                e.getMaxAge(), e.getEligibility(), e.getAgeLimit(), e.getApplicationProcess(), e.getRegistrationInfo(),
                e.getExamPattern(), e.getSyllabus(), e.getSelectionProcess(), e.getInstructions(), e.getOfficialUrl(),
                e.getInterestTags(), e.isDemo(), e.getId());
    }

    public void delete(int id) { Jdbc.update("DELETE FROM government_exams WHERE id = ?", id); }

    // ---- dates ----
    public List<ExamDate> dates(int examId) {
        return Jdbc.query("SELECT d.*, e.name AS exam_name FROM exam_dates d JOIN government_exams e ON e.id = d.exam_id "
                + "WHERE d.exam_id = ? ORDER BY d.event_date", ExamDAO::mapDate, examId);
    }
    public List<ExamDate> upcomingDates(int limit) {
        return Jdbc.query("SELECT d.*, e.name AS exam_name FROM exam_dates d JOIN government_exams e ON e.id = d.exam_id "
                + "WHERE d.event_date >= CURDATE() ORDER BY d.event_date LIMIT ?", ExamDAO::mapDate, limit);
    }
    public long countUpcomingDates() { return Jdbc.count("SELECT COUNT(*) FROM exam_dates WHERE event_date >= CURDATE()"); }
    public void addDate(int examId, String eventName, java.sql.Date date, boolean official) {
        Jdbc.insert("INSERT INTO exam_dates(exam_id,event_name,event_date,is_official) VALUES(?,?,?,?)", examId, eventName, date, official);
        touch(examId);
    }
    public void deleteDate(int dateId) { Jdbc.update("DELETE FROM exam_dates WHERE id = ?", dateId); }

    // ---- centers ----
    public List<ExamCenter> centers(int examId) {
        return Jdbc.query("SELECT * FROM exam_centers WHERE exam_id = ? ORDER BY district, center_name",
                rs -> new ExamCenter(rs.getInt("id"), rs.getInt("exam_id"), rs.getString("district"),
                        rs.getString("center_name"), rs.getString("address")), examId);
    }
    public void addCenter(int examId, String district, String name, String address) {
        Jdbc.insert("INSERT INTO exam_centers(exam_id,district,center_name,address) VALUES(?,?,?,?)", examId, district, name, address);
        touch(examId);
    }
    public void deleteCenter(int centerId) { Jdbc.update("DELETE FROM exam_centers WHERE id = ?", centerId); }

    private void touch(int examId) { Jdbc.update("UPDATE government_exams SET last_updated = NOW() WHERE id = ?", examId); }

    // ---- saved exams ----
    public List<GovernmentExam> savedBy(int studentId) {
        return Jdbc.query("SELECT e.* FROM government_exams e JOIN saved_exams se ON se.exam_id = e.id "
                + "WHERE se.student_id = ? ORDER BY se.saved_at DESC", ExamDAO::map, studentId);
    }
    public Set<Integer> savedIds(int studentId) {
        return new LinkedHashSet<>(Jdbc.query("SELECT exam_id FROM saved_exams WHERE student_id = ?", rs -> rs.getInt(1), studentId));
    }
    public boolean toggleSaved(int studentId, int examId) {
        if (Jdbc.update("DELETE FROM saved_exams WHERE student_id = ? AND exam_id = ?", studentId, examId) > 0) return false;
        Jdbc.update("INSERT INTO saved_exams(student_id,exam_id) VALUES(?,?)", studentId, examId);
        return true;
    }
}

package com.kalvi.dao;

import com.kalvi.model.CareerRecommendation;
import com.kalvi.util.Jdbc;
import java.util.List;

/** Data access for saved career roadmaps (table career_recommendations). */
public class RecommendationDAO {
    public void save(int studentId, String preferredCareer, String topCourse, String roadmapSteps) {
        Jdbc.insert("INSERT INTO career_recommendations(student_id,preferred_career,top_course,roadmap_steps) VALUES(?,?,?,?)",
                studentId, preferredCareer, topCourse, roadmapSteps);
        // keep only the 5 most recent roadmaps per student
        Jdbc.update("DELETE FROM career_recommendations WHERE student_id = ? AND id NOT IN "
                + "(SELECT id FROM (SELECT id FROM career_recommendations WHERE student_id = ? ORDER BY id DESC LIMIT 5) t)",
                studentId, studentId);
    }
    public List<CareerRecommendation> findByStudent(int studentId) {
        return Jdbc.query("SELECT * FROM career_recommendations WHERE student_id = ? ORDER BY id DESC",
                rs -> new CareerRecommendation(rs.getInt("id"), rs.getInt("student_id"), rs.getString("preferred_career"),
                        rs.getString("top_course"), rs.getString("roadmap_steps"), rs.getTimestamp("created_at")), studentId);
    }
    public void delete(int id, int studentId) {
        Jdbc.update("DELETE FROM career_recommendations WHERE id = ? AND student_id = ?", id, studentId);
    }
}

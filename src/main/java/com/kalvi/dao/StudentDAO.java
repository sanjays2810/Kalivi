package com.kalvi.dao;

import com.kalvi.model.Student;
import com.kalvi.util.DBConnection;
import com.kalvi.util.DataAccessException;
import com.kalvi.util.Jdbc;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/** Data access for student profiles (users + students tables). */
public class StudentDAO {
    private static final String SELECT = "SELECT s.*, u.full_name, u.email FROM students s JOIN users u ON u.id = s.user_id ";

    static Student map(ResultSet rs) throws SQLException {
        return new Student(rs.getInt("user_id"), rs.getString("full_name"), rs.getString("email"), rs.getString("mobile"),
                rs.getDate("dob"), rs.getString("gender"), rs.getString("district"), rs.getString("group_12"),
                rs.getDouble("marks"), rs.getString("interests"), rs.getString("preferred_career"),
                rs.getString("sector_preference"));
    }

    /** Creates the login account and the profile in ONE transaction. */
    public int register(Student s, String passwordHash) {
        try (Connection c = DBConnection.getConnection()) {
            c.setAutoCommit(false);
            try {
                int id;
                try (PreparedStatement ps = c.prepareStatement(
                        "INSERT INTO users(full_name,email,password_hash,role) VALUES(?,?,?,'STUDENT')", Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, s.getFullName());
                    ps.setString(2, s.getEmail().toLowerCase());
                    ps.setString(3, passwordHash);
                    ps.executeUpdate();
                    try (ResultSet k = ps.getGeneratedKeys()) { k.next(); id = k.getInt(1); }
                }
                try (PreparedStatement ps = c.prepareStatement("INSERT INTO students(user_id,mobile,dob,gender,district,group_12,marks,"
                        + "interests,preferred_career,sector_preference) VALUES(?,?,?,?,?,?,?,?,?,?)")) {
                    ps.setInt(1, id);
                    ps.setString(2, s.getMobile());
                    ps.setDate(3, new java.sql.Date(s.getDob().getTime()));
                    ps.setString(4, s.getGender());
                    ps.setString(5, s.getDistrict());
                    ps.setString(6, s.getGroup12());
                    ps.setDouble(7, s.getMarks());
                    ps.setString(8, s.getInterests());
                    ps.setString(9, s.getPreferredCareer());
                    ps.setString(10, s.getSectorPreference());
                    ps.executeUpdate();
                }
                c.commit();
                return id;
            } catch (SQLException e) { c.rollback(); throw e; }
        } catch (SQLException e) {
            throw new DataAccessException("Registration failed: " + e.getMessage(), e);
        }
    }

    public Student findByUserId(int id) { return Jdbc.queryOne(SELECT + "WHERE s.user_id = ?", StudentDAO::map, id); }

    public List<Student> findAll() { return Jdbc.query(SELECT + "ORDER BY u.created_at DESC", StudentDAO::map); }

    public void updateProfile(Student s) {
        Jdbc.update("UPDATE users SET full_name = ? WHERE id = ?", s.getFullName(), s.getUserId());
        Jdbc.update("UPDATE students SET mobile=?, dob=?, gender=?, district=?, group_12=?, marks=?, interests=?, "
                        + "preferred_career=?, sector_preference=? WHERE user_id=?",
                s.getMobile(), new java.sql.Date(s.getDob().getTime()), s.getGender(), s.getDistrict(), s.getGroup12(),
                s.getMarks(), s.getInterests(), s.getPreferredCareer(), s.getSectorPreference(), s.getUserId());
    }

    public long count() { return Jdbc.count("SELECT COUNT(*) FROM students"); }

    public Map<String, Long> countByGroup() { return grouped("SELECT group_12, COUNT(*) FROM students GROUP BY group_12 ORDER BY 2 DESC"); }
    public Map<String, Long> countByDistrict() { return grouped("SELECT district, COUNT(*) FROM students GROUP BY district ORDER BY 2 DESC"); }

    static Map<String, Long> grouped(String sql) {
        Map<String, Long> m = new LinkedHashMap<>();
        Jdbc.query(sql, rs -> { m.put(rs.getString(1), rs.getLong(2)); return 1; });
        return m;
    }
}

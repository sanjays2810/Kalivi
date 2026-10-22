package com.kalvi.dao;

import com.kalvi.model.User;
import com.kalvi.util.Jdbc;
import java.sql.ResultSet;
import java.sql.SQLException;

/** Data access for the users table (login accounts for students and admins). */
public class UserDAO {
    static User map(ResultSet rs) throws SQLException {
        return new User(rs.getInt("id"), rs.getString("full_name"), rs.getString("email"),
                rs.getString("password_hash"), rs.getString("role"), rs.getTimestamp("created_at"));
    }

    public User findByEmail(String email) {
        return Jdbc.queryOne("SELECT * FROM users WHERE email = ?", UserDAO::map, email.toLowerCase());
    }

    public User findById(int id) { return Jdbc.queryOne("SELECT * FROM users WHERE id = ?", UserDAO::map, id); }

    public boolean emailExists(String email) {
        return Jdbc.count("SELECT COUNT(*) FROM users WHERE email = ?", email.toLowerCase()) > 0;
    }

    public int create(String fullName, String email, String passwordHash, String role) {
        return (int) Jdbc.insert("INSERT INTO users(full_name,email,password_hash,role) VALUES(?,?,?,?)",
                fullName, email.toLowerCase(), passwordHash, role);
    }

    public void updatePassword(int userId, String passwordHash) {
        Jdbc.update("UPDATE users SET password_hash = ? WHERE id = ?", passwordHash, userId);
    }

    public void delete(int userId) { Jdbc.update("DELETE FROM users WHERE id = ?", userId); }
}

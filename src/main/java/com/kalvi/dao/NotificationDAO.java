package com.kalvi.dao;

import com.kalvi.model.Notification;
import com.kalvi.util.Jdbc;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

/** Data access for announcements shown on student dashboards. */
public class NotificationDAO {
    static Notification map(ResultSet rs) throws SQLException {
        return new Notification(rs.getInt("id"), rs.getString("title"), rs.getString("message"), rs.getBoolean("is_demo"),
                rs.getTimestamp("created_at"));
    }
    public List<Notification> latest(int limit) {
        return Jdbc.query("SELECT * FROM notifications ORDER BY created_at DESC, id DESC LIMIT ?", NotificationDAO::map, limit);
    }
    public Notification findById(int id) { return Jdbc.queryOne("SELECT * FROM notifications WHERE id = ?", NotificationDAO::map, id); }
    public void create(Notification n) {
        Jdbc.insert("INSERT INTO notifications(title,message,is_demo) VALUES(?,?,?)", n.getTitle(), n.getMessage(), n.isDemo());
    }
    public void update(Notification n) {
        Jdbc.update("UPDATE notifications SET title=?,message=?,is_demo=? WHERE id=?", n.getTitle(), n.getMessage(), n.isDemo(), n.getId());
    }
    public void delete(int id) { Jdbc.update("DELETE FROM notifications WHERE id = ?", id); }
}

package com.kalvi.dao;

import com.kalvi.model.Resource;
import com.kalvi.util.Jdbc;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

/** Data access for educational resources. */
public class ResourceDAO {
    static Resource map(ResultSet rs) throws SQLException {
        return new Resource(rs.getInt("id"), rs.getString("title"), rs.getString("description"), rs.getString("category"),
                rs.getString("link"), rs.getDate("date_added"));
    }
    public List<Resource> findAll(String category, String q) {
        StringBuilder sql = new StringBuilder("SELECT * FROM resources WHERE 1=1");
        java.util.List<Object> p = new java.util.ArrayList<>();
        if (category != null && !category.isBlank()) { sql.append(" AND category = ?"); p.add(category); }
        if (q != null && !q.isBlank()) { sql.append(" AND (title LIKE ? OR description LIKE ?)"); p.add("%" + q.trim() + "%"); p.add("%" + q.trim() + "%"); }
        sql.append(" ORDER BY category, date_added DESC");
        return Jdbc.query(sql.toString(), ResourceDAO::map, p.toArray());
    }
    public Resource findById(int id) { return Jdbc.queryOne("SELECT * FROM resources WHERE id = ?", ResourceDAO::map, id); }
    public long count() { return Jdbc.count("SELECT COUNT(*) FROM resources"); }
    public void create(Resource r) {
        Jdbc.insert("INSERT INTO resources(title,description,category,link,date_added) VALUES(?,?,?,?,CURDATE())",
                r.getTitle(), r.getDescription(), r.getCategory(), r.getLink());
    }
    public void update(Resource r) {
        Jdbc.update("UPDATE resources SET title=?,description=?,category=?,link=? WHERE id=?",
                r.getTitle(), r.getDescription(), r.getCategory(), r.getLink(), r.getId());
    }
    public void delete(int id) { Jdbc.update("DELETE FROM resources WHERE id = ?", id); }
}

package com.kalvi.dao;

import com.kalvi.model.Library;
import com.kalvi.util.Jdbc;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/** Data access for nearby libraries / learning centres. */
public class LibraryDAO {
    static Library map(ResultSet rs) throws SQLException {
        return new Library(rs.getInt("id"), rs.getString("name"), rs.getString("district"), rs.getString("location"),
                rs.getString("address"), rs.getString("contact"), rs.getString("facilities"), rs.getString("opening_hours"),
                rs.getBoolean("is_demo"));
    }
    public List<Library> search(String district, String q) {
        StringBuilder sql = new StringBuilder("SELECT * FROM libraries WHERE 1=1");
        List<Object> p = new ArrayList<>();
        if (district != null && !district.isBlank()) { sql.append(" AND district = ?"); p.add(district); }
        if (q != null && !q.isBlank()) { sql.append(" AND (name LIKE ? OR location LIKE ? OR address LIKE ?)"); for (int i = 0; i < 3; i++) p.add("%" + q.trim() + "%"); }
        sql.append(" ORDER BY district, name");
        return Jdbc.query(sql.toString(), LibraryDAO::map, p.toArray());
    }
    public Library findById(int id) { return Jdbc.queryOne("SELECT * FROM libraries WHERE id = ?", LibraryDAO::map, id); }
    public long count() { return Jdbc.count("SELECT COUNT(*) FROM libraries"); }
    public void create(Library l) {
        Jdbc.insert("INSERT INTO libraries(name,district,location,address,contact,facilities,opening_hours,is_demo) VALUES(?,?,?,?,?,?,?,?)",
                l.getName(), l.getDistrict(), l.getLocation(), l.getAddress(), l.getContact(), l.getFacilities(), l.getOpeningHours(), l.isDemo());
    }
    public void update(Library l) {
        Jdbc.update("UPDATE libraries SET name=?,district=?,location=?,address=?,contact=?,facilities=?,opening_hours=?,is_demo=? WHERE id=?",
                l.getName(), l.getDistrict(), l.getLocation(), l.getAddress(), l.getContact(), l.getFacilities(), l.getOpeningHours(), l.isDemo(), l.getId());
    }
    public void delete(int id) { Jdbc.update("DELETE FROM libraries WHERE id = ?", id); }
}

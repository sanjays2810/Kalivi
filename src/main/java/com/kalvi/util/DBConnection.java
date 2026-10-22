package com.kalvi.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/** Creates JDBC connections. Credentials come from db.properties (or environment variables). */
public final class DBConnection {
    private static final Properties CONFIG = new Properties();

    static {
        try (InputStream in = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (in != null) CONFIG.load(in);
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (IOException | ClassNotFoundException e) {
            throw new ExceptionInInitializerError("Cannot initialise database configuration: " + e.getMessage());
        }
    }

    private DBConnection() {}

    private static String setting(String env, String key) {
        String v = System.getenv(env);
        return (v != null && !v.isBlank()) ? v : CONFIG.getProperty(key);
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(setting("KALVI_DB_URL", "db.url"),
                setting("KALVI_DB_USER", "db.username"), setting("KALVI_DB_PASSWORD", "db.password"));
    }
}

package com.kalvi.util;

import com.kalvi.dao.UserDAO;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

/**
 * Runs once at start-up: publishes drop-down options to the JSPs and creates the DEMO accounts (hashed with BCrypt)
 * when they do not exist yet. Change/delete these accounts before any real deployment.
 */
@WebListener
public class AppInitializer implements ServletContextListener {
    public static final String DEMO_ADMIN_EMAIL = "admin@kalvi.demo";
    public static final String DEMO_ADMIN_PASSWORD = "Admin@123";

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext ctx = sce.getServletContext();
        ctx.setAttribute("groups", Options.GROUPS);
        ctx.setAttribute("interestOptions", Options.INTERESTS);
        ctx.setAttribute("sectors", Options.SECTORS);
        ctx.setAttribute("genders", Options.GENDERS);
        ctx.setAttribute("districts", Options.DISTRICTS);
        ctx.setAttribute("resourceCategories", Options.RESOURCE_CATEGORIES);
        ctx.setAttribute("qualifications", Options.QUALIFICATIONS);
        try {
            UserDAO users = new UserDAO();
            if (!users.emailExists(DEMO_ADMIN_EMAIL)) {
                int id = users.create("Kalvi Admin", DEMO_ADMIN_EMAIL, PasswordUtil.hash(DEMO_ADMIN_PASSWORD), "ADMIN");
                Jdbc.update("INSERT INTO admins(user_id, designation) VALUES(?, 'System Administrator')", id);
                ctx.log("Kalvi: demo admin created (" + DEMO_ADMIN_EMAIL + ")");
            }
        } catch (RuntimeException e) {
            ctx.log("Kalvi: could not create demo admin - is MySQL running and database.sql imported? " + e.getMessage());
        }
    }
}

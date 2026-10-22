# KALVI – Career Guidance Platform (Advanced Java: Servlets + JSP + JDBC + MySQL)

Kalvi helps students after 12th standard (especially in Tamil Nadu) choose a course, explore careers, check government-exam eligibility and print a personalised roadmap.

## 1. Features
- Home page with hero, quick-access cards, English | தமிழ் language switch (resource bundles)
- Student registration (BCrypt hashed passwords), login, logout, 30-minute session timeout, protected pages
- Student dashboard: stats, recommended courses, eligible exams, upcoming dates, saved items, latest roadmap, notifications
- Courses: search + filters (category, 12th group, duration, career field, interest) + pagination, detail page, save
- Government exams: search/eligibility filters (qualification, age, category, department), detail page with dates, centers, **official source + last-updated + DEMO label**
- Career roadmap: rule-based engine (`CareerRecommendationService`), visual timeline, saved to DB, printable (browser print)
- Resources, nearby libraries (search by district)
- Admin panel: dashboard + charts, students, CRUD for courses / exams (+dates, centers) / resources / libraries / notifications, reports, change password

## 2. Technology stack
Java 17, Servlet 6 / JSP 3.1 (Jakarta EE 10), JSTL 3, JDBC, MySQL 8, Maven, **Apache Tomcat 10.1**, Bootstrap 5, Font Awesome, Chart.js (CDN), jBCrypt.

## 3. Architecture
`JSP view  ←  Servlet controller  →  Service (CareerRecommendationService)  →  DAO  →  JDBC (Jdbc helper, PreparedStatement only)  →  MySQL`
Filters: `EncodingFilter`, `AuthenticationFilter` (/student/*), `AdminAuthorizationFilter` (/admin/*). JSPs live in `WEB-INF/views` so they can only be reached through servlets.

## 4. Project structure
```
Kalvi/
├── pom.xml
├── database.sql                      (schema + DEMO data)
└── src/main
    ├── java/com/kalvi/{model,dao,service,controller,controller/admin,filter,util}
    ├── resources/{db.properties,messages*.properties}
    └── webapp/{index.jsp,about.jsp,error.jsp,css,js,images,WEB-INF/{web.xml,jspf,tags,views,views/admin}}
```

## 5. Database design (kalvi_db)
users, students, admins, course_categories, courses, government_exams, exam_dates, exam_centers, resources, libraries, notifications, saved_courses, saved_exams, career_recommendations – with PK/FK (ON DELETE CASCADE), UNIQUE(email), NOT NULL and indexes. Student → saved_courses / saved_exams / career_recommendations; course → category; exam → dates, centers.

## 6. Installation
Install: JDK 17+, Maven 3.8+, MySQL 8, Apache Tomcat **10.1.x** (NOT 9 – this project uses `jakarta.*`).

### MySQL
```bash
mysql -u root -p < database.sql
```
Edit `src/main/resources/db.properties` (URL / username / password). Or set env vars `KALVI_DB_URL`, `KALVI_DB_USER`, `KALVI_DB_PASSWORD`.

### Build
```bash
mvn clean package          # produces target/Kalvi.war
```
### Deploy on Tomcat
Copy `target/Kalvi.war` to `<TOMCAT_HOME>/webapps/`, then start Tomcat (`bin/startup.sh` or `bin\startup.bat`).
Open **http://localhost:8080/Kalvi/** (Admin: http://localhost:8080/Kalvi/admin/login).
(Eclipse/IntelliJ: add Tomcat 10.1 server, run the project on it.)

## 7. Demo credentials
| Role | Email | Password |
|---|---|---|
| Admin | admin@kalvi.demo | Admin@123 |
| Student | register on /register | min 8 chars, letter + number |

The admin is created (BCrypt hash) automatically at first start by `AppInitializer`. Change the password in Admin → Settings.

## 8. Data accuracy
All sample courses/exams/dates/libraries are **DEMO data** (`is_demo=1`), clearly labelled in the UI. Exam dates are placeholders generated relative to today – they are NOT official. Admin → Government Exams lets you enter verified details, the official URL, official dates (tick “official”) and untick “sample data”. Pages show `Source: Official Website | Last Updated: dd-MM-yyyy`.

## 9. Test cases
1. Register with a duplicate email → “Email already registered”.
2. Register with weak password / mismatching confirm → error messages.
3. Login wrong password → “Invalid email or password”.
4. Open `/student/dashboard` while logged out → redirected to login; student opening `/admin/dashboard` → 403 page.
5. Courses: search “Java”, filter group = Commerce, category = Engineering, paginate.
6. Save/unsave a course and an exam; check Saved Items page.
7. Roadmap: Computer Science + Programming → B.Tech IT / B.E CSE / BCA near the top; print preview shows only the roadmap.
8. Exams: qualification = 12th, age = 17 → NDA appears, Group 4 does not (min age 18).
9. Switch to தமிழ் → navbar/hero change language.
10. Admin: add/edit/delete a course; add exam, then date and center; check “Last updated” changes; delete with confirm dialog.
11. Stop MySQL → friendly “could not connect to the database” page (no stack trace).
12. Wait 30 min idle → “session expired” message.

## 10. Troubleshooting
- **404 / ClassNotFound `javax.servlet`** → you used Tomcat 9; use 10.1.
- **“Communications link failure” / DB error page** → MySQL not running or wrong `db.properties`.
- **Access denied for user** → fix username/password; for MySQL 8 the URL already has `allowPublicKeyRetrieval=true`.
- **Tamil shows as ???** → keep files UTF-8 (pom sets UTF-8); don’t re-save `.properties` in ANSI.
- **Styles/icons missing** → Bootstrap/Font Awesome/Chart.js load from CDN: needs internet.
- **Admin login fails** → check Tomcat log for “demo admin created”; make sure `database.sql` was imported before first start.
- **Wrong URL** → context path = WAR name (`Kalvi.war` → `/Kalvi/`).

## 11. Future enhancements
Email verification & password reset, CSRF tokens, connection pool (HikariCP), more languages (add `messages_xx.properties`), admin import of exam notifications, maps for libraries, cut-off/college module, unit tests.

## Notes on design choices
Search servlets are merged into the list servlets (`/courses`, `/exams`); JSPs are under WEB-INF (not directly accessible); one JSP per admin entity switches between list and form.

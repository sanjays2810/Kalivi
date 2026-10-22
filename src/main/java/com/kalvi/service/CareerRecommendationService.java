package com.kalvi.service;

import com.kalvi.dao.CourseDAO;
import com.kalvi.dao.ExamDAO;
import com.kalvi.model.Course;
import com.kalvi.model.GovernmentExam;
import com.kalvi.model.Student;
import com.kalvi.service.RoadmapResult.ScoredCourse;
import com.kalvi.service.RoadmapResult.Step;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/**
 * Rule-based career recommendation engine.
 *
 * Scoring rules (all business logic lives here, not in the JSPs):
 *  1. The student's 12th group must be accepted by the course (or the course accepts "Any") - otherwise it is excluded.
 *  2. +2 for every interest that matches the course's interest tags.
 *  3. +3 if the preferred-career text matches the course name / career field / career opportunities.
 *  4. +4 for an explicit rule, e.g. IF group = Computer Science AND interest = Programming THEN B.Tech IT, B.E CSE, BCA ...
 *  5. Marks: course.minMarks above the student's marks marks the course as a "Stretch" (-2).
 */
public class CareerRecommendationService {

    /** IF group (or "*") AND interest THEN boost courses whose name contains any keyword. */
    private record Rule(String group, String interest, String... courseKeywords) {}

    private static final List<Rule> RULES = List.of(
            new Rule("Computer Science", "Programming", "Information Technology", "Computer Science", "BCA", "Artificial"),
            new Rule("Computer Applications", "Programming", "BCA", "Computer Science", "Information Technology"),
            new Rule("Computer Science", "Data & AI", "Artificial", "Data", "Computer Science"),
            new Rule("Computer Science", "Electronics", "Electronics"),
            new Rule("Bio-Maths", "Healthcare", "Pharm", "Nursing", "Physiotherapy"),
            new Rule("Biology", "Healthcare", "Nursing", "Pharm", "Physiotherapy", "Medical Laboratory"),
            new Rule("Commerce", "Business & Finance", "B.Com", "BBA", "Commerce"),
            new Rule("*", "Teaching", "Elementary Education", "English", "Mathematics"),
            new Rule("*", "Law & Civil Services", "LL.B", "History", "Political"),
            new Rule("*", "Mechanical & Design", "Mechanical"),
            new Rule("*", "Construction", "Civil"),
            new Rule("*", "Languages & Writing", "English", "Tamil"),
            new Rule("*", "Science & Research", "Physics", "Chemistry", "Mathematics"));

    private final CourseDAO courseDAO = new CourseDAO();
    private final ExamDAO examDAO = new ExamDAO();

    /** Builds the complete recommendation for a student profile (saved profile OR roadmap form input). */
    public RoadmapResult build(Student profile) {
        RoadmapResult result = new RoadmapResult();
        List<String> interests = splitInterests(profile.getInterests());
        String preferred = profile.getPreferredCareer() == null ? "" : profile.getPreferredCareer().trim().toLowerCase(Locale.ROOT);

        List<ScoredCourse> scored = new ArrayList<>();
        for (Course c : courseDAO.findAll()) {
            if (!acceptsGroup(c, profile.getGroup12())) continue;
            int score = 1;
            List<String> why = new ArrayList<>();
            why.add("Open to " + profile.getGroup12() + " students");
            for (String i : interests) {
                if (containsIgnoreCase(c.getInterestTags(), i)) { score += 2; why.add("matches your interest in " + i); }
            }
            if (!preferred.isEmpty() && matchesPreferred(c, preferred)) { score += 3; why.add("relates to your preferred career"); }
            for (Rule r : RULES) {
                boolean groupOk = r.group().equals("*") || r.group().equalsIgnoreCase(profile.getGroup12());
                if (groupOk && interests.contains(r.interest()) && nameHasAny(c, r.courseKeywords())) { score += 4; why.add("recommended for " + r.interest()); break; }
            }
            String fit;
            if (c.getMinMarks() > profile.getMarks()) { score -= 2; fit = "Stretch - usually needs about " + (int) c.getMinMarks() + "%+"; }
            else fit = score >= 6 ? "Strong match" : "Good match";
            if (score > 0) scored.add(new ScoredCourse(c, score, String.join("; ", why), fit));
        }
        scored.sort(Comparator.comparingInt(ScoredCourse::getScore).reversed().thenComparing(sc -> sc.getCourse().getName()));
        result.getCourses().addAll(scored.size() > 8 ? scored.subList(0, 8) : scored);

        buildExams(profile, interests, result);
        buildSteps(profile, result);
        return result;
    }

    private void buildExams(Student p, List<String> interests, RoadmapResult result) {
        int age = ageOf(p.getDob());
        boolean govtInterest = interests.contains("Government Jobs") || interests.contains("Law & Civil Services");
        boolean wantsGovt = !"Private".equalsIgnoreCase(p.getSectorPreference());
        List<GovernmentExam> eligible = new ArrayList<>();
        List<GovernmentExam> future = new ArrayList<>();
        for (GovernmentExam e : examDAO.findAll()) {
            if (e.getQualificationRank() <= 12) {
                boolean ageOk = age <= 0 || (age >= e.getMinAge() && (e.getMaxAge() == 0 || age <= e.getMaxAge()));
                if (ageOk) eligible.add(e);
            } else future.add(e);
        }
        // Interest-matching exams first; if the student prefers private jobs we still list them, just not prioritised.
        Comparator<GovernmentExam> byInterest = Comparator.comparingInt((GovernmentExam e) -> {
            int s = 0;
            for (String i : interests) if (containsIgnoreCase(e.getInterestTags(), i)) s += 2;
            if (govtInterest) s += 1;
            return -s;
        }).thenComparing(GovernmentExam::getName);
        eligible.sort(byInterest);
        future.sort(byInterest);
        if (wantsGovt || govtInterest) result.getEligibleExams().addAll(eligible);
        else result.getEligibleExams().addAll(eligible.size() > 3 ? eligible.subList(0, 3) : eligible);
        result.getFutureExams().addAll(future.size() > 4 ? future.subList(0, 4) : future);
    }

    private void buildSteps(Student p, RoadmapResult result) {
        result.getSteps().add(new Step("12th Standard", p.getGroup12() + " - " + trimMarks(p.getMarks()) + "%", "fa-school"));
        if (result.getCourses().isEmpty()) {
            result.getSteps().add(new Step("Explore Courses", "No exact match found - browse all courses or try different interests.", "fa-compass"));
            return;
        }
        Course top = result.getCourses().get(0).getCourse();
        result.setTopCourseName(top.getName());
        result.getSteps().add(new Step(top.getName(), top.getDuration() + " | " + top.getCategoryName(), "fa-graduation-cap"));
        result.getSteps().add(new Step("Build Skills", firstItems(top.getSkills(), 4), "fa-laptop-code"));
        result.getSteps().add(new Step("Internship & Projects", "Do at least one internship and 2-3 real projects related to " + top.getCareerField() + ".", "fa-briefcase"));
        result.getSteps().add(new Step("Start Your Career", firstItems(top.getJobOpportunities().isBlank() ? top.getCareerOpportunities() : top.getJobOpportunities(), 3), "fa-user-tie"));
        boolean govt = !"Private".equalsIgnoreCase(p.getSectorPreference());
        if (govt) {
            StringBuilder names = new StringBuilder();
            for (GovernmentExam e : result.getFutureExams()) { if (names.length() > 0) names.append(", "); names.append(e.getName()); }
            String detail = names.length() > 0 ? names.toString() : top.getGovernmentOpportunities();
            result.getSteps().add(new Step("Government Exams", "After your degree consider: " + detail, "fa-landmark"));
        }
        result.getSteps().add(new Step("Higher Studies", top.getHigherStudies(), "fa-book-open-reader"));
    }

    // ------------------------------------------------------------------ helpers
    private static boolean acceptsGroup(Course c, String group) {
        String req = c.getRequiredGroups();
        return req == null || req.equalsIgnoreCase("Any") || containsIgnoreCase(req, group);
    }
    private static boolean nameHasAny(Course c, String[] keys) {
        for (String k : keys) if (containsIgnoreCase(c.getName(), k)) return true;
        return false;
    }
    private static boolean matchesPreferred(Course c, String preferred) {
        for (String word : preferred.split("[^a-z0-9+#]+")) {
            if (word.length() < 3) continue;
            if (containsIgnoreCase(c.getName(), word) || containsIgnoreCase(c.getCareerField(), word)
                    || containsIgnoreCase(c.getCareerOpportunities(), word) || containsIgnoreCase(c.getSkills(), word)) return true;
        }
        return false;
    }
    private static boolean containsIgnoreCase(String text, String part) {
        return text != null && part != null && !part.isBlank() && text.toLowerCase(Locale.ROOT).contains(part.toLowerCase(Locale.ROOT));
    }
    static List<String> splitInterests(String csv) {
        List<String> out = new ArrayList<>();
        if (csv != null) for (String s : csv.split(",")) if (!s.isBlank()) out.add(s.trim());
        return out;
    }
    private static String firstItems(String csv, int n) {
        if (csv == null || csv.isBlank()) return "-";
        String[] parts = csv.split(",");
        return String.join(", ", Arrays.stream(parts).map(String::trim).limit(n).toList());
    }
    private static String trimMarks(double m) { return m == Math.rint(m) ? String.valueOf((int) m) : String.valueOf(m); }

    /** Age in completed years (0 when the date of birth is unknown). */
    public static int ageOf(Date dob) {
        if (dob == null) return 0;
        Calendar b = Calendar.getInstance(); b.setTime(dob);
        Calendar n = Calendar.getInstance();
        int age = n.get(Calendar.YEAR) - b.get(Calendar.YEAR);
        if (n.get(Calendar.DAY_OF_YEAR) < b.get(Calendar.DAY_OF_YEAR)) age--;
        return age;
    }
}

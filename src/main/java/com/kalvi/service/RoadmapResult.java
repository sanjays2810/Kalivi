package com.kalvi.service;

import com.kalvi.model.Course;
import com.kalvi.model.GovernmentExam;
import java.util.ArrayList;
import java.util.List;

/** Output of the recommendation engine: ranked courses, exams and the step-by-step roadmap. */
public class RoadmapResult {

    /** A course together with its score and the human-readable reasons. */
    public static class ScoredCourse {
        private final Course course;
        private final int score;
        private final String reason;
        private final String fit;       // "Strong match", "Good match" or "Stretch (needs higher marks)"
        public ScoredCourse(Course course, int score, String reason, String fit) {
            this.course = course; this.score = score; this.reason = reason; this.fit = fit;
        }
        public Course getCourse() { return course; }
        public int getScore() { return score; }
        public String getReason() { return reason; }
        public String getFit() { return fit; }
    }

    /** One stage of the roadmap timeline. */
    public static class Step {
        private final String title;
        private final String detail;
        private final String icon;     // Font Awesome class
        public Step(String title, String detail, String icon) { this.title = title; this.detail = detail; this.icon = icon; }
        public String getTitle() { return title; }
        public String getDetail() { return detail; }
        public String getIcon() { return icon; }
    }

    private final List<ScoredCourse> courses = new ArrayList<>();
    private final List<GovernmentExam> eligibleExams = new ArrayList<>();
    private final List<GovernmentExam> futureExams = new ArrayList<>();
    private final List<Step> steps = new ArrayList<>();
    private String topCourseName = "";

    public List<ScoredCourse> getCourses() { return courses; }
    public List<GovernmentExam> getEligibleExams() { return eligibleExams; }
    public List<GovernmentExam> getFutureExams() { return futureExams; }
    public List<Step> getSteps() { return steps; }
    public String getTopCourseName() { return topCourseName; }
    public void setTopCourseName(String n) { this.topCourseName = n; }

    /** Serialises the steps as "Title::Detail|Title::Detail" for storing in career_recommendations. */
    public String stepsAsText() {
        StringBuilder sb = new StringBuilder();
        for (Step s : steps) {
            if (sb.length() > 0) sb.append('|');
            sb.append(s.getTitle().replace("|", "/").replace("::", ":")).append("::")
              .append(s.getDetail().replace("|", "/").replace("::", ":"));
        }
        return sb.toString();
    }
}

package com.kalvi.model;

import java.util.Date;

/** JavaBean for the CareerRecommendation entity. */
public class CareerRecommendation implements java.io.Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private int studentId;
    private String preferredCareer;
    private String topCourse;
    private String roadmapSteps;
    private Date createdAt;

    public CareerRecommendation() {}
    public CareerRecommendation(int id, int studentId, String preferredCareer, String topCourse, String roadmapSteps, Date createdAt) {
        this.id = id;
        this.studentId = studentId;
        this.preferredCareer = preferredCareer;
        this.topCourse = topCourse;
        this.roadmapSteps = roadmapSteps;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }
    public String getPreferredCareer() { return preferredCareer; }
    public void setPreferredCareer(String preferredCareer) { this.preferredCareer = preferredCareer; }
    public String getTopCourse() { return topCourse; }
    public void setTopCourse(String topCourse) { this.topCourse = topCourse; }
    public String getRoadmapSteps() { return roadmapSteps; }
    public void setRoadmapSteps(String roadmapSteps) { this.roadmapSteps = roadmapSteps; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}

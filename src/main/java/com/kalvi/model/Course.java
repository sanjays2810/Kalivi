package com.kalvi.model;

import java.util.Date;

/** JavaBean for the Course entity. */
public class Course implements java.io.Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private String name;
    private int categoryId;
    private String categoryName;
    private String duration;
    private String eligibility;
    private String requiredGroups;
    private String admissionRequirements;
    private String careerOpportunities;
    private String higherStudies;
    private String jobOpportunities;
    private String governmentOpportunities;
    private String skills;
    private String description;
    private String careerField;
    private String interestTags;
    private double minMarks;
    private boolean demo;
    private Date lastUpdated;

    public Course() {}
    public Course(int id, String name, int categoryId, String categoryName, String duration, String eligibility, String requiredGroups, String admissionRequirements, String careerOpportunities, String higherStudies, String jobOpportunities, String governmentOpportunities, String skills, String description, String careerField, String interestTags, double minMarks, boolean demo, Date lastUpdated) {
        this.id = id;
        this.name = name;
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.duration = duration;
        this.eligibility = eligibility;
        this.requiredGroups = requiredGroups;
        this.admissionRequirements = admissionRequirements;
        this.careerOpportunities = careerOpportunities;
        this.higherStudies = higherStudies;
        this.jobOpportunities = jobOpportunities;
        this.governmentOpportunities = governmentOpportunities;
        this.skills = skills;
        this.description = description;
        this.careerField = careerField;
        this.interestTags = interestTags;
        this.minMarks = minMarks;
        this.demo = demo;
        this.lastUpdated = lastUpdated;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }
    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
    public String getDuration() { return duration; }
    public void setDuration(String duration) { this.duration = duration; }
    public String getEligibility() { return eligibility; }
    public void setEligibility(String eligibility) { this.eligibility = eligibility; }
    public String getRequiredGroups() { return requiredGroups; }
    public void setRequiredGroups(String requiredGroups) { this.requiredGroups = requiredGroups; }
    public String getAdmissionRequirements() { return admissionRequirements; }
    public void setAdmissionRequirements(String admissionRequirements) { this.admissionRequirements = admissionRequirements; }
    public String getCareerOpportunities() { return careerOpportunities; }
    public void setCareerOpportunities(String careerOpportunities) { this.careerOpportunities = careerOpportunities; }
    public String getHigherStudies() { return higherStudies; }
    public void setHigherStudies(String higherStudies) { this.higherStudies = higherStudies; }
    public String getJobOpportunities() { return jobOpportunities; }
    public void setJobOpportunities(String jobOpportunities) { this.jobOpportunities = jobOpportunities; }
    public String getGovernmentOpportunities() { return governmentOpportunities; }
    public void setGovernmentOpportunities(String governmentOpportunities) { this.governmentOpportunities = governmentOpportunities; }
    public String getSkills() { return skills; }
    public void setSkills(String skills) { this.skills = skills; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getCareerField() { return careerField; }
    public void setCareerField(String careerField) { this.careerField = careerField; }
    public String getInterestTags() { return interestTags; }
    public void setInterestTags(String interestTags) { this.interestTags = interestTags; }
    public double getMinMarks() { return minMarks; }
    public void setMinMarks(double minMarks) { this.minMarks = minMarks; }
    public boolean isDemo() { return demo; }
    public void setDemo(boolean demo) { this.demo = demo; }
    public Date getLastUpdated() { return lastUpdated; }
    public void setLastUpdated(Date lastUpdated) { this.lastUpdated = lastUpdated; }
}

package com.kalvi.model;

import java.util.Date;

/** JavaBean for the GovernmentExam entity. */
public class GovernmentExam implements java.io.Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private String name;
    private String department;
    private String category;
    private String qualification;
    private int qualificationRank;
    private int minAge;
    private int maxAge;
    private String eligibility;
    private String ageLimit;
    private String applicationProcess;
    private String registrationInfo;
    private String examPattern;
    private String syllabus;
    private String selectionProcess;
    private String instructions;
    private String officialUrl;
    private String interestTags;
    private boolean demo;
    private Date lastUpdated;

    public GovernmentExam() {}
    public GovernmentExam(int id, String name, String department, String category, String qualification, int qualificationRank, int minAge, int maxAge, String eligibility, String ageLimit, String applicationProcess, String registrationInfo, String examPattern, String syllabus, String selectionProcess, String instructions, String officialUrl, String interestTags, boolean demo, Date lastUpdated) {
        this.id = id;
        this.name = name;
        this.department = department;
        this.category = category;
        this.qualification = qualification;
        this.qualificationRank = qualificationRank;
        this.minAge = minAge;
        this.maxAge = maxAge;
        this.eligibility = eligibility;
        this.ageLimit = ageLimit;
        this.applicationProcess = applicationProcess;
        this.registrationInfo = registrationInfo;
        this.examPattern = examPattern;
        this.syllabus = syllabus;
        this.selectionProcess = selectionProcess;
        this.instructions = instructions;
        this.officialUrl = officialUrl;
        this.interestTags = interestTags;
        this.demo = demo;
        this.lastUpdated = lastUpdated;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public String getQualification() { return qualification; }
    public void setQualification(String qualification) { this.qualification = qualification; }
    public int getQualificationRank() { return qualificationRank; }
    public void setQualificationRank(int qualificationRank) { this.qualificationRank = qualificationRank; }
    public int getMinAge() { return minAge; }
    public void setMinAge(int minAge) { this.minAge = minAge; }
    public int getMaxAge() { return maxAge; }
    public void setMaxAge(int maxAge) { this.maxAge = maxAge; }
    public String getEligibility() { return eligibility; }
    public void setEligibility(String eligibility) { this.eligibility = eligibility; }
    public String getAgeLimit() { return ageLimit; }
    public void setAgeLimit(String ageLimit) { this.ageLimit = ageLimit; }
    public String getApplicationProcess() { return applicationProcess; }
    public void setApplicationProcess(String applicationProcess) { this.applicationProcess = applicationProcess; }
    public String getRegistrationInfo() { return registrationInfo; }
    public void setRegistrationInfo(String registrationInfo) { this.registrationInfo = registrationInfo; }
    public String getExamPattern() { return examPattern; }
    public void setExamPattern(String examPattern) { this.examPattern = examPattern; }
    public String getSyllabus() { return syllabus; }
    public void setSyllabus(String syllabus) { this.syllabus = syllabus; }
    public String getSelectionProcess() { return selectionProcess; }
    public void setSelectionProcess(String selectionProcess) { this.selectionProcess = selectionProcess; }
    public String getInstructions() { return instructions; }
    public void setInstructions(String instructions) { this.instructions = instructions; }
    public String getOfficialUrl() { return officialUrl; }
    public void setOfficialUrl(String officialUrl) { this.officialUrl = officialUrl; }
    public String getInterestTags() { return interestTags; }
    public void setInterestTags(String interestTags) { this.interestTags = interestTags; }
    public boolean isDemo() { return demo; }
    public void setDemo(boolean demo) { this.demo = demo; }
    public Date getLastUpdated() { return lastUpdated; }
    public void setLastUpdated(Date lastUpdated) { this.lastUpdated = lastUpdated; }
}

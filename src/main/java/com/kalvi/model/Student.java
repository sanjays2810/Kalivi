package com.kalvi.model;

import java.util.Date;

/** JavaBean for the Student entity. */
public class Student implements java.io.Serializable {
    private static final long serialVersionUID = 1L;
    private int userId;
    private String fullName;
    private String email;
    private String mobile;
    private Date dob;
    private String gender;
    private String district;
    private String group12;
    private double marks;
    private String interests;
    private String preferredCareer;
    private String sectorPreference;

    public Student() {}
    public Student(int userId, String fullName, String email, String mobile, Date dob, String gender, String district, String group12, double marks, String interests, String preferredCareer, String sectorPreference) {
        this.userId = userId;
        this.fullName = fullName;
        this.email = email;
        this.mobile = mobile;
        this.dob = dob;
        this.gender = gender;
        this.district = district;
        this.group12 = group12;
        this.marks = marks;
        this.interests = interests;
        this.preferredCareer = preferredCareer;
        this.sectorPreference = sectorPreference;
    }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getMobile() { return mobile; }
    public void setMobile(String mobile) { this.mobile = mobile; }
    public Date getDob() { return dob; }
    public void setDob(Date dob) { this.dob = dob; }
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    public String getDistrict() { return district; }
    public void setDistrict(String district) { this.district = district; }
    public String getGroup12() { return group12; }
    public void setGroup12(String group12) { this.group12 = group12; }
    public double getMarks() { return marks; }
    public void setMarks(double marks) { this.marks = marks; }
    public String getInterests() { return interests; }
    public void setInterests(String interests) { this.interests = interests; }
    public String getPreferredCareer() { return preferredCareer; }
    public void setPreferredCareer(String preferredCareer) { this.preferredCareer = preferredCareer; }
    public String getSectorPreference() { return sectorPreference; }
    public void setSectorPreference(String sectorPreference) { this.sectorPreference = sectorPreference; }
}

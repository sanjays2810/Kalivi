package com.kalvi.model;

/** JavaBean for the ExamCenter entity. */
public class ExamCenter implements java.io.Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private int examId;
    private String district;
    private String centerName;
    private String address;

    public ExamCenter() {}
    public ExamCenter(int id, int examId, String district, String centerName, String address) {
        this.id = id;
        this.examId = examId;
        this.district = district;
        this.centerName = centerName;
        this.address = address;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getExamId() { return examId; }
    public void setExamId(int examId) { this.examId = examId; }
    public String getDistrict() { return district; }
    public void setDistrict(String district) { this.district = district; }
    public String getCenterName() { return centerName; }
    public void setCenterName(String centerName) { this.centerName = centerName; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
}

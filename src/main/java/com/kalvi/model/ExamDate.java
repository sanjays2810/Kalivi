package com.kalvi.model;

import java.util.Date;

/** JavaBean for the ExamDate entity. */
public class ExamDate implements java.io.Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private int examId;
    private String examName;
    private String eventName;
    private Date eventDate;
    private boolean official;

    public ExamDate() {}
    public ExamDate(int id, int examId, String examName, String eventName, Date eventDate, boolean official) {
        this.id = id;
        this.examId = examId;
        this.examName = examName;
        this.eventName = eventName;
        this.eventDate = eventDate;
        this.official = official;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getExamId() { return examId; }
    public void setExamId(int examId) { this.examId = examId; }
    public String getExamName() { return examName; }
    public void setExamName(String examName) { this.examName = examName; }
    public String getEventName() { return eventName; }
    public void setEventName(String eventName) { this.eventName = eventName; }
    public Date getEventDate() { return eventDate; }
    public void setEventDate(Date eventDate) { this.eventDate = eventDate; }
    public boolean isOfficial() { return official; }
    public void setOfficial(boolean official) { this.official = official; }
}

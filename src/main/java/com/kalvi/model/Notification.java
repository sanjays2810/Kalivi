package com.kalvi.model;

import java.util.Date;

/** JavaBean for the Notification entity. */
public class Notification implements java.io.Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private String title;
    private String message;
    private boolean demo;
    private Date createdAt;

    public Notification() {}
    public Notification(int id, String title, String message, boolean demo, Date createdAt) {
        this.id = id;
        this.title = title;
        this.message = message;
        this.demo = demo;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public boolean isDemo() { return demo; }
    public void setDemo(boolean demo) { this.demo = demo; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}

package com.kalvi.model;

import java.util.Date;

/** JavaBean for the Resource entity. */
public class Resource implements java.io.Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private String title;
    private String description;
    private String category;
    private String link;
    private Date dateAdded;

    public Resource() {}
    public Resource(int id, String title, String description, String category, String link, Date dateAdded) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.category = category;
        this.link = link;
        this.dateAdded = dateAdded;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public String getLink() { return link; }
    public void setLink(String link) { this.link = link; }
    public Date getDateAdded() { return dateAdded; }
    public void setDateAdded(Date dateAdded) { this.dateAdded = dateAdded; }
}

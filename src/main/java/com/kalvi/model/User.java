package com.kalvi.model;

import java.util.Date;

/** JavaBean for the User entity. */
public class User implements java.io.Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private String fullName;
    private String email;
    private String passwordHash;
    private String role;
    private Date createdAt;

    public User() {}
    public User(int id, String fullName, String email, String passwordHash, String role, Date createdAt) {
        this.id = id;
        this.fullName = fullName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.role = role;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}

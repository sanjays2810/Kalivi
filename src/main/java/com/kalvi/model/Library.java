package com.kalvi.model;

/** JavaBean for the Library entity. */
public class Library implements java.io.Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private String name;
    private String district;
    private String location;
    private String address;
    private String contact;
    private String facilities;
    private String openingHours;
    private boolean demo;

    public Library() {}
    public Library(int id, String name, String district, String location, String address, String contact, String facilities, String openingHours, boolean demo) {
        this.id = id;
        this.name = name;
        this.district = district;
        this.location = location;
        this.address = address;
        this.contact = contact;
        this.facilities = facilities;
        this.openingHours = openingHours;
        this.demo = demo;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDistrict() { return district; }
    public void setDistrict(String district) { this.district = district; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getContact() { return contact; }
    public void setContact(String contact) { this.contact = contact; }
    public String getFacilities() { return facilities; }
    public void setFacilities(String facilities) { this.facilities = facilities; }
    public String getOpeningHours() { return openingHours; }
    public void setOpeningHours(String openingHours) { this.openingHours = openingHours; }
    public boolean isDemo() { return demo; }
    public void setDemo(boolean demo) { this.demo = demo; }
}

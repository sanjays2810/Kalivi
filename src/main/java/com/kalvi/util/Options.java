package com.kalvi.util;

import java.util.List;

/** Fixed drop-down / checkbox values used across forms (published to JSPs by AppInitializer). */
public final class Options {
    private Options() {}
    public static final List<String> GROUPS = List.of("Computer Science", "Bio-Maths", "Biology", "Commerce",
            "Computer Applications", "Arts", "Vocational", "Other");
    public static final List<String> INTERESTS = List.of("Programming", "Data & AI", "Electronics", "Mechanical & Design",
            "Construction", "Healthcare", "Business & Finance", "Teaching", "Law & Civil Services", "Government Jobs",
            "Languages & Writing", "Science & Research", "Creative Arts");
    public static final List<String> SECTORS = List.of("Government", "Private", "Both");
    public static final List<String> GENDERS = List.of("Male", "Female", "Other");
    public static final List<String> RESOURCE_CATEGORIES = List.of("Study Materials", "Government Websites", "Exam Syllabus",
            "Previous Question Papers", "Career Resources", "Scholarships", "Useful Links");
    public static final List<String> QUALIFICATIONS = List.of("10th", "12th", "Diploma", "Degree");
    public static final List<String> DISTRICTS = List.of("Ariyalur", "Chengalpattu", "Chennai", "Coimbatore", "Cuddalore",
            "Dharmapuri", "Dindigul", "Erode", "Kallakurichi", "Kancheepuram", "Kanniyakumari", "Karur", "Krishnagiri",
            "Madurai", "Mayiladuthurai", "Nagapattinam", "Namakkal", "Nilgiris", "Perambalur", "Pudukkottai", "Ramanathapuram",
            "Ranipet", "Salem", "Sivagangai", "Tenkasi", "Thanjavur", "Theni", "Thoothukudi", "Tiruchirappalli", "Tirunelveli",
            "Tirupathur", "Tiruppur", "Tiruvallur", "Tiruvannamalai", "Tiruvarur", "Vellore", "Viluppuram", "Virudhunagar");
}

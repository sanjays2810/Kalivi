package com.kalvi.controller;

import com.kalvi.model.Student;
import com.kalvi.util.Options;
import com.kalvi.util.ValidationUtil;
import jakarta.servlet.http.HttpServletRequest;
import java.time.LocalDate;
import java.time.Period;
import java.util.ArrayList;
import java.util.List;

/** Reads and validates the student profile fields shared by registration and profile pages. */
final class StudentForm {
    private StudentForm() {}

    static Student read(HttpServletRequest req) {
        Student s = new Student();
        s.setFullName(ValidationUtil.trim(req.getParameter("fullName")));
        s.setEmail(ValidationUtil.trim(req.getParameter("email")));
        s.setMobile(ValidationUtil.trim(req.getParameter("mobile")));
        s.setGender(ValidationUtil.trim(req.getParameter("gender")));
        s.setDistrict(ValidationUtil.trim(req.getParameter("district")));
        s.setGroup12(ValidationUtil.trim(req.getParameter("group12")));
        s.setMarks(ValidationUtil.toDouble(req.getParameter("marks"), -1));
        String[] interests = req.getParameterValues("interests");
        s.setInterests(interests == null ? "" : String.join(",", interests));
        s.setPreferredCareer(ValidationUtil.trim(req.getParameter("preferredCareer")));
        s.setSectorPreference(ValidationUtil.trim(req.getParameter("sectorPreference")));
        try {
            s.setDob(java.sql.Date.valueOf(LocalDate.parse(req.getParameter("dob"))));
        } catch (Exception e) { s.setDob(null); }
        return s;
    }

    static List<String> validate(Student s) {
        List<String> err = new ArrayList<>();
        if (s.getFullName().length() < 3 || s.getFullName().length() > 100) err.add("Full name must be 3-100 characters.");
        if (!ValidationUtil.isMobile(s.getMobile())) err.add("Enter a valid 10-digit Indian mobile number.");
        if (s.getDob() == null) err.add("Enter a valid date of birth.");
        else {
            int age = Period.between(((java.sql.Date) s.getDob()).toLocalDate(), LocalDate.now()).getYears();
            if (age < 14 || age > 60) err.add("Date of birth looks incorrect (age must be 14-60).");
        }
        if (!Options.GENDERS.contains(s.getGender())) err.add("Select a gender.");
        if (!Options.DISTRICTS.contains(s.getDistrict())) err.add("Select your district.");
        if (!Options.GROUPS.contains(s.getGroup12())) err.add("Select your 12th group.");
        if (s.getMarks() < 0 || s.getMarks() > 100) err.add("12th marks must be a percentage between 0 and 100.");
        if (!Options.SECTORS.contains(s.getSectorPreference())) s.setSectorPreference("Both");
        for (String i : s.getInterests().split(",")) if (!i.isEmpty() && !Options.INTERESTS.contains(i)) err.add("Invalid interest selected.");
        return err;
    }
}

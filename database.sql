-- ============================================================================
--  KALVI - Career Guidance Platform        database.sql
--  Run:  mysql -u root -p < database.sql
--  ALL sample rows are DEMO DATA (is_demo = 1). They are NOT official government information.
--  The demo admin account (admin@kalvi.demo / Admin@123) is created with a BCrypt hash
--  automatically by the application at first start (see AppInitializer.java).
-- ============================================================================
CREATE DATABASE IF NOT EXISTS kalvi_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE kalvi_db;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS career_recommendations, saved_exams, saved_courses, notifications, exam_centers, exam_dates,
    government_exams, courses, course_categories, resources, libraries, admins, students, users;
SET FOREIGN_KEY_CHECKS = 1;

-- ------------------------------------------------------------------ accounts
CREATE TABLE users (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    full_name     VARCHAR(100) NOT NULL,
    email         VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(100) NOT NULL,             -- BCrypt hash, never plain text
    role          ENUM('STUDENT','ADMIN') NOT NULL DEFAULT 'STUDENT',
    created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_users_role (role)
) ENGINE=InnoDB;

CREATE TABLE students (
    user_id           INT PRIMARY KEY,
    mobile            VARCHAR(15)  NOT NULL,
    dob               DATE         NOT NULL,
    gender            VARCHAR(10)  NOT NULL,
    district          VARCHAR(50)  NOT NULL,
    group_12          VARCHAR(40)  NOT NULL,
    marks             DECIMAL(5,2) NOT NULL,
    interests         VARCHAR(500) NOT NULL DEFAULT '',
    preferred_career  VARCHAR(150) NOT NULL DEFAULT '',
    sector_preference VARCHAR(15)  NOT NULL DEFAULT 'Both',
    CONSTRAINT fk_students_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_students_group (group_12), INDEX idx_students_district (district)
) ENGINE=InnoDB;

CREATE TABLE admins (
    user_id     INT PRIMARY KEY,
    designation VARCHAR(80) NOT NULL DEFAULT 'Administrator',
    CONSTRAINT fk_admins_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ------------------------------------------------------------------ courses
CREATE TABLE course_categories (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(60) NOT NULL UNIQUE,
    description VARCHAR(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB;

CREATE TABLE courses (
    id                       INT AUTO_INCREMENT PRIMARY KEY,
    name                     VARCHAR(150) NOT NULL,
    category_id              INT NOT NULL,
    duration                 VARCHAR(30)  NOT NULL,
    eligibility              VARCHAR(255) NOT NULL DEFAULT '',
    required_groups          VARCHAR(255) NOT NULL,            -- comma list of 12th groups, or 'Any'
    admission_requirements   VARCHAR(500) NOT NULL DEFAULT '',
    career_opportunities     VARCHAR(500) NOT NULL DEFAULT '', -- comma separated
    higher_studies           VARCHAR(500) NOT NULL DEFAULT '',
    job_opportunities        VARCHAR(500) NOT NULL DEFAULT '',
    government_opportunities VARCHAR(500) NOT NULL DEFAULT '',
    skills                   VARCHAR(500) NOT NULL DEFAULT '',
    description              TEXT,
    career_field             VARCHAR(60)  NOT NULL DEFAULT '',
    interest_tags            VARCHAR(255) NOT NULL DEFAULT '',
    min_marks                DECIMAL(5,2) NOT NULL DEFAULT 0,  -- approximate marks that usually help for admission
    is_demo                  TINYINT(1)   NOT NULL DEFAULT 1,
    last_updated             TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_courses_category FOREIGN KEY (category_id) REFERENCES course_categories(id),
    INDEX idx_courses_name (name), INDEX idx_courses_category (category_id), INDEX idx_courses_field (career_field)
) ENGINE=InnoDB;

-- ------------------------------------------------------------------ government exams
CREATE TABLE government_exams (
    id                 INT AUTO_INCREMENT PRIMARY KEY,
    name               VARCHAR(150) NOT NULL,
    department         VARCHAR(150) NOT NULL,
    category           VARCHAR(60)  NOT NULL,                  -- e.g. State Services, Teaching, Defence
    qualification      VARCHAR(20)  NOT NULL,                  -- 10th / 12th / Diploma / Degree
    qualification_rank INT NOT NULL,                           -- 10, 12 or 15 (degree) - used for eligibility checks
    min_age            INT NOT NULL DEFAULT 0,
    max_age            INT NOT NULL DEFAULT 0,                 -- 0 = no upper limit
    eligibility        TEXT,
    age_limit          VARCHAR(255) NOT NULL DEFAULT '',
    application_process TEXT,
    registration_info  TEXT,
    exam_pattern       TEXT,
    syllabus           TEXT,
    selection_process  TEXT,
    instructions       TEXT,
    official_url       VARCHAR(255) NOT NULL DEFAULT '',       -- OFFICIAL SOURCE
    interest_tags      VARCHAR(255) NOT NULL DEFAULT '',
    is_demo            TINYINT(1)   NOT NULL DEFAULT 1,        -- 1 = sample data, 0 = verified by an admin
    last_updated       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_exams_category (category), INDEX idx_exams_rank (qualification_rank)
) ENGINE=InnoDB;

CREATE TABLE exam_dates (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    exam_id     INT NOT NULL,
    event_name  VARCHAR(120) NOT NULL,
    event_date  DATE NOT NULL,
    is_official TINYINT(1) NOT NULL DEFAULT 0,                 -- 0 = placeholder / demo date
    CONSTRAINT fk_dates_exam FOREIGN KEY (exam_id) REFERENCES government_exams(id) ON DELETE CASCADE,
    INDEX idx_dates_date (event_date)
) ENGINE=InnoDB;

CREATE TABLE exam_centers (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    exam_id     INT NOT NULL,
    district    VARCHAR(50)  NOT NULL,
    center_name VARCHAR(150) NOT NULL,
    address     VARCHAR(255) NOT NULL DEFAULT '',
    CONSTRAINT fk_centers_exam FOREIGN KEY (exam_id) REFERENCES government_exams(id) ON DELETE CASCADE,
    INDEX idx_centers_district (district)
) ENGINE=InnoDB;

-- ------------------------------------------------------------------ resources, libraries, notifications
CREATE TABLE resources (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    title       VARCHAR(150) NOT NULL,
    description VARCHAR(500) NOT NULL DEFAULT '',
    category    VARCHAR(40)  NOT NULL,
    link        VARCHAR(255) NOT NULL,
    date_added  DATE NOT NULL,
    INDEX idx_resources_category (category)
) ENGINE=InnoDB;

CREATE TABLE libraries (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    name          VARCHAR(150) NOT NULL,
    district      VARCHAR(50)  NOT NULL,
    location      VARCHAR(100) NOT NULL DEFAULT '',
    address       VARCHAR(255) NOT NULL,
    contact       VARCHAR(100) NOT NULL DEFAULT '',
    facilities    VARCHAR(255) NOT NULL DEFAULT '',
    opening_hours VARCHAR(100) NOT NULL DEFAULT '',
    is_demo       TINYINT(1)   NOT NULL DEFAULT 1,
    INDEX idx_libraries_district (district)
) ENGINE=InnoDB;

CREATE TABLE notifications (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    title      VARCHAR(150) NOT NULL,
    message    VARCHAR(500) NOT NULL,
    is_demo    TINYINT(1) NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ------------------------------------------------------------------ student relations
CREATE TABLE saved_courses (
    student_id INT NOT NULL,
    course_id  INT NOT NULL,
    saved_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (student_id, course_id),
    CONSTRAINT fk_sc_student FOREIGN KEY (student_id) REFERENCES students(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_sc_course  FOREIGN KEY (course_id)  REFERENCES courses(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE saved_exams (
    student_id INT NOT NULL,
    exam_id    INT NOT NULL,
    saved_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (student_id, exam_id),
    CONSTRAINT fk_se_student FOREIGN KEY (student_id) REFERENCES students(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_se_exam    FOREIGN KEY (exam_id)    REFERENCES government_exams(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE career_recommendations (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    student_id       INT NOT NULL,
    preferred_career VARCHAR(150) NOT NULL DEFAULT '',
    top_course       VARCHAR(150) NOT NULL DEFAULT '',
    roadmap_steps    TEXT NOT NULL,                              -- "Title::Detail|Title::Detail|..."
    created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_cr_student FOREIGN KEY (student_id) REFERENCES students(user_id) ON DELETE CASCADE,
    INDEX idx_cr_student (student_id)
) ENGINE=InnoDB;

-- ============================================================================
--  DEMO DATA  (sample information only - verify everything on the official websites)
-- ============================================================================
INSERT INTO course_categories(name, description) VALUES
 ('Engineering', 'B.E / B.Tech degree programmes'),
 ('Arts & Science', 'Undergraduate degrees in science, computer, commerce and arts'),
 ('Diploma', 'Polytechnic and teacher-education diplomas'),
 ('Health Sciences', 'Nursing, pharmacy and allied health'),
 ('Law', 'Integrated law degrees');

-- columns: name, category, duration, eligibility, required_groups, admission, careers, higher, jobs, govt, skills, description, field, interests, min_marks
INSERT INTO courses(name,category_id,duration,eligibility,required_groups,admission_requirements,career_opportunities,higher_studies,job_opportunities,government_opportunities,skills,description,career_field,interest_tags,min_marks) VALUES
('B.Tech Information Technology',1,'4 Years','12th pass with Maths','Computer Science,Bio-Maths,Computer Applications','Counselling based on cut-off marks (demo information)','Software Developer,Data Analyst,Cloud Engineer,Web Developer','M.Tech,MBA,MS Abroad','IT companies,Startups,Product companies','Technical posts in PSUs and government IT departments','Java,SQL,Web Development,Problem Solving','Study of software, databases, networks and web technologies.','Information Technology','Programming,Data & AI,Government Jobs',70),
('B.E Computer Science and Engineering',1,'4 Years','12th pass with Maths','Computer Science,Bio-Maths,Computer Applications','Counselling based on cut-off marks (demo information)','Software Engineer,Full-Stack Developer,Cybersecurity Analyst,DevOps Engineer','M.E,MBA,MS Abroad','Software companies,Banks (IT),Startups','Scientist/Engineer posts in research organisations','Programming,Data Structures,Databases,Networking','Core computer science covering algorithms, systems and software engineering.','Information Technology','Programming,Data & AI',75),
('B.E Artificial Intelligence and Machine Learning',1,'4 Years','12th pass with Maths','Computer Science,Bio-Maths','Counselling based on cut-off marks (demo information)','ML Engineer,Data Scientist,AI Developer,Research Assistant','M.Tech AI,MS Data Science,PhD','AI startups,Analytics firms,Product companies','Research roles in government labs','Python,Statistics,Machine Learning,Maths','Learn to build intelligent systems using data and algorithms.','Data & AI','Data & AI,Programming,Science & Research',78),
('B.E Electronics and Communication Engineering',1,'4 Years','12th pass with Physics, Chemistry, Maths','Computer Science,Bio-Maths','Counselling based on cut-off marks (demo information)','Embedded Engineer,VLSI Engineer,Network Engineer,IoT Developer','M.E VLSI,M.Tech,MBA','Electronics firms,Telecom companies','BSNL, ISRO and DRDO type technical posts','Circuits,Embedded C,Signal Processing,IoT','Electronics, communication systems and embedded technology.','Electronics','Electronics,Government Jobs',70),
('B.E Mechanical Engineering',1,'4 Years','12th pass with Physics, Chemistry, Maths','Computer Science,Bio-Maths','Counselling based on cut-off marks (demo information)','Design Engineer,Production Engineer,Maintenance Engineer,CAD Specialist','M.E,MBA,Master in Design','Manufacturing,Automobile,Energy sector','Railways and PSU engineer posts','CAD,Thermodynamics,Manufacturing,Problem Solving','Design and manufacturing of machines and systems.','Mechanical','Mechanical & Design,Government Jobs',65),
('B.E Civil Engineering',1,'4 Years','12th pass with Physics, Chemistry, Maths','Computer Science,Bio-Maths','Counselling based on cut-off marks (demo information)','Site Engineer,Structural Designer,Surveyor,Project Planner','M.E Structural,MBA,Urban Planning','Construction firms,Consultancies','PWD, Highways and Water Resources engineer posts','AutoCAD,Surveying,Structural Analysis,Estimation','Planning, design and construction of infrastructure.','Civil','Construction,Government Jobs',60),
('B.E Electrical and Electronics Engineering',1,'4 Years','12th pass with Physics, Chemistry, Maths','Computer Science,Bio-Maths','Counselling based on cut-off marks (demo information)','Electrical Engineer,Power Systems Engineer,Automation Engineer','M.E Power Systems,MBA','Power utilities,Manufacturing,Renewable energy','TANGEDCO and PSU engineer posts','Circuits,Power Systems,PLC,MATLAB','Generation, distribution and control of electrical power.','Electrical','Electronics,Government Jobs',65),
('B.Sc Computer Science',2,'3 Years','12th pass (Maths/Computer Science preferred)','Computer Science,Bio-Maths,Computer Applications,Commerce','Merit / counselling in Arts & Science colleges (demo information)','Programmer,Web Developer,System Analyst,Tester','MCA,M.Sc Computer Science,MBA','IT companies,Support roles,Startups','Computer-related posts in government departments','Programming,Databases,Web Basics','Foundations of programming, data structures and databases.','Information Technology','Programming,Data & AI',60),
('BCA - Bachelor of Computer Applications',2,'3 Years','12th pass in any stream (Maths helps)','Any','Merit based (demo information)','Software Developer,App Developer,Web Designer,IT Support','MCA,MBA','IT services,Startups,Freelancing','Computer assistant posts','Programming,Web Development,Databases','Application-oriented computer course for software careers.','Information Technology','Programming,Creative Arts',55),
('B.Com - Bachelor of Commerce',2,'3 Years','12th pass (Commerce preferred)','Commerce,Computer Applications,Arts,Computer Science,Bio-Maths','Merit based (demo information)','Accountant,Tax Assistant,Banking Executive,Auditor Trainee','M.Com,CA,CMA,MBA','Banks,Accounting firms,Corporates','Bank and Group 4 / Group 2 type exams','Accounting,Tally,Excel,Taxation','Accounting, taxation and business finance.','Commerce','Business & Finance,Government Jobs',55),
('BBA - Bachelor of Business Administration',2,'3 Years','12th pass in any stream','Any','Merit / entrance (demo information)','Business Executive,HR Associate,Marketing Executive,Entrepreneur','MBA,PGDM','Corporates,Startups,Retail','Management trainee posts in PSUs','Communication,Management,Marketing,Excel','Introduction to management, marketing and entrepreneurship.','Management','Business & Finance',55),
('B.A English',2,'3 Years','12th pass in any stream','Any','Merit based (demo information)','Content Writer,Editor,Teacher,Translator','M.A English,B.Ed,MBA','Media,Publishing,Education,BPO','TET/TRB teaching exams after B.Ed, civil services','Writing,Communication,Literature,Critical Thinking','Study of literature, language and communication.','Languages','Languages & Writing,Teaching,Law & Civil Services',50),
('B.Sc Mathematics',2,'3 Years','12th pass with Maths','Computer Science,Bio-Maths','Merit based (demo information)','Data Analyst,Actuarial Trainee,Teacher,Banking Executive','M.Sc Maths,B.Ed,MBA','Analytics,Banks,Education','TRB, banking and SSC exams','Mathematics,Logic,Statistics,Excel','Pure and applied mathematics with statistics.','Science','Science & Research,Teaching,Data & AI',55),
('B.Sc Physics',2,'3 Years','12th pass with Physics and Maths','Computer Science,Bio-Maths','Merit based (demo information)','Lab Technician,Research Assistant,Teacher,Electronics Technician','M.Sc Physics,B.Ed,PhD','Research labs,Manufacturing,Education','Scientific assistant posts, teaching exams','Experimentation,Maths,Analysis','Study of matter, energy and the physical universe.','Science','Science & Research,Teaching,Electronics',55),
('B.Sc Chemistry',2,'3 Years','12th pass with Chemistry','Bio-Maths,Biology,Computer Science','Merit based (demo information)','Chemist,Quality Analyst,Lab Technician,Teacher','M.Sc Chemistry,B.Ed,PhD','Pharma,Chemical industry,Education','Government lab and teaching posts','Lab Skills,Analysis,Safety','Study of substances, reactions and materials.','Science','Science & Research,Healthcare,Teaching',55),
('B.Sc Nursing',4,'4 Years','12th pass with Biology, Physics, Chemistry','Biology,Bio-Maths','Entrance / merit as per state rules (demo information)','Staff Nurse,Community Health Nurse,Nursing Tutor','M.Sc Nursing,Public Health','Hospitals,Clinics,Overseas nursing','Government hospital staff nurse recruitment','Patient Care,Anatomy,Communication,Empathy','Professional nursing degree for hospital and community care.','Healthcare','Healthcare',60),
('B.Pharm - Bachelor of Pharmacy',4,'4 Years','12th pass with Physics, Chemistry and Biology/Maths','Biology,Bio-Maths','Counselling / merit (demo information)','Pharmacist,Drug Inspector,Quality Control Analyst,Medical Representative','M.Pharm,MBA Pharma','Pharma companies,Hospitals,Medical stores','Drug inspector and pharmacist posts','Pharmacology,Chemistry,Lab Skills','Medicine formulation, safety and dispensing.','Healthcare','Healthcare,Science & Research',60),
('Diploma in Civil Engineering',3,'3 Years','10th pass (or 12th for lateral entry)','Any','Merit based (demo information)','Site Supervisor,Surveyor,Draughtsman','B.E (lateral entry),AMIE','Construction,Contractors','Junior engineer posts in PWD and local bodies','AutoCAD,Surveying,Estimation','Practical civil engineering skills after school.','Civil','Construction,Government Jobs',50),
('Diploma in Mechanical Engineering',3,'3 Years','10th pass (or 12th for lateral entry)','Any','Merit based (demo information)','Technician,Machinist,Maintenance Supervisor','B.E (lateral entry)','Factories,Workshops','Junior engineer / technician posts in PSUs','Workshop Practice,CAD,Maintenance','Hands-on mechanical and manufacturing training.','Mechanical','Mechanical & Design,Government Jobs',50),
('Diploma in Computer Engineering',3,'3 Years','10th pass (or 12th for lateral entry)','Any','Merit based (demo information)','Junior Programmer,Hardware Technician,Network Assistant','B.E / B.Tech (lateral entry)','IT support,Small software firms','Junior assistant posts','Programming,Networking,Hardware','Practical computing and networking skills.','Information Technology','Programming,Electronics',50),
('Diploma in Elementary Education (D.El.Ed)',3,'2 Years','12th pass (marks criteria apply)','Any','Counselling based (demo information)','Primary School Teacher,Education Assistant','B.A/B.Sc then B.Ed','Private schools,Tuition','TNTET Paper I and teacher recruitment exams','Teaching,Communication,Child Psychology','Professional training for primary school teaching.','Teaching','Teaching,Government Jobs',50),
('B.A. LL.B (Integrated Law)',5,'5 Years','12th pass in any stream','Any','Entrance / merit as per university (demo information)','Advocate,Legal Advisor,Judicial Service Aspirant,Corporate Counsel','LL.M,PhD in Law','Law firms,Corporates,Courts','Judicial services and law officer posts','Reasoning,Reading,Communication,Argumentation','Integrated degree covering arts subjects and law.','Law','Law & Civil Services,Languages & Writing,Government Jobs',60),
('B.Sc Physiotherapy',4,'4 Years','12th pass with Biology, Physics, Chemistry','Biology,Bio-Maths','Merit / counselling (demo information)','Physiotherapist,Rehab Specialist,Sports Therapist','MPT,PhD','Hospitals,Sports clinics','Government hospital physiotherapist posts','Anatomy,Patient Care,Exercise Science','Therapy-based care for movement and rehabilitation.','Healthcare','Healthcare,Science & Research',60);

INSERT INTO government_exams(name,department,category,qualification,qualification_rank,min_age,max_age,eligibility,age_limit,application_process,registration_info,exam_pattern,syllabus,selection_process,instructions,official_url,interest_tags) VALUES
('TNPSC Group 4','Tamil Nadu Public Service Commission','State Services','10th',10,18,0,'[DEMO] Pass in SSLC (10th) with Tamil eligibility as notified.','[DEMO] Age limits vary by category - check the official notification.','[DEMO] Apply online on the commission website after the notification is released.','[DEMO] One-time registration (OTR) on the official portal, then apply for the exam.','[DEMO] Written exam - General Studies and Tamil eligibility (see notification).','[DEMO] General Studies, Aptitude, Tamil language.','[DEMO] Written examination followed by counselling / certificate verification.','[DEMO] Carry the hall ticket and a valid photo ID. Reach the centre early.','https://www.tnpsc.gov.in','Government Jobs,Law & Civil Services'),
('TNPSC Group 2 / 2A','Tamil Nadu Public Service Commission','State Services','Degree',15,18,0,'[DEMO] Any degree from a recognised university.','[DEMO] Check the notification for age relaxation.','[DEMO] Online application through the TNPSC portal.','[DEMO] One-time registration required.','[DEMO] Preliminary, Main and interview stages (see notification).','[DEMO] General Studies, Tamil, Aptitude.','[DEMO] Preliminary -> Main -> Interview / Certificate verification.','[DEMO] Follow the instructions printed on the hall ticket.','https://www.tnpsc.gov.in','Government Jobs,Law & Civil Services'),
('TNPSC Group 1','Tamil Nadu Public Service Commission','State Services','Degree',15,21,0,'[DEMO] Degree from a recognised university.','[DEMO] See official notification.','[DEMO] Apply online on the official portal.','[DEMO] One-time registration on the portal.','[DEMO] Preliminary, Main, Interview.','[DEMO] General Studies and optional subjects as notified.','[DEMO] Prelims -> Mains -> Interview.','[DEMO] Verify centre and timing on the hall ticket.','https://www.tnpsc.gov.in','Government Jobs,Law & Civil Services'),
('TN TET (Teacher Eligibility Test)','Teacher Recruitment Board, Tamil Nadu','Teaching','12th',12,18,0,'[DEMO] Paper I: 12th plus D.El.Ed (conditions as notified). Paper II: Degree plus B.Ed.','[DEMO] No upper age limit for TET in many notifications - verify.','[DEMO] Apply online through the TRB website.','[DEMO] Register on the TRB portal and pay the fee online.','[DEMO] Objective type, Child Development, Language, Maths/EVS (see notification).','[DEMO] Child Development & Pedagogy, Tamil/English, Mathematics, Environmental Studies.','[DEMO] Eligibility certificate based on minimum qualifying marks.','[DEMO] Carry the hall ticket and ID proof.','https://trb.tn.gov.in','Teaching,Government Jobs'),
('TN TRB Teacher Recruitment','Teacher Recruitment Board, Tamil Nadu','Teaching','Degree',15,21,0,'[DEMO] Degree + B.Ed + TET pass for most teacher posts.','[DEMO] As per notification.','[DEMO] Online application on the TRB portal.','[DEMO] Registration on the official portal.','[DEMO] Written exam on subject and pedagogy.','[DEMO] Subject syllabus, Teaching aptitude.','[DEMO] Written exam -> Certificate verification.','[DEMO] Read all instructions in the notification.','https://trb.tn.gov.in','Teaching,Government Jobs'),
('TN Police Constable (TNUSRB)','Tamil Nadu Uniformed Services Recruitment Board','Police & Uniformed','10th',10,18,0,'[DEMO] SSLC pass; physical standards as notified.','[DEMO] Age limits vary by category.','[DEMO] Apply online through the TNUSRB portal.','[DEMO] Register on the official site.','[DEMO] Written test, physical measurement and endurance test.','[DEMO] General Knowledge, Psychology, Tamil eligibility.','[DEMO] Written -> Physical tests -> Certificate verification.','[DEMO] Medical fitness required; follow all instructions.','https://www.tnusrb.tn.gov.in','Government Jobs,Law & Civil Services'),
('SSC CHSL (Combined Higher Secondary Level)','Staff Selection Commission','Central Services','12th',12,18,27,'[DEMO] 12th pass for clerical / data entry posts.','[DEMO] Typically 18-27 with relaxations - verify on the notification.','[DEMO] Apply online on the SSC portal.','[DEMO] One-time registration on the SSC website.','[DEMO] Computer-based tests: Tier I and Tier II / skill test.','[DEMO] Reasoning, English, Quantitative Aptitude, General Awareness.','[DEMO] Tier I -> Tier II -> Skill / typing test.','[DEMO] Follow the exam-city and shift details on the admit card.','https://ssc.gov.in','Government Jobs,Business & Finance'),
('RRB NTPC (Railways)','Railway Recruitment Boards','Railways','12th',12,18,33,'[DEMO] 12th-level posts available; graduate posts also exist.','[DEMO] Verify age limits in the notification.','[DEMO] Apply online on the regional RRB website.','[DEMO] Registration on the RRB portal.','[DEMO] Computer-based test stages, skill test for some posts.','[DEMO] Mathematics, Reasoning, General Awareness.','[DEMO] CBT -> Skill/aptitude test -> Document verification.','[DEMO] Verify city and shift details.','https://www.rrbchennai.gov.in','Government Jobs'),
('NDA (National Defence Academy)','Union Public Service Commission','Defence','12th',12,16,19,'[DEMO] 12th pass (Maths + Physics for Army wing / Air Force / Navy).','[DEMO] Unmarried male and female candidates within the notified age band.','[DEMO] Apply on the UPSC portal.','[DEMO] One-time registration (OTR) on UPSC.','[DEMO] Written exam (Maths, General Ability) and SSB interview.','[DEMO] Mathematics, English, General Knowledge.','[DEMO] Written -> SSB interview -> Medical.','[DEMO] Medical and physical standards apply.','https://upsc.gov.in','Government Jobs,Mechanical & Design'),
('IBPS Clerk (Banking)','Institute of Banking Personnel Selection','Banking','Degree',15,20,28,'[DEMO] Degree in any discipline; computer literacy.','[DEMO] See notification.','[DEMO] Online application on the IBPS portal.','[DEMO] Registration on the IBPS website.','[DEMO] Preliminary and Main online exams.','[DEMO] English, Numerical Ability, Reasoning.','[DEMO] Prelims -> Mains -> Provisional allotment.','[DEMO] Carry admit card and ID.','https://www.ibps.in','Business & Finance,Government Jobs');

-- demo dates (relative to today so they always look "upcoming"; is_official = 0 means PLACEHOLDER, not a real date)
INSERT INTO exam_dates(exam_id,event_name,event_date,is_official)
SELECT id,'Notification (DEMO placeholder)',DATE_ADD(CURDATE(), INTERVAL 5+id DAY),0 FROM government_exams;
INSERT INTO exam_dates(exam_id,event_name,event_date,is_official)
SELECT id,'Last date to apply (DEMO placeholder)',DATE_ADD(CURDATE(), INTERVAL 35+id DAY),0 FROM government_exams;
INSERT INTO exam_dates(exam_id,event_name,event_date,is_official)
SELECT id,'Examination (DEMO placeholder)',DATE_ADD(CURDATE(), INTERVAL 80+id*2 DAY),0 FROM government_exams;

-- demo centres
INSERT INTO exam_centers(exam_id,district,center_name,address)
SELECT e.id, d.district, CONCAT('DEMO Centre - ', d.district), 'Sample address (demo) - see hall ticket for the real centre'
FROM government_exams e CROSS JOIN
 (SELECT 'Chennai' AS district UNION SELECT 'Tiruchirappalli' UNION SELECT 'Madurai' UNION SELECT 'Coimbatore' UNION SELECT 'Salem') d;

INSERT INTO resources(title,description,category,link,date_added) VALUES
('TNPSC Official Website','Notifications, syllabus, results and one-time registration.','Government Websites','https://www.tnpsc.gov.in',CURDATE()),
('Teacher Recruitment Board (TRB)','Official TET / TRB notifications and results.','Government Websites','https://trb.tn.gov.in',CURDATE()),
('TNUSRB Official Website','Police and uniformed services recruitment.','Government Websites','https://www.tnusrb.tn.gov.in',CURDATE()),
('TNEA - Engineering Admissions','Official counselling portal for engineering admissions in Tamil Nadu.','Useful Links','https://www.tneaonline.org',CURDATE()),
('TN Arts & Science Admissions (TNGASA)','Official admission portal for government arts & science colleges.','Useful Links','https://www.tngasa.in',CURDATE()),
('National Scholarship Portal','Central and state scholarships for students.','Scholarships','https://scholarships.gov.in',CURDATE()),
('NPTEL Free Courses','Free online engineering and science courses by IITs/IISc.','Study Materials','https://nptel.ac.in',CURDATE()),
('SWAYAM','Free online courses from Indian institutions.','Study Materials','https://swayam.gov.in',CURDATE()),
('National Career Service Portal','Career counselling, job listings and skill information.','Career Resources','https://www.ncs.gov.in',CURDATE()),
('Tamil Nadu Government Portal','State government schemes and departments.','Useful Links','https://www.tn.gov.in',CURDATE());

-- Library details are sample entries - verify address and timings locally before visiting.
INSERT INTO libraries(name,district,location,address,contact,facilities,opening_hours,is_demo) VALUES
('Anna Centenary Library (sample entry)','Chennai','Kotturpuram','Kotturpuram, Chennai','Verify locally','Reading halls,Competitive exam section,Digital library,Wi-Fi','Verify locally',1),
('Connemara Public Library (sample entry)','Chennai','Egmore','Egmore, Chennai','Verify locally','Reference section,Reading hall,Newspapers','Verify locally',1),
('Kalaignar Centenary Library (sample entry)','Madurai','Madurai city','Madurai','Verify locally','Reading halls,Children section,Competitive exam books','Verify locally',1),
('District Central Library - Tiruchirappalli (sample entry)','Tiruchirappalli','Tiruchirappalli city','Tiruchirappalli','Verify locally','Reading hall,Competitive exam books,Newspapers','Verify locally',1),
('District Central Library - Coimbatore (sample entry)','Coimbatore','Coimbatore city','Coimbatore','Verify locally','Reading hall,Reference books','Verify locally',1),
('District Central Library - Salem (sample entry)','Salem','Salem city','Salem','Verify locally','Reading hall,Competitive exam books','Verify locally',1);

INSERT INTO notifications(title,message,is_demo) VALUES
('Welcome to Kalvi','Explore courses, check government exam eligibility and build your career roadmap.',0),
('Demo data notice','Exam dates and details on this installation are SAMPLE data. Always confirm on the official website.',1),
('Update your profile','Keep your 12th group, marks and interests updated for better recommendations.',0);

/* =========================================================
   RESET
   ========================================================= */

DROP TABLE IF EXISTS 
    review_criterion,
    scholarship_criterion,
    application_scholarship,
    review,
    document,
    application,
    scholarship,
    criterion,
    reviewer,
    student
CASCADE;


/* =========================================================
   TABLES
   ========================================================= */

CREATE TABLE student (
    studentid SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    surname VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    age INTEGER CHECK (age > 0), 
    financialincome DECIMAL(10,2),
    university VARCHAR(255),
    universityranking INTEGER,
    englishexamscore FLOAT CHECK (englishexamscore BETWEEN 0 AND 100)
);

CREATE TABLE scholarship (
    scholarshipid SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    providername VARCHAR(255),
    scholarshiptype VARCHAR(255),
    startdate DATE,
    applicationdeadline DATE
);

CREATE TABLE application (
    applicationid SERIAL PRIMARY KEY,
    studentid INTEGER REFERENCES student(studentid) ON DELETE CASCADE,
    applicationdate DATE NOT NULL,
    outcome VARCHAR(50) CHECK (outcome IN ('Accepted','Rejected','Waitlist')) NOT NULL,
    status VARCHAR(50) CHECK (status IN ('ELIGIBLE','INELIGIBLE_AGE','AUTO_REJECT_ENGLISH')),
    score NUMERIC(6,2)
);

CREATE TABLE reviewer (
    reviewerid SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    surname VARCHAR(255) NOT NULL,
    contactemail VARCHAR(255)
);

CREATE TABLE document (
    documentid SERIAL PRIMARY KEY,
    applicationid INTEGER REFERENCES application(applicationid),
    type VARCHAR(255),
    uploaddate DATE
);

CREATE TABLE review (
    reviewid SERIAL PRIMARY KEY,
    applicationid INTEGER REFERENCES application(applicationid),
    reviewerid INTEGER REFERENCES reviewer(reviewerid),
    recommendation BOOLEAN
);

CREATE TABLE criterion (
    criterionid SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    weight FLOAT
);

CREATE TABLE application_scholarship (
    applicationid INTEGER REFERENCES application(applicationid),
    scholarshipid INTEGER REFERENCES scholarship(scholarshipid),
    PRIMARY KEY (applicationid, scholarshipid)
);

CREATE TABLE scholarship_criterion (
    scholarshipid INTEGER REFERENCES scholarship(scholarshipid),
    criterionid INTEGER REFERENCES criterion(criterionid),
    PRIMARY KEY (scholarshipid, criterionid)
);

CREATE TABLE review_criterion (
    reviewid INTEGER REFERENCES review(reviewid),
    criterionid INTEGER REFERENCES criterion(criterionid),
    PRIMARY KEY (reviewid, criterionid)
);

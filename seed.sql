/* =========================================================
   SEED DATA
   ========================================================= */

INSERT INTO criterion (name, description, weight) VALUES 
('Academic Success','GPA and ranking',0.40),
('Financial Need','Household income',0.30),
('Leadership','Activities',0.20),
('English','Language score',0.10);

INSERT INTO reviewer (name,surname,contactemail) VALUES
('Ahmet','Yılmaz','ahmet@uni.edu'),
('Emily','Clark','emily@org.org'),
('Mehmet','Demir','mehmet@corp.com'),
('Selin','Öztürk','selin@edu.tr');

INSERT INTO scholarship (name,providername,scholarshiptype,startdate,applicationdeadline) VALUES
('Global Excellence','Tech Foundation','Merit','2024-09-01','2024-08-15'),
('Support Tomorrow','Gov Dept','Need','2024-10-01','2024-09-01'),
('STEM Scholars','Innovate','Special','2025-01-01','2024-11-30');


/* =========================================================
   STUDENTS (200)
   ========================================================= */

INSERT INTO student (name,surname,email,age,financialincome,university,universityranking,englishexamscore)
SELECT 
    (ARRAY['Ali','Ayşe','Mehmet','Fatma','Can','Zeynep','Burak','Elif','Emre','Selin','Mert','Gamze','Ozan','Buse','Tolga','Ezgi','Kaan','Deniz','Cem','Esra'])[floor(random()*20)+1],
    (ARRAY['Yılmaz','Kaya','Demir','Çelik','Şahin','Yıldız','Öztürk','Arslan','Doğan','Kılıç','Aslan','Çetin','Kara','Koç','Kurt','Özkan','Şimşek','Polat','Özdemir','Aydın'])[floor(random()*20)+1],
    'student'||generate_series||'@edu.tr',
    floor(random()*(30-18+1)+18),
    round((random()*150000)::numeric,2),
    (ARRAY['ODTÜ','İTÜ','Boğaziçi','Bilkent','Koç','Sabancı','Hacettepe','Gazi','Ege','YTÜ','Marmara'])[floor(random()*11)+1],
    floor(random()*100+1),
    round((random()*60+40)::numeric,1)
FROM generate_series(1,200);


/* =========================================================
   APPLICATIONS
   ========================================================= */

INSERT INTO application (studentid,applicationdate,outcome)
SELECT 
    studentid,
    DATE '2024-01-01' + (random()*180)::int,
    'Rejected'
FROM student
WHERE random()>0.1;


/* =========================================================
   SCORE + STATUS CALCULATION
   ========================================================= */

WITH bounds AS (
  SELECT
    MIN(financialincome) min_income,
    MAX(financialincome) max_income,
    MIN(universityranking) min_rank,
    MAX(universityranking) max_rank
  FROM student
),
calc AS (
  SELECT
    a.applicationid,
    CASE
      WHEN s.age > 25 THEN 'INELIGIBLE_AGE'
      WHEN s.englishexamscore < 60 THEN 'AUTO_REJECT_ENGLISH'
      ELSE 'ELIGIBLE'
    END AS status,
    CASE
      WHEN s.age > 25 THEN NULL
      WHEN s.englishexamscore < 60 THEN 0
      ELSE
        0.40 * (100*(b.max_income-s.financialincome)/NULLIF(b.max_income-b.min_income,0))
      + 0.25 * s.englishexamscore
      + 0.25 * (100*(b.max_rank-s.universityranking)/NULLIF(b.max_rank-b.min_rank,0))
      + 0.10 * (100*(25-s.age)/NULLIF(25-17,0))
    END AS score
  FROM application a
  JOIN student s ON s.studentid=a.studentid
  CROSS JOIN bounds b
)
UPDATE application a
SET
  status = c.status,
  score = ROUND(c.score::numeric,2),
  outcome = CASE
              WHEN c.status IN ('INELIGIBLE_AGE','AUTO_REJECT_ENGLISH')
              THEN 'Rejected'
              ELSE a.outcome
            END
FROM calc c
WHERE a.applicationid=c.applicationid;


/* =========================================================
   FINAL DECISION
   ========================================================= */

WITH ranked AS (
  SELECT
    applicationid,
    ROW_NUMBER() OVER (ORDER BY score DESC NULLS LAST, applicationid) rn
  FROM application
  WHERE status='ELIGIBLE'
)
UPDATE application a
SET outcome = CASE
    WHEN r.rn <= 20 THEN 'Accepted'
    WHEN r.rn BETWEEN 21 AND 30 THEN 'Waitlist'
    ELSE 'Rejected'
END
FROM ranked r
WHERE a.applicationid=r.applicationid;


/* =========================================================
   SCHOLARSHIP ASSIGNMENTS
   ========================================================= */

INSERT INTO application_scholarship
SELECT a.applicationid, 1
FROM application a
JOIN student s ON a.studentid = s.studentid
WHERE s.englishexamscore >= 85;

INSERT INTO application_scholarship
SELECT a.applicationid, 2
FROM application a
JOIN student s ON a.studentid = s.studentid
WHERE s.financialincome < 15000;

INSERT INTO application_scholarship
SELECT applicationid, 3
FROM application
WHERE applicationid % 5 = 0;


/* =========================================================
   DOCUMENTS
   ========================================================= */

INSERT INTO document (applicationid, type, uploaddate)
SELECT 
    applicationid,
    (ARRAY['Transcript','CV','Letter','Income Statement'])[floor(random()*4)+1],
    applicationdate
FROM application;


/* =========================================================
   REVIEWS
   ========================================================= */

WITH eligible_ranked AS (
    SELECT
        a.applicationid,
        a.outcome,
        ROW_NUMBER() OVER (ORDER BY a.score DESC NULLS LAST, a.applicationid) AS rn
    FROM application a
    WHERE a.status = 'ELIGIBLE'
),
assigned AS (
    SELECT
        applicationid,
        outcome,
        ((rn - 1) % 4) + 1 AS reviewerid
    FROM eligible_ranked
),
ins AS (
    INSERT INTO review (applicationid, reviewerid, recommendation)
    SELECT
        applicationid,
        reviewerid,
        CASE
            WHEN outcome = 'Accepted' THEN TRUE
            WHEN outcome = 'Waitlist' THEN (random() < 0.70)
            ELSE (random() < 0.15)
        END
    FROM assigned
    RETURNING reviewid
)
INSERT INTO review_criterion (reviewid, criterionid)
SELECT
    reviewid,
    floor(random()*4+1)::int
FROM ins;

/* =========================================================
   REVIEW QUEUE VIEW
   ========================================================= */

CREATE OR REPLACE VIEW v_review_queue AS
SELECT
  a.applicationid,
  s.studentid,
  s.name,
  s.surname,
  s.age,
  s.financialincome,
  s.university,
  s.universityranking,
  s.englishexamscore,
  a.status,
  a.score,
  a.outcome
FROM application a
JOIN student s ON s.studentid=a.studentid
ORDER BY
  (a.status='ELIGIBLE') DESC,
  a.score DESC NULLS LAST;


/* =========================================================
   CONTROLS / ANALYSIS
   ========================================================= */

SELECT outcome, COUNT(*) 
FROM application 
GROUP BY outcome 
ORDER BY outcome;

SELECT status, COUNT(*) 
FROM application 
GROUP BY status 
ORDER BY status;

SELECT
  (SELECT COUNT(*) FROM application WHERE status='ELIGIBLE') AS eligible_applications,
  (SELECT COUNT(*) FROM review) AS total_reviews;

SELECT
  r.reviewerid,
  (rv.name || ' ' || rv.surname) AS reviewer_name,
  COUNT(*) AS total_reviews,
  SUM(CASE WHEN a.outcome='Accepted' THEN 1 ELSE 0 END) AS accepted_reviewed,
  SUM(CASE WHEN a.outcome='Waitlist' THEN 1 ELSE 0 END) AS waitlist_reviewed,
  SUM(CASE WHEN a.outcome='Rejected' THEN 1 ELSE 0 END) AS rejected_reviewed,
  SUM(CASE WHEN r.recommendation THEN 1 ELSE 0 END) AS recommended,
  SUM(CASE WHEN NOT r.recommendation THEN 1 ELSE 0 END) AS not_recommended
FROM review r
JOIN reviewer rv ON rv.reviewerid = r.reviewerid
JOIN application a ON a.applicationid = r.applicationid
GROUP BY r.reviewerid, reviewer_name
ORDER BY r.reviewerid;

SELECT * 
FROM v_review_queue 
ORDER BY score DESC NULLS LAST;

SELECT * 
FROM v_review_queue 
WHERE outcome='Waitlist' 
ORDER BY score DESC NULLS LAST;

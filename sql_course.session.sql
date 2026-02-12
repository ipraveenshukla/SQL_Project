





























/* 



SELECT 
    job_title_short,
    salary_year_avg
FROM
(
SELECT *
FROM jan_jobs
UNION ALL
SELECT *
FROM feb_jobs
UNION ALL
SELECT *
FROM mar_jobs
) AS q1_jobs



WHERE 
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL 
ORDER BY
    salary_year_avg DESC



SELECT
    job_title_short,
    company_id,
    job_location
FROM
    jan_jobs

UNION

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    feb_jobs

UNION

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    mar_jobs



SELECT
    job_title_short,
    company_id,
    job_location
FROM
    jan_jobs

UNION ALL

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    feb_jobs

UNION ALL

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    mar_jobs



WITH Remote_Jobs AS
(
SELECT
    skill_id,
    COUNT(*) AS Job_Count
FROM
    skills_job_dim AS skills_to_job
INNER JOIN job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id
WHERE
    job_postings.job_work_from_home = TRUE AND
    job_title_short = 'Data Analyst'

GROUP BY
    skill_id


)

SELECT
    skill.skills AS Skill_Name,
    Remote_Jobs.Job_Count
FROM    
    Remote_Jobs
INNER JOIN skills_dim AS skill ON Remote_Jobs.skill_id = skill.skill_id
ORDER BY
    Remote_Jobs.Job_Count DESC
LIMIT 5;



WITH Jobs_Available AS
(
SELECT
    company_id,
    COUNT(job_id) AS Job_Count,
CASE
    WHEN COUNT(job_id) > 200 THEN 'Large'
    WHEN COUNT(job_id) > 50 THEN 'Medium'
    ELSE 'Small'
END AS Company_Category
FROM
    job_postings_fact

GROUP BY
    company_id
)

SELECT
    name AS Company_Name,
    Jobs_Available.Job_Count,
    Jobs_Available.Company_Category
FROM
    company_dim
LEFT JOIN
    Jobs_Available ON Jobs_Available.company_id = company_dim.company_id



ORDER BY
    Job_Count ;



WITH Job_Count AS
(
    SELECT
    skill_id, 
    COUNT(job_id) AS Available_Jobs
    FROM
    skills_job_dim
    GROUP BY
    skill_id
)

SELECT
    
    skills,
    Job_Count.Available_Jobs
    FROM
    skills_dim
LEFT JOIN
    Job_Count ON Job_Count.skill_id = skills_dim.skill_id

ORDER BY
    Available_Jobs DESC
LIMIT 10 ;



WITH company_job_count AS
(
    SELECT
    company_id,
    COUNT (job_id) AS Total_Jobs
    FROM
    job_postings_fact
    GROUP BY
    company_id
)

SELECT
    company_dim.name AS Company_Name,
    Total_Jobs

FROM
    company_dim
LEFT JOIN
    company_job_count ON company_job_count.company_id = company_dim.company_id
 ORDER BY Total_Jobs DESC 




SELECT 
    company_id,
    name AS Company_Name
FROM
    company_dim
WHERE
    company_id IN 
    (
SELECT
    company_id
FROM
    job_postings_fact
WHERE
    job_no_degree_mention = TRUE
    )
ORDER BY
    company_id





WITH March_Jobs AS
    (
    SELECT *
    FROM
        job_postings_fact
    WHERE
    EXTRACT (MONTH FROM job_posted_date) = 3
    )
SELECT *
FROM March_Jobs;


SELECT *
FROM (
    SELECT *    
    FROM job_postings_fact
    WHERE EXTRACT (MONTH FROM job_posted_date) = 1
)   AS January_jobs


SELECT
    COUNT(job_id) AS Jobs_Available,
CASE
    WHEN  salary_year_avg >= 150000 THEN 'Strong Apply'
    WHEN  salary_year_avg >= 100000 THEN 'Apply'
    ELSE 'Not Apply'
END AS Apply_Recommendation
FROM
    job_postings_fact
WHERE   
    salary_year_avg IS NOT NULL  AND
    job_title_short = 'Data Analyst'
Group BY
    Apply_Recommendation ;


ALTER TABLE job_postings_fact
ALTER COLUMN salary_year_avg TYPE INTEGER;

SELECT 
    COUNT(job_id) AS Number_of_Jobs,
CASE    
    WHEN job_location = 'Anywhere' THEN 'Remote'
    WHEN job_location = 'New York, NY' THEN 'Local'
    ELSE 'Onsite'
END AS Location_Category
    
FROM    
    job_postings_fact
WHERE
--  job_title_short = 'Data Scientist'
    job_title_short = 'Data Analyst'
GROUP BY
    Location_Category;



CREATE TABLE Jan_Jobs AS SELECT * FROM job_postings_fact WHERE EXTRACT(MONTH FROM job_posted_date) = 1;
CREATE TABLE Feb_Jobs AS SELECT * FROM job_postings_fact WHERE EXTRACT(MONTH FROM job_posted_date) = 2;
CREATE TABLE Mar_Jobs AS SELECT * FROM job_postings_fact WHERE EXTRACT(MONTH FROM job_posted_date) = 3;



CREATE TABLE Jan_Jobs AS
    SELECT *
    FROM
        job_postings_fact
    WHERE
        EXTRACT(MONTH FROM job_posted_date) =1;


CREATE TABLE Jan_Jobs AS SELECT * FROM job_postings_fact WHERE EXTRACT(MONTH FROM job_posted_date) = 1;
CREATE TABLE Feb_Jobs AS SELECT * FROM job_postings_fact WHERE EXTRACT(MONTH FROM job_posted_date) = 2;
CREATE TABLE Mar_Jobs AS SELECT * FROM job_postings_fact WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

DROP TABLE Jan_Jobs;
DROP TABLE Feb_Jobs;
DROP TABLE Mar_Jobs;


SELECT job_posted_date
FROM Jan_Jobs;




SELECT
    EXTRACT (MONTH FROM job_posted_date) AS Month_Posted,
    COUNT(job_id) AS ID
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    Month_Posted
ORDER BY
    ID DESC



SELECT
    job_title_short AS Title,
    job_location AS Location,
EXTRACT (MONTH FROM job_posted_date) AS Month_Posted,
EXTRACT (YEAR FROM job_posted_date) AS Year_Posted

FROM
    job_postings_fact
    Limit 10;
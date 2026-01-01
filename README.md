Overview

This project implements a relational database system for managing a scholarship application and evaluation process. The system models students, scholarships, applications, reviewers, evaluation criteria, and related documents, and supports the full workflow from application submission to final decision making.

The database is designed using an Entity–Relationship (ER) model and implemented in SQL with normalized tables, integrity constraints, and associative entities for many-to-many relationships. Synthetic data is generated to simulate realistic application scenarios and evaluation outcomes.

Project Structure
├── README.md
├── sql/
│   ├── schema.sql
│   ├── seed.sql
│   └── queries.sql
├── python/
│   └── gui.py   (to be added)
└── report/
    └── report.pdf


 The database is based on the following core entities:
	•	Student: Stores applicant demographic, academic, and financial information.
	•	Scholarship: Represents available scholarship programs and their properties.
	•	Application: Links students to scholarships and stores application status, score, and outcome.
	•	Document: Stores supporting documents submitted with applications.
	•	Reviewer: Represents evaluators responsible for assessing applications.
	•	Review: Stores individual evaluations of applications.
	•	Criterion: Defines evaluation criteria used during the review process.

Many-to-many relationships are implemented through associative tables:
	•	application_scholarship
	•	scholarship_criterion
	•	review_criterion




  SQL Files Description

schema.sql
	•	Drops existing tables safely using CASCADE
	•	Creates all database tables
	•	Defines:
	•	Primary keys
	•	Foreign keys
	•	Composite keys for associative tables
	•	Domain and integrity constraints (e.g. age, outcome, status checks)

seed.sql
	•	Populates the database with synthetic data
	•	Generates:
	•	200 students
	•	Scholarships, reviewers, and criteria
	•	Applications with rule-based eligibility checks
	•	Computes application scores using weighted criteria
	•	Assigns outcomes (Accepted, Waitlist, Rejected)
	•	Ensures:
	•	Each eligible application receives exactly one review
	•	Reviewer workload is balanced

queries.sql
	•	Defines analytical views and queries
	•	Includes:
	•	Review queue view
	•	Outcome and status distributions
	•	Reviewer workload analysis
	•	Consistency checks between applications and reviews




Python Component

A Python-based graphical user interface (GUI) is used to interact with the database and visualize application and review information.
The implementation is located in the python/ directory and connects directly to the SQL database to retrieve and display results.


How to Run the Project
	1.	Create an empty PostgreSQL database.
	2.	Run the SQL files in the following order:


schema.sql
seed.sql
queries.sql




Notes
	•	The data used in this project is fully synthetic and generated for academic purposes.
	•	The project is structured to be reproducible and extensible.
	•	Full documentation and explanations are provided in the accompanying report.
  

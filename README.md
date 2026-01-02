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



## Graphical User Interface (GUI)

In addition to the database design and SQL implementation, this project includes a graphical user interface (GUI) to interact with the system more intuitively.

The GUI allows users to:
- Execute predefined SQL queries
- View query results in a structured and readable format
- Interact with the database without directly writing SQL commands

The GUI is implemented as a separate module under the `GUI/` directory and communicates with the database using the defined schema and seed data provided in this repository.

This component demonstrates how the designed database can be integrated into a user-facing application, supporting practical usage scenarios beyond raw SQL execution.

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
  

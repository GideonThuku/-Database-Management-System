# Disability Therapy Center - Database Schema

**File name (SQL):** `disability_therapy_center.sql`

This repository contains a full relational database schema for a **Disability Therapy Center**.  
The schema is designed for MySQL and includes tables for clients, therapists, sessions, programs, billing, and staff. It uses proper keys and constraints and follows normalization best practices.

---

## Prerequisites

Before you run the SQL file, make sure you have:

- MySQL Server installed (version 5.7+ recommended)  
- MySQL Workbench or access to the `mysql` command-line client  
- (Optional) A code editor like VS Code

---

## What is included

- `disability_therapy_center.sql` — the SQL file that:
  - Creates the database `disability_therapy_center`
  - Creates all tables with PRIMARY KEY, FOREIGN KEY, UNIQUE, NOT NULL, and CHECK constraints
  - Provides optional sample `INSERT` statements (commented out) for testing

Tables created (main ones):

- `Clients` — client/patient personal details and disability info  
- `Therapists` — therapist details and specialties  
- `Therapy_Sessions` — scheduled therapy sessions (links clients & therapists)  
- `Programs` — therapy programs (e.g., 6-week courses)  
- `Client_Programs` — enrollment (many-to-many) between clients and programs  
- `Invoices` — billing per session  
- `Payments` — payments against invoices  
- `Staff` — admin/front-desk user accounts (optional)

---

## How to run the SQL file

### Using MySQL Workbench
1. Open MySQL Workbench and connect to your local server.  
2. Open the file: `File → Open SQL Script...` → select `disability_therapy_center.sql`.  
3. Click the lightning bolt icon (Execute) to run the script.  
4. The database `disability_therapy_center` will be created and tables added.

### Using the command line (Windows / macOS / Linux)
Open a terminal (or Git Bash) and run:

```bash
mysql -u your_mysql_user -p < disability_therapy_center.sql
```

You will be prompted for your MySQL password. After running, connect to MySQL and use the database:

```bash
mysql -u your_mysql_user -p
# then at the mysql> prompt:
USE disability_therapy_center;
SHOW TABLES;
```

Replace `your_mysql_user` with your MySQL username (e.g., `root`).

---

## Quick verification queries

After running the SQL file, try these queries to check the tables:

```sql
-- Show table list
USE disability_therapy_center;
SHOW TABLES;

-- See columns for Clients
DESCRIBE Clients;

-- Count rows (should be zero unless you inserted sample data)
SELECT COUNT(*) FROM Clients;
SELECT COUNT(*) FROM Therapists;

-- If you added sample data (uncommented INSERTs), list a few rows:
SELECT * FROM Clients LIMIT 5;
SELECT * FROM Therapy_Sessions LIMIT 5;
```

---

## How to add sample data (optional)

The SQL file includes commented `INSERT` statements near the end. To load sample data:

1. Open `disability_therapy_center.sql` in a text editor.  
2. Find the `SAMPLE DATA (Optional)` section.  
3. Remove comment markers (`--`) from the `INSERT` lines you want to run.  
4. Save and re-run the file (or paste the `INSERT` statements into your SQL client and run them).

---

## Design notes

- The schema follows normalization principles (1NF, 2NF, 3NF): data is split into logical tables so fields depend on keys only.  
- Relationships:
  - **One-to-many**: Clients → Therapy_Sessions; Therapists → Therapy_Sessions  
  - **Many-to-many**: Clients ↔ Programs via `Client_Programs`  
  - **One-to-one (enforced)**: Appointment/Session → Invoice (unique session_id in `Invoices`)  
- Foreign keys use `ON DELETE` and `ON UPDATE` rules to keep referential integrity:
  - For clients we used `ON DELETE CASCADE` so if a client is removed, their sessions are removed too (adjust as needed for your policy).

---

## Recommended next steps

- Create an **ERD** (Entity Relationship Diagram) from the schema using MySQL Workbench or an online tool (dbdiagram.io). This helps visualize table relationships.  
- Add indexes on frequently searched columns (e.g., `session_date`, `therapist_id`) for performance.  
- Add user authentication and password hashing if you plan to build an app.

---

## Troubleshooting

- If `CREATE DATABASE` fails, ensure you are connected with a user that has `CREATE` privileges.  
- If any `DROP TABLE IF EXISTS` or `CREATE TABLE` fails, read the error message in Workbench or the terminal — it will usually say which constraint or name caused the problem.
- If you get errors about `CHECK` constraints in older MySQL versions, either upgrade or remove the `CHECK` clauses (they are supported best in MySQL 8+).

---
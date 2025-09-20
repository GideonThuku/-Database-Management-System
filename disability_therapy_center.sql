-- disability_therapy_center.sql
-- Database Schema for a Disability Therapy Center

-- Create database
CREATE DATABASE IF NOT EXISTS disability_therapy_center
  CHARACTER SET = 'utf8mb4'
  COLLATE = 'utf8mb4_unicode_ci';
USE disability_therapy_center;

-- =========================
-- Table: Clients (Patients)
-- =========================
DROP TABLE IF EXISTS Clients;
CREATE TABLE Clients (
  client_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  date_of_birth DATE,
  gender ENUM('male','female','other') DEFAULT 'other',
  disability_type VARCHAR(200) NOT NULL,
  phone VARCHAR(20) UNIQUE,
  email VARCHAR(255) UNIQUE,
  address TEXT,
  guardian_name VARCHAR(200),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- =========================
-- Table: Therapists
-- =========================
DROP TABLE IF EXISTS Therapists;
CREATE TABLE Therapists (
  therapist_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  specialty ENUM('physical','occupational','speech','counseling','other') NOT NULL,
  phone VARCHAR(20) UNIQUE,
  email VARCHAR(255) UNIQUE,
  hire_date DATE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- =========================
-- Table: Therapy_Sessions
-- Each session links a client and a therapist
-- =========================
DROP TABLE IF EXISTS Therapy_Sessions;
CREATE TABLE Therapy_Sessions (
  session_id INT AUTO_INCREMENT PRIMARY KEY,
  client_id INT NOT NULL,
  therapist_id INT NOT NULL,
  session_date DATETIME NOT NULL,
  session_type ENUM('individual','group') DEFAULT 'individual',
  focus_area VARCHAR(255), -- e.g. "motor skills", "speech training"
  status ENUM('scheduled','completed','cancelled') DEFAULT 'scheduled',
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_session_client FOREIGN KEY (client_id)
    REFERENCES Clients(client_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_session_therapist FOREIGN KEY (therapist_id)
    REFERENCES Therapists(therapist_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =========================
-- Table: Programs
-- A program is a set of therapy sessions (e.g., 6-week physical therapy)
-- =========================
DROP TABLE IF EXISTS Programs;
CREATE TABLE Programs (
  program_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL UNIQUE,
  description TEXT,
  duration_weeks INT NOT NULL CHECK (duration_weeks > 0),
  cost DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- =========================
-- Table: Client_Programs (Many-to-Many)
-- Connects clients with the programs they are enrolled in
-- =========================
DROP TABLE IF EXISTS Client_Programs;
CREATE TABLE Client_Programs (
  client_id INT NOT NULL,
  program_id INT NOT NULL,
  start_date DATE NOT NULL,
  progress_notes TEXT,
  PRIMARY KEY (client_id, program_id),
  CONSTRAINT fk_cp_client FOREIGN KEY (client_id)
    REFERENCES Clients(client_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_cp_program FOREIGN KEY (program_id)
    REFERENCES Programs(program_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =========================
-- Table: Invoices (Billing)
-- One-to-one with a therapy session
-- =========================
DROP TABLE IF EXISTS Invoices;
CREATE TABLE Invoices (
  invoice_id INT AUTO_INCREMENT PRIMARY KEY,
  session_id INT NOT NULL UNIQUE,
  amount DECIMAL(10,2) NOT NULL,
  status ENUM('unpaid','paid','pending') DEFAULT 'unpaid',
  issue_date DATE DEFAULT (CURRENT_DATE),
  CONSTRAINT fk_invoice_session FOREIGN KEY (session_id)
    REFERENCES Therapy_Sessions(session_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =========================
-- Table: Payments
-- Multiple payments can be made per invoice
-- =========================
DROP TABLE IF EXISTS Payments;
CREATE TABLE Payments (
  payment_id INT AUTO_INCREMENT PRIMARY KEY,
  invoice_id INT NOT NULL,
  payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
  payment_method ENUM('cash','card','mobile_money','insurance') DEFAULT 'cash',
  reference VARCHAR(255),
  CONSTRAINT fk_payment_invoice FOREIGN KEY (invoice_id)
    REFERENCES Invoices(invoice_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =========================
-- Table: Staff (Admin, Front Desk)
-- Optional: handles bookings and payments
-- =========================
DROP TABLE IF EXISTS Staff;
CREATE TABLE Staff (
  staff_id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(100) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  role ENUM('admin','frontdesk','manager','therapist') DEFAULT 'frontdesk',
  email VARCHAR(255) UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- =========================
-- SAMPLE DATA (Optional)
-- =========================
-- INSERT INTO Clients (first_name,last_name,disability_type,phone,email)
-- VALUES ('John','Mwangi','Cerebral Palsy','+254700123456','john@example.com');

-- INSERT INTO Therapists (first_name,last_name,specialty,phone,email)
-- VALUES ('Grace','Otieno','physical','+254701234567','grace.otieno@center.org');

-- INSERT INTO Programs (name,description,duration_weeks,cost)
-- VALUES ('Motor Skills Training','Improve coordination and muscle strength',6,5000.00);

-- INSERT INTO Client_Programs (client_id,program_id,start_date)
-- VALUES (1,1,'2025-09-25');

-- INSERT INTO Therapy_Sessions (client_id,therapist_id,session_date,focus_area)
-- VALUES (1,1,'2025-09-26 09:00:00','Leg strengthening');

-- INSERT INTO Invoices (session_id,amount,status)
-- VALUES (1,2000.00,'unpaid');

-- INSERT INTO Payments (invoice_id,amount,payment_method)
-- VALUES (1,1000.00,'mobile_money');

-- =========================
-- END OF SCHEMA
-- =========================

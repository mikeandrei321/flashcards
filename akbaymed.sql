-- Users (authentication and basic profile)
CREATE TABLE users (
    id VARCHAR2(36) PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    email VARCHAR2(255) UNIQUE NOT NULL,
    contact_no VARCHAR2(15),
    user_type VARCHAR2(20) CHECK (user_type IN ('patient', 'bhw', 'admin')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Barangay Health Workers profile
CREATE TABLE bhw_profiles (
    id VARCHAR2(36) PRIMARY KEY,
    user_id VARCHAR2(36) REFERENCES users(id),
    barangay VARCHAR2(100) NOT NULL,
    assigned_area VARCHAR2(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Patients basic information
CREATE TABLE patients (
    id VARCHAR2(36) PRIMARY KEY,
    user_id VARCHAR2(36) REFERENCES users(id),
    date_of_birth DATE,
    sex CHAR(1) CHECK (sex IN ('M', 'F')),
    barangay VARCHAR2(100),
    contact_no VARCHAR2(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Patient visits
CREATE TABLE visits (
    id VARCHAR2(36) PRIMARY KEY,
    patient_id VARCHAR2(36) REFERENCES patients(id),
    bhw_id VARCHAR2(36) REFERENCES bhw_profiles(id),
    visit_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    service_type VARCHAR2(50),
    notes VARCHAR2(4000)
);

-- Medications master list
CREATE TABLE medications (
    id VARCHAR2(36) PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    description VARCHAR2(4000),
    category VARCHAR2(100)
);

-- Barangay Medicine Inventory
CREATE TABLE barangay_stock (
    id VARCHAR2(36) PRIMARY KEY,
    barangay VARCHAR2(100),
    medication_id VARCHAR2(36) REFERENCES medications(id),
    quantity NUMBER,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Medication distributions (donations and requests)
CREATE TABLE med_distributions (
    id VARCHAR2(36) PRIMARY KEY,
    type VARCHAR2(20) CHECK (type IN ('donation', 'request')),
    patient_id VARCHAR2(36) REFERENCES patients(id),
    medication_id VARCHAR2(36) REFERENCES medications(id),
    quantity NUMBER,
    status VARCHAR2(20) CHECK (status IN ('pending', 'approved', 'declined')),
    processed_by VARCHAR2(36) REFERENCES bhw_profiles(id),
    processed_at TIMESTAMP
);

-- Appointments schedule
CREATE TABLE appointments (
    id VARCHAR2(36) PRIMARY KEY,
    patient_id VARCHAR2(36) REFERENCES patients(id),
    bhw_id VARCHAR2(36) REFERENCES bhw_profiles(id),
    appointment_date TIMESTAMP,
    type VARCHAR2(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

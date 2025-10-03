-- -----------------------------------------------------
-- Schema hotel_database
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS hotel_database;
SET search_path TO hotel_database;

-- -----------------------------------------------------
-- Table addresses
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS addresses (
  address_id SERIAL PRIMARY KEY,
  address_line1 VARCHAR(100),
  address_line2 VARCHAR(100),
  city VARCHAR(45),
  state VARCHAR(45),
  country VARCHAR(45),
  zipcode VARCHAR(8)
);

-- -----------------------------------------------------
-- Table hotel_chain
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS hotel_chain (
  hotel_chain_id SERIAL PRIMARY KEY,
  hotel_chain_name VARCHAR(45),
  hotel_chain_contact_number VARCHAR(12),
  hotel_chain_email_address VARCHAR(45),
  hotel_chain_website VARCHAR(45),
  hotel_chain_head_office_address_id INT NOT NULL,
  CONSTRAINT fk_hotel_chains_addresses1
    FOREIGN KEY (hotel_chain_head_office_address_id)
    REFERENCES addresses (address_id)
);

CREATE INDEX IF NOT EXISTS idx_hotel_chain_address
  ON hotel_chain (hotel_chain_head_office_address_id);

-- -----------------------------------------------------
-- Table star_ratings
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS star_ratings (
  star_rating INT PRIMARY KEY,
  star_rating_image VARCHAR(100)
);

-- -----------------------------------------------------
-- Table hotel
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS hotel (
  hotel_id SERIAL PRIMARY KEY,
  hotel_name VARCHAR(45),
  hotel_contact_number VARCHAR(12),
  hotel_email_address VARCHAR(45),
  hotel_website VARCHAR(45),
  hotel_description VARCHAR(100),
  hotel_floor_count INT,
  hotel_room_capacity INT,
  hotel_chain_id INT,
  addresses_address_id INT NOT NULL,
  star_ratings_star_rating INT NOT NULL,
  check_in_time TIME,
  check_out_time TIME,
  CONSTRAINT fk_hotels_addresses1 FOREIGN KEY (addresses_address_id)
    REFERENCES addresses (address_id),
  CONSTRAINT fk_hotel_star_ratings1 FOREIGN KEY (star_ratings_star_rating)
    REFERENCES star_ratings (star_rating)
);

CREATE INDEX IF NOT EXISTS idx_hotel_address ON hotel (addresses_address_id);
CREATE INDEX IF NOT EXISTS idx_hotel_star_rating ON hotel (star_ratings_star_rating);

-- -----------------------------------------------------
-- Table room_type
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS room_type (
  room_type_id SERIAL PRIMARY KEY,
  room_type_name VARCHAR(45),
  room_cost DECIMAL(10,2),
  room_type_description VARCHAR(100),
  smoke_friendly BOOLEAN,
  pet_friendly BOOLEAN
);

-- -----------------------------------------------------
-- Table rooms
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS rooms (
  room_id SERIAL PRIMARY KEY,
  room_number INT,
  rooms_type_rooms_type_id INT NOT NULL,
  hotel_hotel_id INT NOT NULL,
  CONSTRAINT fk_rooms_rooms_type1 FOREIGN KEY (rooms_type_rooms_type_id)
    REFERENCES room_type (room_type_id),
  CONSTRAINT fk_rooms_hotel1 FOREIGN KEY (hotel_hotel_id)
    REFERENCES hotel (hotel_id)
);

CREATE INDEX IF NOT EXISTS idx_rooms_type ON rooms (rooms_type_rooms_type_id);
CREATE INDEX IF NOT EXISTS idx_rooms_hotel ON rooms (hotel_hotel_id);

-- -----------------------------------------------------
-- Table guests
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS guests (
  guest_id SERIAL PRIMARY KEY,
  guest_first_name VARCHAR(45),
  guest_last_name VARCHAR(45),
  guest_contact_number VARCHAR(12),
  guest_email_address VARCHAR(45),
  guest_credit_card VARCHAR(45),
  guest_id_proof VARCHAR(45),
  addresses_address_id INT NOT NULL,
  CONSTRAINT fk_guests_addresses1 FOREIGN KEY (addresses_address_id)
    REFERENCES addresses (address_id)
);

CREATE INDEX IF NOT EXISTS idx_guests_address ON guests (addresses_address_id);

-- -----------------------------------------------------
-- Table department
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS department (
  department_id SERIAL PRIMARY KEY,
  department_name VARCHAR(45),
  department_description VARCHAR(100)
);

-- -----------------------------------------------------
-- Table employees
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS employees (
  emp_id SERIAL PRIMARY KEY,
  emp_first_name VARCHAR(45),
  emp_last_name VARCHAR(45),
  emp_designation VARCHAR(45),
  emp_contact_number VARCHAR(12),
  emp_email_address VARCHAR(45),
  department_department_id INT NOT NULL,
  addresses_address_id INT NOT NULL,
  hotel_hotel_id INT NOT NULL,
  CONSTRAINT fk_employees_services1 FOREIGN KEY (department_department_id)
    REFERENCES department (department_id),
  CONSTRAINT fk_employees_addresses1 FOREIGN KEY (addresses_address_id)
    REFERENCES addresses (address_id),
  CONSTRAINT fk_employees_hotel1 FOREIGN KEY (hotel_hotel_id)
    REFERENCES hotel (hotel_id)
);

CREATE INDEX IF NOT EXISTS idx_employees_department ON employees (department_department_id);
CREATE INDEX IF NOT EXISTS idx_employees_address ON employees (addresses_address_id);
CREATE INDEX IF NOT EXISTS idx_employees_hotel ON employees (hotel_hotel_id);

-- -----------------------------------------------------
-- Table bookings
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS bookings (
  booking_id SERIAL PRIMARY KEY,
  booking_date TIMESTAMP,
  duration_of_stay VARCHAR(10),
  check_in_date TIMESTAMP,
  check_out_date TIMESTAMP,
  booking_payment_type VARCHAR(45),
  total_rooms_booked INT,
  hotel_hotel_id INT NOT NULL,
  guests_guest_id INT NOT NULL,
  employees_emp_id INT NOT NULL,
  total_amount DECIMAL(10,2),
  CONSTRAINT fk_bookings_hotel1 FOREIGN KEY (hotel_hotel_id)
    REFERENCES hotel (hotel_id),
  CONSTRAINT fk_bookings_guests1 FOREIGN KEY (guests_guest_id)
    REFERENCES guests (guest_id),
  CONSTRAINT fk_bookings_employees1 FOREIGN KEY (employees_emp_id)
    REFERENCES employees (emp_id)
);

CREATE INDEX IF NOT EXISTS idx_bookings_hotel ON bookings (hotel_hotel_id);
CREATE INDEX IF NOT EXISTS idx_bookings_guests ON bookings (guests_guest_id);
CREATE INDEX IF NOT EXISTS idx_bookings_employees ON bookings (employees_emp_id);

-- -----------------------------------------------------
-- Table hotel_chain_has_hotel
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS hotel_chain_has_hotel (
  hotel_chains_hotel_chain_id INT NOT NULL,
  hotels_hotel_id INT NOT NULL,
  PRIMARY KEY (hotel_chains_hotel_chain_id, hotels_hotel_id),
  CONSTRAINT fk_hotel_chains_has_hotels_hotel_chains1 FOREIGN KEY (hotel_chains_hotel_chain_id)
    REFERENCES hotel_chain (hotel_chain_id),
  CONSTRAINT fk_hotel_chains_has_hotels_hotels1 FOREIGN KEY (hotels_hotel_id)
    REFERENCES hotel (hotel_id)
);

CREATE INDEX IF NOT EXISTS idx_hotel_chain_has_hotel_chain ON hotel_chain_has_hotel (hotel_chains_hotel_chain_id);
CREATE INDEX IF NOT EXISTS idx_hotel_chain_has_hotel ON hotel_chain_has_hotel (hotels_hotel_id);

-- -----------------------------------------------------
-- Table room_rate_discount
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS room_rate_discount (
  discount_id SERIAL PRIMARY KEY,
  discount_rate DECIMAL(10,2),
  start_month SMALLINT,
  end_month SMALLINT,
  room_type_room_type_id INT NOT NULL,
  CONSTRAINT fk_room_rate_discount_room_type1 FOREIGN KEY (room_type_room_type_id)
    REFERENCES room_type (room_type_id)
);

CREATE INDEX IF NOT EXISTS idx_room_rate_discount_room_type ON room_rate_discount (room_type_room_type_id);

-- -----------------------------------------------------
-- Table rooms_booked
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS rooms_booked (
  rooms_booked_id SERIAL PRIMARY KEY,
  bookings_booking_id INT NOT NULL,
  rooms_room_id INT NOT NULL,
  CONSTRAINT fk_rooms_booked_bookings1 FOREIGN KEY (bookings_booking_id)
    REFERENCES bookings (booking_id),
  CONSTRAINT fk_rooms_booked_rooms1 FOREIGN KEY (rooms_room_id)
    REFERENCES rooms (room_id)
);

CREATE INDEX IF NOT EXISTS idx_rooms_booked_booking ON rooms_booked (bookings_booking_id);
CREATE INDEX IF NOT EXISTS idx_rooms_booked_room ON rooms_booked (rooms_room_id);

-- -----------------------------------------------------
-- Table hotel_services
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS hotel_services (
  service_id SERIAL PRIMARY KEY,
  service_name VARCHAR(45),
  service_description VARCHAR(100),
  service_cost DECIMAL(10,2),
  hotel_hotel_id INT NOT NULL,
  CONSTRAINT fk_hotel_services_hotel1 FOREIGN KEY (hotel_hotel_id)
    REFERENCES hotel (hotel_id)
);

CREATE INDEX IF NOT EXISTS idx_hotel_services_hotel ON hotel_services (hotel_hotel_id);

-- -----------------------------------------------------
-- Table hotel_services_used_by_guests
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS hotel_services_used_by_guests (
  service_used_id SERIAL PRIMARY KEY,
  hotel_services_service_id INT NOT NULL,
  bookings_booking_id INT NOT NULL,
  CONSTRAINT fk_hotel_services_has_bookings_hotel_services1 FOREIGN KEY (hotel_services_service_id)
    REFERENCES hotel_services (service_id),
  CONSTRAINT fk_hotel_services_has_bookings_bookings1 FOREIGN KEY (bookings_booking_id)
    REFERENCES bookings (booking_id)
);

CREATE INDEX IF NOT EXISTS idx_hotel_services_used_booking ON hotel_services_used_by_guests (bookings_booking_id);
CREATE INDEX IF NOT EXISTS idx_hotel_services_used_service ON hotel_services_used_by_guests (hotel_services_service_id);

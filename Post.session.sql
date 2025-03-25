-- Create the ServiceEase database
CREATE DATABASE service_db;

-- Create the users table
CREATE TABLE users (
    ID SERIAL PRIMARY KEY,  -- Unique ID for each user
    Name VARCHAR(50) NOT NULL,  -- User's name (required)
    email VARCHAR(50) UNIQUE NOT NULL,  -- Unique email (required)
    password TEXT NOT NULL,  -- Hashed password storage (required)
    contact_number NUMERIC(10) UNIQUE NOT NULL,  -- Unique contact number (required)
    role VARCHAR(20) DEFAULT 'user' CHECK (role IN('user','admin','provider')),  -- User roles
    profile_picture TEXT DEFAULT NULL,  -- Optional profile picture
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- Timestamp of account creation
);

-- Create the services table
CREATE TABLE services (
    id SERIAL PRIMARY KEY,  -- Unique ID for each service
    provider_id INT REFERENCES users(id) ON DELETE CASCADE,  -- Service provider reference
    Name VARCHAR(50) NOT NULL,  -- Service name (required)
    description TEXT,  -- Service description (optional)
    category VARCHAR(50) NOT NULL,  -- Service category (required)
    price DECIMAL(10,2),  -- Service price
    ratings DECIMAL(3,2) CHECK (ratings BETWEEN 0 AND 5),  -- Ratings constraint (0-5 scale)
    contact_number NUMERIC(10) UNIQUE NOT NULL,  -- Unique contact number for provider
    available BOOLEAN DEFAULT TRUE,  -- Availability status
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- Timestamp of service listing
);
DROP TABLE services;
-- Create the bookings table
CREATE TABLE bookings (
    id SERIAL PRIMARY KEY,  -- Unique ID for each booking
    user_id INT REFERENCES users(id) ON DELETE CASCADE,  -- Reference to the user who booked
    service_id INT REFERENCES services(id) ON DELETE CASCADE,  -- Reference to booked service
    status VARCHAR(20) DEFAULT 'pending' CHECK(status IN('pending', 'completed', 'cancelled', 'failed')),  -- Booking status
    scheduled_time TIMESTAMP NOT NULL,  -- Scheduled time for the service
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- Timestamp of booking creation
);

-- Create the reviews table
CREATE TABLE reviews (
    id SERIAL PRIMARY KEY,  -- Unique ID for each review
    user_id INT REFERENCES users(id) ON DELETE CASCADE,  -- Reference to reviewer (user)
    service_id INT REFERENCES services(id) ON DELETE CASCADE,  -- Reference to reviewed service
    rating DECIMAL(3,2) CHECK (rating BETWEEN 0 AND 5) NOT NULL,  -- Rating with constraint
    review_text TEXT,  -- Optional review text
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- Timestamp of review creation
);

-- Create the payments table
CREATE TABLE payments (
    id SERIAL PRIMARY KEY,  -- Unique ID for each payment
    user_id INT REFERENCES users(id) ON DELETE CASCADE,  -- Reference to user making the payment
    booking_id INT REFERENCES bookings(id) ON DELETE CASCADE,  -- Reference to related booking
    amount DECIMAL(10,2) NOT NULL,  -- Payment amount
    payment_method VARCHAR(50) CHECK (payment_method IN ('Credit Card', 'Debit Card', 'UPI', 'Net Banking', 'PayPal', 'Cash')),  -- Payment method constraints
    payment_status VARCHAR(20) DEFAULT 'pending' CHECK (payment_status IN ('pending', 'success', 'failed', 'refunded')),  -- Payment status
    transaction_id VARCHAR(100) UNIQUE NOT NULL,  -- Unique transaction ID
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- Timestamp of payment
);
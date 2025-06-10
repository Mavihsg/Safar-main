CREATE DATABASE bus_reservation_db;
USE bus_reservation_db;

SELECT * FROM Admin;
SELECT * FROM User;
SELECT * FROM Route;
SELECT * FROM Bus;
SELECT * FROM Reservation;
SELECT * FROM Feedback;

-- Drop existing tables in reverse order of dependencies
-- DROP TABLE IF EXISTS Feedback;
-- DROP TABLE IF EXISTS Reservation;
-- DROP TABLE IF EXISTS Bus;
-- DROP TABLE IF EXISTS Route;
-- DROP TABLE IF EXISTS User;
-- DROP TABLE IF EXISTS Admin;

-- Create Admin table with auto_increment
CREATE TABLE Admin (
    adminID INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);

-- Create User table with auto_increment
CREATE TABLE User (
    userID INT PRIMARY KEY AUTO_INCREMENT,
    firstName VARCHAR(255) NOT NULL,
    lastName VARCHAR(255) NOT NULL,
    mobile VARCHAR(20) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);

-- Create Route table with auto_increment
CREATE TABLE Route (
    routeID INT PRIMARY KEY AUTO_INCREMENT,
    routeFrom VARCHAR(255) NOT NULL,
    routeTO VARCHAR(255) NOT NULL,
    distance INT NOT NULL
);

-- Create Bus table with auto_increment
CREATE TABLE Bus (
    busId INT PRIMARY KEY AUTO_INCREMENT,
    busName VARCHAR(255) NOT NULL,
    driverName VARCHAR(255) NOT NULL,
    busType VARCHAR(50) NOT NULL,
    routeFrom VARCHAR(255) NOT NULL,
    routeTo VARCHAR(255) NOT NULL,
    busJourneyDate DATE NOT NULL,
    arrivalTime TIME NOT NULL,
    departureTime TIME NOT NULL,
    seats INT NOT NULL,
    availableSeats INT NOT NULL,
    fare DECIMAL(10,2) NOT NULL,
    routeID INT,
    FOREIGN KEY (routeID) REFERENCES Route(routeID)
);

-- Create Reservation table with auto_increment
CREATE TABLE Reservation (
    reservationID INT PRIMARY KEY AUTO_INCREMENT,
    status VARCHAR(50) NOT NULL,
    date DATE NOT NULL,
    time TIME NOT NULL,
    source VARCHAR(255) NOT NULL,
    destination VARCHAR(255) NOT NULL,
    journeyDate DATETIME NOT NULL,
    bookedSeat INT NOT NULL,
    Fare DECIMAL(10,2) NOT NULL,
    userID INT,
    busId INT,
    FOREIGN KEY (userID) REFERENCES User(userID),
    FOREIGN KEY (busId) REFERENCES Bus(busId)
);

-- Create Feedback table with auto_increment
CREATE TABLE Feedback (
    feedbackID INT PRIMARY KEY AUTO_INCREMENT,
    driverRating INT CHECK (driverRating BETWEEN 1 AND 5),
    serviceRating INT CHECK (serviceRating BETWEEN 1 AND 5),
    overallRating INT CHECK (overallRating BETWEEN 1 AND 5),
    comments TEXT,
    feedbackDateTime DATETIME NOT NULL,
    userID INT,
    busId INT,
    FOREIGN KEY (userID) REFERENCES User(userID),
    FOREIGN KEY (busId) REFERENCES Bus(busId)
);

-- Insert Admin data
INSERT INTO Admin (name, email, password) VALUES 
('Shivam Gupta', 'shivamgupta@busservice.in', 'qwerty1234'),
('Priya Sharma', 'priya.admin@busservice.in', 'hashed_password_456'),
('Amit Patel', 'amit.admin@busservice.in', 'hashed_password_789');

-- Insert Routes
INSERT INTO Route (routeFrom, routeTO, distance) VALUES 
('Mumbai', 'Pune', 150),
('Delhi', 'Jaipur', 281),
('Bangalore', 'Chennai', 346),
('Hyderabad', 'Bangalore', 570),
('Delhi', 'Agra', 233);

-- Insert Users
INSERT INTO User (firstName, lastName, mobile, email, password) VALUES 
('Arun', 'Verma', '9876543210', 'arun.verma@gmail.com', 'hashed_pwd_1'),
('Deepa', 'Krishnan', '8765432109', 'deepa.k@gmail.com', 'hashed_pwd_2'),
('Suresh', 'Patel', '7654321098', 'suresh.patel@gmail.com', 'hashed_pwd_3'),
('Meera', 'Singh', '9876543211', 'meera.singh@yahoo.com', 'hashed_pwd_4'),
('Karthik', 'Raman', '8876543212', 'karthik.r@gmail.com', 'hashed_pwd_5');

-- Insert Buses (using current date + 1 day for journey dates)
INSERT INTO Bus (busName, driverName, busType, routeFrom, routeTo, busJourneyDate, 
                arrivalTime, departureTime, seats, availableSeats, fare, routeID) VALUES 
('Volvo-9400', 'Ramesh Kumar', 'AC Sleeper', 'Mumbai', 'Pune', '2025-06-11', 
 '08:00:00', '06:00:00', 40, 40, 800.00, 1),
('Ashok-Express', 'Sunil Yadav', 'AC Seater', 'Delhi', 'Jaipur', '2025-06-11', 
 '14:00:00', '10:00:00', 45, 45, 1200.00, 2),
('Royal-Cruiser', 'Vijay Singh', 'AC Sleeper', 'Bangalore', 'Chennai', '2025-06-11', 
 '23:00:00', '19:00:00', 38, 38, 1500.00, 3);

-- Insert Reservations (using current date/time for booking timestamp)
INSERT INTO Reservation (status, date, time, source, destination, journeyDate, 
                        bookedSeat, Fare, userID, busId) VALUES 
('CONFIRMED', '2025-06-10', '04:03:17', 'Mumbai', 'Pune', '2025-06-11 06:00:00', 
 12, 800.00, 1, 1),
('CONFIRMED', '2025-06-10', '04:03:17', 'Delhi', 'Jaipur', '2025-06-11 10:00:00', 
 15, 1200.00, 2, 2),
('CONFIRMED', '2025-06-10', '04:03:17', 'Bangalore', 'Chennai', '2025-06-11 19:00:00', 
 8, 1500.00, 3, 3);

-- Insert Feedback (using current date/time for feedback timestamp)
INSERT INTO Feedback (driverRating, serviceRating, overallRating, comments, 
                     feedbackDateTime, userID, busId) VALUES 
(5, 4, 5, 'Very comfortable journey, driver was very professional', 
 '2025-06-10 04:03:17', 1, 1),
(4, 5, 4, 'Good service, bus was clean and on time', 
 '2025-06-10 04:03:17', 2, 2),
(5, 5, 5, 'Excellent journey experience, will travel again', 
 '2025-06-10 04:03:17', 3, 3);

-- Update available seats
UPDATE Bus 
SET availableSeats = seats - (
    SELECT COUNT(*) 
    FROM Reservation 
    WHERE Reservation.busId = Bus.busId 
    AND status = 'CONFIRMED'
);

-- Create indexes for better performance
CREATE INDEX idx_bus_route ON Bus(routeID);
CREATE INDEX idx_reservation_user ON Reservation(userID);
CREATE INDEX idx_reservation_bus ON Reservation(busId);
CREATE INDEX idx_feedback_user ON Feedback(userID);
CREATE INDEX idx_feedback_bus ON Feedback(busId);
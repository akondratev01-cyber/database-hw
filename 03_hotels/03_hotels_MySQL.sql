-- =========================================================
-- БД 3. Бронирование отелей
-- Файл: 03_hotels_MySQL.sql
-- Назначение: создание структуры БД, заполнение данными
--             и выполнение SQL-запросов по заданиям
-- СУБД: MySQL / MariaDB
-- =========================================================

USE hotels_db;

-- =========================================================
-- Удаление таблиц при повторном прогоне
-- =========================================================

DROP TABLE IF EXISTS Booking;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Room;
DROP TABLE IF EXISTS Hotel;

-- =========================================================
-- Создание таблиц
-- =========================================================

-- Создание таблицы Hotel
CREATE TABLE Hotel (
    ID_hotel INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL
);

-- Создание таблицы Room
CREATE TABLE Room (
    ID_room INT PRIMARY KEY,
    ID_hotel INT,
    room_type ENUM('Single', 'Double', 'Suite') NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    capacity INT NOT NULL,
    FOREIGN KEY (ID_hotel) REFERENCES Hotel(ID_hotel)
);

-- Создание таблицы Customer
CREATE TABLE Customer (
    ID_customer INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL
);

-- Создание таблицы Booking
CREATE TABLE Booking (
    ID_booking INT PRIMARY KEY,
    ID_room INT,
    ID_customer INT,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    FOREIGN KEY (ID_room) REFERENCES Room(ID_room),
    FOREIGN KEY (ID_customer) REFERENCES Customer(ID_customer)
);

-- =========================================================
-- Наполнение таблиц данными
-- =========================================================

-- Вставка данных в таблицу Hotel
INSERT INTO Hotel (ID_hotel, name, location) VALUES
(1, 'Grand Hotel', 'Paris, France'),
(2, 'Ocean View Resort', 'Miami, USA'),
(3, 'Mountain Retreat', 'Aspen, USA'),
(4, 'City Center Inn', 'New York, USA'),
(5, 'Desert Oasis', 'Las Vegas, USA'),
(6, 'Lakeside Lodge', 'Lake Tahoe, USA'),
(7, 'Historic Castle', 'Edinburgh, Scotland'),
(8, 'Tropical Paradise', 'Bali, Indonesia'),
(9, 'Business Suites', 'Tokyo, Japan'),
(10, 'Eco-Friendly Hotel', 'Copenhagen, Denmark');

-- Вставка данных в таблицу Room
INSERT INTO Room (ID_room, ID_hotel, room_type, price, capacity) VALUES
(1, 1, 'Single', 150.00, 1),
(2, 1, 'Double', 200.00, 2),
(3, 1, 'Suite', 350.00, 4),
(4, 2, 'Single', 120.00, 1),
(5, 2, 'Double', 180.00, 2),
(6, 2, 'Suite', 300.00, 4),
(7, 3, 'Double', 250.00, 2),
(8, 3, 'Suite', 400.00, 4),
(9, 4, 'Single', 100.00, 1),
(10, 4, 'Double', 150.00, 2),
(11, 5, 'Single', 90.00, 1),
(12, 5, 'Double', 140.00, 2),
(13, 6, 'Suite', 280.00, 4),
(14, 7, 'Double', 220.00, 2),
(15, 8, 'Single', 130.00, 1),
(16, 8, 'Double', 190.00, 2),
(17, 9, 'Suite', 360.00, 4),
(18, 10, 'Single', 110.00, 1),
(19, 10, 'Double', 160.00, 2);

-- Вставка данных в таблицу Customer
INSERT INTO Customer (ID_customer, name, email, phone) VALUES
(1, 'John Doe', 'john.doe@example.com', '+1234567890'),
(2, 'Jane Smith', 'jane.smith@example.com', '+0987654321'),
(3, 'Alice Johnson', 'alice.johnson@example.com', '+1122334455'),
(4, 'Bob Brown', 'bob.brown@example.com', '+2233445566'),
(5, 'Charlie White', 'charlie.white@example.com', '+3344556677'),
(6, 'Diana Prince', 'diana.prince@example.com', '+4455667788'),
(7, 'Ethan Hunt', 'ethan.hunt@example.com', '+5566778899'),
(8, 'Fiona Apple', 'fiona.apple@example.com', '+6677889900'),
(9, 'George Washington', 'george.washington@example.com', '+7788990011'),
(10, 'Hannah Montana', 'hannah.montana@example.com', '+8899001122');

-- Вставка данных в таблицу Booking с разнообразием клиентов
INSERT INTO Booking (ID_booking, ID_room, ID_customer, check_in_date, check_out_date) VALUES
(1, 1, 1, '2025-05-01', '2025-05-05'),  -- 4 ночи, John Doe
(2, 2, 2, '2025-05-02', '2025-05-06'),  -- 4 ночи, Jane Smith
(3, 3, 3, '2025-05-03', '2025-05-07'),  -- 4 ночи, Alice Johnson
(4, 4, 4, '2025-05-04', '2025-05-08'),  -- 4 ночи, Bob Brown
(5, 5, 5, '2025-05-05', '2025-05-09'),  -- 4 ночи, Charlie White
(6, 6, 6, '2025-05-06', '2025-05-10'),  -- 4 ночи, Diana Prince
(7, 7, 7, '2025-05-07', '2025-05-11'),  -- 4 ночи, Ethan Hunt
(8, 8, 8, '2025-05-08', '2025-05-12'),  -- 4 ночи, Fiona Apple
(9, 9, 9, '2025-05-09', '2025-05-13'),  -- 4 ночи, George Washington
(10, 10, 10, '2025-05-10', '2025-05-14'),  -- 4 ночи, Hannah Montana
(11, 1, 2, '2025-05-11', '2025-05-15'),  -- 4 ночи, Jane Smith
(12, 2, 3, '2025-05-12', '2025-05-14'),  -- 2 ночи, Alice Johnson
(13, 3, 4, '2025-05-13', '2025-05-15'),  -- 2 ночи, Bob Brown
(14, 4, 5, '2025-05-14', '2025-05-16'),  -- 2 ночи, Charlie White
(15, 5, 6, '2025-05-15', '2025-05-16'),  -- 1 ночь, Diana Prince
(16, 6, 7, '2025-05-16', '2025-05-18'),  -- 2 ночи, Ethan Hunt
(17, 7, 8, '2025-05-17', '2025-05-21'),  -- 4 ночи, Fiona Apple
(18, 8, 9, '2025-05-18', '2025-05-19'),  -- 1 ночь, George Washington
(19, 9, 10, '2025-05-19', '2025-05-22'),  -- 3 ночи, Hannah Montana
(20, 10, 1, '2025-05-20', '2025-05-22'), -- 2 ночи, John Doe
(21, 1, 2, '2025-05-21', '2025-05-23'),  -- 2 ночи, Jane Smith
(22, 2, 3, '2025-05-22', '2025-05-25'),  -- 3 ночи, Alice Johnson
(23, 3, 4, '2025-05-23', '2025-05-26'),  -- 3 ночи, Bob Brown
(24, 4, 5, '2025-05-24', '2025-05-25'),  -- 1 ночь, Charlie White
(25, 5, 6, '2025-05-25', '2025-05-27'),  -- 2 ночи, Diana Prince
(26, 6, 7, '2025-05-26', '2025-05-29');  -- 3 ночи, Ethan Hunt

-- =========================================================
-- Задача 1
-- Найти клиентов, сделавших более двух бронирований
-- в разных отелях, со списком отелей и средней длительностью проживания
-- =========================================================
SELECT
	c.name,
	c.email,
	c.phone,
	COUNT(*) AS total_bookings,
	GROUP_CONCAT(DISTINCT h.name ORDER BY h.name SEPARATOR ', ') AS hotel_list,
	ROUND(AVG(DATEDIFF(b.check_out_date, b.check_in_date)), 4) AS avg_stay_days
FROM
	Customer c
JOIN Booking b ON
	c.ID_customer = b.ID_customer
JOIN Room r ON
	b.ID_room = r.ID_room
JOIN Hotel h ON
	r.ID_hotel = h.ID_hotel
GROUP BY
	c.ID_customer,
	c.name,
	c.email,
	c.phone
HAVING
	COUNT(*) > 2
	AND COUNT(DISTINCT h.ID_hotel) > 1
ORDER BY
	total_bookings DESC;

-- =========================================================
-- Задача 2
-- Найти клиентов, которые сделали более двух бронирований
-- в разных отелях и потратили более 500 долларов
-- =========================================================
SELECT
	c.ID_customer,
	c.name,
	COUNT(*) AS total_bookings,
	ROUND(SUM(r.price), 2) AS total_spent,
	COUNT(DISTINCT h.ID_hotel) AS unique_hotels
FROM
	Customer c
JOIN Booking b ON
	c.ID_customer = b.ID_customer
JOIN Room r ON
	b.ID_room = r.ID_room
JOIN Hotel h ON
	r.ID_hotel = h.ID_hotel
GROUP BY
	c.ID_customer,
	c.name
HAVING
	COUNT(*) > 2
	AND COUNT(DISTINCT h.ID_hotel) > 1
	AND SUM(r.price) > 500
ORDER BY
	total_spent ASC;

-- =========================================================
-- Задача 3
-- Определить предпочитаемый тип отелей для каждого клиента
-- и вывести список посещённых отелей
-- =========================================================
SELECT
	customer_hotels.ID_customer,
	customer_hotels.name,
	CASE
		WHEN MAX(CASE WHEN hotel_categories.hotel_category = 'Дорогой' THEN 1 ELSE 0 END) = 1 THEN 'Дорогой'
		WHEN MAX(CASE WHEN hotel_categories.hotel_category = 'Средний' THEN 1 ELSE 0 END) = 1 THEN 'Средний'
		ELSE 'Дешевый'
	END AS preferred_hotel_type,
	GROUP_CONCAT(DISTINCT customer_hotels.hotel_name ORDER BY customer_hotels.hotel_name SEPARATOR ', ') AS visited_hotels
FROM
	(
	SELECT
		c.ID_customer,
		c.name,
		h.ID_hotel,
		h.name AS hotel_name
	FROM
		Customer c
	JOIN Booking b ON
		c.ID_customer = b.ID_customer
	JOIN Room r ON
		b.ID_room = r.ID_room
	JOIN Hotel h ON
		r.ID_hotel = h.ID_hotel
) AS customer_hotels
JOIN (
	SELECT
		h.ID_hotel,
		CASE
			WHEN AVG(r.price) < 175 THEN 'Дешевый'
			WHEN AVG(r.price) <= 300 THEN 'Средний'
			ELSE 'Дорогой'
		END AS hotel_category
	FROM
		Hotel h
	JOIN Room r ON
		h.ID_hotel = r.ID_hotel
	GROUP BY
		h.ID_hotel
) AS hotel_categories
    ON
	customer_hotels.ID_hotel = hotel_categories.ID_hotel
GROUP BY
	customer_hotels.ID_customer,
	customer_hotels.name
ORDER BY
	CASE
		WHEN CASE
			WHEN MAX(CASE WHEN hotel_categories.hotel_category = 'Дорогой' THEN 1 ELSE 0 END) = 1 THEN 'Дорогой'
			WHEN MAX(CASE WHEN hotel_categories.hotel_category = 'Средний' THEN 1 ELSE 0 END) = 1 THEN 'Средний'
			ELSE 'Дешевый'
		END = 'Дешевый' THEN 1
		WHEN CASE
			WHEN MAX(CASE WHEN hotel_categories.hotel_category = 'Дорогой' THEN 1 ELSE 0 END) = 1 THEN 'Дорогой'
			WHEN MAX(CASE WHEN hotel_categories.hotel_category = 'Средний' THEN 1 ELSE 0 END) = 1 THEN 'Средний'
			ELSE 'Дешевый'
		END = 'Средний' THEN 2
		ELSE 3
	END,
	customer_hotels.ID_customer;
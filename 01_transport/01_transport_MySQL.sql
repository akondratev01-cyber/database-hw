-- =========================================================
-- БД 1. Транспортные средства
-- Файл: 01_transport_MySQL.sql
-- Назначение: полный SQL-скрипт по заданию
--             (создание таблиц, наполнение, решение задач)
-- СУБД: MySQL / MariaDB
-- =========================================================

USE transport_db;

-- =========================================================
-- Удаление таблиц при повторном прогоне
-- =========================================================
DROP TABLE IF EXISTS Bicycle;
DROP TABLE IF EXISTS Motorcycle;
DROP TABLE IF EXISTS Car;
DROP TABLE IF EXISTS Vehicle;

-- =========================================================
-- Создание таблиц
-- =========================================================

-- Создание таблицы Vehicle

CREATE TABLE Vehicle (
    maker VARCHAR(100) NOT NULL,
    model VARCHAR(100) NOT NULL,
    type ENUM('Car', 'Motorcycle', 'Bicycle') NOT NULL,
    PRIMARY KEY (model)
);

-- Создание таблицы Car

CREATE TABLE Car (
    vin VARCHAR(17) NOT NULL,
    model VARCHAR(100) NOT NULL,
    engine_capacity DECIMAL(4, 2) NOT NULL, -- объем двигателя в литрах
    horsepower INT NOT NULL,                 -- мощность в лошадиных силах
    price DECIMAL(10, 2) NOT NULL,           -- цена в долларах
    transmission ENUM('Automatic', 'Manual') NOT NULL, -- тип трансмиссии
    PRIMARY KEY (vin),
    FOREIGN KEY (model) REFERENCES Vehicle(model)
);

-- Создание таблицы Motorcycle

CREATE TABLE Motorcycle (
    vin VARCHAR(17) NOT NULL,
    model VARCHAR(100) NOT NULL,
    engine_capacity DECIMAL(4, 2) NOT NULL, -- объем двигателя в литрах
    horsepower INT NOT NULL,                 -- мощность в лошадиных силах
    price DECIMAL(10, 2) NOT NULL,           -- цена в долларах
    type ENUM('Sport', 'Cruiser', 'Touring') NOT NULL, -- тип мотоцикла
    PRIMARY KEY (vin),
    FOREIGN KEY (model) REFERENCES Vehicle(model)
);

-- Создание таблицы Bicycle

CREATE TABLE Bicycle (
    serial_number VARCHAR(20) NOT NULL,
    model VARCHAR(100) NOT NULL,
    gear_count INT NOT NULL,                 -- количество передач
    price DECIMAL(10, 2) NOT NULL,           -- цена в долларах
    type ENUM('Mountain', 'Road', 'Hybrid') NOT NULL, -- тип велосипеда
    PRIMARY KEY (serial_number),
    FOREIGN KEY (model) REFERENCES Vehicle(model)
);

-- =========================================================
-- Наполнение таблиц данными
-- =========================================================

-- Вставка данных в таблицу Vehicle
INSERT INTO Vehicle (maker, model, type) VALUES
('Toyota', 'Camry', 'Car'),
('Honda', 'Civic', 'Car'),
('Ford', 'Mustang', 'Car'),
('Yamaha', 'YZF-R1', 'Motorcycle'),
('Harley-Davidson', 'Sportster', 'Motorcycle'),
('Kawasaki', 'Ninja', 'Motorcycle'),
('Trek', 'Domane', 'Bicycle'),
('Giant', 'Defy', 'Bicycle'),
('Specialized', 'Stumpjumper', 'Bicycle');

-- Вставка данных в таблицу Car
INSERT INTO Car (vin, model, engine_capacity, horsepower, price, transmission) VALUES
('1HGCM82633A123456', 'Camry', 2.5, 203, 24000.00, 'Automatic'),
('2HGFG3B53GH123456', 'Civic', 2.0, 158, 22000.00, 'Manual'),
('1FA6P8CF0J1234567', 'Mustang', 5.0, 450, 55000.00, 'Automatic');

-- Вставка данных в таблицу Motorcycle
INSERT INTO Motorcycle (vin, model, engine_capacity, horsepower, price, type) VALUES
('JYARN28E9FA123456', 'YZF-R1', 1.0, 200, 17000.00, 'Sport'),
('1HD1ZK3158K123456', 'Sportster', 1.2, 70, 12000.00, 'Cruiser'),
('JKBVNAF156A123456', 'Ninja', 0.9, 150, 14000.00, 'Sport');

-- Вставка данных в таблицу Bicycle
INSERT INTO Bicycle (serial_number, model, gear_count, price, type) VALUES
('SN123456789', 'Domane', 22, 3500.00, 'Road'),
('SN987654321', 'Defy', 20, 3000.00, 'Road'),
('SN456789123', 'Stumpjumper', 30, 4000.00, 'Mountain');

-- =========================================================
-- Задача 1
-- Вывести производителей и модели спортивных мотоциклов
-- с мощностью более 150 л.с. и ценой менее 20000
-- =========================================================
SELECT v.maker, v.model
FROM Vehicle v
JOIN Motorcycle m ON v.model = m.model
WHERE m.horsepower > 150
  AND m.price < 20000
  AND m.type = 'Sport'
ORDER BY m.horsepower DESC;

-- =========================================================
-- Задача 2
-- Вывести автомобили, мотоциклы и велосипеды,
-- соответствующие условиям задания, в одном наборе данных
-- =========================================================
SELECT *
FROM (
    SELECT
        v.maker,
        v.model,
        c.horsepower,
        c.engine_capacity,
        'Car' AS vehicle_type
    FROM Vehicle v
    JOIN Car c ON v.model = c.model
    WHERE c.horsepower > 150
      AND c.engine_capacity < 3
      AND c.price < 35000
    UNION ALL
    SELECT
        v.maker,
        v.model,
        m.horsepower,
        m.engine_capacity,
        'Motorcycle' AS vehicle_type
    FROM Vehicle v
    JOIN Motorcycle m ON v.model = m.model
    WHERE m.horsepower > 150
      AND m.engine_capacity < 1.5
      AND m.price < 20000
    UNION ALL
    SELECT
        v.maker,
        v.model,
        NULL AS horsepower,
        NULL AS engine_capacity,
        'Bicycle' AS vehicle_type
    FROM Vehicle v
    JOIN Bicycle b ON v.model = b.model
    WHERE b.gear_count > 18
      AND b.price < 4000
) AS result
ORDER BY horsepower IS NULL, 
	horsepower DESC, 
    CASE WHEN horsepower is null then maker END DESC;
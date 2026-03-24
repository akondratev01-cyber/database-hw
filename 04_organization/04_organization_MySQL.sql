-- =========================================================
-- База данных 4. Структура организации
-- Файл: 04_organization_MySQL.sql
-- Назначение: создание структуры БД, заполнение данными
--             и выполнение SQL-запросов по заданиям
-- СУБД: MariaDB / MySQL
-- =========================================================

USE organization_db;

-- =========================================================
-- Удаление таблиц при повторном прогоне
-- =========================================================

DROP TABLE IF EXISTS Tasks;
DROP TABLE IF EXISTS Projects;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Roles;
DROP TABLE IF EXISTS Departments;

-- =========================================================
-- Создание таблиц
-- =========================================================

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL
);

CREATE TABLE Roles (
    RoleID INT PRIMARY KEY,
    RoleName VARCHAR(100) NOT NULL
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Position VARCHAR(100),
    ManagerID INT,
    DepartmentID INT,
    RoleID INT,
    FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
);

CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100) NOT NULL,
    StartDate DATE,
    EndDate DATE,
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Tasks (
    TaskID INT PRIMARY KEY,
    TaskName VARCHAR(100) NOT NULL,
    AssignedTo INT,
    ProjectID INT,
    FOREIGN KEY (AssignedTo) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);

-- =========================================================
-- Наполнение таблиц данными
-- =========================================================

-- Добавление отделов
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'Отдел продаж'),
(2, 'Отдел маркетинга'),
(3, 'IT-отдел'),
(4, 'Отдел разработки'),
(5, 'Отдел поддержки');

-- Добавление ролей
INSERT INTO Roles (RoleID, RoleName) VALUES
(1, 'Менеджер'),
(2, 'Директор'),
(3, 'Генеральный директор'),
(4, 'Разработчик'),
(5, 'Специалист по поддержке'),
(6, 'Маркетолог');

-- Добавление сотрудников
INSERT INTO Employees (EmployeeID, Name, Position, ManagerID, DepartmentID, RoleID) VALUES
(1, 'Иван Иванов', 'Генеральный директор', NULL, 1, 3),
(2, 'Петр Петров', 'Директор по продажам', 1, 1, 2),
(3, 'Светлана Светлова', 'Директор по маркетингу', 1, 2, 2),
(4, 'Алексей Алексеев', 'Менеджер по продажам', 2, 1, 1),
(5, 'Мария Мариева', 'Менеджер по маркетингу', 3, 2, 1),
(6, 'Андрей Андреев', 'Разработчик', 1, 4, 4),
(7, 'Елена Еленова', 'Специалист по поддержке', 1, 5, 5),
(8, 'Олег Олегов', 'Менеджер по продукту', 2, 1, 1),
(9, 'Татьяна Татеева', 'Маркетолог', 3, 2, 6),
(10, 'Николай Николаев', 'Разработчик', 6, 4, 4),
(11, 'Ирина Иринина', 'Разработчик', 6, 4, 4),
(12, 'Сергей Сергеев', 'Специалист по поддержке', 7, 5, 5),
(13, 'Кристина Кристинина', 'Менеджер по продажам', 4, 1, 1),
(14, 'Дмитрий Дмитриев', 'Маркетолог', 3, 2, 6),
(15, 'Виктор Викторов', 'Менеджер по продажам', 4, 1, 1),
(16, 'Анастасия Анастасиева', 'Специалист по поддержке', 7, 5, 5),
(17, 'Максим Максимов', 'Разработчик', 6, 4, 4),
(18, 'Людмила Людмилова', 'Специалист по маркетингу', 3, 2, 6),
(19, 'Наталья Натальева', 'Менеджер по продажам', 4, 1, 1),
(20, 'Александр Александров', 'Менеджер по маркетингу', 3, 2, 1),
(21, 'Галина Галина', 'Специалист по поддержке', 7, 5, 5),
(22, 'Павел Павлов', 'Разработчик', 6, 4, 4),
(23, 'Марина Маринина', 'Специалист по маркетингу', 3, 2, 6),
(24, 'Станислав Станиславов', 'Менеджер по продажам', 4, 1, 1),
(25, 'Екатерина Екатеринина', 'Специалист по поддержке', 7, 5, 5),
(26, 'Денис Денисов', 'Разработчик', 6, 4, 4),
(27, 'Ольга Ольгина', 'Маркетолог', 3, 2, 6),
(28, 'Игорь Игорев', 'Менеджер по продукту', 2, 1, 1),
(29, 'Анастасия Анастасиевна', 'Специалист по поддержке', 7, 5, 5),
(30, 'Валентин Валентинов', 'Разработчик', 6, 4, 4);

-- Добавление проектов
INSERT INTO Projects (ProjectID, ProjectName, StartDate, EndDate, DepartmentID) VALUES
(1, 'Проект A', '2025-01-01', '2025-12-31', 1),
(2, 'Проект B', '2025-02-01', '2025-11-30', 2),
(3, 'Проект C', '2025-03-01', '2025-10-31', 4),
(4, 'Проект D', '2025-04-01', '2025-09-30', 5),
(5, 'Проект E', '2025-05-01', '2025-08-31', 3);

-- Добавление задач
INSERT INTO Tasks (TaskID, TaskName, AssignedTo, ProjectID) VALUES
(1, 'Задача 1: Подготовка отчета по продажам', 4, 1),
(2, 'Задача 2: Анализ рынка', 9, 2),
(3, 'Задача 3: Разработка нового функционала', 10, 3),
(4, 'Задача 4: Поддержка клиентов', 12, 4),
(5, 'Задача 5: Создание рекламной кампании', 5, 2),
(6, 'Задача 6: Обновление документации', 6, 3),
(7, 'Задача 7: Проведение тренинга для сотрудников', 8, 1),
(8, 'Задача 8: Тестирование нового продукта', 11, 3),
(9, 'Задача 9: Ответы на запросы клиентов', 12, 4),
(10, 'Задача 10: Подготовка маркетинговых материалов', 9, 2),
(11, 'Задача 11: Интеграция с новым API', 10, 3),
(12, 'Задача 12: Настройка системы поддержки', 7, 5),
(13, 'Задача 13: Проведение анализа конкурентов', 9, 2),
(14, 'Задача 14: Создание презентации для клиентов', 4, 1),
(15, 'Задача 15: Обновление сайта', 6, 3);

-- =========================================================
-- База данных 4. Структура организации
-- Задача 1
-- Найти всех сотрудников в иерархии Ивана Иванова
-- =========================================================
WITH RECURSIVE employee_hierarchy AS (
-- сам Иван Иванов
SELECT
	e.EmployeeID,
	e.Name,
	e.ManagerID,
	e.DepartmentID,
	e.RoleID
FROM
	Employees e
WHERE
	e.EmployeeID = 1
UNION ALL
-- все его подчиненные, затем подчиненные подчиненных и т.д.
SELECT
	e.EmployeeID,
	e.Name,
	e.ManagerID,
	e.DepartmentID,
	e.RoleID
FROM
	Employees e
INNER JOIN employee_hierarchy eh
        ON
	e.ManagerID = eh.EmployeeID
)
SELECT
	eh.EmployeeID,
	eh.Name AS EmployeeName,
	eh.ManagerID,
	d.DepartmentName,
	r.RoleName,
	p.ProjectNames,
	t.TaskNames
FROM
	employee_hierarchy eh
LEFT JOIN Departments d
    ON
	eh.DepartmentID = d.DepartmentID
LEFT JOIN Roles r
    ON
	eh.RoleID = r.RoleID
LEFT JOIN (
	SELECT
		e.EmployeeID,
		GROUP_CONCAT(DISTINCT p.ProjectName ORDER BY p.ProjectName SEPARATOR ', ') AS ProjectNames
	FROM
		Employees e
	LEFT JOIN Projects p
        ON
		e.DepartmentID = p.DepartmentID
	GROUP BY
		e.EmployeeID
) p
    ON
	eh.EmployeeID = p.EmployeeID
LEFT JOIN (
	SELECT
		t.AssignedTo AS EmployeeID,
		GROUP_CONCAT(DISTINCT t.TaskName ORDER BY t.TaskName SEPARATOR ', ') AS TaskNames
	FROM
		Tasks t
	GROUP BY
		t.AssignedTo
) t
    ON
	eh.EmployeeID = t.EmployeeID
ORDER BY
	eh.Name;

-- =========================================================
-- База данных 4. Структура организации
-- Задача 2
-- Иерархия сотрудников Ивана Иванова с проектами, задачами,
-- количеством задач и количеством прямых подчиненных
-- =========================================================
WITH RECURSIVE employee_hierarchy AS (
SELECT
	e.EmployeeID,
	e.Name,
	e.ManagerID,
	e.DepartmentID,
	e.RoleID
FROM
	Employees e
WHERE
	e.EmployeeID = 1
UNION ALL
SELECT
	e.EmployeeID,
	e.Name,
	e.ManagerID,
	e.DepartmentID,
	e.RoleID
FROM
	Employees e
INNER JOIN employee_hierarchy eh
        ON
	e.ManagerID = eh.EmployeeID
)
SELECT
	eh.EmployeeID,
	eh.Name AS EmployeeName,
	eh.ManagerID,
	d.DepartmentName,
	r.RoleName,
	p.ProjectNames,
	t.TaskNames,
	COALESCE(t.TotalTasks, 0) AS TotalTasks,
	COALESCE(s.TotalSubordinates, 0) AS TotalSubordinates
FROM
	employee_hierarchy eh
LEFT JOIN Departments d
    ON
	eh.DepartmentID = d.DepartmentID
LEFT JOIN Roles r
    ON
	eh.RoleID = r.RoleID
LEFT JOIN (
	SELECT
		e.EmployeeID,
		GROUP_CONCAT(DISTINCT p.ProjectName ORDER BY p.ProjectName SEPARATOR ', ') AS ProjectNames
	FROM
		Employees e
	LEFT JOIN Projects p
        ON
		e.DepartmentID = p.DepartmentID
	GROUP BY
		e.EmployeeID
) p
    ON
	eh.EmployeeID = p.EmployeeID
LEFT JOIN (
	SELECT
		t.AssignedTo AS EmployeeID,
		GROUP_CONCAT(DISTINCT t.TaskName ORDER BY t.TaskName SEPARATOR ', ') AS TaskNames,
		COUNT(t.TaskID) AS TotalTasks
	FROM
		Tasks t
	GROUP BY
		t.AssignedTo
) t
    ON
	eh.EmployeeID = t.EmployeeID
LEFT JOIN (
	SELECT
		e.ManagerID,
		COUNT(*) AS TotalSubordinates
	FROM
		Employees e
	WHERE
		e.ManagerID IS NOT NULL
	GROUP BY
		e.ManagerID
) s
    ON
	eh.EmployeeID = s.ManagerID
ORDER BY
	eh.Name;

-- =========================================================
-- База данных 4. Структура организации
-- Задача 3
-- Сотрудники с ролью менеджера, у которых есть подчиненные
-- (с выводом проектов, задач и общего количества подчиненных,
-- включая всю шлубину иерархии)
-- =========================================================
WITH RECURSIVE subordinate_hierarchy AS (
-- прямые подчиненные для каждого сотрудника
SELECT
	e.EmployeeID AS RootEmployeeID,
	sub.EmployeeID AS SubordinateID
FROM
	Employees e
JOIN Employees sub
        ON
	sub.ManagerID = e.EmployeeID
UNION ALL
-- подчиненные подчиненных и далее по иерархии
SELECT
	sh.RootEmployeeID,
	sub.EmployeeID AS SubordinateID
FROM
	subordinate_hierarchy sh
JOIN Employees sub
        ON
	sub.ManagerID = sh.SubordinateID
)
SELECT
	e.EmployeeID,
	e.Name AS EmployeeName,
	e.ManagerID,
	d.DepartmentName,
	r.RoleName,
	p.ProjectNames,
	t.TaskNames,
	COUNT(DISTINCT sh.SubordinateID) AS TotalSubordinates
FROM
	Employees e
JOIN Roles r
    ON
	e.RoleID = r.RoleID
LEFT JOIN Departments d
    ON
	e.DepartmentID = d.DepartmentID
LEFT JOIN subordinate_hierarchy sh
    ON
	e.EmployeeID = sh.RootEmployeeID
LEFT JOIN (
	SELECT
		e2.EmployeeID,
		GROUP_CONCAT(DISTINCT p.ProjectName ORDER BY p.ProjectName SEPARATOR ', ') AS ProjectNames
	FROM
		Employees e2
	LEFT JOIN Projects p
        ON
		e2.DepartmentID = p.DepartmentID
	GROUP BY
		e2.EmployeeID
) p
    ON
	e.EmployeeID = p.EmployeeID
LEFT JOIN (
	SELECT
		t.AssignedTo AS EmployeeID,
		GROUP_CONCAT(DISTINCT t.TaskName ORDER BY t.TaskName SEPARATOR ', ') AS TaskNames
	FROM
		Tasks t
	GROUP BY
		t.AssignedTo
) t
    ON
	e.EmployeeID = t.EmployeeID
WHERE
	r.RoleName = 'Менеджер'
GROUP BY
	e.EmployeeID,
	e.Name,
	e.ManagerID,
	d.DepartmentName,
	r.RoleName,
	p.ProjectNames,
	t.TaskNames
HAVING
	COUNT(DISTINCT sh.SubordinateID) > 0
ORDER BY
	e.Name;
create database lost_found_portal;
use lost_found_portal;

create table users(
user_id int primary key auto_increment,
name varchar(100) not null ,
email varchar(50) not null,
phone_no varchar(11),
department varchar(60)
);
insert into users(name,email,phone_no,department)  
value("nitin choure","nitinchoure2006@gmail.com","9579393553","computer since"),
('Nitin Patil', 'nitin.patil@gmail.com', '9876543210', 'Computer'),
('Rahul Jadhav', 'rahul.jadhav@gmail.com', '9876543211', 'IT'),
('Priya Shinde', 'priya.shinde@gmail.com', '9876543212', 'Computer'),
('Sneha Pawar', 'sneha.pawar@gmail.com', '9876543213', 'Mechanical');
select * from users;


create table  categories(
category_id int primary key auto_increment,
category_name varchar(50) not null unique
);
INSERT INTO categories (category_name)
VALUES
('ID Card'),
('Mobile Phone'),
('Bag'),
('Keys'),
('Notebook');

SELECT * FROM categories;

ALTER TABLE categories
RENAME COLUMN catagory_name TO category_name;

DESCRIBE categories;

create table lost_items(
lost_id int auto_increment primary key ,
user_id int not null ,
category_id INT NOT NULL,
item_name varchar(100)  not null,
description varchar(150) not null ,
lost_date date not null ,
lost_location varchar(100) not null ,
status varchar(100),
 constraint fk_lost_user foreign key (user_id) references users(user_id),
constraint fk_lost_category foreign key (category_id) references categories(category_id)
);

INSERT INTO lost_items
(user_id, category_id, item_name, description, lost_date, lost_location, status)
VALUES
(1, 1, 'College ID Card', 'Blue college ID card with Nitin name', '2026-08-01', 'Library', 'Lost'),
(2, 2, 'Samsung Mobile', 'Black Samsung mobile phone', '2026-08-02', 'Canteen', 'Lost'),
(3, 3, 'Black Bag', 'Black backpack containing books', '2026-08-02', 'Computer Lab', 'Lost'),
(4, 4, 'Bike Keys', 'Two keys with a red keychain', '2026-08-03', 'Parking Area', 'Lost'),
(5, 5, 'DBMS Notebook', 'Blue notebook with DBMS notes', '2026-08-03', 'Classroom 101', 'Lost');

select * from lost_items;

create table found_items(
found_id int auto_increment primary key,
user_id int not null,
category_id int not null,
item_name varchar(100) not null,
description varchar(150) not null,
found_date date not null,
found_location varchar(100),
status varchar(50),

constraint fk_found_user foreign key(user_id) references users(user_id),
constraint fk_found_category foreign key(category_id) references categories(category_id)
);

INSERT INTO found_items
(user_id, category_id, item_name, description, found_date, found_location, status)
VALUES
(2, 1, 'College ID Card', 'Blue college ID card found near library', '2026-08-01', 'Library', 'Found'),
(3, 2, 'Samsung Mobile', 'Black Samsung mobile found on canteen table', '2026-08-02', 'Canteen', 'Found'),
(1, 3, 'Black Bag', 'Black backpack found in computer lab', '2026-08-02', 'Computer Lab', 'Found'),
(5, 4, 'Bike Keys', 'Two keys with red keychain found in parking area', '2026-08-03', 'Parking Area', 'Found'),
(4, 5, 'DBMS Notebook', 'Blue DBMS notebook found in classroom', '2026-08-03', 'Classroom 101', 'Found');

select * from found_items;


create table matches(
match_id int auto_increment primary key ,
lost_id int not null,
found_id int not null ,
match_status varchar(100) not null ,
returned_date date  ,

constraint fk_lost_id foreign key(lost_id) references lost_items(lost_id),
constraint fk_found_id foreign key(found_id) references found_items(found_id)

);
INSERT INTO matches
(lost_id, found_id, match_status, returned_date)
VALUES
(1, 1, 'Returned', '2026-08-02'),
(2, 2, 'Returned', '2026-08-03'),
(3, 3, 'Pending', NULL),
(4, 4, 'Returned', '2026-08-04'),
(5, 5, 'Pending', NULL);

select * from matches;

SELECT * FROM lost_items;
SELECT
    l.item_name,
    l.lost_date,
    l.lost_location,
    l.status,
    u.name AS user_name,
    c.category_name
FROM lost_items l
JOIN users u ON l.user_id = u.user_id
JOIN categories c ON l.category_id = c.category_id;

SELECT 
    f.item_name,
    f.found_date,
    f.found_location,
    f.status,
    u.name AS found_by,
    c.category_name
FROM found_items f
JOIN users u ON f.user_id = u.user_id
JOIN categories c ON f.category_id = c.category_id;

SELECT
    m.match_id,
    l.item_name AS lost_item,
    f.item_name AS found_item,
    m.match_status,
    m.returned_date
FROM matches m
JOIN lost_items l ON m.lost_id = l.lost_id
JOIN found_items f ON m.found_id = f.found_id;

SELECT
    l.item_name AS lost_item,
    f.item_name AS found_item,
    m.match_status
FROM matches m
JOIN lost_items l ON m.lost_id = l.lost_id
JOIN found_items f ON m.found_id = f.found_id
WHERE m.match_status = 'Pending';

SELECT
    l.item_name,
    l.description,
    l.lost_location,
    l.lost_date
FROM lost_items l
JOIN categories c ON l.category_id = c.category_id
WHERE c.category_name = 'Mobile Phone';

SELECT
    c.category_name,
    COUNT(l.lost_id) AS total_lost_items
FROM categories c
LEFT JOIN lost_items l ON c.category_id = l.category_id
GROUP BY c.category_name;

UPDATE lost_items
SET status = 'Returned'
WHERE lost_id = 1;

SELECT * FROM lost_items
WHERE lost_id = 1;

SELECT
    status,
    COUNT(*) AS total_items
FROM lost_items
GROUP BY status;
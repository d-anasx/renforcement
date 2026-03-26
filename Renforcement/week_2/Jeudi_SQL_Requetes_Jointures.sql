-- 1. Create the Database
CREATE DATABASE IF NOT EXISTS livraison_db;
USE livraison_db;

-- 2. Table: utilisateurs (Clients and Delivery drivers)
CREATE TABLE utilisateurs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    type ENUM('client', 'livreur') NOT NULL,
    created_at DATE DEFAULT (CURRENT_DATE)
);

-- 3. Table: restaurants
CREATE TABLE restaurants (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255) NOT NULL,
    ville VARCHAR(255),
    note_moy FLOAT DEFAULT 0
);

-- 4. Table: plats (Dishes)
CREATE TABLE plats (
    id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_id INT,
    nom VARCHAR(255) NOT NULL,
    prix DECIMAL(10,2) NOT NULL,
    categorie VARCHAR(100),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)
);

-- 5. Table: commandes (Central table)
CREATE TABLE commandes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    client_id INT,
    livreur_id INT,
    restaurant_id INT,
    statut ENUM('en cours', 'livré', 'annulé') DEFAULT 'en cours',
    total DECIMAL(10,2),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (client_id) REFERENCES utilisateurs(id),
    FOREIGN KEY (livreur_id) REFERENCES utilisateurs(id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)
);

-- 6. Table: lignes_commande (Order details)
CREATE TABLE lignes_commande (
    id INT PRIMARY KEY AUTO_INCREMENT,
    commande_id INT,
    plat_id INT,
    quantite INT,
    prix_unit DECIMAL(10,2),
    FOREIGN KEY (commande_id) REFERENCES commandes(id),
    FOREIGN KEY (plat_id) REFERENCES plats(id)
);

-- 7. Table: notations (Reviews)
CREATE TABLE notations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    commande_id INT,
    note INT CHECK (note BETWEEN 1 AND 5),
    commentaire TEXT,
    FOREIGN KEY (commande_id) REFERENCES commandes(id)
);





INSERT INTO utilisateurs (nom, email, type) VALUES 
('Mehdi', 'mehdi@email.com', 'client'),
('Sara', 'sara@email.com', 'client'),
('Youssef', 'youssef@email.com', 'livreur');

INSERT INTO restaurants (nom, ville, note_moy) VALUES 
('Pizza Hut', 'Paris', 4.5),
('Poulet Chic', 'Lyon', 3.8),
('Burger King', 'Marseille', 4.2);

INSERT INTO plats (restaurant_id, nom, prix, categorie) VALUES 
(1, 'Pizza Margherita', 12.00, 'pizza'),
(2, 'Poulet Rôti', 14.50, 'poulet'),
(3, 'Double Cheese Burger', 9.50, 'burger');

INSERT INTO commandes (client_id, livreur_id, restaurant_id, statut, total) VALUES 
(1, 3, 1, 'livré', 24.00),
(2, 3, 2, 'en cours', 14.50);

INSERT INTO utilisateurs (nom, email, type) VALUES 
('Anas', 'anas@codewave.com', 'client'),
('Lina', 'lina@codewave.com', 'client'),
('Karim', 'karim@codewave.com', 'livreur'),
('Fatima', 'fatima@codewave.com', 'client');

INSERT INTO restaurants (nom, ville, note_moy) VALUES 
('Sushi Zen', 'Paris', 4.7),
('Tacos de Lyon', 'Lyon', 3.5),
('Le Petit Indien', 'Marseille', 4.1);

INSERT INTO plats (restaurant_id, nom, prix, categorie) VALUES 
(1, 'Pizza 4 Saisons', 15.50, 'pizza'),
(3, 'Veggie Burger', 10.50, 'burger'),
(4, 'Plateau Sushi 24pc', 32.00, 'sushi'),
(2, 'Poulet Braisé', 16.00, 'poulet'),
(5, 'Tacos Maxi XL', 11.50, 'tacos');

INSERT INTO commandes (client_id, livreur_id, restaurant_id, statut, total) VALUES 
(1, 3, 1, 'livré', 35.50),   
(4, 5, 4, 'livré', 64.00),   
(5, 3, 2, 'annulé', 16.00),  
(1, 6, 3, 'en cours', 21.00),
(2, 3, 1, 'livré', 15.50),   
(4, 5, 1, 'livré', 12.00);   




INSERT INTO lignes_commande (commande_id, plat_id, quantite, prix_unit) VALUES 
(1, 1, 2, 12.00), 
(2, 2, 1, 14.50), 
(3, 1, 1, 15.50), 
(3, 3, 2, 10.00), 
(4, 7, 2, 22.00), 
(5, 8, 1, 11.50), 
(6, 1, 1, 12.00), 
(7, 4, 1, 32.00); 



INSERT INTO notations (commande_id, note, commentaire) VALUES 
(1, 5, 'Livreur très rapide et pizza encore chaude !'),
(2, 4, 'Bon poulet, mais un peu froid à l''arrivée.'),
(4, 5, 'Les sushis étaient excellents, je recommande.'),
(6, 2, 'Erreur dans la commande, j''ai reçu une Margherita au lieu d''une 4 saisons.'),
(7, 4, 'Livraison soignée et respect des horaires.');

-- ex 1 -- 

--1--

SELECT nom, email 
FROM utilisateurs 
WHERE type = 'client';


--2--

SELECT * FROM plats 
WHERE prix < 15 
ORDER BY prix ASC;



--3--

SELECT statut, COUNT(*) AS nb_commandes 
FROM commandes 
GROUP BY statut;

--4--
SELECT nom, note_moy 
FROM restaurants 
ORDER BY note_moy DESC 
LIMIT 3;


--5-- 

SELECT SUM(total) AS chiffre_affaires_total, AVG(total) AS panier_moyen 
FROM commandes 
WHERE statut = 'livré';



--6--

SELECT * FROM plats 
WHERE nom LIKE '%poulet%';


-- ex 2 --

--1--
SELECT nom , COUNT(c.id) as nbr_commandes
from utilisateurs u
JOIN commandes c on u.id = c.client_id
GROUP BY nom

--2--

SELECT nom , COUNT(c.id) as nbr_commandes
from restaurants r
LEFT JOIN commandes c on r.id = c.restaurant_id
GROUP BY nom

--3--

SELECT c.id, c.total , c.created_at , u.nom as client , ut.nom as livreur , r.nom as restau
from commandes c
JOIN utilisateurs u on u.id = c.client_id                                                                                                                                     
JOIN utilisateurs ut on ut.id = c.livreur_id                                                                                                                                     
JOIN restaurants r on r.id = c.restaurant_id
WHERE statut = 'livré'


--4--

SELECT p.nom , SUM(lc.quantite) as quantity
from plats p
JOIN lignes_commande lc on p.id = lc.plat_id
GROUP BY p.nom

--5--

SELECT u.nom , Count(c.id) as commandes
from utilisateurs u
JOIN commandes c on u.id = c.livreur_id
GROUP BY u.nom
HAVING commandes >= 3


--6--

Select u.nom , n.note
from utilisateurs u
JOIN commandes c on u.id = c.livreur_id
JOIN notations n on c.id = n.commande_id
ORDER BY n.note DESC
LIMIT 3




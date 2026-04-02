-- database creation 


CREATE DATABASE livraison;
USE livraison;


-- utilisateurs
CREATE TABLE utilisateurs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100),
    email VARCHAR(100),
    type ENUM('client', 'livreur')
);

-- restaurants
CREATE TABLE restaurants (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100),
    ville VARCHAR(100),
    note_moy DECIMAL(2,1)
);

-- plats
CREATE TABLE plats (
    id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT,
    nom VARCHAR(100),
    prix DECIMAL(6,2),
    categorie VARCHAR(50),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)
);

-- commandes
CREATE TABLE commandes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT,
    livreur_id INT,
    restaurant_id INT,
    statut VARCHAR(20),
    total DECIMAL(6,2),
    created_at DATETIME,
    FOREIGN KEY (client_id) REFERENCES utilisateurs(id),
    FOREIGN KEY (livreur_id) REFERENCES utilisateurs(id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)
);

-- lignes_commande
CREATE TABLE lignes_commande (
    id INT AUTO_INCREMENT PRIMARY KEY,
    commande_id INT,
    plat_id INT,
    quantite INT,
    prix_unit DECIMAL(6,2),
    FOREIGN KEY (commande_id) REFERENCES commandes(id),
    FOREIGN KEY (plat_id) REFERENCES plats(id)
);

-- notations
CREATE TABLE notations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    commande_id INT,
    note INT,
    commentaire TEXT,
    FOREIGN KEY (commande_id) REFERENCES commandes(id)
);


-- data

INSERT INTO utilisateurs (nom, email, type) VALUES
('Ali', 'ali@mail.com', 'client'),
('Sara', 'sara@mail.com', 'client'),
('Yassine', 'yassine@mail.com', 'client'),

('Karim', 'karim@mail.com', 'livreur'),
('Omar', 'omar@mail.com', 'livreur'),
('Hassan', 'hassan@mail.com', 'livreur');



INSERT INTO restaurants (nom, ville, note_moy) VALUES
('Snack 7', 'Marrakech', 4.2),
('Pizza House', 'Casablanca', 4.5),
('Tacos Time', 'Marrakech', 3.9);


INSERT INTO plats (restaurant_id, nom, prix, categorie) VALUES
(1, 'Burger', 40, 'fastfood'),
(1, 'Sandwich', 30, 'fastfood'),

(2, 'Pizza Margherita', 60, 'italian'),
(2, 'Pizza 4 Fromages', 70, 'italian'),

(3, 'Tacos Poulet', 50, 'mexican'),
(3, 'Tacos Viande', 55, 'mexican');




INSERT INTO commandes (client_id, livreur_id, restaurant_id, statut, total, created_at) VALUES
(1, 4, 1, 'livré', 70, NOW()),
(2, 4, 2, 'livré', 60, NOW()),
(3, 5, 3, 'livré', 55, NOW()),
(1, 5, 2, 'en cours', 70, NOW()),
(2, 6, 1, 'livré', 40, NOW()),
(3, 4, 3, 'livré', 50, NOW()),
(1, 4, 1, 'livré', 30, NOW());




INSERT INTO lignes_commande (commande_id, plat_id, quantite, prix_unit) VALUES
(1, 1, 1, 40),
(1, 2, 1, 30),

(2, 3, 1, 60),

(3, 6, 1, 55),

(4, 4, 1, 70),

(5, 1, 1, 40),

(6, 5, 1, 50),

(7, 2, 1, 30);




INSERT INTO notations (commande_id, note, commentaire) VALUES
(1, 5, 'Excellent'),
(2, 4, 'Good'),
(3, 3, 'Average'),
(5, 5, 'Perfect'),
(6, 4, 'Nice'),
(7, 5, 'Top service');



--extra


INSERT INTO commandes (client_id, livreur_id, restaurant_id, statut, total, created_at) VALUES

(1, 5, 1, 'livré', 45, NOW()),
(2, 5, 2, 'livré', 65, NOW()),
(3, 5, 3, 'livré', 50, NOW()),

(1, 6, 2, 'livré', 70, NOW()),
(2, 6, 3, 'livré', 55, NOW()),
(3, 6, 1, 'livré', 35, NOW());



INSERT INTO notations (commande_id, note, commentaire) VALUES
(8, 4, 'Good'),
(9, 5, 'Excellent'),
(10, 4, 'Nice'),

(11, 5, 'Perfect'),
(12, 4, 'Good'),
(13, 5, 'Top');




--exercice 2

--9

SELECT u.nom , COUNT(c.id) , SUM(c.total) , AVG(n.note)
FROM utilisateurs u
LEFT JOIN commandes c on c.livreur_id = u.id 
LEFT JOIN notations n on n.commande_id = c.id 
WHERE u.type = 'livreur'
GROUP BY u.nom


--10


SELECT 
    u.nom,
    COUNT(DISTINCT c.id) AS nb_livraisons,
    AVG(n.note) AS note_moyenne
FROM utilisateurs u
JOIN commandes c ON u.id = c.livreur_id
LEFT JOIN notations n ON c.id = n.commande_id
WHERE u.type = 'livreur' AND c.statut = 'livré'
GROUP BY u.id, u.nom
HAVING COUNT(DISTINCT c.id) > 2
   AND AVG(n.note) >= 4;


--11

SELECT u.nom
FROM utilisateurs u
WHERE u.type = 'livreur'
AND NOT EXISTS (
    SELECT 1
    FROM commandes c
    WHERE c.livreur_id = u.id
      AND c.statut = 'livré'
      AND MONTH(c.created_at) = MONTH(CURRENT_DATE())
      AND YEAR(c.created_at) = YEAR(CURRENT_DATE())
);

--12

SELECT 
    u.nom,
    COUNT(c.id) AS total_commandes,
    COUNT(CASE WHEN c.statut = 'livré' THEN 1 END) AS commandes_livrees,
    (COUNT(CASE WHEN c.statut = 'livré' THEN 1 END) * 100.0 / COUNT(c.id)) AS taux_succes
FROM utilisateurs u
JOIN commandes c ON u.id = c.livreur_id
WHERE u.type = 'livreur'
GROUP BY u.id, u.nom
HAVING COUNT(c.id) >= 3
ORDER BY taux_succes DESC;

--13

SELECT 
    r.nom,
    AVG(n.note) AS note_moyenne
FROM restaurants r
JOIN commandes c ON r.id = c.restaurant_id
JOIN notations n ON c.id = n.commande_id
GROUP BY r.id, r.nom
HAVING COUNT(n.id) >= 1;


--14

EXPLAIN SELECT 
    u.nom,
    COUNT(CASE WHEN c.statut = 'livré' THEN 1 END),
    SUM(c.total),
    AVG(n.note)
FROM utilisateurs u
LEFT JOIN commandes c ON u.id = c.livreur_id
LEFT JOIN notations n ON c.id = n.commande_id
WHERE u.type = 'livreur'
GROUP BY u.id;
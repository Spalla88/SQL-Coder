-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS lacteos;
USE lacteos;

-- Tabla auxiliar Paises
CREATE TABLE Paises (
    pais_id VARCHAR(3) PRIMARY KEY,
    pais VARCHAR(50) NOT NULL
);

-- Tabla auxiliar Provincias
CREATE TABLE Provincias (
    provincia_id INT PRIMARY KEY,
    provincia VARCHAR(50) NOT NULL,
    pais_id VARCHAR(3),
    FOREIGN KEY (pais_id) REFERENCES Paises(pais_id)
);

-- Tabla: estimacion-variacion-intermensual-provincia-tbo-cte
CREATE TABLE estimacion_variacion_intermensual_provincia_tbo_cte (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pais_id VARCHAR(3),
    provincia_id INT,
    año INT,
    mes VARCHAR(10),
    CCP VARCHAR(10),
    producto VARCHAR(50),
    uni_med_id VARCHAR(5),
    cantidad DECIMAL(10,2),
    FOREIGN KEY (pais_id) REFERENCES Paises(pais_id),
    FOREIGN KEY (provincia_id) REFERENCES Provincias(provincia_id)
);
SELECT * FROM estimacion_variacion_intermensual_provincia_tbo_cte LIMIT 5;

-- Tabla: estimacion-variacion-intermensual-nacional-tbo-cte
CREATE TABLE estimacion_variacion_intermensual_nacional_tbo_cte (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pais_id VARCHAR(3),
    año INT,
    mes VARCHAR(10),
    CCP VARCHAR(10),
    producto VARCHAR(50),
    uni_med_id VARCHAR(5),
    cantidad DECIMAL(10,2),
    FOREIGN KEY (pais_id) REFERENCES Paises(pais_id)
);

SELECT * FROM estimacion_variacion_intermensual_nacional_tbo_cte LIMIT 5;

-- Tabla: estimacion-variacion-intermensual-estrato-tbo-cte
CREATE TABLE estimacion_variacion_intermensual_estrato_tbo_cte (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pais_id VARCHAR(3),
    año INT,
    mes VARCHAR(10),
    CCP VARCHAR(10),
    producto VARCHAR(50),
    Estrato_productivo VARCHAR(20),
    uni_med_id VARCHAR(5),
    cantidad DECIMAL(10,2),
    FOREIGN KEY (pais_id) REFERENCES Paises(pais_id)
);

SELECT * FROM estimacion_variacion_intermensual_estrato_tbo_cte LIMIT 5;

-- Tabla: estimacion-variacion-interanual-provincia-tbo-cte
CREATE TABLE estimacion_variacion_interanual_provincia_tbo_cte (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pais_id VARCHAR(3),
    provincia_id INT,
    año INT,
    mes VARCHAR(10),
    CCP VARCHAR(10),
    producto VARCHAR(50),
    uni_med_id VARCHAR(5),
    cantidad DECIMAL(10,2),
    FOREIGN KEY (pais_id) REFERENCES Paises(pais_id),
    FOREIGN KEY (provincia_id) REFERENCES Provincias(provincia_id)
);

SELECT * FROM estimacion_variacion_interanual_provincia_tbo_cte LIMIT 5;

-- Tabla: estimacion-variacion-interanual-nacional-tbo-cte
CREATE TABLE estimacion_variacion_interanual_nacional_tbo_cte (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pais_id VARCHAR(3),
    año INT,
    mes VARCHAR(10),
    CCP VARCHAR(10),
    producto VARCHAR(50),
    uni_med_id VARCHAR(5),
    cantidad DECIMAL(10,2),
    FOREIGN KEY (pais_id) REFERENCES Paises(pais_id)
);

SELECT * FROM estimacion_variacion_interanual_nacional_tbo_cte LIMIT 5;

-- Tabla: estimacion-variacion-interanual-estrato-tbo-cte
CREATE TABLE estimacion_variacion_interanual_estrato_tbo_cte (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pais_id VARCHAR(3),
    año INT,
    mes VARCHAR(10),
    CCP VARCHAR(10),
    producto VARCHAR(50),
    Estrato_productivo VARCHAR(20),
    uni_med_id VARCHAR(5),
    cantidad DECIMAL(10,2),
    FOREIGN KEY (pais_id) REFERENCES Paises(pais_id)
);

SELECT * FROM estimacion_variacion_interanual_estrato_tbo_cte LIMIT 5;

-- Índices para optimizar consultas
CREATE INDEX idx_pais_id ON estimacion_variacion_intermensual_provincia_tbo_cte(pais_id);
CREATE INDEX idx_provincia_id ON estimacion_variacion_intermensual_provincia_tbo_cte(provincia_id);
CREATE INDEX idx_anio_mes ON estimacion_variacion_intermensual_provincia_tbo_cte(año, mes);
CREATE INDEX idx_pais_id_estrato ON estimacion_variacion_intermensual_estrato_tbo_cte(pais_id);
CREATE INDEX idx_anio_mes_estrato ON estimacion_variacion_intermensual_estrato_tbo_cte(año, mes);
CREATE INDEX idx_pais_id_nacional ON estimacion_variacion_intermensual_nacional_tbo_cte(pais_id);
CREATE INDEX idx_anio_mes_nacional ON estimacion_variacion_intermensual_nacional_tbo_cte(año, mes);

-- Tabla de auditoría
CREATE TABLE AuditoriaVariaciones (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_registro INT,
    tabla_afectada VARCHAR(50),
    accion VARCHAR(50),
    fecha_modificacion DATETIME,
    usuario VARCHAR(50)
);

SELECT COUNT(*) AS total_registros FROM AuditoriaVariaciones;
SELECT * FROM AuditoriaVariaciones LIMIT 5;

-- Vistas
CREATE VIEW vw_VariacionMensualPorProvincia AS
SELECT p.pais, pr.provincia, e.año, e.mes, e.cantidad
FROM estimacion_variacion_intermensual_provincia_tbo_cte e
JOIN Provincias pr ON e.provincia_id = pr.provincia_id
JOIN Paises p ON e.pais_id = p.pais_id
WHERE e.cantidad IS NOT NULL;

SELECT * FROM vw_VariacionMensualPorProvincia LIMIT 5;

CREATE VIEW vw_VariacionNacionalPorAnio AS
SELECT p.pais, e.año, e.mes, e.cantidad
FROM estimacion_variacion_intermensual_nacional_tbo_cte e
JOIN Paises p ON e.pais_id = p.pais_id
ORDER BY e.año, e.mes;

SELECT * FROM vw_VariacionNacionalPorAnio LIMIT 5;

CREATE VIEW vw_EstratoProductivo AS
SELECT e.Estrato_productivo, AVG(e.cantidad) as promedio_variacion, p.pais
FROM estimacion_variacion_interanual_estrato_tbo_cte e
JOIN Paises p ON e.pais_id = p.pais_id
GROUP BY e.Estrato_productivo, p.pais;

SELECT * FROM vw_EstratoProductivo LIMIT 5;

CREATE VIEW vw_VariacionInteranualPorProvincia AS
SELECT 
    p.pais,
    pr.provincia,
    e.año,
    e.mes,
    e.cantidad
FROM estimacion_variacion_interanual_provincia_tbo_cte e
JOIN Provincias pr ON e.provincia_id = pr.provincia_id
JOIN Paises p ON e.pais_id = p.pais_id
WHERE e.cantidad IS NOT NULL;

SELECT * FROM vw_VariacionInteranualPorProvincia LIMIT 5;

CREATE VIEW vw_VariacionInteranualPorEstrato AS
SELECT 
    p.pais,
    e.Estrato_productivo,
    e.año,
    e.mes,
    e.cantidad
FROM estimacion_variacion_interanual_estrato_tbo_cte e
JOIN Paises p ON e.pais_id = p.pais_id
WHERE e.cantidad IS NOT NULL;

SELECT * FROM vw_VariacionInteranualPorEstrato LIMIT 5;

-- Funciones
DELIMITER //
CREATE FUNCTION fn_PromedioVariacionMensual(p_provincia_id INT, p_anio INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(10,2);
    SELECT AVG(cantidad) INTO promedio
    FROM estimacion_variacion_intermensual_provincia_tbo_cte
    WHERE provincia_id = p_provincia_id AND año = p_anio;
    RETURN IFNULL(promedio, 0);
END //
DELIMITER ;

SELECT fn_PromedioVariacionMensual(6, 2015) AS promedio;

DELIMITER //
CREATE FUNCTION fn_TotalProduccionEstrato(p_estrato VARCHAR(20), p_anio INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(cantidad) INTO total
    FROM estimacion_variacion_interanual_estrato_tbo_cte
    WHERE Estrato_productivo = p_estrato AND año = p_anio;
    RETURN IFNULL(total, 0);
END //
DELIMITER ;

-- Stored Procedures
DELIMITER //
CREATE PROCEDURE sp_InsertarVariacionMensual(
    IN p_pais_id VARCHAR(3),
    IN p_provincia_id INT,
    IN p_anio INT,
    IN p_mes VARCHAR(10),
    IN p_CCP VARCHAR(10),
    IN p_producto VARCHAR(50),
    IN p_uni_med_id VARCHAR(5),
    IN p_cantidad DECIMAL(10,2)
)
BEGIN
    IF EXISTS (SELECT 1 FROM Paises WHERE pais_id = p_pais_id) AND
       EXISTS (SELECT 1 FROM Provincias WHERE provincia_id = p_provincia_id AND pais_id = p_pais_id) THEN
        INSERT INTO estimacion_variacion_intermensual_provincia_tbo_cte (
            pais_id, provincia_id, año, mes, CCP, producto, uni_med_id, cantidad
        )
        VALUES (p_pais_id, p_provincia_id, p_anio, p_mes, p_CCP, p_producto, p_uni_med_id, p_cantidad);
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'País o provincia inválidos.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_ActualizarVariacionNacional(
    IN p_pais_id VARCHAR(3),
    IN p_anio INT,
    IN p_mes VARCHAR(10),
    IN p_cantidad DECIMAL(10,2)
)
BEGIN
    UPDATE estimacion_variacion_intermensual_nacional_tbo_cte
    SET cantidad = p_cantidad
    WHERE pais_id = p_pais_id AND año = p_anio AND mes = p_mes;
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se encontró el registro para actualizar.';
    END IF;
END //
DELIMITER ;

-- Trigger
DELIMITER //
CREATE TRIGGER trg_AuditoriaVariacionMensual
AFTER INSERT ON estimacion_variacion_intermensual_provincia_tbo_cte
FOR EACH ROW
BEGIN
    INSERT INTO AuditoriaVariaciones (id_registro, tabla_afectada, accion, fecha_modificacion, usuario)
    VALUES (NEW.id, 'estimacion_variacion_intermensual_provincia_tbo_cte', 'INSERT', NOW(), USER());
END //
DELIMITER ;

-- Inserción en Paises
INSERT INTO Paises (pais_id, pais) VALUES
('032', 'Argentina');

-- Inserción en Provincias
INSERT INTO Provincias (provincia_id, provincia, pais_id) VALUES
(6, 'Buenos Aires', '032'),
(14, 'Córdoba', '032'),
(30, 'Entre Ríos', '032'),
(42, 'La Pampa', '032'),
(82, 'Santa Fe', '032'),
(86, 'Santiago del Estero', '032');

ALTER TABLE AuditoriaVariaciones
MODIFY COLUMN tabla_afectada VARCHAR(100);
DESCRIBE AuditoriaVariaciones;

-- Variación mensual promedio por provincia en 2016:
SELECT p.provincia, ROUND(AVG(e.cantidad), 2) AS promedio_variacion
FROM estimacion_variacion_intermensual_provincia_tbo_cte e
JOIN Provincias p ON e.provincia_id = p.provincia_id
WHERE e.año = 2016
GROUP BY p.provincia;

-- Mes con mayor variación positiva por provincia:
SELECT p.provincia, e.año, e.mes, e.cantidad
FROM estimacion_variacion_intermensual_provincia_tbo_cte e
JOIN Provincias p ON e.provincia_id = p.provincia_id
WHERE (e.provincia_id, e.cantidad) IN (
    SELECT provincia_id, MAX(cantidad)
    FROM estimacion_variacion_intermensual_provincia_tbo_cte
    GROUP BY provincia_id
);

-- Comparación interanual nacional:
SELECT año, mes, cantidad
FROM estimacion_variacion_interanual_nacional_tbo_cte
ORDER BY año, FIELD(mes, 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre');
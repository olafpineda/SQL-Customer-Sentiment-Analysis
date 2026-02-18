CREATE TABLE tickets_soporte (
    ticket_id INT PRIMARY KEY,
    fecha_creacion DATE,
    agente_id VARCHAR(50),
    equipo VARCHAR(50),
    categoria VARCHAR(100),
    llamada_telefonica BOOLEAN,
    survey_done VARCHAR(50), -- Aquí guardaremos 'Satisfecho', 'Insatisfecho' o NULL
    tiempo_resolucion_min INT
);

-- Vamos a insertar unos datos de prueba para ver que funciona
INSERT INTO tickets_soporte VALUES 
(101, '2024-01-05', 'Agent_01', 'Team_A', 'Technical', TRUE, 'Satisfecho', 15),
(102, '2024-01-05', 'Agent_02', 'Team_B', 'Billing', FALSE, 'Insatisfecho', 45),
(103, '2024-01-06', 'Agent_01', 'Team_A', 'Technical', TRUE, NULL, 10),
(104, '2024-01-06', 'Agent_03', 'Team_C', 'Technical', FALSE, 'Insatisfecho', 60),
(105, '2024-01-07', 'Agent_02', 'Team_B', 'Billing', TRUE, 'Satisfecho', 20);

/* 1. LIMPIEZA Y ESTANDARIZACIÓN 
   Aquí demostramos que sabemos limpiar textos y manejar valores nulos */
SELECT 
    ticket_id,
    UPPER(TRIM(equipo)) AS equipo_formateado, -- Elimina espacios y estandariza mayúsculas
    COALESCE(survey_done, 'No contestada') AS estatus_encuesta, -- Cambia los NULL por un texto legible
    tiempo_resolucion_min
FROM tickets_soporte;

/* 2. ANÁLISIS AVANZADO (WINDOW FUNCTIONS)
   Este es el código que mencioné para comparar a cada agente contra el promedio de su propio equipo */
SELECT 
    ticket_id,
    agente_id,
    equipo,
    tiempo_resolucion_min,
    AVG(tiempo_resolucion_min) OVER(PARTITION BY equipo) AS promedio_del_equipo,
    tiempo_resolucion_min - AVG(tiempo_resolucion_min) OVER(PARTITION BY equipo) AS diferencia_vs_promedio
FROM tickets_soporte
ORDER BY equipo, diferencia_vs_promedio DESC;
/*******************************************************************************
PROJECT: Customer Satisfaction (CSAT/DSAT) & Agent Performance Analysis
AUTHOR: Olaf Pineda Nuñez
DATABASE: MySQL 8.0
DESCRIPTION: This script demonstrates data modeling, cleaning, and advanced 
             analytics to identify friction points in customer support.
*******************************************************************************/

-- =============================================================================
-- STEP 1: DATABASE SCHEMA & DATA INGESTION
-- =============================================================================

-- Create the main transaction table (Support Tickets)
CREATE TABLE support_tickets (
    ticket_id INT PRIMARY KEY,
    created_at DATE,
    agent_id VARCHAR(50),
    team_name VARCHAR(50),
    category VARCHAR(100),
    survey_result VARCHAR(50), -- Options: 'Satisfied', 'Unsatisfied', NULL
    resolution_time_min INT
);

-- Create the organizational table (Team Leadership)
CREATE TABLE team_leadership (
    team_id VARCHAR(50) PRIMARY KEY,
    manager_name VARCHAR(100),
    department VARCHAR(50)
);

-- Ingesting sample data for tickets
INSERT INTO support_tickets VALUES 
(101, '2024-01-05', 'Agent_01', 'Team_A', 'Technical', 'Satisfied', 15),
(102, '2024-01-05', 'Agent_02', 'Team_B', 'Billing', 'Unsatisfied', 45),
(103, '2024-01-06', 'Agent_01', 'Team_A', 'Technical', NULL, 10),
(104, '2024-01-06', 'Agent_03', 'Team_C', 'Technical', 'Unsatisfied', 60),
(105, '2024-01-07', 'Agent_02', 'Team_B', 'Billing', 'Satisfied', 20),
(106, '2024-01-07', 'Agent_01', 'Team_A', 'Technical', 'Satisfied', 12),
(107, '2024-01-08', 'Agent_03', 'Team_C', 'Technical', 'Unsatisfied', 55);

-- Ingesting sample data for leadership mapping
INSERT INTO team_leadership VALUES 
('Team_A', 'Sophia Rodriguez', 'Customer Experience'),
('Team_B', 'Charles Mendez', 'Billing Operations'),
('Team_C', 'Elena Gomez', 'Technical Support');

-- =============================================================================
-- STEP 2: DATA CLEANING & STANDARDIZATION
-- =============================================================================

/* Goal: Standardize team names and handle missing survey values (NULLs)
to ensure accurate reporting.
*/
SELECT 
    ticket_id,
    UPPER(TRIM(team_name)) AS standardized_team,
    COALESCE(survey_result, 'Pending/No Response') AS survey_status,
    resolution_time_min
FROM support_tickets;

-- =============================================================================
-- STEP 3: ADVANCED ANALYTICS - AGENT BENCHMARKING
-- =============================================================================

/* Goal: Use Window Functions (OVER/PARTITION BY) to compare individual 
agent speed against their specific team average.
*/
SELECT 
    ticket_id,
    agent_id,
    team_name,
    resolution_time_min,
    ROUND(AVG(resolution_time_min) OVER(PARTITION BY team_name), 2) AS team_avg_res,
    resolution_time_min - AVG(resolution_time_min) OVER(PARTITION BY team_name) AS performance_gap
FROM support_tickets
ORDER BY team_name, performance_gap DESC;

-- =============================================================================
-- STEP 4: RELATIONAL REPORTING - MANAGER PERFORMANCE
-- =============================================================================

/* Goal: Connect ticket data with leadership structure to identify 
which Managers are overseeing high-DSAT areas.
*/
SELECT 
    l.manager_name,
    l.department,
    COUNT(t.ticket_id) AS total_tickets,
    COUNT(CASE WHEN t.survey_result = 'Unsatisfied' THEN 1 END) AS dsat_count,
    ROUND(
        (COUNT(CASE WHEN t.survey_result = 'Unsatisfied' THEN 1 END) * 100.0) / 
        NULLIF(COUNT(t.survey_result), 0), 
    2) AS dsat_percentage
FROM support_tickets t
INNER JOIN team_leadership l ON t.team_name = l.team_id
GROUP BY l.manager_name, l.department
ORDER BY dsat_percentage DESC;

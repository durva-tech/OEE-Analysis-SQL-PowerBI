CREATE OR REPLACE VIEW oee_powerbi_view AS
SELECT
    p.machine_id,
    p.production_date,
    p.shift,
    (p.planned_minutes - IFNULL(d.downtime_minutes, 0)) / NULLIF(p.planned_minutes, 0) AS availability,
    (p.actual_output * p.ideal_cycle_time) / NULLIF(p.planned_minutes, 0) AS performance,
    p.good_units / NULLIF(p.actual_output, 0) AS quality,
    (
        (p.planned_minutes - IFNULL(d.downtime_minutes, 0)) / NULLIF(p.planned_minutes, 0)
    ) *
    (
        (p.actual_output * p.ideal_cycle_time) / NULLIF(p.planned_minutes, 0)
    ) *
    (
        p.good_units / NULLIF(p.actual_output, 0)
    ) AS oeedowntime_logproduction_date
FROM machine_production p
LEFT JOIN (
    SELECT
        machine_id,
        downtime_date,
        shift,
        SUM(downtime_minutes) AS downtime_minutes
    FROM downtime_log
    GROUP BY machine_id, downtime_date, shift
) d
  ON p.machine_id = d.machine_id
 AND p.production_date = d.downtime_date
 AND p.shift = d.shift;
 
 SELECT * FROM machine_production;machine_production


WITH CurrentAndPreviousValues AS (
    SELECT 
        a.control_instance_id,
        a.answer AS current_value,
        LAG(h.answer) OVER (PARTITION BY h.control_instance_id ORDER BY h.audit_timestamp) AS previous_value
    FROM
        answers a
    LEFT JOIN
        history_table h ON a.control_instance_id = h.control_instance_id
    WHERE
        a.control_instance_id IN (your_list_of_control_instance_ids)
)

SELECT 
    cv.control_instance_id,
    cv.current_value,
    cv.previous_value
FROM
    CurrentAndPreviousValues cv

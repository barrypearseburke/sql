WITH CurrentAndPreviousValues AS (
    SELECT 
        ci.ID AS control_instance_id,
        ci.Algo_id,
        qa.answer AS current_answer,
        LAG(his.previous_answer) OVER (PARTITION BY ci.ID ORDER BY his.audit_datetime) AS previous_answer,
        his.audit_datetime
    FROM 
        control_instances ci
    INNER JOIN
        question_answers qa ON ci.ID = qa.control_instance_id
    OUTER APPLY (
        SELECT TOP 1 his.previous_answer, his.audit_datetime
        FROM his_table his
        WHERE his.control_instance_id = ci.ID
        AND his.audit_datetime < GETDATE()  -- Assuming current date and time are used for current values
        ORDER BY his.audit_datetime DESC
    ) his
    WHERE 
        ci.Algo_id IN ('AU1', 'AU2')
)

SELECT 
    cv.control_instance_id,
    cv.Algo_id,
    cv.current_answer,
    cv.previous_answer,
    cv.audit_datetime
FROM 
    CurrentAndPreviousValues 

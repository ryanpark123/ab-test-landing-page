CREATE VIEW ab_clean AS
WITH contaminated AS (
  -- users who saw the wrong page for their group
  SELECT user_id FROM ab_data
  WHERE NOT ((exp_group = 'control'   AND landing_page = 'old_page')
          OR (exp_group = 'treatment' AND landing_page = 'new_page'))
  UNION
  -- users assigned to both groups
  SELECT user_id FROM ab_data
  GROUP BY user_id
  HAVING COUNT(DISTINCT exp_group) > 1
),
ranked AS (
  SELECT a.*,
         ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY ts) AS rn
  FROM ab_data a
  WHERE NOT EXISTS (SELECT 1 FROM contaminated c WHERE c.user_id = a.user_id)
)
SELECT user_id, ts, exp_group, converted
FROM ranked
WHERE rn = 1;
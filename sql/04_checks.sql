-- 1. Group sizes (expect roughly 50/50)
SELECT exp_group,
       COUNT(*) AS users,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM ab_clean
GROUP BY exp_group;

-- 2. Daily traffic balance
SELECT DATE(ts) AS day,
       COUNT(*) FILTER (WHERE exp_group = 'control')   AS control_users,
       COUNT(*) FILTER (WHERE exp_group = 'treatment') AS treatment_users
FROM ab_clean
GROUP BY DATE(ts)
ORDER BY day;
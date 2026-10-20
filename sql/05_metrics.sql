-- 1. Overall conversion by group
CREATE VIEW group_metrics AS
SELECT exp_group,
       COUNT(*)       AS users,
       SUM(converted) AS conversions,
       ROUND(AVG(converted)::numeric, 5) AS conversion_rate
FROM ab_clean
GROUP BY exp_group;

-- 2. Cumulative conversion rate by day (shows whether the effect is stable or fades)
CREATE VIEW daily_metrics AS
WITH daily AS (
  SELECT DATE(ts) AS day, exp_group,
         COUNT(*) AS users, SUM(converted) AS conversions
  FROM ab_clean
  GROUP BY DATE(ts), exp_group
)
SELECT day, exp_group, users, conversions,
       SUM(conversions) OVER w * 1.0 / SUM(users) OVER w AS cumulative_cr
FROM daily
WINDOW w AS (PARTITION BY exp_group ORDER BY day);

-- 3. Conversion by country and group (skip if no countries.csv)
CREATE VIEW country_metrics AS
SELECT c.country, a.exp_group,
       COUNT(*) AS users,
       ROUND(AVG(a.converted)::numeric, 5) AS conversion_rate
FROM ab_clean a
JOIN countries c ON c.user_id = a.user_id
GROUP BY c.country, a.exp_group
ORDER BY c.country, a.exp_group;
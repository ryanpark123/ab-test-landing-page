-- 1. Rows vs. unique users (a gap means duplicates)
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT user_id) AS unique_users
FROM ab_data;

-- 2. Group vs. page mismatches (control should see old_page, treatment new_page)
SELECT exp_group, landing_page, COUNT(*) AS n
FROM ab_data
GROUP BY exp_group, landing_page
ORDER BY exp_group, landing_page;

-- 3. Users appearing more than once
SELECT user_id, COUNT(*) AS appearances
FROM ab_data
GROUP BY user_id
HAVING COUNT(*) > 1
ORDER BY appearances DESC;

-- 4. Date range and nulls
SELECT MIN(ts), MAX(ts),
       COUNT(*) FILTER (WHERE converted IS NULL) AS null_converted
FROM ab_data;
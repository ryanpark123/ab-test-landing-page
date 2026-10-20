CREATE DATABASE ab_test;
\c ab_test

CREATE TABLE ab_data (
  user_id      INTEGER,
  ts           TIMESTAMP,
  exp_group    TEXT,
  landing_page TEXT,
  converted    SMALLINT
);

CREATE TABLE countries (
  user_id INTEGER PRIMARY KEY,
  country TEXT
);

\copy ab_data   FROM 'data/ab_data.csv'   WITH (FORMAT csv, HEADER true);
\copy countries FROM 'data/countries.csv' WITH (FORMAT csv, HEADER true);
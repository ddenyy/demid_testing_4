CREATE TABLE IF NOT EXISTS pc_builds (
    id SERIAL PRIMARY KEY,
    components_ids TEXT UNIQUE 
);

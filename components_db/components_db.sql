CREATE TABLE IF NOT EXISTS components (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    type TEXT NOT NULL, 
    manufacturer TEXT NOT NULL,
    specs JSONB,
    issue TEXT
);
CREATE UNIQUE INDEX IF NOT EXISTS components_unique_idx
ON components (name, type, manufacturer);

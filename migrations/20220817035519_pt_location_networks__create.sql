CREATE TABLE IF NOT EXISTS pt_locations (
    id bigserial PRIMARY KEY,
    filter_networks boolean NOT NULL DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS pt_location_networks (
    id bigserial PRIMARY KEY,
    location_id BIGINT NOT NULL REFERENCES pt_locations ON UPDATE CASCADE ON DELETE CASCADE,
    network CIDR NOT NULL
);

CREATE TABLE IF NOT EXISTS pt_sessions (
    id bigserial PRIMARY KEY,
    location_id BIGINT REFERENCES pt_locations ON UPDATE CASCADE ON DELETE CASCADE
);

ALTER TABLE pt_reservations ADD COLUMN IF NOT EXISTS session_id BIGINT NOT NULL REFERENCES pt_sessions ON UPDATE CASCADE ON DELETE CASCADE;

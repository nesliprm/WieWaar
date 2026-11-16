-- Run once by the postgres accessory on first boot (see config/deploy.yml).
-- The primary database (wie_waar_production) is created from POSTGRES_DB.
CREATE DATABASE wie_waar_production_cache;
CREATE DATABASE wie_waar_production_queue;
CREATE DATABASE wie_waar_production_cable;

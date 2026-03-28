select * from bronze.bookings;
select * from bronze.listings;
select * from bronze.hosts;

select count(*) from bronze.bookings;
select count(*) from bronze.listings;
select count(*) from bronze.hosts;

--Tranformation Layer
select * from silver.silver_bookings;
select * from silver.silver_listings;
select * from silver.silver_hosts;

select count(*) from silver.silver_bookings;
select count(*) from silver.silver_listings;
select count(*) from silver.silver_hosts;

-- Verifying the SCD type 2 Tables
select * from gold.booking_full_data;
select count(*) from gold.booking_full_data;
select * from gold.hosts_full_data;
select count(*) from gold.hosts_full_data;


-- Serving Layer
select * from gold.dim_bookings;
select * from gold.dim_hosts;
select * from gold.dim_listings;

select * from gold.fact;
select * from gold.obt;
select * from gold.obt
where host_id=1;

INSERT INTO source_schema.hosts (host_id, host_name, host_since, is_superhost, response_rate, created_at)
VALUES
-- Same ID (for update/upsert scenario)
(1, 'Utsav', '2022-05-10', TRUE, 95, CURRENT_TIMESTAMP()),

-- Different ID (new insert scenario)
(201, 'Rahul', '2023-01-15', FALSE, 88, CURRENT_TIMESTAMP());


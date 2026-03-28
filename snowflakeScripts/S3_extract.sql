-- Creating the Database
CREATE DATABASE snowflake_dbt;

-- Creating the SCHEMA
CREATE SCHEMA source_schema; 


-- Creating the Storage Integration
CREATE STORAGE INTEGRATION s3_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::979437020390:role/snowflake_s3_role'
  STORAGE_ALLOWED_LOCATIONS = ('s3://dbt-snowflake-uk/source_DATA/');

-- Checking the Storage Integration
DESC INTEGRATION s3_integration;

-- Defining the File Format
CREATE OR REPLACE FILE FORMAT csv_format_utsav
  TYPE = CSV
  SKIP_HEADER = 1
  FIELD_OPTIONALLY_ENCLOSED_BY = '"';

-- Creating the Stage
CREATE OR REPLACE STAGE stage_utsav
  URL = 's3://dbt-snowflake-uk/source_DATA/'
  STORAGE_INTEGRATION = s3_integration
  FILE_FORMAT = csv_format_utsav;

LIST @stage_utsav;


-- Loading the Data into snowflake from s3
COPY INTO bookings
FROM @stage_utsav
FILES=('bookings.csv')

COPY INTO hosts
FROM @stage_utsav
FILES=('hosts.csv')

COPY INTO listings
FROM @stage_utsav
FILES=('listings.csv')

-- Verifying the Data 
select * from bookings;
select * from listings;
select * from hosts;


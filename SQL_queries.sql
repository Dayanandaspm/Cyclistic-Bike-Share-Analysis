
-- =====================================================
-- CYCLISTIC BIKE-SHARE CASE STUDY
-- Project: Analyzing Casual Riders vs Annual Members
-- Tool: Google BigQuery
-- Table: trips_5months
-- =====================================================


-- QUERY 1: CHECK DATA QUALITY
-- Count total rows, missing ride IDs, missing rider types,
-- and the number of distinct rider types.

SELECT
  COUNT(*) AS total_rows,
  COUNTIF(ride_id IS NULL) AS missing_ride_ids,
  COUNTIF(member_casual IS NULL) AS missing_rider_types,
  COUNT(DISTINCT member_casual) AS rider_type_count
FROM
  `cyclistic-bike-share-512218.cyclistic_analysis.trips_5months`;


-- QUERY 2: CHECK DUPLICATE RIDE IDs
-- Compare total rows with unique ride IDs.

SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT ride_id) AS unique_ride_ids,
  COUNT(*) - COUNT(DISTINCT ride_id) AS duplicate_id_rows
FROM
  `cyclistic-bike-share-512218.cyclistic_analysis.trips_5months`;


-- QUERY 3: CHECK MISSING TIMESTAMPS AND INVALID DURATIONS
-- Check missing start/end times and negative ride durations.

SELECT
  COUNTIF(started_at IS NULL) AS missing_started_at,
  COUNTIF(ended_at IS NULL) AS missing_ended_at,
  COUNTIF(ended_at < started_at) AS negative_duration_rows
FROM
  `cyclistic-bike-share-512218.cyclistic_analysis.trips_5months`;


-- QUERY 4: TOTAL TRIPS BY RIDER TYPE
-- Compare the number of trips made by members and casual riders.

SELECT
  member_casual,
  COUNT(*) AS total_trips
FROM
  `cyclistic-bike-share-512218.cyclistic_analysis.trips_5months`
GROUP BY
  member_casual;


-- QUERY 5: AVERAGE RIDE LENGTH BY RIDER TYPE
-- Calculate average ride duration in minutes.

SELECT
  member_casual,
  AVG(TIMESTAMP_DIFF(ended_at, started_at, MINUTE))
    AS avg_ride_length_minutes
FROM
  `cyclistic-bike-share-512218.cyclistic_analysis.trips_5months`
GROUP BY
  member_casual;


-- QUERY 6: RIDES BY DAY OF THE WEEK
-- Compare daily trip counts for members and casual riders.
-- Sunday = 1; Saturday = 7.

SELECT
  member_casual,
  FORMAT_DATE('%A', DATE(started_at)) AS day_of_week,
  COUNT(*) AS total_trips
FROM
  `cyclistic-bike-share-512218.cyclistic_analysis.trips_5months`
GROUP BY
  member_casual,
  EXTRACT(DAYOFWEEK FROM started_at),
  day_of_week
ORDER BY
  EXTRACT(DAYOFWEEK FROM started_at),
  member_casual;
  
  
  --Rides by day of the week
  
  SELECT
  member_casual,
  FORMAT_DATE('%A', DATE(started_at)) AS day_of_week,
  COUNT(*) AS total_trips
FROM
  `cyclistic-bike-share-512218.cyclistic_analysis.trips_5months`
GROUP BY
  member_casual,
  EXTRACT(DAYOFWEEK FROM started_at),
  day_of_week
ORDER BY
  EXTRACT(DAYOFWEEK FROM started_at),
  member_casual;

---- Monthly trip patterns 

SELECT
  EXTRACT(MONTH FROM started_at) AS month_number,
  FORMAT_DATE('%B', DATE(started_at)) AS month,
  member_casual,
  COUNT(*) AS total_trips
FROM
  `cyclistic-bike-share-512218.cyclistic_analysis.trips_5months`
WHERE
  started_at >= TIMESTAMP('2025-01-01')
  AND started_at < TIMESTAMP('2025-06-01')
GROUP BY
  month_number,
  month,
  member_casual
ORDER BY
  month_number,
  member_casual;
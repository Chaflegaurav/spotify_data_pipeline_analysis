USE SpotifyDB;
GO

-- 1. BASIC DATA OVERVIEW
-- ============================================================
  
-- View all data
SELECT TOP 10 * FROM top_100_songs;

-- Total count
SELECT COUNT(*) AS total_songs FROM top_100_songs;

-- =============================================================
-- 2. POPULARITY ANALYSIS
-- =============================================================

-- Top 10 most popular songs
SELECT TOP 10
    name,
	artists_name,
	popularity,
	album_type
FROM top_100_songs
ORDER BY popularity DESC;

-- Average popularity by album type
SELECT
    album_type,
	COUNT(*) AS song_count,
	AVG(popularity) AS avg_popularity,
	MIN(popularity) AS min_popularity,
	MAX(popularity) AS max_popularity
FROM top_100_songs
GROUP BY album_type
ORDER BY avg_popularity DESC;

-- Popularity distribution
SELECT
    popularity_category,
	COUNT(*) AS count,
	CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(5,2)) AS percentage
	FROM top_100_songs
	GROUP BY popularity_category
	ORDER BY count DESC;

-- =============================================================================
-- 3. DURATION ANALYSIS
-- =============================================================================

-- Average song duration statistics
SELECT
    AVG(duration_minutes) AS avg_duration_minutes,
	MIN(duration_minutes) AS shortest_song_minutes,
	MAX(duration_minutes) AS longest_song_minutes,
	STDEV(duration_minutes) AS std_dev_minutes
FROM top_100_songs;

-- Duration catgeory distribution
SELECT
    duration_category,
	COUNT(*) AS count,
	AVG(duration_minutes) AS avg_duration,
	AVG(popularity) AS avg_popularity
FROM top_100_songs
GROUP BY duration_category
ORDER BY
    CASE duration_category
	   WHEN 'Short' THEN 1
	   WHEN 'Medium' THEN 2
	   WHEN 'Long' THEN 3
	END;

-- Shortest and longest songs
SELECT 'Shortest' AS type, name, artists_name, duration_minutes
FROM (
    SELECT name, artists_name, duration_minutes
    FROM top_100_songs
    ORDER BY duration_minutes ASC
    OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY
) AS shortest

UNION ALL

SELECT 'Longest' AS type, name, artists_name, duration_minutes
FROM (
    SELECT name, artists_name, duration_minutes
    FROM top_100_songs
    ORDER BY duration_minutes DESC
    OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY
) AS longest;

-- =========================================================
-- 4. ARTIST ANALYSIS
-- =========================================================

-- Top artists by number of songs
SELECT
    artists_name,
	COUNT(*) AS song_count,
	AVG(popularity) AS avg_popularity,
	AVG(duration_minutes) AS avg_duration
FROM top_100_songs
GROUP BY artists_name
HAVING COUNT(*) > 1
ORDER BY song_count DESC, avg_popularity DESC;

-- =============================================================
-- 5. AlBUM TYPE ANALYSIS
-- =============================================================

-- Comparison between singles and albums
SELECT
    album_type,
	COUNT(*) AS count,
	AVG(duration_minutes) AS avg_duration,
	AVG(popularity) AS avg_popularity,
    MIN(popularity) AS min_popularity,
	MAX(popularity) AS max_popularity
FROM top_100_songs
GROUP BY album_type;

-- ==============================================================
-- 6. CORRELATION ANALYSIS
-- ==============================================================

-- Relationship between duration and popularity
SELECT
    duration_category,
	popularity_category,
	COUNT(*) AS count
FROM top_100_songs
GROUP BY duration_category, popularity_category
ORDER BY duration_category, popularity_category;

-- Songs with high popularity and various durations
SELECT
    duration_category,
	COUNT(*) AS count,
	AVG(popularity) AS avg_popularity
FROM top_100_songs
WHERE popularity >= 70
GROUP BY duration_category;

-- ===================================================================
-- 8. ADVANCED INSIGHTS
-- ===================================================================
SELECT
    'Sweet Spot Songs' AS category,
	COUNT(*) AS count,
	AVG(duration_minutes) AS avg_duration,
	MIN(duration_minutes) AS min_duration,
	MAX(duration_minutes) AS max_duration
FROM top_100_songs
WHERE popularity >= 70;

-- Outlier detection (very short or very long songs)
SELECT
    name,
	artists_name,
	duration_minutes,
	popularity,
	CASE
	    WHEN duration_minutes < 2.5 THEN 'Unusually Short'
		WHEN duration_minutes > 5.0 THEN 'Unusually Long'
	END AS outlier_type
FROM top_100_songs
WHERE duration_minutes < 2.5 OR duration_minutes > 5.0
ORDER BY duration_minutes;

-- ========================================================================
-- 9. EXPORT VIEWS FOR TABLEAU
-- ========================================================================

-- Create view for Tableau: Summary statistics by category
CREATE OR ALTER VIEW vw_category_summary AS
SELECT
    album_type,
	duration_category,
	popularity_category,
	COUNT(*) AS song_count,
	AVG(duration_minutes) AS avg_duration,
	AVG(popularity) AS avg_popularity
FROM top_100_songs
GROUP BY album_type, duration_category, popularity_category;
GO

-- Create view for Tableau: Artist performance
CREATE OR ALTER VIEW vw_artist_performance AS
SELECT
    artists_name,
	COUNT(*) AS total_songs,
	AVG(popularity) AS avg_popularity,
	AVG(duration_minutes) AS avg_duration,
	MAX(popularity) AS max_popularity
FROM top_100_songs
GROUP BY artists_name;
GO

-- Create view for Tableau: Song details
CREATE OR ALTER VIEW vw_song_details AS
SELECT 
    name,
	artists_name,
	duration_minutes,
	popularity,
	album_type,
	duration_category,
	popularity_category
FROM top_100_songs;
GO

-- Verify Views
SELECT * FROM vw_category_summary;
SELECT * FROM vw_artist_performance ORDER BY total_songs DESC;
SELECT * FROM vw_song_details;

SELECT * FROM top_100_songs;
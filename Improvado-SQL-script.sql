CREATE database marketing_analysis;
USE marketing_analysis;
CREATE TABLE facebook_ads (date DATE, campaign_id VARCHAR(50), campaign_name VARCHAR(255), ad_set_id VARCHAR(50),
ad_set_name VARCHAR(50), impressions INT, clicks INT, spend DECIMAL(10,2), conversions INT, video_views INT, 
engagement_rate DECIMAL(8,4), reach INT, frequency DECIMAL(6,2));
CREATE TABLE google_ads (date DATE, campaign_id varchar(50), campaign_name VARCHAR(255), ad_group_id VARCHAR(50),
ad_group_name varchar(255), impressions int, clicks int, cost decimal(10,2), conversions int,
conversion_value decimal(10,2), ctr decimal(10,5), avg_cpc decimal(10,4), quality_score int, search_impression_share decimal(10,5));
CREATE TABLE tiktok_ads (date DATE, campaign_id VARCHAR(50), campaign_name VARCHAR(255), adgroup_id VARCHAR(50), adgroup_name VARCHAR(255), impressions INT, 
clicks INT, cost DECIMAL(10,2), conversions INT, video_views INT,video_watch_25 INT, video_watch_50 INT, video_watch_75 INT, video_watch_100 INT,
likes INT, shares INT, comments INT);
SHOW TABLES;
select count(*) as facebook_rows from facebook_ads;
select count(*) as google_rows from google_ads;
select count(*) as tiktok_rows from tiktok_ads;
select * from google_ads limit 5;
select * from facebook_ads limit 5;
select * from tiktok_ads limit 5;
-- unified data model
CREATE TABLE unified_ads as
SELECT date, 'Facebook' as Platform, campaign_id, campaign_name, ad_set_id as ad_group_id,
ad_set_name as ad_group_name,
impressions, clicks, spend as cost, conversions, video_views
from facebook_ads
UNION ALL
SELECT date, 'Google' as Platform, campaign_id, campaign_name, ad_group_id, ad_group_name,
impressions, clicks, cost, conversions,
NULL AS video_views
from google_ads
UNION ALL
SELECT date, 'TikTok' as Platform, campaign_id, campaign_name, adgroup_id as ad_group_id,
adgroup_name as ad_group_name, impressions, clicks, cost, conversions, video_views
from tiktok_ads;
-- validating data
SELECT Platform, count(*) as row_count
from unified_ads
group by Platform;
-- NULL check
SELECT 
COUNT(*) AS total_rows,
SUM(cost) AS total_spend,
SUM(conversions) AS total_conversions,
SUM(clicks) AS total_clicks,
SUM(impressions) AS total_impressions
FROM unified_ads;
CREATE VIEW unified_ads_kpi AS
SELECT *,
(clicks / NULLIF(impressions,0)) AS ctr,
(cost / NULLIF(clicks,0)) AS cpc,
(cost / NULLIF(conversions,0)) AS cpa
FROM unified_ads;

show tables
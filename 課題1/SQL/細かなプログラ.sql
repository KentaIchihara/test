SELECT
user_id
,sum(order_amount)
FROM
ro_data
GROUP BY user_id
;

SELECT user_id
,count(*) 
FROM ro_data
GROUP BY user_id
;

SELECT
user_id
,(date('2016-07-01')-min(order_date)) as date
FROM
ro_data
GROUP BY user_id
;

select *,  date('2016-10-24') as d from ro_data 
;

drop function rfmrank2(date0 varchar(10));
create or replace function rfmrank2(date0 varchar(10)) returns table(user_id varchar(10), date date, rfm_rank text) AS $$
with x as (
  select *, date(date0) as dd from ro_data 
  )
  ,a as (
  SELECT user_id ,(dd-max(order_date)) as date FROM x where order_date <= dd GROUP BY user_id, dd
  )
  ,b as (
  SELECT user_id ,count(*) FROM x where order_date <= dd GROUP BY user_id
  )
  ,c as (
  SELECT user_id ,sum(order_amount) FROM x where order_date <= dd GROUP BY user_id
  )
  ,d as (
  select a.user_id, a.date, e.count, e.sum from a inner join 
  (select b.user_id, b.count, c.sum from b inner join c on b.user_id = c.user_id) 
  as e on a.user_id = e.user_id
  )
  ,e as (
  select
    *,
  case
    when date <= 30 and count >= 7 and sum >= 50000 then 'A'
    when date <= 60 and count >= 5 and sum >= 30000 then 'B'
    when date <= 120 and count >= 3 and sum >= 10000 then 'C'
    else 'D'
  end as RFM_rank
  from d
  order by user_id
  )
  ,f as (
  select ro_data.user_id, e.count, e.sum, coalesce(e.rfm_rank, 'D') as rfm_rank from 
  (select user_id from ro_data group by user_id) as ro_data left join e on ro_data.user_id = e.user_id 
  )
select
  user_id,date(date0),rfm_rank
--  ,count(*)
from f
--group by rfm_rank
order by rfm_rank
;
$$ LANGUAGE SQL;

select * from rfmrank2('?');

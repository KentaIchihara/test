with x as (
  select *, date('2017-12-20') as dd from ro_data 
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
select
  rfm_rank
  ,count(*)
from e
group by rfm_rank
order by rfm_rank
;


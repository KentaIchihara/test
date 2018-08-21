drop function rfmrank_tran(date1 varchar(10), date2 varchar(10));
create or replace function rfmrank_tran(date1 varchar(10), date2 varchar(10)) returns table(transition text, count bigint) AS $$

with x as (
  select *, date(date1) as dd1, date(date2) as dd2 from ro_data 
  )
  ,a1 as (
  SELECT user_id ,(dd1-max(order_date)) as date FROM x where order_date <= dd1 GROUP BY user_id, dd1
  )
  ,a2 as (
  SELECT user_id ,(dd2-max(order_date)) as date FROM x where order_date <= dd2 GROUP BY user_id, dd2
  )
  ,b1 as (
  SELECT user_id ,count(*) FROM x where order_date <= dd1 GROUP BY user_id
  )
  ,b2 as (
  SELECT user_id ,count(*) FROM x where order_date <= dd2 GROUP BY user_id
  )
  ,c1 as (
  SELECT user_id ,sum(order_amount) FROM x where order_date <= dd1 GROUP BY user_id
  )
  ,c2 as (
  SELECT user_id ,sum(order_amount) FROM x where order_date <= dd2 GROUP BY user_id
  )
  ,d1 as (
  select a1.user_id, a1.date, e.count, e.sum from a1 inner join 
  (select b1.user_id, b1.count, c1.sum from b1 inner join c1 on b1.user_id = c1.user_id) 
  as e on a1.user_id = e.user_id
  )
  ,d2 as (
  select a2.user_id, a2.date, e.count, e.sum from a2 inner join 
  (select b2.user_id, b2.count, c2.sum from b2 inner join c2 on b2.user_id = c2.user_id) 
  as e on a2.user_id = e.user_id
  )
  ,e1 as (
  select
    *,
  case
    when date <= 30 and count >= 7 and sum >= 50000 then 'A'
    when date <= 60 and count >= 5 and sum >= 30000 then 'B'
    when date <= 120 and count >= 3 and sum >= 10000 then 'C'
    else 'D'
  end as RFM_rank1
  from d1
  )
  ,e2 as (
  select
    *,
  case
    when date <= 30 and count >= 7 and sum >= 50000 then 'A'
    when date <= 60 and count >= 5 and sum >= 30000 then 'B'
    when date <= 120 and count >= 3 and sum >= 10000 then 'C'
    else 'D'
  end as RFM_rank2
  from d2
  )
  ,f1 as (
  select ro_data.user_id, e1.count, e1.sum, coalesce(e1.rfm_rank1, 'D') as rfm_rank1 from 
  (select user_id from ro_data group by user_id) as ro_data left join e1 on ro_data.user_id = e1.user_id 
  )
  ,f2 as (
  select ro_data.user_id, e2.count, e2.sum, coalesce(e2.rfm_rank2, 'D') as rfm_rank2 from 
  (select user_id from ro_data group by user_id) as ro_data left join e2 on ro_data.user_id = e2.user_id 
  )
select
  (rfm_rank1 ||'Å®'|| rfm_rank2) as transition
  ,count(*)
from f1
full join f2 on f1.user_id = f2.user_id
group by transition
order by transition
;
$$ LANGUAGE SQL;


select * from rfmrank_tran('2015-12-20', '2015-12-20');

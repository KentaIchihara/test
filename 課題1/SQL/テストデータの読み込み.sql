DROP TABLE IF EXISTS ro_test CASCADE;
CREATE TABLE ro_test(
	  user_id   varchar(10)  
	, order_date date         
	, order_amount integer          
)
;
copy ro_test
from 'C:/Program Files/PostgreSQL/9.4/bin/ro_test.csv'
with 
csv
delimiter ','
header
;

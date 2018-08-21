DROP TABLE IF EXISTS ro_data CASCADE;
CREATE TABLE ro_data(
	  user_id   varchar(10)  
	, order_date date         
	, order_amount integer          
)
;
copy ro_data
from 'C:/Program Files/PostgreSQL/9.4/bin/ro_data.csv'
with 
csv
delimiter ','
header
;

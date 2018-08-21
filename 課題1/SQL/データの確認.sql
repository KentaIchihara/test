select
	*
from
	information_schema.columns
where
	table_catalog = current_database()
		and
	table_name = 'ro_data'
order by
	ordinal_position
;


-- to empty the table, in case of duplicate load-------------------------
Truncate table Bronze.crm_cust_info;

--------------------- BULK Load Script----------------------
BULK insert Bronze.erp_PX_CAT_G1V1
from 'C:\Users\Jawed\OneDrive\Desktop\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\PX_CAT_G1V2.csv'
with(
firstrow = 2,
fieldterminator = ',',
tablock);

---- to validate-----------
select* from Bronze.erp_PX_CAT_G1V1;

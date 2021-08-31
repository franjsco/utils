#!/bin/bash
#################################################
#	importer.sh
#------------------------------------------------ 
# import a Monefy CSV on a MySQL/MariaDB table  		
#
#	@franjsco (Francesco Esposito)  
#################################################
#path
PATH_IN="/yourdirectory/monefy_csv/"
PATH_COMP="/yourdirectory/monefy_csv/complete"

#db parameters
DB_HOST="<host>"
DB_USER="<user>"
DB_PASSWORD="<password>"
DB_NAME="<dbname>"

for FILES in $(find $PATH_IN -maxdepth 1 -type f)
do
	#connect and import CSV (date,account,category,amount,import date) with LOAD DATA
	mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME -e "LOAD DATA LOCAL INFILE '$FILES'
	INTO TABLE TABLE_IMPORT_MONEFY
	FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n'
	IGNORE 1 LINES
	(@data_op,@account,@category,@amount,@dummy,@dummy,@dummy,description)
	SET
	DATA_OP = STR_TO_DATE(@data_op,'%d/%m/%Y'),
	ACCOUNT = @account,
	CATEGORY = @category,
	AMOUNT = REPLACE(REPLACE(@AMOUNT,'.',''),',','.'),
	INSERT_DATE = CURDATE()"

	#move file into directory after the import
	mv $FILES $PATH_COMP

done

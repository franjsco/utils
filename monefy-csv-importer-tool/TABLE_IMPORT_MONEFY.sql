/************************************************
* CREATE TABLE
* filename: CREATE_STG_IMPORT_MONEFY.sql
*
* author:	@franjsco (Francesco Esposito)
*************************************************/
CREATE TABLE TABLE_IMPORT_MONEFY(
	DATA_OP DATE,
	ACCOUNT VARCHAR(50),
	CATEGORY VARCHAR(50),
	AMOUNT DECIMAL(30,2),
	DESCRIPTION VARCHAR(50),
	INSERT_DATE DATE,
	FLG_ELAB CHAR(1) DEFAULT "N"
);

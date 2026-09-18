-- =============================================================================
-- File: database_exploration.sql
-- Purpose: Structural & Metadata Audit of the Data Warehouse
-- Description: Inspects database objects, column definitions, data types, 
--              and dynamically calculates total row counts across tables.
-- Target Engine: Microsoft SQL Server (T-SQL)
-- =============================================================================

-- =============================================================================
-- 1. Database Objects Exploration
-- Purpose: List all active tables and views present across schemas.
-- =============================================================================
SELECT 
    table_catalog,
    table_schema,
    table_name,
    table_type
FROM INFORMATION_SCHEMA.TABLES
ORDER BY 
    table_schema, 
    table_name;


-- =============================================================================
-- 2. Schema Structure & Column Metadata Exploration
-- Purpose: Audit column names, data types, and nullability properties.
-- =============================================================================
SELECT 
    table_schema,
    table_name,
    column_name,
    data_type,
    is_nullable
FROM INFORMATION_SCHEMA.COLUMNS
ORDER BY 
    table_schema, 
    table_name, 
    ordinal_position;


-- =============================================================================
-- 3. Dynamic Row Count Audit (Bronze Layer)
-- Purpose: Automatically query and aggregate total row counts for all base tables.
-- =============================================================================
DECLARE @sql NVARCHAR(MAX) = '';

-- Generate dynamic UNION ALL SELECT query for every table in the Bronze schema
SELECT @sql += 'SELECT ''' + TABLE_NAME + ''' AS TableName, COUNT(*) AS TotalRows FROM [' + TABLE_SCHEMA + '].[' + TABLE_NAME + '] UNION ALL '
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'bronze' 
  AND TABLE_TYPE = 'BASE TABLE';

-- Remove the trailing ' UNION ALL ' (11 characters)
IF LEN(@sql) > 0
BEGIN
    SET @sql = LEFT(@sql, LEN(@sql) - 10);
    EXEC sp_executesql @sql;
END;
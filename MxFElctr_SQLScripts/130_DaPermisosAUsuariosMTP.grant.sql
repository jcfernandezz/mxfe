-------------------------------------------------------------------------------------------
--Propósito. Permiso a usuarios Windows:
--Requisito. El login debe estar creado.
--			No existen usuarios huérfanos. Usar: verifica usuarios huérfanos de login.select.sql
--
-------------------------------------------------------------------------------------------

USE dynamics;
IF not EXISTS (SELECT * FROM sys.database_principals WHERE name = N'MTP\Juan.Fernandez')
	CREATE USER [MTP\Juan.Fernandez] FOR LOGIN [MTP\Juan.Fernandez];

IF not EXISTS (SELECT * FROM sys.database_principals WHERE name = N'MTP\Localization Mexico')
	CREATE USER [MTP\Localization Mexico] FOR LOGIN [MTP\Localization Mexico];

EXEC sp_addrolemember 'rol_cfdigital', 'MTP\Localization Mexico';
EXEC sp_addrolemember 'rol_cfdigital', 'MTP\Juan.Fernandez';


use mtp1;
IF not EXISTS (SELECT * FROM sys.database_principals WHERE name = N'MTP\Juan.Fernandez')
	CREATE USER [MTP\Juan.Fernandez] FOR LOGIN [MTP\Juan.Fernandez];

IF not EXISTS (SELECT * FROM sys.database_principals WHERE name = N'MTP\Localization Mexico')
	CREATE USER [MTP\Localization Mexico] FOR LOGIN [MTP\Localization Mexico];
	
EXEC sp_addrolemember 'rol_cfdigital', 'MTP\Localization Mexico';
EXEC sp_addrolemember 'rol_cfdigital', 'MTP\Juan.Fernandez';

use mtp2;
IF not EXISTS (SELECT * FROM sys.database_principals WHERE name = N'MTP\Juan.Fernandez')
	CREATE USER [MTP\Juan.Fernandez] FOR LOGIN [MTP\Juan.Fernandez];

IF not EXISTS (SELECT * FROM sys.database_principals WHERE name = N'MTP\Localization Mexico')
	CREATE USER [MTP\Localization Mexico] FOR LOGIN [MTP\Localization Mexico];
	
EXEC sp_addrolemember 'rol_cfdigital', 'MTP\Localization Mexico';
EXEC sp_addrolemember 'rol_cfdigital', 'MTP\Juan.Fernandez';


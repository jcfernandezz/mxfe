-------------------------------------------------------------------------------------------
--Permiso a usuarios Windows:
-------------------------------------------------------------------------------------------
use dynamics;
EXEC sp_addrolemember 'rol_cfdigital', 'MEMCO-DS01\GPCustomization';
EXEC sp_addrolemember 'rol_cfdigital', 'MEMCO-DS01\tilselam';

use ZMMEX; --TEST
EXEC sp_addrolemember 'rol_cfdigital', 'MEMCO-DS01\GPCustomization';
EXEC sp_addrolemember 'rol_cfdigital', 'MEMCO-DS01\tilselam';


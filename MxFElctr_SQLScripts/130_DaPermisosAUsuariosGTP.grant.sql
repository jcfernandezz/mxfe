-------------------------------------------------------------------------------------------
--Permiso a usuarios Windows:
-------------------------------------------------------------------------------------------
use dynamics;
EXEC sp_addrolemember 'rol_cfdigital', 'GTP\MX Electronic Invoicing';
EXEC sp_addrolemember 'rol_cfdigital', 'GTP\jcfern�ndez';


use la103;
EXEC sp_addrolemember 'rol_cfdigital', 'GTP\MX Electronic Invoicing';
EXEC sp_addrolemember 'rol_cfdigital', 'GTP\jcfern�ndez';

use la124;
EXEC sp_addrolemember 'rol_cfdigital', 'GTP\MX Electronic Invoicing';
EXEC sp_addrolemember 'rol_cfdigital', 'GTP\jcfern�ndez';


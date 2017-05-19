--GETTY
--Factura Electr�nica
--Prop�sito. Accesos a objetos de reporte de factura electr�nica
--Requisitos. Ejecutar antes los permisos para factura electr�nica (110) y los permisos a los reportes de impresi�n (120)
--			Para usuario de dominio: Crear login y accesos a bds: Dynamics, [GCOL], INTDB2
--Atenci�n! en el explorador de Windows 2008: 
--		Dar permiso a las carpetas de almacenamiento de facturas electr�nicas. Usar share, permission level Contributor
--		Dar permiso a la carpeta de aplicaci�n de factura electr�nica. Usar share, permission level Contributor
--		Dar permiso a la carpeta del reporte crystal de la factura 
-------------------------------------------------------------------------------------------
--Permiso a usuarios Windows:
-------------------------------------------------------------------------------------------
use mex10; 
create user [GILA\mayra.garcia ] for login [GILA\mayra.garcia];
--gmope
EXEC sp_addrolemember 'rol_cfdigital', 'GILA\tiiselam' ;
EXEC sp_addrolemember 'rol_cfdigital', 'GILA\ext-tiiselam4';
EXEC sp_addrolemember 'rol_cfdigital', 'GILA\daniel.montes';
EXEC sp_addrolemember 'rol_cfdigital', 'GILA\mauricio.gomez';
EXEC sp_addrolemember 'rol_cfdigital', 'GILA\alma.licea';
EXEC sp_addrolemember 'rol_cfdigital', 'GILA\luis.flores';
EXEC sp_addrolemember 'rol_cfdigital', 'GILA\lucia.mompo';
EXEC sp_addrolemember 'rol_cfdigital', 'GILA\mayra.garcia';

--gusa
--EXEC sp_addrolemember 'rol_cfdigital', 'GILA\javier.iglesias';
--EXEC sp_addrolemember 'rol_cfdigital', 'GILA\jimena.lagomarsino';
--EXEC sp_addrolemember 'rol_cfdigital', 'GILA\nurys.sanchezmartine';


use dynamics;
create user [GILA\mayra.garcia ] for login [GILA\mayra.garcia];
EXEC sp_addrolemember 'rol_cfdigital', 'GILA\tiiselam';
EXEC sp_addrolemember 'rol_cfdigital', 'GILA\ext-tiiselam4';
EXEC sp_addrolemember 'rol_cfdigital', 'GILA\contador.mexico';
EXEC sp_addrolemember 'rol_cfdigital', 'GILA\daniel.montes';
EXEC sp_addrolemember 'rol_cfdigital', 'GILA\mauricio.gomez';
EXEC sp_addrolemember 'rol_cfdigital', 'GILA\alma.licea';
EXEC sp_addrolemember 'rol_cfdigital', 'GILA\javier.iglesias';
EXEC sp_addrolemember 'rol_cfdigital', 'GILA\jimena.lagomarsino';
EXEC sp_addrolemember 'rol_cfdigital', 'GILA\nurys.sanchezmartine';
EXEC sp_addrolemember 'rol_cfdigital', 'GILA\luis.flores';
EXEC sp_addrolemember 'rol_cfdigital', 'GILA\lucia.mompo';
EXEC sp_addrolemember 'rol_cfdigital', 'GILA\mayra.garcia';

use intdb2;
create user [GILA\mayra.garcia ] for login [GILA\mayra.garcia];
EXEC sp_addrolemember 'rol_cfdigital', 'GILA\tiiselam';
EXEC sp_addrolemember 'rol_cfdigital', 'GILA\ext-tiiselam4';
EXEC sp_addrolemember 'rol_cfdigital', 'GILA\contador.mexico';
EXEC sp_addrolemember 'rol_cfdigital', 'GILA\daniel.montes';
EXEC sp_addrolemember 'rol_cfdigital', 'GILA\mauricio.gomez';
EXEC sp_addrolemember 'rol_cfdigital', 'GILA\alma.licea';
EXEC sp_addrolemember 'rol_cfdigital', 'GILA\javier.iglesias';
EXEC sp_addrolemember 'rol_cfdigital', 'GILA\jimena.lagomarsino';
EXEC sp_addrolemember 'rol_cfdigital', 'GILA\nurys.sanchezmartine';
EXEC sp_addrolemember 'rol_cfdigital', 'GILA\luis.flores';
EXEC sp_addrolemember 'rol_cfdigital', 'GILA\lucia.mompo';
EXEC sp_addrolemember 'rol_cfdigital', 'GILA\mayra.garcia';

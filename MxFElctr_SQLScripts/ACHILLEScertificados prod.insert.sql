--achilles México PROD
--Inserta datos de certificados
--

------------------------------------------------------------------------------------------------------------
use MX67P	--achilles México
go

insert into cfd_CER00100 
( ID_Certificado, ruta_certificado, ruta_clave,contrasenia_clave, fecha_vig_desde, fecha_vig_hasta, estado, [fecha_ultima_modificacio], [TIME1], [usr_ultima_modificacion])
values('PAC', '\\VSPRODMSGP1\AchillesMexico\fePAC\prod-0000290.cer', 
				'\\VSPRODMSGP1\AchillesMexico\fePAC\prod-0000290.pfx', 
				'OUTZCU39', '10/22/2015', '7/23/2020', 1, 0, 0, '');

insert into cfd_CER00100 
( ID_Certificado, ruta_certificado, ruta_clave,contrasenia_clave, fecha_vig_desde, fecha_vig_hasta, estado, [fecha_ultima_modificacio], [TIME1], [usr_ultima_modificacion])
values('CERT01', '\\VSPRODMSGP1\AchillesMexico\feCIA\CSD_AQUILES_AME150313KKA_20150414_192318s.cer', 
				'\\VSPRODMSGP1\AchillesMexico\feCIA\CSD_AQUILES_AME150313KKA_20150414_192318s.key', 
				'AQUILE15', '4/14/2015', '4/14/2019', 1, 0, 0, '');
go

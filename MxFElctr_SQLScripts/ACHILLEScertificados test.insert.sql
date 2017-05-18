--achilles México TEST
--Inserta datos de certificados de test
--

------------------------------------------------------------------------------------------------------------
use CL67T	--achilles México
go

insert into cfd_CER00100 
( ID_Certificado, ruta_certificado, ruta_clave,contrasenia_clave, fecha_vig_desde, fecha_vig_hasta, estado, [fecha_ultima_modificacio], [TIME1], [usr_ultima_modificacion])
values('PAC', '\\sabgsqltest01\AchillesMexico\fePAC\tst-0000290.cer', 
				'\\sabgsqltest01\AchillesMexico\fePAC\tst-0000290.pfx', 
				'CLKUSL68', '10/22/2015', '7/24/2020', 1, 0, 0, '')
go
insert into cfd_CER00100 
( ID_Certificado, ruta_certificado, ruta_clave,contrasenia_clave, fecha_vig_desde, fecha_vig_hasta, estado, [fecha_ultima_modificacio], [TIME1], [usr_ultima_modificacion])
values('CERT01', '\\sabgsqltest01\AchillesMexico\feCIA\CSD01_AAA010101AAA.cer', 
				'\\sabgsqltest01\AchillesMexico\feCIA\CSD01_AAA010101AAA.key', 
				'12345678a', '5/7/13', '5/7/2017', 1, 0, 0, '')
go

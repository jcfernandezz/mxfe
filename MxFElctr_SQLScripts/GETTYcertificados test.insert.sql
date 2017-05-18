--Inserta datos de certificados de test
--
use gmope
go

insert into cfd_CER00100 
( ID_Certificado, ruta_certificado, ruta_clave,contrasenia_clave, fecha_vig_desde, fecha_vig_hasta, estado, [fecha_ultima_modificacio], [TIME1], [usr_ultima_modificacion])
values('PAC', '\\gilabasrdb04\GettyMX_FacturaElectronicaXml\fePac\tst-0000205.cer', 
				'\\gilabasrdb04\GettyMX_FacturaElectronicaXml\fePac\tst-0000205.pfx', 
				'interfactura205', '5/2/14', '3/28/16', 1, 0, 0, '')
go
insert into cfd_CER00100 
( ID_Certificado, ruta_certificado, ruta_clave,contrasenia_clave, fecha_vig_desde, fecha_vig_hasta, estado, [fecha_ultima_modificacio], [TIME1], [usr_ultima_modificacion])
values('160727', '\\gilabasrdb04\GettyMX_FacturaElectronicaXml\feCIA\aaa010101aaa__csd_01.cer', 
				'\\gilabasrdb04\GettyMX_FacturaElectronicaXml\feCIA\aaa010101aaa__csd_01.key', 
				'12345678a', '7/27/12', '7/27/16', 1, 0, 0, '')
go

use gmser
go

insert into cfd_CER00100 
( ID_Certificado, ruta_certificado, ruta_clave,contrasenia_clave, fecha_vig_desde, fecha_vig_hasta, estado, [fecha_ultima_modificacio], [TIME1], [usr_ultima_modificacion])
values('PAC', '\\gilabasrdb04\GettyMXSrv_FacturaElectronicaXml\fePac\tst-0000082.cer', 
				'\\gilabasrdb04\GettyMXSrv_FacturaElectronicaXml\fePac\tst-0000082.pfx', 
				'interfactura82', '11/25/13', '11/25/15', 1, 0, 0, '')
go
insert into cfd_CER00100 
( ID_Certificado, ruta_certificado, ruta_clave,contrasenia_clave, fecha_vig_desde, fecha_vig_hasta, estado, [fecha_ultima_modificacio], [TIME1], [usr_ultima_modificacion])
values('160727', '\\gilabasrdb04\GettyMXSrv_FacturaElectronicaXml\feCIA\aaa010101aaa__csd_01.cer', 
				'\\gilabasrdb04\GettyMXSrv_FacturaElectronicaXml\feCIA\aaa010101aaa__csd_01.key', 
				'12345678a', '7/27/12', '7/27/16', 1, 0, 0, '')
go

select *
from cfd_CER00100 


--Inserta datos de certificados de test
--
use MEX10
go

insert into cfd_CER00100 
( ID_Certificado, ruta_certificado, ruta_clave,contrasenia_clave, fecha_vig_desde, fecha_vig_hasta, estado, [fecha_ultima_modificacio], [TIME1], [usr_ultima_modificacion])
values('PAC', '\\10.1.1.22\GettyMX_FacturaElectronicaXml\fePac\tst-0000593.cer', 
				'\\10.1.1.22\GettyMX_FacturaElectronicaXml\fePac\tst-0000593.pfx', 
				'qwertyuio213', '2/7/17', '7/24/20', 1, 0, 0, '')
go
insert into cfd_CER00100 
( ID_Certificado, ruta_certificado, ruta_clave,contrasenia_clave, fecha_vig_desde, fecha_vig_hasta, estado, [fecha_ultima_modificacio], [TIME1], [usr_ultima_modificacion])
values('210510', '\\10.1.1.22\GettyMX_FacturaElectronicaXml\feCIA\CSDPruebas01_IF_der.cer', 
				'\\10.1.1.22\GettyMX_FacturaElectronicaXml\feCIA\CSDPruebas01_IF_der.key', 
				'a12345678', '5/11/17', '5/10/21', 1, 0, 0, '')
go

----------------------
select *
from cfd_CER00100 
where id_certificado = 'PAC'

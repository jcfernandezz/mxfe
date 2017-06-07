--Inserta datos de certificados de producción
--
use mex10
go

insert into cfd_CER00100 
( ID_Certificado, ruta_certificado, ruta_clave,contrasenia_clave, fecha_vig_desde, fecha_vig_hasta, estado, [fecha_ultima_modificacio], [TIME1], [usr_ultima_modificacion])
values('PAC', '\\10.1.1.24\GettyMX_FacturaElectronicaXml\fePac\prod-0000593.cer', 
				'\\10.1.1.24\GettyMX_FacturaElectronicaXml\fePac\prod-0000593.pfx', 
				'edcrfvtgvh2112', '2/7/17', '7/24/20', 1, 0, 0, '')
go
insert into cfd_CER00100 
( ID_Certificado, ruta_certificado, ruta_clave,contrasenia_clave, fecha_vig_desde, fecha_vig_hasta, estado, [fecha_ultima_modificacio], [TIME1], [usr_ultima_modificacion])
values('210529', '\\10.1.1.24\GettyMX_FacturaElectronicaXml\feCIA\CSD_CIUDAD_DE_MEXICO_GIM170302BF9_20170529_153809.cer', 
				'\\10.1.1.24\GettyMX_FacturaElectronicaXml\feCIA\CSD_CIUDAD_DE_MEXICO_GIM170302BF9_20170529_153809.key', 
				'GETTY2017', '5/29/17', '5/29/21', 1, 0, 0, '')
go

------------------------------------------------------------------------------------------------------------
select *
from cfd_CER00100 c
where c.id_certificado ='CERT01'

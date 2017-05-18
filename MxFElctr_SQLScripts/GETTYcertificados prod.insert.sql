--Inserta datos de certificados de producción
--
use gmope
go

insert into cfd_CER00100 
( ID_Certificado, ruta_certificado, ruta_clave,contrasenia_clave, fecha_vig_desde, fecha_vig_hasta, estado, [fecha_ultima_modificacio], [TIME1], [usr_ultima_modificacion])
values('PAC', '\\gilabasrap05\GettyMX_FacturaElectronicaXml\fePac\prod-0000054.cer', 
				'\\gilabasrap05\GettyMX_FacturaElectronicaXml\fePac\prod-0000054.pfx', 
				'Awertj7890054', '5/25/15', '5/25/20', 1, 0, 0, '')
go
insert into cfd_CER00100 
( ID_Certificado, ruta_certificado, ruta_clave,contrasenia_clave, fecha_vig_desde, fecha_vig_hasta, estado, [fecha_ultima_modificacio], [TIME1], [usr_ultima_modificacion])
values('22NOV12', '\\gilabasrap05\GettyMX_FacturaElectronicaXml\feCIA\GilaMexOp.cer', 
				'\\gilabasrap05\GettyMX_FacturaElectronicaXml\feCIA\GilaMexOp.key', 
				'GETTYOMA2016', '11/14/2016', '11/10/2020', 1, 0, 0, '')
go

use gmser
go

--update c set estado = 0
--select *
--from cfd_cer00100 c
--where c.id_certificado = 'CERT01'

insert into cfd_CER00100 
( ID_Certificado, ruta_certificado, ruta_clave,contrasenia_clave, fecha_vig_desde, fecha_vig_hasta, estado, [fecha_ultima_modificacio], [TIME1], [usr_ultima_modificacion])
values('PAC', '\\gilabasrap05\GettyMXSrv_FacturaElectronicaXml\fePAC\prod-0000082.cer', 
				'\\gilabasrap05\GettyMXSrv_FacturaElectronicaXml\fePAC\prod-0000082.pfx', 
				'Awertj7890082', '11/6/2015', '07/14/2020', 1, 0, 0, '')
go
insert into cfd_CER00100 
( ID_Certificado, ruta_certificado, ruta_clave,contrasenia_clave, fecha_vig_desde, fecha_vig_hasta, estado, [fecha_ultima_modificacio], [TIME1], [usr_ultima_modificacion])
values('CERT02', '\\gilabasrap05\GettyMXSrv_FacturaElectronicaXml\feCIA\GilaMexSer.cer', 
				'\\gilabasrap05\GettyMXSrv_FacturaElectronicaXml\feCIA\GilaMexSer.key', 
				'GETTYOMA090521', '12/19/16', '12/12/20', 1, 0, 0, '')
go

--select *
--from cfd_CER00100 
--where id_certificado in ( 'PAC', 'CERT01')

--update c set fecha_vig_hasta='12/19/2016'
--			ruta_clave = replace(ruta_clave, 'gilabasrdb01', 'gilabasrap05'), -- fecha_vig_desde='11/6/2015' , fecha_vig_hasta='7/14/2020'
--			ruta_certificado = replace(ruta_certificado, 'gilabasrdb01', 'gilabasrap05') -- fecha_vig_desde='11/6/2015' , fecha_vig_hasta='7/14/2020'
--delete c
select *
from cfd_CER00100 c
where c.id_certificado ='CERT01'

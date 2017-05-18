--Inserta datos de certificados de test
--
use la103
go

insert into cfd_CER00100 
( ID_Certificado, ruta_certificado, ruta_clave,contrasenia_clave, fecha_vig_desde, fecha_vig_hasta, estado, [fecha_ultima_modificacio], [TIME1], [usr_ultima_modificacion])
values('PAC', 'D:\GPElectronicInvoice\feTowersMexTST\fePAC\tst-0000035.cer', 
				'D:\GPElectronicInvoice\feTowersMexTST\fePAC\tst-0000035.pfx', 
				'interfactura35', '6/15/12', '6/5/14', 1, 0, 0, '')
go
insert into cfd_CER00100 
( ID_Certificado, ruta_certificado, ruta_clave,contrasenia_clave, fecha_vig_desde, fecha_vig_hasta, estado, [fecha_ultima_modificacio], [TIME1], [usr_ultima_modificacion])
values('CERT01', 'D:\GPElectronicInvoice\feTowersMexTST\feCIA\aaa010101aaa__csd_01.cer', 
				'D:\GPElectronicInvoice\feTowersMexTST\feCIA\aaa010101aaa__csd_01.key', 
				'12345678a', '9/25/12', '9/15/16', 1, 0, 0, '')
go

use la124
go

insert into cfd_CER00100 
( ID_Certificado, ruta_certificado, ruta_clave,contrasenia_clave, fecha_vig_desde, fecha_vig_hasta, estado, [fecha_ultima_modificacio], [TIME1], [usr_ultima_modificacion])
values('PAC', 'D:\GPElectronicInvoice\feCentroMexTST\fePAC\tst-0000034.cer', 
				'D:\GPElectronicInvoice\feCentroMexTST\fePAC\tst-0000034.pfx', 
				'interfactura34', '6/15/12', '6/5/14', 1, 0, 0, '')
go
insert into cfd_CER00100 
( ID_Certificado, ruta_certificado, ruta_clave,contrasenia_clave, fecha_vig_desde, fecha_vig_hasta, estado, [fecha_ultima_modificacio], [TIME1], [usr_ultima_modificacion])
values('CERT01', 'D:\GPElectronicInvoice\feCentroMexTST\feCIA\aaa010101aaa__csd_01.cer', 
				'D:\GPElectronicInvoice\feCentroMexTST\feCIA\aaa010101aaa__csd_01.key', 
				'12345678a', '7/12/12', '7/2/16', 1, 0, 0, '')
go

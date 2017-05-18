--Inserta datos de certificados de test
--
use MTP1 
go

insert into cfd_CER00100 
( ID_Certificado, ruta_certificado, ruta_clave,contrasenia_clave, fecha_vig_desde, fecha_vig_hasta, estado, [fecha_ultima_modificacio], [TIME1], [usr_ultima_modificacion])
values('PAC', '\\mtp-colo-fp01\Company$\GP_Share\Invoices\MTPtest\fePAC\tst-0000194.cer', 
				'\\mtp-colo-fp01\Company$\GP_Share\Invoices\MTPtest\fePAC\tst-0000194.pfx', 
				'interfactura194', '5/2/14', '3/28/16', 1, 0, 0, '')
go
insert into cfd_CER00100 
( ID_Certificado, ruta_certificado, ruta_clave,contrasenia_clave, fecha_vig_desde, fecha_vig_hasta, estado, [fecha_ultima_modificacio], [TIME1], [usr_ultima_modificacion])
values('CERT01', '\\mtp-colo-fp01\Company$\GP_Share\Invoices\MTPtest\feCIA\aaa010101aaa__csd_01.cer', 
				'\\mtp-colo-fp01\Company$\GP_Share\Invoices\MTPtest\feCIA\aaa010101aaa__csd_01.key', 
				'12345678a', '7/27/12', '7/27/16', 1, 0, 0, '')
go
------------------------------------------------------------------------------------------------------------
use MTP2
go

insert into cfd_CER00100 
( ID_Certificado, ruta_certificado, ruta_clave,contrasenia_clave, fecha_vig_desde, fecha_vig_hasta, estado, [fecha_ultima_modificacio], [TIME1], [usr_ultima_modificacion])
values('PAC', '\\mtp-colo-fp01\Company$\GP_Share\Invoices\CapsaTest\fePAC\tst-0000211.cer', 
				'\\mtp-colo-fp01\Company$\GP_Share\Invoices\CapsaTest\fePAC\tst-0000211.pfx', 
				'interfactura211', '5/2/14', '3/28/16', 1, 0, 0, '')
go
insert into cfd_CER00100 
( ID_Certificado, ruta_certificado, ruta_clave,contrasenia_clave, fecha_vig_desde, fecha_vig_hasta, estado, [fecha_ultima_modificacio], [TIME1], [usr_ultima_modificacion])
values('CERT01', '\\mtp-colo-fp01\Company$\GP_Share\Invoices\CapsaTest\feCIA\aaa010101aaa__csd_01.cer', 
				'\\mtp-colo-fp01\Company$\GP_Share\Invoices\CapsaTest\feCIA\aaa010101aaa__csd_01.key', 
				'12345678a', '7/27/12', '7/27/16', 1, 0, 0, '')
go

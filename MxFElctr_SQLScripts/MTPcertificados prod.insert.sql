--Inserta datos de certificados de test
--
use MTP1 
go

insert into cfd_CER00100 
( ID_Certificado, ruta_certificado, ruta_clave,contrasenia_clave, fecha_vig_desde, fecha_vig_hasta, estado, [fecha_ultima_modificacio], [TIME1], [usr_ultima_modificacion])
values('PAC', '\\mtp-colo-fp01\Company$\GP_Share\Invoices\MTP\fePAC\prod-0000194.cer', 
				'\\mtp-colo-fp01\Company$\GP_Share\Invoices\MTP\fePAC\prod-0000194.pfx', 
				'Awertj7890194', '5/2/14', '3/18/16', 1, 0, 0, '')
go
insert into cfd_CER00100 
( ID_Certificado, ruta_certificado, ruta_clave,contrasenia_clave, fecha_vig_desde, fecha_vig_hasta, estado, [fecha_ultima_modificacio], [TIME1], [usr_ultima_modificacion])
values('CERT01', '\\mtp-colo-fp01\Company$\GP_Share\Invoices\MTP\feCIA\00001000000304249007.cer', 
				'\\mtp-colo-fp01\Company$\GP_Share\Invoices\MTP\feCIA\00001000000304249007.key', 
				'CoSap712', '5/26/14', '5/16/18', 1, 0, 0, '')
go
------------------------------------------------------------------------------------------------------------
use MTP2	--capsa
go

--insert into cfd_CER00100 
--( ID_Certificado, ruta_certificado, ruta_clave,contrasenia_clave, fecha_vig_desde, fecha_vig_hasta, estado, [fecha_ultima_modificacio], [TIME1], [usr_ultima_modificacion])
--values('PAC', '\\mtp-colo-fp01\Company$\GP_Share\Invoices\Capsa\fePAC\prod-0000211.cer', 
--				'\\mtp-colo-fp01\Company$\GP_Share\Invoices\Capsa\fePAC\prod-0000211.pfx', 
--				'Awertj7890211', '5/2/14', '3/18/16', 1, 0, 0, '')
--go
insert into cfd_CER00100 
( ID_Certificado, ruta_certificado, ruta_clave,contrasenia_clave, fecha_vig_desde, fecha_vig_hasta, estado, [fecha_ultima_modificacio], [TIME1], [usr_ultima_modificacion])
values('PAC', '\\mtp-colo-fp01\Company$\GP_Share\Invoices\Capsa\fePAC\prod-0000194.cer', 
				'\\mtp-colo-fp01\Company$\GP_Share\Invoices\Capsa\fePAC\prod-0000194.pfx', 
				'prod-0000194*', '3/14/2016', '7/24/2100', 1, 0, 0, '')
go
insert into cfd_CER00100 
( ID_Certificado, ruta_certificado, ruta_clave,contrasenia_clave, fecha_vig_desde, fecha_vig_hasta, estado, [fecha_ultima_modificacio], [TIME1], [usr_ultima_modificacion])
values('CERT01', '\\mtp-colo-fp01\Company$\GP_Share\Invoices\Capsa\feCIA\00001000000401024586.cer', 
				 '\\mtp-colo-fp01\Company$\GP_Share\Invoices\Capsa\feCIA\CSD_CAPSA_CAP0005112F8_20151216_124941.key', 
				'Capsa2015', '12/16/15', '12/16/19', 1, 0, 0, '')
go


------------------------------------------------------------------------------------------------------------

select *
from cfd_CER00100
where id_certificado = 'CERT01'


--Inserta datos de certificados de producción
--
use la103
go

insert into cfd_CER00100 
( ID_Certificado, ruta_certificado, ruta_clave,contrasenia_clave, fecha_vig_desde, fecha_vig_hasta, estado, [fecha_ultima_modificacio], [TIME1], [usr_ultima_modificacion])
values('PAC', '\\gtp-fs\companysf\DynamicsGPShare\GPElectronicInvoice\feTowersMex\fePAC\prod-0000035.cer', 
				'\\gtp-fs\companysf\DynamicsGPShare\GPElectronicInvoice\feTowersMex\fePAC\prod-0000035.pfx', 
				'Awertj7890035', '6/15/12', '6/5/14', 1, 0, 0, '')
go
insert into cfd_CER00100 
( ID_Certificado, ruta_certificado, ruta_clave,contrasenia_clave, fecha_vig_desde, fecha_vig_hasta, estado, [fecha_ultima_modificacio], [TIME1], [usr_ultima_modificacion])
values('CERT01', '\\gtp-fs\companysf\DynamicsGPShare\GPElectronicInvoice\feTowersMex\feCIA\00001000000202019605.cer', 
				'\\gtp-fs\companysf\DynamicsGPShare\GPElectronicInvoice\feTowersMex\feCIA\ggt1107198k7_1209252016s.key', 
				'GGT1107198K7', '9/25/12', '9/15/16', 1, 0, 0, '')
go

--use la124
--go
delete from cfd_CER00100
go 
--insert into cfd_CER00100 
--( ID_Certificado, ruta_certificado, ruta_clave,contrasenia_clave, fecha_vig_desde, fecha_vig_hasta, estado, [fecha_ultima_modificacio], [TIME1], [usr_ultima_modificacion])
--values('PAC', '\\gtp-fs\companysf\DynamicsGPShare\GPElectronicInvoice\feCentroMex\fePAC\prod-0000034.cer', 
--				'\\gtp-fs\companysf\DynamicsGPShare\GPElectronicInvoice\feCentroMex\fePAC\prod-0000034.pfx', 
--				'Awertj7890034', '6/15/12', '6/5/14', 1, 0, 0, '')
--go
--insert into cfd_CER00100 
--( ID_Certificado, ruta_certificado, ruta_clave,contrasenia_clave, fecha_vig_desde, fecha_vig_hasta, estado, [fecha_ultima_modificacio], [TIME1], [usr_ultima_modificacion])
--values('CERT01', '\\gtp-fs\companysf\DynamicsGPShare\GPElectronicInvoice\feCentroMex\feCIA\00001000000201536743.cer', 
--				'\\gtp-fs\companysf\DynamicsGPShare\GPElectronicInvoice\feCentroMex\feCIA\imc0803049g5_1207111949s.key', 
--				'Imcnubia12', '7/12/12', '7/2/16', 1, 0, 0, '')
--go

select *
from cfd_CER00100
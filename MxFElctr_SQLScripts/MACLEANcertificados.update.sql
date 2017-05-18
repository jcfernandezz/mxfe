--Actualiza certificados de conexión del PAC
--
USE MMMEX;

update c set ruta_certificado = '\\MEMCODB02\Dynshare\feMCLNMEX\fePAC\prod-0000018.cer', 
		ruta_clave = '\\MEMCODB02\Dynshare\feMCLNMEX\fePAC\prod-0000018.pfx'	--contrasenia_clave = 'Usuario10*', fecha_vig_desde='6/27/2014', fecha_vig_hasta='3/28/2100'
from cfd_CER00100 c
where ID_Certificado = 'PAC'

update c set 
		ruta_certificado =	'\\MEMCODB02\Dynshare\feMCLNMEX\feCIA\00001000000402555297.cer', 
		ruta_clave =		'\\MEMCODB02\Dynshare\feMCLNMEX\feCIA\MEM1112149PA_20160520_111155.key', 
		contrasenia_clave = 'Fervasa1', fecha_vig_desde='5/20/2016', fecha_vig_hasta='5/13/2020'
from cfd_CER00100 c
where ID_Certificado = 'CERT01'


---------------------------------------
USE MMSER;

update c set ruta_certificado = '\\MEMCODB02\Dynshare\feMCLNMEXSER\fePac\prod-0000023.cer', 
		ruta_clave = '\\MEMCODB02\Dynshare\feMCLNMEXSER\fePac\prod-0000023.pfx'	--contrasenia_clave = 'Usuario10*', fecha_vig_desde='6/27/2014', fecha_vig_hasta='3/28/2016'
from cfd_CER00100 c
where ID_Certificado = 'PAC'

update c set ruta_certificado = '\\MEMCODB02\Dynshare\feMCLNMEXSER\feCia\MMS111214I33.cer', 
		ruta_clave = '\\MEMCODB02\Dynshare\feMCLNMEXSER\feCia\MMS111214I33.key',	--contrasenia_clave = 'Usuario10*', 
		fecha_vig_desde='7/4/2016', fecha_vig_hasta='7/1/2020'
from cfd_CER00100 c
where ID_Certificado = 'CERT01'

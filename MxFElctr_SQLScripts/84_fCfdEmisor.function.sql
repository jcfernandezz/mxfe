
IF OBJECT_ID ('dbo.fCfdEmisor') IS NOT NULL
   DROP FUNCTION dbo.fCfdEmisor
GO

create function dbo.fCfdEmisor()
returns table
as
--Prop�sito. Devuelve datos del emisor
--Requisitos. Los impuestos est�n configurados en el campo texto de la compa��a. 
--			Debe indicar el par�metros IMPUESTOS=[idImpuesto1],[idImpuesto2],etc.
--			Debe indicar el par�metros OTROS=[01] � [02]
--			[01] El m�todo de pago es fijo. Si la factura viene de la interface pagada indica tarjeta de cr�dito, sino dep�sito
--				El n�mero de cuenta bancaria viene del campo 1 def por el usuario de la direcci�n de facturaci�n del cliente
--			[02] El m�todo de pago viene del campo 1 tipo lista def por el usuario de la factura
--				El n�mero de cuenta bancaria viene del campo 2 tipo texto def por el usuario de la factura
--Utilizado por. fCfdDatosAdicionales()
--24/04/12 jcf Creaci�n cfdi
--02/07/12 jcf Agrega par�metro OTROS. 
--08/02/17 jcf Elimina estado de lugarExpedicion
--
return
( 
select rtrim(replace(ci.TAXREGTN, 'RFC ', '')) rfc, 
	dbo.fCfdReemplazaSecuenciaDeEspacios(dbo.fCfdReemplazaCaracteresNI(RTRIM(ci.ADRCNTCT)), 10) nombre, 
	dbo.fCfdReemplazaSecuenciaDeEspacios(dbo.fCfdReemplazaCaracteresNI(rtrim(ci.ADDRESS1)), 10) calle, 
	dbo.fCfdReemplazaSecuenciaDeEspacios(dbo.fCfdReemplazaCaracteresNI(rtrim(ci.ADDRESS2)), 10) colonia, 
	dbo.fCfdReemplazaSecuenciaDeEspacios(dbo.fCfdReemplazaCaracteresNI(RTRIM(ci.CITY)), 10) ciudad, 
	dbo.fCfdReemplazaSecuenciaDeEspacios(dbo.fCfdReemplazaCaracteresNI(RTRIM(ci.COUNTY)), 10) municipio, 
	dbo.fCfdReemplazaSecuenciaDeEspacios(dbo.fCfdReemplazaCaracteresNI(RTRIM(ci.[STATE])), 10) estado,  
	dbo.fCfdReemplazaSecuenciaDeEspacios(dbo.fCfdReemplazaCaracteresNI(RTRIM(ci.CMPCNTRY)), 10) pais, 
	dbo.fCfdReemplazaSecuenciaDeEspacios(dbo.fCfdReemplazaCaracteresNI(RTRIM(ci.ZIPCODE)), 10) codigoPostal, 
	left(dbo.fCfdReemplazaSecuenciaDeEspacios(dbo.fCfdReemplazaCaracteresNI(
			rtrim(ci.ADDRESS1)+' '+rtrim(ci.ADDRESS2)+' '+RTRIM(ci.ZIPCODE)+' '+RTRIM(ci.COUNTY)+' '+RTRIM(ci.CITY)+' '+RTRIM(ci.CMPCNTRY)), 10), 250) LugarExpedicion,
	'3.2' [version], 
	dbo.fCfdReemplazaSecuenciaDeEspacios(dbo.fCfdReemplazaCaracteresNI(ISNULL(nt.INET7, '')), 10) rutaXml,
	dbo.fCfdReemplazaSecuenciaDeEspacios(dbo.fCfdReemplazaCaracteresNI(ISNULL(nt.INET8, '')), 10) regimen,
	case when charindex('IMPUESTOS=', nt.inetinfo) > 0 and charindex(char(13), nt.inetinfo) > 0 then
		substring(nt.inetinfo, charindex('IMPUESTOS=', nt.inetinfo)+10, charindex(char(13), nt.inetinfo, charindex('IMPUESTOS=', nt.inetinfo)) - charindex('IMPUESTOS=', nt.inetinfo) -10) 
	else 'no hay impuestos' end impuestos,
	CASE when charindex('OTROS=', nt.inetinfo) > 0 and  charindex(char(13), nt.inetinfo) > 0 then
		substring(nt.inetinfo, charindex('OTROS=', nt.inetinfo)+6, charindex(char(13), nt.inetinfo, charindex('OTROS=', nt.inetinfo)) - charindex('OTROS=', nt.inetinfo) -6) 
	else 'no hay otros datos' end otrosDatos
from DYNAMICS..SY01500 ci			--sy_company_mstr
left join SY01200 nt				--coInetAddress
	on nt.Master_Type = 'CMP'
	and nt.Master_ID = ci.INTERID
	and nt.ADRSCODE = ci.LOCATNID
where ci.INTERID = DB_NAME()
)
go

IF (@@Error = 0) PRINT 'Creaci�n exitosa de la funci�n: fCfdEmisor()'
ELSE PRINT 'Error en la creaci�n de la funci�n: fCfdEmisor()'
GO

------------------------------------------------------------------------------------
--select *
--from dbo.fCfdEmisor()


--FACTURA ELECTRONICA GP - MEXICO
--Proyectos:		GETTY
--Prop�sito:		Genera funciones y vistas de FACTURAS para la facturaci�n electr�nica en GP - MEXICO
--Referencia:		
--		1/11/11 Versi�n CFD 1 -	100823 Normativa formal Anexo 20.pdf, 
--		10/2/12 Versi�n CFD 2.2 - 111230 Normativa Anexo20.doc
--		25/4/12 Versi�n CFDI 3.2 - 111230 Normativa Anexo20.doc
--Utilizado por:	Aplicaci�n C# de generaci�n de factura electr�nica M�xico
-----------------------------------------------------------------------------------------------------------
IF OBJECT_ID ('dbo.fCfdInfoAduaneraXML') IS NOT NULL
   DROP FUNCTION dbo.fCfdInfoAduaneraXML
GO

create function dbo.fCfdInfoAduaneraXML(@ITEMNMBR char(31), @SERLTNUM char(21))
returns xml 
as
--Prop�sito. Obtiene info aduanera para conceptos de importaci�n
--Requisito. Se asume que todos los art�culos importados usan n�mero de serie o lote. De otro modo se consideran nacionales.
--			Tambi�n se asume que no hay n�meros de serie repetidos por art�culo
--17/5/12 jcf Creaci�n
--
begin
	declare @cncp xml;
	select @cncp = null;

	IF isnull(@SERLTNUM, '_NULO') <> '_NULO'	
	begin
		WITH XMLNAMESPACES ('http://www.sat.gob.mx/cfd/3' as "cfdi")
		select @cncp = (
		   select ad.numero, ad.fecha
		   from (
				--En caso de usar n�mero de lote, la info aduanera viene en el n�mero de lote y los atributos del lote
				select top 1 dbo.fCfdReemplazaSecuenciaDeEspacios(ltrim(rtrim(@SERLTNUM)),10) numero, 
						--dbo.fCfdReemplazaSecuenciaDeEspacios(ltrim(rtrim(dbo.fCfdReemplazaCaracteresNI(la.LOTATRB1 +' '+ la.LOTATRB2))),10) numero, 
						replace(convert(varchar(12), la.LOTATRB4, 102), '.', '-') fecha,
						dbo.fCfdReemplazaSecuenciaDeEspacios(ltrim(rtrim(dbo.fCfdReemplazaCaracteresNI(la.LOTATRB3))),10) aduana
				  from iv00301 la				--iv_lot_attributes [ITEMNMBR LOTNUMBR]
				  inner join IV00101 ma			--iv_itm_mstr
					on ma.ITEMNMBR = la.ITEMNMBR
				 where ma.ITMTRKOP = 3			--lote
					and la.ITEMNMBR = @ITEMNMBR
					and la.LOTNUMBR = @SERLTNUM
				union all
				--En caso de usar n�mero de serie, la info aduanera viene de los campos def por el usuario de la recepci�n de compra
				select top 1 dbo.fCfdReemplazaSecuenciaDeEspacios(ltrim(rtrim(dbo.fCfdReemplazaCaracteresNI(ud.user_defined_text01))),10) numero, 
						replace(convert(varchar(12), ud.user_defined_date01, 102), '.', '-') fecha,
						dbo.fCfdReemplazaSecuenciaDeEspacios(ltrim(rtrim(dbo.fCfdReemplazaCaracteresNI(ud.user_defined_text02))),10) aduana
				  from POP30330	rs				--POP_SerialLotHist [POPRCTNM RCPTLNNM QTYTYPE SLTSQNUM]
					inner JOIN POP10306 ud		--POP_ReceiptUserDefined 			
					on ud.POPRCTNM = rs.POPRCTNM
					inner join IV00101 ma		--iv_itm_mstr
					on ma.ITEMNMBR = rs.ITEMNMBR
				where ma.ITMTRKOP = 2			--serie
					and rs.ITEMNMBR = @ITEMNMBR
					and rs.SERLTNUM = @SERLTNUM
				) ad
			FOR XML raw('cfdi:InformacionAduanera') , type
		)
	end
	return @cncp
end
go

IF (@@Error = 0) PRINT 'Creaci�n exitosa de: fCfdInfoAduaneraXML()'
ELSE PRINT 'Error en la creaci�n de: fCfdInfoAduaneraXML()'
GO

-------------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[vwSopLineasTrxVentas]') AND OBJECTPROPERTY(id,N'IsView') = 1)
    DROP view dbo.[vwSopLineasTrxVentas];
GO

create view dbo.vwSopLineasTrxVentas as
--Prop�sito. Obtiene todas las l�neas de facturas de venta SOP y la info aduanera de importaci�n
--			Tambi�n obtiene la serie/lote del art�culo o kits
--Requisito. No incluye descuentos. Todos los descuentos est�n sumados en la cabecera. Ver: fCfdGeneraDocumentoDeVentaXML[descuento]
--			Si el tipo de art�culo es servicio, y el cliente requiere una unidad espec�fica, usar campo COMMENT2.
--				Si no indica una unidad espec�fica, usar: No aplica.
--			Si el tipo de art�culo no es servicio, usar la unidad del art�culo.
--			Atenci�n ! Si la compa��a vende art�culos de inventario DEBE usar unidades de medida listadas en el SAT. 
--			De otro modo, hacer conversiones en esta vista.
--23/04/12 JCF Creaci�n
--26/07/12 jcf Agrega campo UOFMsat para indicar la unidad de medida: No aplica. (mail 24/7/12 de M G�mez)
--02/08/12 jcf Agrega funci�n fCfdUofMSAT para obtener unidad de medida de acuerdo al cliente y al SAT.
--
select dt.soptype, dt.sopnumbe, dt.LNITMSEQ, dt.ITEMNMBR, ISNULL(sr.serltqty, dt.QUANTITY) cantidad, dt.QUANTITY, sr.serltqty, dt.UOFM, 
	case when ma.ITEMTYPE >= 4 then		--4: Misc Charges, 5:servicios, 6:flat fee
			case when rtrim(cs.COMMENT2) = '' then 'No Aplica' 
			else rtrim(cs.COMMENT2) 
			end
	else um.UOFMLONGDESC
	end UOFMsat, 
	sr.SERLTNUM, dt.ITEMDESC, dt.ORUNTPRC, dt.OXTNDPRC, dt.CMPNTSEQ, 
	case when isnull(sr.SOPNUMBE, '_nulo')='_nulo' then 
			cast(dt.QUANTITY * dt.ORUNTPRC as numeric(19,6)) 
		else 
			cast(sr.SERLTQTY * dt.ORUNTPRC as numeric(19,6)) 
	end importe,
	isnull(ma.ITMTRKOP, 1) ITMTRKOP		--3 lote, 2 serie, 1 nada
from SOP30200 cb
inner join SOP30300 dt
	on cb.SOPNUMBE = dt.SOPNUMBE
	and cb.SOPTYPE = dt.SOPTYPE
INNER join rm00101 cs
	on cs.custnmbr = cb.custnmbr
left join iv00101 ma				--iv_itm_mstr
	on ma.ITEMNMBR = dt.ITEMNMBR
left join sop10201 sr				--SOP_Serial_Lot_WORK_HIST
	on sr.SOPNUMBE = dt.SOPNUMBE
	and sr.SOPTYPE = dt.SOPTYPE
	and sr.CMPNTSEQ = dt.CMPNTSEQ
	and sr.LNITMSEQ = dt.LNITMSEQ
outer apply dbo.fCfdUofMSAT(ma.UOMSCHDL, dt.UOFM ) um
go	

IF (@@Error = 0) PRINT 'Creaci�n exitosa de: vwSopLineasTrxVentas'
ELSE PRINT 'Error en la creaci�n de: vwSopLineasTrxVentas'
GO

-------------------------------------------------------------------------------------------------------
IF OBJECT_ID ('dbo.fCfdParteXML') IS NOT NULL
   DROP FUNCTION dbo.fCfdParteXML
GO

create function dbo.fCfdParteXML(@soptype smallint, @sopnumbe char(21), @LNITMSEQ int)
returns xml 
as
--Prop�sito. Obtiene info de componentes de kit e info aduanera
--2/5/12 jcf Creaci�n
--
begin
	declare @cncp xml;
	WITH XMLNAMESPACES ('http://www.sat.gob.mx/cfd/3' as "cfdi")
	select @cncp = (
		select dt.cantidad, 
				case when dt.ITMTRKOP = 2 then --tracking option: serie
					dbo.fCfdReemplazaSecuenciaDeEspacios(ltrim(rtrim(dbo.fCfdReemplazaCaracteresNI(dt.SERLTNUM))),10) 
					else null
				end noIdentificacion, 
				dbo.fCfdReemplazaSecuenciaDeEspacios(ltrim(rtrim(dbo.fCfdReemplazaCaracteresNI(dt.ITEMDESC))), 10) descripcion,
				dbo.fCfdInfoAduaneraXML(dt.ITEMNMBR, dt.SERLTNUM)
		from vwSopLineasTrxVentas dt
		where dt.soptype = @soptype
		and dt.sopnumbe = @sopnumbe
		and dt.LNITMSEQ = @LNITMSEQ
		and dt.CMPNTSEQ <> 0		--a nivel componente de kit
		FOR XML raw('cfdi:Parte') , type
	)
	return @cncp
end
go

IF (@@Error = 0) PRINT 'Creaci�n exitosa de: fCfdParteXML()'
ELSE PRINT 'Error en la creaci�n de: fCfdParteXML()'
GO

--------------------------------------------------------------------------------------------------------

IF OBJECT_ID ('dbo.fCfdConceptosXML') IS NOT NULL
   DROP FUNCTION dbo.fCfdConceptosXML
GO

create function dbo.fCfdConceptosXML(@p_soptype smallint, @p_sopnumbe varchar(21))
returns xml 
as
--Prop�sito. Obtiene las l�neas de una factura en formato xml para CFDI
--			Elimina carriage returns, line feeds, tabs, secuencias de espacios y caracteres especiales.
--23/04/12 jcf Creaci�n
--25/07/12 jcf Modifica unidad de medida: usa UOFMsat.
--14/08/14 jcf El importe debe ser distinto de cero (Achilles)
--
begin
	declare @cncp xml;
	WITH XMLNAMESPACES ('http://www.sat.gob.mx/cfd/3' as "cfdi")
	select @cncp = (
		select 
			Concepto.cantidad				'@cantidad', 
			rtrim(Concepto.UOFMsat)			'@unidad', 
			case when Concepto.ITMTRKOP = 2 then --tracking option: serie
				dbo.fCfdReemplazaSecuenciaDeEspacios(ltrim(rtrim(dbo.fCfdReemplazaCaracteresNI(Concepto.SERLTNUM))),10) 
				else null
			end '@noIdentificacion',
			dbo.fCfdReemplazaSecuenciaDeEspacios(ltrim(rtrim(dbo.fCfdReemplazaCaracteresNI(Concepto.ITEMDESC))), 10) '@descripcion', 
			Concepto.ORUNTPRC				'@valorUnitario',
			Concepto.importe				'@importe',
			dbo.fCfdInfoAduaneraXML(Concepto.ITEMNMBR, Concepto.SERLTNUM),
			dbo.fCfdParteXML(Concepto.soptype, Concepto.sopnumbe, Concepto.LNITMSEQ) 
		from vwSopLineasTrxVentas Concepto
		where CMPNTSEQ = 0					--a nivel kit
		and Concepto.soptype = @p_soptype
		and Concepto.sopnumbe = @p_sopnumbe
		and Concepto.importe != 0          
		FOR XML path('cfdi:Concepto'), type, root('cfdi:Conceptos')
	)
	return @cncp
end
go

IF (@@Error = 0) PRINT 'Creaci�n exitosa de: fCfdConceptosXML()'
ELSE PRINT 'Error en la creaci�n de: fCfdConceptosXML()'
GO

--------------------------------------------------------------------------------------------------------
IF OBJECT_ID ('dbo.fCfdImpuestosXML') IS NOT NULL
begin
   DROP FUNCTION dbo.fCfdImpuestosXML
   print 'funci�n fCfdImpuestosXML eliminada'
end
GO

create function dbo.fCfdImpuestosXML(@p_soptype smallint, @p_sopnumbe varchar(21), @p_impuestos varchar(150))
returns xml 
as
begin
	declare @impu xml;
	WITH XMLNAMESPACES ('http://www.sat.gob.mx/cfd/3' as "cfdi")
	select @impu = (
		select 	
			case when charindex(RTRIM(imp.taxdtlid), @p_impuestos) > 0 then 'IVA' else '' end impuesto,
			dbo.fCfdObtienePorcentajeImpuesto (imp.taxdtlid) tasa,
			imp.orslstax importe
		from sop10105 imp	--sop_tax_work_hist
 		where imp.SOPTYPE = @p_soptype
		  and imp.SOPNUMBE = @p_sopnumbe
		  and imp.LNITMSEQ = 0
		  and charindex(RTRIM(imp.taxdtlid), @p_impuestos) > 0
		FOR XML raw('cfdi:Traslado'), type, root('cfdi:Traslados')
		)
	return @impu
end
go

IF (@@Error = 0) PRINT 'Creaci�n exitosa de la funci�n: fCfdImpuestosXML()'
ELSE PRINT 'Error en la creaci�n de la funci�n: fCfdImpuestosXML()'
GO
--------------------------------------------------------------------------------------------------------
IF OBJECT_ID ('dbo.fCfdCertificadoVigente') IS NOT NULL
   DROP FUNCTION dbo.fCfdCertificadoVigente
GO

create function dbo.fCfdCertificadoVigente(@fecha datetime)
returns table
as
--Prop�sito. Verifica que la fecha corresponde a un certificado vigente y activo
--			Si existe m�s de uno o ninguno, devuelve el estado: inconsistente
--			Tambi�n devuelve datos del folio y certificado asociado.
--Requisitos. Los estados posibles para generar o no archivos xml son: no emitido, inconsistente
--24/4/12 jcf Creaci�n cfdi
--23/5/12 jcf El id: PAC est� reservado para los certificados del PAC
--
return
(  
	--declare @fecha datetime
	--select @fecha = '1/4/12'
	select top 1 --fyc.noAprobacion, fyc.anoAprobacion, 
			fyc.ID_Certificado, fyc.ruta_certificado, fyc.ruta_clave, fyc.contrasenia_clave, fyc.fila, 
			case when fyc.fila > 1 then 'inconsistente' else 'no emitido' end estado
	from (
		SELECT top 2 rtrim(B.ID_Certificado) ID_Certificado, rtrim(B.ruta_certificado) ruta_certificado, rtrim(B.ruta_clave) ruta_clave, 
				rtrim(B.contrasenia_clave) contrasenia_clave, row_number() over (order by B.ID_Certificado) fila
		FROM cfd_CER00100 B
		WHERE B.estado = '1'
			and B.id_certificado <> 'PAC'	--El id PAC est� reservado para el PAC
			and datediff(day, B.fecha_vig_desde, @fecha) >= 0
			and datediff(day, B.fecha_vig_hasta, @fecha) <= 0
		) fyc
	order by fyc.fila desc
)
go

IF (@@Error = 0) PRINT 'Creaci�n exitosa de la funci�n: fCfdCertificadoVigente()'
ELSE PRINT 'Error en la creaci�n de la funci�n: fCfdCertificadoVigente()'
GO

--------------------------------------------------------------------------------------------------------
IF OBJECT_ID ('dbo.fCfdCertificadoPAC') IS NOT NULL
   DROP FUNCTION dbo.fCfdCertificadoPAC
GO

create function dbo.fCfdCertificadoPAC(@fecha datetime)
returns table
as
--Prop�sito. Obtiene el certificado del PAC. 
--			Verifica que la fecha corresponde a un certificado vigente y activo
--Requisitos. El id PAC est� reservado para registrar el certificado del PAC. 
--23/5/12 jcf Creaci�n
--
return
(  
	--declare @fecha datetime
	--select @fecha = '5/4/12'
	SELECT rtrim(B.ID_Certificado) ID_Certificado, rtrim(B.ruta_certificado) ruta_certificado, rtrim(B.ruta_clave) ruta_clave, 
			rtrim(B.contrasenia_clave) contrasenia_clave
	FROM cfd_CER00100 B
	WHERE B.estado = '1'
		and B.id_certificado = 'PAC'	--El id PAC est� reservado para el PAC
		and datediff(day, B.fecha_vig_desde, @fecha) >= 0
		and datediff(day, B.fecha_vig_hasta, @fecha) <= 0
)
go

IF (@@Error = 0) PRINT 'Creaci�n exitosa de la funci�n: fCfdCertificadoPAC()'
ELSE PRINT 'Error en la creaci�n de la funci�n: fCfdCertificadoPAC()'
GO

--------------------------------------------------------------------------------------------------------
IF OBJECT_ID ('dbo.fCfdGeneraDocumentoDeVentaXML') IS NOT NULL
   DROP FUNCTION dbo.fCfdGeneraDocumentoDeVentaXML
GO

create function dbo.fCfdGeneraDocumentoDeVentaXML (@soptype smallint, @sopnumbe varchar(21))
returns xml 
as
--Prop�sito. Elabora un comprobante xml para factura electr�nica cfdi
--Requisitos. El total de impuestos de la factura debe corresponder a la suma del detalle de impuestos. 
--				En un futuro se deber�a usar fCfdTotalImpuestos que ahora est� comentada.
--				No incluye retenciones.
--24/04/12 jcf Creaci�n cfdi
--12/06/12 jcf Agrega NumCtaPago
--13/11/12 jcf Habilita nodo direcci�n del receptor. Solicitado por Televisa.
--31/01/17 jcf Agrega noExterior, municipio del receptor
--17/02/17 jcf Agrega noExterior al emisor
--
begin
	declare @cfd xml;
	WITH XMLNAMESPACES
	(
				'http://www.w3.org/2001/XMLSchema-instance' as "xsi",
				'http://www.sat.gob.mx/cfd/3' as "cfdi"
	)
	select @cfd = 
	(
	select 
		'http://www.sat.gob.mx/cfd/3 http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv32.xsd'	'@xsi:schemaLocation',
		emi.[version]										'@version',
		rtrim(tv.docid)										'@serie',
		rtrim(tv.sopnumbe)									'@folio',
		convert(datetime, tv.fechahora, 126)				'@fecha',
		''													'@sello', 
		tv.formaDePago										'@formaDePago',
		''													'@noCertificado', 
		''													'@certificado', 
		tv.subtotal											'@subTotal',
		tv.descuento										'@descuento',
		tv.xchgrate											'@TipoCambio',
		tv.curncyid											'@Moneda',
		tv.total											'@total',
		case when tv.SOPTYPE = 3 then 
				'ingreso' else 'egreso' end					'@tipoDeComprobante',
		tv.metodoDePago										'@metodoDePago',
		emi.LugarExpedicion									'@LugarExpedicion',
		tv.NumCtaPago										'@NumCtaPago',
		emi.rfc												'cfdi:Emisor/@rfc',
		emi.nombre											'cfdi:Emisor/@nombre', 

--		emi.calle											'cfdi:Emisor/cfdi:DomicilioFiscal/@calle', 
		case when patindex('%#%', emi.calle) = 0 then 
			emi.calle 
		else rtrim(left(rtrim(emi.calle), patindex('%#%', emi.calle)-1))
		end													'cfdi:Emisor/cfdi:DomicilioFiscal/@calle', 
		case when patindex('%#%', emi.calle) = 0 then 
			null
		else right(rtrim(emi.calle), len(emi.calle)-patindex('%#%', emi.calle)) 
		end													'cfdi:Emisor/cfdi:DomicilioFiscal/@noExterior', 

		emi.colonia											'cfdi:Emisor/cfdi:DomicilioFiscal/@colonia', 
		emi.ciudad											'cfdi:Emisor/cfdi:DomicilioFiscal/@localidad', 
		emi.municipio										'cfdi:Emisor/cfdi:DomicilioFiscal/@municipio',
		emi.estado											'cfdi:Emisor/cfdi:DomicilioFiscal/@estado',
		emi.pais											'cfdi:Emisor/cfdi:DomicilioFiscal/@pais',
		emi.codigoPostal									'cfdi:Emisor/cfdi:DomicilioFiscal/@codigoPostal',
		emi.regimen											'cfdi:Emisor/cfdi:RegimenFiscal/@Regimen',
		tv.idImpuestoCliente								'cfdi:Receptor/@rfc',
		tv.nombreCliente									'cfdi:Receptor/@nombre', 

--		tv.address1											'cfdi:Receptor/cfdi:Domicilio/@calle',
		case when patindex('%#%', tv.address1) = 0 then 
			tv.address1 
		else rtrim(left(rtrim(tv.address1), patindex('%#%', tv.address1)-1))
		end													'cfdi:Receptor/cfdi:Domicilio/@calle',
		case when patindex('%#%', tv.address1) = 0 then 
			null
		else right(rtrim(tv.address1), len(tv.address1)-patindex('%#%', tv.address1)) 
		end													'cfdi:Receptor/cfdi:Domicilio/@noExterior',
		tv.address2											'cfdi:Receptor/cfdi:Domicilio/@colonia',
		tv.city												'cfdi:Receptor/cfdi:Domicilio/@localidad',
		tv.address3											'cfdi:Receptor/cfdi:Domicilio/@municipio',
		tv.[state]											'cfdi:Receptor/cfdi:Domicilio/@estado',
		tv.country											'cfdi:Receptor/cfdi:Domicilio/@pais',
		tv.zipcode											'cfdi:Receptor/cfdi:Domicilio/@codigoPostal',
		dbo.fCfdConceptosXML(tv.soptype, tv.sopnumbe),
		--case when tv.impuesto <> im.totalImpuestos then null else 'error' end		'cfdi:Impuestos/@error'
		tv.impuesto											'cfdi:Impuestos/@totalImpuestosTrasladados',
		isnull(dbo.fCfdImpuestosXML(tv.soptype, tv.sopnumbe, emi.impuestos), ' ')	'cfdi:Impuestos',
		''													'cfdi:Complemento'
	from vwSopTransaccionesVenta tv
		cross join dbo.fCfdEmisor() emi
		--left join dbo.fCfdTotalImpuestos(tv.soptype, tv.sopnumbe, emi.impuestos) im
	where tv.sopnumbe =	@sopnumbe		
	and tv.soptype = @soptype
	FOR XML path('cfdi:Comprobante'), type
	)
	return @cfd;
end
go

IF (@@Error = 0) PRINT 'Creaci�n exitosa de la funci�n: fCfdGeneraDocumentoDeVentaXML ()'
ELSE PRINT 'Error en la creaci�n de la funci�n: fCfdGeneraDocumentoDeVentaXML ()'
GO
-----------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[vwCfdTransaccionesDeVenta]') AND OBJECTPROPERTY(id,N'IsView') = 1)
    DROP view dbo.[vwCfdTransaccionesDeVenta];
GO

create view dbo.vwCfdTransaccionesDeVenta as
--Prop�sito. Todos los documentos de venta: facturas y notas de cr�dito. 
--			Incluye la cadena original para el cfdi.
--			Si el documento no fue emitido, genera el comprobante xml en el campo comprobanteXml
--Usado por. App Factura digital (doodads)
--Requisitos. El estado "no emitido" indica que no se ha emitido el archivo xml pero que est� listo para ser generado.
--			El estado "inconsistente" indica que existe un problema en el folio o certificado, por tanto no puede ser generado.
--			El estado "emitido" indica que el archivo xml ha sido generado y sellado por el PAC y est� listo para ser impreso.
--24/04/12 jcf Creaci�n cfdi
--23/05/12 jcf Agrega datos del certificado del PAC
--10/07/12 jcf Agrega metodoDePago, NumCtaPago
--07/11/12 jcf Agrega par�metro a fCfdAddendaXML
--24/02/14 jcf Agrega par�metro a fCfdAddendaXML para cliente Mabe
--14/09/17 jcf Agrega par�metros incluyeAddendaDflt para addenda predeterminada para todos los clientes. Utilizado en MTP
--
select tv.estadoContabilizado, tv.soptype, tv.docid, tv.sopnumbe, tv.fechahora, 
	tv.CUSTNMBR, tv.nombreCliente, tv.idImpuestoCliente, tv.total, tv.voidstts, 

	isnull(lf.estado, isnull(fv.estado, 'inconsistente')) estado,
	case when isnull(lf.estado, isnull(fv.estado, 'inconsistente')) = 'inconsistente' 
		then 'folio o certificado inconsistente'
		else ISNULL(lf.mensaje, tv.estadoContabilizado)
	end mensaje,
	case when isnull(lf.estado, isnull(fv.estado, 'inconsistente')) = 'no emitido' 
		then dbo.fCfdGeneraDocumentoDeVentaXML (tv.soptype, tv.sopnumbe) 
		else cast('' as xml) 
	end comprobanteXml,
	
	--Datos del xml sellado por el PAC:
	isnull(dx.selloCFD, '') selloCFD, 
	isnull(dx.FechaTimbrado, '') FechaTimbrado, 
	isnull(dx.UUID, '') UUID, 
	isnull(dx.noCertificadoSAT, '') noCertificadoSAT, 
	isnull(dx.[version], '') [version], 
	isnull(dx.selloSAT, '') selloSAT, 
	isnull(dx.formaDePago, '') formaDePago,
	isnull(dx.sello, '') sello, 
	isnull(dx.noCertificado, '') noCertificado, 
	isnull(dx.noAprobacion, '') noAprobacion, 
	convert(varchar(5), isnull(dx.anoAprobacion, 0)) anoAprobacion,
	'||'+dx.[version]+'|'+dx.UUID+'|'+dx.FechaTimbrado+'|'+dx.selloCFD+'|'+dx.noCertificadoSAT+'||' cadenaOriginalSAT,
	
	fv.ID_Certificado, fv.ruta_certificado, fv.ruta_clave, fv.contrasenia_clave, 
	isnull(pa.ruta_certificado, '_noexiste') ruta_certificadoPac, isnull(pa.ruta_clave, '_noexiste') ruta_clavePac, isnull(pa.contrasenia_clave, '') contrasenia_clavePac, 
	emi.rfc, emi.regimen, emi.rutaXml, tv.nroOrden USERDEF1,
	isnull(lf.estadoActual, '000000') estadoActual, 
	isnull(lf.mensajeEA, tv.estadoContabilizado) mensajeEA,
	isnull(dx.metodoDePago, '') metodoDePago,
	isnull(dx.NumCtaPago, '') NumCtaPago,
	dbo.fCfdAddendaXML(tv.custnmbr,  tv.soptype, tv.sopnumbe, tv.docid, tv.cstponbr, tv.curncyid, tv.docdate, tv.xchgrate, tv.subtotal, tv.total, emi.incluyeAddendaDflt) addenda
from vwSopTransaccionesVenta tv
	cross join dbo.fCfdEmisor() emi
	outer apply dbo.fCfdCertificadoVigente(tv.fechahora) fv
	outer apply dbo.fCfdCertificadoPAC(tv.fechahora) pa
	left join cfdlogfacturaxml lf
		on lf.soptype = tv.SOPTYPE
		and lf.sopnumbe = tv.sopnumbe
		and lf.estado = 'emitido'
	outer apply dbo.fCfdDatosXmlParaImpresion(lf.archivoXML) dx
go

IF (@@Error = 0) PRINT 'Creaci�n exitosa de la vista: vwCfdTransaccionesDeVenta'
ELSE PRINT 'Error en la creaci�n de la vista: vwCfdTransaccionesDeVenta'
GO

-----------------------------------------------------------------------------------------
--IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[vwCfdDocumentosAImprimir]') AND OBJECTPROPERTY(id,N'IsView') = 1)
--    DROP view dbo.[vwCfdDocumentosAImprimir];
--GO
IF (OBJECT_ID ('dbo.vwCfdDocumentosAImprimir', 'V') IS NULL)
   exec('create view dbo.vwCfdDocumentosAImprimir as SELECT 1 as t');
go

alter view dbo.vwCfdDocumentosAImprimir as
--Prop�sito. Lista los documentos de venta que est�n listos para imprimirse: facturas y notas de cr�dito. 
--			Incluye los datos del cfdi.
--07/05/12 jcf Creaci�n
--29/05/12 jcf Cambia la ruta para que funcione en SSRS
--10/07/12 jcf Agrega metodoDePago, NumCtaPago
--29/08/13 jcf Agrega USERDEF1 (nroOrden)
--11/09/13 jcf Agrega ruta del archivo en formato de red
--09/07/14 jcf Modifica la obtenci�n del nombre del archivo
--13/07/16 jcf Agrega cat�logo de m�todo de pago
--19/10/16 jcf Agrega rutaFileDrive. Util para reportes Crystal
--
select tv.soptype, tv.docid, tv.sopnumbe, tv.fechahora fechaHoraEmision, tv.regimen regimenFiscal, 
	tv.idImpuestoCliente rfcReceptor, tv.nombreCliente, tv.total, formaDePago, 
	--isnull(ca.descripcion, tv.metodoDePago) metodoDePago, 
	tv.metodoDePago,
	tv.NumCtaPago, tv.USERDEF1, 
	UUID folioFiscal, noCertificado noCertificadoCSD, [version], selloCFD, selloSAT, cadenaOriginalSAT, noCertificadoSAT, FechaTimbrado, 
	--tv.rutaxml								+ 'cbb\' + replace(tv.mensaje, 'Almacenado en '+tv.rutaxml, '')+'.jpg' rutaYNomArchivoNet,
	'file://'+replace(tv.rutaxml, '\', '/') + 'cbb/' + RIGHT( tv.mensaje, CHARINDEX( '\', REVERSE( tv.mensaje ) + '\' ) - 1 ) +'.jpg' rutaYNomArchivo, 
	tv.rutaxml								+ 'cbb\' + RIGHT( tv.mensaje, CHARINDEX( '\', REVERSE( tv.mensaje ) + '\' ) - 1 ) +'.jpg' rutaYNomArchivoNet,
	'file://c:\getty' + substring(tv.rutaxml, charindex('\', tv.rutaxml, 3), 250) 
											+ 'cbb\' + RIGHT( tv.mensaje, CHARINDEX( '\', REVERSE( tv.mensaje ) + '\' ) - 1 ) +'.jpg' rutaFileDrive
from dbo.vwCfdTransaccionesDeVenta tv
left join dbo.cfdiCatalogo ca
	on ca.tipo = 'MTDPG'
	and ca.clave = tv.metodoDePago
where estado = 'emitido'
go
IF (@@Error = 0) PRINT 'Creaci�n exitosa de la vista: vwCfdDocumentosAImprimir  '
ELSE PRINT 'Error en la creaci�n de la vista: vwCfdDocumentosAImprimir '
GO
-----------------------------------------------------------------------------------------

-- FIN DE SCRIPT ***********************************************


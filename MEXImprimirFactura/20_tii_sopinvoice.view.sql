
IF (OBJECT_ID ('dbo.TII_SOPINVOICE', 'V') IS NULL)
   exec('create view dbo.TII_SOPINVOICE as SELECT 1 as t');
go

alter VIEW [dbo].[TII_SOPINVOICE] AS 
--Prop�sito. Representaci�n impresa de factura electr�nica M�xico. Habilitar codigoBarras si usa Crystal!
--...2011 I Garc�a Creaci�n.
--27/08/12 jcf Agrega unidad de medida No aplica para items tipo servicio
--09/11/12 jcf Agrega fCfdDatosAdicionales y comenta SOP10106
--21/12/12 jcf Corrige cantidad e importe para el caso de lotes o n�meros de serie
--29/08/13 jcf Comenta fCfdDatosAdicionales
--04/09/13 jcf Modifica condici�n de monto en letras
--14/09/15 JCF Ajusta monto en letras para MTP
--19/11/15 jcf Modifica usd por us$ (usado en MTP)
--17/10/16 jcf Agrega ORTDISAM, y CodigoBarras en caso de usar Crystal
--18/09/17 jcf Agrega isocurrc, addLeyenda. Comenta codigoBarras. Habilitar si usa Crystal
--20/09/17 jcf Agrega noExterior
--
SELECT 
		SOPHEADER.DOCSTATUS,
		SOPHEADER.SOPTYPE,
		SOPHEADER.SOPNUMBE,
		SOPHEADER.DOCDATE,
		SOPHEADER.GLPOSTDT,
		SOPHEADER.DUEDATE,
		SOPHEADER.PYMTRMID,
		SOPHEADER.LOCNCODE,
		SOPHEADER.CUSTNMBR,
		SOPHEADER.CUSTNAME,
		SOPHEADER.CSTPONBR,
		SOPHEADER.PRBTADCD,
		SOPHEADER.PRSTADCD,
		SOPHEADER.ShipToName,
		SOPHEADER.ADDRESS1,
		case when patindex('%#%', SOPHEADER.address1) = 0 then 
			'-'
		else right(rtrim(SOPHEADER.address1), len(SOPHEADER.address1)-patindex('%#%', SOPHEADER.address1)) 
		end noExterior,
		SOPHEADER.ADDRESS2,
		SOPHEADER.ADDRESS3,
		SOPHEADER.CITY,
		SOPHEADER.STATE,
		SOPHEADER.ZIPCODE,
		SOPHEADER.CCode,
		SOPHEADER.COUNTRY,
		SOPHEADER.PHNUMBR1,
		SOPHEADER.PHNUMBR2,
		SOPHEADER.PHONE3,
		SOPHEADER.FAXNUMBR,
		SOPHEADER.SHIPMTHD,
		SOPHEADER.SUBTOTAL,
		SOPHEADER.ORSUBTOT,
		SOPHEADER.OREMSUBT,
		SOPHEADER.ORTDISAM,
		SOPHEADER.FRTAMNT,
		SOPHEADER.ORFRTAMT,
		SOPHEADER.MISCAMNT,
		SOPHEADER.ORMISCAMT,
		SOPHEADER.TXRGNNUM,
		SOPHEADER.TAXAMNT,
		SOPHEADER.ORTAXAMT,
		SOPHEADER.DOCAMNT,
		CASE
			WHEN SOPHEADER.CURNCYID like '%MXN' THEN UPPER(DBO.TII_INVOICE_AMOUNT_LETTERS(SOPHEADER.ORDOCAMT, 'PESOS ')) + ' M.N.'
			WHEN SOPHEADER.CURNCYID like '%US$' THEN UPPER(DBO.TII_INVOICE_AMOUNT_LETTERS(SOPHEADER.ORDOCAMT, 'DOLARES AMERICANOS '))
		ELSE
			UPPER(DBO.TII_INVOICE_AMOUNT_LETTERS(SOPHEADER.ORDOCAMT, default)) 
		END  AS AMOUNT_LETTERS,
		SOPHEADER.ORDOCAMT,
		SOPHEADER.CURNCYID,
		SOPHEADER.RATETPID,
		SOPHEADER.EXGTBLID,
		SOPHEADER.XCHGRATE,
		SOPELECTINV.isocurrc,
		SOPELECTINV.USERDEF1,
		SOPELECTINV.NumCtaPago USERDEF2,
		SOPELECTINV.metodoDePago USRTAB01,
		rtrim(SOPELECTINV.metodoDePago) + ' ' + rtrim(SOPELECTINV.NumCtaPago) AS FORMADEPAGOCONCATENADO,
		RMCUSTOMER.TXRGNNUM AS TXRGNNUMCUST,
		SOPDETAIL.LNITMSEQ,
		SOPDETAIL.ORDEN,
		SOPDETAIL.CMPNTSEQ,
		SOPDETAIL.ITEMNMBR,
		SOPDETAIL.ITEMDESC,
		SOPDETAIL.UOFM,
		SOPDETAIL.LOCNCODE AS LOCNCODE_SOPDETAIL,
		SOPDETAIL.UNITPRCE,
		SOPDETAIL.ORUNTPRC,
		SOPDETAIL.XTNDPRCE,
		case when isnull(SOPDETAILSERIALLOT.SOPNUMBE, '_nulo')='_nulo' then 
			cast(SOPDETAIL.QUANTITY * SOPDETAIL.ORUNTPRC as numeric(19,6)) 
		else 
			cast(SOPDETAILSERIALLOT.SERLTQTY * SOPDETAIL.ORUNTPRC as numeric(19,6)) 
		end OXTNDPRC,
		SOPDETAIL.QUANTITY,
		SOPDETAILSERIALLOT.SERLTNUM,
		ISNULL(SOPDETAILSERIALLOT.SERLTQTY, SOPDETAIL.QUANTITY) SERLTQTY,
		SOPDETAILSERIALLOT.BIN,
		SOPDETAILSERIALLOT.LOTATRB1,
		SOPDETAILSERIALLOT.LOTATRB2,
		SOPDETAILSERIALLOT.LOTATRB3,
		SOPDETAILSERIALLOT.LOTATRB4,
		SOPDETAILSERIALLOT.LOTATRB5,
		RTRIM(SOPINVOICEINFO.ADRSCODE) AS ADRSCODE_INVOICE,
		RTRIM(SOPINVOICEINFO.SHIPMTHD) AS SHIPMTHD_INVOICE,
		RTRIM(SOPINVOICEINFO.CNTCPRSN) AS CNTCPRSN_INVOICE,
		RTRIM(SOPINVOICEINFO.ADDRESS1) AS ADDRESS1_INVOICE,
		RTRIM(SOPINVOICEINFO.ADDRESS2) AS ADDRESS2_INVOICE,
		RTRIM(SOPINVOICEINFO.ADDRESS3) AS ADDRESS3_INVOICE,
		RTRIM(SOPINVOICEINFO.CCode) AS CCode_INVOICE,
		RTRIM(SOPINVOICEINFO.COUNTRY) AS COUNTRY_INVOICE,
		RTRIM(SOPINVOICEINFO.CITY) AS CITY_INVOICE,
		RTRIM(SOPINVOICEINFO.STATE) AS STATE_INVOICE,
		RTRIM(SOPINVOICEINFO.ZIP) AS ZIP_INVOICE,
		RTRIM(SOPINVOICEINFO.PHONE1) AS PHONE1_INVOICE,
		RTRIM(SOPINVOICEINFO.PHONE2) AS PHONE2_INVOICE,
		RTRIM(SOPINVOICEINFO.PHONE3) AS PHONE3_INVOICE,
		RTRIM(SOPINVOICEINFO.FAX) AS FAX_INVOICE,
		RTRIM(SOPSHIPMENTINFO.ADRSCODE) AS ADRSCODE_SHIPMENT,
		RTRIM(SOPSHIPMENTINFO.SHIPMTHD) AS SHIPMTHD_SHIPMENT,
		RTRIM(SOPSHIPMENTINFO.CNTCPRSN) AS CNTCPRSN_SHIPMENT,
		RTRIM(SOPSHIPMENTINFO.ADDRESS1) AS ADDRESS1_SHIPMENT,
		RTRIM(SOPSHIPMENTINFO.ADDRESS2) AS ADDRESS2_SHIPMENT,
		RTRIM(SOPSHIPMENTINFO.ADDRESS3) AS ADDRESS3_SHIPMENT,
		RTRIM(SOPSHIPMENTINFO.CCode) AS CCode_SHIPMENT,
		RTRIM(SOPSHIPMENTINFO.COUNTRY) AS COUNTRY_SHIPMENT,
		RTRIM(SOPSHIPMENTINFO.CITY) AS CITY_SHIPMENT,
		RTRIM(SOPSHIPMENTINFO.STATE) AS STATE_SHIPMENT,
		RTRIM(SOPSHIPMENTINFO.ZIP) AS ZIP_SHIPMENT,
		RTRIM(SOPSHIPMENTINFO.PHONE1) AS PHONE1_SHIPMENT,
		RTRIM(SOPSHIPMENTINFO.PHONE2) AS PHONE2_SHIPMENT,
		RTRIM(SOPSHIPMENTINFO.PHONE3) AS PHONE3_SHIPMENT,
		RTRIM(SOPSHIPMENTINFO.FAX) AS FAX_SHIPMENT,
		SOPELECTINV.docid,
		RIGHT('0' + CAST(DAY(SOPELECTINV.fechaHoraEmision) AS VARCHAR(2)),2) + '/' + RIGHT('0' + CAST(MONTH(SOPELECTINV.fechaHoraEmision) AS VARCHAR(2)),2) + '/' + CAST(YEAR(SOPELECTINV.fechaHoraEmision) AS CHAR(4)) + ' ' + RIGHT('0' + CAST(DATEPART(HOUR,SOPELECTINV.fechaHoraEmision) AS VARCHAR(2)),2) + ':' + RIGHT('0' + CAST(DATEPART(MINUTE,SOPELECTINV.fechaHoraEmision) AS VARCHAR(2)),2) + ':' + RIGHT('0' + CAST(DATEPART(SECOND,SOPELECTINV.fechaHoraEmision) AS VARCHAR(2)),2) AS fechaHoraEmision,
		SOPELECTINV.regimenFiscal,
		SOPELECTINV.rfcReceptor,
		SOPELECTINV.nombreCliente,
		SOPELECTINV.total,
		RTRIM(SOPELECTINV.formaDePago) AS formaDePago,
		SOPELECTINV.folioFiscal,
		SOPELECTINV.noCertificadoCSD,
		SOPELECTINV.version,
		SOPELECTINV.selloCFD,
		SOPELECTINV.selloSAT,
		SOPELECTINV.cadenaOriginalSAT,
		SOPELECTINV.noCertificadoSAT,
		RIGHT('0' + CAST(DAY(SOPELECTINV.FechaTimbrado) AS VARCHAR(2)),2) + '/' + RIGHT('0' + CAST(MONTH(SOPELECTINV.FechaTimbrado) AS VARCHAR(2)),2) + '/' + CAST(YEAR(SOPELECTINV.FechaTimbrado) AS CHAR(4)) + ' ' + RIGHT('0' + CAST(DATEPART(HOUR,SOPELECTINV.FechaTimbrado) AS VARCHAR(2)),2) + ':' + RIGHT('0' + CAST(DATEPART(MINUTE,SOPELECTINV.FechaTimbrado) AS VARCHAR(2)),2) + ':' + RIGHT('0' + CAST(DATEPART(SECOND,SOPELECTINV.FechaTimbrado) AS VARCHAR(2)),2) AS FechaTimbrado,
		dbo.fCfdReemplazaSecuenciaDeEspacios(dbo.fCfdReemplazaCaracteresNI(RTRIM(substring(cm.cmmttext, 1, 350))), 10) addLeyenda,

		RTRIM(SOPELECTINV.rutaYNomArchivo) AS rutaYNomArchivo
		--dbo.fCfdObtieneImagenC(SOPELECTINV.rutaYNomArchivo) codigoBarras
FROM
(
		-- ENCABEZADO DE FACTURAS SOP EN LOTE
		SELECT
				'Sin Contabilizar' as DOCSTATUS,
				SOPTYPE,
				SOPNUMBE,
				DOCDATE,
				GLPOSTDT,
				DUEDATE,
				PYMTRMID,
				LOCNCODE,
				CUSTNMBR,
				CUSTNAME,
				CSTPONBR,
				PRBTADCD,
				PRSTADCD,
				ShipToName,
				ADDRESS1,
				ADDRESS2,
				ADDRESS3,
				CITY,
				STATE,
				ZIPCODE,
				CCode,
				COUNTRY,
				PHNUMBR1,
				PHNUMBR2,
				PHONE3,
				FAXNUMBR,
				SHIPMTHD,
				SUBTOTAL,
				ORSUBTOT,
				OREMSUBT,
				ORTDISAM,
				FRTAMNT,
				ORFRTAMT,
				MISCAMNT,
				ORMISCAMT,
				TXRGNNUM,
				TAXAMNT,
				ORTAXAMT,
				DOCAMNT,
				ORDOCAMT,
				CURNCYID,
				RATETPID,
				EXGTBLID,
				XCHGRATE		
		FROM 
				SOP10100 WITH (NOLOCK)
		WHERE 
				SOPTYPE IN (3,4) -- 3 FACTURA / 4 DEVOLUCION

		UNION ALL

		-- ENCABEZADO DE FACTURAS SOP CONTABILIZADAS
		SELECT 
				'Contabilizado' as DOCSTATUS,
				SOPTYPE,
				SOPNUMBE,
				DOCDATE,
				GLPOSTDT,
				DUEDATE,
				PYMTRMID,
				LOCNCODE,
				CUSTNMBR,
				CUSTNAME,
				CSTPONBR,
				PRBTADCD,
				PRSTADCD,
				ShipToName,
				ADDRESS1,
				ADDRESS2,
				ADDRESS3,
				CITY,
				STATE,
				ZIPCODE,
				CCode,
				COUNTRY,
				PHNUMBR1,
				PHNUMBR2,
				PHONE3,
				FAXNUMBR,
				SHIPMTHD,
				SUBTOTAL,
				ORSUBTOT,
				OREMSUBT,
				ORTDISAM,
				FRTAMNT,
				ORFRTAMT,
				MISCAMNT,
				ORMISCAMT,
				TXRGNNUM,
				TAXAMNT,
				ORTAXAMT,
				DOCAMNT,
				ORDOCAMT,
				CURNCYID,
				RATETPID,
				EXGTBLID,
				XCHGRATE
		FROM 
				SOP30200 WITH (NOLOCK)
		WHERE 
				SOPTYPE IN (3,4) -- 3 FACTURA / 4 DEVOLUCION
		
) SOPHEADER

LEFT OUTER JOIN

(

		-- LINEAS DE FACTURAS SOP EN LOTE
		SELECT 
				SOPTYPE,
				SOPNUMBE,
				LNITMSEQ,
				LNITMSEQ / 16384 AS ORDEN,
				CMPNTSEQ,
				ITEMNMBR,
				ITEMDESC,
				UOFM,
				LOCNCODE,
				UNITPRCE,
				ORUNTPRC,
				XTNDPRCE,
				OXTNDPRC,
				QUANTITY
		FROM 
				SOP10200 WITH (NOLOCK)
		WHERE 
				SOPTYPE IN (3,4) -- 3 FACTURA / 4 DEVOLUCION

		UNION ALL

		-- LINEAS DE FACTURAS SOP CONTABILIZADAS
		SELECT 
				SOPTYPE,
				SOPNUMBE,
				LNITMSEQ,
				LNITMSEQ / 16384 AS ORDEN,
				CMPNTSEQ,
				ITEMNMBR,
				ITEMDESC,
				UOFM,
				LOCNCODE,
				UNITPRCE,
				ORUNTPRC,
				XTNDPRCE,
				OXTNDPRC,
				QUANTITY
		FROM 
				SOP30300 WITH (NOLOCK)
		WHERE 
				SOPTYPE IN (3,4) -- 3 FACTURA / 4 DEVOLUCION
) SOPDETAIL

	ON SOPHEADER.SOPTYPE = SOPDETAIL.SOPTYPE AND SOPHEADER.SOPNUMBE = SOPDETAIL.SOPNUMBE

LEFT OUTER JOIN

(

-- DATOS DE LOTES/SERIES UTILIZADOS EN TRX DE VENTAS (TANTO EN LOTE COMO CONTABILIZADAS)
SELECT 
		A.SOPTYPE,
		A.SOPNUMBE,
		A.LNITMSEQ,
		CMPNTSEQ,
		A.SERLTNUM,
		A.SERLTQTY,
		A.ITEMNMBR,
		A.BIN,
		B.LOTATRB1,
		B.LOTATRB2,
		B.LOTATRB3,
		B.LOTATRB4,
		B.LOTATRB5
FROM 
		SOP10201 A WITH (NOLOCK) INNER JOIN
		IV00301 B WITH (NOLOCK) ON A.ITEMNMBR = B.ITEMNMBR AND A.SERLTNUM = B.LOTNUMBR
WHERE 
		A.SOPTYPE IN (3,4) -- 3 FACTURA / 4 DEVOLUCION
) SOPDETAILSERIALLOT

	ON SOPDETAIL.SOPTYPE = SOPDETAILSERIALLOT.SOPTYPE AND SOPDETAIL.SOPNUMBE = SOPDETAILSERIALLOT.SOPNUMBE AND SOPDETAIL.LNITMSEQ = SOPDETAILSERIALLOT.LNITMSEQ AND SOPDETAIL.CMPNTSEQ = SOPDETAILSERIALLOT.CMPNTSEQ
	
INNER JOIN RM00102 AS SOPINVOICEINFO WITH (NOLOCK)
	ON SOPHEADER.PRBTADCD = SOPINVOICEINFO.ADRSCODE AND SOPHEADER.CUSTNMBR = SOPINVOICEINFO.CUSTNMBR

INNER JOIN RM00102 as SOPSHIPMENTINFO WITH (NOLOCK)
	ON SOPHEADER.PRSTADCD = SOPSHIPMENTINFO.ADRSCODE AND SOPHEADER.CUSTNMBR = SOPSHIPMENTINFO.CUSTNMBR

LEFT OUTER JOIN vwCfdDocumentosAImprimir as SOPELECTINV WITH (NOLOCK)
	ON SOPHEADER.SOPTYPE = SOPELECTINV.soptype AND SOPHEADER.SOPNUMBE = SOPELECTINV.sopnumbe

INNER JOIN RM00101 as RMCUSTOMER WITH (NOLOCK)
	ON SOPHEADER.CUSTNMBR = RMCUSTOMER.CUSTNMBR

left join sop10106 cm
	on cm.sopnumbe = SOPHEADER.sopnumbe
	and cm.soptype = SOPHEADER.soptype
	and cm.comment_1 != ''

GO




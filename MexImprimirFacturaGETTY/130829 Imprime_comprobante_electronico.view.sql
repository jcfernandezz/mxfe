
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[IMPRIME_COMPROBANTE_ELECTRONICO]
AS
--18/01/11 jcf Reemplaza montos funcionales por montos originales
--04/07/12 jcf Agrega campo NumCtaPago
--10/07/12 jcf Agrega campos: metodoDePago, bankname
--14/08/12 jcf Agrega campos: uofm
--29/08/13 jcf Cambios varios para cfdi
--10/09/13 jcf Agrega county. Convierte fechaTimbrado a datetime. Agrega imagen de c�digo de barras
--
SELECT A.SOPTYPE, A.SOPNUMBE, 1 LINEA, C.LNITMSEQ, A.DOCDATE, A.PYMTRCVD, A.DOCID, 
	A.CURNCYID, A.XCHGRATE, A.ORTDISAM TRDISAMT, A.ORSUBTOT SUBTOTAL, A.ORTAXAMT TAXAMNT, A.ORDOCAMT DOCAMNT, A.ORACTAMT ACCTAMNT, 
	DYNAMICS.dbo.fncNUMLET(A.CURNCYID, A.ORDOCAMT) CURTEXT, 
	
	A.CUSTNMBR, DUEDATE, 
	CASE WHEN I.DUEDTDS = 0 THEN 'Contado' ELSE CONVERT(VARCHAR,I.DUEDTDS) + ' d�as' END PYMTRMID, 
	CONVERT(INT, A.CUSTNMBR) user_id, A.CUSTNAME, 
	B.ADDRESS1, B.ADDRESS2, B.ADDRESS3, B.CITY, B.STATE, B.COUNTRY, B.ZIP, B.PHONE1, B.PHONE2, B.FAX, SUBSTRING(B.TXRGNNUM, 1, 25) tax_number, B.BANKNAME,
	ISNULL(LTRIM(RTRIM((CONVERT(CHAR(400), F.TXTFIELD)))) + ' -  ' + ISNULL(H.description, ''), '')  address, 
	CO.CCode address_country_code, 
	ISNULL(RTRIM(CONVERT(CHAR(400),D.CMMTTEXT)), '') shipping_address, 
	'' shipping_address_country_code, '' license_address, '' license_address_country_code,
	CONVERT(int, C.INTEGRATIONID) article_id, C.ITEMNMBR, C.ITEMDESC ITEMDESC, 
	
	C.ORUNTPRC UNITPRCE, C.OXTNDPRC XTNDPRCE, C.QUANTITY, 
	case when rtrim(B.COMMENT2) = '' then 'No Aplica' else rtrim(B.COMMENT2) end UOFM,
	
	ISNULL(E.CMMTTEXT, '') info, C.ShipToName img_url, 
	ISNULL(D.USERDEF1, '') ORDENVTA,
	ISNULL(D.USRDAT01, 0) FECHAORDVTA, B.USERDEF1, ISNULL(G.LOCATNNM, '') TRANSFA, ISNULL(G.ADRCNTCT, '') BANCO, 
	ISNULL(G.ADDRESS1, '') CUENTA, ISNULL(G.ADDRESS2, '') CBU, ISNULL(G.ADDRESS3, '') TRANSFTIT, CO.ADRCNTCT CMPNYNAM, CO.ADDRESS1 ADDRESS1CO,
	CO.COUNTY COUNTYCO, CO.ZIPCODE ZIPCODECO, CO.CITY CITYCO, CO.ADDRESS2 TELCO, CO.STATE MAIL1CO, CO.ADDRESS3 MAIL2CO, CO.CMPNYNAM EMPRESA, CO.TAXREGTN,
	ISNULL((SELECT TXTFIELD FROM SY03900 A1, SY00600 B1 WHERE A1.NOTEINDX = B1.NOTEINDX AND B1.LOCATNID = 'VENTAS'), '') DIRVTAS,
	ISNULL((SELECT TXTFIELD FROM SY03900 A1, SY00600 B1 WHERE A1.NOTEINDX = B1.NOTEINDX AND B1.LOCATNID = 'DIRECCION'), '') DIRDIRE,
	ISNULL((SELECT TXTFIELD FROM SY03900 A1, SY00600 B1 WHERE A1.NOTEINDX = B1.NOTEINDX AND B1.LOCATNID = 'BANCO'), '') DIRBCO,
	A.CSTPONBR ORDCPRA,
	ISNULL(D.USERDEF2, '') TIPOTRABAJO,
	ISNULL(D.USRDEF03, '') PEDIDOPOR,
	ISNULL(D.USRDEF04, '') CLIENTE,
	ISNULL(D.USRDEF05, '') PROMOCION,
	ISNULL(HD.memo, '') memo,
	'SOP10100' sTabla,
	ISNULL((select TOP 1 CHEKBKID from SOP10103 WHERE SOPTYPE = A.SOPTYPE AND SOPNUMBE = A.SOPNUMBE), '') CHEKBKID,
	ISNULL((select TOP 1 CHEKNMBR from SOP10103 WHERE SOPTYPE = A.SOPTYPE AND SOPNUMBE = A.SOPNUMBE), '') CHEKNMBR,
	--ISNULL(HD.FECHAHORA, 0) FECHAHORAGP,
	FE.fechaHoraEmision,
	FE.regimenFiscal,
	FE.rfcReceptor,
	FE.nombreCliente,
	FE.total,
	RTRIM(FE.formaDePago) AS formaDePago,
	FE.folioFiscal,
	FE.noCertificadoCSD,
	FE.[version],
	FE.selloCFD,
	FE.selloSAT,
	FE.cadenaOriginalSAT,
	FE.noCertificadoSAT,
	cast (FE.FechaTimbrado as datetime) FechaTimbrado,
	RTRIM(FE.rutaYNomArchivoNet) AS rutaYNomArchivoNet,
	FE.metodoDePago, FE.NumCtaPago, FE.USERDEF1 salesOrder, 
	RTRIM(FE.metodoDePago)  + ' ' + FE.NumCtaPago FORMADEPAGOCONCATENADO,
	null imagenbinaria,
	null codigoBarras
FROM SOP10100 A 
	INNER JOIN RM00101 B ON A.CUSTNMBR = B.CUSTNMBR
	INNER JOIN SOP10200 C ON A.SOPTYPE = C.SOPTYPE AND A.SOPNUMBE = C.SOPNUMBE
	LEFT OUTER JOIN vwCfdDocumentosAImprimir FE ON A.SOPTYPE = FE.soptype AND A.SOPNUMBE = FE.SOPNUMBE
	LEFT OUTER JOIN INT_SOPHDR HD ON A.SOPTYPE = HD.SOPTYPE AND A.SOPNUMBE = HD.SOPNUMBE
	LEFT OUTER JOIN DYNAMICS..SY01500 CO ON CO.INTERID = DB_NAME()
	LEFT OUTER JOIN SOP10106 D ON A.SOPTYPE = D.SOPTYPE AND A.SOPNUMBE = D.SOPNUMBE 
	LEFT OUTER JOIN SOP10202 E ON E.SOPTYPE = A.SOPTYPE AND E.SOPNUMBE = A.SOPNUMBE AND E.LNITMSEQ = C.LNITMSEQ
	LEFT OUTER JOIN SY03900 F ON A.NOTEINDX = F.NOTEINDX
	LEFT OUTER JOIN SY00600 G ON G.LOCATNID = 'BANCO'
	LEFT OUTER JOIN INTDB2..ERP_Country_Description H ON B.COUNTRY = H.country_code AND language_code = 'es'
	LEFT OUTER JOIN SY03300 I ON A.PYMTRMID = I.PYMTRMID
--WHERE A.DOCDATE >= DATEADD(m, -2, CONVERT(CHAR(8), GETDATE(), 112))

UNION ALL

SELECT A.SOPTYPE, A.SOPNUMBE, 1 LINEA, C.LNITMSEQ, A.DOCDATE, A.PYMTRCVD, A.DOCID,
	
	A.CURNCYID, A.XCHGRATE, A.ORTDISAM TRDISAMT, A.ORSUBTOT SUBTOTAL, A.ORTAXAMT TAXAMNT, A.ORDOCAMT DOCAMNT, A.ORACTAMT ACCTAMNT,
	DYNAMICS.dbo.fncNUMLET(A.CURNCYID, A.ORDOCAMT) CURTEXT, 
	
	A.CUSTNMBR, DUEDATE, 
	CASE WHEN I.DUEDTDS = 0 THEN 'Contado' ELSE CONVERT(VARCHAR,I.DUEDTDS) + ' d�as' END PYMTRMID, 
	CONVERT(INT, A.CUSTNMBR) user_id, A.CUSTNAME, 
	B.ADDRESS1, B.ADDRESS2, B.ADDRESS3, B.CITY, B.STATE, B.COUNTRY, B.ZIP, B.PHONE1, B.PHONE2, B.FAX, SUBSTRING(B.TXRGNNUM, 1, 25) tax_number,  B.BANKNAME,
	ISNULL(LTRIM(RTRIM((CONVERT(CHAR(400), F.TXTFIELD)))) + ' -  ' + ISNULL(H.description, ''), '')  address, 
	CO.CCode address_country_code, 
	ISNULL(RTRIM(CONVERT(CHAR(400),D.CMMTTEXT)), '') shipping_address, 
	'' shipping_address_country_code, '' license_address, '' license_address_country_code,
	CONVERT(int, HD.INTEGRATIONID) article_id, C.ITEMNMBR, C.ITEMDESC ITEMDESC, 

	C.ORUNTPRC UNITPRCE, C.OXTNDPRC XTNDPRCE, C.QUANTITY, 
	case when rtrim(B.COMMENT2) = '' then 'No Aplica' else rtrim(B.COMMENT2) end UOFM,
	
	ISNULL(E.CMMTTEXT, '') info, C.ShipToName img_url, 
	ISNULL(D.USERDEF1, '') ORDENVTA,
	ISNULL(D.USRDAT01, 0) FECHAORDVTA, B.USERDEF1, ISNULL(G.LOCATNNM, '') TRANSFA, ISNULL(G.ADRCNTCT, '') BANCO, 
	ISNULL(G.ADDRESS1, '') CUENTA, ISNULL(G.ADDRESS2, '') CBU, ISNULL(G.ADDRESS3, '') TRANSFTIT, CO.ADRCNTCT CMPNYNAM, CO.ADDRESS1 ADDRESS1CO,
	CO.COUNTY COUNTYCO, CO.ZIPCODE ZIPCODECO, CO.CITY CITYCO, CO.ADDRESS2 TELCO, CO.STATE MAIL1CO, CO.ADDRESS3 MAIL2CO, CO.CMPNYNAM EMPRESA, CO.TAXREGTN,
	ISNULL((SELECT TXTFIELD FROM SY03900 A1, SY00600 B1 WHERE A1.NOTEINDX = B1.NOTEINDX AND B1.LOCATNID = 'VENTAS'), '') DIRVTAS,
	ISNULL((SELECT TXTFIELD FROM SY03900 A1, SY00600 B1 WHERE A1.NOTEINDX = B1.NOTEINDX AND B1.LOCATNID = 'DIRECCION'), '') DIRDIRE,
	ISNULL((SELECT TXTFIELD FROM SY03900 A1, SY00600 B1 WHERE A1.NOTEINDX = B1.NOTEINDX AND B1.LOCATNID = 'BANCO'), '') DIRBCO,
	A.CSTPONBR ORDCPRA,
	ISNULL(D.USERDEF2, '') TIPOTRABAJO,
	ISNULL(D.USRDEF03, '') PEDIDOPOR,
	ISNULL(D.USRDEF04, '') CLIENTE,
	ISNULL(D.USRDEF05, '') PROMOCION,
	ISNULL(HD.memo, '') memo,
	'SOP30200' sTabla,
	ISNULL((select TOP 1 CHEKBKID from SOP10103 WHERE SOPTYPE = A.SOPTYPE AND SOPNUMBE = A.SOPNUMBE), '') CHEKBKID,
	ISNULL((select TOP 1 CHEKNMBR from SOP10103 WHERE SOPTYPE = A.SOPTYPE AND SOPNUMBE = A.SOPNUMBE), '') CHEKNMBR,
	--ISNULL(HD.FECHAHORA, 0) FECHAHORAGP,
	FE.fechaHoraEmision,
	FE.regimenFiscal,
	FE.rfcReceptor,
	FE.nombreCliente,
	FE.total,
	RTRIM(FE.formaDePago) AS formaDePago,
	FE.folioFiscal,
	FE.noCertificadoCSD,
	FE.[version],
	FE.selloCFD,
	FE.selloSAT,
	FE.cadenaOriginalSAT,
	FE.noCertificadoSAT,
	cast (FE.FechaTimbrado as datetime) FechaTimbrado,
	RTRIM(FE.rutaYNomArchivoNet) AS rutaYNomArchivoNet,
	FE.metodoDePago, FE.NumCtaPago, FE.USERDEF1 salesOrder, 
	RTRIM(FE.metodoDePago)  + ' ' + FE.NumCtaPago FORMADEPAGOCONCATENADO,
	dbo.fCfdObtieneImagenC(C.ShipToName) imagenBinaria,
	dbo.fCfdObtieneImagenC('file://C:\GETTY' + Stuff(rutaYNomArchivoNet, 1, 14, '')) codigoBarras
FROM SOP30200 A 
	INNER JOIN SOP30300 C ON A.SOPTYPE = C.SOPTYPE AND A.SOPNUMBE = C.SOPNUMBE
	INNER JOIN RM00101 B ON A.CUSTNMBR = B.CUSTNMBR
	LEFT OUTER  JOIN vwCfdDocumentosAImprimir FE ON A.SOPTYPE = FE.soptype AND A.SOPNUMBE = FE.SOPNUMBE
	LEFT OUTER JOIN INT_SOPHDR HD ON A.SOPTYPE = HD.SOPTYPE AND A.SOPNUMBE = HD.SOPNUMBE
	LEFT OUTER JOIN DYNAMICS..SY01500 CO ON CO.INTERID = DB_NAME()
	LEFT OUTER JOIN SOP10106 D ON A.SOPTYPE = D.SOPTYPE AND A.SOPNUMBE = D.SOPNUMBE 
	LEFT OUTER JOIN SOP10202 E ON E.SOPTYPE = A.SOPTYPE AND E.SOPNUMBE = A.SOPNUMBE AND E.LNITMSEQ = C.LNITMSEQ
	LEFT OUTER JOIN SY03900 F ON A.NOTEINDX = F.NOTEINDX
	LEFT OUTER JOIN SY00600 G ON G.LOCATNID = 'BANCO'
	LEFT OUTER JOIN INTDB2..ERP_Country_Description H ON B.COUNTRY = H.country_code AND language_code = 'es'
	LEFT OUTER JOIN SY03300 I ON A.PYMTRMID = I.PYMTRMID
	--WHERE A.DOCDATE >= DATEADD(m, -2, CONVERT(CHAR(8), GETDATE(), 112))
GO
--sp_columns [IMPRIME_COMPROBANTE_ELECTRONICO]



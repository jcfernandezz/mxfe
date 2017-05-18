--GETTY
--Pruebas de Factura electrónica México
--
--1. Probar en bd que no tenga los objetos sql instalados
-- 	* Aviso de que tu Certificado Digital está por vencer
use gmope;

select * from dbo.fCfdEmisor()
select * from vwSopLineasTrxVentas
select dbo.fCfdParteXML(3, 'FV A0001-00000002')
select dbo.fCfdInfoAduaneraXML(3, 'FV A0001-00000003', 'K0002', '31')
select dbo.fCfdParteXML(3, 'FV A0001-00000006')
select dbo.fCfdConceptosXML(3, 'FV A0001-00000001')
select dbo.fCfdGeneraDocumentoDeVentaXML (3, '0015885')

select rfc, IdImpuestoCliente, total, uuid, mensaje, *
from vwCfdTransaccionesDeVenta
where sopnumbe like '%15885'


select soptype, docid, sopnumbe, fechaHoraEmision, regimenFiscal, rfcReceptor, nombreCliente, total, formaDePago, folioFiscal,
	noCertificadoCSD, [version], selloCFD, selloSAT, cadenaOriginalSAT, noCertificadoSAT, FechaTimbrado, rutaYNomArchivo
from vwCfdDocumentosAImprimir

sp_columns vwCfdDocumentosAImprimir

--update sop30200 set DOCNCORR = '09:50:17:220'
where SOPNUMBE = 'FV A0001-00000016'

select docncorr, * from sop30200
where soptype = 3
and datediff(month,4, docdate ) >= 0

--update cfd_cer00100 set ruta_certificado = 'C:\GPUsuario\GPExpressCfdi\fePRUEBA\aaa010101aaa_csd_01.cer', 
--					ruta_clave = 'C:\GPUsuario\GPExpressCfdi\fePRUEBA\aaa010101aaa_csd_01.key', 
--					contrasenia_clave = 'a0123456789'

select *
  from [cfd_CER00100]
--where itemnmbr = '42000 RR181 HT434969' -- '408742-0008' -- '441194-0001' -- '465823-9001S' -- 'ABBR181-97000' 
order by 1

select * from iv00301 --iv_lot_attributes [ITEMNMBR LOTNUMBR]
sp_statistics pop30330
sp_columns pop


------------------------------------------------------------------------------------------------------
--Tabla LOG XML
--
select * 
from cfdlogfacturaxml 
where sopnumbe in ( 'FV A0001-00000008', '0000011', '0000012')
order by soptype, sopnumbe

select month(sp.docdate), sp.soptype, count(sp.sopnumbe)
, sum(case when isnull(lxm.estado, '') = 'enviado' then 1 else 0 end) enviado
from sop30200 sp
left join 
	(select * from cfdlogfacturaxml 
	where estado = 'enviado') lxm
	on sp.sopnumbe = lxm.sopnumbe
	and sp.soptype = lxm.soptype
where datediff(DAY, '5/1/11', sp.DOCDATE) >= 0
--sp.sopnumbe in ('0000435')
group by month(sp.docdate), sp.soptype

--update cfdlogfacturaxml set estadoActual = '000101', mensajeEA = 'Xml emitido. Pdf impreso. E-mail no enviado. '
--where estado = 'emitido'
--and soptype = 3
--and sopnumbe in ( '0000003', '0000004')

--
--update cfdlogfacturaxml set estadoActual = '010101',
--							mensajeea = rtrim(mensajeEA) + ' E-mail enviado manualmente.'

select *
from [ACA_IETU00400]
------------------------------------------------------------------------------------------------------------------
select  ma.custnmbr, ma.custname, ad.userdef2	--, ad.userdef1, ad.*
from rm00102 ad
inner join rm00101 ma
on ma.custnmbr = ad.custnmbr
where ad.userdef2 != ''

select userdef2, 
--update ad set userdef2 =
case when ad.userdef2 = 'Cheque' then '02'
	when ad.userdef2 = 'Efectivo' then '01'
	when ad.userdef2 = 'No identificado      ' then ''
	when ad.userdef2 = 'Tarjeta              ' then '04'
	when ad.userdef2 in ( 'Transfer / Cheque    ', 'Transferencia        ', 'Transferencia electr ', 'Transferencia/Cheque ', 'Trasnferencia        ') then '03'
end
,*
from rm00102 ad
where ad.userdef2 in ('01', '02', '03', '04')
and custnmbr = '000013480'
and adrscode = 'MAIN'

select top 100 *, 'file://C:\GETTY' + Stuff(rutaYNomArchivoNet, 1, 14, ''), 
	dbo.fCfdObtieneImagenC('file://C:\GETTY' + Stuff(rutaYNomArchivoNet, 1, 14, '')) codigoBarras
from dbo.vwCfdDocumentosAImprimir
where sopnumbe = '0001814              '


select top 100 *
from [TII_SOPINVOICE]
where sopnumbe = '0013113'

--Obtiene el número de recepción donde ingresó un artículo - serie
select top 100  *
from sop30200
where year(docdate) = 2016
and soptype = 4



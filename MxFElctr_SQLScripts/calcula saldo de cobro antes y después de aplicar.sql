--select custnmbr, *
--from sop10100
--order by 1 
--select curtrxam, *
--from _tmpDespues
--where custnmbr = '000021767      '


select ororgtrx, *
from vwRmTransaccionesTodas
where --orctrxam <> 0
DOCNUMBR in ( '5114', '0013945              ')

mc020102

--calcular saldos antes y después de aplicar cobro
select 
	oraptoam,	--monto que se descuenta a la factura en la moneda original de la factura
	apptoamt,		--Monto que se descuenta a la factura en moneda funcional
	ORAPTOAM / APPTOAMT,	--Unidades de moneda de factura / unidad de la moneda de pago Ej. USD / MXN 
	glpostdt,		--fecha de aplicación
	aptoexrate,
	rlganlos,
	*
from vwRmTrxAplicadas
where custnmbr = '000021767      '
and APTODCNM = '0013945              '
order by 3

                      
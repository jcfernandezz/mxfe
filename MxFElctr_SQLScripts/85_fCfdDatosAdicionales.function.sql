--------------------------------------------------------------------------------------------------------

IF OBJECT_ID ('dbo.fCfdDatosAdicionales') IS NOT NULL
   DROP FUNCTION dbo.fCfdDatosAdicionales
GO

create function dbo.fCfdDatosAdicionales(@orpmtrvd numeric(21,5), @soptype smallint, @sopnumbe varchar(21), @custnmbr varchar(15), @prbtadcd varchar(15))
returns table
as
--Prop�sito. Devuelve datos adicionales de la factura
--Requisitos. Los impuestos est�n configurados en el campo texto de la compa��a. 
--			Debe indicar el par�metros IMPUESTOS=[idImpuesto1],[idImpuesto2],etc.
--			Debe indicar el par�metros OTROS=[01] � [02]
--			[01] El m�todo de pago est� en el campo 2 def por el usuario de la direcci�n de facturaci�n del cliente.
--				El n�mero de cuenta bancaria viene del campo 1 def por el usuario de la direcci�n de facturaci�n del cliente
--			[02] El m�todo de pago viene del campo 1 tipo lista def por el usuario de la factura
--				El n�mero de cuenta bancaria viene del campo 2 tipo texto def por el usuario de la factura
--02/07/12 jcf Creaci�n cfdi
--10/07/12 jcf Modifica campo metodoDePago
--
return
( 
	select  case when len(rtrim(isnull(mad.USERDEF1, ''))) < 4 then 'no identificado' else rtrim(mad.USERDEF1) end NumCtaPago,
			case when len(rtrim(isnull(mad.USERDEF2, ''))) < 1 then 'no identificado' else rtrim(mad.USERDEF2) end metodoDePago,
			ctrl.USERDEF1 nroOrden, '' referencia
	from rm00102 mad					--rm_customer_mstr_addr [CUSTNMBR ADRSCODE]
	cross apply dbo.fCfdEmisor() emi	--configuraci�n
    left outer join SOP10106 ctrl			--campos def. por el usuario.
       on ctrl.SOPTYPE = @soptype
      and ctrl.SOPNUMBE = @sopnumbe
	where emi.otrosDatos = '01'
	and mad.custnmbr = @custnmbr
	and mad.adrscode = @prbtadcd

	union all

	select case when len(rtrim(isnull(ctrl.USERDEF2, ''))) < 4 then 'no identificado' else rtrim(ctrl.USERDEF2) end NumCtaPago,
		case when LEN(rtrim(isnull(ctrl.usrtab01, ''))) < 1 then 'No identificado' else rtrim(ctrl.usrtab01) end metodoDePago,
		'' nroOrden, ctrl.USERDEF1
	from SOP10106 ctrl					--campos def. por el usuario.
	cross apply dbo.fCfdEmisor() emi	--configuraci�n
	where emi.otrosDatos = '02'
	and ctrl.soptype = @soptype
	and ctrl.sopnumbe = @sopnumbe
)
go

IF (@@Error = 0) PRINT 'Creaci�n exitosa de la funci�n: fCfdDatosAdicionales()'
ELSE PRINT 'Error en la creaci�n de la funci�n: fCfdDatosAdicionales()'
GO
--------------------------------------------------------------------------------------------------------

IF OBJECT_ID ('dbo.fCfdUofMSAT') IS NOT NULL
   DROP FUNCTION dbo.fCfdUofMSAT
GO

create function dbo.fCfdUofMSAT(@UOMSCHDL varchar(11), @UOFM varchar(9))
returns table
as
--Prop�sito. Obtiene la descripci�n larga de la unidad de medida 
--Requisitos. 
--02/08/12 jcf Creaci�n 
--
return
( 
	select UOFMLONGDESC
	from iv40202	--unidades de medida [UOMSCHDL SEQNUMBR]
	WHERE UOMSCHDL = @UOMSCHDL
	and UOFM = @UOFM 
)
go

IF (@@Error = 0) PRINT 'Creaci�n exitosa de la funci�n: fCfdUofMSAT()'
ELSE PRINT 'Error en la creaci�n de la funci�n: fCfdUofMSAT()'
GO

------------------------------------------------------------------------------------------
--select *
--from dbo.fCfdDatosAdicionales(0, 3, 'FV A0001-00000016', 'C0004', 'PRINCIPAL')


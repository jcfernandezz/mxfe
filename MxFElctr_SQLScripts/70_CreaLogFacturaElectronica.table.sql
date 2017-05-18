--GETTY - Factura Electrónica México CFDI
--Propósito. Tablas y funciones para monitorear la creación de facturas en formato xml
--
---------------------------------------------------------------------------------------
--Propósito. Log de facturas emitidas en formato xml. Sólo debe haber un estado emitido para cada factura.
--23/4/12 jcf Creación cfdi
--
IF not EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[cfdLogFacturaXML]') AND OBJECTPROPERTY(id,N'IsTable') = 1)
begin
	CREATE TABLE dbo.cfdLogFacturaXML (
	  soptype SMALLINT  NOT NULL DEFAULT 0 ,
	  sopnumbe VARCHAR(21)  NOT NULL DEFAULT '' ,
	  secuencia INTEGER  NOT NULL IDENTITY ,
	  estado VARCHAR(20)  NOT NULL DEFAULT 'anulado' , 
	  mensaje VARCHAR(255)  NOT NULL DEFAULT 'xml no emitido' ,
	  estadoActual varchar(20) default '000000', 
	  mensajeEA varchar(255) default '',
	  noAprobacion varchar(21) not null default '',
	  fechaEmision datetime not null default getdate(), 
	  idUsuario varchar(10) not null default '',
	  fechaAnulacion datetime not null default 0,
	  idUsuarioAnulacion varchar(10) not null default '',
	  archivoXML xml default ''
	PRIMARY KEY(soptype, sopnumbe, secuencia));

	alter table dbo.cfdLogFacturaXML add constraint chk_estado check(estado in ('emitido', 'anulado', 'impreso', 'enviado'));
	create index idx1_cfdLogFacturaXML on dbo.cfdLogFacturaXML(soptype, sopnumbe, estado) include (estadoActual, archivoXML);
end;
go

---------------------------------------------------------------------------------------------------------------------------
--Para actualizar Getty:
--drop index idx1_cfdLogFacturaXML on dbo.cfdLogFacturaXML;
--	create index idx1_cfdLogFacturaXML on dbo.cfdLogFacturaXML(soptype, sopnumbe, estado) include (estadoActual, archivoXML);


IF OBJECT_ID ('dbo.fCfdDatosXmlParaImpresion') IS NOT NULL
   drop function dbo.fCfdDatosXmlParaImpresion
go

create function dbo.fCfdDatosXmlParaImpresion(@archivoXml xml)
--Propósito. Obtiene los datos de la factura electrónica
--Usado por. vwCfdTransaccionesDeVenta
--Requisitos. CFDI
--05/10/10 jcf Creación
--10/07/12 jcf Agrega metodoDePago, NumCtaPago
--
returns table
return(
	WITH XMLNAMESPACES('http://www.sat.gob.mx/TimbreFiscalDigital' as "tfd")
	select 
	@archivoXml.value('(//tfd:TimbreFiscalDigital/@selloCFD)[1]', 'varchar(8000)') selloCFD,
	@archivoXml.value('(//tfd:TimbreFiscalDigital/@FechaTimbrado)[1]', 'varchar(20)') FechaTimbrado,
	@archivoXml.value('(//tfd:TimbreFiscalDigital/@UUID)[1]', 'varchar(50)') UUID,
	@archivoXml.value('(//tfd:TimbreFiscalDigital/@noCertificadoSAT)[1]', 'varchar(20)') noCertificadoSAT,
	@archivoXml.value('(//tfd:TimbreFiscalDigital/@version)[1]', 'varchar(5)') [version],
	@archivoXml.value('(//tfd:TimbreFiscalDigital/@selloSAT)[1]', 'varchar(8000)') selloSAT,
	@archivoXml.value('(//@sello)[1]', 'varchar(8000)') sello,
	@archivoXml.value('(//@noCertificado)[1]', 'varchar(20)') noCertificado,
	@archivoXml.value('(//@noAprobacion)[1]', 'integer') noAprobacion,
	@archivoXml.value('(//@anoAprobacion)[1]', 'integer') anoAprobacion,
	@archivoXml.value('(//@formaDePago)[1]', 'varchar(50)') formaDePago,
	@archivoXml.value('(//@metodoDePago)[1]', 'varchar(21)') metodoDePago,
	@archivoXml.value('(//@NumCtaPago)[1]', 'varchar(21)') NumCtaPago
	)
	go
--------------------------------------------------------------------------------------
--PRUEBAS--
--select * from cfdLogFacturaXML

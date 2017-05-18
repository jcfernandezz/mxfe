--Getty 
--Factura Electr�nica
--Prop�sito. Rol que da accesos a objetos de reporte de factura electr�nica
--Requisitos. Ejecutar antes los permisos para factura electr�nica (110)
--
--01/11/10 JCF Creaci�n
--15/12/10 JCF Agrega grant vwCfdCompannias a bd Dynamics
--22/12/10 jcf Agrega grants varios para impresi�n de factura
--07/01/11 jcf Agrega grants varios para impresi�n de factura en Esp, Usa, Per� y Colombia
--
-----------------------------------------------------------------------------------
--use [bd compa��a]

--Vistas que usa la impresi�n de factura
grant select on dbo.IMPRIME_COMPROBANTE_ELECTRONICO to rol_cfdigital, dyngrp;
grant select on dbo.IMPRIME_COMPROBANTE_POSTED to rol_cfdigital, dyngrp;
grant select on dbo.IMPRIME_COMPROBANTE to rol_cfdigital, dyngrp;
grant select on dbo.INT_SOPLINE_DATA to rol_cfdigital, dyngrp;
grant select on dbo.INT_SOPLINE_DATA_VIEW to rol_cfdigital, dyngrp;
grant select on dbo.INT_COUNTRY_DESCIPTION to rol_cfdigital, dyngrp;
grant select on dbo.IV00101 to rol_cfdigital, dyngrp;

--grant select on dbo.IMPRIME_COMPROBANTE_UNICO to rol_cfdigital, dyngrp;		--espa�a


------------------------------------------------------------------------------------------
use dynamics;

--Objetos que usa la impresi�n de factura
grant execute on dbo.fncNUMLET to rol_cfdigital, dyngrp;
grant execute on dbo.fncNUMLET_ENG to rol_cfdigital, dyngrp;
grant select on dbo.mc40200 to rol_cfdigital;

-------------------------------------------------------------------------------------------
use intdb2

IF DATABASE_PRINCIPAL_ID('rol_cfdigital') IS NULL
	create role rol_cfdigital;

--Objetos que usa la impresi�n de factura
grant select on dbo.ERP_Country_Description  to rol_cfdigital;
grant select on dbo.ERP_Invoice  to rol_cfdigital;




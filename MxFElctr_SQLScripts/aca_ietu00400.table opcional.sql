
/****** Object:  Table [dbo].[ACA_IETU00400]    Script Date: 08/26/2015 16:19:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ACA_IETU00400](
	[MexFolioFiscal] [char](41) NOT NULL,
	[DOCTYPE] [smallint] NOT NULL,
	[VCHRNMBR] [char](21) NOT NULL,
	[ACA_Gasto] [tinyint] NOT NULL,
	[ACA_IVA] [tinyint] NOT NULL,
	[DEX_ROW_ID] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PKACA_IETU00400] PRIMARY KEY NONCLUSTERED 
(
	[DOCTYPE] ASC,
	[VCHRNMBR] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


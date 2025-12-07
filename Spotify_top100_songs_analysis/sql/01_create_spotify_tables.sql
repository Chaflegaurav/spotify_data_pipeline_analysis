USE [SpotifyDB]
GO

/****** Object:  Table [dbo].[top_100_songs]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[top_100_songs](
	[name] [varchar](max) NULL,
	[id] [varchar](max) NULL,
	[duration] [float] NULL,
	[album_type] [varchar](max) NULL,
	[popularity] [bigint] NULL,
	[artists_name] [varchar](max) NULL,
	[duration_minutes] [float] NULL,
	[popularity_category] [varchar](max) NULL,
	[duration_category] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO



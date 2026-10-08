USE [Knjiznica]
GO
/****** Object:  Table [dbo].[status]    Script Date: 08.10.2026 12:07:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[status](
	[id] [tinyint] IDENTITY(1,1) NOT NULL,
	[naziv] [nvarchar](50) NOT NULL,
	[za_izposojo] [bit] NULL,
	[za_vracilo] [bit] NULL,
 CONSTRAINT [PK_status_knjige] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[zanr]    Script Date: 08.10.2026 12:07:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[zanr](
	[id] [tinyint] IDENTITY(1,1) NOT NULL,
	[naziv] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_zanr_knjige] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[clan]    Script Date: 08.10.2026 12:07:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[clan](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[ime] [varchar](50) NOT NULL,
	[priimek] [varchar](50) NOT NULL,
	[naslov] [nvarchar](max) NULL,
	[telefon] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[knjige]    Script Date: 08.10.2026 12:07:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[knjige](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[isbn] [nvarchar](13) NOT NULL,
	[avtor] [nvarchar](max) NOT NULL,
	[naslov] [nvarchar](max) NOT NULL,
	[zanr_id] [tinyint] NULL,
	[status_knjige] [tinyint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[izposoja]    Script Date: 08.10.2026 12:07:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[izposoja](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[knjiga_id] [bigint] NOT NULL,
	[clan_id] [bigint] NOT NULL,
	[datum_izposoje] [date] NOT NULL,
	[datum_vracila] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[pregled]    Script Date: 08.10.2026 12:07:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE   VIEW [dbo].[pregled]
AS
SELECT       k.id, 
             k.isbn, 
             k.avtor, 
             k.naslov, 
             ISNULL(z.naziv, ' ') AS zanr, 
             s.naziv AS status_knjige,
             ISNULL(CONVERT(VARCHAR(10), iz.datum_izposoje, 104), ' ') AS datum_izposoje,
             ISNULL(CAST(DATEDIFF(DAY, iz.datum_izposoje, CAST(GETDATE() AS DATE)) AS VARCHAR), ' ') AS dni_izposoje, 
             ISNULL(CAST(c.id AS VARCHAR), ' ') AS clan_id,
             CONCAT_WS(' ', c.ime, c.priimek) AS clan
FROM            dbo.knjige AS k 
                         INNER JOIN dbo.status AS s ON k.status_knjige = s.id 
                         LEFT OUTER JOIN dbo.zanr AS z ON k.zanr_id = z.id 
                         LEFT OUTER JOIN dbo.izposoja AS iz ON iz.knjiga_id = k.id AND iz.datum_vracila IS NULL 
                         LEFT OUTER JOIN dbo.clan AS c ON c.id = iz.clan_id
GO
/****** Object:  Table [dbo].[log_izposoje]    Script Date: 08.10.2026 12:07:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_izposoje](
	[cas] [datetime] NOT NULL,
	[akcija] [varchar](20) NULL,
	[izposoja_id] [bigint] NOT NULL,
	[knjiga_id] [bigint] NOT NULL,
	[clan_id] [bigint] NOT NULL,
	[datum_izposoje] [date] NOT NULL,
	[datum_vracila] [date] NULL,
	[naslov_knjige] [nvarchar](max) NULL,
	[naziv_clana] [nvarchar](max) NULL,
	[naslov_clana] [nvarchar](max) NULL,
	[uporabnik] [nvarchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[clan] ON 
GO
INSERT [dbo].[clan] ([id], [ime], [priimek], [naslov], [telefon]) VALUES (1, N'Dragan', N'Jovanovic', N'Sadjarska 50 Race', N'051-555-555')
GO
INSERT [dbo].[clan] ([id], [ime], [priimek], [naslov], [telefon]) VALUES (2, N'Janez', N'Novak', N'Ljubljanska 1, Maribor', N'041-999-000')
GO
SET IDENTITY_INSERT [dbo].[clan] OFF
GO
SET IDENTITY_INSERT [dbo].[izposoja] ON 
GO
INSERT [dbo].[izposoja] ([id], [knjiga_id], [clan_id], [datum_izposoje], [datum_vracila]) VALUES (15, 1, 2, CAST(N'2026-10-06' AS Date), NULL)
GO
INSERT [dbo].[izposoja] ([id], [knjiga_id], [clan_id], [datum_izposoje], [datum_vracila]) VALUES (16, 5, 1, CAST(N'2026-10-06' AS Date), CAST(N'2026-10-06' AS Date))
GO
INSERT [dbo].[izposoja] ([id], [knjiga_id], [clan_id], [datum_izposoje], [datum_vracila]) VALUES (17, 6, 1, CAST(N'2026-10-06' AS Date), NULL)
GO
INSERT [dbo].[izposoja] ([id], [knjiga_id], [clan_id], [datum_izposoje], [datum_vracila]) VALUES (18, 2, 1, CAST(N'2026-10-07' AS Date), NULL)
GO
SET IDENTITY_INSERT [dbo].[izposoja] OFF
GO
SET IDENTITY_INSERT [dbo].[knjige] ON 
GO
INSERT [dbo].[knjige] ([id], [isbn], [avtor], [naslov], [zanr_id], [status_knjige]) VALUES (1, N'1234567890123', N'Ivan Cankar', N'Hlapci', 3, 2)
GO
INSERT [dbo].[knjige] ([id], [isbn], [avtor], [naslov], [zanr_id], [status_knjige]) VALUES (2, N'1234567890222', N'George Orwell', N'1984', 1, 2)
GO
INSERT [dbo].[knjige] ([id], [isbn], [avtor], [naslov], [zanr_id], [status_knjige]) VALUES (3, N'9876543210123', N'France Prešeren', N'Poezije', 2, 1)
GO
INSERT [dbo].[knjige] ([id], [isbn], [avtor], [naslov], [zanr_id], [status_knjige]) VALUES (5, N'5555555555555', N'Oton Župančič', N'Samogovori', NULL, 1)
GO
INSERT [dbo].[knjige] ([id], [isbn], [avtor], [naslov], [zanr_id], [status_knjige]) VALUES (6, N'8976132164641', N'Ivan Cankar', N'Skodelica kave', 3, 2)
GO
INSERT [dbo].[knjige] ([id], [isbn], [avtor], [naslov], [zanr_id], [status_knjige]) VALUES (7, N'9862131321311', N'Charles Bukowski', N'Špeh na kruhu', 1, 1)
GO
SET IDENTITY_INSERT [dbo].[knjige] OFF
GO
INSERT [dbo].[log_izposoje] ([cas], [akcija], [izposoja_id], [knjiga_id], [clan_id], [datum_izposoje], [datum_vracila], [naslov_knjige], [naziv_clana], [naslov_clana], [uporabnik]) VALUES (CAST(N'2026-10-05T18:02:44.243' AS DateTime), N'INSERT', 1, 1, 1, CAST(N'2026-10-05' AS Date), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[log_izposoje] ([cas], [akcija], [izposoja_id], [knjiga_id], [clan_id], [datum_izposoje], [datum_vracila], [naslov_knjige], [naziv_clana], [naslov_clana], [uporabnik]) VALUES (CAST(N'2026-10-05T18:05:36.233' AS DateTime), N'UPDATE', 1, 1, 1, CAST(N'2026-10-01' AS Date), CAST(N'2026-10-05' AS Date), NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[log_izposoje] ([cas], [akcija], [izposoja_id], [knjiga_id], [clan_id], [datum_izposoje], [datum_vracila], [naslov_knjige], [naziv_clana], [naslov_clana], [uporabnik]) VALUES (CAST(N'2026-10-06T08:02:08.690' AS DateTime), N'INSERT', 2, 1, 1, CAST(N'2026-10-06' AS Date), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[log_izposoje] ([cas], [akcija], [izposoja_id], [knjiga_id], [clan_id], [datum_izposoje], [datum_vracila], [naslov_knjige], [naziv_clana], [naslov_clana], [uporabnik]) VALUES (CAST(N'2026-10-06T08:02:14.760' AS DateTime), N'INSERT', 3, 5, 1, CAST(N'2026-10-06' AS Date), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[log_izposoje] ([cas], [akcija], [izposoja_id], [knjiga_id], [clan_id], [datum_izposoje], [datum_vracila], [naslov_knjige], [naziv_clana], [naslov_clana], [uporabnik]) VALUES (CAST(N'2026-10-06T08:11:24.730' AS DateTime), N'INSERT', 4, 2, 1, CAST(N'2026-10-06' AS Date), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[log_izposoje] ([cas], [akcija], [izposoja_id], [knjiga_id], [clan_id], [datum_izposoje], [datum_vracila], [naslov_knjige], [naziv_clana], [naslov_clana], [uporabnik]) VALUES (CAST(N'2026-10-06T08:12:11.437' AS DateTime), N'UPDATE', 2, 1, 1, CAST(N'2026-10-06' AS Date), CAST(N'2026-10-07' AS Date), NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[log_izposoje] ([cas], [akcija], [izposoja_id], [knjiga_id], [clan_id], [datum_izposoje], [datum_vracila], [naslov_knjige], [naziv_clana], [naslov_clana], [uporabnik]) VALUES (CAST(N'2026-10-06T08:21:35.773' AS DateTime), N'INSERT', 5, 3, 1, CAST(N'2026-10-06' AS Date), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[log_izposoje] ([cas], [akcija], [izposoja_id], [knjiga_id], [clan_id], [datum_izposoje], [datum_vracila], [naslov_knjige], [naziv_clana], [naslov_clana], [uporabnik]) VALUES (CAST(N'2026-10-06T08:21:58.557' AS DateTime), N'UPDATE', 3, 5, 1, CAST(N'2026-10-06' AS Date), CAST(N'2026-10-01' AS Date), NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[log_izposoje] ([cas], [akcija], [izposoja_id], [knjiga_id], [clan_id], [datum_izposoje], [datum_vracila], [naslov_knjige], [naziv_clana], [naslov_clana], [uporabnik]) VALUES (CAST(N'2026-10-06T08:22:13.700' AS DateTime), N'INSERT', 6, 5, 1, CAST(N'2026-10-06' AS Date), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[log_izposoje] ([cas], [akcija], [izposoja_id], [knjiga_id], [clan_id], [datum_izposoje], [datum_vracila], [naslov_knjige], [naziv_clana], [naslov_clana], [uporabnik]) VALUES (CAST(N'2026-10-06T08:25:57.387' AS DateTime), N'INSERT', 7, 1, 1, CAST(N'2026-10-06' AS Date), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[log_izposoje] ([cas], [akcija], [izposoja_id], [knjiga_id], [clan_id], [datum_izposoje], [datum_vracila], [naslov_knjige], [naziv_clana], [naslov_clana], [uporabnik]) VALUES (CAST(N'2026-10-06T08:34:34.617' AS DateTime), N'INSERT', 10, 4, 2, CAST(N'2026-10-06' AS Date), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[log_izposoje] ([cas], [akcija], [izposoja_id], [knjiga_id], [clan_id], [datum_izposoje], [datum_vracila], [naslov_knjige], [naziv_clana], [naslov_clana], [uporabnik]) VALUES (CAST(N'2026-10-06T09:09:11.140' AS DateTime), N'UPDATE', 7, 1, 1, CAST(N'2026-10-06' AS Date), CAST(N'2026-10-06' AS Date), N'Hlapci', N'Dragan Jovanovic', N'Sadjarska 50 Race', N'USER PLACEHOLDER')
GO
INSERT [dbo].[log_izposoje] ([cas], [akcija], [izposoja_id], [knjiga_id], [clan_id], [datum_izposoje], [datum_vracila], [naslov_knjige], [naziv_clana], [naslov_clana], [uporabnik]) VALUES (CAST(N'2026-10-06T09:15:27.210' AS DateTime), N'INSERT', 11, 1, 2, CAST(N'2026-10-06' AS Date), NULL, N'Hlapci', N'Janez Novak', N'Ljubljanska 1, Maribor', N'USER PLACEHOLDER')
GO
INSERT [dbo].[log_izposoje] ([cas], [akcija], [izposoja_id], [knjiga_id], [clan_id], [datum_izposoje], [datum_vracila], [naslov_knjige], [naziv_clana], [naslov_clana], [uporabnik]) VALUES (CAST(N'2026-10-06T09:16:42.960' AS DateTime), N'UPDATE', 5, 3, 1, CAST(N'2026-10-06' AS Date), CAST(N'2026-10-06' AS Date), N'Hlapci', N'Dragan Jovanovic', N'Sadjarska 50 Race', N'USER PLACEHOLDER')
GO
INSERT [dbo].[log_izposoje] ([cas], [akcija], [izposoja_id], [knjiga_id], [clan_id], [datum_izposoje], [datum_vracila], [naslov_knjige], [naziv_clana], [naslov_clana], [uporabnik]) VALUES (CAST(N'2026-10-06T10:01:20.867' AS DateTime), N'UPDATE', 4, 2, 1, CAST(N'2026-10-06' AS Date), NULL, N'Hlapci', N'Dragan Jovanovic', N'Sadjarska 50 Race', N'USER PLACEHOLDER')
GO
INSERT [dbo].[log_izposoje] ([cas], [akcija], [izposoja_id], [knjiga_id], [clan_id], [datum_izposoje], [datum_vracila], [naslov_knjige], [naziv_clana], [naslov_clana], [uporabnik]) VALUES (CAST(N'2026-10-06T10:01:25.477' AS DateTime), N'UPDATE', 4, 2, 1, CAST(N'2026-10-06' AS Date), NULL, N'Hlapci', N'Dragan Jovanovic', N'Sadjarska 50 Race', N'USER PLACEHOLDER')
GO
INSERT [dbo].[log_izposoje] ([cas], [akcija], [izposoja_id], [knjiga_id], [clan_id], [datum_izposoje], [datum_vracila], [naslov_knjige], [naziv_clana], [naslov_clana], [uporabnik]) VALUES (CAST(N'2026-10-06T10:03:25.697' AS DateTime), N'UPDATE', 4, 2, 1, CAST(N'2026-10-06' AS Date), NULL, N'Hlapci', N'Dragan Jovanovic', N'Sadjarska 50 Race', N'USER PLACEHOLDER')
GO
INSERT [dbo].[log_izposoje] ([cas], [akcija], [izposoja_id], [knjiga_id], [clan_id], [datum_izposoje], [datum_vracila], [naslov_knjige], [naziv_clana], [naslov_clana], [uporabnik]) VALUES (CAST(N'2026-10-06T10:03:43.057' AS DateTime), N'UPDATE', 4, 2, 1, CAST(N'2026-10-06' AS Date), NULL, N'Hlapci', N'Dragan Jovanovic', N'Sadjarska 50 Race', N'USER PLACEHOLDER')
GO
INSERT [dbo].[log_izposoje] ([cas], [akcija], [izposoja_id], [knjiga_id], [clan_id], [datum_izposoje], [datum_vracila], [naslov_knjige], [naziv_clana], [naslov_clana], [uporabnik]) VALUES (CAST(N'2026-10-06T10:05:53.573' AS DateTime), N'UPDATE', 4, 2, 1, CAST(N'2026-10-01' AS Date), NULL, N'Hlapci', N'Dragan Jovanovic', N'Sadjarska 50 Race', N'USER PLACEHOLDER')
GO
INSERT [dbo].[log_izposoje] ([cas], [akcija], [izposoja_id], [knjiga_id], [clan_id], [datum_izposoje], [datum_vracila], [naslov_knjige], [naziv_clana], [naslov_clana], [uporabnik]) VALUES (CAST(N'2026-10-06T10:06:06.307' AS DateTime), N'UPDATE', 6, 5, 1, CAST(N'2026-10-02' AS Date), NULL, N'1984', N'Dragan Jovanovic', N'Sadjarska 50 Race', N'USER PLACEHOLDER')
GO
INSERT [dbo].[log_izposoje] ([cas], [akcija], [izposoja_id], [knjiga_id], [clan_id], [datum_izposoje], [datum_vracila], [naslov_knjige], [naziv_clana], [naslov_clana], [uporabnik]) VALUES (CAST(N'2026-10-06T19:16:15.040' AS DateTime), N'INSERT', 14, 6, 2, CAST(N'2026-10-06' AS Date), NULL, N'Poezije', N'Janez Novak', N'Ljubljanska 1, Maribor', N'USER PLACEHOLDER')
GO
INSERT [dbo].[log_izposoje] ([cas], [akcija], [izposoja_id], [knjiga_id], [clan_id], [datum_izposoje], [datum_vracila], [naslov_knjige], [naziv_clana], [naslov_clana], [uporabnik]) VALUES (CAST(N'2026-10-06T19:18:27.063' AS DateTime), N'UPDATE', 11, 1, 2, CAST(N'2026-10-06' AS Date), CAST(N'2026-10-06' AS Date), N'Hlapci', N'Janez Novak', N'Ljubljanska 1, Maribor', N'USER PLACEHOLDER')
GO
INSERT [dbo].[log_izposoje] ([cas], [akcija], [izposoja_id], [knjiga_id], [clan_id], [datum_izposoje], [datum_vracila], [naslov_knjige], [naziv_clana], [naslov_clana], [uporabnik]) VALUES (CAST(N'2026-10-06T20:33:02.507' AS DateTime), N'INSERT', 15, 1, 2, CAST(N'2026-10-06' AS Date), NULL, N'Hlapci', N'Janez Novak', N'Ljubljanska 1, Maribor', N'USER PLACEHOLDER')
GO
INSERT [dbo].[log_izposoje] ([cas], [akcija], [izposoja_id], [knjiga_id], [clan_id], [datum_izposoje], [datum_vracila], [naslov_knjige], [naziv_clana], [naslov_clana], [uporabnik]) VALUES (CAST(N'2026-10-06T20:33:20.710' AS DateTime), N'INSERT', 16, 5, 1, CAST(N'2026-10-06' AS Date), NULL, N'Samogovori', N'Dragan Jovanovic', N'Sadjarska 50 Race', N'USER PLACEHOLDER')
GO
INSERT [dbo].[log_izposoje] ([cas], [akcija], [izposoja_id], [knjiga_id], [clan_id], [datum_izposoje], [datum_vracila], [naslov_knjige], [naziv_clana], [naslov_clana], [uporabnik]) VALUES (CAST(N'2026-10-06T20:38:02.123' AS DateTime), N'UPDATE', 16, 5, 1, CAST(N'2026-10-06' AS Date), CAST(N'2026-10-06' AS Date), N'Samogovori', N'Dragan Jovanovic', N'Sadjarska 50 Race', N'USER PLACEHOLDER')
GO
INSERT [dbo].[log_izposoje] ([cas], [akcija], [izposoja_id], [knjiga_id], [clan_id], [datum_izposoje], [datum_vracila], [naslov_knjige], [naziv_clana], [naslov_clana], [uporabnik]) VALUES (CAST(N'2026-10-06T20:45:27.847' AS DateTime), N'INSERT', 17, 6, 1, CAST(N'2026-10-06' AS Date), NULL, N'Skodelica kave', N'Dragan Jovanovic', N'Sadjarska 50 Race', N'USER PLACEHOLDER')
GO
INSERT [dbo].[log_izposoje] ([cas], [akcija], [izposoja_id], [knjiga_id], [clan_id], [datum_izposoje], [datum_vracila], [naslov_knjige], [naziv_clana], [naslov_clana], [uporabnik]) VALUES (CAST(N'2026-10-07T07:21:34.740' AS DateTime), N'INSERT', 18, 2, 1, CAST(N'2026-10-07' AS Date), NULL, N'1984', N'Dragan Jovanovic', N'Sadjarska 50 Race', N'USER PLACEHOLDER')
GO
SET IDENTITY_INSERT [dbo].[status] ON 
GO
INSERT [dbo].[status] ([id], [naziv], [za_izposojo], [za_vracilo]) VALUES (1, N'na voljo', 1, 0)
GO
INSERT [dbo].[status] ([id], [naziv], [za_izposojo], [za_vracilo]) VALUES (2, N'izposojena', 0, 1)
GO
INSERT [dbo].[status] ([id], [naziv], [za_izposojo], [za_vracilo]) VALUES (3, N'ni na voljo', 0, 0)
GO
SET IDENTITY_INSERT [dbo].[status] OFF
GO
SET IDENTITY_INSERT [dbo].[zanr] ON 
GO
INSERT [dbo].[zanr] ([id], [naziv]) VALUES (2, N'ep')
GO
INSERT [dbo].[zanr] ([id], [naziv]) VALUES (3, N'novela')
GO
INSERT [dbo].[zanr] ([id], [naziv]) VALUES (1, N'roman')
GO
SET IDENTITY_INSERT [dbo].[zanr] OFF
GO
/****** Object:  Index [UQ_status_knjige_kombinacija]    Script Date: 08.10.2026 12:07:56 ******/
ALTER TABLE [dbo].[status] ADD  CONSTRAINT [UQ_status_knjige_kombinacija] UNIQUE NONCLUSTERED 
(
	[za_izposojo] ASC,
	[za_vracilo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_status_knjige_naziv]    Script Date: 08.10.2026 12:07:56 ******/
ALTER TABLE [dbo].[status] ADD  CONSTRAINT [UQ_status_knjige_naziv] UNIQUE NONCLUSTERED 
(
	[naziv] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_zanr_knjige_naziv]    Script Date: 08.10.2026 12:07:56 ******/
ALTER TABLE [dbo].[zanr] ADD  CONSTRAINT [UQ_zanr_knjige_naziv] UNIQUE NONCLUSTERED 
(
	[naziv] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[knjige] ADD  CONSTRAINT [DF__knjige__status_k__4A8310C6]  DEFAULT ((1)) FOR [status_knjige]
GO
ALTER TABLE [dbo].[log_izposoje] ADD  DEFAULT (getdate()) FOR [cas]
GO
ALTER TABLE [dbo].[status] ADD  DEFAULT ((0)) FOR [za_izposojo]
GO
ALTER TABLE [dbo].[status] ADD  DEFAULT ((0)) FOR [za_vracilo]
GO
ALTER TABLE [dbo].[izposoja]  WITH CHECK ADD  CONSTRAINT [FK_izposoja_clan] FOREIGN KEY([clan_id])
REFERENCES [dbo].[clan] ([id])
GO
ALTER TABLE [dbo].[izposoja] CHECK CONSTRAINT [FK_izposoja_clan]
GO
ALTER TABLE [dbo].[izposoja]  WITH CHECK ADD  CONSTRAINT [FK_izposoja_knjige] FOREIGN KEY([knjiga_id])
REFERENCES [dbo].[knjige] ([id])
GO
ALTER TABLE [dbo].[izposoja] CHECK CONSTRAINT [FK_izposoja_knjige]
GO
ALTER TABLE [dbo].[knjige]  WITH CHECK ADD  CONSTRAINT [FK_status_knjige] FOREIGN KEY([status_knjige])
REFERENCES [dbo].[status] ([id])
GO
ALTER TABLE [dbo].[knjige] CHECK CONSTRAINT [FK_status_knjige]
GO
ALTER TABLE [dbo].[knjige]  WITH CHECK ADD  CONSTRAINT [FK_zanr_knjige] FOREIGN KEY([zanr_id])
REFERENCES [dbo].[zanr] ([id])
GO
ALTER TABLE [dbo].[knjige] CHECK CONSTRAINT [FK_zanr_knjige]
GO
/****** Object:  StoredProcedure [dbo].[SP_izposoja]    Script Date: 08.10.2026 12:07:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SP_izposoja]
    @id_knjige BIGINT,
    @id_clana BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Vnos nove izposoje z današnjim datumom
        INSERT INTO izposoja (knjiga_id, clan_id, datum_izposoje, datum_vracila)
        VALUES (@id_knjige, @id_clana, CAST(GETDATE() AS DATE), NULL);

        COMMIT TRANSACTION;
        PRINT 'Izposoja uspešno dodana.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_vracilo]    Script Date: 08.10.2026 12:07:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SP_vracilo]
    @id_knjige BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Preverimo, ali obstaja aktivna izposoja za to knjigo
        IF NOT EXISTS (
            SELECT 1 
            FROM izposoja 
            WHERE knjiga_id = @id_knjige AND datum_vracila IS NULL
        )
        BEGIN
            RAISERROR('Za to knjigo ni bila najdena nobena aktivna izposoja.', 16, 1);
        END

        -- 2. Posodobimo datum vračila na današnji datum
        UPDATE izposoja
        SET datum_vracila = CAST(GETDATE() AS DATE)
        WHERE knjiga_id = @id_knjige AND datum_vracila IS NULL;

        COMMIT TRANSACTION;
        PRINT 'Vračilo uspešno zabeleženo.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO
/****** Object:  Trigger [dbo].[TR_izposoja_Audit_Insert]    Script Date: 08.10.2026 12:07:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TR_izposoja_Audit_Insert]
ON [dbo].[izposoja]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [dbo].[log_izposoje] ([akcija], [izposoja_id], knjiga_id, clan_id, datum_izposoje, datum_vracila, naslov_knjige, naziv_clana, naslov_clana, uporabnik)
    SELECT 
        'INSERT',
        i.[id],
        i.knjiga_id,
        i.clan_id,
        i.datum_izposoje, 
        i.datum_vracila,
        k.naslov,
        CONCAT_WS(' ', c.ime, c.priimek),
        c.naslov,
        'USER PLACEHOLDER'
        
    FROM inserted i
    left outer join knjige k on k.id = i.knjiga_id
    left outer join clan c on c.id = i.clan_id;
END;
GO
ALTER TABLE [dbo].[izposoja] ENABLE TRIGGER [TR_izposoja_Audit_Insert]
GO
/****** Object:  Trigger [dbo].[TR_izposoja_Audit_Update]    Script Date: 08.10.2026 12:07:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TR_izposoja_Audit_Update]
ON [dbo].[izposoja]
AFTER update
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [dbo].[log_izposoje] ([akcija], [izposoja_id], knjiga_id, clan_id, datum_izposoje, datum_vracila, naslov_knjige, naziv_clana, naslov_clana, uporabnik)
    SELECT 
        'UPDATE',
        i.[id],
        i.knjiga_id,
        i.clan_id,
        i.datum_izposoje, 
        i.datum_vracila,
        k.naslov,
        CONCAT_WS(' ', c.ime, c.priimek),
        c.naslov,
        'USER PLACEHOLDER'
        
    FROM inserted i
    left outer join knjige k on k.id = i.knjiga_id
    left outer join clan c on c.id = i.clan_id;
        
END;
GO
ALTER TABLE [dbo].[izposoja] ENABLE TRIGGER [TR_izposoja_Audit_Update]
GO
/****** Object:  Trigger [dbo].[trg_PreveriStatusKnjige]    Script Date: 08.10.2026 12:07:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[trg_PreveriStatusKnjige]
ON [dbo].[izposoja]
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Preverimo, ali med vstavljenimi vrsticami obstaja kakšna, 
    -- ki ima status knjige označen z za_izposojo = 0 (false)
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN knjige k ON i.knjiga_id = k.id
        JOIN status sk ON k.status_knjige = sk.id
                WHERE sk.za_izposojo = 0
    )
    BEGIN
        -- Če knjiga ni na voljo za izposojo, prekličemo operacijo in vržemo napako
        RAISERROR ('Knjiga ni na voljo za izposojo (status ne dovoljuje izposoje).', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- 2. dodamo nov zapis v isposojo
    INSERT INTO izposoja (knjiga_id, clan_id, datum_izposoje, datum_vracila)
    SELECT knjiga_id, clan_id, GETDATE(), null
    FROM inserted i;

    -- 3. Posodobimo status v tabeli knjige na status za "izposojeno"
    UPDATE k
    SET k.status_knjige = (SELECT id FROM status s WHERE s.za_izposojo = 0 and s.za_vracilo = 1)
    FROM knjige k
    JOIN inserted i ON k.id = i.knjiga_id;
END;
GO
ALTER TABLE [dbo].[izposoja] ENABLE TRIGGER [trg_PreveriStatusKnjige]
GO
/****** Object:  Trigger [dbo].[trg_SpremeniStatusObVracilu]    Script Date: 08.10.2026 12:07:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   TRIGGER [dbo].[trg_SpremeniStatusObVracilu]
ON [dbo].[izposoja]
INSTEAD OF UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Posodobimo samo datum_vracila v tabeli izposoja
    UPDATE i
    SET i.datum_vracila = ins.datum_vracila,
        i.datum_izposoje = ins.datum_izposoje
    FROM izposoja i
    JOIN inserted ins ON i.id = ins.id;

    -- 2. Posodobimo status v tabeli knjige na 'na_voljo' 
    UPDATE k
    SET k.status_knjige = (SELECT id FROM status WHERE za_izposojo=1 and za_vracilo=0)
    FROM knjige k
    JOIN inserted ins ON k.id = ins.knjiga_id
    WHERE ins.datum_vracila IS NOT NULL; -- Status posodobimo le, če je datum vračila določen
END;
GO
ALTER TABLE [dbo].[izposoja] ENABLE TRIGGER [trg_SpremeniStatusObVracilu]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "i"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 226
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "k"
            Begin Extent = 
               Top = 6
               Left = 264
               Bottom = 136
               Right = 434
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "z"
            Begin Extent = 
               Top = 138
               Left = 246
               Bottom = 234
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "iz"
            Begin Extent = 
               Top = 234
               Left = 246
               Bottom = 364
               Right = 418
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 400
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
     ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'pregled'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'    Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'pregled'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'pregled'
GO
USE [master]
GO
ALTER DATABASE [Knjiznica] SET  READ_WRITE 
GO

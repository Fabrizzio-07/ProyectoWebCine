-- ProyectoWebCine: esquema de la base de datos confiteria (SQL Server 2025)
-- Generado a partir de una exportacion de solo esquema; sin cuentas SQL ni datos reales.
-- Ejecutar unicamente en un servidor donde NO exista la base confiteria.
IF DB_ID(N'confiteria') IS NOT NULL
    THROW 50001, N'La base confiteria ya existe. No ejecutar este script sobre una base existente.', 1;
GO
CREATE DATABASE [confiteria];
GO
USE [confiteria];
GO
/****** Objeto: Table [dbo].[ClientesBoletos] Fecha de script: 12/11/2026 04:44:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientesBoletos](
	[id_cliente] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](100) NOT NULL,
	[frecuencia] [int] NOT NULL,
PRIMARY KEY CLUSTERED
(
	[id_cliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[DetalleVenta] Fecha de script: 12/11/2026 04:44:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetalleVenta](
	[id_detalle] [int] IDENTITY(1,1) NOT NULL,
	[id_venta] [int] NULL,
	[id_producto] [int] NULL,
	[cantidad] [int] NULL,
	[subtotal] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED
(
	[id_detalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[GeneroBoleto] Fecha de script: 12/11/2026 04:44:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GeneroBoleto](
	[codigo_genero] [char](2) NOT NULL,
	[nombre_genero] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED
(
	[codigo_genero] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_GeneroBoleto_nombre_genero] UNIQUE NONCLUSTERED
(
	[nombre_genero] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[HorarioFuncionBoleto] Fecha de script: 12/11/2026 04:44:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HorarioFuncionBoleto](
	[id_horario] [int] IDENTITY(1,1) NOT NULL,
	[codigo_pelicula] [char](6) NOT NULL,
	[sala] [int] NOT NULL,
	[hora_funcion] [time](7) NOT NULL,
PRIMARY KEY CLUSTERED
(
	[id_horario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_HorarioFuncionBoleto] UNIQUE NONCLUSTERED
(
	[codigo_pelicula] ASC,
	[sala] ASC,
	[hora_funcion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[PeliculaBoleto] Fecha de script: 12/11/2026 04:44:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PeliculaBoleto](
	[codigo] [char](6) NOT NULL,
	[nombre] [varchar](120) NOT NULL,
	[duracion_minutos] [int] NOT NULL,
	[precio_base] [decimal](10, 2) NOT NULL,
	[imagen_url] [varchar](500) NULL,
	[estado] [bit] NOT NULL,
PRIMARY KEY CLUSTERED
(
	[codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Personal] Fecha de script: 12/11/2026 04:44:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Personal](
	[id_personal] [int] IDENTITY(1,1) NOT NULL,
	[nombre_completo] [varchar](100) NOT NULL,
	[usuario] [varchar](50) NOT NULL,
	[password] [varchar](255) NOT NULL,
	[id_rol] [int] NOT NULL,
	[estado] [bit] NULL,
PRIMARY KEY CLUSTERED
(
	[id_personal] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED
(
	[usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED
(
	[usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Producto] Fecha de script: 12/11/2026 04:44:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Producto](
	[id_producto] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](100) NOT NULL,
	[precio] [decimal](10, 2) NOT NULL,
	[stock] [int] NOT NULL,
	[categoria] [varchar](50) NULL,
	[estado] [bit] NULL,
	[imagen] [varchar](500) NULL,
PRIMARY KEY CLUSTERED
(
	[id_producto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Rol] Fecha de script: 12/11/2026 04:44:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rol](
	[id_rol] [int] IDENTITY(1,1) NOT NULL,
	[nombre_rol] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED
(
	[id_rol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Venta] Fecha de script: 12/11/2026 04:44:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Venta](
	[id_venta] [int] IDENTITY(1,1) NOT NULL,
	[id_personal] [int] NULL,
	[fecha] [datetime] NULL,
	[total] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED
(
	[id_venta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[VentaAsientoBoleto] Fecha de script: 12/11/2026 04:44:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VentaAsientoBoleto](
	[id_venta_asiento] [int] IDENTITY(1,1) NOT NULL,
	[id_venta] [int] NOT NULL,
	[asiento] [varchar](4) NOT NULL,
PRIMARY KEY CLUSTERED
(
	[id_venta_asiento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_VentaAsientoBoleto] UNIQUE NONCLUSTERED
(
	[id_venta] ASC,
	[asiento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[VentaBoleto] Fecha de script: 12/11/2026 04:44:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VentaBoleto](
	[id_venta] [int] IDENTITY(1,1) NOT NULL,
	[id_personal] [int] NOT NULL,
	[id_cliente] [int] NOT NULL,
	[codigo_pelicula] [char](6) NOT NULL,
	[id_horario] [int] NOT NULL,
	[fecha_compra] [date] NOT NULL,
	[hora_compra] [time](7) NOT NULL,
	[monto_total] [decimal](10, 2) NOT NULL,
PRIMARY KEY CLUSTERED
(
	[id_venta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Objeto: Index [IX_ClientesBoletos_Nombre] Fecha de script: 12/11/2026 04:44:16 ******/
CREATE NONCLUSTERED INDEX [IX_ClientesBoletos_Nombre] ON [dbo].[ClientesBoletos]
(
	[nombre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Objeto: Index [IX_GeneroBoleto_NombreGenero] Fecha de script: 12/11/2026 04:44:16 ******/
CREATE NONCLUSTERED INDEX [IX_GeneroBoleto_NombreGenero] ON [dbo].[GeneroBoleto]
(
	[nombre_genero] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Objeto: Index [IX_HorarioFuncionBoleto_CodigoPelicula] Fecha de script: 12/11/2026 04:44:16 ******/
CREATE NONCLUSTERED INDEX [IX_HorarioFuncionBoleto_CodigoPelicula] ON [dbo].[HorarioFuncionBoleto]
(
	[codigo_pelicula] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Objeto: Index [IX_HorarioFuncionBoleto_HoraFuncion] Fecha de script: 12/11/2026 04:44:16 ******/
CREATE NONCLUSTERED INDEX [IX_HorarioFuncionBoleto_HoraFuncion] ON [dbo].[HorarioFuncionBoleto]
(
	[hora_funcion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Objeto: Index [IX_HorarioFuncionBoleto_Sala] Fecha de script: 12/11/2026 04:44:16 ******/
CREATE NONCLUSTERED INDEX [IX_HorarioFuncionBoleto_Sala] ON [dbo].[HorarioFuncionBoleto]
(
	[sala] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Objeto: Index [IX_PeliculaBoleto_Estado] Fecha de script: 12/11/2026 04:44:16 ******/
CREATE NONCLUSTERED INDEX [IX_PeliculaBoleto_Estado] ON [dbo].[PeliculaBoleto]
(
	[estado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Objeto: Index [IX_PeliculaBoleto_Nombre] Fecha de script: 12/11/2026 04:44:16 ******/
CREATE NONCLUSTERED INDEX [IX_PeliculaBoleto_Nombre] ON [dbo].[PeliculaBoleto]
(
	[nombre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Objeto: Index [IX_VentaAsientoBoleto_IdVenta] Fecha de script: 12/11/2026 04:44:16 ******/
CREATE NONCLUSTERED INDEX [IX_VentaAsientoBoleto_IdVenta] ON [dbo].[VentaAsientoBoleto]
(
	[id_venta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Objeto: Index [IX_VentaBoleto_CodigoPelicula] Fecha de script: 12/11/2026 04:44:16 ******/
CREATE NONCLUSTERED INDEX [IX_VentaBoleto_CodigoPelicula] ON [dbo].[VentaBoleto]
(
	[codigo_pelicula] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Objeto: Index [IX_VentaBoleto_FechaCompra] Fecha de script: 12/11/2026 04:44:16 ******/
CREATE NONCLUSTERED INDEX [IX_VentaBoleto_FechaCompra] ON [dbo].[VentaBoleto]
(
	[fecha_compra] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Objeto: Index [IX_VentaBoleto_IdCliente] Fecha de script: 12/11/2026 04:44:16 ******/
CREATE NONCLUSTERED INDEX [IX_VentaBoleto_IdCliente] ON [dbo].[VentaBoleto]
(
	[id_cliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Objeto: Index [IX_VentaBoleto_IdHorario] Fecha de script: 12/11/2026 04:44:16 ******/
CREATE NONCLUSTERED INDEX [IX_VentaBoleto_IdHorario] ON [dbo].[VentaBoleto]
(
	[id_horario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClientesBoletos] ADD  CONSTRAINT [DF_ClientesBoletos_frecuencia]  DEFAULT ((0)) FOR [frecuencia]
GO
ALTER TABLE [dbo].[PeliculaBoleto] ADD  CONSTRAINT [DF_PeliculaBoleto_estado]  DEFAULT ((1)) FOR [estado]
GO
ALTER TABLE [dbo].[Personal] ADD  DEFAULT ((1)) FOR [estado]
GO
ALTER TABLE [dbo].[Producto] ADD  DEFAULT ((1)) FOR [estado]
GO
ALTER TABLE [dbo].[Venta] ADD  DEFAULT (getdate()) FOR [fecha]
GO
ALTER TABLE [dbo].[DetalleVenta]  WITH CHECK ADD FOREIGN KEY([id_producto])
REFERENCES [dbo].[Producto] ([id_producto])
GO
ALTER TABLE [dbo].[DetalleVenta]  WITH CHECK ADD FOREIGN KEY([id_producto])
REFERENCES [dbo].[Producto] ([id_producto])
GO
ALTER TABLE [dbo].[DetalleVenta]  WITH CHECK ADD FOREIGN KEY([id_venta])
REFERENCES [dbo].[Venta] ([id_venta])
GO
ALTER TABLE [dbo].[DetalleVenta]  WITH CHECK ADD FOREIGN KEY([id_venta])
REFERENCES [dbo].[Venta] ([id_venta])
GO
ALTER TABLE [dbo].[HorarioFuncionBoleto]  WITH CHECK ADD  CONSTRAINT [FK_HorarioFuncionBoleto_Pelicula] FOREIGN KEY([codigo_pelicula])
REFERENCES [dbo].[PeliculaBoleto] ([codigo])
GO
ALTER TABLE [dbo].[HorarioFuncionBoleto] CHECK CONSTRAINT [FK_HorarioFuncionBoleto_Pelicula]
GO
ALTER TABLE [dbo].[Personal]  WITH CHECK ADD FOREIGN KEY([id_rol])
REFERENCES [dbo].[Rol] ([id_rol])
GO
ALTER TABLE [dbo].[Personal]  WITH CHECK ADD FOREIGN KEY([id_rol])
REFERENCES [dbo].[Rol] ([id_rol])
GO
ALTER TABLE [dbo].[Venta]  WITH CHECK ADD FOREIGN KEY([id_personal])
REFERENCES [dbo].[Personal] ([id_personal])
GO
ALTER TABLE [dbo].[Venta]  WITH CHECK ADD FOREIGN KEY([id_personal])
REFERENCES [dbo].[Personal] ([id_personal])
GO
ALTER TABLE [dbo].[VentaAsientoBoleto]  WITH CHECK ADD  CONSTRAINT [FK_VentaAsientoBoleto_Venta] FOREIGN KEY([id_venta])
REFERENCES [dbo].[VentaBoleto] ([id_venta])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[VentaAsientoBoleto] CHECK CONSTRAINT [FK_VentaAsientoBoleto_Venta]
GO
ALTER TABLE [dbo].[VentaBoleto]  WITH CHECK ADD  CONSTRAINT [FK_VentaBoleto_ClientesBoletos] FOREIGN KEY([id_cliente])
REFERENCES [dbo].[ClientesBoletos] ([id_cliente])
GO
ALTER TABLE [dbo].[VentaBoleto] CHECK CONSTRAINT [FK_VentaBoleto_ClientesBoletos]
GO
ALTER TABLE [dbo].[VentaBoleto]  WITH CHECK ADD  CONSTRAINT [FK_VentaBoleto_Horario] FOREIGN KEY([id_horario])
REFERENCES [dbo].[HorarioFuncionBoleto] ([id_horario])
GO
ALTER TABLE [dbo].[VentaBoleto] CHECK CONSTRAINT [FK_VentaBoleto_Horario]
GO
ALTER TABLE [dbo].[VentaBoleto]  WITH CHECK ADD  CONSTRAINT [FK_VentaBoleto_Pelicula] FOREIGN KEY([codigo_pelicula])
REFERENCES [dbo].[PeliculaBoleto] ([codigo])
GO
ALTER TABLE [dbo].[VentaBoleto] CHECK CONSTRAINT [FK_VentaBoleto_Pelicula]
GO
ALTER TABLE [dbo].[VentaBoleto]  WITH CHECK ADD  CONSTRAINT [FK_VentaBoleto_Personal] FOREIGN KEY([id_personal])
REFERENCES [dbo].[Personal] ([id_personal])
GO
ALTER TABLE [dbo].[VentaBoleto] CHECK CONSTRAINT [FK_VentaBoleto_Personal]
GO
/****** Objeto: StoredProcedure [dbo].[listarPeliculasPorGenero] Fecha de script: 12/11/2026 04:44:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[listarPeliculasPorGenero]
    @Genero VARCHAR(30)
AS
BEGIN
    SELECT nombre
    FROM PeliculaBoleto
    WHERE left(codigo,2)=(select codigo_genero
                          from GeneroBoleto
                          where nombre_genero=@Genero)
END;
GO
/****** Objeto: StoredProcedure [dbo].[sp_TotalVentasPorPersonal] Fecha de script: 12/11/2026 04:44:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_TotalVentasPorPersonal]
    @IdPersonal INT,
    @Total DECIMAL(10,2) OUTPUT
AS
BEGIN
    SELECT @Total = SUM(monto_total)
    FROM VentaBoleto
    WHERE id_personal = @IdPersonal;
END;
GO

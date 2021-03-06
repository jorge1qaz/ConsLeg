USE [master]
GO
/****** Object:  Database [Abogados]    Script Date: 16/07/2017 8:29:26 ******/
CREATE DATABASE [Abogados]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Abogados', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\Abogados.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Abogados_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\Abogados_log.ldf' , SIZE = 3136KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Abogados] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Abogados].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Abogados] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Abogados] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Abogados] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Abogados] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Abogados] SET ARITHABORT OFF 
GO
ALTER DATABASE [Abogados] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Abogados] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [Abogados] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Abogados] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Abogados] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Abogados] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Abogados] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Abogados] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Abogados] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Abogados] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Abogados] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Abogados] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Abogados] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Abogados] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Abogados] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Abogados] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Abogados] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Abogados] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Abogados] SET RECOVERY FULL 
GO
ALTER DATABASE [Abogados] SET  MULTI_USER 
GO
ALTER DATABASE [Abogados] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Abogados] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Abogados] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Abogados] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'Abogados', N'ON'
GO
USE [Abogados]
GO
/****** Object:  StoredProcedure [dbo].[SP_detalleAbogado]    Script Date: 16/07/2017 8:29:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_detalleAbogado]
@idAbo nvarchar(50)
as
Begin
	Select
	abo.Nombre as Nombre, abo.Apellido as Apellido,abo.Puntuacion as Puntuacion, abo.foto as foto,
	abo.MinPorSesion as CasosResueltos, abo.Resumen as Resumen, abo.Capacitaciones as Capacitaciones,
	abo.InfoAdicional as InfoAdicional, concat(abo.MinPorSesion, ' minutos') as MinPorSesion,
	concat('S/ ', CONVERT(money,abo.PrecioSesion, 1)) as PrecioSesion,  
	u.Direccion as dir, u.lat as lat, u.long as long from Abogados as abo
	inner join Ubicacion as u
	on u.Correo = abo.Correo
	where abo.Correo = @idAbo
End
GO
/****** Object:  StoredProcedure [dbo].[SP_detalleAbogadoFotoNom]    Script Date: 16/07/2017 8:29:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_detalleAbogadoFotoNom]
@idAbog nvarchar(50)
as
Begin
	Select foto,Nombre,Apellido from Abogados
	where Abogados.Correo = @idAbog
End
GO
/****** Object:  StoredProcedure [dbo].[SP_HacerComentario]    Script Date: 16/07/2017 8:29:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_HacerComentario]
@IdComentario int, 
@Detalle nvarchar(200), 
@Fecha date, 
@IdCliente nvarchar(50), 
@IdAbogado nvarchar(50),
@Puntuacion decimal(18, 0),
@Mensaje nvarchar(200) output
as
Begin try
	Insert into [dbo].[Comentarios] (Detalle, Fecha, Email, Correo, Puntuacion)
	values ( @Detalle, @Fecha, @IdCliente, @IdAbogado, @Puntuacion)
	Select @Mensaje = '¡Se realizó el comentario con éxito!'
	End try
Begin catch
	Select @Mensaje = 'Ha ocurrido un error el base de datos. ERROR: ' + ERROR_MESSAGE()
End catch
GO
/****** Object:  StoredProcedure [dbo].[SP_JuicioArray]    Script Date: 16/07/2017 8:29:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_JuicioArray]
@id int,
@valor smallint
as
	update [dbo].[JuicioDeAlimentos]
		set valorArray = @valor
		where IdPreg = @id

GO
/****** Object:  StoredProcedure [dbo].[SP_JuicioArrayLimpiar]    Script Date: 16/07/2017 8:29:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_JuicioArrayLimpiar]
as
	update [dbo].[JuicioDeAlimentos]
		set valorArray = 0
GO
/****** Object:  StoredProcedure [dbo].[SP_leerJDA]    Script Date: 16/07/2017 8:29:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[SP_leerJDA]
as
select * from JuicioDeAlimentos
GO
/****** Object:  StoredProcedure [dbo].[SP_listarAbogados]    Script Date: 16/07/2017 8:29:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_listarAbogados]
as
select Correo,Nombre,Apellido,Telefono,Pais,Puntuacion,foto,MinPorSesion from Abogados
order by Puntuacion desc
GO
/****** Object:  StoredProcedure [dbo].[SP_Login]    Script Date: 16/07/2017 8:29:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Login]
@Email nvarchar(50),
@Contrasenia nvarchar(MAX),
@Mensaje bit Output
as
	declare @PassEncode As nvarchar(MAX)
	declare @PassDecode As nvarchar(50)
Begin
	
		Select @PassEncode = Contrasenia  from Cliente  Where Email = @Email
		Select @PassEncode = Contrasenia  from Abogados  Where Correo = @Email
		Set @PassEncode = DECRYPTBYPASSPHRASE('password', @PassEncode)
End
Begin
	If @PassEncode = @Contrasenia
		Set @Mensaje = 1
	Else
		Set @Mensaje = 0
End
GO
/****** Object:  StoredProcedure [dbo].[SP_ModificarCapacidades]    Script Date: 16/07/2017 8:29:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_ModificarCapacidades]
@Correo nvarchar(50),
@Resumen nvarchar(MAX),
@Capacitaciones nvarchar(MAX),
@InfoAdicional nvarchar(MAX),
@Mensaje nvarchar(200) output
as
Begin try
	Update Abogados 
	set Resumen = @Resumen, Capacitaciones = @Capacitaciones, InfoAdicional = @InfoAdicional
	where Correo = @Correo;
	Select @Mensaje = '¡Se realizó el comentario con éxito!'
	End try
Begin catch
	Select @Mensaje = 'Ha ocurrido un error el base de datos. ERROR: ' + ERROR_MESSAGE()
End catch
GO
/****** Object:  StoredProcedure [dbo].[SP_MostrarComentarios]    Script Date: 16/07/2017 8:29:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[SP_MostrarComentarios]
@IdAbogado nvarchar(50)
as
Select cl.foto as foto, cl.Nombre as Nombre, cl.Apellidos as Apellidos, com.Detalle as Detalle, com.Puntuacion as Puntuacion, 
com.Fecha  as Fecha from comentarios as com
inner join Cliente as cl
on cl.Email = com.Email
where correo = @IdAbogado
order by Fecha desc
GO
/****** Object:  StoredProcedure [dbo].[SP_MostrarComentariosReducido]    Script Date: 16/07/2017 8:29:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_MostrarComentariosReducido]
@IdAbogado nvarchar(50)
as
Select top 4 cl.foto as foto, cl.Nombre as Nombre, cl.Apellidos as Apellidos, com.Detalle as Detalle, com.Puntuacion as Puntuacion, 
com.Fecha  as Fecha from comentarios as com
inner join Cliente as cl
on cl.Email = com.Email
where correo = @IdAbogado
order by Fecha desc
GO
/****** Object:  StoredProcedure [dbo].[SP_RegistrarAbogado]    Script Date: 16/07/2017 8:29:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_RegistrarAbogado]
@Nombre nvarchar(50), 
@Apellido nvarchar(50),
@FechaNac date,
@Correo nvarchar(50),
@Contrasenia nvarchar(MAX),
@Telefono nvarchar(50), 
@Pais nvarchar(50),
@Puntuacion decimal(18, 0),
@foto nvarchar(200),
@MinPorSesion int,
@PrecioSesion money,
@Mensaje nvarchar(200) output
as
Begin try
	Insert into [dbo].[Abogados] (Nombre, Apellido, FechaNac, Correo, Contrasenia, Telefono, Pais, Puntuacion,
	 foto, MinPorSesion,PrecioSesion, Resumen, Capacitaciones, InfoAdicional)
	values (@Nombre, @Apellido, CONVERT(nvarchar(20), @FechaNac, 103), @Correo, ENCRYPTBYPASSPHRASE('password', @Contrasenia),
	 @Telefono, @Pais, @Puntuacion, @foto, @MinPorSesion, @PrecioSesion, '','','')
	insert into [dbo].[Ubicacion] (IdUbicacion, lat, long, Direccion, Correo)
	values ('0','','','',@Correo)
	Select @Mensaje = '¡Se registró con éxito!'
End try
Begin catch
	Select @Mensaje = 'Ha ocurrido un error el base de datos. ERROR: ' + ERROR_MESSAGE()
End catch

GO
/****** Object:  StoredProcedure [dbo].[SP_RegistrarUsuario]    Script Date: 16/07/2017 8:29:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_RegistrarUsuario]
@Nombre nvarchar(50),
@Apellidos nvarchar(50),
@Email nvarchar(50),
@Telefono nvarchar(50),
@Pais nvarchar(50),
@foto nvarchar(200),
@Contrasenia nvarchar(MAX),
@fechaNac date,
@Mensaje nvarchar(50) output
as
Begin try
	Insert into [dbo].[Cliente] (Nombre, Apellidos, Email, NumTelef, fechaNac, Pais, foto, Contrasenia)
	values ( @Nombre, @Apellidos, @Email, @Telefono, CONVERT(nvarchar(20),@fechaNac, 103), @Pais, @foto, ENCRYPTBYPASSPHRASE('password', @Contrasenia))
	Select @Mensaje = '¡Se registró con éxito!'
End try
Begin catch
	Select @Mensaje = 'Ha ocurrido un error el base de datos. ERROR: ' + ERROR_MESSAGE()
End catch

	

	


GO
/****** Object:  Table [dbo].[Abogados]    Script Date: 16/07/2017 8:29:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Abogados](
	[Nombre] [nvarchar](50) NOT NULL,
	[Apellido] [nvarchar](50) NOT NULL,
	[FechaNac] [date] NOT NULL,
	[Correo] [nvarchar](50) NOT NULL,
	[Contrasenia] [nvarchar](max) NOT NULL,
	[Telefono] [nvarchar](50) NULL,
	[Pais] [nvarchar](50) NULL,
	[Puntuacion] [decimal](18, 0) NULL,
	[foto] [nvarchar](200) NULL,
	[MinPorSesion] [int] NULL,
	[PrecioSesion] [money] NULL,
	[Resumen] [nvarchar](max) NULL,
	[Capacitaciones] [nvarchar](max) NULL,
	[InfoAdicional] [nvarchar](max) NULL,
	[IdEspecialidad] [smallint] NULL,
 CONSTRAINT [PK_Abogados] PRIMARY KEY CLUSTERED 
(
	[Correo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Cliente]    Script Date: 16/07/2017 8:29:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cliente](
	[Nombre] [nvarchar](50) NOT NULL,
	[Apellidos] [nvarchar](50) NOT NULL,
	[fechaNac] [date] NOT NULL,
	[Email] [nvarchar](50) NOT NULL,
	[Contrasenia] [nvarchar](max) NOT NULL,
	[NumTelef] [nvarchar](50) NOT NULL,
	[Pais] [nvarchar](50) NOT NULL,
	[foto] [nvarchar](200) NULL,
 CONSTRAINT [PK_Cliente] PRIMARY KEY CLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Comentarios]    Script Date: 16/07/2017 8:29:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Comentarios](
	[IdComentario] [int] IDENTITY(1,1) NOT NULL,
	[Detalle] [nvarchar](200) NULL,
	[Fecha] [date] NOT NULL,
	[Email] [nvarchar](50) NOT NULL,
	[Correo] [nvarchar](50) NOT NULL,
	[Puntuacion] [decimal](18, 0) NOT NULL,
 CONSTRAINT [PK_Comentarios] PRIMARY KEY CLUSTERED 
(
	[IdComentario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Especialidades]    Script Date: 16/07/2017 8:29:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Especialidades](
	[IdEspecialidad] [smallint] NOT NULL,
	[NomEspecialidad] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Especialidades] PRIMARY KEY CLUSTERED 
(
	[IdEspecialidad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[JuicioDeAlimentos]    Script Date: 16/07/2017 8:29:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JuicioDeAlimentos](
	[IdPreg] [int] IDENTITY(1,1) NOT NULL,
	[valorArray] [smallint] NOT NULL,
 CONSTRAINT [PK_JuicioDeAlimentos] PRIMARY KEY CLUSTERED 
(
	[IdPreg] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MedioPago]    Script Date: 16/07/2017 8:29:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MedioPago](
	[IdCuenta] [int] NOT NULL,
	[NumCuenta] [nvarchar](20) NOT NULL,
	[FechaExpiracion] [date] NOT NULL,
	[NumComprasOnline] [smallint] NOT NULL,
	[IdCliente] [int] NOT NULL,
 CONSTRAINT [PK_MedioPago] PRIMARY KEY CLUSTERED 
(
	[IdCuenta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RegForo]    Script Date: 16/07/2017 8:29:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RegForo](
	[IdForo] [int] NOT NULL,
	[FechaPreg] [date] NULL,
	[Email] [nvarchar](50) NULL,
 CONSTRAINT [PK_RegForo] PRIMARY KEY CLUSTERED 
(
	[IdForo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Ubicacion]    Script Date: 16/07/2017 8:29:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ubicacion](
	[IdUbicacion] [int] IDENTITY(1,1) NOT NULL,
	[lat] [float] NULL,
	[long] [float] NULL,
	[Direccion] [nvarchar](200) NULL,
	[Correo] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Ubicacion] PRIMARY KEY CLUSTERED 
(
	[IdUbicacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Abogados]  WITH CHECK ADD  CONSTRAINT [FK_Abogados_Especialidades] FOREIGN KEY([IdEspecialidad])
REFERENCES [dbo].[Especialidades] ([IdEspecialidad])
GO
ALTER TABLE [dbo].[Abogados] CHECK CONSTRAINT [FK_Abogados_Especialidades]
GO
ALTER TABLE [dbo].[Comentarios]  WITH CHECK ADD  CONSTRAINT [FK_Comentarios_Abogados] FOREIGN KEY([Correo])
REFERENCES [dbo].[Abogados] ([Correo])
GO
ALTER TABLE [dbo].[Comentarios] CHECK CONSTRAINT [FK_Comentarios_Abogados]
GO
ALTER TABLE [dbo].[Comentarios]  WITH CHECK ADD  CONSTRAINT [FK_Comentarios_Cliente] FOREIGN KEY([Email])
REFERENCES [dbo].[Cliente] ([Email])
GO
ALTER TABLE [dbo].[Comentarios] CHECK CONSTRAINT [FK_Comentarios_Cliente]
GO
ALTER TABLE [dbo].[Ubicacion]  WITH CHECK ADD  CONSTRAINT [FK_Ubicacion_Abogados] FOREIGN KEY([Correo])
REFERENCES [dbo].[Abogados] ([Correo])
GO
ALTER TABLE [dbo].[Ubicacion] CHECK CONSTRAINT [FK_Ubicacion_Abogados]
GO
USE [master]
GO
ALTER DATABASE [Abogados] SET  READ_WRITE 
GO

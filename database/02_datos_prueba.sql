/*
ProyectoWebCine - DATOS DE DEMOSTRACION (NO PRODUCCION)
Archivo 02_datos_prueba.sql. Ejecutar SOLO DESPUES de 01_schema.sql,
en una base confiteria NUEVA Y DESECHABLE de cada colaborador.
No configura logins de SQL Server (DB_USER/DB_PASSWORD): esos se crean
por separado en SSMS. Estas cuentas son para el LOGIN WEB de la app.

ANTES DE EJECUTAR:
  1. Verificar que sea una INSTANCIA DE PRUEBAS sin datos reales.
  2. Reemplazar las claves marcadas en @ClaveAdmin y @ClaveCajero.
  3. Cambiar @ConfirmarDatosPrueba a 1 SOLO en el equipo de pruebas.
  4. Ejecutar en SSMS y revisar Mensajes. No subir el archivo editado
     con claves reales al repositorio.
El script rechaza tablas Rol, Personal o Producto no vacias.
Se ejecuta en una transaccion; ante error se hace ROLLBACK.
*/
USE [confiteria];
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @ConfirmarDatosPrueba BIT = 0; -- CAMBIAR A 1 para autorizar explicitamente.
DECLARE @ClaveAdmin VARCHAR(255) = 'CAMBIAR_CLAVE_ADMIN';
DECLARE @ClaveCajero VARCHAR(255) = 'CAMBIAR_CLAVE_CAJERO';

IF @ConfirmarDatosPrueba <> 1
    THROW 51001, 'No autorizado. Ajustar @ConfirmarDatosPrueba a 1 solo en una base de pruebas.', 1;

IF DB_NAME() <> N'confiteria'
    THROW 51002, 'Base de datos incorrecta: se esperaba confiteria.', 1;

IF OBJECT_ID(N'dbo.Rol', N'U') IS NULL
   OR OBJECT_ID(N'dbo.Personal', N'U') IS NULL
   OR OBJECT_ID(N'dbo.Producto', N'U') IS NULL
    THROW 51003, 'Falta el esquema. Ejecutar primero 01_schema.sql en una base nueva.', 1;

IF EXISTS (SELECT 1 FROM dbo.Rol)
   OR EXISTS (SELECT 1 FROM dbo.Personal)
   OR EXISTS (SELECT 1 FROM dbo.Producto)
    THROW 51004, 'Las tablas contienen datos. NO mezclar este script con datos existentes.', 1;

IF @ClaveAdmin = 'CAMBIAR_CLAVE_ADMIN'
   OR @ClaveCajero = 'CAMBIAR_CLAVE_CAJERO'
   OR LEN(@ClaveAdmin) < 8
   OR LEN(@ClaveCajero) < 8
   OR @ClaveAdmin = @ClaveCajero
    THROW 51005, 'Definir dos claves de prueba distintas de al menos 8 caracteres antes de ejecutar.', 1;

BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO dbo.Rol (nombre_rol) VALUES ('Administrador');
    DECLARE @IdAdmin INT = CONVERT(INT, SCOPE_IDENTITY());

    INSERT INTO dbo.Rol (nombre_rol) VALUES ('Cajero');
    DECLARE @IdCajero INT = CONVERT(INT, SCOPE_IDENTITY());

    -- HASHBYTES SHA2_256 convertido a hexadecimal: mismo formato que
    -- la consulta de YGestorPersonal.validarLogin del proyecto actual.
    -- No apto para produccion: migrar a un algoritmo de contrasenas robusto.
    INSERT INTO dbo.Personal (nombre_completo, usuario, [password], id_rol, estado)
    VALUES ('Administrador Demo', 'demo_admin',
       CONVERT(VARCHAR(255), HASHBYTES('SHA2_256', CAST(@ClaveAdmin AS VARCHAR(255))), 2),
       @IdAdmin, 1);

    INSERT INTO dbo.Personal (nombre_completo, usuario, [password], id_rol, estado)
    VALUES ('Cajero Demo', 'demo_cajero',
       CONVERT(VARCHAR(255), HASHBYTES('SHA2_256', CAST(@ClaveCajero AS VARCHAR(255))), 2),
       @IdCajero, 1);

    INSERT INTO dbo.Producto (nombre, precio, stock, categoria, estado, imagen)
    VALUES
        ('Cancha salada demo', 12.50, 30, 'Snacks', 1, NULL),
        ('Gaseosa personal demo', 6.00, 40, 'Bebidas', 1, NULL),
        ('Agua sin gas demo', 4.00, 25, 'Bebidas', 1, NULL),
        ('Nachos demo', 10.00, 15, 'Snacks', 1, NULL),
        ('Chocolate demo', 5.50, 20, 'Dulces', 1, NULL);

    COMMIT TRANSACTION;
    PRINT 'Datos de demostracion insertados. NO usar estas cuentas para produccion.';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;

-- Verificacion sin mostrar los hashes de las contrasenas.
SELECT id_rol, nombre_rol FROM dbo.Rol ORDER BY id_rol;
SELECT p.usuario, p.nombre_completo, r.nombre_rol, p.estado
FROM dbo.Personal p INNER JOIN dbo.Rol r ON p.id_rol = r.id_rol
ORDER BY p.id_personal;
SELECT id_producto, nombre, precio, stock, categoria, estado
FROM dbo.Producto ORDER BY id_producto;

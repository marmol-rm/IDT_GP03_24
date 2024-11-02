-- Script de creacion de base de datos ACTIVO_FIJO_DW
-- Creado: 25/08/2024

/*CREATE DATABASE ACTIVO_FIJO_DW;
GO

USE ACTIVO_FIJO_DW;
GO*/

CREATE TABLE DIM_FECHA(
	FECHA_KEY INT PRIMARY KEY,
	FECHA_COMPLETA DATETIME NOT NULL,
	CUARTO SMALLINT NOT NULL DEFAULT(0),
	ANIO_FISCAL INT NOT NULL DEFAULT(0),
	ANIO_CALENDARIO INT NOT NULL DEFAULT(0),
	MES_CALENDARIO TINYINT NOT NULL DEFAULT(0),
	DIA_DEL_MES TINYINT NOT NULL DEFAULT(0),
	NOMBRE_DIA	VARCHAR(15) NOT NULL DEFAULT 'N/A',
	DIA_ABREV	VARCHAR(3) NOT NULL DEFAULT 'N/A'
);
GO

CREATE TABLE DIM_PRODUCTO(
	PRODUCTO_KEY BIGINT IDENTITY(1,1) PRIMARY KEY,
	PRODUCTO_ID BIGINT NOT NULL,
	NOMBRE_PRODUCTO VARCHAR(100) NOT NULL DEFAULT 'N/A',
	TIPO_PRODUCTO VARCHAR(50) NOT NULL DEFAULT 'N/A',
	ESTADO_PRODUCTO VARCHAR(50) NOT NULL DEFAULT 'N/A',
	TIPO_DE_MONEDA VARCHAR(15) NOT NULL DEFAULT 'N/A',
	METODO_DEPRECIACION VARCHAR(50) NOT NULL DEFAULT 'N/A',
	TASA_DEPRECIACION DECIMAL(25,5) NOT NULL DEFAULT (0),
	VALOR_ANTERIOR DECIMAL(25,2) NOT NULL DEFAULT(0),
	VALOR_ACTUAL 	DECIMAL(25,2) NOT NULL DEFAULT(0),
	VALOR_DEPRECIADO DECIMAL(25,2) NOT NULL DEFAULT(0),
	FECHA_CREACION DATETIME NOT NULL DEFAULT GETDATE(),
	FECHA_ACTUALIZACION DATETIME NOT NULL DEFAULT GETDATE()
);
GO

CREATE TABLE DIM_VENDEDOR(
	VENDEDOR_KEY BIGINT IDENTITY(1,1) PRIMARY KEY,
	VENDEDOR_ID BIGINT NOT NULL,
	NOMBRE_VENDEDOR VARCHAR(100) NOT NULL DEFAULT 'N/A',
	RANGO INT NOT NULL DEFAULT(0),
	SITIO_WEB VARCHAR(100) NOT NULL DEFAULT 'N/A',
	EMAIL VARCHAR(100) NOT NULL DEFAULT 'N/A',
	TELEFONO VARCHAR(30) NOT NULL DEFAULT 'N/A',
	UBICACION VARCHAR(100) NOT NULL DEFAULT 'N/A',
	CODIGO_POSTAL VARCHAR(15) NOT NULL DEFAULT 'N/A',
	CODIGO_PAIS VARCHAR(5) NOT NULL DEFAULT 'N/A',
	PROVINCIA VARCHAR(100) NOT NULL DEFAULT 'N/A',
	CIUDAD VARCHAR(100) NOT NULL DEFAULT 'N/A',
	DIRECCION VARCHAR(255) NOT NULL DEFAULT 'N/A'
);
GO

CREATE TABLE FACT_ACTIVO_FIJO(
	FACT_TABLE_KEY BIGINT IDENTITY(1,1) PRIMARY KEY,
	FECHA_KEY INT NOT NULL FOREIGN KEY REFERENCES DIM_FECHA(FECHA_KEY),
	PRODUCTO_KEY BIGINT NOT NULL FOREIGN KEY REFERENCES DIM_PRODUCTO(PRODUCTO_KEY),
	VENDEDOR_KEY BIGINT NOT NULL FOREIGN KEY REFERENCES DIM_VENDEDOR(VENDEDOR_KEY),
	VALOR_DE_COMPRA DECIMAL(25,2) NOT NULL DEFAULT(0),
	VALOR_RECUPERADO DECIMAL(25,2) NOT NULL DEFAULT(0),
	MES_DE_COMPRA INT NOT NULL,
	ANIO_DE_COMPRA INT NOT NULL
);
GO

CREATE TABLE DW_PARAMETROS(
	PARAM_ID INT IDENTITY(1,1) PRIMARY KEY,
	NOMBRE_PARAM VARCHAR(50) NOT NULL,
	VALOR_PARAM VARCHAR(MAX) NOT NULL
);
GO



-- PROCEDIMIENTOS ALMACENADOS

CREATE PROCEDURE ACTUALIZAR_PRODUCTO(
	@PRODUCTO_ID bigint,
	@NOMBRE_PRODUCTO varchar(100),
	@TIPO_PRODUCTO varchar(50),
	@ESTADO_PRODUCTO varchar(50),
	@TIPO_DE_MONEDA varchar(15), 
	@METODO_DEPRECIACION varchar(50),
	@TASA_DEPRECIACION decimal(13,5),
	@VALOR_DEPRECIADO decimal(13,2),
	@VALOR_ANTERIOR decimal(13,2),
	@VALOR_ACTUAL decimal(13,2)
) AS

BEGIN
	UPDATE DIM_PRODUCTO SET 
	NOMBRE_PRODUCTO=@NOMBRE_PRODUCTO, 
	TIPO_PRODUCTO=@TIPO_PRODUCTO, 
	ESTADO_PRODUCTO=@ESTADO_PRODUCTO, 
	TIPO_DE_MONEDA=@TIPO_DE_MONEDA, 
	METODO_DEPRECIACION=@METODO_DEPRECIACION, 
	TASA_DEPRECIACION=@TASA_DEPRECIACION, 
	VALOR_DEPRECIADO=@VALOR_DEPRECIADO, 
	VALOR_ANTERIOR=@VALOR_ANTERIOR, 
	VALOR_ACTUAL=@VALOR_ACTUAL, 
	FECHA_ACTUALIZACION=getdate() 
	WHERE PRODUCTO_ID=@PRODUCTO_ID;
END;

CREATE PROCEDURE ACTUALIZAR_VENDEDOR(
	@VENDEDOR_ID bigint,
	@NOMBRE varchar(100),
	@RANGO int,
	@SITIO_WEB varchar(100),
	@EMAIL varchar(100),
	@TELEFONO varchar(30),
	@UBICACION varchar(100), 
	@ZIPCODE varchar(15),
	@COD_PAIS varchar(5),
	@PROVINCIA varchar(100),
	@CITY varchar(100),
	@STREET varchar(255)
) AS

BEGIN
	UPDATE DIM_VENDEDOR SET 
	NOMBRE_VENDEDOR=@NOMBRE, 
	RANGO=@RANGO, 
	SITIO_WEB=@SITIO_WEB, 
	EMAIL=@EMAIL, 
	TELEFONO=@TELEFONO, 
	UBICACION=@UBICACION, 
	CODIGO_POSTAL=@ZIPCODE,
	CODIGO_PAIS = @COD_PAIS,
	PROVINCIA=@PROVINCIA,
	CIUDAD=@CITY,
	DIRECCION=@STREET  
	WHERE VENDEDOR_ID=@VENDEDOR_ID;
END;
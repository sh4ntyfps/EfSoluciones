CREATE DATABASE TiendaRopa;
GO

USE TiendaRopa;
GO

CREATE TABLE Categoria (
    IdCategoria INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100)
);

CREATE TABLE Talla (
    IdTalla INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(50)
);

CREATE TABLE Genero (
    IdGenero INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(50)
);

CREATE TABLE Producto (
    IdProducto INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100),
    Descripcion VARCHAR(255),
    Precio DECIMAL(10,2),
    Stock INT,
    IdCategoria INT FOREIGN KEY REFERENCES Categoria(IdCategoria),
    IdTalla INT FOREIGN KEY REFERENCES Talla(IdTalla),
    IdGenero INT FOREIGN KEY REFERENCES Genero(IdGenero),
    ImagenUrl VARCHAR(500)
);

CREATE TABLE Cliente (
    IdCliente INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100),
    Apellido VARCHAR(100),
    Correo VARCHAR(100),
    Telefono VARCHAR(20)
);

CREATE TABLE Usuario (
    IdUsuario INT PRIMARY KEY IDENTITY(1,1),
    Usuario VARCHAR(50),
    Clave VARCHAR(100),
    Rol VARCHAR(50) -- 'Admin' o 'Cliente'
);

CREATE TABLE Venta (
    IdVenta INT PRIMARY KEY IDENTITY(1,1),
    IdCliente INT FOREIGN KEY REFERENCES Cliente(IdCliente),
    Fecha DATETIME DEFAULT GETDATE(),
    Total DECIMAL(10,2)
);

CREATE TABLE DetalleVenta (
    IdDetalle INT PRIMARY KEY IDENTITY(1,1),
    IdVenta INT FOREIGN KEY REFERENCES Venta(IdVenta),
    IdProducto INT FOREIGN KEY REFERENCES Producto(IdProducto),
    Cantidad INT,
    PrecioUnitario DECIMAL(10,2),
    Subtotal DECIMAL(10,2)
);

CREATE TABLE Log (
    IdLog INT PRIMARY KEY IDENTITY(1,1),
    IdUsuario INT FOREIGN KEY REFERENCES Usuario(IdUsuario),
    FechaIngreso DATETIME DEFAULT GETDATE(),
    IP VARCHAR(50)
);

CREATE TABLE Promocion (
    IdPromocion INT PRIMARY KEY IDENTITY(1,1),
    Titulo VARCHAR(100),
    Descripcion TEXT,
    Descuento DECIMAL(5,2),
    FechaInicio DATE,
    FechaFin DATE
);

-- =====================
-- PROCEDIMIENTOS ALMACENADOS
-- =====================
-- PRODUCTO
CREATE PROCEDURE sp_ListarProductos
AS
BEGIN
    SELECT * FROM Producto;
END
GO

CREATE PROCEDURE sp_InsertarProducto
    @Nombre VARCHAR(100),
    @Descripcion VARCHAR(255),
    @Precio DECIMAL(10,2),
    @Stock INT,
    @IdCategoria INT,
    @IdTalla INT,
    @IdGenero INT,
    @ImagenUrl VARCHAR(500)
AS
BEGIN
    INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
    VALUES (@Nombre, @Descripcion, @Precio, @Stock, @IdCategoria, @IdTalla, @IdGenero, @ImagenUrl);
END
GO

CREATE PROCEDURE sp_AgregarProducto
    @Nombre VARCHAR(100),
    @Descripcion VARCHAR(200),
    @Precio DECIMAL(10, 2),
    @Stock INT,
    @ImagenUrl VARCHAR(500),
    @IdCategoria INT,
    @IdGenero INT,
    @IdTalla INT
AS
BEGIN
    INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, ImagenUrl, IdCategoria, IdGenero, IdTalla)
    VALUES (@Nombre, @Descripcion, @Precio, @Stock, @ImagenUrl, @IdCategoria, @IdGenero, @IdTalla)
END
GO

CREATE PROCEDURE sp_EditarProducto
    @IdProducto INT,
    @Nombre VARCHAR(100),
    @Descripcion VARCHAR(200),
    @Precio DECIMAL(10, 2),
    @Stock INT,
    @ImagenUrl VARCHAR(500),
    @IdCategoria INT,
    @IdGenero INT,
    @IdTalla INT
AS
BEGIN
    UPDATE Producto
    SET Nombre = @Nombre,
        Descripcion = @Descripcion,
        Precio = @Precio,
        Stock = @Stock,
        ImagenUrl = @ImagenUrl,
        IdCategoria = @IdCategoria,
        IdGenero = @IdGenero,
        IdTalla = @IdTalla
    WHERE IdProducto = @IdProducto
END
GO

CREATE PROCEDURE sp_ActualizarProducto
    @IdProducto INT,
    @Nombre VARCHAR(100),
    @Descripcion VARCHAR(255),
    @Precio DECIMAL(10,2),
    @Stock INT,
    @IdCategoria INT,
    @IdTalla INT,
    @IdGenero INT,
    @ImagenUrl VARCHAR(500)
AS
BEGIN
    UPDATE Producto
    SET Nombre = @Nombre,
        Descripcion = @Descripcion,
        Precio = @Precio,
        Stock = @Stock,
        IdCategoria = @IdCategoria,
        IdTalla = @IdTalla,
        IdGenero = @IdGenero,
        ImagenUrl = @ImagenUrl
    WHERE IdProducto = @IdProducto;
END
GO

CREATE PROCEDURE sp_EliminarProducto
    @IdProducto INT
AS
BEGIN
    DELETE FROM Producto WHERE IdProducto = @IdProducto;
END
GO

CREATE PROCEDURE sp_ObtenerProductoPorId
    @IdProducto INT
AS
BEGIN
    SELECT * FROM Producto WHERE IdProducto = @IdProducto
END
GO

-- CLIENTE
CREATE PROCEDURE sp_ListarClientes
AS
BEGIN
    SELECT * FROM Cliente;
END
GO

CREATE PROCEDURE sp_ObtenerClientePorId
    @IdCliente INT
AS
BEGIN
    SELECT * FROM Cliente WHERE IdCliente = @IdCliente
END
GO

CREATE PROCEDURE sp_InsertarCliente
    @Nombre VARCHAR(100),
    @Apellido VARCHAR(100),
    @Correo VARCHAR(100),
    @Telefono VARCHAR(15)
AS
BEGIN
    INSERT INTO Cliente (Nombre, Apellido, Correo, Telefono)
    VALUES (@Nombre, @Apellido, @Correo, @Telefono)
END
GO

CREATE PROCEDURE sp_ActualizarCliente
    @IdCliente INT,
    @Nombre VARCHAR(100),
    @Apellido VARCHAR(100),
    @Correo VARCHAR(100),
    @Telefono VARCHAR(15)
AS
BEGIN
    UPDATE Cliente
    SET Nombre = @Nombre,
        Apellido = @Apellido,
        Correo = @Correo,
        Telefono = @Telefono
    WHERE IdCliente = @IdCliente
END
GO

CREATE PROCEDURE sp_EliminarCliente
    @IdCliente INT
AS
BEGIN
    DELETE FROM Cliente WHERE IdCliente = @IdCliente
END
GO

-- VENTA
CREATE PROCEDURE sp_InsertarVenta
    @IdCliente INT,
    @Total DECIMAL(10,2),
    @IdVenta INT OUTPUT
AS
BEGIN
    INSERT INTO Venta (IdCliente, Total)
    VALUES (@IdCliente, @Total);

    SET @IdVenta = SCOPE_IDENTITY();
END
GO

CREATE PROCEDURE sp_InsertarDetalleVenta
    @IdVenta INT,
    @IdProducto INT,
    @Cantidad INT,
    @PrecioUnitario DECIMAL(10,2),
    @Subtotal DECIMAL(10,2)
AS
BEGIN
    INSERT INTO DetalleVenta (IdVenta, IdProducto, Cantidad, PrecioUnitario, Subtotal)
    VALUES (@IdVenta, @IdProducto, @Cantidad, @PrecioUnitario, @Subtotal);
END
GO

----
CREATE OR ALTER PROCEDURE sp_ResumenDashboard
AS
BEGIN
    SELECT 
        (SELECT COUNT(*) FROM Venta) AS TotalVentas,
        (SELECT COUNT(*) FROM Cliente) AS TotalClientes,
        (SELECT COUNT(*) FROM Producto) AS TotalProductos,
        (SELECT ISNULL(SUM(Total), 0) FROM Venta) AS MontoTotal
END


---

--- INSERT

INSERT INTO Categoria (Nombre) VALUES 
('Polos'), ('Camisas'), ('Pantalones'), ('Casacas'), ('Vestidos');

INSERT INTO Talla (Nombre) VALUES 
('S'), ('M'), ('L'), ('XL');

INSERT INTO Genero (Nombre) VALUES 
('Hombre'), ('Mujer');

INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Camisas Mujer XL 1', 'Camisas para mujer talla XL - Modelo 1', 86.00, 58, 2, 4, 2, 'https://hmperu.vtexassets.com/arquivos/ids/5616387/Camisa-de-algodon---Celeste-Rayas---H-M-PE.jpg?v=638852434163830000');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Pantalones Mujer S 2', 'Pantalones para mujer talla S - Modelo 2', 80.00, 44, 3, 1, 2, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRdh4ZU39HgBCtngOznjmOK_dGYwchiOVSDtg&s');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Camisas Mujer XL 3', 'Camisas para mujer talla XL - Modelo 3', 145.80, 62, 2, 4, 2, 'https://oechsle.vteximg.com.br/arquivos/ids/17116595-1000-1000/imageUrl_1.jpg?v=638395255488700000');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Camisas Mujer M 4', 'Camisas para mujer talla M - Modelo 4', 129.20, 32, 2, 2, 2, 'https://www.vittorio.es/media/catalog/product/cache/5236830c9333173f840bb174da726433/b/l/blusa_negra_elegante_mujer_cuello_mao_manga_larga.jpg');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Pantalones Hombre L 5', 'Pantalones para hombre talla L - Modelo 5', 70.80, 12, 3, 3, 1, 'https://images-cdn.ubuy.co.in/668c9e184d94443004548af9-dasayo-fashion-y2k-pants-for-men-s-solid.jpg');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Camisa Hombre S 6', 'Camisa para hombre talla S - Modelo 6', 46.20, 92, 5, 1, 1, 'https://supermallpe.vtexassets.com/arquivos/ids/827519-800-auto?v=638592075973370000&width=800&height=auto&aspect=true');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Casacas Hombre M 7', 'Casacas para hombre talla M - Modelo 7', 98.80, 84, 4, 2, 1, 'https://img.pacifiko.com/PROD/resize/1/500x500/MmJjNTY5Zj.jpg');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Pantalones Hombre XL 8', 'Pantalones para hombre talla XL - Modelo 8', 130.70, 47, 3, 4, 1, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSUKzEwZ-CfWJiuEi9E0D_jJK8m8WNXbH3wqg&s');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Pantalones Mujer XL 9', 'Pantalones para mujer talla XL - Modelo 9', 146.50, 99, 3, 4, 2, 'https://hmperu.vtexassets.com/arquivos/ids/5615196/Pantalon-de-vestir-de-talle-alto---Negro---H-M-PE.jpg?v=638852425120530000');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Casaca Hombre L 10', 'Casaca para hombre talla L - Modelo 10', 144.00, 31, 5, 3, 1, 'https://patagoniape.vtexassets.com/arquivos/ids/184272/https---d30z73rtw6f6d9.cloudfront.net-PATAGONIA-84675_C01_1.jpg?v=638634208166800000');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Casaca Hombre L 11', 'Casaca para hombre talla L - Modelo 11', 97.00, 97, 3, 3, 1, 'https://www.catlifestyle.pe/media/catalog/product/c/a/casacas-hombre-caterpillar-heavyweight-insulated-hooded-work-4040113-11768_1_otenbtuup0tsm7zq.jpg?optimize=medium&bg-color=255,255,255&fit=bounds&height=550&width=550&canvas=550:550');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Casaca Mujer L 12', 'Casaca para mujer talla L - Modelo 12', 85.00, 95, 3, 3, 2, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTRVYmCi7oV-l8xXm5zUMpi-7PSFDqED3LeWw&s');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Casaca Mujer XL 13', 'Casaca para mujer talla XL - Modelo 13', 112.00, 12, 2, 4, 1, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSlFoH5EcX3awYgLx1jxxH7dSJf8skrYLWI0Q&s');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Camisa Hombre M 14', 'Camisa para hombre talla M - Modelo 14', 125.00, 25, 5, 2, 1, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTU1jXuLKzRSzFBPXBrlg4AwNV3RCo8tIAA4w&s');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Vestidos Mujer L 15', 'Vestidos para mujer talla L - Modelo 15', 65.00, 11, 5, 3, 2, 'https://i5.walmartimages.com/asr/4e1232ad-28c4-48bc-9100-38b59af2f3a7.2e7455c323b65145bbb015c82ab85542.jpeg?odnHeight=612&odnWidth=612&odnBg=FFFFFF');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Polos Hombre S 16', 'Polos para hombre talla S - Modelo 16', 61.90, 37, 1, 1, 1, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRUkMLG-OEDVcriV9DjA6-a_Cv7P4WO6L09Bw&s');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Casacas Mujer L 17', 'Casacas para mujer talla L - Modelo 17', 145.00, 97, 4, 3, 2, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQCnFYS060yxSg3h5yowUc10WzIAVNjbFUIxA&s');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Casacas Hombre S 18', 'Casacas para hombre talla S - Modelo 18', 123.00, 40, 4, 1, 1, 'https://yansus.com/cdn/shop/files/polerahombreyansusmelangeconCremalleracolorentero1.png?v=1691706974');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Pantalones Hombre L 19', 'Pantalones para hombre talla L - Modelo 19', 100.00, 92, 3, 3, 1, 'https://m.media-amazon.com/images/I/619x-YQEJLL.jpg');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Pantalones Mujer M 20', 'Pantalones para mujer talla M - Modelo 20', 121.00, 67, 3, 2, 2, 'https://pieers.com/media/catalog/product/cache/1f196d9bd42af3448cca86c23fe7b55a/p/s/psx0b260pp9_1.jpg');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Casacas Hombre XL 21', 'Casacas para hombre talla XL - Modelo 21', 101.00, 54, 4, 4, 1, 'https://m.media-amazon.com/images/I/71OFTTSzK1L._AC_SL1500_.jpg');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Camisas Hombre L 22', 'Camisas para hombre talla L - Modelo 22', 43.17, 47, 2, 3, 1, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpNOi_sUDQtIIWP-bxxbZpVIEkzn6-AzctYA&s');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Pantalones Mujer S 23', 'Pantalones para mujer talla S - Modelo 23', 91.00, 37, 3, 1, 2, 'https://rockfordpe.vtexassets.com/arquivos/ids/295030-800-auto?v=638283339192000000&width=800&height=auto&aspect=true');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Polos Mujer L 24', 'Polos para mujer talla L - Modelo 24', 98.00, 90, 1, 3, 2, 'https://m.media-amazon.com/images/I/718homttdDL._AC_SL1500_.jpg');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Casacas Hombre S 25', 'Casacas para hombre talla S - Modelo 25', 120.00, 18, 4, 1, 1, 'https://thn.pe/cdn/shop/files/IZ4803_1.jpg?v=1723588635');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Camisas Hombre S 26', 'Camisas para hombre talla S - Modelo 26', 103.00, 13, 2, 1, 1, 'https://i5.walmartimages.com/asr/285ef40b-b736-4b4b-8742-05ffa3cc4524.26f0a64f1ae6094aa2d13bab6846bf10.jpeg?odnHeight=612&odnWidth=612&odnBg=FFFFFF');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Vestidos Mujer S 27', 'Vestidos para mujer talla S - Modelo 27', 116.00, 15, 5, 1, 2, 'https://m.media-amazon.com/images/I/51NqlUcBJcL._AC_UL1024_.jpg');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Pantalones Mujer XL 28', 'Pantalones para mujer talla XL - Modelo 28', 138.00, 14, 3, 4, 2, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSvNibohCFoKOqWazsM2GEJZx2zBccxyoS5HA&s');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Casacas Hombre M 29', 'Casacas para hombre talla M - Modelo 29', 146.00, 65, 4, 2, 1, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRtt_wsUCbqNN8isxOfSjLBBkq_KsOj49AXlQ&s');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Vestidos Mujer M 30', 'Vestidos para mujer talla M - Modelo 30', 87.00, 52, 5, 2, 2, 'https://m.media-amazon.com/images/I/71ETMn4MPML._AC_SL1500_.jpg');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Vestidos Mujer S 31', 'Vestidos para Mujer talla S - Modelo 31', 55.00, 46, 5, 1, 1, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTuG2NenHddqrfSGJJNiVvFIEUuqh7jwXulyw&s');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Polos Hombre M 32', 'Polos para hombre talla M - Modelo 32', 84.00, 18, 1, 2, 1, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQq_bYjxmUlzZbKid1-w9ivIDYU5BTSZW1ejQ&s');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Polos Hombre XL 33', 'Polos para hombre talla XL - Modelo 33', 131.00, 72, 1, 4, 1, 'https://i.ebayimg.com/images/g/Cr0AAOSwP-5iOS3J/s-l400.jpg');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Casacas Hombre L 34', 'Casacas para hombre talla L - Modelo 34', 88.00, 68, 4, 3, 1, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTIHs9nrPzO3rLrFnz6TIa-BlkPWNubKqZ9eg&s');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Vestidos Mujer M 35', 'Vestidos para Mujer talla M - Modelo 35', 122.20, 82, 5, 2, 1, 'https://www.sevenseven.com/dw/image/v2/BHFM_PRD/on/demandware.static/-/Sites-storefront_catalog_sevenseven/default/dwc6590c87/images/hi-res/SevenSeven/Vestidos-de-moda-28171411-73013_1.jpg?sw=600&sh=720');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Polos Mujer S 36', 'Polos para mujer talla S - Modelo 36', 148.30, 37, 1, 1, 2, 'https://sydney.pe/wp-content/uploads/2024/11/polo-flame-1.jpg');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Vestidos Mujer XL 37', 'Vestidos para mujer talla XL - Modelo 37', 124.00, 44, 5, 4, 2, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS7f754D1vHRy8WWVQ-o65TmE19ZtYyEcDoZQ&s');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Casacas Mujer XL 38', 'Casacas para mujer talla XL - Modelo 38', 123.20, 85, 4, 4, 2, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSGQk-EhWS3Xhct2MnsClzc-b2kx7lc7GPm7g&s');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Casacas Hombre M 39', 'Casacas para hombre talla M - Modelo 39', 43.80, 87, 4, 2, 1, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT1LEezFGb-9EGwO-mPlF5G2xKcSrz9rQqLnw&s');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Camisas Mujer M 40', 'Camisas para mujer talla M - Modelo 40', 46.00, 66, 2, 2, 2, 'https://shop.mango.com/assets/rcs/pics/static/T6/fotos/S/67085722_88_B.jpg?imwidth=2048&imdensity=1&ts=1702285395203');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Vestidos Mujer XL 41', 'Vestidos para mujer talla XL - Modelo 41', 143.80, 57, 5, 4, 2, 'https://assets.christiandior.com/is/image/diorprod/441L96A6759X0859_E01?$r2x3_default_s85$&crop=707,148,587,1572&wid=1334&hei=2000&scale=0.85&bfc=on&qlt=85');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Camisas Mujer L 42', 'Camisas para mujer talla L - Modelo 42', 78.60, 98, 2, 3, 2, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxGkdF_E8UeRw3FNHXWOrtxqKniDCeQ1uzIw&s');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Pantalones Hombre M 43', 'Pantalones para hombre talla M - Modelo 43', 126.50, 69, 3, 2, 1, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQa7EVRWQiGGGFcGTDZsCVYN9VcQcF3gVcL4g&s');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Casacas Mujer L 44', 'Casacas para mujer talla L - Modelo 44', 83.20, 63, 4, 3, 2, 'https://oechsle.vteximg.com.br/arquivos/ids/18129359-1000-1000/imageUrl_3.jpg?v=638533225748870000');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Polos Mujer XL 45', 'Polos para mujer talla XL - Modelo 45', 145.00, 48, 1, 4, 2, 'https://mercury.vtexassets.com/arquivos/ids/17990163/image-2b3a387f59214510a023a46c6df901e9.jpg?v=638564124665800000');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Pantalones Hombre S 46', 'Pantalones para hombre talla S - Modelo 46', 99.60, 90, 3, 1, 1, 'https://plazavea.vteximg.com.br/arquivos/ids/27627678-418-418/20352039-1.jpg');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Pantalones Hombre S 47', 'Pantalones para hombre talla S - Modelo 47', 112.20, 74, 3, 1, 1, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR55ZXrm3Nw7aooCFhr-JvsKhniBwXdoTBf4g&s');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Vestidos Mujer S 48', 'Vestidos para mujer talla S - Modelo 48', 139.20, 86, 5, 1, 2, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQD_plQZ2BlCAAg02CqGZ12Vfpwmh2i17L9QA&s');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Camisas Mujer M 49', 'Camisas para mujer talla M - Modelo 49', 90.50, 97, 2, 2, 2, 'https://oechsle.vteximg.com.br/arquivos/ids/20849187-800-800/2752159.jpg?v=638790870935630000');
INSERT INTO Producto (Nombre, Descripcion, Precio, Stock, IdCategoria, IdTalla, IdGenero, ImagenUrl)
VALUES ('Camisas Hombre S 50', 'Camisas para hombre talla S - Modelo 50', 92.20, 91, 2, 1, 1, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQlY4nXK8UhFOLsI1wz32TIT8jloROM0ffXxQ&s');

EXEC sp_ListarProductos;

SELECT * FROM Genero
use TiendaRopa
select * from Cliente

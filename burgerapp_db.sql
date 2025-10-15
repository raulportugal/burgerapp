-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 16-10-2025 a las 01:11:59
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `burgerapp_db`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `CambiarDisponibilidadProducto` (IN `producto_id` BIGINT, IN `nuevo_estado` BOOLEAN)   BEGIN
    UPDATE productos 
    SET disponible = nuevo_estado 
    WHERE id = producto_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtenerProductosPorCategoria` (IN `categoria_producto` VARCHAR(50))   BEGIN
    SELECT * FROM productos 
    WHERE categoria = categoria_producto 
    AND disponible = TRUE 
    ORDER BY nombre;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auditoria_productos`
--

CREATE TABLE `auditoria_productos` (
  `id` bigint(20) NOT NULL,
  `producto_id` bigint(20) NOT NULL,
  `accion` enum('INSERT','UPDATE','DELETE') DEFAULT NULL,
  `precio_anterior` decimal(10,2) DEFAULT NULL,
  `precio_nuevo` decimal(10,2) DEFAULT NULL,
  `disponible_anterior` tinyint(1) DEFAULT NULL,
  `disponible_nuevo` tinyint(1) DEFAULT NULL,
  `fecha_cambio` timestamp NOT NULL DEFAULT current_timestamp(),
  `usuario` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `auditoria_productos`
--

INSERT INTO `auditoria_productos` (`id`, `producto_id`, `accion`, `precio_anterior`, `precio_nuevo`, `disponible_anterior`, `disponible_nuevo`, `fecha_cambio`, `usuario`) VALUES
(1, 1, 'UPDATE', 8.99, 8.99, 1, 100, '2025-10-15 17:58:02', 'root@localhost');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_pedidos`
--

CREATE TABLE `detalle_pedidos` (
  `id` bigint(20) NOT NULL,
  `pedido_id` bigint(20) NOT NULL,
  `producto_id` bigint(20) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedidos`
--

CREATE TABLE `pedidos` (
  `id` bigint(20) NOT NULL,
  `cliente_nombre` varchar(100) NOT NULL,
  `cliente_telefono` varchar(15) NOT NULL,
  `cliente_direccion` text NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `estado` enum('pendiente','confirmado','preparando','en_camino','entregado') DEFAULT 'pendiente',
  `notas` text DEFAULT NULL,
  `fecha_pedido` timestamp NOT NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id` bigint(20) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `categoria` varchar(50) NOT NULL,
  `imagen_url` varchar(255) DEFAULT NULL,
  `disponible` tinyint(1) DEFAULT 1,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id`, `nombre`, `descripcion`, `precio`, `categoria`, `imagen_url`, `disponible`, `fecha_creacion`, `fecha_actualizacion`) VALUES
(1, 'Hamburguesa Clásica', 'Carne de res 150g, lechuga fresca, tomate, cebolla morada y nuestra salsa especial de la casa. Pan brioche tostado.', 8.99, 'Hamburguesa', 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&h=300&fit=crop', 100, '2025-10-15 16:57:23', '2025-10-15 17:58:02'),
(2, 'Hamburguesa BBQ', 'Doble carne de res 180g, bacon crujiente, aros de cebolla, queso cheddar y salsa barbacoa casera. Pan de ajonjolí.', 12.99, 'Hamburguesa', 'https://images.unsplash.com/photo-1572802419224-296b0aeee0d9?w=400&h=300&fit=crop', 1, '2025-10-15 16:57:23', '2025-10-15 16:57:23'),
(3, 'Hamburguesa Vegetariana', 'Medallón de garbanzos y espinacas, aguacate fresco, rúcula, tomate seco y mayonesa de albahaca. Pan integral.', 9.49, 'Hamburguesa', 'https://images.unsplash.com/photo-1596662951482-0c4ba74a6df6?w=400&h=300&fit=crop', 1, '2025-10-15 16:57:23', '2025-10-15 16:57:23'),
(4, 'Hamburguesa Picante', 'Carne de res 200g, jalapeños frescos, queso pepper jack, cebolla caramelizada y salsa picante especial. Pan artesanal.', 11.99, 'Hamburguesa', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSCxpLCg2EHWATh6tDNSvITeQuY6mGGUCBE6A&s', 1, '2025-10-15 16:57:23', '2025-10-15 21:09:07'),
(5, 'Hamburguesa Pollo Crispy', 'Pechuga de pollo empanizada, lechuga, tomate, mayonesa de ajo y pepinillos. Pan brioche.', 10.99, 'Hamburguesa', 'https://images.unsplash.com/photo-1526234362653-3b75a0c07438?w=400&h=300&fit=crop', 1, '2025-10-15 16:57:23', '2025-10-15 16:57:23'),
(6, 'Hamburguesa Doble Queso', 'Doble carne de res, doble queso cheddar, cebolla, pepinillos y salsa burger. Pan clásico.', 13.49, 'Hamburguesa', 'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?w=400&h=300&fit=crop', 1, '2025-10-15 16:57:23', '2025-10-15 16:57:23'),
(7, 'Coca-Cola Regular', 'Refresco de cola 500ml, refrescante y burbujeante.', 2.50, 'Bebida', 'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?w=400&h=300&fit=crop', 1, '2025-10-15 16:57:23', '2025-10-15 16:57:23'),
(8, 'Coca-Cola Light', 'Refresco de cola sin azúcar 500ml.', 2.50, 'Bebida', 'https://assets.supermercadosmas.com/img/615x615/product/image/262047/262047.jpg?v2', 1, '2025-10-15 16:57:23', '2025-10-15 21:10:17'),
(9, 'Agua Mineral', 'Agua mineral natural 500ml, perfecta para acompañar tu comida.', 1.50, 'Bebida', 'https://www.farmadon.com.ve/wp-content/uploads/2025/07/Evian-Agua-Mineral-Natural-500Ml.png', 1, '2025-10-15 16:57:23', '2025-10-15 21:11:22'),
(10, 'Jugo de Naranja', 'Jugo de naranja natural recién exprimido 400ml.', 3.50, 'Bebida', 'https://images.unsplash.com/photo-1613478223719-2ab802602423?w=400&h=300&fit=crop', 1, '2025-10-15 16:57:23', '2025-10-15 16:57:23'),
(11, 'Limonada Natural', 'Limonada fresca con hierbabuena 500ml.', 3.00, 'Bebida', 'https://donmelchorpollos.com/wp-content/uploads/2023/06/hierbabuena-07-25.jpg', 1, '2025-10-15 16:57:23', '2025-10-15 21:12:25'),
(12, 'Cerveza Artesanal', 'Cerveza rubia artesanal 355ml, sabor suave y refrescante.', 5.50, 'Bebida', 'https://images.unsplash.com/photo-1535958636474-b021ee887b13?w=400&h=300&fit=crop', 1, '2025-10-15 16:57:23', '2025-10-15 16:57:23'),
(13, 'Papas Fritas Clásicas', 'Porción de papas fritas crujientes con sal marina y perejil.', 3.99, 'Acompañamiento', 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=400&h=300&fit=crop', 1, '2025-10-15 16:57:23', '2025-10-15 16:57:23'),
(14, 'Papas Fritas con Queso', 'Papas fritas bañadas en salsa de queso cheddar derretido.', 5.49, 'Acompañamiento', 'https://tomaleche.com/wp-content/uploads/sites/2/2021/06/GettyImages-921916164-scaled.jpg', 1, '2025-10-15 16:57:23', '2025-10-15 21:13:25'),
(15, 'Onion Rings', 'Aros de cebolla empanizados crujientes con salsa tártara.', 4.49, 'Acompañamiento', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT1_tJE-S4aRnHqdAkNxlbYL6EUwZ6aAHFisQ&s', 1, '2025-10-15 16:57:23', '2025-10-15 21:14:48'),
(16, 'Aros de Calabacín', 'Aros de calabacín empanizados con dip de yogurt y hierbas.', 4.99, 'Acompañamiento', 'https://img-global.cpcdn.com/recipes/79db3d6eeb4af550/680x781cq80/chips-de-calabacin-super-crujiente-con-salsa-de-yogur-foto-principal.jpg', 1, '2025-10-15 16:57:23', '2025-10-15 21:16:44'),
(17, 'Ensalada César', 'Lechuga romana, crutones, queso parmesano y aderezo césar.', 6.99, 'Acompañamiento', 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400&h=300&fit=crop', 1, '2025-10-15 16:57:23', '2025-10-15 16:57:23'),
(18, 'Nuggets de Pollo', '8 piezas de nuggets de pollo crujientes con salsa BBQ.', 5.99, 'Acompañamiento', 'https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?w=400&h=300&fit=crop', 1, '2025-10-15 16:57:23', '2025-10-15 16:57:23'),
(19, 'Helado de Vainilla', 'Bola de helado artesanal de vainilla con topping de chocolate.', 5.99, 'Postre', 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=400&h=300&fit=crop', 1, '2025-10-15 16:57:23', '2025-10-15 16:57:23'),
(20, 'Brownie con Helado', 'Brownie de chocolate caliente con helado de vainilla y salsa de caramelo.', 6.99, 'Postre', 'https://images.unsplash.com/photo-1623334044303-241021148842?w=400&h=300&fit=crop', 1, '2025-10-15 16:57:23', '2025-10-15 16:57:23'),
(21, 'Cheesecake de Fresa', 'Porción de cheesecake New York con coulis de fresa fresca.', 7.49, 'Postre', 'https://images.unsplash.com/photo-1567306301408-9b74779a11af?w=400&h=300&fit=crop', 1, '2025-10-15 16:57:23', '2025-10-15 16:57:23'),
(22, 'Copa de Chocolate', 'Copa de chocolate con brownie, helado y nueces caramelizadas.', 8.99, 'Postre', 'https://images.unsplash.com/photo-1483695028939-5bb13f8648b0?w=400&h=300&fit=crop', 1, '2025-10-15 16:57:23', '2025-10-15 16:57:23'),
(23, 'Donuts Glaseados', '3 donuts glaseados con diferentes toppings: chocolate, fresa y vainilla.', 4.99, 'Postre', 'https://images.unsplash.com/photo-1551106652-a5bcf4b29ab6?w=400&h=300&fit=crop', 1, '2025-10-15 16:57:23', '2025-10-15 16:57:23'),
(24, 'Malteada de Chocolate', 'Malteada cremosa de chocolate con crema batida y chispas.', 6.50, 'Postre', 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=400&h=300&fit=crop', 1, '2025-10-15 16:57:23', '2025-10-15 16:57:23');

--
-- Disparadores `productos`
--
DELIMITER $$
CREATE TRIGGER `after_producto_update` AFTER UPDATE ON `productos` FOR EACH ROW BEGIN
    IF OLD.precio != NEW.precio OR OLD.disponible != NEW.disponible THEN
        INSERT INTO auditoria_productos (
            producto_id, 
            accion, 
            precio_anterior, 
            precio_nuevo, 
            disponible_anterior, 
            disponible_nuevo,
            usuario
        ) VALUES (
            NEW.id,
            'UPDATE',
            OLD.precio,
            NEW.precio,
            OLD.disponible,
            NEW.disponible,
            USER()
        );
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_estadisticas_productos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_estadisticas_productos` (
`categoria` varchar(50)
,`total_productos` bigint(21)
,`disponibles` decimal(22,0)
,`no_disponibles` decimal(22,0)
,`precio_promedio` decimal(11,2)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_menu_completo`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_menu_completo` (
`id` bigint(20)
,`nombre` varchar(100)
,`descripcion` text
,`precio` decimal(10,2)
,`categoria` varchar(50)
,`imagen_url` varchar(255)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_estadisticas_productos`
--
DROP TABLE IF EXISTS `vista_estadisticas_productos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_estadisticas_productos`  AS SELECT `productos`.`categoria` AS `categoria`, count(0) AS `total_productos`, sum(case when `productos`.`disponible` = 1 then 1 else 0 end) AS `disponibles`, sum(case when `productos`.`disponible` = 0 then 1 else 0 end) AS `no_disponibles`, round(avg(`productos`.`precio`),2) AS `precio_promedio` FROM `productos` GROUP BY `productos`.`categoria` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_menu_completo`
--
DROP TABLE IF EXISTS `vista_menu_completo`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_menu_completo`  AS SELECT `productos`.`id` AS `id`, `productos`.`nombre` AS `nombre`, `productos`.`descripcion` AS `descripcion`, `productos`.`precio` AS `precio`, `productos`.`categoria` AS `categoria`, `productos`.`imagen_url` AS `imagen_url` FROM `productos` WHERE `productos`.`disponible` = 1 ORDER BY `productos`.`categoria` ASC, `productos`.`precio` ASC ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `auditoria_productos`
--
ALTER TABLE `auditoria_productos`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `detalle_pedidos`
--
ALTER TABLE `detalle_pedidos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `producto_id` (`producto_id`),
  ADD KEY `idx_pedido` (`pedido_id`);

--
-- Indices de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_estado` (`estado`),
  ADD KEY `idx_fecha` (`fecha_pedido`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_categoria` (`categoria`),
  ADD KEY `idx_disponible` (`disponible`),
  ADD KEY `idx_categoria_disponible` (`categoria`,`disponible`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `auditoria_productos`
--
ALTER TABLE `auditoria_productos`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `detalle_pedidos`
--
ALTER TABLE `detalle_pedidos`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `detalle_pedidos`
--
ALTER TABLE `detalle_pedidos`
  ADD CONSTRAINT `detalle_pedidos_ibfk_1` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `detalle_pedidos_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

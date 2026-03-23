-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 23, 2026 at 12:22 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `inventorydb`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `TransferStock` (IN `prod_id` INT, IN `from_wh` INT, IN `to_wh` INT, IN `qty` INT)   BEGIN
    DECLARE current_qty INT;

    -- Check stock availability
    SELECT quantity INTO current_qty
    FROM Stock
    WHERE product_id = prod_id AND warehouse_id = from_wh;

    IF current_qty >= qty THEN
        -- Deduct from source warehouse
        UPDATE Stock
        SET quantity = quantity - qty
        WHERE product_id = prod_id AND warehouse_id = from_wh;

        -- Add to destination warehouse
        UPDATE Stock
        SET quantity = quantity + qty
        WHERE product_id = prod_id AND warehouse_id = to_wh;

    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient stock for transfer';
    END IF;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `notification_id` int(11) NOT NULL,
  `message` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`notification_id`, `message`, `created_at`) VALUES
(1, 'Low stock alert for Product ID: 1', '2026-03-23 11:22:02');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `product_id` int(11) NOT NULL,
  `product_name` varchar(100) DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`product_id`, `product_name`, `category`, `supplier_id`, `price`) VALUES
(1, 'Laptop', 'Electronics', 1, 50000.00),
(2, 'Mouse', 'Electronics', 1, 500.00),
(3, 'Keyboard', 'Electronics', 4, 1500.00),
(4, 'Monitor', 'Electronics', 4, 12000.00),
(5, 'Office Chair', 'Furniture', 5, 3000.00),
(6, 'Table', 'Furniture', 5, 7000.00),
(7, 'Printer', 'Electronics', 7, 8000.00),
(8, 'Scanner', 'Electronics', 7, 6000.00),
(9, 'Notebook Pack', 'Stationery', 6, 200.00),
(10, 'Pen Pack', 'Stationery', 6, 100.00);

-- --------------------------------------------------------

--
-- Table structure for table `stock`
--

CREATE TABLE `stock` (
  `stock_id` int(11) NOT NULL,
  `product_id` int(11) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `reorder_level` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stock`
--

INSERT INTO `stock` (`stock_id`, `product_id`, `warehouse_id`, `quantity`, `reorder_level`) VALUES
(1, 1, 1, 4, 5),
(2, 2, 1, 50, 20),
(3, 3, 2, 25, 10),
(4, 4, 2, 8, 5),
(5, 5, 3, 15, 10),
(6, 6, 3, 20, 8),
(7, 7, 4, 5, 10),
(8, 8, 4, 12, 6),
(9, 9, 5, 100, 50),
(10, 10, 5, 80, 40),
(11, 1, 2, 13, 5),
(12, 2, 3, 30, 15),
(13, 3, 4, 18, 10),
(14, 4, 5, 6, 5),
(15, 5, 1, 9, 10);

--
-- Triggers `stock`
--
DELIMITER $$
CREATE TRIGGER `low_stock_alert` AFTER UPDATE ON `stock` FOR EACH ROW BEGIN
    IF NEW.quantity <= NEW.reorder_level THEN
        INSERT INTO Notifications(message)
        VALUES (CONCAT('Low stock alert for Product ID: ', NEW.product_id));
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `suppliers`
--

CREATE TABLE `suppliers` (
  `supplier_id` int(11) NOT NULL,
  `supplier_name` varchar(100) DEFAULT NULL,
  `contact_email` varchar(100) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `suppliers`
--

INSERT INTO `suppliers` (`supplier_id`, `supplier_name`, `contact_email`, `phone`) VALUES
(1, 'ABC Traders', 'abc@mail.com', '9876543210'),
(2, 'XYZ Pvt Ltd', 'xyz@mail.com', '9123456780'),
(3, 'Global Supplies', 'global@mail.com', '9988776655'),
(4, 'TechSource', 'tech@mail.com', '9012345678'),
(5, 'Furniture Hub', 'furn@mail.com', '9090909090'),
(6, 'Office Needs', 'office@mail.com', '8888888888'),
(7, 'Smart Electronics', 'smart@mail.com', '7777777777'),
(8, 'Mega Traders', 'mega@mail.com', '6666666666'),
(9, 'Quick Supply Co.', 'quick@mail.com', '9555555555'),
(10, 'Prime Distributors', 'prime@mail.com', '9444444444');

-- --------------------------------------------------------

--
-- Table structure for table `warehouses`
--

CREATE TABLE `warehouses` (
  `warehouse_id` int(11) NOT NULL,
  `warehouse_name` varchar(100) DEFAULT NULL,
  `location` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `warehouses`
--

INSERT INTO `warehouses` (`warehouse_id`, `warehouse_name`, `location`) VALUES
(1, 'Main Warehouse', 'Mumbai'),
(2, 'Secondary Warehouse', 'Pune'),
(3, 'North Warehouse', 'Delhi'),
(4, 'South Warehouse', 'Bangalore'),
(5, 'Central Warehouse', 'Nagpur');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`notification_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`),
  ADD KEY `supplier_id` (`supplier_id`);

--
-- Indexes for table `stock`
--
ALTER TABLE `stock`
  ADD PRIMARY KEY (`stock_id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `warehouse_id` (`warehouse_id`);

--
-- Indexes for table `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`supplier_id`);

--
-- Indexes for table `warehouses`
--
ALTER TABLE `warehouses`
  ADD PRIMARY KEY (`warehouse_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `notification_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `stock`
--
ALTER TABLE `stock`
  MODIFY `stock_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `supplier_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `warehouses`
--
ALTER TABLE `warehouses`
  MODIFY `warehouse_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`supplier_id`);

--
-- Constraints for table `stock`
--
ALTER TABLE `stock`
  ADD CONSTRAINT `stock_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`),
  ADD CONSTRAINT `stock_ibfk_2` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`warehouse_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

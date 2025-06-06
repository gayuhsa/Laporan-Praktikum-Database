-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 05, 2025 at 05:01 PM
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
-- Database: `modul_9`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `tambah_transaksi` (`p_id_pelanggan` INT, `p_id_buku` INT, `p_jumlah` INT)   BEGIN
	-- Menghitung total_harga = harga_buku * jumlah
	SET @total = (SELECT harga FROM buku WHERE id_buku = p_id_buku) * p_jumlah;
    SET @persentase = 1 - hitung_diskon(@total);
    
    -- Mengurangi stok buku sesuai jumlah
    UPDATE buku
    SET stok = stok - p_jumlah
    WHERE id_buku = p_id_buku;
    
    -- Menambahkan nilai total_harga ke total_belanja pelanggan
    UPDATE pelanggan
    SET total_belanja = total_belanja + (@total * @persentase)
    WHERE id_pelanggan = p_id_pelanggan;
    
    COMMIT;
    
    -- Menambahkan data ke tabel transaksi dengan tanggal hari ini
    INSERT INTO transaksi (id_pelanggan, id_buku, jumlah, total_harga, tanggal_transaksi) VALUES
	(p_id_pelanggan, p_id_buku, p_jumlah, @total * @persentase, CURRENT_DATE());
    
    -- Menampilkan pesan 'Transaksi berhasil'
    SELECT "Transaksi berhasil";
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `get_member_status` (`p_id_pelanggan` INT) RETURNS ENUM('GOLD','REGULER','PLATINUM') CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
	SET @total = (SELECT total_belanja FROM pelanggan WHERE id_pelanggan = p_id_pelanggan);
    
    IF @total >= 5000000 THEN
    	RETURN "PLATINUM";
    ELSEIF @total >= 1000000 THEN
    	RETURN "GOLD";
    ELSE
    	RETURN "REGULER";
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `hitung_diskon` (`total_belanja` DECIMAL) RETURNS DECIMAL(5,2)  BEGIN
	IF total_belanja < 1000000 THEN
    		RETURN 0;
	ELSEIF total_belanja < 5000000 THEN
    		RETURN 0.05;
	ELSE
		RETURN 0.1;
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `buku`
--

CREATE TABLE `buku` (
  `id_buku` int(11) NOT NULL,
  `judul` varchar(100) DEFAULT NULL,
  `penulis` varchar(100) DEFAULT NULL,
  `harga` decimal(10,2) DEFAULT NULL,
  `stok` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `buku`
--

INSERT INTO `buku` (`id_buku`, `judul`, `penulis`, `harga`, `stok`) VALUES
(1, 'Judul Buku 1', 'Penulis 1', 50000.00, 10),
(2, 'Judul Buku 2', 'Penulis 2', 80000.00, 30),
(3, 'Judul Buku 3', 'Penulis 3', 100000.00, 10),
(4, 'Judul Buku 4', 'Penulis 4', 70000.00, 40),
(5, 'Judul Buku 5', 'Penulis 5', 99990.00, 30);

-- --------------------------------------------------------

--
-- Table structure for table `pelanggan`
--

CREATE TABLE `pelanggan` (
  `id_pelanggan` int(11) NOT NULL,
  `nama` varchar(100) DEFAULT NULL,
  `total_belanja` decimal(10,2) DEFAULT 0.00,
  `status_member` enum('REGULER','GOLD','PLATINUM') DEFAULT 'REGULER'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pelanggan`
--

INSERT INTO `pelanggan` (`id_pelanggan`, `nama`, `total_belanja`, `status_member`) VALUES
(1, 'Pelanggan 1', 5060000.00, 'PLATINUM'),
(2, 'Pelanggan 2', 0.00, 'REGULER'),
(3, 'Pelanggan 3', 0.00, 'REGULER'),
(4, 'Pelanggan 4', 0.00, 'REGULER'),
(5, 'Pelanggan 5', 0.00, 'REGULER');

-- --------------------------------------------------------

--
-- Table structure for table `transaksi`
--

CREATE TABLE `transaksi` (
  `id_transaksi` int(11) NOT NULL,
  `id_pelanggan` int(11) DEFAULT NULL,
  `id_buku` int(11) DEFAULT NULL,
  `jumlah` int(11) DEFAULT NULL,
  `total_harga` decimal(10,2) DEFAULT NULL,
  `tanggal_transaksi` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transaksi`
--

INSERT INTO `transaksi` (`id_transaksi`, `id_pelanggan`, `id_buku`, `jumlah`, `total_harga`, `tanggal_transaksi`) VALUES
(1, 1, 2, 2, 160000.00, '2025-06-05'),
(2, 1, 3, 50, 4500000.00, '2025-06-05'),
(3, 1, 3, 4, 400000.00, '2025-06-05');

--
-- Triggers `transaksi`
--
DELIMITER $$
CREATE TRIGGER `trigger1` AFTER INSERT ON `transaksi` FOR EACH ROW UPDATE pelanggan
SET status_member = get_member_status(id_pelanggan)
WHERE id_pelanggan = NEW.id_pelanggan
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `buku`
--
ALTER TABLE `buku`
  ADD PRIMARY KEY (`id_buku`);

--
-- Indexes for table `pelanggan`
--
ALTER TABLE `pelanggan`
  ADD PRIMARY KEY (`id_pelanggan`);

--
-- Indexes for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`id_transaksi`),
  ADD KEY `id_pelanggan` (`id_pelanggan`),
  ADD KEY `id_buku` (`id_buku`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `buku`
--
ALTER TABLE `buku`
  MODIFY `id_buku` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `pelanggan`
--
ALTER TABLE `pelanggan`
  MODIFY `id_pelanggan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `transaksi`
--
ALTER TABLE `transaksi`
  MODIFY `id_transaksi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD CONSTRAINT `transaksi_ibfk_1` FOREIGN KEY (`id_pelanggan`) REFERENCES `pelanggan` (`id_pelanggan`),
  ADD CONSTRAINT `transaksi_ibfk_2` FOREIGN KEY (`id_buku`) REFERENCES `buku` (`id_buku`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

-- phpMyAdmin SQL Dump
-- version 4.5.4.1deb2ubuntu2
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jun 13, 2017 at 05:12 PM
-- Server version: 5.7.18-0ubuntu0.16.04.1
-- PHP Version: 7.0.18-0ubuntu0.16.04.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `target_exemplar`
--

-- --------------------------------------------------------

--
-- Table structure for table `target_order`
--

CREATE TABLE `target_order` (
  `id` int(11) NOT NULL,
  `datetime` datetime NOT NULL,
  `content` text NOT NULL,
  `username` int(11) NOT NULL
  PRIMARY KEY (`id`),
  NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=201,
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `target_order`
--

INSERT INTO `target_order` (`id`, `datetime`, `content`, `username`) VALUES
(101, '2017-12-10 03:33:11', 'neque.', 'vendor-1'),
(102, '2016-12-05 20:46:44', 'In condimentum. Donec at', 'vendor-1'),
(103, '2016-05-01 12:16:22', 'amet, dapibus', 'vendor-1'),
(104, '2016-08-27 14:24:33', 'non dui nec', 'vendor-1'),
(105, '2017-02-05 20:37:43', 'Praesent interdum ligula eu', 'vendor-1'),
(106, '2017-12-13 05:30:47', 'hendrerit consectetuer, cursus et,', 'vendor-1'),
(107, '2017-05-03 16:06:39', 'Etiam gravida', 'vendor-1'),
(108, '2017-10-14 21:20:29', 'magna.', 'vendor-1'),
(109, '2016-06-13 02:34:12', 'fringilla mi lacinia', 'vendor-1'),
(110, '2017-02-23 14:58:30', 'ultricies', 'vendor-1'),
(111, '2017-01-26 21:24:14', 'vel', 'vendor-2'),
(112, '2017-02-20 15:47:36', 'iaculis quis, pede.', 'vendor-2'),
(113, '2017-07-16 08:03:45', 'ante dictum', 'vendor-3'),
(114, '2018-01-22 16:02:52', 'eu nulla at', 'vendor-2'),
(115, '2017-04-05 20:49:01', 'sit amet', 'vendor-2'),
(116, '2017-10-20 08:23:51', 'Aliquam ultrices iaculis odio.', 'vendor-1'),
(117, '2018-01-19 15:09:17', 'ipsum. Donec', 'vendor-1'),
(118, '2016-10-21 11:12:23', 'risus. Donec egestas. Aliquam', 'vendor-1'),
(119, '2017-01-20 14:44:30', 'Quisque ac libero nec', 'vendor-2'),
(120, '2018-01-11 05:43:13', 'tellus lorem', 'vendor-3'),
(121, '2017-07-27 15:27:38', 'gravida sit', 'vendor-1'),
(122, '2017-04-17 04:54:28', 'auctor vitae, aliquet', 'vendor-1'),
(123, '2017-04-22 19:32:53', 'sociis natoque', 'vendor-2'),
(124, '2017-02-20 04:39:08', 'tempus mauris erat eget', 'vendor-1'),
(125, '2018-01-02 21:58:17', 'et malesuada fames ac', 'vendor-3'),
(126, '2017-08-07 21:03:34', 'convallis convallis dolor.', 'vendor-2'),
(127, '2016-12-08 07:11:51', 'quam, elementum at, egestas', 'vendor-3'),
(128, '2017-11-12 16:07:27', 'placerat,', 'vendor-2'),
(129, '2017-04-30 03:23:47', 'arcu.', 'vendor-3'),
(130, '2017-04-07 09:36:12', 'nisl. Maecenas malesuada', 'vendor-3'),
(131, '2017-05-01 08:44:26', 'Nulla', 'vendor-2'),
(132, '2016-09-24 05:50:52', 'est, congue a,', 'vendor-2'),
(133, '2017-08-04 18:51:52', 'Curabitur dictum. Phasellus', 'vendor-3'),
(134, '2016-10-27 14:33:38', 'libero.', 'vendor-2'),
(135, '2017-10-04 23:04:25', 'cursus. Nunc mauris', 'vendor-3'),
(136, '2016-04-25 15:04:03', 'bibendum', 'vendor-3'),
(137, '2016-05-16 18:07:30', 'lacus, varius et, euismod', 'vendor-2'),
(138, '2017-08-19 04:25:23', 'a ultricies', 'vendor-2'),
(139, '2017-08-25 06:01:34', 'enim. Nunc', 'vendor-3'),
(140, '2016-12-12 10:13:47', 'at', 'vendor-2'),
(141, '2017-10-08 04:30:00', 'lorem', 'vendor-2'),
(142, '2016-07-08 15:16:34', 'Quisque ornare tortor at', 'vendor-1'),
(143, '2017-01-25 14:50:47', 'non', 'vendor-1'),
(144, '2017-03-02 03:53:29', 'aliquam adipiscing lacus.', 'vendor-1'),
(145, '2016-06-06 21:23:55', 'Aenean gravida nunc', 'vendor-1'),
(146, '2018-02-15 08:09:53', 'Aliquam', 'vendor-1'),
(147, '2016-09-15 03:35:53', 'Nulla', 'vendor-1'),
(148, '2017-09-09 18:20:34', 'Nulla semper tellus id', 'vendor-1'),
(149, '2017-03-13 02:10:19', 'vestibulum massa rutrum', 'vendor-2'),
(150, '2016-09-12 10:04:44', 'luctus vulputate, nisi', 'vendor-1'),
(151, '2016-12-11 18:11:35', 'iaculis enim, sit', 'vendor-2'),
(152, '2016-04-18 10:47:54', 'semper pretium neque. Morbi', 'vendor-1'),
(153, '2017-01-26 10:20:10', 'sit amet', 'vendor-2'),
(154, '2018-01-27 10:33:22', 'Maecenas ornare egestas', 'vendor-3'),
(155, '2018-01-22 03:53:49', 'mi, ac', 'vendor-3'),
(156, '2017-02-25 22:12:41', 'mauris sagittis', 'vendor-1'),
(157, '2016-04-16 12:01:37', 'in aliquet lobortis, nisi', 'vendor-3'),
(158, '2017-11-21 16:45:11', 'neque pellentesque massa lobortis', 'vendor-1'),
(159, '2016-06-23 09:09:03', 'Mauris magna. Duis', 'vendor-1'),
(160, '2016-08-07 19:37:45', 'neque sed', 'vendor-1'),
(161, '2017-06-13 07:43:05', 'elit, pretium', 'vendor-3'),
(162, '2016-08-08 19:28:51', 'et', 'vendor-3'),
(163, '2016-11-01 09:25:17', 'est. Nunc laoreet', 'vendor-2'),
(164, '2016-08-02 03:58:14', 'viverra. Maecenas iaculis', 'vendor-2'),
(165, '2018-01-01 15:10:35', 'ornare egestas ligula.', 'vendor-2'),
(166, '2017-09-08 12:20:26', 'sociis', 'vendor-3'),
(167, '2016-09-04 13:25:30', 'Phasellus nulla. Integer vulputate,', 'vendor-2'),
(168, '2017-04-01 17:41:39', 'metus facilisis', 'vendor-1'),
(169, '2017-02-28 21:49:10', 'accumsan laoreet ipsum. Curabitur', 'vendor-1'),
(170, '2016-04-29 23:46:16', 'facilisis, magna', 'vendor-2'),
(171, '2017-05-03 15:48:44', 'Proin', 'vendor-2'),
(172, '2016-10-08 17:56:38', 'tellus eu augue', 'vendor-1'),
(173, '2017-11-23 04:53:05', 'libero at auctor ullamcorper,', 'vendor-2'),
(174, '2016-07-23 13:11:39', 'orci lacus', 'vendor-3'),
(175, '2017-01-25 15:11:40', 'nulla at', 'vendor-3'),
(176, '2016-06-12 15:56:02', 'blandit. Nam nulla magna,', 'vendor-3'),
(177, '2016-12-19 02:10:29', 'orci', 'vendor-2'),
(178, '2016-06-15 07:17:24', 'montes, nascetur ridiculus mus.', 'vendor-2'),
(179, '2016-07-27 23:40:32', 'Etiam', 'vendor-3'),
(180, '2018-03-10 22:52:38', 'eleifend vitae, erat. Vivamus', 'vendor-2'),
(181, '2017-03-09 02:04:38', 'felis ullamcorper viverra. Maecenas', 'vendor-1'),
(182, '2016-11-25 14:38:38', 'quam dignissim', 'vendor-2'),
(183, '2016-05-31 13:23:10', 'adipiscing elit. Curabitur sed', 'vendor-3'),
(184, '2017-03-09 09:22:30', 'Nunc quis arcu vel', 'vendor-3'),
(185, '2017-07-30 22:52:09', 'ornare,', 'vendor-3'),
(186, '2016-08-10 00:34:41', 'ligula', 'vendor-3'),
(187, '2017-04-10 14:04:18', 'arcu.', 'vendor-1'),
(188, '2017-04-21 15:30:26', 'id magna et ipsum', 'vendor-2'),
(189, '2017-09-25 23:15:11', 'ac risus.', 'vendor-1'),
(190, '2017-06-26 22:54:46', 'a ultricies adipiscing, enim', 'vendor-1'),
(191, '2017-05-27 22:20:24', 'vel,', 'vendor-1'),
(192, '2018-02-18 12:27:19', 'sapien, cursus in,', 'vendor-3'),
(193, '2018-01-04 22:59:12', 'amet metus. Aliquam erat', 'vendor-1'),
(194, '2018-01-27 22:46:15', 'Praesent eu dui.', 'vendor-1'),
(195, '2017-08-22 14:58:50', 'nibh enim,', 'vendor-3'),
(196, '2017-09-30 17:00:31', 'dapibus gravida. Aliquam tincidunt,', 'vendor-2'),
(197, '2016-12-16 23:44:15', 'nulla vulputate', 'vendor-2'),
(198, '2017-08-14 21:03:33', 'eu,', 'vendor-3'),
(199, '2017-04-26 20:58:26', 'Etiam vestibulum massa', 'vendor-3'),
(200, '2017-01-20 23:46:30', 'pellentesque massa lobortis ultrices.', 'vendor-3');

-- --------------------------------------------------------


--
-- Table structure for table `members`
--

CREATE TABLE `members` (
  `id` char(23) NOT NULL,
  `username` varchar(65) NOT NULL DEFAULT '',
  `password` varchar(65) NOT NULL DEFAULT '',
  `email` varchar(65) NOT NULL,
  `verified` tinyint(1) NOT NULL DEFAULT '0',
  `mod_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `root` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUEKEY `username_UNIQUE` (`username`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `email_UNIQUE` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


INSERT INTO `members` (`id`, `username`, `password`, `email`, `verified`, `root`) VALUES
(1, 'root', '$2y$10$N1Oz.rXA2S3rAXPHmfUTH.WePB/4mL9IVYB7dSqzRmHBgBZ0tL2IG', 'root@gmail.com', 1, 1),
(2, 'target', '$2y$10$MGePloNFOO3ACVObNN.VyeyQGR4M7JC1ioGnSDjhwOXcxF9G4ORo.', 'target@gmail.com', 1, 0),
(3, 'vendor-1', '$2y$10$HGMg5Awl201TFwJsN5ykkuSD/W4PWJmch1pbPy9zVh/yheCnTOINu', 'vendor1@gmail.com', 1, 0),
(4, 'vendor-2', '$2y$10$StEl0oramRyYdX3CudIOvurLXLcPSWV2xFZn/smzwQSvTFApq.6rS', 'vendor2@gmail.com', 1, 0),
(5, 'vendor-3', '$2y$10$Od1bDD0vXhPS0oyWIsI7ZuHb7/i/nYOAjMRufLwsmmKekyHXgoF7e', 'vendor3@gmail.com', 1, 0);


--
-- Table structure for table `loginAttempts`
--

CREATE TABLE `loginAttempts` (
  `IP` varchar(20) NOT NULL,
  `Attempts` int(11) NOT NULL,
  `LastLogin` datetime NOT NULL,
  `Username` varchar(65) DEFAULT NULL,
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- --------------------------------------------------------


--
-- Constraints for table `target_order`
--
ALTER TABLE `target_order`
  ADD CONSTRAINT `target_order_ibfk_1` FOREIGN KEY (`username`) REFERENCES `members` (`username`) ON DELETE CASCADE ON UPDATE CASCADE;


/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

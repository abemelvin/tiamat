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
  `owner_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `target_order`
--

INSERT INTO `target_order` (`id`, `datetime`, `content`, `owner_id`) VALUES
(101, '2017-12-10 03:33:11', 'neque.', 2),
(102, '2016-12-05 20:46:44', 'In condimentum. Donec at', 2),
(103, '2016-05-01 12:16:22', 'amet, dapibus', 2),
(104, '2016-08-27 14:24:33', 'non dui nec', 2),
(105, '2017-02-05 20:37:43', 'Praesent interdum ligula eu', 2),
(106, '2017-12-13 05:30:47', 'hendrerit consectetuer, cursus et,', 2),
(107, '2017-05-03 16:06:39', 'Etiam gravida', 2),
(108, '2017-10-14 21:20:29', 'magna.', 2),
(109, '2016-06-13 02:34:12', 'fringilla mi lacinia', 2),
(110, '2017-02-23 14:58:30', 'ultricies', 2),
(111, '2017-01-26 21:24:14', 'vel', 3),
(112, '2017-02-20 15:47:36', 'iaculis quis, pede.', 3),
(113, '2017-07-16 08:03:45', 'ante dictum', 5),
(114, '2018-01-22 16:02:52', 'eu nulla at', 3),
(115, '2017-04-05 20:49:01', 'sit amet', 3),
(116, '2017-10-20 08:23:51', 'Aliquam ultrices iaculis odio.', 4),
(117, '2018-01-19 15:09:17', 'ipsum. Donec', 4),
(118, '2016-10-21 11:12:23', 'risus. Donec egestas. Aliquam', 4),
(119, '2017-01-20 14:44:30', 'Quisque ac libero nec', 3),
(120, '2018-01-11 05:43:13', 'tellus lorem', 5),
(121, '2017-07-27 15:27:38', 'gravida sit', 4),
(122, '2017-04-17 04:54:28', 'auctor vitae, aliquet', 4),
(123, '2017-04-22 19:32:53', 'sociis natoque', 3),
(124, '2017-02-20 04:39:08', 'tempus mauris erat eget', 4),
(125, '2018-01-02 21:58:17', 'et malesuada fames ac', 5),
(126, '2017-08-07 21:03:34', 'convallis convallis dolor.', 3),
(127, '2016-12-08 07:11:51', 'quam, elementum at, egestas', 5),
(128, '2017-11-12 16:07:27', 'placerat,', 3),
(129, '2017-04-30 03:23:47', 'arcu.', 5),
(130, '2017-04-07 09:36:12', 'nisl. Maecenas malesuada', 5),
(131, '2017-05-01 08:44:26', 'Nulla', 3),
(132, '2016-09-24 05:50:52', 'est, congue a,', 3),
(133, '2017-08-04 18:51:52', 'Curabitur dictum. Phasellus', 5),
(134, '2016-10-27 14:33:38', 'libero.', 3),
(135, '2017-10-04 23:04:25', 'cursus. Nunc mauris', 5),
(136, '2016-04-25 15:04:03', 'bibendum', 5),
(137, '2016-05-16 18:07:30', 'lacus, varius et, euismod', 3),
(138, '2017-08-19 04:25:23', 'a ultricies', 3),
(139, '2017-08-25 06:01:34', 'enim. Nunc', 5),
(140, '2016-12-12 10:13:47', 'at', 3),
(141, '2017-10-08 04:30:00', 'lorem', 3),
(142, '2016-07-08 15:16:34', 'Quisque ornare tortor at', 4),
(143, '2017-01-25 14:50:47', 'non', 4),
(144, '2017-03-02 03:53:29', 'aliquam adipiscing lacus.', 4),
(145, '2016-06-06 21:23:55', 'Aenean gravida nunc', 4),
(146, '2018-02-15 08:09:53', 'Aliquam', 4),
(147, '2016-09-15 03:35:53', 'Nulla', 4),
(148, '2017-09-09 18:20:34', 'Nulla semper tellus id', 4),
(149, '2017-03-13 02:10:19', 'vestibulum massa rutrum', 3),
(150, '2016-09-12 10:04:44', 'luctus vulputate, nisi', 4),
(151, '2016-12-11 18:11:35', 'iaculis enim, sit', 3),
(152, '2016-04-18 10:47:54', 'semper pretium neque. Morbi', 4),
(153, '2017-01-26 10:20:10', 'sit amet', 3),
(154, '2018-01-27 10:33:22', 'Maecenas ornare egestas', 5),
(155, '2018-01-22 03:53:49', 'mi, ac', 5),
(156, '2017-02-25 22:12:41', 'mauris sagittis', 4),
(157, '2016-04-16 12:01:37', 'in aliquet lobortis, nisi', 5),
(158, '2017-11-21 16:45:11', 'neque pellentesque massa lobortis', 4),
(159, '2016-06-23 09:09:03', 'Mauris magna. Duis', 4),
(160, '2016-08-07 19:37:45', 'neque sed', 4),
(161, '2017-06-13 07:43:05', 'elit, pretium', 5),
(162, '2016-08-08 19:28:51', 'et', 5),
(163, '2016-11-01 09:25:17', 'est. Nunc laoreet', 3),
(164, '2016-08-02 03:58:14', 'viverra. Maecenas iaculis', 3),
(165, '2018-01-01 15:10:35', 'ornare egestas ligula.', 3),
(166, '2017-09-08 12:20:26', 'sociis', 5),
(167, '2016-09-04 13:25:30', 'Phasellus nulla. Integer vulputate,', 3),
(168, '2017-04-01 17:41:39', 'metus facilisis', 4),
(169, '2017-02-28 21:49:10', 'accumsan laoreet ipsum. Curabitur', 4),
(170, '2016-04-29 23:46:16', 'facilisis, magna', 3),
(171, '2017-05-03 15:48:44', 'Proin', 3),
(172, '2016-10-08 17:56:38', 'tellus eu augue', 4),
(173, '2017-11-23 04:53:05', 'libero at auctor ullamcorper,', 3),
(174, '2016-07-23 13:11:39', 'orci lacus', 5),
(175, '2017-01-25 15:11:40', 'nulla at', 5),
(176, '2016-06-12 15:56:02', 'blandit. Nam nulla magna,', 5),
(177, '2016-12-19 02:10:29', 'orci', 3),
(178, '2016-06-15 07:17:24', 'montes, nascetur ridiculus mus.', 3),
(179, '2016-07-27 23:40:32', 'Etiam', 5),
(180, '2018-03-10 22:52:38', 'eleifend vitae, erat. Vivamus', 3),
(181, '2017-03-09 02:04:38', 'felis ullamcorper viverra. Maecenas', 4),
(182, '2016-11-25 14:38:38', 'quam dignissim', 3),
(183, '2016-05-31 13:23:10', 'adipiscing elit. Curabitur sed', 5),
(184, '2017-03-09 09:22:30', 'Nunc quis arcu vel', 5),
(185, '2017-07-30 22:52:09', 'ornare,', 5),
(186, '2016-08-10 00:34:41', 'ligula', 5),
(187, '2017-04-10 14:04:18', 'arcu.', 4),
(188, '2017-04-21 15:30:26', 'id magna et ipsum', 3),
(189, '2017-09-25 23:15:11', 'ac risus.', 4),
(190, '2017-06-26 22:54:46', 'a ultricies adipiscing, enim', 4),
(191, '2017-05-27 22:20:24', 'vel,', 4),
(192, '2018-02-18 12:27:19', 'sapien, cursus in,', 5),
(193, '2018-01-04 22:59:12', 'amet metus. Aliquam erat', 4),
(194, '2018-01-27 22:46:15', 'Praesent eu dui.', 4),
(195, '2017-08-22 14:58:50', 'nibh enim,', 5),
(196, '2017-09-30 17:00:31', 'dapibus gravida. Aliquam tincidunt,', 3),
(197, '2016-12-16 23:44:15', 'nulla vulputate', 3),
(198, '2017-08-14 21:03:33', 'eu,', 5),
(199, '2017-04-26 20:58:26', 'Etiam vestibulum massa', 5),
(200, '2017-01-20 23:46:30', 'pellentesque massa lobortis ultrices.', 5);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--


CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(255) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(30) NOT NULL,
  `email` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `group_id` int(11) NOT NULL DEFAULT '3',
  -- `active` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- CREATE TABLE `user` (
--   `id` int(11) NOT NULL,
--   `password` varchar(128) NOT NULL,
--   `first_name` varchar(30) NOT NULL,
--   `last_name` varchar(30) NOT NULL,
--   `email` varchar(254) NOT NULL,
--   `username` varchar(150) NOT NULL 
--   `group_id` int(11) NOT NULL DEFAULT '3'
-- ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `password`, `first_name`, `last_name`, `email`, `username`, `group_id`) VALUES
(1, 'root', 'DB', 'manager', 'root@gmail.com', 'root', 1),
(2, 'target', 'Target', 'Company', 'target@gmail.com', 'target', 2),
(3, 'tyallen', 'Tony', 'Allen', 'tony@gmail.com', 'tyallen', 3),
(4, 'stcurry', 'Stephen', 'Curry', 'curry@gmail.com', 'stcurry', 3),
(5, 'lbjames', 'Lebron', 'James', 'james@gmail.com', 'lbjames', 3);

-- --------------------------------------------------------

--
-- Table structure for table `user_group`
--

CREATE TABLE `user_group` (
  `id` int(11) NOT NULL,
  `group_type` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user_group`
--

INSERT INTO `user_group` (`id`, `group_type`) VALUES
(1, 'root'),
(2, 'target'),
(3, 'customer');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `target_order`
--
ALTER TABLE `target_order`
  ADD PRIMARY KEY (`id`),
  ADD KEY `owner_id` (`owner_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD KEY `group_id` (`group_id`);

--
-- Indexes for table `user_group`
--
ALTER TABLE `user_group`
  ADD KEY `id` (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `target_order`
--
ALTER TABLE `target_order`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=201;
--
-- AUTO_INCREMENT for table `user_group`
--
ALTER TABLE `user_group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `target_order`
--
ALTER TABLE `target_order`
  ADD CONSTRAINT `target_order_ibfk_1` FOREIGN KEY (`owner_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `user_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `user_group` (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

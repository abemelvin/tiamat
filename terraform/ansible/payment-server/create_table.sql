
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

CREATE TABLE `transactions` (
  `transac_id` text NOT NULL,
  `datetime` datetime NOT NULL,
  `content` text NOT NULL,
  `amount` double NOT NULL,
  `credit_card_no` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


/* INSERT INTO `transactions` (`transac_id`, `datetime`, `content`, `amount`, `credit_card_no`) VALUES
('001', '2017-12-10 03:33:11', 'something', 100.00,'4000498209990234'),
('002', '2016-12-05 20:46:44', 'something', 100.00,'4144567109297845'),
('003', '2016-05-01 12:16:22', 'something', 100.00,'4043242209456289'); */

-- --------------------------------------------------------


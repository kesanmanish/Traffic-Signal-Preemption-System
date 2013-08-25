-- phpMyAdmin SQL Dump
-- version 2.11.4
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Mar 01, 2013 at 12:05 PM
-- Server version: 5.1.57
-- PHP Version: 5.2.17

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `a7548625_folio`
--

-- --------------------------------------------------------

--
-- Table structure for table `ambulance`
--

CREATE TABLE `ambulance` (
  `amb_id` int(20) NOT NULL AUTO_INCREMENT,
  `amb_no` varchar(10) NOT NULL,
  `amb_pwd` varchar(10) NOT NULL,
  `amb_dname` varchar(20) NOT NULL,
  `amb_phno` varchar(12) DEFAULT NULL,
  `amb_desc` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`amb_id`),
  UNIQUE KEY `amb_no` (`amb_no`),
  UNIQUE KEY `amb_no_2` (`amb_no`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `ambulance`
--

INSERT INTO `ambulance` VALUES(1, 'KA06EE1284', 'amb001', 'PRADEEP', '8951234136', 'BAPTIST');
INSERT INTO `ambulance` VALUES(2, 'KA09EE1285', 'amb002', 'MANISH', '02342323', 'SDSDF');

-- --------------------------------------------------------

--
-- Table structure for table `emergency`
--

CREATE TABLE `emergency` (
  `amb_id` int(20) NOT NULL,
  `e_latitude` decimal(15,12) NOT NULL,
  `e_longitude` decimal(15,12) NOT NULL,
  `e_source` varchar(20) NOT NULL,
  `e_destination` varchar(20) NOT NULL,
  `t_sigid` int(10) NOT NULL,
  `e_jid` int(10) NOT NULL AUTO_INCREMENT,
  `e_priority` int(3) NOT NULL,
  `e_dir` decimal(15,12) NOT NULL,
  `e_speed` decimal(15,12) NOT NULL,
  PRIMARY KEY (`e_jid`),
  KEY `amb_id` (`amb_id`),
  KEY `t_sigid` (`t_sigid`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=52 ;

--
-- Dumping data for table `emergency`
--

INSERT INTO `emergency` VALUES(1, 0.000000000000, 0.000000000000, '', '', 2, 47, 4, 0.000000000000, 0.000000000000);
INSERT INTO `emergency` VALUES(1, 0.000000000000, 0.000000000000, '', '', 2, 46, 4, 0.000000000000, 0.000000000000);
INSERT INTO `emergency` VALUES(1, 0.000000000000, 0.000000000000, '', '', 2, 44, 4, 0.000000000000, 0.000000000000);
INSERT INTO `emergency` VALUES(1, 0.000000000000, 0.000000000000, '', '', 2, 45, 4, 0.000000000000, 0.000000000000);
INSERT INTO `emergency` VALUES(1, 0.000000000000, 0.000000000000, '', '', 2, 48, 3, 0.000000000000, 0.000000000000);
INSERT INTO `emergency` VALUES(1, 0.000000000000, 0.000000000000, '', '', 2, 49, 4, 0.000000000000, 0.000000000000);
INSERT INTO `emergency` VALUES(1, 0.000000000000, 0.000000000000, '', '', 2, 50, 4, 0.000000000000, 0.000000000000);
INSERT INTO `emergency` VALUES(1, 0.000000000000, 0.000000000000, '', '', 2, 51, 4, 0.000000000000, 0.000000000000);

-- --------------------------------------------------------

--
-- Table structure for table `gotime`
--

CREATE TABLE `gotime` (
  `t_sigid` int(10) NOT NULL,
  `g_roadno` int(2) NOT NULL,
  `g_gotime` int(3) NOT NULL,
  KEY `t_sigid` (`t_sigid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `gotime`
--

INSERT INTO `gotime` VALUES(1, 3, 30);

-- --------------------------------------------------------

--
-- Table structure for table `log`
--

CREATE TABLE `log` (
  `amb_id` int(20) NOT NULL,
  `l_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `l_event` varchar(25) NOT NULL,
  `t_sigid` int(10) NOT NULL,
  `l_roadno` int(2) NOT NULL,
  `e_priority` int(3) NOT NULL,
  KEY `amb_id` (`amb_id`),
  KEY `t_sigid` (`t_sigid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `log`
--

INSERT INTO `log` VALUES(1, '2013-02-28 09:45:51', 'LOGIN', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-02-28 09:57:10', 'LOGIN', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-02-28 09:57:15', 'EMERGENCY_START', 2, 0, 1);
INSERT INTO `log` VALUES(1, '2013-02-28 10:02:19', 'LOGOUT', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-02-28 10:02:42', 'LOGIN', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-02-28 10:02:49', 'EMERGENCY_START', 2, 0, 1);
INSERT INTO `log` VALUES(1, '2013-02-28 10:02:53', 'EMERGENCY_END', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-02-28 10:02:57', 'LOGOUT', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-02-28 12:02:48', 'LOGIN', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-02-28 12:02:54', 'EMERGENCY_START', 2, 0, 1);
INSERT INTO `log` VALUES(1, '2013-02-28 12:03:24', 'EMERGENCY_START', 2, 0, 1);
INSERT INTO `log` VALUES(1, '2013-02-28 12:03:27', 'EMERGENCY_START', 2, 0, 2);
INSERT INTO `log` VALUES(1, '2013-02-28 12:04:39', 'EMERGENCY_START', 2, 0, 4);
INSERT INTO `log` VALUES(1, '2013-02-28 12:05:18', 'EMERGENCY_START', 2, 0, 4);
INSERT INTO `log` VALUES(1, '2013-02-28 12:06:30', 'LOGIN', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-02-28 12:06:33', 'EMERGENCY_START', 2, 0, 3);
INSERT INTO `log` VALUES(1, '2013-02-28 12:19:21', 'EMERGENCY_END', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-02-28 12:19:24', 'LOGOUT', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-02-28 12:19:25', 'LOGOUT', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-02-28 12:24:11', 'LOGIN', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-02-28 12:24:15', 'EMERGENCY_START', 2, 0, 2);
INSERT INTO `log` VALUES(1, '2013-02-28 12:28:38', 'EMERGENCY_END', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-02-28 12:28:41', 'LOGOUT', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-03-01 08:55:15', 'LOGIN', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-03-01 08:55:20', 'EMERGENCY_START', 2, 0, 4);
INSERT INTO `log` VALUES(1, '2013-03-01 08:56:04', 'EMERGENCY_END', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-03-01 08:56:07', 'LOGOUT', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-03-01 09:00:31', 'LOGIN', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-03-01 09:00:53', 'EMERGENCY_START', 2, 0, 2);
INSERT INTO `log` VALUES(1, '2013-03-01 09:03:08', 'LOGIN', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-03-01 09:03:12', 'EMERGENCY_START', 2, 0, 2);
INSERT INTO `log` VALUES(1, '2013-03-01 09:03:37', 'LOGIN', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-03-01 09:03:40', 'EMERGENCY_START', 2, 0, 2);
INSERT INTO `log` VALUES(1, '2013-03-01 09:04:13', 'LOGIN', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-03-01 09:04:25', 'EMERGENCY_START', 2, 0, 1);
INSERT INTO `log` VALUES(1, '2013-03-01 09:07:51', 'LOGIN', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-03-01 09:08:02', 'EMERGENCY_START', 2, 0, 1);
INSERT INTO `log` VALUES(1, '2013-03-01 09:20:16', 'EMERGENCY_END', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-03-01 09:20:18', 'LOGOUT', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-03-01 09:20:29', 'EMERGENCY_END', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-03-01 09:20:36', 'LOGOUT', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-03-01 09:20:45', 'EMERGENCY_END', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-03-01 09:20:46', 'LOGOUT', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-03-01 09:20:56', 'EMERGENCY_END', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-03-01 09:21:07', 'LOGOUT', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-03-01 09:21:09', 'EMERGENCY_END', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-03-01 09:21:17', 'EMERGENCY_START', 2, 0, 2);
INSERT INTO `log` VALUES(1, '2013-03-01 09:21:19', 'EMERGENCY_END', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-03-01 09:21:22', 'LOGOUT', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-03-01 09:28:31', 'LOGIN', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-03-01 09:28:36', 'EMERGENCY_START', 2, 0, 4);
INSERT INTO `log` VALUES(1, '2013-03-01 09:34:15', 'LOGIN', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-03-01 09:34:20', 'EMERGENCY_START', 2, 0, 4);
INSERT INTO `log` VALUES(1, '2013-03-01 09:37:21', 'LOGIN', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-03-01 09:37:27', 'EMERGENCY_START', 2, 0, 4);
INSERT INTO `log` VALUES(1, '2013-03-01 09:37:48', 'EMERGENCY_END', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-03-01 09:37:51', 'LOGOUT', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-03-01 09:37:53', 'LOGOUT', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-03-01 09:41:43', 'LOGIN', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-03-01 09:41:48', 'EMERGENCY_START', 2, 0, 4);
INSERT INTO `log` VALUES(1, '2013-03-01 09:49:47', 'LOGIN', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-03-01 09:49:52', 'EMERGENCY_START', 2, 0, 4);
INSERT INTO `log` VALUES(1, '2013-03-01 09:52:36', 'LOGIN', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-03-01 09:52:41', 'EMERGENCY_START', 2, 0, 4);
INSERT INTO `log` VALUES(1, '2013-03-01 09:55:38', 'LOGIN', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-03-01 09:55:46', 'EMERGENCY_START', 2, 0, 4);
INSERT INTO `log` VALUES(1, '2013-03-01 09:56:53', 'LOGIN', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-03-01 09:57:00', 'EMERGENCY_START', 2, 0, 3);
INSERT INTO `log` VALUES(1, '2013-03-01 10:00:42', 'LOGIN', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-03-01 10:00:46', 'EMERGENCY_START', 2, 0, 4);
INSERT INTO `log` VALUES(1, '2013-03-01 10:02:15', 'LOGIN', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-03-01 10:02:20', 'EMERGENCY_START', 2, 0, 4);
INSERT INTO `log` VALUES(1, '2013-03-01 10:03:02', 'LOGIN', 2, 0, 0);
INSERT INTO `log` VALUES(1, '2013-03-01 10:03:12', 'EMERGENCY_START', 2, 0, 4);

-- --------------------------------------------------------

--
-- Table structure for table `login`
--

CREATE TABLE `login` (
  `l_user` varchar(10) NOT NULL,
  `l_pwd` varchar(10) NOT NULL,
  `l_id` int(2) NOT NULL,
  `l_email` varchar(30) NOT NULL,
  `l_name` varchar(30) NOT NULL,
  PRIMARY KEY (`l_id`),
  UNIQUE KEY `l_user` (`l_user`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `login`
--


-- --------------------------------------------------------

--
-- Table structure for table `position`
--

CREATE TABLE `position` (
  `t_sigid` int(10) NOT NULL,
  `p_roadno` varchar(2) NOT NULL,
  `p_latitude` decimal(15,12) NOT NULL,
  `p_longitude` decimal(15,12) NOT NULL,
  KEY `t_sigid` (`t_sigid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `position`
--

INSERT INTO `position` VALUES(1, '3', 123.222222000000, 124.444444000000);

-- --------------------------------------------------------

--
-- Table structure for table `tsignal`
--

CREATE TABLE `tsignal` (
  `t_sigid` int(10) NOT NULL AUTO_INCREMENT,
  `t_code` varchar(10) NOT NULL,
  `t_latitude` decimal(15,12) NOT NULL,
  `t_longitude` decimal(15,12) NOT NULL,
  `t_sigcount` int(1) NOT NULL,
  `t_pausetime` int(3) NOT NULL,
  `t_preempt` tinyint(1) NOT NULL DEFAULT '0',
  `t_ip` varchar(20) NOT NULL,
  PRIMARY KEY (`t_sigid`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `tsignal`
--

INSERT INTO `tsignal` VALUES(1, 'E', 123.222222000000, 124.333333000000, 4, 10, 0, '192.168.1.1');
INSERT INTO `tsignal` VALUES(2, 'D000', 72.000042000000, 71.623565000000, 0, 0, 0, '191.1');

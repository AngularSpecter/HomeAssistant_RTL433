-- phpMyAdmin SQL Dump
-- version 4.6.6deb4
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Feb 11, 2018 at 10:34 AM
-- Server version: 10.1.23-MariaDB-9+deb9u1
-- PHP Version: 7.0.27-0+deb9u1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `RF319`
--

-- --------------------------------------------------------

--
-- Table structure for table `device_translation`
--

CREATE TABLE `device_translation` (
  `idx` int(11) NOT NULL,
  `device_type` int(11) NOT NULL,
  `latch_idx` int(11) NOT NULL,
  `meaning` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32;

-- --------------------------------------------------------

--
-- Table structure for table `device_types`
--

CREATE TABLE `device_types` (
  `idx` int(11) NOT NULL,
  `device_type` int(11) NOT NULL,
  `device_desc` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `ha_field_map`
--

CREATE TABLE `ha_field_map` (
  `idx` int(11) NOT NULL,
  `device_type_idx` int(11) NOT NULL,
  `RTL443_field` varchar(20) NOT NULL,
  `json_field` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `ha_mqtt_channels`
--

CREATE TABLE `ha_mqtt_channels` (
  `idx` int(11) NOT NULL,
  `DESCRIPTION` varchar(40) NOT NULL,
  `MQTT_topic` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32;

-- --------------------------------------------------------

--
-- Table structure for table `known_devices`
--

CREATE TABLE `known_devices` (
  `idx` int(11) NOT NULL,
  `device_idx` int(11) NOT NULL,
  `DESCRIPTION` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32;

-- --------------------------------------------------------

--
-- Table structure for table `log`
--

CREATE TABLE `log` (
  `idx` int(11) NOT NULL,
  `timestamp` int(11) NOT NULL,
  `timestamp_string` varchar(30) DEFAULT NULL,
  `device_idx` int(11) NOT NULL,
  `device_idx_hex` varchar(10) DEFAULT NULL,
  `device_type` int(11) NOT NULL,
  `battery_low` tinyint(1) NOT NULL,
  `latch0` tinyint(1) NOT NULL,
  `latch1` tinyint(1) NOT NULL,
  `latch2` tinyint(1) NOT NULL,
  `latch3` tinyint(1) NOT NULL,
  `latch4` tinyint(1) NOT NULL,
  `raw_message` int(11) NOT NULL,
  `raw_hex` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `device_translation`
--
ALTER TABLE `device_translation`
  ADD PRIMARY KEY (`idx`);

--
-- Indexes for table `device_types`
--
ALTER TABLE `device_types`
  ADD PRIMARY KEY (`idx`);

--
-- Indexes for table `ha_field_map`
--
ALTER TABLE `ha_field_map`
  ADD PRIMARY KEY (`idx`);

--
-- Indexes for table `ha_mqtt_channels`
--
ALTER TABLE `ha_mqtt_channels`
  ADD PRIMARY KEY (`idx`);

--
-- Indexes for table `known_devices`
--
ALTER TABLE `known_devices`
  ADD PRIMARY KEY (`idx`);

--
-- Indexes for table `log`
--
ALTER TABLE `log`
  ADD PRIMARY KEY (`idx`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `device_translation`
--
ALTER TABLE `device_translation`
  MODIFY `idx` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `device_types`
--
ALTER TABLE `device_types`
  MODIFY `idx` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `ha_field_map`
--
ALTER TABLE `ha_field_map`
  MODIFY `idx` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `ha_mqtt_channels`
--
ALTER TABLE `ha_mqtt_channels`
  MODIFY `idx` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;
--
-- AUTO_INCREMENT for table `log`
--
ALTER TABLE `log`
  MODIFY `idx` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=74711;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

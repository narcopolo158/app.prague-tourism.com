-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Počítač: localhost
-- Vytvořeno: Stř 03. čen 2026, 08:58
-- Verze serveru: 10.11.14-MariaDB-0+deb12u2-log
-- Verze PHP: 8.1.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Databáze: `stagingapp`
--
CREATE DATABASE IF NOT EXISTS `stagingapp` DEFAULT CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci;
USE `stagingapp`;

-- --------------------------------------------------------

--
-- Struktura tabulky `admins`
--

CREATE TABLE `admins` (
  `id` int(10) UNSIGNED NOT NULL,
  `email` varchar(190) NOT NULL,
  `name` varchar(120) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `totp_secret` varchar(64) DEFAULT NULL,
  `totp_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `pin_hash` varchar(255) DEFAULT NULL,
  `home_tenant_id` int(10) UNSIGNED DEFAULT NULL,
  `role` enum('owner','manager') NOT NULL,
  `status` enum('active','inactive','archived') NOT NULL DEFAULT 'active',
  `last_login_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Vypisuji data pro tabulku `admins`
--

INSERT INTO `admins` (`id`, `email`, `name`, `password_hash`, `totp_secret`, `totp_enabled`, `pin_hash`, `home_tenant_id`, `role`, `status`, `last_login_at`, `created_at`, `updated_at`) VALUES
(1, 'michal@prague-tourism.com', 'Michal', '$2y$12$UMufEs7cfTqS5SzW70d3mu69hu4G7S71P/gPKEHFu3gw3vCv0OKPe', 'V6TJUE3IMHVQJC4P2MKX5LS4OZLVTH3C', 1, NULL, NULL, 'owner', 'active', '2026-06-02 16:02:45', '2026-05-31 17:04:45', '2026-06-02 16:02:45');

-- --------------------------------------------------------

--
-- Struktura tabulky `admin_recovery_codes`
--

CREATE TABLE `admin_recovery_codes` (
  `id` int(10) UNSIGNED NOT NULL,
  `admin_id` int(10) UNSIGNED NOT NULL,
  `code_hash` varchar(255) NOT NULL,
  `used_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Vypisuji data pro tabulku `admin_recovery_codes`
--

INSERT INTO `admin_recovery_codes` (`id`, `admin_id`, `code_hash`, `used_at`, `created_at`) VALUES
(1, 1, '$2y$12$Gd/cNyiy0YJB9OcwHfOZiO8Of1ACqub4KPF.q3bU08IIM1tdLwxcm', NULL, '2026-05-31 17:04:45'),
(2, 1, '$2y$12$kxCPC/1tRAXBR/B9shOTK.mxQi25kCzMsW3W6FluHCKM1sOxosN/m', NULL, '2026-05-31 17:04:45'),
(3, 1, '$2y$12$HjO018vhqAx4iq38vHerhuYbEPvKg1hwE6FqsQhzbDcPm4441A8hC', NULL, '2026-05-31 17:04:46'),
(4, 1, '$2y$12$pMK9fI.bmeCt8ZDzAxvnYOj6w05fFcDb18p7OroM8fltkPUBZWZoG', NULL, '2026-05-31 17:04:46'),
(5, 1, '$2y$12$TulxChFJxsU9YyxmdXymzuZAy0bahyrbhm3Hrnti6y5sPjuG5/kDy', NULL, '2026-05-31 17:04:46'),
(6, 1, '$2y$12$5zxzHkBE/OOUbN4H1hmZ0uQiOFhZ3QGHwTXrmF9qWbg.8bbKO6wGG', NULL, '2026-05-31 17:04:46'),
(7, 1, '$2y$12$nQGx3OP9SjE70nwVg5rGPeDiJYiSEg5N2Y5EiWxBf9uoTZ42Xwmt.', NULL, '2026-05-31 17:04:47'),
(8, 1, '$2y$12$eg/GS1LmIqi./aqNtb5Z6utUHPgjnaIZ/7MH1vVNxlB1D9r3cYHfe', NULL, '2026-05-31 17:04:47');

-- --------------------------------------------------------

--
-- Struktura tabulky `agencies`
--

CREATE TABLE `agencies` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(150) NOT NULL,
  `brand_color` varchar(9) DEFAULT NULL,
  `logo_url` varchar(255) DEFAULT NULL,
  `contact_name` varchar(120) DEFAULT NULL,
  `contact_email` varchar(190) DEFAULT NULL,
  `contact_phone` varchar(40) DEFAULT NULL,
  `order_instructions` text DEFAULT NULL,
  `default_commission_pct` decimal(5,2) NOT NULL DEFAULT 0.00,
  `payment_model` enum('commission','net_rate','prepaid') NOT NULL DEFAULT 'commission',
  `is_internal` tinyint(1) NOT NULL DEFAULT 0,
  `status` enum('active','inactive','archived') NOT NULL DEFAULT 'active',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deposit_enabled` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Vypisuji data pro tabulku `agencies`
--

INSERT INTO `agencies` (`id`, `name`, `brand_color`, `logo_url`, `contact_name`, `contact_email`, `contact_phone`, `order_instructions`, `default_commission_pct`, `payment_model`, `is_internal`, `status`, `created_at`, `updated_at`, `deposit_enabled`) VALUES
(1, 'Big Bus Tours', NULL, NULL, NULL, NULL, '+420 222 244 244', NULL, 20.00, 'prepaid', 0, 'active', '2026-06-01 06:07:44', '2026-06-01 08:37:00', 0),
(2, 'Premiant', NULL, NULL, NULL, 'info@premiant.cz', '+420 606 600 123', NULL, 20.00, 'prepaid', 0, 'active', '2026-06-01 06:07:44', '2026-06-01 08:37:00', 0),
(3, 'Best Tour', NULL, NULL, NULL, 'besttour@besttour.cz', '+420 602 322 603', NULL, 20.00, 'prepaid', 0, 'active', '2026-06-01 06:07:44', '2026-06-02 13:08:48', 0),
(4, 'Martin Tour', NULL, NULL, NULL, 'info@martintour.cz', '+420 224 212 473', NULL, 20.00, 'prepaid', 0, 'active', '2026-06-01 06:07:44', '2026-06-01 08:37:00', 0),
(5, 'Agency Artistic Intl (AAI)', NULL, NULL, NULL, NULL, NULL, NULL, 20.00, 'prepaid', 0, 'active', '2026-06-01 06:07:44', '2026-06-01 08:37:00', 0),
(6, 'Marie Tycová', NULL, NULL, NULL, NULL, '+420 774 427 600', NULL, 20.00, 'prepaid', 0, 'active', '2026-06-01 06:07:44', '2026-06-01 08:37:00', 0),
(7, 'Mozart Dinner', NULL, NULL, NULL, 'info@mozartdinner.cz', '+420 778 091 222', NULL, 20.00, 'prepaid', 0, 'active', '2026-06-01 06:07:44', '2026-06-01 08:37:00', 0),
(8, 'McGee\'s Trips & Tickets', NULL, NULL, NULL, 'info@mcgeesghosttours.com', '+420 723 306 963', NULL, 20.00, 'prepaid', 0, 'active', '2026-06-01 06:07:44', '2026-06-01 17:53:37', 1),
(9, 'Prague Boats', NULL, NULL, NULL, 'info@pragueboats.cz', '+420 724 202 505', 'Okružní plavby lze prodat přímo. U gastronomických plaveb (oběd/večeře) potvrď rezervaci telefonicky předem.', 20.00, 'prepaid', 0, 'active', '2026-06-01 06:07:44', '2026-06-01 14:47:34', 0),
(10, 'Prague Venice', NULL, NULL, NULL, 'info@prazskebenatky.cz', NULL, NULL, 20.00, 'prepaid', 0, 'active', '2026-06-01 06:07:44', '2026-06-02 13:11:36', 0),
(11, 'U Pavouka', NULL, NULL, NULL, 'groups@upavouka.com', '+420 702 154 432', NULL, 20.00, 'prepaid', 0, 'active', '2026-06-01 06:07:44', '2026-06-02 13:08:48', 0),
(12, 'bm art', NULL, NULL, NULL, NULL, '+420 603 465 561', NULL, 20.00, 'prepaid', 0, 'active', '2026-06-01 06:07:44', '2026-06-01 08:37:00', 0),
(13, 'Folklore Garden', NULL, NULL, NULL, 'info@folkloregarden.cz', '+420 724 334 340', NULL, 20.00, 'prepaid', 0, 'active', '2026-06-01 06:07:44', '2026-06-02 13:05:51', 0),
(14, 'Magical Prague', NULL, NULL, NULL, NULL, NULL, NULL, 20.00, 'prepaid', 0, 'active', '2026-06-01 06:07:44', '2026-06-01 17:53:37', 1),
(15, 'PragueWay', NULL, NULL, NULL, 'info@pragueway.com', '+420 731 238 264', NULL, 20.00, 'prepaid', 1, 'active', '2026-06-01 06:07:44', '2026-06-01 17:53:37', 1),
(16, 'Image Black Light Theatre', NULL, NULL, NULL, 'image@imagetheatre.cz', '+420 222 314 448', NULL, 20.00, 'prepaid', 0, 'active', '2026-06-01 06:07:44', '2026-06-02 13:11:36', 0),
(17, 'Srnec Theatre', NULL, NULL, NULL, 'tickets@srnectheatre.com', '+420 774 574 475', NULL, 20.00, 'prepaid', 0, 'active', '2026-06-01 06:07:44', '2026-06-02 13:11:36', 0),
(18, 'WOW Show', NULL, NULL, NULL, NULL, '+420 777 061 623 / +420 225 113 194', NULL, 20.00, 'prepaid', 0, 'active', '2026-06-01 06:07:44', '2026-06-02 13:11:36', 0),
(19, 'Pilsner Beer Experience', NULL, NULL, NULL, NULL, NULL, NULL, 20.00, 'prepaid', 0, 'inactive', '2026-06-01 06:07:44', '2026-06-01 08:37:00', 0),
(20, 'Story of Prague', NULL, NULL, NULL, NULL, NULL, NULL, 20.00, 'prepaid', 0, 'inactive', '2026-06-01 06:07:44', '2026-06-01 08:37:00', 0),
(21, 'Bohemia Adventures', NULL, NULL, NULL, 'info@bohemiadventures.com', '+420 702 046 321', NULL, 20.00, 'prepaid', 0, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', 0);

-- --------------------------------------------------------

--
-- Struktura tabulky `audit_log`
--

CREATE TABLE `audit_log` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `actor_type` enum('seller','admin','system') NOT NULL,
  `actor_id` int(10) UNSIGNED DEFAULT NULL,
  `tenant_id` int(10) UNSIGNED DEFAULT NULL,
  `action` varchar(80) NOT NULL,
  `target_type` varchar(60) DEFAULT NULL,
  `target_id` varchar(60) DEFAULT NULL,
  `diff_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`diff_json`)),
  `reason` varchar(255) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Vypisuji data pro tabulku `audit_log`
--

INSERT INTO `audit_log` (`id`, `actor_type`, `actor_id`, `tenant_id`, `action`, `target_type`, `target_id`, `diff_json`, `reason`, `ip_address`, `created_at`) VALUES
(1, 'admin', 1, 1, 'seller.create', 'seller', '1', NULL, NULL, '90.180.55.48', '2026-05-31 17:09:35'),
(2, 'admin', 1, NULL, 'product.update', 'product', '6', NULL, NULL, '90.180.55.48', '2026-06-01 07:03:44'),
(3, 'admin', 1, NULL, 'product.update', 'product', '118', NULL, NULL, '90.180.55.48', '2026-06-01 17:34:03'),
(4, 'admin', 1, NULL, 'product.update', 'product', '17', NULL, NULL, '90.180.55.48', '2026-06-02 16:05:26'),
(5, 'seller', 1, NULL, 'sale.cancel', 'sale', '13', '{\"status\":{\"from\":\"paid\",\"to\":\"cancelled\"},\"voucher\":\"PTI-2026-000013\",\"total_czk\":\"6460.00\",\"realised\":false,\"approved_by\":null}', 'Debil', NULL, '2026-06-02 17:22:04'),
(6, 'admin', 1, NULL, 'product.update', 'product', '17', NULL, NULL, '90.180.55.48', '2026-06-02 18:08:32');

-- --------------------------------------------------------

--
-- Struktura tabulky `categories`
--

CREATE TABLE `categories` (
  `id` int(10) UNSIGNED NOT NULL,
  `name_cs` varchar(100) NOT NULL,
  `name_en` varchar(100) DEFAULT NULL,
  `name_de` varchar(100) DEFAULT NULL,
  `icon` varchar(60) DEFAULT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `status` enum('active','inactive','archived') NOT NULL DEFAULT 'active',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Vypisuji data pro tabulku `categories`
--

INSERT INTO `categories` (`id`, `name_cs`, `name_en`, `name_de`, `icon`, `sort_order`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Prohlídkové jízdy', 'Sightseeing', 'Stadtrundfahrten', 'bus', 10, 'active', '2026-05-31 16:40:47', '2026-05-31 16:40:47'),
(2, 'Procházky', 'Walking tours', 'Stadtführungen', 'walk', 20, 'active', '2026-05-31 16:40:47', '2026-05-31 16:40:47'),
(3, 'Lodě a plavby', 'Boats & cruises', 'Bootsfahrten', 'ship', 30, 'active', '2026-05-31 16:40:47', '2026-05-31 16:40:47'),
(4, 'Koncerty', 'Concerts', 'Konzerte', 'music', 40, 'active', '2026-05-31 16:40:47', '2026-05-31 16:40:47'),
(5, 'Divadlo a show', 'Theatre & shows', 'Theater & Shows', 'masks-theater', 50, 'active', '2026-05-31 16:40:47', '2026-05-31 16:40:47'),
(6, 'Večeře a zážitky', 'Dinner & experiences', 'Dinner & Erlebnisse', 'tools-kitchen-2', 60, 'active', '2026-05-31 16:40:47', '2026-05-31 16:40:47'),
(7, 'Výlety z Prahy', 'Day trips', 'Tagesausflüge', 'map-pin', 70, 'active', '2026-05-31 16:40:47', '2026-05-31 16:40:47'),
(8, 'Ghost tours', 'Ghost tours', 'Geistertouren', 'ghost', 80, 'active', '2026-05-31 16:40:47', '2026-05-31 16:40:47'),
(9, 'Aktivity', 'Activities', 'Aktivitäten', 'run', 90, 'active', '2026-06-01 06:52:56', '2026-06-01 06:52:56');

-- --------------------------------------------------------

--
-- Struktura tabulky `customers`
--

CREATE TABLE `customers` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(190) DEFAULT NULL,
  `email` varchar(190) DEFAULT NULL,
  `phone` varchar(60) DEFAULT NULL,
  `language` enum('cs','en','de') NOT NULL DEFAULT 'en',
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Vypisuji data pro tabulku `customers`
--

INSERT INTO `customers` (`id`, `name`, `email`, `phone`, `language`, `notes`, `created_at`) VALUES
(1, 'Dušan', NULL, NULL, 'en', NULL, '2026-06-01 17:54:43'),
(2, 'Josef', NULL, NULL, 'en', NULL, '2026-06-01 17:57:20'),
(3, 'Pepa', NULL, NULL, 'en', NULL, '2026-06-01 19:54:32'),
(4, 'Fanda', NULL, NULL, 'en', NULL, '2026-06-01 20:00:51'),
(5, 'Grundza', NULL, NULL, 'en', NULL, '2026-06-01 20:06:40'),
(6, 'Frantusek', NULL, NULL, 'en', NULL, '2026-06-01 21:12:52'),
(7, 'Karel Vyskočil', NULL, NULL, 'en', NULL, '2026-06-02 13:20:12'),
(8, 'Karel Fetak', NULL, NULL, 'en', NULL, '2026-06-02 15:13:28'),
(9, 'Karel Čurák', NULL, NULL, 'en', NULL, '2026-06-02 16:15:54'),
(10, 'Ada', 'fggt@hjuu', NULL, 'en', NULL, '2026-06-02 17:17:12'),
(11, 'Sdr', NULL, NULL, 'en', NULL, '2026-06-02 17:21:50'),
(12, 'AdA', NULL, NULL, 'en', NULL, '2026-06-02 17:26:06'),
(13, 'Josef', NULL, NULL, 'en', NULL, '2026-06-02 17:27:35'),
(14, 'Dušan Kedluben', NULL, NULL, 'en', NULL, '2026-06-02 18:15:50'),
(15, 'Kedluben', NULL, NULL, 'en', NULL, '2026-06-02 18:35:21'),
(16, 'Zeli', NULL, NULL, 'en', NULL, '2026-06-02 18:45:54'),
(17, 'Straka', NULL, NULL, 'en', NULL, '2026-06-02 18:58:07'),
(18, 'Fero', NULL, NULL, 'en', NULL, '2026-06-02 19:02:32'),
(19, 'Eva Bärtlovà', NULL, NULL, 'en', NULL, '2026-06-02 19:06:27'),
(20, 'Jan', NULL, NULL, 'en', NULL, '2026-06-02 20:04:29');

-- --------------------------------------------------------

--
-- Struktura tabulky `login_attempts`
--

CREATE TABLE `login_attempts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `scope` enum('pin','admin','escalation') NOT NULL,
  `identifier` varchar(190) NOT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `success` tinyint(1) NOT NULL DEFAULT 0,
  `attempted_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Vypisuji data pro tabulku `login_attempts`
--

INSERT INTO `login_attempts` (`id`, `scope`, `identifier`, `ip_address`, `success`, `attempted_at`) VALUES
(1, 'admin', 'michal@prague-tourism.com', '90.180.55.48', 1, '2026-05-31 17:08:12'),
(2, 'pin', 'tenant:1', '90.180.55.48', 1, '2026-05-31 17:11:44'),
(3, 'admin', 'michal@prague-tourism.com', '90.180.55.48', 1, '2026-05-31 17:25:41'),
(4, 'pin', 'tenant:1', '90.180.55.48', 1, '2026-05-31 17:27:44'),
(5, 'admin', 'michal@prague-tourism.com', '90.180.55.48', 1, '2026-05-31 17:28:16'),
(6, 'pin', 'tenant:1', '37.188.140.44', 1, '2026-05-31 17:39:00'),
(7, 'pin', 'tenant:2', '37.188.140.44', 0, '2026-05-31 17:39:33'),
(8, 'pin', 'tenant:1', '37.188.140.44', 1, '2026-05-31 17:40:09'),
(9, 'pin', 'tenant:1', '90.180.55.48', 1, '2026-06-01 04:32:06'),
(10, 'admin', 'michal@prague-tourism.com', '90.180.55.48', 1, '2026-06-01 05:50:30'),
(11, 'admin', 'michal@prague-tourism.com', '37.188.201.156', 1, '2026-06-01 06:26:05'),
(12, 'pin', 'tenant:1', '90.180.55.48', 1, '2026-06-01 07:05:40'),
(13, 'admin', 'michal@prague-tourism.com', '90.180.55.48', 1, '2026-06-01 07:10:17'),
(14, 'pin', 'tenant:1', '90.180.55.48', 1, '2026-06-01 08:08:24'),
(15, 'admin', 'michal@prague-tourism.com', '90.180.55.48', 1, '2026-06-01 08:37:34'),
(16, 'pin', 'tenant:1', '90.180.55.48', 1, '2026-06-01 08:53:35'),
(17, 'pin', 'tenant:1', '90.180.55.48', 1, '2026-06-01 10:12:07'),
(18, 'pin', 'tenant:1', '90.180.55.48', 1, '2026-06-01 10:16:49'),
(19, 'pin', 'tenant:1', '90.180.55.48', 1, '2026-06-01 16:43:24'),
(20, 'admin', 'michal@prague-tourism.com', '90.180.55.48', 1, '2026-06-01 17:31:28'),
(21, 'pin', 'tenant:1', '90.180.55.48', 1, '2026-06-01 17:34:18'),
(22, 'pin', 'tenant:1', '90.180.55.48', 1, '2026-06-01 17:43:11'),
(23, 'pin', 'tenant:1', '90.180.55.48', 1, '2026-06-01 17:54:06'),
(24, 'pin', 'tenant:1', '90.180.55.48', 1, '2026-06-01 19:53:07'),
(25, 'pin', 'tenant:1', '90.180.55.48', 1, '2026-06-02 04:53:16'),
(26, 'pin', 'tenant:1', '90.180.55.48', 1, '2026-06-02 05:59:46'),
(27, 'pin', 'tenant:1', '90.180.55.48', 1, '2026-06-02 06:25:14'),
(28, 'pin', 'tenant:1', '90.180.55.48', 1, '2026-06-02 13:13:43'),
(29, 'pin', 'tenant:1', '90.180.55.48', 1, '2026-06-02 13:43:57'),
(30, 'admin', 'michal@prague-tourism.com', '90.180.55.48', 1, '2026-06-02 16:02:29'),
(31, 'pin', 'tenant:1', '90.180.55.48', 1, '2026-06-02 16:05:58'),
(32, 'pin', 'tenant:1', '90.180.55.48', 1, '2026-06-02 16:14:28'),
(33, 'pin', 'tenant:1', '90.180.55.48', 1, '2026-06-02 17:14:05'),
(34, 'pin', 'tenant:1', '90.180.55.48', 1, '2026-06-03 05:50:23');

-- --------------------------------------------------------

--
-- Struktura tabulky `pickups`
--

CREATE TABLE `pickups` (
  `id` int(10) UNSIGNED NOT NULL,
  `sale_item_id` int(10) UNSIGNED NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `pickup_time` varchar(60) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `status` enum('pending','confirmed','done','cancelled') NOT NULL DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Vypisuji data pro tabulku `pickups`
--

INSERT INTO `pickups` (`id`, `sale_item_id`, `address`, `pickup_time`, `notes`, `status`, `created_at`) VALUES
(1, 23, 'Brix', '8:15', NULL, 'pending', '2026-06-02 18:58:07'),
(2, 25, 'Hotel Avion', '8:00', NULL, 'pending', '2026-06-02 19:06:27');

-- --------------------------------------------------------

--
-- Struktura tabulky `prices`
--

CREATE TABLE `prices` (
  `id` int(10) UNSIGNED NOT NULL,
  `pricing_version_id` int(10) UNSIGNED NOT NULL,
  `cell_key` varchar(255) NOT NULL,
  `dimension_values_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`dimension_values_json`)),
  `czk` decimal(10,2) NOT NULL,
  `eur` decimal(10,2) DEFAULT NULL,
  `is_override` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Vypisuji data pro tabulku `prices`
--

INSERT INTO `prices` (`id`, `pricing_version_id`, `cell_key`, `dimension_values_json`, `czk`, `eur`, `is_override`, `created_at`, `updated_at`) VALUES
(25, 2, '{\"3\":\"VIP (rows 1-6)\",\"4\":\"Adult\"}', '{\"3\":\"VIP (rows 1-6)\",\"4\":\"Adult\"}', 1200.00, 48.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(26, 2, '{\"3\":\"VIP (rows 1-6)\",\"4\":\"Student-ISIC\"}', '{\"3\":\"VIP (rows 1-6)\",\"4\":\"Student-ISIC\"}', 1100.00, 44.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(27, 2, '{\"3\":\"Cat A (rows 7-12)\",\"4\":\"Adult\"}', '{\"3\":\"Cat A (rows 7-12)\",\"4\":\"Adult\"}', 1000.00, 40.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(28, 2, '{\"3\":\"Cat A (rows 7-12)\",\"4\":\"Student-ISIC\"}', '{\"3\":\"Cat A (rows 7-12)\",\"4\":\"Student-ISIC\"}', 900.00, 36.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(29, 2, '{\"3\":\"Cat B (rows 13-18)\",\"4\":\"Adult\"}', '{\"3\":\"Cat B (rows 13-18)\",\"4\":\"Adult\"}', 800.00, 32.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(30, 2, '{\"3\":\"Cat B (rows 13-18)\",\"4\":\"Student-ISIC\"}', '{\"3\":\"Cat B (rows 13-18)\",\"4\":\"Student-ISIC\"}', 700.00, 28.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(31, 3, '{\"5\":\"VIP (rows 1-6)\",\"6\":\"Adult\"}', '{\"5\":\"VIP (rows 1-6)\",\"6\":\"Adult\"}', 1200.00, 48.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(32, 3, '{\"5\":\"VIP (rows 1-6)\",\"6\":\"Student-ISIC\"}', '{\"5\":\"VIP (rows 1-6)\",\"6\":\"Student-ISIC\"}', 1100.00, 44.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(33, 3, '{\"5\":\"Cat A (rows 7-12)\",\"6\":\"Adult\"}', '{\"5\":\"Cat A (rows 7-12)\",\"6\":\"Adult\"}', 1000.00, 40.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(34, 3, '{\"5\":\"Cat A (rows 7-12)\",\"6\":\"Student-ISIC\"}', '{\"5\":\"Cat A (rows 7-12)\",\"6\":\"Student-ISIC\"}', 900.00, 36.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(35, 3, '{\"5\":\"Cat B (rows 13-18)\",\"6\":\"Adult\"}', '{\"5\":\"Cat B (rows 13-18)\",\"6\":\"Adult\"}', 800.00, 32.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(36, 3, '{\"5\":\"Cat B (rows 13-18)\",\"6\":\"Student-ISIC\"}', '{\"5\":\"Cat B (rows 13-18)\",\"6\":\"Student-ISIC\"}', 700.00, 28.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(37, 4, '{\"7\":\"Adult\"}', '{\"7\":\"Adult\"}', 1000.00, 40.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(38, 4, '{\"7\":\"Senior 65+\"}', '{\"7\":\"Senior 65+\"}', 900.00, 36.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(39, 4, '{\"7\":\"Student 16-21\"}', '{\"7\":\"Student 16-21\"}', 900.00, 36.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(40, 4, '{\"7\":\"Child 7-15\"}', '{\"7\":\"Child 7-15\"}', 500.00, 20.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(41, 4, '{\"7\":\"Child 0-6\"}', '{\"7\":\"Child 0-6\"}', 0.00, 0.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(42, 5, '{\"8\":\"Adult\"}', '{\"8\":\"Adult\"}', 1000.00, 40.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(43, 5, '{\"8\":\"Senior 65+\"}', '{\"8\":\"Senior 65+\"}', 900.00, 36.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(44, 5, '{\"8\":\"Student 16-21\"}', '{\"8\":\"Student 16-21\"}', 900.00, 36.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(45, 5, '{\"8\":\"Child 7-15\"}', '{\"8\":\"Child 7-15\"}', 500.00, 20.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(46, 5, '{\"8\":\"Child 0-6\"}', '{\"8\":\"Child 0-6\"}', 0.00, 0.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(47, 6, '{\"9\":\"Adult\"}', '{\"9\":\"Adult\"}', 1000.00, 40.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(48, 6, '{\"9\":\"Senior 65+\"}', '{\"9\":\"Senior 65+\"}', 900.00, 36.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(49, 6, '{\"9\":\"Student 16-21\"}', '{\"9\":\"Student 16-21\"}', 900.00, 36.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(50, 6, '{\"9\":\"Child 7-15\"}', '{\"9\":\"Child 7-15\"}', 500.00, 20.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(51, 6, '{\"9\":\"Child 0-6\"}', '{\"9\":\"Child 0-6\"}', 0.00, 0.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(52, 7, '{\"10\":\"Adult\"}', '{\"10\":\"Adult\"}', 1000.00, 40.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(53, 7, '{\"10\":\"Senior 65+\"}', '{\"10\":\"Senior 65+\"}', 900.00, 36.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(54, 7, '{\"10\":\"Student 16-21\"}', '{\"10\":\"Student 16-21\"}', 900.00, 36.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(55, 7, '{\"10\":\"Child 7-15\"}', '{\"10\":\"Child 7-15\"}', 500.00, 20.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(56, 7, '{\"10\":\"Child 0-6\"}', '{\"10\":\"Child 0-6\"}', 0.00, 0.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(57, 8, '{\"11\":\"VIP zone\"}', '{\"11\":\"VIP zone\"}', 1450.00, 58.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(58, 8, '{\"11\":\"A zone\"}', '{\"11\":\"A zone\"}', 1250.00, 50.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(59, 8, '{\"11\":\"B zone\"}', '{\"11\":\"B zone\"}', 1050.00, 42.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(60, 8, '{\"11\":\"C zone\"}', '{\"11\":\"C zone\"}', 850.00, 34.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(61, 9, '{\"12\":\"A (orchestr\\/front rows)\"}', '{\"12\":\"A (orchestr\\/front rows)\"}', 800.00, 32.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(62, 9, '{\"12\":\"B (rear rows)\"}', '{\"12\":\"B (rear rows)\"}', 600.00, 24.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(71, 11, '{\"15\":\"Adult\"}', '{\"15\":\"Adult\"}', 780.00, 31.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(72, 11, '{\"15\":\"Family (2A+3C 5-15)\"}', '{\"15\":\"Family (2A+3C 5-15)\"}', 1820.00, 73.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(73, 12, '{\"16\":\"Adult\"}', '{\"16\":\"Adult\"}', 900.00, 36.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(74, 12, '{\"16\":\"Family (2A+3C 5-15)\"}', '{\"16\":\"Family (2A+3C 5-15)\"}', 2070.00, 83.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(75, 13, '{\"17\":\"Adult\"}', '{\"17\":\"Adult\"}', 1020.00, 41.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(76, 13, '{\"17\":\"Family (2A+3C 5-15)\"}', '{\"17\":\"Family (2A+3C 5-15)\"}', 2400.00, 96.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(115, 19, '{\"27\":\"Lowest seating\"}', '{\"27\":\"Lowest seating\"}', 5890.00, 236.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(116, 19, '{\"27\":\"Premium seating\"}', '{\"27\":\"Premium seating\"}', 7890.00, 316.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(117, 20, '{\"28\":\"Lowest seating\"}', '{\"28\":\"Lowest seating\"}', 11990.00, 480.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(118, 20, '{\"28\":\"Premium seating\"}', '{\"28\":\"Premium seating\"}', 15990.00, 640.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(125, 23, '[]', '[]', 1990.00, 80.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(174, 48, '{\"56\":\"Dospělý\"}', '{\"56\":\"Dospělý\"}', 800.00, 32.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(175, 48, '{\"56\":\"Dítě\"}', '{\"56\":\"Dítě\"}', 400.00, 16.00, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(332, 121, '{\"101\":\"Discover\",\"102\":\"Adult\"}', '{\"101\":\"Discover\",\"102\":\"Adult\"}', 780.00, 31.00, 0, '2026-06-01 13:46:16', '2026-06-01 13:46:16'),
(333, 121, '{\"101\":\"Discover\",\"102\":\"Family (2A+3C 5-15)\"}', '{\"101\":\"Discover\",\"102\":\"Family (2A+3C 5-15)\"}', 1820.00, 73.00, 0, '2026-06-01 13:46:16', '2026-06-01 13:46:16'),
(334, 121, '{\"101\":\"Essential\",\"102\":\"Adult\"}', '{\"101\":\"Essential\",\"102\":\"Adult\"}', 900.00, 36.00, 0, '2026-06-01 13:46:16', '2026-06-01 13:46:16'),
(335, 121, '{\"101\":\"Essential\",\"102\":\"Family (2A+3C 5-15)\"}', '{\"101\":\"Essential\",\"102\":\"Family (2A+3C 5-15)\"}', 2070.00, 83.00, 0, '2026-06-01 13:46:16', '2026-06-01 13:46:16'),
(336, 121, '{\"101\":\"Explore\",\"102\":\"Adult\"}', '{\"101\":\"Explore\",\"102\":\"Adult\"}', 1020.00, 41.00, 0, '2026-06-01 13:46:16', '2026-06-01 13:46:16'),
(337, 121, '{\"101\":\"Explore\",\"102\":\"Family (2A+3C 5-15)\"}', '{\"101\":\"Explore\",\"102\":\"Family (2A+3C 5-15)\"}', 2400.00, 96.00, 0, '2026-06-01 13:46:16', '2026-06-01 13:46:16'),
(338, 121, '{\"101\":\"Panoramic\",\"102\":\"Adult\"}', '{\"101\":\"Panoramic\",\"102\":\"Adult\"}', 380.00, 15.00, 0, '2026-06-01 13:46:16', '2026-06-01 13:46:16'),
(339, 121, '{\"101\":\"Panoramic\",\"102\":\"Child 5-15\"}', '{\"101\":\"Panoramic\",\"102\":\"Child 5-15\"}', 270.00, 11.00, 0, '2026-06-01 13:46:16', '2026-06-01 13:46:16'),
(340, 121, '{\"101\":\"Panoramic\",\"102\":\"Infant 0-4\"}', '{\"101\":\"Panoramic\",\"102\":\"Infant 0-4\"}', 0.00, 0.00, 0, '2026-06-01 13:46:16', '2026-06-01 13:46:16'),
(347, 122, '{\"103\":\"Standard\"}', '{\"103\":\"Standard\"}', 1000.00, 40.00, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(348, 122, '{\"103\":\"Senior 65+\"}', '{\"103\":\"Senior 65+\"}', 900.00, 36.00, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(349, 122, '{\"103\":\"Student 16-21\"}', '{\"103\":\"Student 16-21\"}', 900.00, 36.00, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(350, 122, '{\"103\":\"Child 7-15\"}', '{\"103\":\"Child 7-15\"}', 500.00, 20.00, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(351, 122, '{\"103\":\"Child 0-6\"}', '{\"103\":\"Child 0-6\"}', 0.00, 0.00, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(352, 123, '{\"104\":\"Standard\"}', '{\"104\":\"Standard\"}', 1000.00, 40.00, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(353, 123, '{\"104\":\"Senior 65+\"}', '{\"104\":\"Senior 65+\"}', 900.00, 36.00, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(354, 123, '{\"104\":\"Student 16-21\"}', '{\"104\":\"Student 16-21\"}', 900.00, 36.00, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(355, 123, '{\"104\":\"Child 7-15\"}', '{\"104\":\"Child 7-15\"}', 500.00, 20.00, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(356, 123, '{\"104\":\"Child 0-6\"}', '{\"104\":\"Child 0-6\"}', 0.00, 0.00, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(357, 124, '{\"105\":\"Standard\"}', '{\"105\":\"Standard\"}', 1000.00, 40.00, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(358, 124, '{\"105\":\"Senior 65+\"}', '{\"105\":\"Senior 65+\"}', 900.00, 36.00, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(359, 124, '{\"105\":\"Student 16-21\"}', '{\"105\":\"Student 16-21\"}', 900.00, 36.00, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(360, 124, '{\"105\":\"Child 7-15\"}', '{\"105\":\"Child 7-15\"}', 500.00, 20.00, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(361, 124, '{\"105\":\"Child 0-6\"}', '{\"105\":\"Child 0-6\"}', 0.00, 0.00, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(362, 125, '{\"106\":\"Standard\"}', '{\"106\":\"Standard\"}', 1000.00, 40.00, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(363, 125, '{\"106\":\"Senior 65+\"}', '{\"106\":\"Senior 65+\"}', 900.00, 36.00, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(364, 125, '{\"106\":\"Student 16-21\"}', '{\"106\":\"Student 16-21\"}', 900.00, 36.00, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(365, 125, '{\"106\":\"Child 7-15\"}', '{\"106\":\"Child 7-15\"}', 500.00, 20.00, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(366, 125, '{\"106\":\"Child 0-6\"}', '{\"106\":\"Child 0-6\"}', 0.00, 0.00, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(367, 126, '{\"107\":\"VIP (rows 1-6)\",\"108\":\"Adult\"}', '{\"107\":\"VIP (rows 1-6)\",\"108\":\"Adult\"}', 1200.00, 48.00, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(368, 126, '{\"107\":\"VIP (rows 1-6)\",\"108\":\"Student\"}', '{\"107\":\"VIP (rows 1-6)\",\"108\":\"Student\"}', 1100.00, 44.00, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(369, 126, '{\"107\":\"Cat A (rows 7-12)\",\"108\":\"Adult\"}', '{\"107\":\"Cat A (rows 7-12)\",\"108\":\"Adult\"}', 1000.00, 40.00, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(370, 126, '{\"107\":\"Cat A (rows 7-12)\",\"108\":\"Student\"}', '{\"107\":\"Cat A (rows 7-12)\",\"108\":\"Student\"}', 900.00, 36.00, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(371, 126, '{\"107\":\"Cat B (rows 13-18)\",\"108\":\"Adult\"}', '{\"107\":\"Cat B (rows 13-18)\",\"108\":\"Adult\"}', 800.00, 32.00, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(372, 126, '{\"107\":\"Cat B (rows 13-18)\",\"108\":\"Student\"}', '{\"107\":\"Cat B (rows 13-18)\",\"108\":\"Student\"}', 700.00, 28.00, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(373, 127, '{\"109\":\"VIP (rows 1-6)\",\"110\":\"Adult\"}', '{\"109\":\"VIP (rows 1-6)\",\"110\":\"Adult\"}', 1200.00, 48.00, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(374, 127, '{\"109\":\"VIP (rows 1-6)\",\"110\":\"Student\"}', '{\"109\":\"VIP (rows 1-6)\",\"110\":\"Student\"}', 1100.00, 44.00, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(375, 127, '{\"109\":\"Cat A (rows 7-12)\",\"110\":\"Adult\"}', '{\"109\":\"Cat A (rows 7-12)\",\"110\":\"Adult\"}', 1000.00, 40.00, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(376, 127, '{\"109\":\"Cat A (rows 7-12)\",\"110\":\"Student\"}', '{\"109\":\"Cat A (rows 7-12)\",\"110\":\"Student\"}', 900.00, 36.00, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(377, 127, '{\"109\":\"Cat B (rows 13-18)\",\"110\":\"Adult\"}', '{\"109\":\"Cat B (rows 13-18)\",\"110\":\"Adult\"}', 800.00, 32.00, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(378, 127, '{\"109\":\"Cat B (rows 13-18)\",\"110\":\"Student\"}', '{\"109\":\"Cat B (rows 13-18)\",\"110\":\"Student\"}', 700.00, 28.00, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(379, 128, '{\"111\":\"VIP\"}', '{\"111\":\"VIP\"}', 1450.00, 58.00, 0, '2026-06-02 13:02:20', '2026-06-02 13:02:20'),
(380, 128, '{\"111\":\"A\"}', '{\"111\":\"A\"}', 1250.00, 50.00, 0, '2026-06-02 13:02:20', '2026-06-02 13:02:20'),
(381, 128, '{\"111\":\"B\"}', '{\"111\":\"B\"}', 1050.00, 42.00, 0, '2026-06-02 13:02:20', '2026-06-02 13:02:20'),
(382, 128, '{\"111\":\"C\"}', '{\"111\":\"C\"}', 850.00, 34.00, 0, '2026-06-02 13:02:20', '2026-06-02 13:02:20'),
(383, 129, '{\"112\":\"A\"}', '{\"112\":\"A\"}', 800.00, 32.00, 0, '2026-06-02 13:02:20', '2026-06-02 13:02:20'),
(384, 129, '{\"112\":\"B\"}', '{\"112\":\"B\"}', 600.00, 24.00, 0, '2026-06-02 13:02:20', '2026-06-02 13:02:20'),
(385, 130, '{\"113\":\"Letní (od 1.5.)\",\"114\":\"Table 8\"}', '{\"113\":\"Letní (od 1.5.)\",\"114\":\"Table 8\"}', 3590.00, 144.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(386, 130, '{\"113\":\"Zimní (do 30.4.)\",\"114\":\"Table 8\"}', '{\"113\":\"Zimní (do 30.4.)\",\"114\":\"Table 8\"}', 2970.00, 119.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(387, 130, '{\"113\":\"Letní (od 1.5.)\",\"114\":\"Table 2\"}', '{\"113\":\"Letní (od 1.5.)\",\"114\":\"Table 2\"}', 4190.00, 168.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(388, 130, '{\"113\":\"Zimní (do 30.4.)\",\"114\":\"Table 2\"}', '{\"113\":\"Zimní (do 30.4.)\",\"114\":\"Table 2\"}', 3620.00, 145.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(389, 130, '{\"113\":\"Letní (od 1.5.)\",\"114\":\"Table 2 front row\"}', '{\"113\":\"Letní (od 1.5.)\",\"114\":\"Table 2 front row\"}', 4690.00, 188.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(390, 130, '{\"113\":\"Zimní (do 30.4.)\",\"114\":\"Table 2 front row\"}', '{\"113\":\"Zimní (do 30.4.)\",\"114\":\"Table 2 front row\"}', 4620.00, 185.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(391, 130, '{\"113\":\"Letní (od 1.5.)\",\"114\":\"Balcony box\"}', '{\"113\":\"Letní (od 1.5.)\",\"114\":\"Balcony box\"}', 4690.00, 188.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(392, 130, '{\"113\":\"Zimní (do 30.4.)\",\"114\":\"Balcony box\"}', '{\"113\":\"Zimní (do 30.4.)\",\"114\":\"Balcony box\"}', 4620.00, 185.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(393, 130, '{\"113\":\"Letní (od 1.5.)\",\"114\":\"Child <12\"}', '{\"113\":\"Letní (od 1.5.)\",\"114\":\"Child <12\"}', 1840.00, 74.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(394, 130, '{\"113\":\"Zimní (do 30.4.)\",\"114\":\"Child <12\"}', '{\"113\":\"Zimní (do 30.4.)\",\"114\":\"Child <12\"}', 1840.00, 74.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(395, 131, '{\"115\":\"Letní (od 1.5.)\",\"116\":\"Table 8\"}', '{\"115\":\"Letní (od 1.5.)\",\"116\":\"Table 8\"}', 2900.00, 116.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(396, 131, '{\"115\":\"Zimní (do 30.4.)\",\"116\":\"Table 8\"}', '{\"115\":\"Zimní (do 30.4.)\",\"116\":\"Table 8\"}', 2340.00, 94.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(397, 131, '{\"115\":\"Letní (od 1.5.)\",\"116\":\"Table 2\"}', '{\"115\":\"Letní (od 1.5.)\",\"116\":\"Table 2\"}', 3500.00, 140.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(398, 131, '{\"115\":\"Zimní (do 30.4.)\",\"116\":\"Table 2\"}', '{\"115\":\"Zimní (do 30.4.)\",\"116\":\"Table 2\"}', 2990.00, 120.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(399, 131, '{\"115\":\"Letní (od 1.5.)\",\"116\":\"Table 2 front row\"}', '{\"115\":\"Letní (od 1.5.)\",\"116\":\"Table 2 front row\"}', 4000.00, 160.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(400, 131, '{\"115\":\"Zimní (do 30.4.)\",\"116\":\"Table 2 front row\"}', '{\"115\":\"Zimní (do 30.4.)\",\"116\":\"Table 2 front row\"}', 3990.00, 160.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(401, 131, '{\"115\":\"Letní (od 1.5.)\",\"116\":\"Balcony box\"}', '{\"115\":\"Letní (od 1.5.)\",\"116\":\"Balcony box\"}', 4000.00, 160.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(402, 131, '{\"115\":\"Zimní (do 30.4.)\",\"116\":\"Balcony box\"}', '{\"115\":\"Zimní (do 30.4.)\",\"116\":\"Balcony box\"}', 3990.00, 160.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(403, 131, '{\"115\":\"Letní (od 1.5.)\",\"116\":\"Child <12\"}', '{\"115\":\"Letní (od 1.5.)\",\"116\":\"Child <12\"}', 1590.00, 64.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(404, 131, '{\"115\":\"Zimní (do 30.4.)\",\"116\":\"Child <12\"}', '{\"115\":\"Zimní (do 30.4.)\",\"116\":\"Child <12\"}', 1590.00, 64.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(405, 132, '{\"117\":\"Letní (od 1.5.)\",\"118\":\"Table 8\"}', '{\"117\":\"Letní (od 1.5.)\",\"118\":\"Table 8\"}', 2300.00, 92.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(406, 132, '{\"117\":\"Zimní (do 30.4.)\",\"118\":\"Table 8\"}', '{\"117\":\"Zimní (do 30.4.)\",\"118\":\"Table 8\"}', 1740.00, 70.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(407, 132, '{\"117\":\"Letní (od 1.5.)\",\"118\":\"Table 2\"}', '{\"117\":\"Letní (od 1.5.)\",\"118\":\"Table 2\"}', 2900.00, 116.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(408, 132, '{\"117\":\"Zimní (do 30.4.)\",\"118\":\"Table 2\"}', '{\"117\":\"Zimní (do 30.4.)\",\"118\":\"Table 2\"}', 2390.00, 96.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(409, 132, '{\"117\":\"Letní (od 1.5.)\",\"118\":\"Table 2 front row\"}', '{\"117\":\"Letní (od 1.5.)\",\"118\":\"Table 2 front row\"}', 3400.00, 136.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(410, 132, '{\"117\":\"Zimní (do 30.4.)\",\"118\":\"Table 2 front row\"}', '{\"117\":\"Zimní (do 30.4.)\",\"118\":\"Table 2 front row\"}', 3390.00, 136.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(411, 132, '{\"117\":\"Letní (od 1.5.)\",\"118\":\"Balcony box\"}', '{\"117\":\"Letní (od 1.5.)\",\"118\":\"Balcony box\"}', 3400.00, 136.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(412, 132, '{\"117\":\"Zimní (do 30.4.)\",\"118\":\"Balcony box\"}', '{\"117\":\"Zimní (do 30.4.)\",\"118\":\"Balcony box\"}', 3390.00, 136.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(413, 132, '{\"117\":\"Letní (od 1.5.)\",\"118\":\"Child <12\"}', '{\"117\":\"Letní (od 1.5.)\",\"118\":\"Child <12\"}', 1290.00, 52.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(414, 132, '{\"117\":\"Zimní (do 30.4.)\",\"118\":\"Child <12\"}', '{\"117\":\"Zimní (do 30.4.)\",\"118\":\"Child <12\"}', 1290.00, 52.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(415, 133, '{\"119\":\"Letní (od 1.5.)\",\"120\":\"Balcony box\"}', '{\"119\":\"Letní (od 1.5.)\",\"120\":\"Balcony box\"}', 8000.00, 320.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(416, 133, '{\"119\":\"Zimní (do 30.4.)\",\"120\":\"Balcony box\"}', '{\"119\":\"Zimní (do 30.4.)\",\"120\":\"Balcony box\"}', 7990.00, 320.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(417, 134, '{\"121\":\"Triple Pack\",\"122\":\"1-9 osob\"}', '{\"121\":\"Triple Pack\",\"122\":\"1-9 osob\"}', 2300.00, 95.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(418, 134, '{\"121\":\"Triple Pack\",\"122\":\"10-14 osob\"}', '{\"121\":\"Triple Pack\",\"122\":\"10-14 osob\"}', 2100.00, 85.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(419, 134, '{\"121\":\"Triple Pack\",\"122\":\"15+ osob\"}', '{\"121\":\"Triple Pack\",\"122\":\"15+ osob\"}', 2000.00, 80.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(420, 134, '{\"121\":\"Four Pack\",\"122\":\"1-9 osob\"}', '{\"121\":\"Four Pack\",\"122\":\"1-9 osob\"}', 2700.00, 110.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(421, 134, '{\"121\":\"Four Pack\",\"122\":\"10-14 osob\"}', '{\"121\":\"Four Pack\",\"122\":\"10-14 osob\"}', 2500.00, 100.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(422, 134, '{\"121\":\"Four Pack\",\"122\":\"15+ osob\"}', '{\"121\":\"Four Pack\",\"122\":\"15+ osob\"}', 2400.00, 95.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(423, 134, '{\"121\":\"Five Pack\",\"122\":\"1-9 osob\"}', '{\"121\":\"Five Pack\",\"122\":\"1-9 osob\"}', 3000.00, 125.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(424, 134, '{\"121\":\"Five Pack\",\"122\":\"10-14 osob\"}', '{\"121\":\"Five Pack\",\"122\":\"10-14 osob\"}', 2800.00, 115.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(425, 134, '{\"121\":\"Five Pack\",\"122\":\"15+ osob\"}', '{\"121\":\"Five Pack\",\"122\":\"15+ osob\"}', 2700.00, 110.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(426, 134, '{\"121\":\"Big Six\",\"122\":\"1-9 osob\"}', '{\"121\":\"Big Six\",\"122\":\"1-9 osob\"}', 3400.00, 140.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(427, 134, '{\"121\":\"Big Six\",\"122\":\"10-14 osob\"}', '{\"121\":\"Big Six\",\"122\":\"10-14 osob\"}', 3200.00, 130.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(428, 134, '{\"121\":\"Big Six\",\"122\":\"15+ osob\"}', '{\"121\":\"Big Six\",\"122\":\"15+ osob\"}', 3100.00, 125.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(429, 134, '{\"121\":\"Seven Pack\",\"122\":\"1-9 osob\"}', '{\"121\":\"Seven Pack\",\"122\":\"1-9 osob\"}', 3900.00, 160.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(430, 134, '{\"121\":\"Seven Pack\",\"122\":\"10-14 osob\"}', '{\"121\":\"Seven Pack\",\"122\":\"10-14 osob\"}', 3700.00, 150.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(431, 134, '{\"121\":\"Seven Pack\",\"122\":\"15+ osob\"}', '{\"121\":\"Seven Pack\",\"122\":\"15+ osob\"}', 3600.00, 145.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(432, 134, '{\"121\":\"Top Ten\",\"122\":\"1-9 osob\"}', '{\"121\":\"Top Ten\",\"122\":\"1-9 osob\"}', 4700.00, 190.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(433, 134, '{\"121\":\"Top Ten\",\"122\":\"10-14 osob\"}', '{\"121\":\"Top Ten\",\"122\":\"10-14 osob\"}', 4400.00, 180.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(434, 134, '{\"121\":\"Top Ten\",\"122\":\"15+ osob\"}', '{\"121\":\"Top Ten\",\"122\":\"15+ osob\"}', 4300.00, 175.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(435, 134, '{\"121\":\"Badass Pack\",\"122\":\"1-9 osob\"}', '{\"121\":\"Badass Pack\",\"122\":\"1-9 osob\"}', 5800.00, 240.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(436, 134, '{\"121\":\"Badass Pack\",\"122\":\"10-14 osob\"}', '{\"121\":\"Badass Pack\",\"122\":\"10-14 osob\"}', 5500.00, 225.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(437, 134, '{\"121\":\"Badass Pack\",\"122\":\"15+ osob\"}', '{\"121\":\"Badass Pack\",\"122\":\"15+ osob\"}', 5400.00, 220.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(438, 134, '{\"121\":\"Ladies Pack\",\"122\":\"1-9 osob\"}', '{\"121\":\"Ladies Pack\",\"122\":\"1-9 osob\"}', 2300.00, 95.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(439, 134, '{\"121\":\"Ladies Pack\",\"122\":\"10-14 osob\"}', '{\"121\":\"Ladies Pack\",\"122\":\"10-14 osob\"}', 2200.00, 90.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(440, 134, '{\"121\":\"Ladies Pack\",\"122\":\"15+ osob\"}', '{\"121\":\"Ladies Pack\",\"122\":\"15+ osob\"}', 2100.00, 85.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(441, 135, '{\"123\":\"Adult\"}', '{\"123\":\"Adult\"}', 1300.00, 52.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(442, 135, '{\"123\":\"Child 3-12\"}', '{\"123\":\"Child 3-12\"}', 825.00, 33.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(443, 135, '{\"123\":\"Infant 0-2\"}', '{\"123\":\"Infant 0-2\"}', 0.00, 0.00, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(444, 136, '{\"124\":\"Tandem Skydiving\"}', '{\"124\":\"Tandem Skydiving\"}', 6200.00, 258.00, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(445, 136, '{\"124\":\"Tandem + Photos & Video\"}', '{\"124\":\"Tandem + Photos & Video\"}', 8700.00, 368.00, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(446, 136, '{\"124\":\"Tandem + Photos & Video & Selfie\"}', '{\"124\":\"Tandem + Photos & Video & Selfie\"}', 9200.00, 388.00, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(447, 137, '{\"125\":\"40-minute horse ride\"}', '{\"125\":\"40-minute horse ride\"}', 2000.00, 80.00, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(448, 138, '{\"126\":\"Chomutov (62 m bridge)\"}', '{\"126\":\"Chomutov (62 m bridge)\"}', 3800.00, 150.00, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(449, 138, '{\"126\":\"Harrachov (36 m TV tower)\"}', '{\"126\":\"Harrachov (36 m TV tower)\"}', 4300.00, 170.00, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(450, 139, '{\"127\":\"2 rides (20 min)\"}', '{\"127\":\"2 rides (20 min)\"}', 1200.00, 46.00, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(451, 139, '{\"127\":\"3 rides (30 min)\"}', '{\"127\":\"3 rides (30 min)\"}', 1500.00, 59.00, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(452, 140, '{\"128\":\"5 rides\"}', '{\"128\":\"5 rides\"}', 1000.00, 39.00, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(453, 141, '{\"129\":\"4-6 osob\"}', '{\"129\":\"4-6 osob\"}', 2400.00, 100.00, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(454, 141, '{\"129\":\"7+ osob\"}', '{\"129\":\"7+ osob\"}', 1950.00, 80.00, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(455, 142, '{\"130\":\"1-hour balloon flight\"}', '{\"130\":\"1-hour balloon flight\"}', 6000.00, 240.00, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(456, 143, '{\"131\":\"2 osoby\"}', '{\"131\":\"2 osoby\"}', 3500.00, 140.00, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(457, 143, '{\"131\":\"3-4 osoby\"}', '{\"131\":\"3-4 osoby\"}', 3300.00, 132.00, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(458, 143, '{\"131\":\"5+ osob\"}', '{\"131\":\"5+ osob\"}', 3200.00, 128.00, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(459, 144, '{\"132\":\"1-4 osoby\"}', '{\"132\":\"1-4 osoby\"}', 2500.00, 98.00, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(460, 144, '{\"132\":\"5-8 osob\"}', '{\"132\":\"5-8 osob\"}', 2300.00, 90.00, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(461, 144, '{\"132\":\"9-12 osob\"}', '{\"132\":\"9-12 osob\"}', 2100.00, 82.00, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(462, 144, '{\"132\":\"13+ osob\"}', '{\"132\":\"13+ osob\"}', 2000.00, 78.00, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(463, 145, '{\"133\":\"100 bullets\"}', '{\"133\":\"100 bullets\"}', 1200.00, 46.00, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(464, 145, '{\"133\":\"200 bullets\"}', '{\"133\":\"200 bullets\"}', 1400.00, 55.00, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(465, 145, '{\"133\":\"300 bullets\"}', '{\"133\":\"300 bullets\"}', 1600.00, 63.00, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(466, 146, '{\"134\":\"2-3 osoby\"}', '{\"134\":\"2-3 osoby\"}', 1600.00, 63.00, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(467, 146, '{\"134\":\"4-5 osob\"}', '{\"134\":\"4-5 osob\"}', 1400.00, 55.00, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(468, 146, '{\"134\":\"6-7 osob\"}', '{\"134\":\"6-7 osob\"}', 1200.00, 47.00, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(469, 146, '{\"134\":\"8+ osob\"}', '{\"134\":\"8+ osob\"}', 1000.00, 39.00, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(470, 147, '{\"135\":\"15-minute flyboarding\"}', '{\"135\":\"15-minute flyboarding\"}', 2700.00, 105.00, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(471, 148, '{\"136\":\"Short ride (30 min)\",\"137\":\"1-4 osoby\"}', '{\"136\":\"Short ride (30 min)\",\"137\":\"1-4 osoby\"}', 2000.00, 78.00, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(472, 148, '{\"136\":\"Short ride (30 min)\",\"137\":\"5-10 osob\"}', '{\"136\":\"Short ride (30 min)\",\"137\":\"5-10 osob\"}', 1700.00, 67.00, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(473, 148, '{\"136\":\"Short ride (30 min)\",\"137\":\"11+ osob\"}', '{\"136\":\"Short ride (30 min)\",\"137\":\"11+ osob\"}', 1600.00, 63.00, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(474, 148, '{\"136\":\"Medium ride (45 min)\",\"137\":\"1-4 osoby\"}', '{\"136\":\"Medium ride (45 min)\",\"137\":\"1-4 osoby\"}', 2400.00, 94.00, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(475, 148, '{\"136\":\"Medium ride (45 min)\",\"137\":\"5-10 osob\"}', '{\"136\":\"Medium ride (45 min)\",\"137\":\"5-10 osob\"}', 2100.00, 82.00, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(476, 148, '{\"136\":\"Medium ride (45 min)\",\"137\":\"11+ osob\"}', '{\"136\":\"Medium ride (45 min)\",\"137\":\"11+ osob\"}', 2000.00, 78.00, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(477, 148, '{\"136\":\"Long ride (60 min)\",\"137\":\"1-4 osoby\"}', '{\"136\":\"Long ride (60 min)\",\"137\":\"1-4 osoby\"}', 2800.00, 110.00, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(478, 148, '{\"136\":\"Long ride (60 min)\",\"137\":\"5-10 osob\"}', '{\"136\":\"Long ride (60 min)\",\"137\":\"5-10 osob\"}', 2500.00, 98.00, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(479, 148, '{\"136\":\"Long ride (60 min)\",\"137\":\"11+ osob\"}', '{\"136\":\"Long ride (60 min)\",\"137\":\"11+ osob\"}', 2400.00, 94.00, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(480, 149, '{\"138\":\"Per person\"}', '{\"138\":\"Per person\"}', 1400.00, 56.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(481, 150, '{\"139\":\"Per person\"}', '{\"139\":\"Per person\"}', 1300.00, 52.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(482, 151, '{\"140\":\"Per person\"}', '{\"140\":\"Per person\"}', 1300.00, 52.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(483, 152, '{\"141\":\"Per person\"}', '{\"141\":\"Per person\"}', 1300.00, 52.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(484, 153, '{\"142\":\"Per person\"}', '{\"142\":\"Per person\"}', 650.00, 26.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(485, 154, '{\"143\":\"Per person\"}', '{\"143\":\"Per person\"}', 1000.00, 40.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(486, 155, '{\"144\":\"Per person\"}', '{\"144\":\"Per person\"}', 800.00, 32.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(487, 156, '{\"145\":\"Per person\"}', '{\"145\":\"Per person\"}', 1700.00, 68.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(488, 157, '{\"146\":\"Per person\"}', '{\"146\":\"Per person\"}', 1400.00, 56.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(489, 158, '{\"147\":\"Per person\"}', '{\"147\":\"Per person\"}', 700.00, 28.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(490, 159, '{\"148\":\"Per person\"}', '{\"148\":\"Per person\"}', 1550.00, 62.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(491, 160, '{\"149\":\"Per person\"}', '{\"149\":\"Per person\"}', 1250.00, 50.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(492, 161, '{\"150\":\"Per person\"}', '{\"150\":\"Per person\"}', 1399.00, 56.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(493, 162, '{\"151\":\"Per person\"}', '{\"151\":\"Per person\"}', 1799.00, 72.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(494, 163, '{\"152\":\"Adult\"}', '{\"152\":\"Adult\"}', 1100.00, 44.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(495, 163, '{\"152\":\"Student\"}', '{\"152\":\"Student\"}', 1000.00, 40.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(496, 163, '{\"152\":\"Child 5-15\"}', '{\"152\":\"Child 5-15\"}', 900.00, 36.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(497, 163, '{\"152\":\"Infant 0-4\"}', '{\"152\":\"Infant 0-4\"}', 0.00, 0.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(498, 164, '{\"153\":\"Adult\"}', '{\"153\":\"Adult\"}', 950.00, 38.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(499, 164, '{\"153\":\"Student\"}', '{\"153\":\"Student\"}', 850.00, 34.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(500, 164, '{\"153\":\"Child 5-15\"}', '{\"153\":\"Child 5-15\"}', 750.00, 30.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(501, 164, '{\"153\":\"Infant 0-4\"}', '{\"153\":\"Infant 0-4\"}', 0.00, 0.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(502, 165, '{\"154\":\"Adult\"}', '{\"154\":\"Adult\"}', 450.00, 18.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(503, 165, '{\"154\":\"Student\"}', '{\"154\":\"Student\"}', 450.00, 18.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(504, 165, '{\"154\":\"Child 5-15\"}', '{\"154\":\"Child 5-15\"}', 350.00, 14.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(505, 165, '{\"154\":\"Infant 0-4\"}', '{\"154\":\"Infant 0-4\"}', 0.00, 0.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(506, 166, '{\"155\":\"Adult\"}', '{\"155\":\"Adult\"}', 1300.00, 52.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(507, 166, '{\"155\":\"Student\"}', '{\"155\":\"Student\"}', 1300.00, 52.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(508, 166, '{\"155\":\"Child 5-15\"}', '{\"155\":\"Child 5-15\"}', 1050.00, 42.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(509, 166, '{\"155\":\"Infant 0-4\"}', '{\"155\":\"Infant 0-4\"}', 0.00, 0.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(510, 167, '{\"156\":\"Adult\"}', '{\"156\":\"Adult\"}', 390.00, 16.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(511, 167, '{\"156\":\"Student\"}', '{\"156\":\"Student\"}', 390.00, 16.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(512, 167, '{\"156\":\"Child 5-15\"}', '{\"156\":\"Child 5-15\"}', 200.00, 8.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(513, 167, '{\"156\":\"Infant 0-4\"}', '{\"156\":\"Infant 0-4\"}', 0.00, 0.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(514, 168, '{\"157\":\"Adult\"}', '{\"157\":\"Adult\"}', 1300.00, 52.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(515, 168, '{\"157\":\"Student\"}', '{\"157\":\"Student\"}', 1300.00, 52.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(516, 168, '{\"157\":\"Child 5-15\"}', '{\"157\":\"Child 5-15\"}', 800.00, 32.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(517, 168, '{\"157\":\"Infant 0-4\"}', '{\"157\":\"Infant 0-4\"}', 0.00, 0.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(518, 169, '{\"158\":\"Adult\"}', '{\"158\":\"Adult\"}', 1950.00, 78.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(519, 169, '{\"158\":\"Student\"}', '{\"158\":\"Student\"}', 1850.00, 74.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(520, 169, '{\"158\":\"Child 5-15\"}', '{\"158\":\"Child 5-15\"}', 1650.00, 66.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(521, 169, '{\"158\":\"Infant 0-4\"}', '{\"158\":\"Infant 0-4\"}', 0.00, 0.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(522, 170, '{\"159\":\"Adult\"}', '{\"159\":\"Adult\"}', 1900.00, 76.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(523, 170, '{\"159\":\"Student\"}', '{\"159\":\"Student\"}', 1800.00, 72.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(524, 170, '{\"159\":\"Child 5-15\"}', '{\"159\":\"Child 5-15\"}', 1600.00, 64.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(525, 170, '{\"159\":\"Infant 0-4\"}', '{\"159\":\"Infant 0-4\"}', 0.00, 0.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(526, 171, '{\"160\":\"Adult\"}', '{\"160\":\"Adult\"}', 1350.00, 54.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(527, 171, '{\"160\":\"Student\"}', '{\"160\":\"Student\"}', 1350.00, 54.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(528, 171, '{\"160\":\"Child 5-15\"}', '{\"160\":\"Child 5-15\"}', 1050.00, 42.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(529, 171, '{\"160\":\"Infant 0-4\"}', '{\"160\":\"Infant 0-4\"}', 0.00, 0.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(530, 172, '{\"161\":\"Adult\"}', '{\"161\":\"Adult\"}', 1450.00, 58.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(531, 172, '{\"161\":\"Student\"}', '{\"161\":\"Student\"}', 1350.00, 54.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(532, 172, '{\"161\":\"Child 5-15\"}', '{\"161\":\"Child 5-15\"}', 1150.00, 46.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(533, 172, '{\"161\":\"Infant 0-4\"}', '{\"161\":\"Infant 0-4\"}', 0.00, 0.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(534, 173, '{\"162\":\"Adult\"}', '{\"162\":\"Adult\"}', 1650.00, 66.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(535, 173, '{\"162\":\"Student\"}', '{\"162\":\"Student\"}', 1550.00, 62.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(536, 173, '{\"162\":\"Child 5-15\"}', '{\"162\":\"Child 5-15\"}', 1350.00, 54.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(537, 173, '{\"162\":\"Infant 0-4\"}', '{\"162\":\"Infant 0-4\"}', 0.00, 0.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(538, 174, '{\"163\":\"Adult\"}', '{\"163\":\"Adult\"}', 1150.00, 46.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(539, 174, '{\"163\":\"Student\"}', '{\"163\":\"Student\"}', 1150.00, 46.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(540, 174, '{\"163\":\"Child 5-15\"}', '{\"163\":\"Child 5-15\"}', 950.00, 38.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(541, 174, '{\"163\":\"Infant 0-4\"}', '{\"163\":\"Infant 0-4\"}', 0.00, 0.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(542, 175, '{\"164\":\"Adult\"}', '{\"164\":\"Adult\"}', 990.00, 40.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(543, 175, '{\"164\":\"Student\"}', '{\"164\":\"Student\"}', 990.00, 40.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(544, 175, '{\"164\":\"Child 5-15\"}', '{\"164\":\"Child 5-15\"}', 750.00, 30.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(545, 175, '{\"164\":\"Infant 0-4\"}', '{\"164\":\"Infant 0-4\"}', 0.00, 0.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(546, 176, '{\"165\":\"Adult\"}', '{\"165\":\"Adult\"}', 2080.00, 83.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(547, 176, '{\"165\":\"Student & Senior\"}', '{\"165\":\"Student & Senior\"}', 1940.00, 78.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(548, 176, '{\"165\":\"Child 4-6\"}', '{\"165\":\"Child 4-6\"}', 1790.00, 72.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(549, 176, '{\"165\":\"Infant 0-3\"}', '{\"165\":\"Infant 0-3\"}', 0.00, 0.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(550, 177, '{\"166\":\"Adult\"}', '{\"166\":\"Adult\"}', 1530.00, 61.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(551, 177, '{\"166\":\"Student & Senior\"}', '{\"166\":\"Student & Senior\"}', 1390.00, 56.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(552, 177, '{\"166\":\"Child 4-6\"}', '{\"166\":\"Child 4-6\"}', 1190.00, 48.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(553, 177, '{\"166\":\"Infant 0-3\"}', '{\"166\":\"Infant 0-3\"}', 0.00, 0.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(554, 178, '{\"167\":\"Adult\"}', '{\"167\":\"Adult\"}', 1890.00, 76.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(555, 178, '{\"167\":\"Student & Senior\"}', '{\"167\":\"Student & Senior\"}', 1790.00, 72.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(556, 178, '{\"167\":\"Child 4-6\"}', '{\"167\":\"Child 4-6\"}', 1690.00, 68.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(557, 178, '{\"167\":\"Infant 0-3\"}', '{\"167\":\"Infant 0-3\"}', 0.00, 0.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(558, 179, '{\"168\":\"Adult\"}', '{\"168\":\"Adult\"}', 1750.00, 70.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(559, 179, '{\"168\":\"Student & Senior\"}', '{\"168\":\"Student & Senior\"}', 1600.00, 64.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(560, 179, '{\"168\":\"Child 4-6\"}', '{\"168\":\"Child 4-6\"}', 1490.00, 60.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(561, 179, '{\"168\":\"Infant 0-3\"}', '{\"168\":\"Infant 0-3\"}', 0.00, 0.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(562, 180, '{\"169\":\"Adult\"}', '{\"169\":\"Adult\"}', 1640.00, 66.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(563, 180, '{\"169\":\"Student & Senior\"}', '{\"169\":\"Student & Senior\"}', 1500.00, 60.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(564, 180, '{\"169\":\"Child 4-6\"}', '{\"169\":\"Child 4-6\"}', 1390.00, 56.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(565, 180, '{\"169\":\"Infant 0-3\"}', '{\"169\":\"Infant 0-3\"}', 0.00, 0.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(566, 181, '{\"170\":\"Adult\"}', '{\"170\":\"Adult\"}', 2590.00, 104.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(567, 181, '{\"170\":\"Student & Senior\"}', '{\"170\":\"Student & Senior\"}', 2390.00, 96.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(568, 181, '{\"170\":\"Child 4-6\"}', '{\"170\":\"Child 4-6\"}', 1990.00, 80.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(569, 181, '{\"170\":\"Infant 0-3\"}', '{\"170\":\"Infant 0-3\"}', 0.00, 0.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(570, 182, '{\"171\":\"Adult\"}', '{\"171\":\"Adult\"}', 1090.00, 44.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(571, 182, '{\"171\":\"Student & Senior\"}', '{\"171\":\"Student & Senior\"}', 950.00, 38.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(572, 182, '{\"171\":\"Child 4-6\"}', '{\"171\":\"Child 4-6\"}', 890.00, 36.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(573, 182, '{\"171\":\"Infant 0-3\"}', '{\"171\":\"Infant 0-3\"}', 0.00, 0.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(574, 183, '{\"172\":\"Adult\"}', '{\"172\":\"Adult\"}', 680.00, 27.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(575, 183, '{\"172\":\"Student & Senior\"}', '{\"172\":\"Student & Senior\"}', 600.00, 24.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(576, 183, '{\"172\":\"Child 4-6\"}', '{\"172\":\"Child 4-6\"}', 550.00, 22.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(577, 183, '{\"172\":\"Infant 0-3\"}', '{\"172\":\"Infant 0-3\"}', 0.00, 0.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(578, 184, '{\"173\":\"Adult\"}', '{\"173\":\"Adult\"}', 1690.00, 68.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(579, 184, '{\"173\":\"Student & Senior\"}', '{\"173\":\"Student & Senior\"}', 1490.00, 60.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(580, 184, '{\"173\":\"Child 4-6\"}', '{\"173\":\"Child 4-6\"}', 1290.00, 52.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(581, 184, '{\"173\":\"Infant 0-3\"}', '{\"173\":\"Infant 0-3\"}', 0.00, 0.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(582, 185, '{\"174\":\"Adult\"}', '{\"174\":\"Adult\"}', 1890.00, 76.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(583, 185, '{\"174\":\"Student & Senior\"}', '{\"174\":\"Student & Senior\"}', 1690.00, 68.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(584, 185, '{\"174\":\"Child 4-6\"}', '{\"174\":\"Child 4-6\"}', 1490.00, 60.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(585, 185, '{\"174\":\"Infant 0-3\"}', '{\"174\":\"Infant 0-3\"}', 0.00, 0.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(586, 186, '{\"175\":\"Adult\"}', '{\"175\":\"Adult\"}', 1900.00, 76.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(587, 186, '{\"175\":\"Student & Senior\"}', '{\"175\":\"Student & Senior\"}', 1700.00, 68.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(588, 186, '{\"175\":\"Child 4-6\"}', '{\"175\":\"Child 4-6\"}', 1190.00, 48.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(589, 186, '{\"175\":\"Infant 0-3\"}', '{\"175\":\"Infant 0-3\"}', 0.00, 0.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(590, 187, '{\"176\":\"One-way\"}', '{\"176\":\"One-way\"}', 380.00, 15.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(591, 187, '{\"176\":\"Both-way\"}', '{\"176\":\"Both-way\"}', 700.00, 28.00, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(592, 188, '{\"177\":\"Adult\"}', '{\"177\":\"Adult\"}', 500.00, 22.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(593, 188, '{\"177\":\"Student 12-26\"}', '{\"177\":\"Student 12-26\"}', 400.00, 17.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(594, 188, '{\"177\":\"Child 4-12\"}', '{\"177\":\"Child 4-12\"}', 300.00, 13.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(595, 188, '{\"177\":\"Infant 0-3\"}', '{\"177\":\"Infant 0-3\"}', 0.00, 0.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(596, 188, '{\"177\":\"Family (2A+2C)\"}', '{\"177\":\"Family (2A+2C)\"}', 1400.00, 61.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(597, 189, '{\"178\":\"Adult\"}', '{\"178\":\"Adult\"}', 900.00, 39.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(598, 189, '{\"178\":\"Infant 0-3\"}', '{\"178\":\"Infant 0-3\"}', 0.00, 0.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(599, 190, '{\"179\":\"Adult\"}', '{\"179\":\"Adult\"}', 2000.00, 87.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(600, 190, '{\"179\":\"Student 12-26\"}', '{\"179\":\"Student 12-26\"}', 1800.00, 78.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(601, 190, '{\"179\":\"Child 4-12\"}', '{\"179\":\"Child 4-12\"}', 1500.00, 65.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(602, 190, '{\"179\":\"Infant 0-3\"}', '{\"179\":\"Infant 0-3\"}', 0.00, 0.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(603, 191, '{\"180\":\"Adult\"}', '{\"180\":\"Adult\"}', 1300.00, 57.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(604, 191, '{\"180\":\"Student 12-26\"}', '{\"180\":\"Student 12-26\"}', 1000.00, 43.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(605, 191, '{\"180\":\"Child 4-12\"}', '{\"180\":\"Child 4-12\"}', 700.00, 30.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(606, 191, '{\"180\":\"Infant 0-3\"}', '{\"180\":\"Infant 0-3\"}', 0.00, 0.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(607, 192, '{\"181\":\"Adult\"}', '{\"181\":\"Adult\"}', 1900.00, 83.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(608, 192, '{\"181\":\"Student 12-26\"}', '{\"181\":\"Student 12-26\"}', 1750.00, 76.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(609, 192, '{\"181\":\"Child 4-12\"}', '{\"181\":\"Child 4-12\"}', 1300.00, 57.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(610, 192, '{\"181\":\"Infant 0-3\"}', '{\"181\":\"Infant 0-3\"}', 0.00, 0.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(611, 193, '{\"182\":\"Adult\"}', '{\"182\":\"Adult\"}', 1400.00, 61.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(612, 193, '{\"182\":\"Student 12-26\"}', '{\"182\":\"Student 12-26\"}', 1100.00, 48.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(613, 193, '{\"182\":\"Child 4-12\"}', '{\"182\":\"Child 4-12\"}', 700.00, 30.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(614, 193, '{\"182\":\"Infant 0-3\"}', '{\"182\":\"Infant 0-3\"}', 0.00, 0.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(615, 194, '{\"183\":\"Adult\"}', '{\"183\":\"Adult\"}', 1400.00, 61.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(616, 194, '{\"183\":\"Student 12-26\"}', '{\"183\":\"Student 12-26\"}', 1200.00, 52.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(617, 194, '{\"183\":\"Child 4-12\"}', '{\"183\":\"Child 4-12\"}', 1000.00, 43.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(618, 194, '{\"183\":\"Infant 0-3\"}', '{\"183\":\"Infant 0-3\"}', 0.00, 0.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(619, 195, '{\"184\":\"Adult\"}', '{\"184\":\"Adult\"}', 1400.00, 61.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(620, 195, '{\"184\":\"Student 12-26\"}', '{\"184\":\"Student 12-26\"}', 1200.00, 52.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(621, 195, '{\"184\":\"Child 4-12\"}', '{\"184\":\"Child 4-12\"}', 1000.00, 43.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(622, 195, '{\"184\":\"Infant 0-3\"}', '{\"184\":\"Infant 0-3\"}', 0.00, 0.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(623, 196, '{\"185\":\"Adult\"}', '{\"185\":\"Adult\"}', 900.00, 39.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(624, 196, '{\"185\":\"Infant 0-3\"}', '{\"185\":\"Infant 0-3\"}', 0.00, 0.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(625, 197, '{\"186\":\"Adult\"}', '{\"186\":\"Adult\"}', 400.00, 18.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(626, 197, '{\"186\":\"Student 12-26\"}', '{\"186\":\"Student 12-26\"}', 350.00, 15.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(627, 197, '{\"186\":\"Child 4-12\"}', '{\"186\":\"Child 4-12\"}', 250.00, 11.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(628, 197, '{\"186\":\"Infant 0-3\"}', '{\"186\":\"Infant 0-3\"}', 0.00, 0.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(629, 197, '{\"186\":\"Family (2A+2C)\"}', '{\"186\":\"Family (2A+2C)\"}', 1100.00, 48.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(630, 198, '{\"187\":\"Adult\"}', '{\"187\":\"Adult\"}', 800.00, 35.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(631, 198, '{\"187\":\"Student 12-26\"}', '{\"187\":\"Student 12-26\"}', 600.00, 26.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(632, 198, '{\"187\":\"Child 4-12\"}', '{\"187\":\"Child 4-12\"}', 400.00, 17.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(633, 198, '{\"187\":\"Infant 0-3\"}', '{\"187\":\"Infant 0-3\"}', 0.00, 0.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35');
INSERT INTO `prices` (`id`, `pricing_version_id`, `cell_key`, `dimension_values_json`, `czk`, `eur`, `is_override`, `created_at`, `updated_at`) VALUES
(634, 198, '{\"187\":\"Family (2A+2C)\"}', '{\"187\":\"Family (2A+2C)\"}', 1900.00, 83.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(635, 199, '{\"188\":\"Adult\"}', '{\"188\":\"Adult\"}', 400.00, 18.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(636, 199, '{\"188\":\"Student 12-26\"}', '{\"188\":\"Student 12-26\"}', 350.00, 15.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(637, 199, '{\"188\":\"Child 4-12\"}', '{\"188\":\"Child 4-12\"}', 300.00, 13.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(638, 199, '{\"188\":\"Infant 0-3\"}', '{\"188\":\"Infant 0-3\"}', 0.00, 0.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(639, 199, '{\"188\":\"Family (2A+2C)\"}', '{\"188\":\"Family (2A+2C)\"}', 1200.00, 52.00, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(640, 200, '{\"189\":\"Adult\"}', '{\"189\":\"Adult\"}', 700.00, 30.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(641, 200, '{\"189\":\"Student 12-26\"}', '{\"189\":\"Student 12-26\"}', 500.00, 22.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(642, 200, '{\"189\":\"Child 4-12\"}', '{\"189\":\"Child 4-12\"}', 400.00, 17.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(643, 200, '{\"189\":\"Infant 0-3\"}', '{\"189\":\"Infant 0-3\"}', 0.00, 0.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(644, 200, '{\"189\":\"Family (2A+2C)\"}', '{\"189\":\"Family (2A+2C)\"}', 1700.00, 74.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(645, 201, '{\"190\":\"Adult\"}', '{\"190\":\"Adult\"}', 1800.00, 78.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(646, 201, '{\"190\":\"Student 12-26\"}', '{\"190\":\"Student 12-26\"}', 1700.00, 74.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(647, 201, '{\"190\":\"Child 4-12\"}', '{\"190\":\"Child 4-12\"}', 1500.00, 65.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(648, 201, '{\"190\":\"Infant 0-3\"}', '{\"190\":\"Infant 0-3\"}', 0.00, 0.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(649, 202, '{\"191\":\"Adult\"}', '{\"191\":\"Adult\"}', 1100.00, 48.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(650, 202, '{\"191\":\"Student 12-26\"}', '{\"191\":\"Student 12-26\"}', 800.00, 35.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(651, 202, '{\"191\":\"Child 4-12\"}', '{\"191\":\"Child 4-12\"}', 600.00, 26.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(652, 202, '{\"191\":\"Infant 0-3\"}', '{\"191\":\"Infant 0-3\"}', 0.00, 0.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(653, 203, '{\"192\":\"Adult\"}', '{\"192\":\"Adult\"}', 1500.00, 65.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(654, 203, '{\"192\":\"Student 12-26\"}', '{\"192\":\"Student 12-26\"}', 1300.00, 57.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(655, 203, '{\"192\":\"Child 4-12\"}', '{\"192\":\"Child 4-12\"}', 900.00, 39.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(656, 203, '{\"192\":\"Infant 0-3\"}', '{\"192\":\"Infant 0-3\"}', 0.00, 0.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(657, 204, '{\"193\":\"Per person\"}', '{\"193\":\"Per person\"}', 650.00, 27.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(658, 205, '{\"194\":\"Adult\"}', '{\"194\":\"Adult\"}', 5750.00, 239.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(659, 205, '{\"194\":\"Child\"}', '{\"194\":\"Child\"}', 4490.00, 187.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(660, 206, '{\"195\":\"Per person\"}', '{\"195\":\"Per person\"}', 3750.00, 150.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(661, 207, '{\"196\":\"Per person\"}', '{\"196\":\"Per person\"}', 4225.00, 169.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(662, 208, '{\"197\":\"Per person\"}', '{\"197\":\"Per person\"}', 4875.00, 195.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(663, 209, '{\"198\":\"Per person\"}', '{\"198\":\"Per person\"}', 4125.00, 165.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(664, 210, '{\"199\":\"Per person\"}', '{\"199\":\"Per person\"}', 4625.00, 185.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(665, 211, '{\"200\":\"Per person\"}', '{\"200\":\"Per person\"}', 4875.00, 195.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(666, 212, '{\"201\":\"Per person\"}', '{\"201\":\"Per person\"}', 4625.00, 185.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(667, 213, '{\"202\":\"Per person\"}', '{\"202\":\"Per person\"}', 4500.00, 180.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(668, 214, '{\"203\":\"Per person\"}', '{\"203\":\"Per person\"}', 4875.00, 195.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(669, 215, '{\"204\":\"Per person\"}', '{\"204\":\"Per person\"}', 5125.00, 205.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(670, 216, '{\"205\":\"Per person\"}', '{\"205\":\"Per person\"}', 5375.00, 215.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(671, 217, '{\"206\":\"Per person\"}', '{\"206\":\"Per person\"}', 5500.00, 220.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(672, 218, '{\"207\":\"Per person\"}', '{\"207\":\"Per person\"}', 5500.00, 220.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(673, 219, '{\"208\":\"Per person\"}', '{\"208\":\"Per person\"}', 5500.00, 220.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(674, 220, '{\"209\":\"Per person\"}', '{\"209\":\"Per person\"}', 3500.00, 140.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(675, 221, '{\"210\":\"Per person\"}', '{\"210\":\"Per person\"}', 5500.00, 220.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(676, 222, '{\"211\":\"Per person\"}', '{\"211\":\"Per person\"}', 7250.00, 290.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(677, 223, '{\"212\":\"Per person\"}', '{\"212\":\"Per person\"}', 18750.00, 750.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(678, 224, '{\"213\":\"Per person\"}', '{\"213\":\"Per person\"}', 17050.00, 682.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(679, 225, '{\"214\":\"Per person\"}', '{\"214\":\"Per person\"}', 40000.00, 1600.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(680, 226, '{\"215\":\"Public (per person)\"}', '{\"215\":\"Public (per person)\"}', 700.00, 28.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(681, 226, '{\"215\":\"Private group\"}', '{\"215\":\"Private group\"}', 7500.00, 300.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(682, 227, '{\"216\":\"Public (per person)\"}', '{\"216\":\"Public (per person)\"}', 450.00, 20.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(683, 227, '{\"216\":\"Private group\"}', '{\"216\":\"Private group\"}', 5500.00, 220.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(684, 228, '{\"217\":\"Public (per person)\"}', '{\"217\":\"Public (per person)\"}', 700.00, 28.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(685, 228, '{\"217\":\"Private group\"}', '{\"217\":\"Private group\"}', 7500.00, 300.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(686, 229, '{\"218\":\"Public (per person)\"}', '{\"218\":\"Public (per person)\"}', 1200.00, 48.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(687, 229, '{\"218\":\"Private group\"}', '{\"218\":\"Private group\"}', 12500.00, 500.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(688, 230, '{\"219\":\"Public (per person)\"}', '{\"219\":\"Public (per person)\"}', 700.00, 28.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(689, 230, '{\"219\":\"Private group\"}', '{\"219\":\"Private group\"}', 7500.00, 300.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(690, 231, '{\"220\":\"Public (per person)\"}', '{\"220\":\"Public (per person)\"}', 2450.00, 98.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(691, 231, '{\"220\":\"Private group\"}', '{\"220\":\"Private group\"}', 24500.00, 980.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(692, 232, '{\"221\":\"Public (per person)\"}', '{\"221\":\"Public (per person)\"}', 500.00, 20.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(693, 232, '{\"221\":\"Private group\"}', '{\"221\":\"Private group\"}', 6000.00, 240.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(694, 233, '{\"222\":\"Adult\"}', '{\"222\":\"Adult\"}', 450.00, 18.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(695, 233, '{\"222\":\"Child 3-11\"}', '{\"222\":\"Child 3-11\"}', 300.00, 12.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(696, 234, '{\"223\":\"Adult\"}', '{\"223\":\"Adult\"}', 700.00, 28.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(697, 234, '{\"223\":\"Child 3-11\"}', '{\"223\":\"Child 3-11\"}', 480.00, 19.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(698, 235, '{\"224\":\"Adult\"}', '{\"224\":\"Adult\"}', 450.00, 18.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(699, 235, '{\"224\":\"Child 3-11\"}', '{\"224\":\"Child 3-11\"}', 300.00, 12.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(700, 236, '{\"225\":\"Adult\"}', '{\"225\":\"Adult\"}', 600.00, 24.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(701, 236, '{\"225\":\"Child 3-11\"}', '{\"225\":\"Child 3-11\"}', 400.00, 16.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(702, 237, '{\"226\":\"Adult\"}', '{\"226\":\"Adult\"}', 1029.00, 41.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(703, 237, '{\"226\":\"Child 3-11\"}', '{\"226\":\"Child 3-11\"}', 550.00, 22.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(704, 238, '{\"227\":\"Adult\"}', '{\"227\":\"Adult\"}', 550.00, 22.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(705, 238, '{\"227\":\"Child 3-11\"}', '{\"227\":\"Child 3-11\"}', 380.00, 15.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(706, 239, '{\"228\":\"Essential\",\"229\":\"Adult\"}', '{\"228\":\"Essential\",\"229\":\"Adult\"}', 1230.00, 49.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(707, 239, '{\"228\":\"Essential\",\"229\":\"Child 3-11\"}', '{\"228\":\"Essential\",\"229\":\"Child 3-11\"}', 830.00, 33.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(708, 239, '{\"228\":\"Exclusive\",\"229\":\"Adult\"}', '{\"228\":\"Exclusive\",\"229\":\"Adult\"}', 1480.00, 59.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(709, 239, '{\"228\":\"Exclusive\",\"229\":\"Child 3-11\"}', '{\"228\":\"Exclusive\",\"229\":\"Child 3-11\"}', 1000.00, 40.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(710, 240, '{\"230\":\"Essential\",\"231\":\"Adult\"}', '{\"230\":\"Essential\",\"231\":\"Adult\"}', 1980.00, 79.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(711, 240, '{\"230\":\"Essential\",\"231\":\"Child 3-11\"}', '{\"230\":\"Essential\",\"231\":\"Child 3-11\"}', 1380.00, 55.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(712, 240, '{\"230\":\"Exclusive\",\"231\":\"Adult\"}', '{\"230\":\"Exclusive\",\"231\":\"Adult\"}', 2480.00, 99.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(713, 240, '{\"230\":\"Exclusive\",\"231\":\"Child 3-11\"}', '{\"230\":\"Exclusive\",\"231\":\"Child 3-11\"}', 1880.00, 75.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(714, 240, '{\"230\":\"De Luxe\",\"231\":\"Adult\"}', '{\"230\":\"De Luxe\",\"231\":\"Adult\"}', 3230.00, 129.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(715, 240, '{\"230\":\"De Luxe\",\"231\":\"Child 3-11\"}', '{\"230\":\"De Luxe\",\"231\":\"Child 3-11\"}', 2480.00, 99.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(716, 241, '{\"232\":\"Essential\",\"233\":\"Adult\"}', '{\"232\":\"Essential\",\"233\":\"Adult\"}', 1730.00, 69.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(717, 241, '{\"232\":\"Essential\",\"233\":\"Child 3-11\"}', '{\"232\":\"Essential\",\"233\":\"Child 3-11\"}', 1230.00, 49.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(718, 241, '{\"232\":\"Exclusive\",\"233\":\"Adult\"}', '{\"232\":\"Exclusive\",\"233\":\"Adult\"}', 2230.00, 89.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(719, 241, '{\"232\":\"Exclusive\",\"233\":\"Child 3-11\"}', '{\"232\":\"Exclusive\",\"233\":\"Child 3-11\"}', 1730.00, 69.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(720, 242, '{\"234\":\"Adult\"}', '{\"234\":\"Adult\"}', 550.00, 22.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(721, 242, '{\"234\":\"Child 2-12\"}', '{\"234\":\"Child 2-12\"}', 350.00, 14.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(722, 243, '{\"235\":\"Abrakadabra\",\"236\":\"Adult 15+\"}', '{\"235\":\"Abrakadabra\",\"236\":\"Adult 15+\"}', 590.00, 24.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(723, 243, '{\"235\":\"Abrakadabra\",\"236\":\"Child 3-14\"}', '{\"235\":\"Abrakadabra\",\"236\":\"Child 3-14\"}', 450.00, 18.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(724, 243, '{\"235\":\"Abrakadabra\",\"236\":\"Student ISIC\"}', '{\"235\":\"Abrakadabra\",\"236\":\"Student ISIC\"}', 500.00, 20.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(725, 243, '{\"235\":\"Abrakadabra\",\"236\":\"Family (2A+2C)\"}', '{\"235\":\"Abrakadabra\",\"236\":\"Family (2A+2C)\"}', 1900.00, 76.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(726, 243, '{\"235\":\"Afrikania\",\"236\":\"Adult 15+\"}', '{\"235\":\"Afrikania\",\"236\":\"Adult 15+\"}', 590.00, 24.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(727, 243, '{\"235\":\"Afrikania\",\"236\":\"Child 3-14\"}', '{\"235\":\"Afrikania\",\"236\":\"Child 3-14\"}', 450.00, 18.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(728, 243, '{\"235\":\"Afrikania\",\"236\":\"Student ISIC\"}', '{\"235\":\"Afrikania\",\"236\":\"Student ISIC\"}', 500.00, 20.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(729, 243, '{\"235\":\"Afrikania\",\"236\":\"Family (2A+2C)\"}', '{\"235\":\"Afrikania\",\"236\":\"Family (2A+2C)\"}', 1900.00, 76.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(730, 243, '{\"235\":\"Cosmic Cabinet\",\"236\":\"Adult 15+\"}', '{\"235\":\"Cosmic Cabinet\",\"236\":\"Adult 15+\"}', 590.00, 24.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(731, 243, '{\"235\":\"Cosmic Cabinet\",\"236\":\"Child 3-14\"}', '{\"235\":\"Cosmic Cabinet\",\"236\":\"Child 3-14\"}', 450.00, 18.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(732, 243, '{\"235\":\"Cosmic Cabinet\",\"236\":\"Student ISIC\"}', '{\"235\":\"Cosmic Cabinet\",\"236\":\"Student ISIC\"}', 500.00, 20.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(733, 243, '{\"235\":\"Cosmic Cabinet\",\"236\":\"Family (2A+2C)\"}', '{\"235\":\"Cosmic Cabinet\",\"236\":\"Family (2A+2C)\"}', 1900.00, 76.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(734, 243, '{\"235\":\"The Best of Image\",\"236\":\"Adult 15+\"}', '{\"235\":\"The Best of Image\",\"236\":\"Adult 15+\"}', 590.00, 24.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(735, 243, '{\"235\":\"The Best of Image\",\"236\":\"Child 3-14\"}', '{\"235\":\"The Best of Image\",\"236\":\"Child 3-14\"}', 450.00, 18.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(736, 243, '{\"235\":\"The Best of Image\",\"236\":\"Student ISIC\"}', '{\"235\":\"The Best of Image\",\"236\":\"Student ISIC\"}', 500.00, 20.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(737, 243, '{\"235\":\"The Best of Image\",\"236\":\"Family (2A+2C)\"}', '{\"235\":\"The Best of Image\",\"236\":\"Family (2A+2C)\"}', 1900.00, 76.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(738, 244, '{\"237\":\"Adult\"}', '{\"237\":\"Adult\"}', 650.00, 26.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(739, 244, '{\"237\":\"Student\"}', '{\"237\":\"Student\"}', 550.00, 22.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(740, 244, '{\"237\":\"Child 3-10\"}', '{\"237\":\"Child 3-10\"}', 450.00, 18.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(741, 245, '{\"238\":\"Adult\"}', '{\"238\":\"Adult\"}', 650.00, 26.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(742, 245, '{\"238\":\"Student\"}', '{\"238\":\"Student\"}', 600.00, 24.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(743, 245, '{\"238\":\"Child 3-10\"}', '{\"238\":\"Child 3-10\"}', 500.00, 20.00, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36');

-- --------------------------------------------------------

--
-- Struktura tabulky `pricing_dimensions`
--

CREATE TABLE `pricing_dimensions` (
  `id` int(10) UNSIGNED NOT NULL,
  `product_id` int(10) UNSIGNED NOT NULL,
  `type` varchar(40) NOT NULL,
  `label` varchar(120) NOT NULL,
  `values_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`values_json`)),
  `value_meta_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`value_meta_json`)),
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Vypisuji data pro tabulku `pricing_dimensions`
--

INSERT INTO `pricing_dimensions` (`id`, `product_id`, `type`, `label`, `values_json`, `value_meta_json`, `sort_order`, `created_at`, `updated_at`) VALUES
(3, 57, 'seating', 'Kategorie sezení', '[\"VIP (rows 1-6)\",\"Cat A (rows 7-12)\",\"Cat B (rows 13-18)\"]', NULL, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(4, 57, 'passenger_type', 'Typ návštěvníka', '[\"Adult\",\"Student-ISIC\"]', NULL, 1, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(5, 58, 'seating', 'Kategorie sezení', '[\"VIP (rows 1-6)\",\"Cat A (rows 7-12)\",\"Cat B (rows 13-18)\"]', NULL, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(6, 58, 'passenger_type', 'Typ návštěvníka', '[\"Adult\",\"Student-ISIC\"]', NULL, 1, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(7, 84, 'passenger_type', 'Typ návštěvníka', '[\"Adult\",\"Senior 65+\",\"Student 16-21\",\"Child 7-15\",\"Child 0-6\"]', NULL, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(8, 85, 'passenger_type', 'Typ návštěvníka', '[\"Adult\",\"Senior 65+\",\"Student 16-21\",\"Child 7-15\",\"Child 0-6\"]', NULL, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(9, 86, 'passenger_type', 'Typ návštěvníka', '[\"Adult\",\"Senior 65+\",\"Student 16-21\",\"Child 7-15\",\"Child 0-6\"]', NULL, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(10, 87, 'passenger_type', 'Typ návštěvníka', '[\"Adult\",\"Senior 65+\",\"Student 16-21\",\"Child 7-15\",\"Child 0-6\"]', NULL, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(11, 48, 'seating', 'Zóna', '[\"VIP zone\",\"A zone\",\"B zone\",\"C zone\"]', NULL, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(12, 49, 'seating', 'Zóna', '[\"A (orchestr\\/front rows)\",\"B (rear rows)\"]', NULL, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(15, 1, 'passenger_type', 'Typ návštěvníka', '[\"Adult\",\"Family (2A+3C 5-15)\"]', NULL, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(16, 2, 'passenger_type', 'Typ návštěvníka', '[\"Adult\",\"Family (2A+3C 5-15)\"]', NULL, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(17, 3, 'passenger_type', 'Typ návštěvníka', '[\"Adult\",\"Family (2A+3C 5-15)\"]', NULL, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(27, 63, 'seating', 'Sezení', '[\"Lowest seating\",\"Premium seating\"]', NULL, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(28, 64, 'seating', 'Sezení', '[\"Lowest seating\",\"Premium seating\"]', NULL, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(56, 30, 'passenger_type', 'Typ pasažéra', '[\"Dospělý\",\"Dítě\"]', NULL, 0, '2026-06-01 07:39:56', '2026-06-01 07:39:56'),
(101, 118, 'variant', 'Varianta', '[\"Discover\",\"Essential\",\"Explore\",\"Panoramic\"]', '{\"Discover\":{\"label\":\"Discover\",\"tone\":\"neutral\",\"desc\":\"24 h, jedna trasa, bez plavby\",\"features\":[{\"l\":\"1 trasa (Red)\",\"v\":\"yes\"},{\"l\":\"Platnost 24 hodin\",\"v\":\"yes\"},{\"l\":\"Plavba po Vltavě\",\"v\":\"no\"}]},\"Essential\":{\"label\":\"Essential\",\"tone\":\"green\",\"desc\":\"24 h, dvě trasy + plavba po Vltavě\",\"badges\":[\"Best value\"],\"features\":[{\"l\":\"2 trasy (Red+Blue)\",\"v\":\"yes\"},{\"l\":\"Platnost 24 hodin\",\"v\":\"yes\"},{\"l\":\"Plavba po Vltavě\",\"v\":\"yes\"}]},\"Explore\":{\"label\":\"Explore\",\"tone\":\"gold\",\"desc\":\"48 h, dvě trasy + plavba a procházky\",\"features\":[{\"l\":\"2 trasy (Red+Blue)\",\"v\":\"yes\"},{\"l\":\"Platnost 48 hodin\",\"v\":\"yes\"},{\"l\":\"Plavba + 3× walking tour\",\"v\":\"yes\"}]},\"Panoramic\":{\"label\":\"Panoramic\",\"tone\":\"purple\",\"desc\":\"Jednorázová panoramatická jízda (~1 h), bez hop-off\",\"badges\":[\"Limited\"],\"features\":[{\"l\":\"1 trasa (Red)\",\"v\":\"yes\"},{\"l\":\"Panoramatická jízda ~1 h\",\"v\":\"yes\"},{\"l\":\"Hop-on hop-off\",\"v\":\"no\"}]}}', 0, '2026-06-01 13:46:16', '2026-06-01 13:46:16'),
(102, 118, 'passenger_type', 'Typ pasažéra', '[\"Adult\",\"Child 5-15\",\"Infant 0-4\",\"Family (2A+3C 5-15)\"]', NULL, 1, '2026-06-01 13:46:16', '2026-06-01 13:46:16'),
(103, 84, 'ticket_type', 'Ticket', '[\"Standard\", \"Senior 65+\", \"Student 16-21\", \"Child 7-15\", \"Child 0-6\"]', NULL, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(104, 85, 'ticket_type', 'Ticket', '[\"Standard\", \"Senior 65+\", \"Student 16-21\", \"Child 7-15\", \"Child 0-6\"]', NULL, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(105, 86, 'ticket_type', 'Ticket', '[\"Standard\", \"Senior 65+\", \"Student 16-21\", \"Child 7-15\", \"Child 0-6\"]', NULL, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(106, 87, 'ticket_type', 'Ticket', '[\"Standard\", \"Senior 65+\", \"Student 16-21\", \"Child 7-15\", \"Child 0-6\"]', NULL, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(107, 57, 'zone', 'Zone', '[\"VIP (rows 1-6)\", \"Cat A (rows 7-12)\", \"Cat B (rows 13-18)\"]', NULL, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(108, 57, 'audience', 'Visitor', '[\"Adult\", \"Student\"]', NULL, 1, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(109, 58, 'zone', 'Zone', '[\"VIP (rows 1-6)\", \"Cat A (rows 7-12)\", \"Cat B (rows 13-18)\"]', NULL, 0, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(110, 58, 'audience', 'Visitor', '[\"Adult\", \"Student\"]', NULL, 1, '2026-06-02 13:01:57', '2026-06-02 13:01:57'),
(111, 48, 'zone', 'Zone', '[\"VIP\", \"A\", \"B\", \"C\"]', NULL, 0, '2026-06-02 13:02:20', '2026-06-02 13:02:20'),
(112, 49, 'zone', 'Zone', '[\"A\", \"B\"]', NULL, 0, '2026-06-02 13:02:20', '2026-06-02 13:02:20'),
(113, 59, 'variant', 'Sezóna', '[\"Letní (od 1.5.)\", \"Zimní (do 30.4.)\"]', NULL, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(114, 59, 'seating', 'Sezení', '[\"Table 8\", \"Table 2\", \"Table 2 front row\", \"Balcony box\", \"Child <12\"]', NULL, 1, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(115, 60, 'variant', 'Sezóna', '[\"Letní (od 1.5.)\", \"Zimní (do 30.4.)\"]', NULL, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(116, 60, 'seating', 'Sezení', '[\"Table 8\", \"Table 2\", \"Table 2 front row\", \"Balcony box\", \"Child <12\"]', NULL, 1, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(117, 62, 'variant', 'Sezóna', '[\"Letní (od 1.5.)\", \"Zimní (do 30.4.)\"]', NULL, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(118, 62, 'seating', 'Sezení', '[\"Table 8\", \"Table 2\", \"Table 2 front row\", \"Balcony box\", \"Child <12\"]', NULL, 1, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(119, 61, 'variant', 'Sezóna', '[\"Letní (od 1.5.)\", \"Zimní (do 30.4.)\"]', NULL, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(120, 61, 'seating', 'Sezení', '[\"Balcony box\"]', NULL, 1, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(121, 89, 'variant', 'Balíček (zbraně)', '[\"Triple Pack\", \"Four Pack\", \"Five Pack\", \"Big Six\", \"Seven Pack\", \"Top Ten\", \"Badass Pack\", \"Ladies Pack\"]', '{\"Triple Pack\": {\"desc\": \"Kalashnikov · Pump Shotgun · Glock 17 (3 zbraně, 25 ran)\"}, \"Four Pack\": {\"desc\": \"Kalashnikov · Pump Shotgun · MP5 · .38 Special (4 zbraně, 30 ran)\"}, \"Five Pack\": {\"desc\": \"Kalashnikov · Pump Shotgun · MP5 · .38 Special · Glock 17 (5 zbraní, 40 ran)\"}, \"Big Six\": {\"desc\": \"Kalashnikov · Dragunov · AR15 · Pump Shotgun · MP5 · .44 Taurus (6 zbraní, 45 ran)\"}, \"Seven Pack\": {\"desc\": \"Kalashnikov · Dragunov · AR15 · Pump Shotgun · MP5 · .44 Taurus · Glock 17 (7 zbraní, 55 ran)\"}, \"Top Ten\": {\"desc\": \"10 zbraní vč. Scorpion EVO, Colt 1911, S&W MP9 (80 ran)\"}, \"Badass Pack\": {\"desc\": \"13 zbraní vč. Desert Eagle .50, P90, G36, Steyr AUG (90 ran)\"}, \"Ladies Pack\": {\"desc\": \"Ruger Mark · Glock 44 · V-AR9 – nízký zpětný ráz (3 zbraně, 30 ran)\"}}', 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(122, 89, 'variant', 'Velikost skupiny (sleva)', '[\"1-9 osob\", \"10-14 osob\", \"15+ osob\"]', NULL, 1, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(123, 88, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Child 3-12\", \"Infant 0-2\"]', NULL, 0, '2026-06-02 13:05:51', '2026-06-02 13:05:51'),
(124, 90, 'variant', 'Balíček', '[\"Tandem Skydiving\", \"Tandem + Photos & Video\", \"Tandem + Photos & Video & Selfie\"]', NULL, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(125, 91, 'variant', 'Balíček', '[\"40-minute horse ride\"]', NULL, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(126, 92, 'variant', 'Lokalita', '[\"Chomutov (62 m bridge)\", \"Harrachov (36 m TV tower)\"]', NULL, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(127, 93, 'variant', 'Balíček', '[\"2 rides (20 min)\", \"3 rides (30 min)\"]', NULL, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(128, 94, 'variant', 'Balíček', '[\"5 rides\"]', NULL, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(129, 95, 'variant', 'Velikost skupiny', '[\"4-6 osob\", \"7+ osob\"]', NULL, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(130, 96, 'variant', 'Balíček', '[\"1-hour balloon flight\"]', NULL, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(131, 97, 'variant', 'Velikost skupiny', '[\"2 osoby\", \"3-4 osoby\", \"5+ osob\"]', NULL, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(132, 98, 'variant', 'Velikost skupiny', '[\"1-4 osoby\", \"5-8 osob\", \"9-12 osob\", \"13+ osob\"]', NULL, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(133, 99, 'variant', 'Balíček', '[\"100 bullets\", \"200 bullets\", \"300 bullets\"]', NULL, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(134, 100, 'variant', 'Velikost skupiny', '[\"2-3 osoby\", \"4-5 osob\", \"6-7 osob\", \"8+ osob\"]', NULL, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(135, 101, 'variant', 'Balíček', '[\"15-minute flyboarding\"]', NULL, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(136, 102, 'variant', 'Délka jízdy', '[\"Short ride (30 min)\", \"Medium ride (45 min)\", \"Long ride (60 min)\"]', NULL, 0, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(137, 102, 'variant', 'Velikost skupiny', '[\"1-4 osoby\", \"5-10 osob\", \"11+ osob\"]', NULL, 1, '2026-06-02 13:06:52', '2026-06-02 13:06:52'),
(138, 103, 'passenger_type', 'Návštěvník', '[\"Per person\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(139, 104, 'passenger_type', 'Návštěvník', '[\"Per person\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(140, 105, 'passenger_type', 'Návštěvník', '[\"Per person\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(141, 106, 'passenger_type', 'Návštěvník', '[\"Per person\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(142, 107, 'passenger_type', 'Návštěvník', '[\"Per person\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(143, 108, 'passenger_type', 'Návštěvník', '[\"Per person\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(144, 109, 'passenger_type', 'Návštěvník', '[\"Per person\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(145, 110, 'passenger_type', 'Návštěvník', '[\"Per person\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(146, 111, 'passenger_type', 'Návštěvník', '[\"Per person\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(147, 112, 'passenger_type', 'Návštěvník', '[\"Per person\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(148, 113, 'passenger_type', 'Návštěvník', '[\"Per person\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(149, 114, 'passenger_type', 'Návštěvník', '[\"Per person\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(150, 82, 'passenger_type', 'Návštěvník', '[\"Per person\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(151, 83, 'passenger_type', 'Návštěvník', '[\"Per person\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(152, 5, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student\", \"Child 5-15\", \"Infant 0-4\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(153, 6, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student\", \"Child 5-15\", \"Infant 0-4\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(154, 7, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student\", \"Child 5-15\", \"Infant 0-4\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(155, 8, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student\", \"Child 5-15\", \"Infant 0-4\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(156, 9, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student\", \"Child 5-15\", \"Infant 0-4\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(157, 10, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student\", \"Child 5-15\", \"Infant 0-4\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(158, 11, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student\", \"Child 5-15\", \"Infant 0-4\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(159, 12, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student\", \"Child 5-15\", \"Infant 0-4\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(160, 13, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student\", \"Child 5-15\", \"Infant 0-4\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(161, 14, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student\", \"Child 5-15\", \"Infant 0-4\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(162, 15, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student\", \"Child 5-15\", \"Infant 0-4\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(163, 16, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student\", \"Child 5-15\", \"Infant 0-4\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(164, 17, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student\", \"Child 5-15\", \"Infant 0-4\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(165, 18, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student & Senior\", \"Child 4-6\", \"Infant 0-3\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(166, 19, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student & Senior\", \"Child 4-6\", \"Infant 0-3\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(167, 20, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student & Senior\", \"Child 4-6\", \"Infant 0-3\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(168, 21, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student & Senior\", \"Child 4-6\", \"Infant 0-3\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(169, 22, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student & Senior\", \"Child 4-6\", \"Infant 0-3\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(170, 23, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student & Senior\", \"Child 4-6\", \"Infant 0-3\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(171, 24, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student & Senior\", \"Child 4-6\", \"Infant 0-3\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(172, 25, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student & Senior\", \"Child 4-6\", \"Infant 0-3\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(173, 26, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student & Senior\", \"Child 4-6\", \"Infant 0-3\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(174, 27, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student & Senior\", \"Child 4-6\", \"Infant 0-3\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(175, 28, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student & Senior\", \"Child 4-6\", \"Infant 0-3\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(176, 29, 'variant', 'Transfer (2-3 os.)', '[\"One-way\", \"Both-way\"]', NULL, 0, '2026-06-02 13:08:48', '2026-06-02 13:08:48'),
(177, 32, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student 12-26\", \"Child 4-12\", \"Infant 0-3\", \"Family (2A+2C)\"]', NULL, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(178, 33, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Infant 0-3\"]', NULL, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(179, 34, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student 12-26\", \"Child 4-12\", \"Infant 0-3\"]', NULL, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(180, 35, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student 12-26\", \"Child 4-12\", \"Infant 0-3\"]', NULL, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(181, 36, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student 12-26\", \"Child 4-12\", \"Infant 0-3\"]', NULL, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(182, 37, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student 12-26\", \"Child 4-12\", \"Infant 0-3\"]', NULL, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(183, 38, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student 12-26\", \"Child 4-12\", \"Infant 0-3\"]', NULL, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(184, 39, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student 12-26\", \"Child 4-12\", \"Infant 0-3\"]', NULL, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(185, 40, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Infant 0-3\"]', NULL, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(186, 41, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student 12-26\", \"Child 4-12\", \"Infant 0-3\", \"Family (2A+2C)\"]', NULL, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(187, 42, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student 12-26\", \"Child 4-12\", \"Infant 0-3\", \"Family (2A+2C)\"]', NULL, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(188, 43, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student 12-26\", \"Child 4-12\", \"Infant 0-3\", \"Family (2A+2C)\"]', NULL, 0, '2026-06-02 13:11:35', '2026-06-02 13:11:35'),
(189, 44, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student 12-26\", \"Child 4-12\", \"Infant 0-3\", \"Family (2A+2C)\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(190, 45, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student 12-26\", \"Child 4-12\", \"Infant 0-3\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(191, 46, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student 12-26\", \"Child 4-12\", \"Infant 0-3\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(192, 47, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Student 12-26\", \"Child 4-12\", \"Infant 0-3\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(193, 121, 'passenger_type', 'Návštěvník', '[\"Per person\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(194, 122, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Child\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(195, 123, 'passenger_type', 'Návštěvník', '[\"Per person\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(196, 124, 'passenger_type', 'Návštěvník', '[\"Per person\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(197, 125, 'passenger_type', 'Návštěvník', '[\"Per person\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(198, 126, 'passenger_type', 'Návštěvník', '[\"Per person\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(199, 127, 'passenger_type', 'Návštěvník', '[\"Per person\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(200, 128, 'passenger_type', 'Návštěvník', '[\"Per person\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(201, 129, 'passenger_type', 'Návštěvník', '[\"Per person\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(202, 130, 'passenger_type', 'Návštěvník', '[\"Per person\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(203, 131, 'passenger_type', 'Návštěvník', '[\"Per person\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(204, 132, 'passenger_type', 'Návštěvník', '[\"Per person\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(205, 133, 'passenger_type', 'Návštěvník', '[\"Per person\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(206, 134, 'passenger_type', 'Návštěvník', '[\"Per person\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(207, 135, 'passenger_type', 'Návštěvník', '[\"Per person\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(208, 136, 'passenger_type', 'Návštěvník', '[\"Per person\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(209, 137, 'passenger_type', 'Návštěvník', '[\"Per person\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(210, 138, 'passenger_type', 'Návštěvník', '[\"Per person\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(211, 139, 'passenger_type', 'Návštěvník', '[\"Per person\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(212, 140, 'passenger_type', 'Návštěvník', '[\"Per person\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(213, 141, 'passenger_type', 'Návštěvník', '[\"Per person\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(214, 142, 'passenger_type', 'Návštěvník', '[\"Per person\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(215, 65, 'variant', 'Možnost', '[\"Public (per person)\", \"Private group\"]', '{\"Private group\": {\"desc\": \"celá skupina, max ~8 os.\"}}', 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(216, 66, 'variant', 'Možnost', '[\"Public (per person)\", \"Private group\"]', '{\"Private group\": {\"desc\": \"celá skupina, max ~8 os.\"}}', 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(217, 67, 'variant', 'Možnost', '[\"Public (per person)\", \"Private group\"]', '{\"Private group\": {\"desc\": \"celá skupina, max ~8 os.\"}}', 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(218, 68, 'variant', 'Možnost', '[\"Public (per person)\", \"Private group\"]', '{\"Private group\": {\"desc\": \"celá skupina, max ~8 os.\"}}', 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(219, 69, 'variant', 'Možnost', '[\"Public (per person)\", \"Private group\"]', '{\"Private group\": {\"desc\": \"celá skupina, max ~8 os.\"}}', 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(220, 70, 'variant', 'Možnost', '[\"Public (per person)\", \"Private group\"]', '{\"Private group\": {\"desc\": \"celá skupina, max ~8 os.\"}}', 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(221, 71, 'variant', 'Možnost', '[\"Public (per person)\", \"Private group\"]', '{\"Private group\": {\"desc\": \"celá skupina, max ~8 os.\"}}', 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(222, 72, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Child 3-11\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(223, 73, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Child 3-11\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(224, 74, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Child 3-11\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(225, 75, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Child 3-11\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(226, 76, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Child 3-11\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(227, 77, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Child 3-11\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(228, 78, 'variant', 'Třída', '[\"Essential\", \"Exclusive\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(229, 78, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Child 3-11\"]', NULL, 1, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(230, 79, 'variant', 'Třída', '[\"Essential\", \"Exclusive\", \"De Luxe\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(231, 79, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Child 3-11\"]', NULL, 1, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(232, 80, 'variant', 'Třída', '[\"Essential\", \"Exclusive\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(233, 80, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Child 3-11\"]', NULL, 1, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(234, 81, 'passenger_type', 'Návštěvník', '[\"Adult\", \"Child 2-12\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(235, 115, 'variant', 'Představení', '[\"Abrakadabra\", \"Afrikania\", \"Cosmic Cabinet\", \"The Best of Image\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(236, 115, 'passenger_type', 'Vstupenka', '[\"Adult 15+\", \"Child 3-14\", \"Student ISIC\", \"Family (2A+2C)\"]', NULL, 1, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(237, 116, 'passenger_type', 'Vstupenka', '[\"Adult\", \"Student\", \"Child 3-10\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36'),
(238, 117, 'passenger_type', 'Vstupenka', '[\"Adult\", \"Student\", \"Child 3-10\"]', NULL, 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36');

-- --------------------------------------------------------

--
-- Struktura tabulky `pricing_versions`
--

CREATE TABLE `pricing_versions` (
  `id` int(10) UNSIGNED NOT NULL,
  `product_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(120) NOT NULL,
  `effective_from` date DEFAULT NULL,
  `effective_to` date DEFAULT NULL,
  `status` enum('draft','active','archived') NOT NULL DEFAULT 'draft',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `commission_pct` decimal(5,2) DEFAULT NULL,
  `seller_bonus_pct` decimal(5,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Vypisuji data pro tabulku `pricing_versions`
--

INSERT INTO `pricing_versions` (`id`, `product_id`, `name`, `effective_from`, `effective_to`, `status`, `created_at`, `updated_at`, `commission_pct`, `seller_bonus_pct`) VALUES
(2, 57, 'Katalog 2026', NULL, NULL, 'active', '2026-06-01 07:39:56', '2026-06-01 07:39:56', NULL, NULL),
(3, 58, 'Katalog 2026', NULL, NULL, 'active', '2026-06-01 07:39:56', '2026-06-01 07:39:56', NULL, NULL),
(4, 84, 'Katalog 2026', NULL, NULL, 'active', '2026-06-01 07:39:56', '2026-06-01 07:39:56', NULL, NULL),
(5, 85, 'Katalog 2026', NULL, NULL, 'active', '2026-06-01 07:39:56', '2026-06-01 07:39:56', NULL, NULL),
(6, 86, 'Katalog 2026', NULL, NULL, 'active', '2026-06-01 07:39:56', '2026-06-01 07:39:56', NULL, NULL),
(7, 87, 'Katalog 2026', NULL, NULL, 'active', '2026-06-01 07:39:56', '2026-06-01 07:39:56', NULL, NULL),
(8, 48, 'Katalog 2026', NULL, NULL, 'active', '2026-06-01 07:39:56', '2026-06-01 07:39:56', NULL, NULL),
(9, 49, 'Katalog 2026', NULL, NULL, 'active', '2026-06-01 07:39:56', '2026-06-01 07:39:56', NULL, NULL),
(11, 1, 'Katalog 2026', NULL, NULL, 'active', '2026-06-01 07:39:56', '2026-06-01 07:39:56', NULL, NULL),
(12, 2, 'Katalog 2026', NULL, NULL, 'active', '2026-06-01 07:39:56', '2026-06-01 07:39:56', NULL, NULL),
(13, 3, 'Katalog 2026', NULL, NULL, 'active', '2026-06-01 07:39:56', '2026-06-01 07:39:56', NULL, NULL),
(19, 63, 'Katalog 2026', NULL, NULL, 'active', '2026-06-01 07:39:56', '2026-06-01 07:39:56', NULL, NULL),
(20, 64, 'Katalog 2026', NULL, NULL, 'active', '2026-06-01 07:39:56', '2026-06-01 07:39:56', NULL, NULL),
(23, 4, 'Katalog 2026', NULL, NULL, 'active', '2026-06-01 07:39:56', '2026-06-01 07:39:56', NULL, NULL),
(48, 30, 'Katalog 2026', NULL, NULL, 'active', '2026-06-01 07:39:56', '2026-06-01 07:39:56', NULL, NULL),
(121, 118, 'Big Bus 2026', NULL, NULL, 'active', '2026-06-01 13:46:16', '2026-06-01 13:46:16', NULL, NULL),
(122, 84, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:01:57', '2026-06-02 13:01:57', NULL, NULL),
(123, 85, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:01:57', '2026-06-02 13:01:57', NULL, NULL),
(124, 86, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:01:57', '2026-06-02 13:01:57', NULL, NULL),
(125, 87, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:01:57', '2026-06-02 13:01:57', NULL, NULL),
(126, 57, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:01:57', '2026-06-02 13:01:57', NULL, NULL),
(127, 58, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:01:57', '2026-06-02 13:01:57', NULL, NULL),
(128, 48, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:02:20', '2026-06-02 13:02:20', NULL, NULL),
(129, 49, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:02:20', '2026-06-02 13:02:20', NULL, NULL),
(130, 59, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:05:51', '2026-06-02 13:05:51', NULL, NULL),
(131, 60, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:05:51', '2026-06-02 13:05:51', NULL, NULL),
(132, 62, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:05:51', '2026-06-02 13:05:51', NULL, NULL),
(133, 61, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:05:51', '2026-06-02 13:05:51', NULL, NULL),
(134, 89, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:05:51', '2026-06-02 13:05:51', NULL, NULL),
(135, 88, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:05:51', '2026-06-02 13:05:51', NULL, NULL),
(136, 90, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:06:52', '2026-06-02 13:06:52', NULL, NULL),
(137, 91, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:06:52', '2026-06-02 13:06:52', NULL, NULL),
(138, 92, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:06:52', '2026-06-02 13:06:52', NULL, NULL),
(139, 93, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:06:52', '2026-06-02 13:06:52', NULL, NULL),
(140, 94, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:06:52', '2026-06-02 13:06:52', NULL, NULL),
(141, 95, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:06:52', '2026-06-02 13:06:52', NULL, NULL),
(142, 96, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:06:52', '2026-06-02 13:06:52', NULL, NULL),
(143, 97, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:06:52', '2026-06-02 13:06:52', NULL, NULL),
(144, 98, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:06:52', '2026-06-02 13:06:52', NULL, NULL),
(145, 99, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:06:52', '2026-06-02 13:06:52', NULL, NULL),
(146, 100, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:06:52', '2026-06-02 13:06:52', NULL, NULL),
(147, 101, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:06:52', '2026-06-02 13:06:52', NULL, NULL),
(148, 102, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:06:52', '2026-06-02 13:06:52', NULL, NULL),
(149, 103, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(150, 104, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(151, 105, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(152, 106, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(153, 107, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(154, 108, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(155, 109, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(156, 110, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(157, 111, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(158, 112, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(159, 113, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(160, 114, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(161, 82, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(162, 83, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(163, 5, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(164, 6, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(165, 7, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(166, 8, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(167, 9, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(168, 10, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(169, 11, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(170, 12, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(171, 13, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(172, 14, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(173, 15, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(174, 16, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(175, 17, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(176, 18, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(177, 19, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(178, 20, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(179, 21, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(180, 22, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(181, 23, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(182, 24, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(183, 25, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(184, 26, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(185, 27, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(186, 28, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(187, 29, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:08:48', '2026-06-02 13:08:48', NULL, NULL),
(188, 32, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:35', '2026-06-02 13:11:35', NULL, NULL),
(189, 33, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:35', '2026-06-02 13:11:35', NULL, NULL),
(190, 34, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:35', '2026-06-02 13:11:35', NULL, NULL),
(191, 35, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:35', '2026-06-02 13:11:35', NULL, NULL),
(192, 36, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:35', '2026-06-02 13:11:35', NULL, NULL),
(193, 37, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:35', '2026-06-02 13:11:35', NULL, NULL),
(194, 38, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:35', '2026-06-02 13:11:35', NULL, NULL),
(195, 39, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:35', '2026-06-02 13:11:35', NULL, NULL),
(196, 40, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:35', '2026-06-02 13:11:35', NULL, NULL),
(197, 41, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:35', '2026-06-02 13:11:35', NULL, NULL),
(198, 42, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:35', '2026-06-02 13:11:35', NULL, NULL),
(199, 43, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:35', '2026-06-02 13:11:35', NULL, NULL),
(200, 44, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(201, 45, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(202, 46, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(203, 47, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(204, 121, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(205, 122, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(206, 123, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(207, 124, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(208, 125, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(209, 126, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(210, 127, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(211, 128, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(212, 129, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(213, 130, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(214, 131, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(215, 132, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(216, 133, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(217, 134, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(218, 135, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(219, 136, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(220, 137, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(221, 138, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(222, 139, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(223, 140, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(224, 141, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(225, 142, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(226, 65, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(227, 66, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(228, 67, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(229, 68, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(230, 69, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(231, 70, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(232, 71, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(233, 72, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(234, 73, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(235, 74, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(236, 75, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(237, 76, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(238, 77, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(239, 78, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(240, 79, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(241, 80, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(242, 81, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(243, 115, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(244, 116, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL),
(245, 117, 'Katalog 2026', NULL, NULL, 'active', '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL);

-- --------------------------------------------------------

--
-- Struktura tabulky `products`
--

CREATE TABLE `products` (
  `id` int(10) UNSIGNED NOT NULL,
  `agency_id` int(10) UNSIGNED NOT NULL,
  `commission_pct` decimal(5,2) DEFAULT NULL,
  `seller_bonus_pct` decimal(5,2) DEFAULT NULL,
  `name_cs` varchar(190) NOT NULL,
  `name_en` varchar(190) DEFAULT NULL,
  `name_de` varchar(190) DEFAULT NULL,
  `image_path` varchar(255) DEFAULT NULL,
  `variant_diagram_path` varchar(255) DEFAULT NULL,
  `description_cs` text DEFAULT NULL,
  `description_en` text DEFAULT NULL,
  `description_de` text DEFAULT NULL,
  `languages` varchar(255) DEFAULT NULL,
  `order_instructions` text DEFAULT NULL,
  `booking_url` varchar(500) DEFAULT NULL,
  `has_contingent` tinyint(1) NOT NULL DEFAULT 0,
  `duration_minutes` int(10) UNSIGNED DEFAULT NULL,
  `schedule_type` enum('continuous','fixed_daily','multiple_daily','weekly_pattern','seasonal','specific_dates','on_demand') NOT NULL DEFAULT 'on_demand',
  `voucher_redemption_type` enum('direct_entry','box_office_exchange','bus_activation','agency_call') NOT NULL DEFAULT 'direct_entry',
  `ticket_type` enum('open','date_required') NOT NULL DEFAULT 'date_required',
  `pickup_available` tinyint(1) NOT NULL DEFAULT 0,
  `pickup_required` tinyint(1) NOT NULL DEFAULT 0,
  `pickup_free` tinyint(1) NOT NULL DEFAULT 1,
  `pickup_window_minutes` int(10) UNSIGNED DEFAULT NULL,
  `pickup_confirmation` enum('fixed','tbc_agency') DEFAULT NULL,
  `status` enum('active','inactive','archived') NOT NULL DEFAULT 'active',
  `is_featured` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deposit_fixed_czk` decimal(10,2) DEFAULT NULL,
  `deposit_fixed_eur` decimal(10,2) DEFAULT NULL,
  `meeting_point_address` varchar(255) DEFAULT NULL,
  `map_url` varchar(255) DEFAULT NULL,
  `included` text DEFAULT NULL,
  `excluded` text DEFAULT NULL,
  `what_to_bring` text DEFAULT NULL,
  `important_info` text DEFAULT NULL,
  `cancellation_policy` varchar(255) DEFAULT NULL,
  `meeting_point_note` varchar(255) DEFAULT NULL,
  `meeting_options` text DEFAULT NULL,
  `seating` tinyint(1) NOT NULL DEFAULT 0,
  `addons` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Vypisuji data pro tabulku `products`
--

INSERT INTO `products` (`id`, `agency_id`, `commission_pct`, `seller_bonus_pct`, `name_cs`, `name_en`, `name_de`, `image_path`, `variant_diagram_path`, `description_cs`, `description_en`, `description_de`, `languages`, `order_instructions`, `booking_url`, `has_contingent`, `duration_minutes`, `schedule_type`, `voucher_redemption_type`, `ticket_type`, `pickup_available`, `pickup_required`, `pickup_free`, `pickup_window_minutes`, `pickup_confirmation`, `status`, `is_featured`, `created_at`, `updated_at`, `deposit_fixed_czk`, `deposit_fixed_eur`, `meeting_point_address`, `map_url`, `included`, `excluded`, `what_to_bring`, `important_info`, `cancellation_policy`, `meeting_point_note`, `meeting_options`, `seating`, `addons`) VALUES
(1, 1, NULL, NULL, 'Discover 24h', NULL, NULL, 'placeholders/ag-1.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1440, 'continuous', 'direct_entry', 'open', 0, 0, 1, NULL, NULL, 'inactive', 0, '2026-06-01 06:52:56', '2026-06-02 18:08:01', NULL, NULL, NULL, NULL, 'Unlimited hop-on hop-off on both routes (Red and Green) for your ticket validity\nMultilingual audio commentary (24 languages) with earphones\nOn-board staff\nVltava river cruise (where included in your ticket)', 'Food and drinks\nGratuities', 'This voucher (print or mobile)\nSun protection in summer', 'Board at any of the 18 stops — look for the red Big Bus. Audio guide via the earphones provided.', 'Free cancellation up to 24 hours before start; non-refundable afterwards.', NULL, NULL, 0, NULL),
(2, 1, NULL, NULL, 'Essential 24h', NULL, NULL, 'placeholders/ag-1.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1440, 'continuous', 'direct_entry', 'open', 0, 0, 1, NULL, NULL, 'inactive', 0, '2026-06-01 06:52:56', '2026-06-02 18:08:01', NULL, NULL, NULL, NULL, 'Unlimited hop-on hop-off on both routes (Red and Green) for your ticket validity\nMultilingual audio commentary (24 languages) with earphones\nOn-board staff\nVltava river cruise (where included in your ticket)', 'Food and drinks\nGratuities', 'This voucher (print or mobile)\nSun protection in summer', 'Board at any of the 18 stops — look for the red Big Bus. Audio guide via the earphones provided.', 'Free cancellation up to 24 hours before start; non-refundable afterwards.', NULL, NULL, 0, NULL),
(3, 1, NULL, NULL, 'Explore 48h', NULL, NULL, 'placeholders/ag-1.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 2880, 'continuous', 'direct_entry', 'open', 0, 0, 1, NULL, NULL, 'inactive', 0, '2026-06-01 06:52:56', '2026-06-02 18:08:01', NULL, NULL, NULL, NULL, 'Unlimited hop-on hop-off on both routes (Red and Green) for your ticket validity\nMultilingual audio commentary (24 languages) with earphones\nOn-board staff\nVltava river cruise (where included in your ticket)', 'Food and drinks\nGratuities', 'This voucher (print or mobile)\nSun protection in summer', 'Board at any of the 18 stops — look for the red Big Bus. Audio guide via the earphones provided.', 'Free cancellation up to 24 hours before start; non-refundable afterwards.', NULL, NULL, 0, NULL),
(4, 1, NULL, NULL, 'Panoramic 72h', NULL, NULL, 'placeholders/ag-1.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 4320, 'continuous', 'direct_entry', 'open', 0, 0, 1, NULL, NULL, 'inactive', 0, '2026-06-01 06:52:56', '2026-06-02 18:08:01', NULL, NULL, NULL, NULL, 'Unlimited hop-on hop-off on both routes (Red and Green) for your ticket validity\nMultilingual audio commentary (24 languages) with earphones\nOn-board staff\nVltava river cruise (where included in your ticket)', 'Food and drinks\nGratuities', 'This voucher (print or mobile)\nSun protection in summer', 'Board at any of the 18 stops — look for the red Big Bus. Audio guide via the earphones provided.', 'Free cancellation up to 24 hours before start; non-refundable afterwards.', NULL, NULL, 0, NULL),
(5, 2, NULL, NULL, 'Grand City Tour – Best of Prague', 'Grand City Tour – Best of Prague', NULL, 'placeholders/ag-2.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 240, 'multiple_daily', 'direct_entry', 'date_required', 1, 0, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:08:48', NULL, NULL, 'Premiant Point — Na Příkopě 23, Praha 1', NULL, 'Professional guide / multilingual commentary\nTransport by coach (and boat where part of the tour)\nFree hotel pickup on request', 'Meals\nGratuities\nOptional admission fees', 'This voucher (print or mobile)\nComfortable walking shoes', NULL, 'Free cancellation up to 24 hours before start; non-refundable afterwards.', 'Meet at the Premiant office (Na Příkopě 23, Praha 1), or choose free hotel pickup.', NULL, 0, NULL),
(6, 2, NULL, NULL, 'The Best of Prague (shorter)', 'The Best of Prague (shorter)', NULL, 'products/6_e8b6d883.jpg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 210, 'multiple_daily', 'direct_entry', 'date_required', 1, 0, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:08:48', NULL, NULL, 'Info Centre — Malostranské náměstí 22, Praha 1', NULL, 'Professional guide / multilingual commentary\nTransport by coach (and boat where part of the tour)\nFree hotel pickup on request', 'Meals\nGratuities\nOptional admission fees', 'This voucher (print or mobile)\nComfortable walking shoes', NULL, 'Free cancellation up to 24 hours before start; non-refundable afterwards.', 'Meet at the Premiant office (Na Příkopě 23, Praha 1), or choose free hotel pickup.', NULL, 0, NULL),
(7, 2, NULL, NULL, 'Walking Tour – Old & Jewish Town', 'Walking Tour – Old & Jewish Town', NULL, 'placeholders/ag-2.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 150, 'fixed_daily', 'direct_entry', 'date_required', 1, 0, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:08:48', NULL, NULL, 'Premiant Point — Na Příkopě 23, Praha 1', NULL, 'Professional guide / multilingual commentary\nTransport by coach (and boat where part of the tour)\nFree hotel pickup on request', 'Meals\nGratuities\nOptional admission fees', 'This voucher (print or mobile)\nComfortable walking shoes', NULL, 'Free cancellation up to 24 hours before start; non-refundable afterwards.', 'Meet at the Premiant office (Na Příkopě 23, Praha 1), or choose free hotel pickup.', NULL, 0, NULL),
(8, 2, NULL, NULL, 'Prague Castle Interiors + boat', 'Prague Castle Interiors + boat', NULL, 'placeholders/ag-2.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 240, 'fixed_daily', 'direct_entry', 'date_required', 1, 0, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:08:48', NULL, NULL, 'Premiant Point — Na Příkopě 23, Praha 1', NULL, 'Round-trip transport from Prague\nEnglish-speaking guide', 'Meals\nGratuities', 'This voucher (print or mobile)\nComfortable shoes and weather-appropriate clothing', NULL, 'Free cancellation up to 24 hours before start; non-refundable afterwards.', 'Meet at the Premiant office (Na Příkopě 23, Praha 1), or choose free hotel pickup.', NULL, 0, NULL),
(9, 2, NULL, NULL, 'Panoramic Vltava River Cruise', 'Panoramic Vltava River Cruise', NULL, 'placeholders/ag-2.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 55, 'weekly_pattern', 'direct_entry', 'date_required', 1, 0, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:08:48', NULL, NULL, 'Boat pier — Dvořákovo nábřeží, Pier 17, Praha 1', NULL, 'Round-trip transport from Prague\nEnglish-speaking guide', 'Meals\nGratuities', 'This voucher (print or mobile)\nComfortable shoes and weather-appropriate clothing', NULL, 'Free cancellation up to 24 hours before start; non-refundable afterwards.', 'Meet at the Premiant office (Na Příkopě 23, Praha 1), or choose free hotel pickup.', NULL, 0, NULL),
(10, 2, NULL, NULL, 'Evening Cruise with Dinner', 'Evening Cruise with Dinner', NULL, 'placeholders/ag-2.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 180, 'weekly_pattern', 'direct_entry', 'date_required', 1, 0, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:08:48', NULL, NULL, 'Boat pier — Dvořákovo nábřeží, Pier 17, Praha 1', NULL, 'Round-trip transport from Prague\nEnglish-speaking guide', 'Meals\nGratuities', 'This voucher (print or mobile)\nComfortable shoes and weather-appropriate clothing', NULL, 'Free cancellation up to 24 hours before start; non-refundable afterwards.', 'Meet at the Premiant office (Na Příkopě 23, Praha 1), or choose free hotel pickup.', NULL, 0, NULL),
(11, 2, NULL, NULL, 'Český Krumlov – UNESCO', 'Český Krumlov – UNESCO', NULL, 'placeholders/ag-2.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 660, 'weekly_pattern', 'direct_entry', 'date_required', 1, 0, 1, NULL, 'tbc_agency', 'active', 1, '2026-06-01 06:52:56', '2026-06-02 13:08:48', NULL, NULL, 'Premiant Point — Na Příkopě 23, Praha 1', NULL, 'Round-trip transport from Prague\nEnglish-speaking guide', 'Meals\nGratuities', 'This voucher (print or mobile)\nComfortable shoes and weather-appropriate clothing', NULL, 'Free cancellation up to 24 hours before start; non-refundable afterwards.', 'Meet at the Premiant office (Na Příkopě 23, Praha 1), or choose free hotel pickup.', NULL, 0, NULL),
(12, 2, NULL, NULL, 'Karlovy Vary + Watchtower Diana', 'Karlovy Vary + Watchtower Diana', NULL, 'placeholders/ag-2.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 570, 'weekly_pattern', 'direct_entry', 'date_required', 1, 0, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:08:48', NULL, NULL, 'Premiant Point — Na Příkopě 23, Praha 1', NULL, 'Round-trip transport from Prague\nEnglish-speaking guide', 'Meals\nGratuities', 'This voucher (print or mobile)\nComfortable shoes and weather-appropriate clothing', NULL, 'Free cancellation up to 24 hours before start; non-refundable afterwards.', 'Meet at the Premiant office (Na Příkopě 23, Praha 1), or choose free hotel pickup.', NULL, 0, NULL),
(13, 2, NULL, NULL, 'Karlovy Vary – eGuide (self)', 'Karlovy Vary – eGuide (self)', NULL, 'placeholders/ag-2.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 570, 'weekly_pattern', 'direct_entry', 'date_required', 1, 0, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:08:48', NULL, NULL, 'Premiant Point — Na Příkopě 23, Praha 1', NULL, 'Round-trip transport from Prague\nEnglish-speaking guide', 'Meals\nGratuities', 'This voucher (print or mobile)\nComfortable shoes and weather-appropriate clothing', NULL, 'Free cancellation up to 24 hours before start; non-refundable afterwards.', 'Meet at the Premiant office (Na Příkopě 23, Praha 1), or choose free hotel pickup.', NULL, 0, NULL),
(14, 2, NULL, NULL, 'Terezín Memorial', 'Terezín Memorial', NULL, 'placeholders/ag-2.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 300, 'specific_dates', 'direct_entry', 'date_required', 1, 0, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:08:48', NULL, NULL, 'Premiant Point — Na Příkopě 23, Praha 1', NULL, 'Round-trip transport from Prague\nEnglish-speaking guide', 'Meals\nGratuities', 'This voucher (print or mobile)\nComfortable shoes and weather-appropriate clothing', NULL, 'Free cancellation up to 24 hours before start; non-refundable afterwards.', 'Meet at the Premiant office (Na Příkopě 23, Praha 1), or choose free hotel pickup.', NULL, 0, NULL),
(15, 2, NULL, NULL, 'Kutná Hora + Bone Church', 'Kutná Hora + Bone Church', NULL, 'placeholders/ag-2.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 390, 'specific_dates', 'direct_entry', 'date_required', 1, 0, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:08:48', NULL, NULL, 'Premiant Point — Na Příkopě 23, Praha 1', NULL, 'Round-trip transport from Prague\nEnglish-speaking guide', 'Meals\nGratuities', 'This voucher (print or mobile)\nComfortable shoes and weather-appropriate clothing', NULL, 'Free cancellation up to 24 hours before start; non-refundable afterwards.', 'Meet at the Premiant office (Na Příkopě 23, Praha 1), or choose free hotel pickup.', NULL, 0, NULL),
(16, 2, NULL, NULL, 'Kutná Hora – eGuide (self)', 'Kutná Hora – eGuide (self)', NULL, 'placeholders/ag-2.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 390, 'specific_dates', 'direct_entry', 'date_required', 1, 0, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:08:48', NULL, NULL, 'Premiant Point — Na Příkopě 23, Praha 1', NULL, 'Round-trip transport from Prague\nEnglish-speaking guide', 'Meals\nGratuities', 'This voucher (print or mobile)\nComfortable shoes and weather-appropriate clothing', NULL, 'Free cancellation up to 24 hours before start; non-refundable afterwards.', 'Meet at the Premiant office (Na Příkopě 23, Praha 1), or choose free hotel pickup.', NULL, 0, NULL),
(17, 2, NULL, NULL, 'Teplice – Royal Spa City', 'Teplice – Royal Spa City', NULL, 'placeholders/ag-2.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 660, 'continuous', 'direct_entry', 'open', 1, 0, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 16:05:26', NULL, NULL, 'Premiant Point — Na Příkopě 23, Praha 1', NULL, 'Self-guided audio eGuide for your mobile phone', 'Transport\r\nGuide\r\nAdmission fees', 'This voucher\r\nA smartphone and earphones', NULL, 'Free cancellation up to 24 hours before start; non-refundable afterwards.', 'Meet at the Premiant office (Na Příkopě 23, Praha 1), or choose free hotel pickup.', NULL, 0, NULL),
(18, 3, NULL, NULL, 'Český Krumlov Day Trip', 'Český Krumlov Day Trip', NULL, 'placeholders/ag-3.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 600, 'weekly_pattern', 'direct_entry', 'date_required', 1, 0, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:08:48', NULL, NULL, 'Na Florenci 33, Praha 1', NULL, NULL, NULL, NULL, NULL, NULL, 'Meet at Na Florenci 33, or choose free hotel pickup.', NULL, 0, NULL),
(19, 3, NULL, NULL, 'Karlštejn Castle', 'Karlštejn Castle', NULL, 'placeholders/ag-3.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 300, 'fixed_daily', 'direct_entry', 'date_required', 1, 0, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:08:48', NULL, NULL, 'Na Florenci 33, Praha 1', NULL, NULL, NULL, NULL, NULL, NULL, 'Meet at Na Florenci 33, or choose free hotel pickup.', NULL, 0, NULL),
(20, 3, NULL, NULL, 'Karlovy Vary Spa Town', 'Karlovy Vary Spa Town', NULL, 'placeholders/ag-3.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 540, 'weekly_pattern', 'direct_entry', 'date_required', 1, 0, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:08:48', NULL, NULL, 'Na Florenci 33, Praha 1', NULL, NULL, NULL, NULL, NULL, NULL, 'Meet at Na Florenci 33, or choose free hotel pickup.', NULL, 0, NULL),
(21, 3, NULL, NULL, 'Kutná Hora & Bone Church', 'Kutná Hora & Bone Church', NULL, 'placeholders/ag-3.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 360, 'weekly_pattern', 'direct_entry', 'date_required', 1, 0, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:08:48', NULL, NULL, 'Na Florenci 33, Praha 1', NULL, NULL, NULL, NULL, NULL, NULL, 'Meet at Na Florenci 33, or choose free hotel pickup.', NULL, 0, NULL),
(22, 3, NULL, NULL, 'Terezín Memorial', 'Terezín Memorial', NULL, 'placeholders/ag-3.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 360, 'weekly_pattern', 'direct_entry', 'date_required', 1, 0, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:08:48', NULL, NULL, 'Na Florenci 33, Praha 1', NULL, NULL, NULL, NULL, NULL, NULL, 'Meet at Na Florenci 33, or choose free hotel pickup.', NULL, 0, NULL),
(23, 3, NULL, NULL, 'Best of Prague', 'Best of Prague', NULL, 'placeholders/ag-3.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 390, 'weekly_pattern', 'direct_entry', 'date_required', 1, 0, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:08:48', NULL, NULL, 'Na Florenci 33, Praha 1', NULL, NULL, NULL, NULL, NULL, NULL, 'Meet at Na Florenci 33, or choose free hotel pickup.', NULL, 0, NULL),
(24, 3, NULL, NULL, 'City Tour', 'City Tour', NULL, 'placeholders/ag-3.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 150, 'fixed_daily', 'direct_entry', 'date_required', 1, 0, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:08:48', NULL, NULL, 'Na Florenci 33, Praha 1', NULL, NULL, NULL, NULL, NULL, NULL, 'Meet at Na Florenci 33, or choose free hotel pickup.', NULL, 0, NULL),
(25, 3, NULL, NULL, 'Old Town Prague', 'Old Town Prague', NULL, 'placeholders/ag-3.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 120, 'specific_dates', 'direct_entry', 'date_required', 1, 0, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:08:48', NULL, NULL, 'Na Florenci 33, Praha 1', NULL, NULL, NULL, NULL, NULL, NULL, 'Meet at Na Florenci 33, or choose free hotel pickup.', NULL, 0, NULL),
(26, 3, NULL, NULL, 'Folklore Evening', 'Folklore Evening', NULL, 'placeholders/ag-3.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 180, 'weekly_pattern', 'direct_entry', 'date_required', 1, 0, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:08:48', NULL, NULL, 'Na Florenci 33, Praha 1', NULL, NULL, NULL, NULL, NULL, NULL, 'Meet at Na Florenci 33, or choose free hotel pickup.', NULL, 0, NULL),
(27, 3, NULL, NULL, 'River Cruise with Dinner', 'River Cruise with Dinner', NULL, 'placeholders/ag-3.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 180, 'weekly_pattern', 'direct_entry', 'date_required', 1, 0, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:08:48', NULL, NULL, 'Na Florenci 33, Praha 1', NULL, NULL, NULL, NULL, NULL, NULL, 'Meet at Na Florenci 33, or choose free hotel pickup.', NULL, 0, NULL),
(28, 3, NULL, NULL, 'Prague Jewish Town', 'Prague Jewish Town', NULL, 'placeholders/ag-3.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 180, 'multiple_daily', 'direct_entry', 'date_required', 1, 0, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:08:48', NULL, NULL, 'Na Florenci 33, Praha 1', NULL, NULL, NULL, NULL, NULL, NULL, 'Meet at Na Florenci 33, or choose free hotel pickup.', NULL, 0, NULL),
(29, 3, NULL, NULL, 'Shopping Tour (Fashion Arena)', 'Shopping Tour (Fashion Arena)', NULL, 'placeholders/ag-3.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 150, 'multiple_daily', 'direct_entry', 'date_required', 1, 0, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:08:48', NULL, NULL, 'Na Florenci 33, Praha 1', NULL, NULL, NULL, NULL, 'Transfer pricing for 2-3 passengers. Larger groups: see brochure / on request.', NULL, 'Meet at Na Florenci 33, or choose free hotel pickup.', NULL, 0, NULL),
(30, 3, NULL, NULL, 'Airport Transfer', NULL, NULL, 'placeholders/ag-3.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 'on_demand', 'direct_entry', 'date_required', 1, 0, 1, NULL, 'tbc_agency', 'inactive', 0, '2026-06-01 06:52:56', '2026-06-02 18:08:01', NULL, NULL, 'Na Florenci 1413/33, Praha 1', NULL, NULL, NULL, NULL, NULL, NULL, 'Meet at Na Florenci 33, or choose free hotel pickup.', NULL, 0, NULL),
(31, 3, NULL, NULL, 'Private Tours', NULL, NULL, 'placeholders/ag-3.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 'on_demand', 'direct_entry', 'date_required', 1, 0, 1, NULL, 'tbc_agency', 'inactive', 0, '2026-06-01 06:52:56', '2026-06-02 18:08:01', NULL, NULL, 'Na Florenci 1413/33, Praha 1', NULL, NULL, NULL, NULL, NULL, NULL, 'Meet at Na Florenci 33, or choose free hotel pickup.', NULL, 0, NULL),
(32, 4, NULL, NULL, 'Prague Historical City', 'Prague Historical City', NULL, 'placeholders/ag-4.svg', NULL, NULL, NULL, NULL, '26 languages (audio); live guide EN', NULL, NULL, 0, 120, 'multiple_daily', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:11:36', NULL, NULL, 'Staroměstské náměstí, Praha 1', NULL, NULL, NULL, NULL, NULL, NULL, 'Choose your departure stop when booking — A: Old Town Square (corner of Pařížská 1, beside St. Nicholas Church, Old Town). B: náměstí Republiky 3 (in front of the Hybernia Palace, opposite the Municipal House).', 'Stop A – Old Town Square||Old Town Square (corner of Pařížská 1, beside St. Nicholas Church), Praha 1\nStop B – náměstí Republiky||náměstí Republiky 3 (in front of the Hybernia Palace), Praha 1', 0, NULL),
(33, 4, NULL, NULL, 'Jewish Prague', 'Jewish Prague', NULL, 'placeholders/ag-4.svg', NULL, NULL, NULL, NULL, '26 languages (audio); live guide EN', NULL, NULL, 0, 180, 'multiple_daily', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:11:36', NULL, NULL, 'Staroměstské náměstí, Praha 1', NULL, NULL, NULL, NULL, NULL, NULL, 'Choose your departure stop when booking — A: Old Town Square (corner of Pařížská 1, beside St. Nicholas Church, Old Town). B: náměstí Republiky 3 (in front of the Hybernia Palace, opposite the Municipal House).', 'Stop A – Old Town Square||Old Town Square (corner of Pařížská 1, beside St. Nicholas Church), Praha 1\nStop B – náměstí Republiky||náměstí Republiky 3 (in front of the Hybernia Palace), Praha 1', 0, NULL),
(34, 4, NULL, NULL, 'Český Krumlov', 'Český Krumlov', NULL, 'placeholders/ag-4.svg', NULL, NULL, NULL, NULL, 'audio průvodce v 26 jazycích', NULL, NULL, 0, 600, 'weekly_pattern', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:11:35', NULL, NULL, 'Staroměstské náměstí, Praha 1', NULL, NULL, NULL, NULL, NULL, NULL, 'Choose your departure stop when booking — A: Old Town Square (corner of Pařížská 1, beside St. Nicholas Church, Old Town). B: náměstí Republiky 3 (in front of the Hybernia Palace, opposite the Municipal House).', 'Stop A – Old Town Square||Old Town Square (corner of Pařížská 1, beside St. Nicholas Church), Praha 1\nStop B – náměstí Republiky||náměstí Republiky 3 (in front of the Hybernia Palace), Praha 1', 0, NULL),
(35, 4, NULL, NULL, 'Karlštejn Castle', 'Karlštejn Castle', NULL, 'placeholders/ag-4.svg', NULL, NULL, NULL, NULL, '26 languages (audio); live guide EN', NULL, NULL, 0, 300, 'fixed_daily', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:11:36', NULL, NULL, 'Staroměstské náměstí, Praha 1', NULL, NULL, NULL, NULL, NULL, NULL, 'Choose your departure stop when booking — A: Old Town Square (corner of Pařížská 1, beside St. Nicholas Church, Old Town). B: náměstí Republiky 3 (in front of the Hybernia Palace, opposite the Municipal House).', 'Stop A – Old Town Square||Old Town Square (corner of Pařížská 1, beside St. Nicholas Church), Praha 1\nStop B – náměstí Republiky||náměstí Republiky 3 (in front of the Hybernia Palace), Praha 1', 0, NULL),
(36, 4, NULL, NULL, 'Karlovy Vary Spa Town', 'Karlovy Vary Spa Town', NULL, 'placeholders/ag-4.svg', NULL, NULL, NULL, NULL, '26 languages (audio); live guide EN', NULL, NULL, 0, 540, 'weekly_pattern', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:11:36', NULL, NULL, 'Staroměstské náměstí, Praha 1', NULL, NULL, NULL, NULL, NULL, NULL, 'Choose your departure stop when booking — A: Old Town Square (corner of Pařížská 1, beside St. Nicholas Church, Old Town). B: náměstí Republiky 3 (in front of the Hybernia Palace, opposite the Municipal House).', 'Stop A – Old Town Square||Old Town Square (corner of Pařížská 1, beside St. Nicholas Church), Praha 1\nStop B – náměstí Republiky||náměstí Republiky 3 (in front of the Hybernia Palace), Praha 1', 0, NULL),
(37, 4, NULL, NULL, 'Kutná Hora & Ossuary (Bone Church)', 'Kutná Hora & Ossuary (Bone Church)', NULL, 'placeholders/ag-4.svg', NULL, NULL, NULL, NULL, '26 languages (audio); live guide EN', NULL, NULL, 0, 360, 'weekly_pattern', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:11:36', NULL, NULL, 'Staroměstské náměstí, Praha 1', NULL, NULL, NULL, NULL, NULL, NULL, 'Choose your departure stop when booking — A: Old Town Square (corner of Pařížská 1, beside St. Nicholas Church, Old Town). B: náměstí Republiky 3 (in front of the Hybernia Palace, opposite the Municipal House).', 'Stop A – Old Town Square||Old Town Square (corner of Pařížská 1, beside St. Nicholas Church), Praha 1\nStop B – náměstí Republiky||náměstí Republiky 3 (in front of the Hybernia Palace), Praha 1', 0, NULL),
(38, 4, NULL, NULL, 'Terezín Memorial', 'Terezín Memorial', NULL, 'placeholders/ag-4.svg', NULL, NULL, NULL, NULL, '26 languages (audio); live guide EN', NULL, NULL, 0, 360, 'weekly_pattern', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:11:36', NULL, NULL, 'Staroměstské náměstí, Praha 1', NULL, NULL, NULL, NULL, NULL, NULL, 'Choose your departure stop when booking — A: Old Town Square (corner of Pařížská 1, beside St. Nicholas Church, Old Town). B: náměstí Republiky 3 (in front of the Hybernia Palace, opposite the Municipal House).', 'Stop A – Old Town Square||Old Town Square (corner of Pařížská 1, beside St. Nicholas Church), Praha 1\nStop B – náměstí Republiky||náměstí Republiky 3 (in front of the Hybernia Palace), Praha 1', 0, NULL),
(39, 4, NULL, NULL, 'Prague Castle in detail (incl. Interiors)', 'Prague Castle in detail (incl. Interiors)', NULL, 'placeholders/ag-4.svg', NULL, NULL, NULL, NULL, '26 languages (audio); live guide EN', NULL, NULL, 0, 210, 'multiple_daily', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:11:36', NULL, NULL, 'Staroměstské náměstí, Praha 1', NULL, NULL, NULL, NULL, NULL, NULL, 'Choose your departure stop when booking — A: Old Town Square (corner of Pařížská 1, beside St. Nicholas Church, Old Town). B: náměstí Republiky 3 (in front of the Hybernia Palace, opposite the Municipal House).', 'Stop A – Old Town Square||Old Town Square (corner of Pařížská 1, beside St. Nicholas Church), Praha 1\nStop B – náměstí Republiky||náměstí Republiky 3 (in front of the Hybernia Palace), Praha 1', 0, NULL),
(40, 4, NULL, NULL, 'Live Guided City Tour with Prague Castle', 'Live Guided City Tour with Prague Castle', NULL, 'placeholders/ag-4.svg', NULL, NULL, NULL, NULL, '26 languages (audio); live guide EN', NULL, NULL, 0, 210, 'fixed_daily', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:11:36', NULL, NULL, 'Staroměstské náměstí, Praha 1', NULL, NULL, NULL, NULL, NULL, NULL, 'Choose your departure stop when booking — A: Old Town Square (corner of Pařížská 1, beside St. Nicholas Church, Old Town). B: náměstí Republiky 3 (in front of the Hybernia Palace, opposite the Municipal House).', 'Stop A – Old Town Square||Old Town Square (corner of Pařížská 1, beside St. Nicholas Church), Praha 1\nStop B – náměstí Republiky||náměstí Republiky 3 (in front of the Hybernia Palace), Praha 1', 0, NULL),
(41, 4, NULL, NULL, 'Short River Cruise', 'Short River Cruise', NULL, 'placeholders/ag-4.svg', NULL, NULL, NULL, NULL, '26 languages (audio); live guide EN', NULL, NULL, 0, 60, 'multiple_daily', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:11:36', NULL, NULL, 'Staroměstské náměstí, Praha 1', NULL, NULL, NULL, NULL, NULL, NULL, 'Choose your departure stop when booking — A: Old Town Square (corner of Pařížská 1, beside St. Nicholas Church, Old Town). B: náměstí Republiky 3 (in front of the Hybernia Palace, opposite the Municipal House).', 'Stop A – Old Town Square||Old Town Square (corner of Pařížská 1, beside St. Nicholas Church), Praha 1\nStop B – náměstí Republiky||náměstí Republiky 3 (in front of the Hybernia Palace), Praha 1', 0, NULL),
(42, 4, NULL, NULL, 'Prague Historical City + 1 Hour Boat Trip', 'Prague Historical City + 1 Hour Boat Trip', NULL, 'placeholders/ag-4.svg', NULL, NULL, NULL, NULL, '26 languages (audio); live guide EN', NULL, NULL, 0, 180, 'specific_dates', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:11:36', NULL, NULL, 'Staroměstské náměstí, Praha 1', NULL, NULL, NULL, NULL, NULL, NULL, 'Choose your departure stop when booking — A: Old Town Square (corner of Pařížská 1, beside St. Nicholas Church, Old Town). B: náměstí Republiky 3 (in front of the Hybernia Palace, opposite the Municipal House).', 'Stop A – Old Town Square||Old Town Square (corner of Pařížská 1, beside St. Nicholas Church), Praha 1\nStop B – náměstí Republiky||náměstí Republiky 3 (in front of the Hybernia Palace), Praha 1', 0, NULL),
(43, 4, NULL, NULL, 'Short Prague Old Town City Tour', 'Short Prague Old Town City Tour', NULL, 'placeholders/ag-4.svg', NULL, NULL, NULL, NULL, '26 languages (audio); live guide EN', NULL, NULL, 0, 60, 'weekly_pattern', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:11:36', NULL, NULL, 'Staroměstské náměstí, Praha 1', NULL, NULL, NULL, NULL, NULL, NULL, 'Choose your departure stop when booking — A: Old Town Square (corner of Pařížská 1, beside St. Nicholas Church, Old Town). B: náměstí Republiky 3 (in front of the Hybernia Palace, opposite the Municipal House).', 'Stop A – Old Town Square||Old Town Square (corner of Pařížská 1, beside St. Nicholas Church), Praha 1\nStop B – náměstí Republiky||náměstí Republiky 3 (in front of the Hybernia Palace), Praha 1', 0, NULL),
(44, 4, NULL, NULL, 'Short Old Town City Tour + Short River Cruise', 'Short Old Town City Tour + Short River Cruise', NULL, 'placeholders/ag-4.svg', NULL, NULL, NULL, NULL, '26 languages (audio); live guide EN', NULL, NULL, 0, 120, 'weekly_pattern', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:11:36', NULL, NULL, 'Staroměstské náměstí, Praha 1', NULL, NULL, NULL, NULL, NULL, NULL, 'Choose your departure stop when booking — A: Old Town Square (corner of Pařížská 1, beside St. Nicholas Church, Old Town). B: náměstí Republiky 3 (in front of the Hybernia Palace, opposite the Municipal House).', 'Stop A – Old Town Square||Old Town Square (corner of Pařížská 1, beside St. Nicholas Church), Praha 1\nStop B – náměstí Republiky||náměstí Republiky 3 (in front of the Hybernia Palace), Praha 1', 0, NULL),
(45, 4, NULL, NULL, 'Prague Unlimited Tour – All inclusive', 'Prague Unlimited Tour – All inclusive', NULL, 'placeholders/ag-4.svg', NULL, NULL, NULL, NULL, '26 languages (audio); live guide EN', NULL, NULL, 0, 390, 'specific_dates', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:11:36', NULL, NULL, 'Staroměstské náměstí, Praha 1', NULL, NULL, NULL, NULL, NULL, NULL, 'Choose your departure stop when booking — A: Old Town Square (corner of Pařížská 1, beside St. Nicholas Church, Old Town). B: náměstí Republiky 3 (in front of the Hybernia Palace, opposite the Municipal House).', 'Stop A – Old Town Square||Old Town Square (corner of Pařížská 1, beside St. Nicholas Church), Praha 1\nStop B – náměstí Republiky||náměstí Republiky 3 (in front of the Hybernia Palace), Praha 1', 0, NULL),
(46, 4, NULL, NULL, 'Lunch River Cruise', 'Lunch River Cruise', NULL, 'placeholders/ag-4.svg', NULL, NULL, NULL, NULL, '26 languages (audio); live guide EN', NULL, NULL, 0, 150, 'fixed_daily', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:11:36', NULL, NULL, 'Staroměstské náměstí, Praha 1', NULL, NULL, NULL, NULL, NULL, NULL, 'Choose your departure stop when booking — A: Old Town Square (corner of Pařížská 1, beside St. Nicholas Church, Old Town). B: náměstí Republiky 3 (in front of the Hybernia Palace, opposite the Municipal House).', 'Stop A – Old Town Square||Old Town Square (corner of Pařížská 1, beside St. Nicholas Church), Praha 1\nStop B – náměstí Republiky||náměstí Republiky 3 (in front of the Hybernia Palace), Praha 1', 0, NULL),
(47, 4, NULL, NULL, 'Evening River Cruise with Dinner', 'Evening River Cruise with Dinner', NULL, 'placeholders/ag-4.svg', NULL, NULL, NULL, NULL, '26 languages (audio); live guide EN', NULL, NULL, 0, 210, 'weekly_pattern', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:11:36', NULL, NULL, 'Staroměstské náměstí, Praha 1', NULL, NULL, NULL, NULL, NULL, NULL, 'Choose your departure stop when booking — A: Old Town Square (corner of Pařížská 1, beside St. Nicholas Church, Old Town). B: náměstí Republiky 3 (in front of the Hybernia Palace, opposite the Municipal House).', 'Stop A – Old Town Square||Old Town Square (corner of Pařížská 1, beside St. Nicholas Church), Praha 1\nStop B – náměstí Republiky||náměstí Republiky 3 (in front of the Hybernia Palace), Praha 1', 0, NULL),
(48, 5, NULL, NULL, 'Swan Lake Ballet', NULL, NULL, 'placeholders/ag-5.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 150, 'specific_dates', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:03:39', NULL, NULL, 'Broadway Theatre, Na Příkopě 31, Praha 1', NULL, 'Show admission', NULL, NULL, NULL, NULL, 'Broadway passage (entrance from Na Příkopě 31 or Celetná 38). Show your voucher at the box office.', NULL, 1, NULL),
(49, 5, NULL, NULL, 'Best of Czech and World Classical Music', NULL, NULL, 'placeholders/ag-5.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 'weekly_pattern', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:03:39', NULL, NULL, 'Church of St. Martin in the Wall, Martinská 8, Praha 1', NULL, 'Concert admission', NULL, NULL, NULL, 'Free cancellation up to 24 hours before the concert; non-refundable afterwards.', 'Please arrive 20 minutes before the concert; show this voucher at the box office.', NULL, 1, NULL),
(50, 5, NULL, NULL, 'Concert @ Hybernia (TBD program)', NULL, NULL, 'placeholders/ag-5.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 'specific_dates', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'archived', 0, '2026-06-01 06:52:56', '2026-06-02 13:03:39', NULL, NULL, NULL, NULL, 'Concert admission', NULL, NULL, NULL, 'Free cancellation up to 24 hours before the concert; non-refundable afterwards.', 'Please arrive 20 minutes before the concert and show this voucher at the box office.', NULL, 1, NULL),
(51, 5, NULL, NULL, 'Concert @ Smetana Hall (TBD program)', NULL, NULL, 'placeholders/ag-5.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 'specific_dates', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'archived', 0, '2026-06-01 06:52:56', '2026-06-02 13:03:39', NULL, NULL, NULL, NULL, 'Concert admission', NULL, NULL, NULL, 'Free cancellation up to 24 hours before the concert; non-refundable afterwards.', 'Please arrive 20 minutes before the concert and show this voucher at the box office.', NULL, 1, NULL),
(52, 5, NULL, NULL, 'Concert @ Klementinum Mirror Chapel', NULL, NULL, 'placeholders/ag-5.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 'specific_dates', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'archived', 0, '2026-06-01 06:52:56', '2026-06-02 13:03:39', NULL, NULL, NULL, NULL, 'Concert admission', NULL, NULL, NULL, 'Free cancellation up to 24 hours before the concert; non-refundable afterwards.', 'Please arrive 20 minutes before the concert and show this voucher at the box office.', NULL, 1, NULL),
(53, 5, NULL, NULL, 'Concert @ St. George\'s Basilica', NULL, NULL, 'placeholders/ag-5.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 'specific_dates', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'archived', 0, '2026-06-01 06:52:56', '2026-06-02 13:03:39', NULL, NULL, NULL, NULL, 'Concert admission', NULL, NULL, NULL, 'Free cancellation up to 24 hours before the concert; non-refundable afterwards.', 'Please arrive 20 minutes before the concert and show this voucher at the box office.', NULL, 1, NULL),
(54, 5, NULL, NULL, 'Concert @ St. Cajetan', NULL, NULL, 'placeholders/ag-5.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 'specific_dates', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'archived', 0, '2026-06-01 06:52:56', '2026-06-02 13:03:39', NULL, NULL, NULL, NULL, 'Concert admission', NULL, NULL, NULL, 'Free cancellation up to 24 hours before the concert; non-refundable afterwards.', 'Please arrive 20 minutes before the concert and show this voucher at the box office.', NULL, 1, NULL),
(55, 5, NULL, NULL, 'Christmas Concerts @ Martin', NULL, NULL, 'placeholders/ag-5.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 'seasonal', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'archived', 0, '2026-06-01 06:52:56', '2026-06-02 13:03:39', NULL, NULL, 'Church of St. Martin in the Wall, Martinská 8, Praha 1', NULL, 'Concert admission', NULL, NULL, NULL, 'Free cancellation up to 24 hours before the concert; non-refundable afterwards.', 'Please arrive 20 minutes before the concert and show this voucher at the box office.', NULL, 1, NULL),
(56, 5, NULL, NULL, 'Easter Concerts', NULL, NULL, 'placeholders/ag-5.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 'seasonal', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'archived', 0, '2026-06-01 06:52:56', '2026-06-02 13:03:39', NULL, NULL, NULL, NULL, 'Concert admission', NULL, NULL, NULL, 'Free cancellation up to 24 hours before the concert; non-refundable afterwards.', 'Please arrive 20 minutes before the concert and show this voucher at the box office.', NULL, 1, NULL),
(57, 6, NULL, NULL, 'Concert @ Rudolfinum Suk Hall', NULL, NULL, 'placeholders/ag-6.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 'specific_dates', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:03:39', NULL, NULL, 'Rudolfinum – Suk Hall, Alšovo nábřeží 12, Praha 1', NULL, 'Concert admission', NULL, NULL, 'Student price requires a valid ISIC card. Please arrive 20 minutes before the concert.', 'Free cancellation up to 24 hours before the concert; non-refundable afterwards.', 'Please arrive 20 minutes before the concert and show this voucher at the box office.', NULL, 1, NULL),
(58, 6, NULL, NULL, 'Concert @ Lichtenštejnský palác', NULL, NULL, 'placeholders/ag-6.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 'specific_dates', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:03:39', NULL, NULL, 'Lichtenstein Palace – B. Martinů Hall, Malostranské náměstí 13, Praha 1', NULL, 'Concert admission', NULL, NULL, 'Student price requires a valid ISIC card. Please arrive 20 minutes before the concert.', 'Free cancellation up to 24 hours before the concert; non-refundable afterwards.', 'Please arrive 20 minutes before the concert and show this voucher at the box office.', NULL, 1, NULL),
(59, 7, NULL, NULL, 'Mozart Dinner (unlimited drinks)', 'Mozart Dinner (unlimited drinks)', NULL, 'placeholders/ag-7.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 180, 'fixed_daily', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:05:51', NULL, NULL, 'Grand Hotel Bohemia – Boccaccio Ballroom, Králodvorská 4 (side entrance), Praha 1', NULL, '3-course dinner (Czech & Austrian cuisine)\nLive Mozart concert (arias, duets, instrumental)', 'Drinks\nGratuities', NULL, 'Smart-casual dress. Non-smoking inside the hall.', 'Free cancellation up to 24 hours before start; non-refundable afterwards.', 'Please arrive 15 minutes before the start. Seating is by arrival time.', NULL, 1, NULL),
(60, 7, NULL, NULL, 'Mozart Dinner (welcome drink)', 'Mozart Dinner (welcome drink)', NULL, 'placeholders/ag-7.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 180, 'fixed_daily', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:05:51', NULL, NULL, 'Grand Hotel Bohemia – Boccaccio Ballroom, Králodvorská 4 (side entrance), Praha 1', NULL, '3-course dinner (Czech & Austrian cuisine)\nLive Mozart concert (arias, duets, instrumental)', 'Drinks\nGratuities', NULL, 'Smart-casual dress. Non-smoking inside the hall.', 'Free cancellation up to 24 hours before start; non-refundable afterwards.', 'Please arrive 15 minutes before the start. Seating is by arrival time.', NULL, 1, NULL),
(61, 7, NULL, NULL, 'Mozart Gold Dinner (4-course)', 'Mozart Gold Dinner (4-course)', NULL, 'placeholders/ag-7.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 180, 'fixed_daily', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:05:51', NULL, NULL, 'Grand Hotel Bohemia – Boccaccio Ballroom, Králodvorská 4 (side entrance), Praha 1', NULL, '3-course dinner (Czech & Austrian cuisine)\nLive Mozart concert (arias, duets, instrumental)', 'Drinks\nGratuities', NULL, 'Smart-casual dress. Non-smoking inside the hall.', 'Free cancellation up to 24 hours before start; non-refundable afterwards.', 'Please arrive 15 minutes before the start. Seating is by arrival time.', NULL, 1, NULL),
(62, 7, NULL, NULL, 'Mozart Concert (no dinner)', 'Mozart Concert (no dinner)', NULL, 'placeholders/ag-7.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 90, 'fixed_daily', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:05:51', NULL, NULL, 'Grand Hotel Bohemia – Boccaccio Ballroom, Králodvorská 4 (side entrance), Praha 1', NULL, '3-course dinner (Czech & Austrian cuisine)\nLive Mozart concert (arias, duets, instrumental)', 'Drinks\nGratuities', NULL, 'Smart-casual dress. Non-smoking inside the hall.', 'Free cancellation up to 24 hours before start; non-refundable afterwards.', 'Please arrive 15 minutes before the start. Seating is by arrival time.', NULL, 1, NULL),
(63, 7, NULL, NULL, 'Christmas Dinner', NULL, NULL, 'placeholders/ag-7.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 180, 'specific_dates', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'inactive', 0, '2026-06-01 06:52:56', '2026-06-02 18:08:01', NULL, NULL, 'Grand Hotel Bohemia – Boccaccio Ballroom, Králodvorská 4 (side entrance), Praha 1', NULL, '3-course dinner (Czech & Austrian cuisine)\nLive Mozart concert (arias, duets, instrumental)', 'Drinks\nGratuities', NULL, 'Smart-casual dress. Non-smoking inside the hall.', 'Free cancellation up to 24 hours before start; non-refundable afterwards.', 'Please arrive 15 minutes before the start. Seating is by arrival time.', NULL, 1, NULL),
(64, 7, NULL, NULL, 'NYE Gala', NULL, NULL, 'placeholders/ag-7.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 240, 'specific_dates', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'inactive', 0, '2026-06-01 06:52:56', '2026-06-02 18:08:01', NULL, NULL, 'Grand Hotel Bohemia – Boccaccio Ballroom, Králodvorská 4 (side entrance), Praha 1', NULL, '3-course dinner (Czech & Austrian cuisine)\nLive Mozart concert (arias, duets, instrumental)', 'Drinks\nGratuities', NULL, 'Smart-casual dress. Non-smoking inside the hall.', 'Free cancellation up to 24 hours before start; non-refundable afterwards.', 'Please arrive 15 minutes before the start. Seating is by arrival time.', NULL, 1, NULL),
(65, 8, NULL, NULL, 'Alchemy & Mysteries of Prague Castle', 'Alchemy & Mysteries of Prague Castle', NULL, 'placeholders/ag-8.svg', NULL, NULL, NULL, NULL, 'EN, DE', NULL, NULL, 0, 180, 'multiple_daily', 'direct_entry', 'date_required', 1, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:11:36', NULL, NULL, 'Týnská 627/7, 110 00 Praha 1 (před budovou č. 7)', NULL, 'Professional guide\nHotel pickup and drop-off\nGratuities\nTour in EN or DE (per selected option)\nSmall-group walking tour', 'Tram ticket\nEntries/interiors (unless stated)', NULL, 'Evening tour. Exterior only (no interiors). Min. 2 pax. Tram ticket not included. Not wheelchair/stroller accessible. Comfortable shoes recommended.', 'Min. 2 osoby na rezervaci. Při nenaplnění může být zájezd po potvrzení zrušen – nabídnut náhradní termín nebo plná refundace.', 'Starting point in front of the building at Týnská 7.', NULL, 0, NULL),
(66, 8, NULL, NULL, 'Ghosts & Legends of Old Town', 'Ghosts & Legends of Old Town', NULL, 'placeholders/ag-8.svg', NULL, NULL, NULL, NULL, 'EN, DE', NULL, NULL, 0, 90, 'multiple_daily', 'direct_entry', 'date_required', 1, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:11:36', NULL, NULL, 'Týnská 627/7, 110 00 Praha 1 (před budovou č. 7)', NULL, 'Professional guide\nHotel pickup and drop-off\nGratuities\nTour in EN or DE (per selected option)', 'Tram ticket\nEntries/interiors (unless stated)', NULL, 'Evening tour. Min. 2 pax. Arrive 10 min early. Not wheelchair accessible. Price per person; set schedule.', 'Min. 2 osoby na rezervaci. Při nenaplnění může být zájezd po potvrzení zrušen – nabídnut náhradní termín nebo plná refundace.', 'Starting point in front of the building at Týnská 7.', NULL, 0, NULL),
(67, 8, NULL, NULL, 'Psychiatric Hospital & Abandoned Cemetery', 'Psychiatric Hospital & Abandoned Cemetery', NULL, 'placeholders/ag-8.svg', NULL, NULL, NULL, NULL, 'EN', NULL, NULL, 0, 180, 'multiple_daily', 'direct_entry', 'date_required', 1, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:11:36', NULL, NULL, 'Psychiatrická nemocnice Bohnice, Ústavní 91, 181 00 Praha 8 (před branou)', NULL, 'Professional guide\nHotel pickup and drop-off\nGratuities\nInterior visit of the hospital buildings', 'Tram ticket\nEntries/interiors (unless stated)', NULL, 'Dark history of psychiatry – not recommended for small children. Min. 2 pax. Not wheelchair/stroller accessible. Comfortable shoes; bottle of water.', 'Min. 2 osoby na rezervaci. Při nenaplnění může být zájezd po potvrzení zrušen – nabídnut náhradní termín nebo plná refundace.', 'Starting point in front of the building at Týnská 7.', NULL, 0, NULL),
(68, 8, NULL, NULL, 'Prague Castle Tour & Canal River Cruise', 'Prague Castle Tour & Canal River Cruise', NULL, 'placeholders/ag-8.svg', NULL, NULL, NULL, NULL, 'EN', NULL, NULL, 0, 180, 'multiple_daily', 'direct_entry', 'date_required', 1, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:11:36', NULL, NULL, 'Týnská 627/7, 110 00 Praha 1 (před budovou č. 7)', NULL, 'Professional guide\nHotel pickup and drop-off\nGratuities\nRiver cruise with refreshments & on-board commentary', 'Tram ticket\nEntries/interiors (unless stated)', NULL, 'English only (private DE on request). Does NOT enter Prague Castle interior. Tram ticket not included. Min. 2 pax. Not wheelchair/stroller accessible.', 'Min. 2 osoby na rezervaci. Při nenaplnění může být zájezd po potvrzení zrušen – nabídnut náhradní termín nebo plná refundace.', 'Starting point in front of the building at Týnská 7.', NULL, 0, NULL),
(69, 8, NULL, NULL, 'World War 2 & Operation Anthropoid', 'World War 2 & Operation Anthropoid', NULL, 'placeholders/ag-8.svg', NULL, NULL, NULL, NULL, 'EN', NULL, NULL, 0, 180, 'multiple_daily', 'direct_entry', 'date_required', 1, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:11:36', NULL, NULL, 'Týnská 627/7, 110 00 Praha 1 (před budovou č. 7)', NULL, 'Knowledgeable guide\nVisit to Church of St Cyril and Methodius\nHotel pickup and drop-off\nGratuities', 'Tram ticket\nEntries/interiors (unless stated)', NULL, 'WW2 themes – not recommended for small children (children must be accompanied; free of charge). Min. 2 pax. Not wheelchair/stroller accessible. Bottle of water.', 'Min. 2 osoby na rezervaci. Při nenaplnění může být zájezd po potvrzení zrušen – nabídnut náhradní termín nebo plná refundace.', 'Starting point in front of the building at Týnská 7.', NULL, 0, NULL),
(70, 8, NULL, NULL, 'Prague Full-Day City Tour with Cruise & Lunch', 'Prague Full-Day City Tour with Cruise & Lunch', NULL, 'placeholders/ag-8.svg', NULL, NULL, NULL, NULL, 'EN', NULL, NULL, 0, 360, 'multiple_daily', 'direct_entry', 'date_required', 1, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:11:36', NULL, NULL, 'Týnská 627/7, 110 00 Praha 1 (před budovou č. 7)', NULL, 'Knowledgeable guide\nTraditional Czech lunch\nRiver cruise with refreshments & on-board commentary\nHotel pickup and drop-off\nGratuities', 'Tram ticket\nEntries/interiors (unless stated)', NULL, 'English only (private DE on request). Not recommended for children under 10. Tram ticket not included. Min. 2 pax. Not wheelchair/stroller accessible.', 'Min. 2 osoby na rezervaci. Při nenaplnění může být zájezd po potvrzení zrušen – nabídnut náhradní termín nebo plná refundace.', 'Starting point in front of the building at Týnská 7.', NULL, 0, NULL),
(71, 8, NULL, NULL, 'Highlights of Prague Old Town & Jewish Ghetto', 'Highlights of Prague Old Town & Jewish Ghetto', NULL, 'placeholders/ag-8.svg', NULL, NULL, NULL, NULL, 'EN', NULL, NULL, 0, 120, 'multiple_daily', 'direct_entry', 'date_required', 1, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:11:36', NULL, NULL, 'Týnská 627/7, 110 00 Praha 1 (před budovou č. 7)', NULL, 'Professional guide\nHotel pickup and drop-off\nGratuities\nBottle of water', 'Tram ticket\nEntries/interiors (unless stated)', NULL, 'English only (private DE on request). Min. 2 pax. Arrive 10 min early. Not wheelchair accessible. Price per person; set schedule.', 'Min. 2 osoby na rezervaci. Při nenaplnění může být zájezd po potvrzení zrušen – nabídnut náhradní termín nebo plná refundace.', 'Starting point in front of the building at Týnská 7.', NULL, 0, NULL);
INSERT INTO `products` (`id`, `agency_id`, `commission_pct`, `seller_bonus_pct`, `name_cs`, `name_en`, `name_de`, `image_path`, `variant_diagram_path`, `description_cs`, `description_en`, `description_de`, `languages`, `order_instructions`, `booking_url`, `has_contingent`, `duration_minutes`, `schedule_type`, `voucher_redemption_type`, `ticket_type`, `pickup_available`, `pickup_required`, `pickup_free`, `pickup_window_minutes`, `pickup_confirmation`, `status`, `is_featured`, `created_at`, `updated_at`, `deposit_fixed_czk`, `deposit_fixed_eur`, `meeting_point_address`, `map_url`, `included`, `excluded`, `what_to_bring`, `important_info`, `cancellation_policy`, `meeting_point_note`, `meeting_options`, `seating`, `addons`) VALUES
(72, 9, NULL, NULL, 'Sightseeing Cruise (50 min)', 'Sightseeing Cruise (50 min)', NULL, 'placeholders/ag-9.svg', NULL, 'Hodinová okružní plavba prosklenou lodí historickým centrem Prahy – jedna z nejoblíbenějších plaveb. Z paluby i ze salonu uvidíte nejznámější památky na obou březích Vltavy. Odplutí od Čechova mostu, pár minut od Staroměstského náměstí.', 'A one-hour sightseeing cruise on a glass-sided boat through the historic centre of Prague — one of the most popular trips. From the deck and the saloon you will see the best-known landmarks on both banks of the Vltava. Departs from Čech Bridge, a few minutes from the Old Town Square.', NULL, '16 languages (audio/printed guide)', NULL, NULL, 0, 50, 'multiple_daily', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 1, '2026-06-01 06:52:56', '2026-06-02 13:11:36', NULL, NULL, 'Dvořákovo nábřeží, molo 3B (u Čechova mostu), Praha 1', NULL, '50 min sightseeing on the Vltava\nOnline GPS guide (audio/text/photos, 30+ sights)\nPrinted guide in 16 languages\nFree Wi-Fi on board', 'Food and drinks\nGratuities', 'This voucher (print or mobile)\nA light jacket for the open deck', 'Boarding: Čechův most, molo 3B. Children 3–11; under 3 free. Latest check-in 10 min before departure.', 'Free cancellation up to 24 hours before departure; non-refundable afterwards.', 'The boat departs from Čech Bridge (Prague Boats pier). Please arrive 15 minutes before departure.', NULL, 0, NULL),
(73, 9, NULL, NULL, 'Prague Grand River Cruise (2h)', 'Prague Grand River Cruise (2h)', NULL, 'placeholders/ag-9.svg', NULL, 'Dvouhodinová klidná okružní plavba pro ty, kdo si chtějí Prahu užít beze spěchu a v pohodlí. Z prosklené lodi se otevírá výhled na Pražský hrad, proplouvá se pod Karlovým mostem a kolem Rudolfina a Národního divadla. Odplutí od Čechova mostu.', 'A relaxed two-hour cruise for those who want to enjoy Prague without rushing. From the glass-sided boat you take in Prague Castle, glide beneath Charles Bridge and pass the Rudolfinum and the National Theatre. Departs from Čech Bridge.', NULL, '16 languages (audio/printed guide)', NULL, NULL, 0, 120, 'multiple_daily', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:11:36', NULL, NULL, 'Dvořákovo nábřeží, molo 3B (u Čechova mostu), Praha 1', NULL, '2h sightseeing on the Vltava\nOnline GPS guide (30+ sights)\nPrinted guide in 16 languages\nFree Wi-Fi on board', 'Food and drinks\nGratuities', 'This voucher (print or mobile)\nA light jacket for the open deck', 'Boarding: Čechův most, molo 3B. Children 3–11; under 3 free. Latest check-in 10 min before departure.', 'Free cancellation up to 24 hours before departure; non-refundable afterwards.', 'The boat departs from Čech Bridge (Prague Boats pier). Please arrive 15 minutes before departure.', NULL, 0, NULL),
(74, 9, NULL, NULL, 'Evening Sightseeing Cruise (50 min)', 'Evening Sightseeing Cruise (50 min)', NULL, 'placeholders/ag-9.svg', NULL, 'Hodinová večerní okružní plavba prosklenou lodí – Praha v nasvícené kráse z paluby i ze salonu. Cestou míjíte nejznámější památky podél Vltavy. Odplutí od Čechova mostu.', 'A one-hour evening sightseeing cruise on a glass-sided boat — Prague at its illuminated best, seen from the deck and the saloon. The route passes the most famous landmarks along the Vltava. Departs from Čech Bridge.', NULL, '16 languages (audio/printed guide)', NULL, NULL, 0, 50, 'multiple_daily', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:11:36', NULL, NULL, 'Dvořákovo nábřeží, molo 3B (u Čechova mostu), Praha 1', NULL, '50 min sightseeing on the Vltava\nOnline GPS guide (audio/text/photos, 30+ sights)\nPrinted guide in 16 languages\nFree Wi-Fi on board', 'Food and drinks\nGratuities', 'This voucher (print or mobile)\nA light jacket for the open deck', 'Boarding: Čechův most, molo 3B. Children 3–11; under 3 free. Latest check-in 10 min before departure. Evening departures.', 'Free cancellation up to 24 hours before departure; non-refundable afterwards.', 'The boat departs from Čech Bridge (Prague Boats pier). Please arrive 15 minutes before departure.', NULL, 0, NULL),
(75, 9, NULL, NULL, 'Evening Eco-cruise with a Glass of Prosecco', 'Evening Eco-cruise with a Glass of Prosecco', NULL, 'placeholders/ag-9.svg', NULL, 'Hodinová večerní plavba na plně elektrické lodi (Marie d\'Bohemia nebo Bella Bohemia) – tiše a ekologicky. V ceně sklenka prosecca (nebo džus) a malé občerstvení; výhled z otevřené horní paluby i prosklených stěn, wi-fi zdarma a tištěný průvodce v 16 jazycích. Cestou Pražský hrad a Karlův most.', 'A one-hour evening cruise on a fully electric boat (Marie d\'Bohemia or Bella Bohemia) — quiet and eco-friendly. Includes a glass of Prosecco (or juice) and a light snack, views from the open top deck and the glass walls, free Wi-Fi and a printed guide in 16 languages. You pass Prague Castle and Charles Bridge.', NULL, '16 languages (audio/printed guide)', NULL, NULL, 0, 50, 'multiple_daily', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:11:36', NULL, NULL, 'Dvořákovo nábřeží, molo 3B (u Čechova mostu), Praha 1', NULL, '50 min evening eco-cruise\nGlass of prosecco or juice\nLight refreshments\nPrinted guide in 16 languages\nFree Wi-Fi on board', 'Additional drinks\nGratuities', 'This voucher (print or mobile)\nA light jacket for the open deck', 'Boarding: Čechův most, molo 3B. Children 3–11; under 3 free. Latest check-in 10 min before departure. Departures from 20:00.', 'Free cancellation up to 24 hours before departure; non-refundable afterwards.', 'The boat departs from Čech Bridge (Prague Boats pier). Please arrive 15 minutes before departure.', NULL, 0, NULL),
(76, 9, NULL, NULL, 'Beer Story Tour & Prague River Cruise', 'Beer Story Tour & Prague River Cruise', NULL, 'placeholders/ag-9.svg', NULL, 'Kombinovaná vstupenka spojující dva zážitky za cenu jednoho: návštěvu Pilsner Urquell: The Original Beer Experience (60 minut s ochutnávkou) a 50minutovou okružní plavbu na elektrické lodi kolem nejkrásnějších pražských památek. Kombinovanou vstupenku lze koupit pouze na pokladně na molu 3B.', 'A combined ticket pairing two experiences for the price of one: a visit to Pilsner Urquell: The Original Beer Experience (60 minutes, with a tasting) and a 50-minute sightseeing cruise on an electric boat past Prague\'s most beautiful landmarks. The combined ticket can only be purchased at the platform 3B ticket office.', NULL, '16 languages (audio/printed guide)', NULL, NULL, 0, 150, 'multiple_daily', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:11:36', NULL, NULL, 'Dvořákovo nábřeží, molo 3B (u Čechova mostu), Praha 1', NULL, 'Prague river cruise\nBeer story / tasting element\nOnline GPS guide\nFree Wi-Fi on board', 'Additional drinks and food\nGratuities', 'This voucher (print or mobile)', 'Boarding: Čechův most, molo 3B. Children 3–11; under 3 free. Latest check-in 10 min before departure.', 'Free cancellation up to 24 hours before departure; non-refundable afterwards.', 'The boat departs from Čech Bridge (Prague Boats pier). Please arrive 15 minutes before departure.', NULL, 0, NULL),
(77, 9, NULL, NULL, 'Cruise to Devil\'s Channel (Čertovka)', 'Cruise to Devil\'s Channel (Čertovka)', NULL, 'placeholders/ag-9.svg', NULL, 'Plavba malým člunem úzkým ramenem Vltavy zvaným Čertovka mezi ostrovem Kampa a Malou Stranou – zákoutí přezdívanému „pražské Benátky\" hned u Karlova mostu, s historickým mlýnským kolem. Komorní pohled na město z míst, kam velké lodě nedoplují.', 'A small-boat cruise along Čertovka, the narrow arm of the Vltava between Kampa Island and the Lesser Town — the corner nicknamed \"Prague\'s Venice\" right by Charles Bridge, with its historic mill wheel. An intimate view of the city from places the larger boats cannot reach.', NULL, '16 languages (audio/printed guide)', NULL, NULL, 0, 50, 'multiple_daily', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:11:36', NULL, NULL, 'Dvořákovo nábřeží, molo 3B (u Čechova mostu), Praha 1', NULL, '50 min sightseeing on the Vltava\nOnline GPS guide (audio/text/photos, 30+ sights)\nPrinted guide in 16 languages\nFree Wi-Fi on board', 'Food and drinks\nGratuities', 'This voucher (print or mobile)\nA light jacket for the open deck', 'Boarding: Čechův most, molo 3B. Children 3–11; under 3 free. Latest check-in 10 min before departure.', 'Free cancellation up to 24 hours before departure; non-refundable afterwards.', 'The boat departs from Čech Bridge (Prague Boats pier). Please arrive 15 minutes before departure.', NULL, 0, NULL),
(78, 9, NULL, NULL, 'Lunch Cruise on a Glass Boat (2h)', 'Lunch Cruise on a Glass Boat (2h)', NULL, 'placeholders/ag-9.svg', 'diagrams/prague-boats-2cat.svg', 'Dvouhodinová obědová plavba prosklenou lodí centrem Prahy. V ceně uvítací drink a teplý i studený raut – obědváte v klidu přímo na Vltavě, zatímco kolem oken plyne panorama města a hraje živá hudba. Po jídle se dá vyjít na otevřenou horní palubu za výhledy a fotkami. Odplutí ve 12:00 od Čechova mostu; trasa míjí Karlův most, Pražský hrad, Národní divadlo, Tančící dům a Vyšehrad. Dvě kategorie sezení – centrální salon a prémiová místa u oken.', 'A two-hour lunch cruise through the centre of Prague on a glass-sided boat. The ticket includes a welcome drink and a hot and cold buffet — a relaxed lunch right on the Vltava with the city panorama passing the windows and live music in the background. After the meal you can head up to the open top deck for views and photos. Departs at 12:00 from Čech Bridge, passing Charles Bridge, Prague Castle, the National Theatre, the Dancing House and Vyšehrad. Two seating categories: central saloon and premium seats by the windows.', NULL, '16 languages', NULL, 'https://www.prague-boats.cz/prague-lunch-cruise/', 0, 120, 'fixed_daily', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 1, '2026-06-01 06:52:56', '2026-06-02 13:11:36', NULL, NULL, 'Dvořákovo nábřeží, molo 3B (u Čechova mostu), Praha 1', NULL, '2h cruise on a glass boat\nWelcome drink\nBuffet lunch (all you can eat)\nLive music\nFree Wi-Fi', 'Drinks other than the welcome drink\nGratuities', 'This voucher (print or mobile)\nA light jacket for the open deck', 'Boarding: Čechův most, molo 3B. Children 3–11; under 3 free. Latest check-in 10 min before departure. Daily 12:00. Exclusive: min. 2 osoby. Animals not permitted.', 'Free cancellation up to 24 hours before departure; non-refundable afterwards.', 'The boat departs from Čech Bridge (Prague Boats pier). Please arrive 15 minutes before departure.', NULL, 0, NULL),
(79, 9, NULL, NULL, 'Crystal Dinner Cruise (3h)', 'Crystal Dinner Cruise (3h)', NULL, 'placeholders/ag-9.svg', 'diagrams/prague-boats-3cat.svg', 'Tříhodinová večerní plavba po Vltavě na prosklené lodi s posuvnou střechou – za příznivého počasí pod hvězdami, jinak za panoramatem skrz skleněné stěny. V ceně uvítací drink se sýrovou plnou a pečivem, bohatý teplý i studený raut formou all-you-can-eat a živá hudba. Odplutí ve 19:00 od Čechova mostu (5 minut od Staroměstského náměstí); cestou nasvícený Karlův most, Pražský hrad, Národní divadlo, Tančící dům a Vyšehrad. Místo si vybíráte podle kategorie sezení.', 'A three-hour evening cruise on the Vltava aboard a glass-sided boat with a sliding roof — under the stars in fair weather, or behind the glass walls when it is not. The ticket includes a welcome drink with a cheese platter and bread, a generous all-you-can-eat hot and cold buffet and live music. Departs at 19:00 from Čech Bridge, a five-minute walk from the Old Town Square, passing the illuminated Charles Bridge, Prague Castle, the National Theatre, the Dancing House and Vyšehrad. Choose your seat by category at booking.', NULL, '16 languages', 'Před prodejem ověř volné místo a potvrď rezervaci telefonicky (datum, čas, počet osob a kategorie sezení).', 'https://www.prague-boats.cz/crystal-dinner/', 0, 180, 'fixed_daily', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 1, '2026-06-01 06:52:56', '2026-06-02 13:11:36', NULL, NULL, 'Dvořákovo nábřeží, molo 3B (u Čechova mostu), Praha 1', NULL, '3h evening cruise (glass boat, sliding roof)\nWelcome drink with cheese platter\nGenerous buffet (all you can eat)\nLive music\nFree Wi-Fi', 'Drinks other than the welcome drink\nGratuities', 'This voucher (print or mobile)\nA light jacket for the open deck', 'Boarding: Čechův most, molo 3B. Children 3–11; under 3 free. Latest check-in 10 min before departure. Departure 19:00. De Luxe: min. 2 osoby.', 'Free cancellation up to 24 hours before departure; non-refundable afterwards.', 'The boat departs from Čech Bridge (Prague Boats pier). Please arrive 15 minutes before departure.', NULL, 0, NULL),
(80, 9, NULL, NULL, 'Dinner Cruise – Prague by Night (3h)', 'Dinner Cruise – Prague by Night (3h)', NULL, 'placeholders/ag-9.svg', 'diagrams/prague-boats-2cat.svg', 'Tříhodinová večerní plavba s rautovou večeří – ideální na romantický večer ve dvou, sešlost s přáteli, rodinnou oslavu i firemní setkání v netradičních kulisách. Pro nejlepší výhled na nasvícené město lze rezervovat garantované místo u okna. Odplutí ve 19:00 od Čechova mostu; večerní trasa míjí rozzářený Karlův most, Pražský hrad, Národní divadlo, Tančící dům a Vyšehrad. Dvě kategorie sezení.', 'A three-hour evening cruise with a buffet dinner — ideal for a romantic dinner for two, a get-together with friends, a family celebration or a business meeting against an unusual backdrop. For the best view of the illuminated city you can reserve a guaranteed window seat. Departs at 19:00 from Čech Bridge, the night-time route taking in the glowing Charles Bridge, Prague Castle, the National Theatre, the Dancing House and Vyšehrad. Two seating categories.', NULL, '16 languages', NULL, 'https://www.prague-boats.cz/prague-by-night-prague-dinner-cruise/', 0, 180, 'fixed_daily', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:11:36', NULL, NULL, 'Dvořákovo nábřeží, molo 3B (u Čechova mostu), Praha 1', NULL, '3h evening cruise through central Prague\nWelcome drink\nBuffet dinner (all you can eat)\nLive music\nFree Wi-Fi', 'Drinks other than the welcome drink\nGratuities', 'This voucher (print or mobile)\nA light jacket for the open deck', 'Boarding: Čechův most, molo 3B. Children 3–11; under 3 free. Latest check-in 10 min before departure. Departure 19:00. Essential: min. 2 osoby. Guaranteed window seat for extra charge.', 'Free cancellation up to 24 hours before departure; non-refundable afterwards.', 'The boat departs from Čech Bridge (Prague Boats pier). Please arrive 15 minutes before departure.', NULL, 0, NULL),
(81, 10, NULL, NULL, 'Čertovka 45min Cruise (Prague Venice)', 'Čertovka 45min Cruise (Prague Venice)', NULL, 'placeholders/ag-10.svg', NULL, NULL, NULL, NULL, '19 languages (audio guide)', NULL, NULL, 0, 45, 'continuous', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:11:36', NULL, NULL, 'Křižovnické náměstí 3, 110 00 Praha 1 (molo Judita pod Karlovým mostem)', NULL, '45-min cruise around Charles Bridge & the Čertovka canal\nFree admission to the Charles Bridge Museum\nFree Czech craft beer Krakonoš + refreshments\nAudio guide in 19 languages + disposable headphones', NULL, NULL, 'Departs every 10 minutes from the medieval Judith wharf beneath Charles Bridge; the boat leaves even with one passenger. Open 365 days. Hours: Jan–Apr & Oct–Dec 10:00–18:00; May–Jun & Sep 10:00–19:00; Jul–Aug 10:00–20:00. Child fare 2–12 years.', 'Free cancellation up to 24 hours before the cruise.', 'Departures from Křižovnické náměstí. First visit the Charles Bridge Museum to exchange your voucher for a boat ticket and free museum entry, then continue through the museum to the boarding point on the channel under Charles Bridge.', NULL, 0, NULL),
(82, 11, NULL, NULL, 'Afternoon Show (3-course)', 'Afternoon Show (3-course)', NULL, 'placeholders/ag-11.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 120, 'fixed_daily', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:08:48', NULL, NULL, 'Celetná 17, Praha 1', NULL, 'Live historic music\nDances with fire\nMedieval fencers\nWelcome Czech honey wine\nUnlimited drinks (beer, wine, soft drinks)\n3-course menu', NULL, NULL, 'Menu in 9 languages. Vegetarian / vegan menu at no extra charge.', NULL, NULL, NULL, 0, NULL),
(83, 11, NULL, NULL, 'Evening Show (5-course)', 'Evening Show (5-course)', NULL, 'placeholders/ag-11.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 150, 'fixed_daily', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:08:48', NULL, NULL, 'Celetná 17, Praha 1', NULL, 'Live historic music\nDances with fire\nMedieval fencers\nWelcome Czech honey wine\nUnlimited drinks (beer, wine, soft drinks)\n5-course menu (choice per course)', NULL, NULL, 'Menu in 9 languages. Vegetarian / vegan menu at no extra charge.', NULL, NULL, NULL, 0, NULL),
(84, 12, 30.00, NULL, 'HALLELUJAH', NULL, NULL, 'placeholders/ag-12.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 60, 'weekly_pattern', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:03:39', NULL, NULL, 'Spanish Synagogue, Vězeňská 1, Praha 1 – Josefov', NULL, 'Concert admission', NULL, NULL, NULL, 'Free cancellation up to 24 hours before the concert; non-refundable afterwards.', 'Please arrive 20 minutes before the concert; show this voucher at the box office.', NULL, 1, NULL),
(85, 12, 30.00, NULL, 'CARMINA BURANA / BOLERO', NULL, NULL, 'placeholders/ag-12.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 60, 'weekly_pattern', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:03:39', NULL, NULL, 'Spanish Synagogue, Vězeňská 1, Praha 1 – Josefov', NULL, 'Concert admission', NULL, NULL, NULL, 'Free cancellation up to 24 hours before the concert; non-refundable afterwards.', 'Please arrive 20 minutes before the concert; show this voucher at the box office.', NULL, 1, NULL),
(86, 12, 30.00, NULL, 'MUSICALS in concert', NULL, NULL, 'placeholders/ag-12.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 60, 'specific_dates', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:03:39', NULL, NULL, 'Spanish Synagogue, Vězeňská 1, Praha 1 – Josefov', NULL, 'Concert admission', NULL, NULL, NULL, 'Free cancellation up to 24 hours before the concert; non-refundable afterwards.', 'Please arrive 20 minutes before the concert; show this voucher at the box office.', NULL, 1, NULL),
(87, 12, 30.00, NULL, 'Best of Czech and world music', NULL, NULL, 'placeholders/ag-12.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 60, 'weekly_pattern', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:03:39', NULL, NULL, 'Spanish Synagogue, Vězeňská 1, Praha 1 – Josefov', NULL, 'Concert admission', NULL, NULL, NULL, 'Free cancellation up to 24 hours before the concert; non-refundable afterwards.', 'Please arrive 20 minutes before the concert; show this voucher at the box office.', NULL, 1, NULL),
(88, 13, NULL, NULL, 'Folklore Dinner Show', NULL, NULL, 'placeholders/ag-13.svg', NULL, NULL, NULL, NULL, 'Non-verbal', 'Rezervace nutná: dostupnost zkontroluj v kalendáři na webu folkloregarden.cz a rezervuj telefonicky na +420 724 334 340. Počet hostů není omezen.', 'https://www.folkloregarden.cz', 0, 180, 'on_demand', 'direct_entry', 'date_required', 1, 1, 0, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:08:23', NULL, NULL, 'Na Zlíchově 18, Praha 5 – Hlubočepy', NULL, 'Return transfer (hotel pickup)\n4-course dinner\nWelcome drink (mead)\nLive folklore show', 'Extra drinks\nGratuities', NULL, 'No minimum or maximum group size. The performance is non-verbal — traditional folk dance, a multi-course dinner and live music, so there is no language barrier.', NULL, 'Pickup z hotelové recepce 18:40–19:00 vlastním minibusem; show 19:00–22:00, drop-off zpět na hotel po 22:00.', NULL, 0, '[{\"label\": \"Special main course (upgrade)\", \"czk\": 75, \"eur\": 3}, {\"label\": \"Hotel transfer (return minibus)\", \"czk\": 300, \"eur\": 12}]'),
(89, 14, NULL, NULL, 'Range Shooting', NULL, NULL, 'placeholders/ag-14.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 'on_demand', 'direct_entry', 'date_required', 1, 1, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:06:52', NULL, NULL, 'IC Mostecká 53/4, Praha 1', NULL, 'English-speaking instructor\nBriefing (safety, gun handling, shooting techniques)\nRange fee (indoor or outdoor range)\nGuns rental (1-13 guns by package)\nGear (ammo, targets, eye & ear protection)\nRefreshment (mineral water)\nPick-up & drop-off + both-way transfer (AC minibus)', 'Gratuities\nPersonal expenses', 'This voucher (print or mobile)\nComfortable clothing and closed shoes', 'Exact pick-up time is confirmed by the agency. Minimum age, weight or health restrictions may apply — please check when booking. Weather-dependent activities may be rescheduled.', 'Free cancellation up to 24 hours before the activity.', 'We pick you up — at your hotel or at IC Mostecká 53/4, Praha 1. The agency confirms the exact time.', NULL, 0, NULL),
(90, 14, NULL, NULL, 'Tandem Skydiving', NULL, NULL, 'placeholders/ag-14.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 240, 'on_demand', 'direct_entry', 'date_required', 1, 1, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:06:52', NULL, NULL, 'IC Mostecká 53/4, Praha 1', NULL, 'English-speaking tandem skydiver\nBriefing & tandem jump simulation training\nEquipment (skydive suit, goggles)\n20-minute sightseeing flight\nTandem jump from 4,200 m, 1-minute free fall at 200 km/h\nTransfers (AC minibus from/to our office)', 'Gratuities\nPersonal expenses', 'This voucher (print or mobile)\nComfortable clothing and closed shoes', 'Exact pick-up time is confirmed by the agency. Minimum age, weight or health restrictions may apply — please check when booking. Weather-dependent activities may be rescheduled.', 'Free cancellation up to 24 hours before the activity.', 'We pick you up — at your hotel or at IC Mostecká 53/4, Praha 1. The agency confirms the exact time.', NULL, 0, NULL),
(91, 14, NULL, NULL, 'Horse Riding', NULL, NULL, 'placeholders/ag-14.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 120, 'on_demand', 'direct_entry', 'date_required', 1, 1, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:06:52', NULL, NULL, 'IC Mostecká 53/4, Praha 1', NULL, 'Pick-up & drop-off + both-way transfer (AC minibus)\nEnglish-speaking instructor\nBriefing (safety)\nEquipment (helmet)\n40-minute riding session\nRefreshment (mineral water)', 'Gratuities\nPersonal expenses', 'This voucher (print or mobile)\nComfortable clothing and closed shoes', 'Exact pick-up time is confirmed by the agency. Minimum age, weight or health restrictions may apply — please check when booking. Weather-dependent activities may be rescheduled.', 'Free cancellation up to 24 hours before the activity.', 'We pick you up — at your hotel or at IC Mostecká 53/4, Praha 1. The agency confirms the exact time.', NULL, 0, NULL),
(92, 14, NULL, NULL, 'Bungee Jumping', NULL, NULL, 'placeholders/ag-14.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 180, 'on_demand', 'direct_entry', 'date_required', 1, 1, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:06:52', NULL, NULL, 'IC Mostecká 53/4, Praha 1', NULL, 'Pick-up & drop-off + both-way transfer\nEnglish-speaking professional instructors\nBriefing (safety)\nBungee jump (62 m bridge or 36 m TV tower by package)\nWeight limit 40-160 kg', 'Gratuities\nPersonal expenses', 'This voucher (print or mobile)\nComfortable clothing and closed shoes', 'Exact pick-up time is confirmed by the agency. Minimum age, weight or health restrictions may apply — please check when booking. Weather-dependent activities may be rescheduled.', 'Free cancellation up to 24 hours before the activity.', 'We pick you up — at your hotel or at IC Mostecká 53/4, Praha 1. The agency confirms the exact time.', NULL, 0, NULL),
(93, 14, NULL, NULL, 'Go-Karting', NULL, NULL, 'placeholders/ag-14.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 90, 'on_demand', 'direct_entry', 'date_required', 1, 1, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:06:52', NULL, NULL, 'IC Mostecká 53/4, Praha 1', NULL, 'Pick-up & drop-off + both-way transfer\nEnglish-speaking instructor\nBriefing (safety)\nEquipment (go-karts, petrol, helmet, gloves)\n2 or 3 ten-minute rides by package\nRacing results printed after each ride', 'Gratuities\nPersonal expenses', 'This voucher (print or mobile)\nComfortable clothing and closed shoes', 'Exact pick-up time is confirmed by the agency. Minimum age, weight or health restrictions may apply — please check when booking. Weather-dependent activities may be rescheduled.', 'Free cancellation up to 24 hours before the activity.', 'We pick you up — at your hotel or at IC Mostecká 53/4, Praha 1. The agency confirms the exact time.', NULL, 0, NULL),
(94, 14, NULL, NULL, 'Bobsleigh Track', NULL, NULL, 'placeholders/ag-14.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 60, 'on_demand', 'direct_entry', 'date_required', 1, 1, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:06:52', NULL, NULL, 'IC Mostecká 53/4, Praha 1', NULL, 'Pick-up & drop-off + both-way transfer\nEnglish-speaking instructor\nBriefing (safety)\n5 rides on the bobsleigh track\nRefreshment (beer, wine or soft drink)', 'Gratuities\nPersonal expenses', 'This voucher (print or mobile)\nComfortable clothing and closed shoes', 'Exact pick-up time is confirmed by the agency. Minimum age, weight or health restrictions may apply — please check when booking. Weather-dependent activities may be rescheduled.', 'Free cancellation up to 24 hours before the activity.', 'We pick you up — at your hotel or at IC Mostecká 53/4, Praha 1. The agency confirms the exact time.', NULL, 0, NULL),
(95, 14, NULL, NULL, 'White Water Rafting', NULL, NULL, 'placeholders/ag-14.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 180, 'on_demand', 'direct_entry', 'date_required', 1, 1, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:06:52', NULL, NULL, 'IC Mostecká 53/4, Praha 1', NULL, 'Pick-up & drop-off + both-way transfer\nEnglish-speaking instructor\nBriefing (safety)\nEquipment (paddles, lifejacket, wetsuit, neoprene shoes, helmet, changing room, showers)\n6 rides on the world-class wildwater canal\nRefreshment (mineral water)', 'Gratuities\nPersonal expenses', 'This voucher (print or mobile)\nComfortable clothing and closed shoes', 'Exact pick-up time is confirmed by the agency. Minimum age, weight or health restrictions may apply — please check when booking. Weather-dependent activities may be rescheduled.', 'Free cancellation up to 24 hours before the activity.', 'We pick you up — at your hotel or at IC Mostecká 53/4, Praha 1. The agency confirms the exact time.', NULL, 0, NULL),
(96, 14, NULL, NULL, 'Hot Air Ballooning', NULL, NULL, 'placeholders/ag-14.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 180, 'on_demand', 'direct_entry', 'date_required', 1, 1, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:06:52', NULL, NULL, 'IC Mostecká 53/4, Praha 1', NULL, 'Pick-up & drop-off + both-way transfer\nEnglish-speaking pilot\nBriefing (safety)\nOne-hour hot air balloon flight\nRefreshment (mineral water + champagne toast)', 'Gratuities\nPersonal expenses', 'This voucher (print or mobile)\nComfortable clothing and closed shoes', 'Exact pick-up time is confirmed by the agency. Minimum age, weight or health restrictions may apply — please check when booking. Weather-dependent activities may be rescheduled.', 'Free cancellation up to 24 hours before the activity.', 'We pick you up — at your hotel or at IC Mostecká 53/4, Praha 1. The agency confirms the exact time.', NULL, 0, NULL),
(97, 14, NULL, NULL, 'Indoor Skydiving', NULL, NULL, 'placeholders/ag-14.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 90, 'on_demand', 'direct_entry', 'date_required', 1, 1, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:06:52', NULL, NULL, 'IC Mostecká 53/4, Praha 1', NULL, 'Pick-up & drop-off + both-way transfer\nEnglish-speaking instructor\nBriefing (video projection + flight simulation)\nEquipment (suit, helmet, goggles, gloves)\n4-minute flight (two 2-minute flights)', 'Gratuities\nPersonal expenses', 'This voucher (print or mobile)\nComfortable clothing and closed shoes', 'Exact pick-up time is confirmed by the agency. Minimum age, weight or health restrictions may apply — please check when booking. Weather-dependent activities may be rescheduled.', 'Free cancellation up to 24 hours before the activity.', 'We pick you up — at your hotel or at IC Mostecká 53/4, Praha 1. The agency confirms the exact time.', NULL, 0, NULL),
(98, 14, NULL, NULL, 'Clay Pigeons Shooting', NULL, NULL, 'placeholders/ag-14.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 120, 'on_demand', 'direct_entry', 'date_required', 1, 1, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:06:52', NULL, NULL, 'IC Mostecká 53/4, Praha 1', NULL, 'Pick-up & drop-off + both-way transfer\nEnglish-speaking instructor\nBriefing (safety, shotgun handling)\nEquipment (shotgun, ammunition, clay targets, eye & ear protection)\n10 clay targets & 20 shots\nRefreshment (mineral water)', 'Gratuities\nPersonal expenses', 'This voucher (print or mobile)\nComfortable clothing and closed shoes', 'Exact pick-up time is confirmed by the agency. Minimum age, weight or health restrictions may apply — please check when booking. Weather-dependent activities may be rescheduled.', 'Free cancellation up to 24 hours before the activity.', 'We pick you up — at your hotel or at IC Mostecká 53/4, Praha 1. The agency confirms the exact time.', NULL, 0, NULL),
(99, 14, NULL, NULL, 'Paintball', NULL, NULL, 'placeholders/ag-14.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 120, 'on_demand', 'direct_entry', 'date_required', 1, 1, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:06:52', NULL, NULL, 'IC Mostecká 53/4, Praha 1', NULL, 'Equipment (overall, face mask, gloves, paintball gun, ammo)\nEnglish-speaking instructor\nBriefing (safety, gun handling)\nPaintball game up to 4 hours\n100 / 200 / 300 bullets by package', 'Gratuities\nPersonal expenses', 'This voucher (print or mobile)\nComfortable clothing and closed shoes', 'Exact pick-up time is confirmed by the agency. Minimum age, weight or health restrictions may apply — please check when booking. Weather-dependent activities may be rescheduled.', 'Free cancellation up to 24 hours before the activity.', 'We pick you up — at your hotel or at IC Mostecká 53/4, Praha 1. The agency confirms the exact time.', NULL, 0, NULL),
(100, 14, NULL, NULL, 'High Roping', NULL, NULL, 'placeholders/ag-14.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 120, 'on_demand', 'direct_entry', 'date_required', 1, 1, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:06:52', NULL, NULL, 'IC Mostecká 53/4, Praha 1', NULL, 'Pick-up & drop-off + both-way transfer\nEnglish-speaking instructor\nBriefing (safety)\nEquipment\nTwo hours of high roping\nRefreshment (mineral water)', 'Gratuities\nPersonal expenses', 'This voucher (print or mobile)\nComfortable clothing and closed shoes', 'Exact pick-up time is confirmed by the agency. Minimum age, weight or health restrictions may apply — please check when booking. Weather-dependent activities may be rescheduled.', 'Free cancellation up to 24 hours before the activity.', 'We pick you up — at your hotel or at IC Mostecká 53/4, Praha 1. The agency confirms the exact time.', NULL, 0, NULL),
(101, 14, NULL, NULL, 'Flyboarding', NULL, NULL, 'placeholders/ag-14.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 90, 'on_demand', 'direct_entry', 'date_required', 1, 1, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:06:52', NULL, NULL, 'IC Mostecká 53/4, Praha 1', NULL, 'Pick-up & drop-off + both-way transfer\nEnglish-speaking instructor\nBriefing (safety)\nEquipment (wetsuit, lifejacket, helmet, shower facilities)\n15-minute flyboarding\nRefreshment (mineral water)', 'Gratuities\nPersonal expenses', 'This voucher (print or mobile)\nComfortable clothing and closed shoes', 'Minimum age 12; weight limit 30 kg. Exact pick-up time is confirmed by the agency. Minimum age, weight or health restrictions may apply — please check when booking. Weather-dependent activities may be rescheduled.', 'Free cancellation up to 24 hours before the activity.', 'We pick you up — at your hotel or at IC Mostecká 53/4, Praha 1. The agency confirms the exact time.', NULL, 0, NULL),
(102, 14, NULL, NULL, 'Quad Biking', NULL, NULL, 'placeholders/ag-14.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 120, 'on_demand', 'direct_entry', 'date_required', 1, 1, 1, NULL, 'tbc_agency', 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:06:52', NULL, NULL, 'IC Mostecká 53/4, Praha 1', NULL, 'Pick-up & drop-off + both-way transfer\nEnglish-speaking instructor\nBriefing (safety)\nEquipment (quad bike, helmet, gloves)\n30 / 45 / 60-minute ride by package', 'Gratuities\nPersonal expenses', 'This voucher (print or mobile)\nComfortable clothing and closed shoes', 'Exact pick-up time is confirmed by the agency. Minimum age, weight or health restrictions may apply — please check when booking. Weather-dependent activities may be rescheduled.', 'Free cancellation up to 24 hours before the activity.', 'We pick you up — at your hotel or at IC Mostecká 53/4, Praha 1. The agency confirms the exact time.', NULL, 0, NULL),
(103, 15, NULL, NULL, 'Castle Side Food Tour', NULL, NULL, 'placeholders/ag-15.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 180, 'fixed_daily', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:08:48', NULL, NULL, 'Mostecká 4/53, Praha 1 (kancelář PragueWay)', NULL, 'Local English-speaking guide\nFood and/or drink tastings as per the itinerary', 'Additional food and drinks beyond the tastings\nGratuities', 'This voucher (print or mobile)\nComfortable shoes (cobblestones)\nCome hungry', 'Small group. Please share any dietary requirements when booking.', 'Free cancellation up to 24 hours before start; non-refundable afterwards.', 'Meet at Mostecká 53/4 (information centre). Please arrive 10 minutes early.', NULL, 0, NULL),
(104, 15, NULL, NULL, 'Castle Side Beer Tour', NULL, NULL, 'placeholders/ag-15.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 210, 'fixed_daily', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:08:48', NULL, NULL, 'Mostecká 4/53, Praha 1 (kancelář PragueWay)', NULL, 'Local English-speaking guide\nFood and/or drink tastings as per the itinerary', 'Additional food and drinks beyond the tastings\nGratuities', 'This voucher (print or mobile)\nComfortable shoes (cobblestones)\nCome hungry', 'Small group. Please share any dietary requirements when booking.', 'Free cancellation up to 24 hours before start; non-refundable afterwards.', 'Meet at Mostecká 53/4 (information centre). Please arrive 10 minutes early.', NULL, 0, NULL),
(105, 15, NULL, NULL, 'One Prague Tour Castle Side', NULL, NULL, 'placeholders/ag-15.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 180, 'multiple_daily', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:08:48', NULL, NULL, 'Mostecká 4/53, Praha 1 (kancelář PragueWay)', NULL, 'Local English-speaking guide', 'Admission fees where applicable\nGratuities', 'This voucher (print or mobile)\nComfortable shoes (cobblestones)', NULL, 'Free cancellation up to 24 hours before start; non-refundable afterwards.', 'Meet at Mostecká 53/4 (information centre). Please arrive 10 minutes early.', NULL, 0, NULL),
(106, 15, NULL, NULL, 'One Prague Tour Old Town Road', NULL, NULL, 'placeholders/ag-15.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 180, 'multiple_daily', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:08:48', NULL, NULL, 'Mostecká 4/53, Praha 1 (kancelář PragueWay)', NULL, 'Local English-speaking guide\nFood and/or drink tastings as per the itinerary', 'Additional food and drinks beyond the tastings\nGratuities', 'This voucher (print or mobile)\nComfortable shoes (cobblestones)\nCome hungry', 'Small group. Please share any dietary requirements when booking.', 'Free cancellation up to 24 hours before start; non-refundable afterwards.', 'Meet at Mostecká 53/4 (information centre). Please arrive 10 minutes early.', NULL, 0, NULL),
(107, 15, NULL, NULL, 'Old Town & Jewish Quarter', NULL, NULL, 'placeholders/ag-15.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 120, 'multiple_daily', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:08:48', NULL, NULL, 'Mostecká 4/53, Praha 1 (kancelář PragueWay)', NULL, 'Local English-speaking guide', 'Admission fees where applicable\nGratuities', 'This voucher (print or mobile)\nComfortable shoes (cobblestones)', NULL, 'Free cancellation up to 24 hours before start; non-refundable afterwards.', 'Meet at Mostecká 53/4 (information centre). Please arrive 10 minutes early.', NULL, 0, NULL),
(108, 15, NULL, NULL, 'Charles Bridge River Cruise', NULL, NULL, 'placeholders/ag-15.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 90, 'fixed_daily', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:08:48', NULL, NULL, 'Mostecká 4/53, Praha 1 (kancelář PragueWay)', NULL, 'Scenic river cruise\nLocal commentary', 'Admission fees where applicable\nGratuities', 'This voucher (print or mobile)\nComfortable shoes (cobblestones)', NULL, 'Free cancellation up to 24 hours before start; non-refundable afterwards.', 'Meet at Mostecká 53/4 (information centre). Please arrive 10 minutes early.', NULL, 0, NULL),
(109, 15, NULL, NULL, 'Vyšehrad Castle & Fort', NULL, NULL, 'placeholders/ag-15.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 150, 'seasonal', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:11:36', NULL, NULL, 'Charles IV Statue, Křížovnické náměstí, Praha 1', NULL, 'Local English-speaking guide', 'Admission fees where applicable\nGratuities', 'This voucher (print or mobile)\nComfortable shoes (cobblestones)', NULL, 'Free cancellation up to 24 hours before start; non-refundable afterwards.', 'Meet at the Charles IV statue on Křižovnické náměstí, Praha 1.', NULL, 0, NULL),
(110, 15, NULL, NULL, 'E-Scooter Grand City Tour', NULL, NULL, 'placeholders/ag-15.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 180, 'multiple_daily', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:08:48', NULL, NULL, 'Mostecká 4/53, Praha 1 (kancelář PragueWay)', NULL, 'E-scooter and helmet\nLocal guide\nSafety briefing', 'Gratuities', 'This voucher (print or mobile)\nComfortable shoes', 'Minimum height 150 cm.', 'Free cancellation up to 24 hours before start; non-refundable afterwards.', 'Meet at Mostecká 53/4 (information centre). Please arrive 10 minutes early.', NULL, 0, NULL),
(111, 15, NULL, NULL, 'Old Town & Medieval Underground', NULL, NULL, 'placeholders/ag-15.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 180, 'multiple_daily', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:08:48', NULL, NULL, 'Mostecká 4/53, Praha 1 (kancelář PragueWay)', NULL, 'Local English-speaking guide', 'Admission fees where applicable\nGratuities', 'This voucher (print or mobile)\nComfortable shoes (cobblestones)', NULL, 'Free cancellation up to 24 hours before start; non-refundable afterwards.', 'Meet at Mostecká 53/4 (information centre). Please arrive 10 minutes early.', NULL, 0, NULL),
(112, 15, NULL, NULL, 'Prague Castle Highlights', NULL, NULL, 'placeholders/ag-15.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 120, 'fixed_daily', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:08:48', NULL, NULL, 'Mostecká 4/53, Praha 1 (kancelář PragueWay)', NULL, 'Local English-speaking guide', 'Admission fees where applicable\nGratuities', 'This voucher (print or mobile)\nComfortable shoes (cobblestones)', NULL, 'Free cancellation up to 24 hours before start; non-refundable afterwards.', 'Meet at Mostecká 53/4 (information centre). Please arrive 10 minutes early.', NULL, 0, NULL),
(113, 15, NULL, NULL, 'One-Day See It All', NULL, NULL, 'placeholders/ag-15.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 420, 'fixed_daily', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:08:48', NULL, NULL, 'Mostecká 4/53, Praha 1 (kancelář PragueWay)', NULL, 'Local English-speaking guide', 'Admission fees where applicable\nGratuities', 'This voucher (print or mobile)\nComfortable shoes (cobblestones)', NULL, 'Free cancellation up to 24 hours before start; non-refundable afterwards.', 'Meet at Mostecká 53/4 (information centre). Please arrive 10 minutes early.', NULL, 0, NULL),
(114, 15, NULL, NULL, 'E-Scooter Panoramic Tour', NULL, NULL, 'placeholders/ag-15.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 120, 'multiple_daily', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:08:48', NULL, NULL, 'Mostecká 4/53, Praha 1 (kancelář PragueWay)', NULL, 'E-scooter and helmet\nLocal guide\nSafety briefing', 'Gratuities', 'This voucher (print or mobile)\nComfortable shoes', 'Minimum height 150 cm.', 'Free cancellation up to 24 hours before start; non-refundable afterwards.', 'Meet at Mostecká 53/4 (information centre). Please arrive 10 minutes early.', NULL, 0, NULL),
(115, 16, NULL, NULL, 'Image Black Light Theatre', 'Image Black Light Theatre', NULL, 'placeholders/ag-16.svg', NULL, NULL, NULL, NULL, 'Non-verbal', NULL, NULL, 0, 80, 'fixed_daily', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:11:36', NULL, NULL, 'Národní 25, 110 00 Praha 1', NULL, 'Non-verbal black-light theatre performance (75–85 min, no intermission)', NULL, NULL, 'Daily at 20:00. All performances are non-verbal (no language barrier). Box office opens 16:00 on the day; hall opens 30 min before start. Wheelchair accessible. Reservation by phone required (+420 732 156 343 / +420 222 314 448). The specific show follows the monthly programme.', 'Reservation by phone required; cancellation terms per the theatre.', 'Show your voucher at the Image Theatre box office.', NULL, 1, NULL),
(116, 17, NULL, NULL, 'Antologia (Srnec Black Light Theatre)', 'Antologia (Srnec Black Light Theatre)', NULL, 'placeholders/ag-17.svg', NULL, NULL, NULL, NULL, 'Non-verbal', NULL, NULL, 0, 90, 'fixed_daily', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:11:36', NULL, NULL, 'Národní 20, 110 00 Praha 1 (Reduta Jazz Club)', NULL, 'Non-verbal black-light theatre performance (90 min, with intermission)', NULL, NULL, 'Show at 20:00 per the monthly programme. The original / oldest black-light theatre in the world. Venue: Reduta Jazz Club, Národní 20. NOTE: the full (adult) price varies by date per the monthly programme — on some dates it is 550 CZK instead of 650; apply a discount on those dates. Reservation by phone (+420 774 574 475).', 'Reservation by phone required; cancellation terms per the theatre.', 'Show your voucher at the Srnec Theatre box office (inside the Reduta Jazz Club building).', NULL, 1, NULL),
(117, 18, NULL, NULL, 'WOW Show – 4D Interactive Black Light', 'WOW Show – 4D Interactive Black Light', NULL, 'placeholders/ag-18.svg', NULL, NULL, NULL, NULL, 'Non-verbal', NULL, NULL, 0, 65, 'fixed_daily', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-01 06:52:56', '2026-06-02 13:11:36', NULL, NULL, 'Divadlo Broadway, Na Příkopě 31, 110 00 Praha 1 (pasáž Broadway; vstup i z Celetné 38)', NULL, 'Non-verbal 4D & interactive black-light show (65 min, no intermission)', NULL, NULL, 'Non-verbal 4D & interactive show for all ages, 65 min, no intermission, no language barrier. Free seating – choose your seat on arrival (booster seats for small children). Show at 20:00 or 21:30 per the monthly programme. Reservation by phone (+420 777 061 623 / +420 225 113 194), Mon–Sun from 12:00 until showtime.', 'Reservation by phone required; cancellation terms per the theatre.', 'Broadway passage (entrance from Na Příkopě 31 or Celetná 38). Show your voucher at the box office.', NULL, 1, NULL),
(118, 1, NULL, NULL, 'Big Bus Hop-on Hop-off', 'Big Bus Hop-on Hop-off', NULL, 'placeholders/ag-1.svg', NULL, 'Vyhlídkové autobusy hop-on hop-off s otevřenou střechou a audio průvodcem v 11 jazycích. Nastupujete a vystupujete, kde chcete; autobusy jezdí zhruba každých 15 minut. Variantu si vyberte podle délky platnosti a počtu tras – některé balíčky zahrnují i plavbu po Vltavě. Storno zdarma 24 h předem.', 'Hop-on hop-off sightseeing buses with an open top and audio commentary in 11 languages. Get on and off wherever you like; buses run roughly every 15 minutes. Choose the variant by validity and number of routes — some packages also include a Vltava river cruise. Free cancellation up to 24 hours in advance.', NULL, 'audio průvodce v 11 jazycích', NULL, NULL, 1, NULL, 'continuous', 'bus_activation', 'open', 0, 0, 1, NULL, NULL, 'active', 1, '2026-06-01 13:46:16', '2026-06-02 12:55:19', NULL, NULL, NULL, NULL, 'Unlimited hop-on hop-off on both routes (Red and Green) for your ticket validity\nMultilingual audio commentary (24 languages) with earphones\nOn-board staff\nVltava river cruise (where included in your ticket)', 'Food and drinks\nGratuities', 'This voucher (print or mobile)\nSun protection in summer', 'Board at any of the 18 stops — look for the red Big Bus. Audio guide via the earphones provided.', 'Free cancellation up to 24 hours before start; non-refundable afterwards.', NULL, NULL, 0, NULL),
(119, 19, NULL, NULL, 'Pilsner Urquell Experience – vstupenka', 'Pilsner Urquell Experience – ticket', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 'on_demand', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'inactive', 0, '2026-06-02 13:01:57', '2026-06-02 18:08:01', NULL, NULL, 'Pilsner Urquell Experience, 28. října 377/13, Praha 1', NULL, 'Admission', NULL, NULL, NULL, NULL, 'Show your voucher at the entrance.', NULL, 0, NULL),
(120, 20, NULL, NULL, 'Story of Prague – interaktivní muzeum', 'Story of Prague – interactive museum', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 'on_demand', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'inactive', 0, '2026-06-02 13:01:57', '2026-06-02 18:08:01', NULL, NULL, 'Story of Prague, Křižovnické náměstí, Praha 1', NULL, 'Museum admission\nApp audio guide (7 languages)', NULL, NULL, 'Interactive AR museum — 160 exhibits across 19 rooms / 3 floors. Open daily 10:00–20:00.', NULL, 'Enter from inside the passage at Křižovnické náměstí. Show your voucher at the entrance.', NULL, 0, NULL),
(121, 15, NULL, NULL, 'The Little Quarter Walk: Prague Beyond the Crowds', 'The Little Quarter Walk: Prague Beyond the Crowds', NULL, NULL, NULL, NULL, NULL, NULL, 'EN', NULL, NULL, 0, 150, 'multiple_daily', 'direct_entry', 'date_required', 0, 0, 1, NULL, NULL, 'active', 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL, 'West side of Charles Bridge, Praha 1', NULL, 'Local expert guide\nSmall-group experience\nOne café drink (beer, wine or non-alcoholic)\nSeasonal admission: Vrtba Garden (Mar–Oct) / St. Nicholas Church interior (winter)', NULL, NULL, 'Daily 9:30 & 15:30. Small group (max 11–12). Minimum 2 participants — if you are a solo traveler, contact us before booking.', 'Free cancellation up to 24 hours before the tour.', NULL, NULL, 0, NULL);
INSERT INTO `products` (`id`, `agency_id`, `commission_pct`, `seller_bonus_pct`, `name_cs`, `name_en`, `name_de`, `image_path`, `variant_diagram_path`, `description_cs`, `description_en`, `description_de`, `languages`, `order_instructions`, `booking_url`, `has_contingent`, `duration_minutes`, `schedule_type`, `voucher_redemption_type`, `ticket_type`, `pickup_available`, `pickup_required`, `pickup_free`, `pickup_window_minutes`, `pickup_confirmation`, `status`, `is_featured`, `created_at`, `updated_at`, `deposit_fixed_czk`, `deposit_fixed_eur`, `meeting_point_address`, `map_url`, `included`, `excluded`, `what_to_bring`, `important_info`, `cancellation_policy`, `meeting_point_note`, `meeting_options`, `seating`, `addons`) VALUES
(122, 15, NULL, NULL, 'Czech Highlights in 2 Days: Prague & Bohemian Switzerland', 'Czech Highlights in 2 Days: Prague & Bohemian Switzerland', NULL, NULL, NULL, NULL, NULL, NULL, 'EN', NULL, NULL, 0, 1020, 'on_demand', 'direct_entry', 'date_required', 1, 1, 1, NULL, NULL, 'active', 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL, 'Day 1: Mostecká 53/4, Praha 1 (West side of Charles Bridge)', NULL, 'Day 1 (Prague): local expert guide, boat cruise (free drink & snack), tram ticket to the castle\nDay 2 (National Park): hotel pickup & drop-off, expert guides, lunch & snacks (veg options), all entries & transport\nSmall-group comfort', NULL, NULL, 'Two consecutive days (Day 1 Prague, Day 2 Bohemian/Saxon Switzerland). Bring EU ID or passport — the national-park day crosses into Germany. Difficulty easy/moderate (8–10 km hike). Operated jointly by PragueWay (Day 1) and Bohemia Adventures (Day 2).', 'Free cancellation up to 24 hours before; one day can be cancelled independently.', 'Day 1 Prague: meet at Mostecká 53/4 at 10:00. Day 2 National Park: hotel pickup 7:30–8:00, drop-off ~18:30.', NULL, 0, NULL),
(123, 21, NULL, NULL, 'Top Highlights of Bohemian & Saxon Switzerland (with Boat Ride)', 'Top Highlights of Bohemian & Saxon Switzerland (with Boat Ride)', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 600, 'on_demand', 'direct_entry', 'date_required', 1, 1, 1, NULL, NULL, 'active', 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Free cancellation up to 24 hours before the tour.', 'Hotel pickup in Prague included; exact time confirmed by the agency.', NULL, 0, NULL),
(124, 21, NULL, NULL, 'Easy Walking Tour: Romantic Boat Ride & Bastei Bridge', 'Easy Walking Tour: Romantic Boat Ride & Bastei Bridge', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 540, 'on_demand', 'direct_entry', 'date_required', 1, 1, 1, NULL, NULL, 'active', 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Free cancellation up to 24 hours before the tour.', 'Hotel pickup in Prague included; exact time confirmed by the agency.', NULL, 0, NULL),
(125, 21, NULL, NULL, 'Best Viewpoint Hikes: Tisa Rocks, Pravčická Gate & Bastei Bridge', 'Best Viewpoint Hikes: Tisa Rocks, Pravčická Gate & Bastei Bridge', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 600, 'on_demand', 'direct_entry', 'date_required', 1, 1, 1, NULL, NULL, 'active', 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Free cancellation up to 24 hours before the tour.', 'Hotel pickup in Prague included; exact time confirmed by the agency.', NULL, 0, NULL),
(126, 21, NULL, NULL, 'Easy Walking Tour: Tisa Rocks & Bastei Bridge', 'Easy Walking Tour: Tisa Rocks & Bastei Bridge', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 540, 'on_demand', 'direct_entry', 'date_required', 1, 1, 1, NULL, NULL, 'active', 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Free cancellation up to 24 hours before the tour.', 'Hotel pickup in Prague included; exact time confirmed by the agency.', NULL, 0, NULL),
(127, 21, NULL, NULL, 'Karlovy Vary All-Inclusive Escape: Springs, Views & Culture', 'Karlovy Vary All-Inclusive Escape: Springs, Views & Culture', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 600, 'on_demand', 'direct_entry', 'date_required', 1, 1, 1, NULL, NULL, 'active', 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Free cancellation up to 24 hours before the tour.', 'Hotel pickup in Prague included; exact time confirmed by the agency.', NULL, 0, NULL),
(128, 21, NULL, NULL, 'Dresden City Tour from Prague & Bastei Bridge', 'Dresden City Tour from Prague & Bastei Bridge', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 600, 'on_demand', 'direct_entry', 'date_required', 1, 1, 1, NULL, NULL, 'active', 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Free cancellation up to 24 hours before the tour.', 'Hotel pickup in Prague included; exact time confirmed by the agency.', NULL, 0, NULL),
(129, 21, NULL, NULL, 'Terezín & the Best of Bohemian and Saxon Switzerland', 'Terezín & the Best of Bohemian and Saxon Switzerland', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 600, 'on_demand', 'direct_entry', 'date_required', 1, 1, 1, NULL, NULL, 'active', 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Free cancellation up to 24 hours before the tour.', 'Hotel pickup in Prague included; exact time confirmed by the agency.', NULL, 0, NULL),
(130, 21, NULL, NULL, 'Discover Bohemia: Tisa Rocks, Bastei Bridge & Brewery with Beer Tasting', 'Discover Bohemia: Tisa Rocks, Bastei Bridge & Brewery with Beer Tasting', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 600, 'on_demand', 'direct_entry', 'date_required', 1, 1, 1, NULL, NULL, 'active', 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Free cancellation up to 24 hours before the tour.', 'Hotel pickup in Prague included; exact time confirmed by the agency.', NULL, 0, NULL),
(131, 21, NULL, NULL, 'Unlimited Thermal Spa & Top Highlights of Saxon Switzerland', 'Unlimited Thermal Spa & Top Highlights of Saxon Switzerland', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 600, 'on_demand', 'direct_entry', 'date_required', 1, 1, 1, NULL, NULL, 'active', 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Free cancellation up to 24 hours before the tour.', 'Hotel pickup in Prague included; exact time confirmed by the agency.', NULL, 0, NULL),
(132, 21, NULL, NULL, 'Dresden Christmas Market Special Tour with Mulled Wine', 'Dresden Christmas Market Special Tour with Mulled Wine', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 600, 'on_demand', 'direct_entry', 'date_required', 1, 1, 1, NULL, NULL, 'active', 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Free cancellation up to 24 hours before the tour.', 'Hotel pickup in Prague included; exact time confirmed by the agency.', NULL, 0, NULL),
(133, 21, NULL, NULL, 'Horseback Riding Tour in Bohemian Switzerland', 'Horseback Riding Tour in Bohemian Switzerland', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 480, 'on_demand', 'direct_entry', 'date_required', 1, 1, 1, NULL, NULL, 'active', 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Free cancellation up to 24 hours before the tour.', 'Hotel pickup in Prague included; exact time confirmed by the agency.', NULL, 0, NULL),
(134, 21, NULL, NULL, 'Mountain Bike Adventure Tour from Prague', 'Mountain Bike Adventure Tour from Prague', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 480, 'on_demand', 'direct_entry', 'date_required', 1, 1, 1, NULL, NULL, 'active', 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Free cancellation up to 24 hours before the tour.', 'Hotel pickup in Prague included; exact time confirmed by the agency.', NULL, 0, NULL),
(135, 21, NULL, NULL, 'Rafting & Canoeing Adventure Tour to Bohemian Switzerland', 'Rafting & Canoeing Adventure Tour to Bohemian Switzerland', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 480, 'on_demand', 'direct_entry', 'date_required', 1, 1, 1, NULL, NULL, 'active', 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Free cancellation up to 24 hours before the tour.', 'Hotel pickup in Prague included; exact time confirmed by the agency.', NULL, 0, NULL),
(136, 21, NULL, NULL, 'Rock Climbing & Via Ferrata Tour in Bohemian Switzerland', 'Rock Climbing & Via Ferrata Tour in Bohemian Switzerland', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 480, 'on_demand', 'direct_entry', 'date_required', 1, 1, 1, NULL, NULL, 'active', 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Free cancellation up to 24 hours before the tour.', 'Hotel pickup in Prague included; exact time confirmed by the agency.', NULL, 0, NULL),
(137, 21, NULL, NULL, 'Winter Fairy Tale: Winter Hiking in Bohemian & Saxon Switzerland', 'Winter Fairy Tale: Winter Hiking in Bohemian & Saxon Switzerland', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 600, 'on_demand', 'direct_entry', 'date_required', 1, 1, 1, NULL, NULL, 'active', 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Free cancellation up to 24 hours before the tour.', 'Hotel pickup in Prague included; exact time confirmed by the agency.', NULL, 0, NULL),
(138, 21, NULL, NULL, 'Cross-Country Skiing Guided Tour from Prague', 'Cross-Country Skiing Guided Tour from Prague', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 480, 'on_demand', 'direct_entry', 'date_required', 1, 1, 1, NULL, NULL, 'active', 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Free cancellation up to 24 hours before the tour.', 'Hotel pickup in Prague included; exact time confirmed by the agency.', NULL, 0, NULL),
(139, 21, NULL, NULL, 'Downhill Skiing & Snowboarding Tour', 'Downhill Skiing & Snowboarding Tour', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 480, 'on_demand', 'direct_entry', 'date_required', 1, 1, 1, NULL, NULL, 'active', 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Free cancellation up to 24 hours before the tour.', 'Hotel pickup in Prague included; exact time confirmed by the agency.', NULL, 0, NULL),
(140, 21, NULL, NULL, 'Private Day Trip of Bohemian & Saxon Switzerland (up to 16)', 'Private Day Trip of Bohemian & Saxon Switzerland (up to 16)', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 600, 'on_demand', 'direct_entry', 'date_required', 1, 1, 1, NULL, NULL, 'active', 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Private group price (up to 16 people). Fully customizable itinerary.', 'Free cancellation up to 24 hours before the tour.', 'Hotel pickup in Prague included; exact time confirmed by the agency.', NULL, 0, NULL),
(141, 21, NULL, NULL, 'Overnight Bohemian Switzerland Tour with Wellness Stay', 'Overnight Bohemian Switzerland Tour with Wellness Stay', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1440, 'on_demand', 'direct_entry', 'date_required', 1, 1, 1, NULL, NULL, 'active', 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Overnight tour with wellness stay at Bohemian Homes (1–12 guests).', 'Free cancellation up to 24 hours before the tour.', 'Hotel pickup in Prague included; exact time confirmed by the agency.', NULL, 0, NULL),
(142, 21, NULL, NULL, 'Luxury Wood Cabin Stay with Private Tour of Bohemian Switzerland', 'Luxury Wood Cabin Stay with Private Tour of Bohemian Switzerland', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1440, 'on_demand', 'direct_entry', 'date_required', 1, 1, 1, NULL, NULL, 'active', 0, '2026-06-02 13:11:36', '2026-06-02 13:11:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Private tour with luxury wood-cabin accommodation and wellness.', 'Free cancellation up to 24 hours before the tour.', 'Hotel pickup in Prague included; exact time confirmed by the agency.', NULL, 0, NULL);

-- --------------------------------------------------------

--
-- Struktura tabulky `product_categories`
--

CREATE TABLE `product_categories` (
  `product_id` int(10) UNSIGNED NOT NULL,
  `category_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Vypisuji data pro tabulku `product_categories`
--

INSERT INTO `product_categories` (`product_id`, `category_id`) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 1),
(6, 1),
(7, 1),
(8, 7),
(9, 7),
(10, 7),
(11, 7),
(12, 7),
(13, 7),
(14, 7),
(15, 7),
(16, 7),
(17, 7),
(18, 7),
(19, 7),
(20, 7),
(21, 7),
(22, 7),
(23, 7),
(24, 1),
(25, 7),
(26, 7),
(27, 7),
(28, 1),
(29, 1),
(30, 1),
(31, 1),
(32, 1),
(33, 1),
(34, 7),
(35, 7),
(36, 7),
(37, 7),
(38, 7),
(39, 1),
(40, 1),
(41, 3),
(42, 7),
(43, 7),
(44, 7),
(45, 7),
(46, 1),
(47, 7),
(48, 4),
(49, 4),
(50, 4),
(51, 4),
(52, 4),
(53, 4),
(54, 4),
(55, 4),
(56, 4),
(57, 4),
(58, 4),
(59, 6),
(60, 6),
(61, 6),
(62, 6),
(63, 6),
(64, 6),
(65, 8),
(66, 8),
(67, 8),
(68, 2),
(69, 2),
(70, 2),
(71, 2),
(72, 3),
(73, 3),
(74, 3),
(75, 3),
(76, 3),
(77, 3),
(78, 6),
(79, 6),
(80, 6),
(81, 3),
(82, 6),
(83, 6),
(84, 4),
(85, 4),
(86, 4),
(87, 4),
(88, 6),
(89, 9),
(90, 9),
(91, 9),
(92, 9),
(93, 9),
(94, 9),
(95, 9),
(96, 9),
(97, 9),
(98, 9),
(99, 9),
(100, 9),
(101, 9),
(102, 9),
(103, 2),
(104, 2),
(105, 2),
(106, 2),
(107, 2),
(108, 3),
(109, 2),
(110, 9),
(111, 2),
(112, 2),
(113, 2),
(114, 9),
(115, 5),
(116, 5),
(117, 5),
(118, 1);

-- --------------------------------------------------------

--
-- Struktura tabulky `product_schedules`
--

CREATE TABLE `product_schedules` (
  `id` int(10) UNSIGNED NOT NULL,
  `product_id` int(10) UNSIGNED NOT NULL,
  `season_from` date DEFAULT NULL,
  `season_to` date DEFAULT NULL,
  `days_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`days_json`)),
  `times_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`times_json`)),
  `open_start` time DEFAULT NULL,
  `open_end` time DEFAULT NULL,
  `frequency_min` int(10) UNSIGNED DEFAULT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Vypisuji data pro tabulku `product_schedules`
--

INSERT INTO `product_schedules` (`id`, `product_id`, `season_from`, `season_to`, `days_json`, `times_json`, `open_start`, `open_end`, `frequency_min`, `sort_order`, `status`) VALUES
(1, 78, NULL, NULL, NULL, '[\"12:00\"]', NULL, NULL, NULL, 0, 'active'),
(2, 81, NULL, NULL, NULL, NULL, '10:00:00', '20:00:00', 15, 0, 'active'),
(5, 9, NULL, NULL, '[1,3,5,7]', '[\"08:45\"]', NULL, NULL, NULL, 0, 'active'),
(6, 49, NULL, NULL, '[6]', '[\"17:00\"]', NULL, NULL, NULL, 0, 'active'),
(7, 69, NULL, NULL, NULL, '[\"14:00\"]', NULL, NULL, NULL, 0, 'active'),
(8, 72, NULL, NULL, NULL, NULL, '10:00:00', '21:00:00', 30, 0, 'active'),
(9, 73, NULL, NULL, NULL, '[\"12:00\", \"15:00\"]', NULL, NULL, NULL, 0, 'active'),
(10, 79, NULL, NULL, NULL, '[\"19:00\"]', NULL, NULL, NULL, 0, 'active'),
(11, 84, NULL, NULL, '[1, 4]', '[\"20:00\"]', NULL, NULL, NULL, 0, 'active'),
(12, 85, NULL, NULL, '[2, 7]', '[\"20:00\"]', NULL, NULL, NULL, 0, 'active'),
(13, 87, NULL, NULL, '[3]', '[\"20:00\"]', NULL, NULL, NULL, 0, 'active'),
(14, 103, NULL, NULL, NULL, '[\"15:00\"]', NULL, NULL, NULL, 0, 'active'),
(15, 104, NULL, NULL, NULL, '[\"18:00\"]', NULL, NULL, NULL, 0, 'active'),
(16, 105, NULL, NULL, NULL, '[\"10:30\", \"15:30\"]', NULL, NULL, NULL, 0, 'active'),
(17, 106, NULL, NULL, NULL, '[\"10:30\", \"15:30\"]', NULL, NULL, NULL, 0, 'active'),
(18, 107, NULL, NULL, NULL, '[\"10:00\", \"17:00\"]', NULL, NULL, NULL, 0, 'active'),
(19, 108, NULL, NULL, NULL, '[\"13:30\"]', NULL, NULL, NULL, 0, 'active'),
(20, 110, NULL, NULL, NULL, '[\"10:00\", \"17:00\"]', NULL, NULL, NULL, 0, 'active'),
(21, 111, NULL, NULL, NULL, '[\"10:00\", \"17:00\"]', NULL, NULL, NULL, 0, 'active'),
(22, 112, NULL, NULL, NULL, '[\"15:00\"]', NULL, NULL, NULL, 0, 'active'),
(23, 113, NULL, NULL, NULL, '[\"10:00\"]', NULL, NULL, NULL, 0, 'active'),
(24, 114, NULL, NULL, NULL, '[\"10:00\", \"17:00\"]', NULL, NULL, NULL, 0, 'active'),
(25, 115, NULL, NULL, NULL, '[\"20:00\"]', NULL, NULL, NULL, 0, 'active'),
(26, 116, NULL, NULL, NULL, '[\"20:00\"]', NULL, NULL, NULL, 0, 'active');

-- --------------------------------------------------------

--
-- Struktura tabulky `refunds`
--

CREATE TABLE `refunds` (
  `id` int(10) UNSIGNED NOT NULL,
  `sale_id` int(10) UNSIGNED NOT NULL,
  `actor_type` enum('seller','admin','system') NOT NULL,
  `actor_id` int(10) UNSIGNED DEFAULT NULL,
  `approved_by_admin_id` int(10) UNSIGNED DEFAULT NULL,
  `kind` enum('partial','full') NOT NULL DEFAULT 'partial',
  `amount_czk` decimal(10,2) NOT NULL,
  `amount_eur` decimal(10,2) DEFAULT NULL,
  `commission_reversed_czk` decimal(10,2) DEFAULT NULL,
  `reason` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabulky `sales`
--

CREATE TABLE `sales` (
  `id` int(10) UNSIGNED NOT NULL,
  `tenant_id` int(10) UNSIGNED NOT NULL,
  `station_id` int(10) UNSIGNED DEFAULT NULL,
  `seller_id` int(10) UNSIGNED NOT NULL,
  `customer_id` int(10) UNSIGNED DEFAULT NULL,
  `voucher_number` varchar(24) DEFAULT NULL,
  `status` enum('draft','paid','cancelled','refunded') NOT NULL DEFAULT 'draft',
  `total_czk` decimal(10,2) NOT NULL DEFAULT 0.00,
  `total_eur` decimal(10,2) DEFAULT NULL,
  `payment_method` enum('cash','card') DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `paid_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_deposit` tinyint(1) NOT NULL DEFAULT 0,
  `paid_czk` decimal(10,2) DEFAULT NULL,
  `paid_eur` decimal(10,2) DEFAULT NULL,
  `balance_czk` decimal(10,2) DEFAULT NULL,
  `balance_eur` decimal(10,2) DEFAULT NULL,
  `pin` varchar(8) DEFAULT NULL,
  `refunded_czk` decimal(10,2) NOT NULL DEFAULT 0.00,
  `refunded_eur` decimal(10,2) DEFAULT NULL,
  `cancelled_at` datetime DEFAULT NULL,
  `cancel_reason` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Vypisuji data pro tabulku `sales`
--

INSERT INTO `sales` (`id`, `tenant_id`, `station_id`, `seller_id`, `customer_id`, `voucher_number`, `status`, `total_czk`, `total_eur`, `payment_method`, `note`, `paid_at`, `created_at`, `updated_at`, `is_deposit`, `paid_czk`, `paid_eur`, `balance_czk`, `balance_eur`, `pin`, `refunded_czk`, `refunded_eur`, `cancelled_at`, `cancel_reason`) VALUES
(1, 1, NULL, 1, NULL, 'PTI-2026-000001', 'paid', 1300.00, 52.00, 'cash', NULL, '2026-06-01 17:45:37', '2026-06-01 17:45:37', '2026-06-01 17:45:37', 0, NULL, NULL, NULL, NULL, NULL, 0.00, NULL, NULL, NULL),
(2, 1, NULL, 1, 1, 'PTI-2026-000002', 'paid', 780.00, 31.00, 'card', NULL, '2026-06-01 17:54:43', '2026-06-01 17:54:43', '2026-06-01 17:54:43', 0, 780.00, 31.00, 0.00, 0.00, NULL, 0.00, NULL, NULL, NULL),
(3, 1, NULL, 1, 2, 'PTI-2026-000003', 'paid', 780.00, 31.00, 'cash', NULL, '2026-06-01 17:57:20', '2026-06-01 17:57:20', '2026-06-01 17:57:20', 0, 780.00, 31.00, 0.00, 0.00, NULL, 0.00, NULL, NULL, NULL),
(4, 1, NULL, 1, 3, 'PTI-2026-000004', 'paid', 1300.00, 52.00, 'card', NULL, '2026-06-01 19:54:32', '2026-06-01 19:54:32', '2026-06-01 19:54:32', 0, 1300.00, 52.00, 0.00, 0.00, NULL, 0.00, NULL, NULL, NULL),
(5, 1, NULL, 1, 4, 'PTI-2026-000005', 'paid', 900.00, 36.00, 'cash', NULL, '2026-06-01 20:00:51', '2026-06-01 20:00:51', '2026-06-01 20:00:51', 0, 900.00, 36.00, 0.00, 0.00, NULL, 0.00, NULL, NULL, NULL),
(6, 1, NULL, 1, NULL, 'PTI-2026-000006', 'paid', 1600.00, 64.00, 'card', NULL, '2026-06-01 20:04:25', '2026-06-01 20:04:25', '2026-06-01 20:04:25', 0, 1600.00, 64.00, 0.00, 0.00, NULL, 0.00, NULL, NULL, NULL),
(7, 1, NULL, 1, 5, 'PTI-2026-000007', 'paid', 3960.00, 158.00, 'cash', NULL, '2026-06-01 20:06:40', '2026-06-01 20:06:40', '2026-06-01 20:06:40', 0, 3960.00, 158.00, 0.00, 0.00, NULL, 0.00, NULL, NULL, NULL),
(8, 1, NULL, 1, 6, 'PTI-2026-000008', 'paid', 7380.00, 294.00, 'card', NULL, '2026-06-01 21:12:52', '2026-06-01 21:12:52', '2026-06-01 21:12:52', 0, 7380.00, 294.00, 0.00, 0.00, NULL, 0.00, NULL, NULL, NULL),
(9, 1, NULL, 1, 7, 'PTI-2026-000009', 'paid', 1400.00, 56.00, 'card', NULL, '2026-06-02 13:20:12', '2026-06-02 13:20:12', '2026-06-02 13:20:12', 0, 1400.00, 56.00, 0.00, 0.00, '5629', 0.00, NULL, NULL, NULL),
(10, 1, NULL, 1, 8, 'PTI-2026-000010', 'paid', 3000.00, 120.00, 'card', NULL, '2026-06-02 15:13:28', '2026-06-02 15:13:28', '2026-06-02 15:13:28', 0, 3000.00, 120.00, 0.00, 0.00, '0091', 0.00, NULL, NULL, NULL),
(11, 1, NULL, 1, 9, 'PTI-2026-000011', 'paid', 900.00, 36.00, 'card', NULL, '2026-06-02 16:15:54', '2026-06-02 16:15:54', '2026-06-02 16:15:54', 0, 900.00, 36.00, 0.00, 0.00, '3235', 0.00, NULL, NULL, NULL),
(12, 1, NULL, 1, 10, 'PTI-2026-000012', 'paid', 3425.00, 137.00, 'cash', NULL, '2026-06-02 17:17:12', '2026-06-02 17:17:12', '2026-06-02 17:17:12', 0, 3425.00, 137.00, 0.00, 0.00, '8699', 0.00, NULL, NULL, NULL),
(13, 1, NULL, 1, 11, 'PTI-2026-000013', 'cancelled', 6460.00, 258.00, 'cash', NULL, '2026-06-02 17:21:50', '2026-06-02 17:21:50', '2026-06-02 17:22:04', 0, 6460.00, 258.00, 0.00, 0.00, '6621', 0.00, NULL, '2026-06-02 17:22:04', 'Debil'),
(14, 1, NULL, 1, NULL, 'PTI-2026-000014', 'paid', 3120.00, 124.00, 'card', NULL, '2026-06-02 17:24:56', '2026-06-02 17:24:56', '2026-06-02 17:24:56', 0, 3120.00, 124.00, 0.00, 0.00, '3824', 0.00, NULL, NULL, NULL),
(15, 1, NULL, 1, 12, 'PTI-2026-000015', 'paid', 11700.00, 468.00, 'card', NULL, '2026-06-02 17:26:06', '2026-06-02 17:26:06', '2026-06-02 17:26:06', 0, 11700.00, 468.00, 0.00, 0.00, '7772', 0.00, NULL, NULL, NULL),
(16, 1, NULL, 1, 13, 'PTI-2026-000016', 'paid', 2800.00, 112.00, 'card', NULL, '2026-06-02 17:27:35', '2026-06-02 17:27:35', '2026-06-02 17:27:35', 0, 2800.00, 112.00, 0.00, 0.00, '3690', 0.00, NULL, NULL, NULL),
(17, 1, NULL, 1, 14, 'PTI-2026-000017', 'paid', 2350.00, 94.00, 'cash', NULL, '2026-06-02 18:15:50', '2026-06-02 18:15:50', '2026-06-02 18:15:50', 0, 2350.00, 94.00, 0.00, 0.00, '4036', 0.00, NULL, NULL, NULL),
(18, 1, NULL, 1, 15, 'PTI-2026-000018', 'paid', 1980.00, 79.00, 'card', NULL, '2026-06-02 18:35:21', '2026-06-02 18:35:21', '2026-06-02 18:35:21', 0, 1980.00, 79.00, 0.00, 0.00, '0516', 0.00, NULL, NULL, NULL),
(19, 1, NULL, 1, 16, 'PTI-2026-000019', 'paid', 1560.00, 62.00, 'cash', NULL, '2026-06-02 18:45:54', '2026-06-02 18:45:54', '2026-06-02 18:45:54', 0, 1560.00, 62.00, 0.00, 0.00, '9618', 0.00, NULL, NULL, NULL),
(20, 1, NULL, 1, 17, 'PTI-2026-000020', 'paid', 3800.00, 150.00, 'card', NULL, '2026-06-02 18:58:07', '2026-06-02 18:58:07', '2026-06-02 18:58:07', 0, 3800.00, 150.00, 0.00, 0.00, '9260', 0.00, NULL, NULL, NULL),
(21, 1, NULL, 1, 18, 'PTI-2026-000021', 'paid', 3060.00, 122.40, 'card', NULL, '2026-06-02 19:02:32', '2026-06-02 19:02:32', '2026-06-02 19:02:32', 0, 3060.00, 122.40, 0.00, 0.00, '4852', 0.00, NULL, NULL, NULL),
(22, 1, NULL, 1, 19, 'PTI-2026-000022', 'paid', 1950.00, 78.00, 'card', NULL, '2026-06-02 19:06:27', '2026-06-02 19:06:27', '2026-06-02 19:06:27', 0, 1950.00, 78.00, 0.00, 0.00, '4392', 0.00, NULL, NULL, NULL),
(23, 1, NULL, 1, 20, 'PTI-2026-000023', 'paid', 900.00, 36.00, 'card', NULL, '2026-06-02 20:04:29', '2026-06-02 20:04:29', '2026-06-02 20:04:29', 0, 900.00, 36.00, 0.00, 0.00, '7655', 0.00, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Struktura tabulky `sale_items`
--

CREATE TABLE `sale_items` (
  `id` int(10) UNSIGNED NOT NULL,
  `sale_id` int(10) UNSIGNED NOT NULL,
  `product_id` int(10) UNSIGNED DEFAULT NULL,
  `pricing_version_id` int(10) UNSIGNED DEFAULT NULL,
  `cell_key` varchar(255) DEFAULT NULL,
  `snapshot_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`snapshot_json`)),
  `qty` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `unit_price_czk` decimal(10,2) NOT NULL,
  `unit_price_eur` decimal(10,2) DEFAULT NULL,
  `discount_pct` decimal(5,2) NOT NULL DEFAULT 0.00,
  `line_total_czk` decimal(10,2) NOT NULL,
  `line_total_eur` decimal(10,2) DEFAULT NULL,
  `commission_pct` decimal(5,2) DEFAULT NULL,
  `commission_czk` decimal(10,2) DEFAULT NULL,
  `agency_cost_czk` decimal(10,2) DEFAULT NULL,
  `agency_cost_eur` decimal(10,2) DEFAULT NULL,
  `seller_bonus_pct` decimal(5,2) DEFAULT NULL,
  `seller_bonus_czk` decimal(10,2) DEFAULT NULL,
  `ticket_date` date DEFAULT NULL,
  `ticket_time` time DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Vypisuji data pro tabulku `sale_items`
--

INSERT INTO `sale_items` (`id`, `sale_id`, `product_id`, `pricing_version_id`, `cell_key`, `snapshot_json`, `qty`, `unit_price_czk`, `unit_price_eur`, `discount_pct`, `line_total_czk`, `line_total_eur`, `commission_pct`, `commission_czk`, `agency_cost_czk`, `agency_cost_eur`, `seller_bonus_pct`, `seller_bonus_czk`, `ticket_date`, `ticket_time`, `created_at`) VALUES
(1, 1, 104, 95, '[]', '{\"lid\":\"a919a17dcf1d\",\"product_id\":104,\"version_id\":95,\"cell_key\":\"[]\",\"product_name\":\"Castle Side Beer Tour\",\"product_name_en\":null,\"product_name_de\":null,\"agency\":\"PragueWay\",\"agency_id\":15,\"image_path\":\"placeholders\\/ag-15.svg\",\"redemption_type\":\"direct_entry\",\"pickup_available\":0,\"pickup_required\":0,\"chosen\":[],\"qty\":1,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":1300,\"retail_eur\":52,\"ticket_date\":\"2026-06-01\",\"ticket_time\":\"18:00\",\"q\":{\"qty\":1,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":1300,\"retail_eur\":52,\"customer_czk\":1300,\"customer_eur\":52,\"agency_czk\":1040,\"agency_eur\":41.6,\"margin_czk\":260,\"margin_eur\":10.4,\"bonus_czk\":26,\"bonus_eur\":1.04}}', 1, 1300.00, 52.00, 0.00, 1300.00, 52.00, 20.00, 260.00, NULL, NULL, NULL, NULL, '2026-06-01', '18:00:00', '2026-06-01 17:45:37'),
(2, 2, 118, 121, '{\"101\":\"Discover\",\"102\":\"Adult\"}', '{\"lid\":\"227290a66d88\",\"product_id\":118,\"version_id\":121,\"cell_key\":\"{\\\"101\\\":\\\"Discover\\\",\\\"102\\\":\\\"Adult\\\"}\",\"product_name\":\"Big Bus Hop-on Hop-off\",\"product_name_en\":\"Big Bus Hop-on Hop-off\",\"product_name_de\":null,\"agency\":\"Big Bus Tours\",\"agency_id\":1,\"image_path\":\"placeholders\\/ag-1.svg\",\"redemption_type\":\"bus_activation\",\"pickup_available\":0,\"pickup_required\":0,\"agency_deposit\":0,\"deposit_fixed_czk\":null,\"deposit_fixed_eur\":null,\"chosen\":[{\"label\":\"Varianta\",\"value\":\"Discover\"},{\"label\":\"Typ pasažéra\",\"value\":\"Adult\"}],\"qty\":1,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":780,\"retail_eur\":31,\"ticket_date\":null,\"ticket_time\":null,\"q\":{\"qty\":1,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":780,\"retail_eur\":31,\"customer_czk\":780,\"customer_eur\":31,\"agency_czk\":624,\"agency_eur\":24.8,\"margin_czk\":156,\"margin_eur\":6.2,\"bonus_czk\":15.6,\"bonus_eur\":0.62}}', 1, 780.00, 31.00, 0.00, 780.00, 31.00, 20.00, 156.00, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-01 17:54:43'),
(3, 3, 118, 121, '{\"101\":\"Discover\",\"102\":\"Adult\"}', '{\"lid\":\"37a9e8da5d1f\",\"product_id\":118,\"version_id\":121,\"cell_key\":\"{\\\"101\\\":\\\"Discover\\\",\\\"102\\\":\\\"Adult\\\"}\",\"product_name\":\"Big Bus Hop-on Hop-off\",\"product_name_en\":\"Big Bus Hop-on Hop-off\",\"product_name_de\":null,\"agency\":\"Big Bus Tours\",\"agency_id\":1,\"image_path\":\"placeholders\\/ag-1.svg\",\"redemption_type\":\"bus_activation\",\"pickup_available\":0,\"pickup_required\":0,\"agency_deposit\":0,\"deposit_fixed_czk\":null,\"deposit_fixed_eur\":null,\"chosen\":[{\"label\":\"Varianta\",\"value\":\"Discover\"},{\"label\":\"Typ pasažéra\",\"value\":\"Adult\"}],\"qty\":1,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":780,\"retail_eur\":31,\"ticket_date\":null,\"ticket_time\":null,\"q\":{\"qty\":1,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":780,\"retail_eur\":31,\"customer_czk\":780,\"customer_eur\":31,\"agency_czk\":624,\"agency_eur\":24.8,\"margin_czk\":156,\"margin_eur\":6.2,\"bonus_czk\":15.6,\"bonus_eur\":0.62}}', 1, 780.00, 31.00, 0.00, 780.00, 31.00, 20.00, 156.00, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-01 17:57:20'),
(4, 4, 104, 95, '[]', '{\"lid\":\"68d2bf2a949f\",\"product_id\":104,\"version_id\":95,\"cell_key\":\"[]\",\"product_name\":\"Castle Side Beer Tour\",\"product_name_en\":null,\"product_name_de\":null,\"agency\":\"PragueWay\",\"agency_id\":15,\"image_path\":\"placeholders\\/ag-15.svg\",\"redemption_type\":\"direct_entry\",\"pickup_available\":0,\"pickup_required\":0,\"agency_deposit\":1,\"deposit_fixed_czk\":null,\"deposit_fixed_eur\":null,\"chosen\":[],\"qty\":1,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":1300,\"retail_eur\":52,\"ticket_date\":\"2026-06-02\",\"ticket_time\":\"18:00\",\"q\":{\"qty\":1,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":1300,\"retail_eur\":52,\"customer_czk\":1300,\"customer_eur\":52,\"agency_czk\":1040,\"agency_eur\":41.6,\"margin_czk\":260,\"margin_eur\":10.4,\"bonus_czk\":26,\"bonus_eur\":1.04}}', 1, 1300.00, 52.00, 0.00, 1300.00, 52.00, 20.00, 260.00, NULL, NULL, NULL, NULL, '2026-06-02', '18:00:00', '2026-06-01 19:54:32'),
(5, 5, 72, 71, '{\"73\":\"Dospělý\"}', '{\"lid\":\"47164c990ef5\",\"product_id\":72,\"version_id\":71,\"cell_key\":\"{\\\"73\\\":\\\"Dospělý\\\"}\",\"product_name\":\"Sightseeing Cruise\",\"product_name_en\":null,\"product_name_de\":null,\"agency\":\"Prague Boats\",\"agency_id\":9,\"image_path\":\"placeholders\\/ag-9.svg\",\"redemption_type\":\"direct_entry\",\"pickup_available\":0,\"pickup_required\":0,\"agency_deposit\":0,\"deposit_fixed_czk\":null,\"deposit_fixed_eur\":null,\"chosen\":[{\"label\":\"Typ pasažéra\",\"value\":\"Dospělý\"}],\"qty\":2,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":450,\"retail_eur\":18,\"ticket_date\":null,\"ticket_time\":null,\"q\":{\"qty\":2,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":450,\"retail_eur\":18,\"customer_czk\":900,\"customer_eur\":36,\"agency_czk\":720,\"agency_eur\":28.8,\"margin_czk\":180,\"margin_eur\":7.2,\"bonus_czk\":18,\"bonus_eur\":0.72}}', 2, 450.00, 18.00, 0.00, 900.00, 36.00, 20.00, 180.00, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-01 20:00:51'),
(6, 6, 49, 9, '{\"12\":\"A (orchestr\\/front rows)\"}', '{\"lid\":\"e2068936e31c\",\"product_id\":49,\"version_id\":9,\"cell_key\":\"{\\\"12\\\":\\\"A (orchestr\\\\\\/front rows)\\\"}\",\"product_name\":\"Best of Czech and World Classical Music\",\"product_name_en\":null,\"product_name_de\":null,\"agency\":\"Agency Artistic Intl (AAI)\",\"agency_id\":5,\"image_path\":\"placeholders\\/ag-5.svg\",\"redemption_type\":\"direct_entry\",\"pickup_available\":0,\"pickup_required\":0,\"agency_deposit\":0,\"deposit_fixed_czk\":null,\"deposit_fixed_eur\":null,\"chosen\":[{\"label\":\"Zóna\",\"value\":\"A (orchestr\\/front rows)\"}],\"qty\":2,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":800,\"retail_eur\":32,\"ticket_date\":\"2026-06-06\",\"ticket_time\":\"17:00\",\"q\":{\"qty\":2,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":800,\"retail_eur\":32,\"customer_czk\":1600,\"customer_eur\":64,\"agency_czk\":1280,\"agency_eur\":51.2,\"margin_czk\":320,\"margin_eur\":12.8,\"bonus_czk\":32,\"bonus_eur\":1.28}}', 2, 800.00, 32.00, 0.00, 1600.00, 64.00, 20.00, 320.00, NULL, NULL, NULL, NULL, '2026-06-06', '17:00:00', '2026-06-01 20:04:25'),
(7, 7, 79, 14, '{\"18\":\"Essential\",\"19\":\"Adult\"}', '{\"lid\":\"11d33b4192e8\",\"product_id\":79,\"version_id\":14,\"cell_key\":\"{\\\"18\\\":\\\"Essential\\\",\\\"19\\\":\\\"Adult\\\"}\",\"product_name\":\"Crystal Dinner\",\"product_name_en\":null,\"product_name_de\":null,\"agency\":\"Prague Boats\",\"agency_id\":9,\"image_path\":\"placeholders\\/ag-9.svg\",\"redemption_type\":\"direct_entry\",\"pickup_available\":0,\"pickup_required\":0,\"agency_deposit\":0,\"deposit_fixed_czk\":null,\"deposit_fixed_eur\":null,\"chosen\":[{\"label\":\"Balíček\",\"value\":\"Essential\"},{\"label\":\"Typ návštěvníka\",\"value\":\"Adult\"}],\"qty\":2,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":1980,\"retail_eur\":79,\"ticket_date\":\"2026-06-03\",\"ticket_time\":\"19:00\",\"q\":{\"qty\":2,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":1980,\"retail_eur\":79,\"customer_czk\":3960,\"customer_eur\":158,\"agency_czk\":3168,\"agency_eur\":126.4,\"margin_czk\":792,\"margin_eur\":31.6,\"bonus_czk\":79.2,\"bonus_eur\":3.16}}', 2, 1980.00, 79.00, 0.00, 3960.00, 158.00, 20.00, 792.00, NULL, NULL, NULL, NULL, '2026-06-03', '19:00:00', '2026-06-01 20:06:40'),
(8, 8, 78, 110, '{\"87\":\"Essential\",\"88\":\"Adult\"}', '{\"lid\":\"60b52afcca7e\",\"product_id\":78,\"version_id\":110,\"cell_key\":\"{\\\"87\\\":\\\"Essential\\\",\\\"88\\\":\\\"Adult\\\"}\",\"product_name\":\"Lunch Cruise (glass boat)\",\"product_name_en\":null,\"product_name_de\":null,\"agency\":\"Prague Boats\",\"agency_id\":9,\"image_path\":\"placeholders\\/ag-9.svg\",\"redemption_type\":\"direct_entry\",\"pickup_available\":0,\"pickup_required\":0,\"agency_deposit\":0,\"deposit_fixed_czk\":null,\"deposit_fixed_eur\":null,\"chosen\":[{\"label\":\"Sezení\",\"value\":\"Essential\"},{\"label\":\"Typ návštěvníka\",\"value\":\"Adult\"}],\"qty\":6,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":1230,\"retail_eur\":49,\"ticket_date\":\"2026-06-03\",\"ticket_time\":\"12:00\",\"q\":{\"qty\":6,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":1230,\"retail_eur\":49,\"customer_czk\":7380,\"customer_eur\":294,\"agency_czk\":5904,\"agency_eur\":235.2,\"margin_czk\":1476,\"margin_eur\":58.8,\"bonus_czk\":147.6,\"bonus_eur\":5.88}}', 6, 1230.00, 49.00, 0.00, 7380.00, 294.00, 20.00, 1476.00, NULL, NULL, NULL, NULL, '2026-06-03', '12:00:00', '2026-06-01 21:12:52'),
(9, 9, 103, 149, '{\"138\":\"Per person\"}', '{\"lid\":\"681e637a2eec\",\"product_id\":103,\"version_id\":149,\"cell_key\":\"{\\\"138\\\":\\\"Per person\\\"}\",\"product_name\":\"Castle Side Food Tour\",\"product_name_en\":null,\"product_name_de\":null,\"agency\":\"PragueWay\",\"agency_id\":15,\"image_path\":\"placeholders\\/ag-15.svg\",\"redemption_type\":\"direct_entry\",\"pickup_available\":0,\"pickup_required\":0,\"agency_deposit\":1,\"deposit_fixed_czk\":null,\"deposit_fixed_eur\":null,\"chosen\":[{\"label\":\"Návštěvník\",\"value\":\"Per person\"}],\"qty\":1,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":1400,\"retail_eur\":56,\"ticket_date\":\"2026-06-02\",\"ticket_time\":\"15:00\",\"q\":{\"qty\":1,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":1400,\"retail_eur\":56,\"customer_czk\":1400,\"customer_eur\":56,\"agency_czk\":1120,\"agency_eur\":44.8,\"margin_czk\":280,\"margin_eur\":11.2,\"bonus_czk\":28,\"bonus_eur\":1.12},\"meeting_label\":null,\"meeting_address\":null,\"is_pickup\":0,\"pickup_addr\":null,\"pickup_time\":null,\"seating\":0,\"seats_note\":null}', 1, 1400.00, 56.00, 0.00, 1400.00, 56.00, 20.00, 280.00, NULL, NULL, NULL, NULL, '2026-06-02', '15:00:00', '2026-06-02 13:20:12'),
(10, 10, 108, 154, '{\"143\":\"Per person\"}', '{\"lid\":\"c0fd726fc706\",\"product_id\":108,\"version_id\":154,\"cell_key\":\"{\\\"143\\\":\\\"Per person\\\"}\",\"product_name\":\"Charles Bridge River Cruise\",\"product_name_en\":null,\"product_name_de\":null,\"agency\":\"PragueWay\",\"agency_id\":15,\"image_path\":\"placeholders\\/ag-15.svg\",\"redemption_type\":\"direct_entry\",\"pickup_available\":0,\"pickup_required\":0,\"agency_deposit\":1,\"deposit_fixed_czk\":null,\"deposit_fixed_eur\":null,\"chosen\":[{\"label\":\"Návštěvník\",\"value\":\"Per person\"}],\"qty\":3,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":1000,\"retail_eur\":40,\"ticket_date\":\"2026-06-02\",\"ticket_time\":\"13:30\",\"q\":{\"qty\":3,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":1000,\"retail_eur\":40,\"customer_czk\":3000,\"customer_eur\":120,\"agency_czk\":2400,\"agency_eur\":96,\"margin_czk\":600,\"margin_eur\":24,\"bonus_czk\":60,\"bonus_eur\":2.4},\"meeting_label\":null,\"meeting_address\":null,\"is_pickup\":0,\"pickup_addr\":null,\"pickup_time\":null,\"seating\":0,\"seats_note\":null}', 3, 1000.00, 40.00, 0.00, 3000.00, 120.00, 20.00, 600.00, NULL, NULL, NULL, NULL, '2026-06-02', '13:30:00', '2026-06-02 15:13:28'),
(11, 11, 72, 233, '{\"222\":\"Adult\"}', '{\"lid\":\"9402f812f9c5\",\"product_id\":72,\"version_id\":233,\"cell_key\":\"{\\\"222\\\":\\\"Adult\\\"}\",\"product_name\":\"Sightseeing Cruise (50 min)\",\"product_name_en\":\"Sightseeing Cruise (50 min)\",\"product_name_de\":null,\"agency\":\"Prague Boats\",\"agency_id\":9,\"image_path\":\"placeholders\\/ag-9.svg\",\"redemption_type\":\"direct_entry\",\"pickup_available\":0,\"pickup_required\":0,\"agency_deposit\":0,\"deposit_fixed_czk\":null,\"deposit_fixed_eur\":null,\"chosen\":[{\"label\":\"Návštěvník\",\"value\":\"Adult\"}],\"qty\":2,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":450,\"retail_eur\":18,\"ticket_date\":\"2026-06-02\",\"ticket_time\":null,\"q\":{\"qty\":2,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":450,\"retail_eur\":18,\"customer_czk\":900,\"customer_eur\":36,\"agency_czk\":720,\"agency_eur\":28.8,\"margin_czk\":180,\"margin_eur\":7.2,\"bonus_czk\":18,\"bonus_eur\":0.72},\"meeting_label\":null,\"meeting_address\":null,\"is_pickup\":0,\"pickup_addr\":null,\"pickup_time\":null,\"seating\":0,\"seats_note\":null}', 2, 450.00, 18.00, 0.00, 900.00, 36.00, 20.00, 180.00, NULL, NULL, NULL, NULL, '2026-06-02', NULL, '2026-06-02 16:15:54'),
(12, 12, 88, 135, '{\"123\":\"Adult\"}', '{\"lid\":\"7b79bb105b38\",\"product_id\":88,\"version_id\":135,\"cell_key\":\"{\\\"123\\\":\\\"Adult\\\"}\",\"product_name\":\"Folklore Dinner Show\",\"product_name_en\":null,\"product_name_de\":null,\"agency\":\"Folklore Garden\",\"agency_id\":13,\"image_path\":\"placeholders\\/ag-13.svg\",\"redemption_type\":\"direct_entry\",\"pickup_available\":1,\"pickup_required\":1,\"agency_deposit\":0,\"deposit_fixed_czk\":null,\"deposit_fixed_eur\":null,\"chosen\":[{\"label\":\"Návštěvník\",\"value\":\"Adult\"}],\"qty\":2,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":1300,\"retail_eur\":52,\"ticket_date\":\"2026-06-10\",\"ticket_time\":null,\"q\":{\"qty\":2,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":1300,\"retail_eur\":52,\"customer_czk\":2600,\"customer_eur\":104,\"agency_czk\":2080,\"agency_eur\":83.2,\"margin_czk\":520,\"margin_eur\":20.8,\"bonus_czk\":52,\"bonus_eur\":2.08},\"meeting_label\":\"Místo srazu\",\"meeting_address\":\"Na Zlíchově 18, Praha 5 – Hlubočepy\",\"is_pickup\":0,\"pickup_addr\":null,\"pickup_time\":null,\"seating\":0,\"seats_note\":null}', 2, 1300.00, 52.00, 0.00, 2600.00, 104.00, 20.00, 520.00, NULL, NULL, NULL, NULL, '2026-06-10', NULL, '2026-06-02 17:17:12'),
(13, 12, 88, 135, '{\"123\":\"Child 3-12\"}', '{\"lid\":\"22cb1752e4da\",\"product_id\":88,\"version_id\":135,\"cell_key\":\"{\\\"123\\\":\\\"Child 3-12\\\"}\",\"product_name\":\"Folklore Dinner Show\",\"product_name_en\":null,\"product_name_de\":null,\"agency\":\"Folklore Garden\",\"agency_id\":13,\"image_path\":\"placeholders\\/ag-13.svg\",\"redemption_type\":\"direct_entry\",\"pickup_available\":1,\"pickup_required\":1,\"agency_deposit\":0,\"deposit_fixed_czk\":null,\"deposit_fixed_eur\":null,\"chosen\":[{\"label\":\"Návštěvník\",\"value\":\"Child 3-12\"}],\"qty\":1,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":825,\"retail_eur\":33,\"ticket_date\":\"2026-06-10\",\"ticket_time\":null,\"q\":{\"qty\":1,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":825,\"retail_eur\":33,\"customer_czk\":825,\"customer_eur\":33,\"agency_czk\":660,\"agency_eur\":26.4,\"margin_czk\":165,\"margin_eur\":6.6,\"bonus_czk\":16.5,\"bonus_eur\":0.66},\"meeting_label\":\"Místo srazu\",\"meeting_address\":\"Na Zlíchově 18, Praha 5 – Hlubočepy\",\"is_pickup\":0,\"pickup_addr\":null,\"pickup_time\":null,\"seating\":0,\"seats_note\":null}', 1, 825.00, 33.00, 0.00, 825.00, 33.00, 20.00, 165.00, NULL, NULL, NULL, NULL, '2026-06-10', NULL, '2026-06-02 17:17:12'),
(14, 13, 79, 240, '{\"230\":\"De Luxe\",\"231\":\"Adult\"}', '{\"lid\":\"66b6e5b22fb7\",\"product_id\":79,\"version_id\":240,\"cell_key\":\"{\\\"230\\\":\\\"De Luxe\\\",\\\"231\\\":\\\"Adult\\\"}\",\"product_name\":\"Crystal Dinner Cruise (3h)\",\"product_name_en\":\"Crystal Dinner Cruise (3h)\",\"product_name_de\":null,\"agency\":\"Prague Boats\",\"agency_id\":9,\"image_path\":\"placeholders\\/ag-9.svg\",\"redemption_type\":\"direct_entry\",\"pickup_available\":0,\"pickup_required\":0,\"agency_deposit\":0,\"deposit_fixed_czk\":null,\"deposit_fixed_eur\":null,\"chosen\":[{\"label\":\"Třída\",\"value\":\"De Luxe\"},{\"label\":\"Návštěvník\",\"value\":\"Adult\"}],\"qty\":2,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":3230,\"retail_eur\":129,\"ticket_date\":\"2026-06-02\",\"ticket_time\":\"19:00\",\"q\":{\"qty\":2,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":3230,\"retail_eur\":129,\"customer_czk\":6460,\"customer_eur\":258,\"agency_czk\":5168,\"agency_eur\":206.4,\"margin_czk\":1292,\"margin_eur\":51.6,\"bonus_czk\":129.2,\"bonus_eur\":5.16},\"meeting_label\":null,\"meeting_address\":null,\"is_pickup\":0,\"pickup_addr\":null,\"pickup_time\":null,\"seating\":0,\"seats_note\":null}', 2, 3230.00, 129.00, 0.00, 6460.00, 258.00, 20.00, 1292.00, NULL, NULL, NULL, NULL, '2026-06-02', '19:00:00', '2026-06-02 17:21:50'),
(15, 14, 118, 121, '{\"101\":\"Discover\",\"102\":\"Adult\"}', '{\"lid\":\"5cf357991094\",\"product_id\":118,\"version_id\":121,\"cell_key\":\"{\\\"101\\\":\\\"Discover\\\",\\\"102\\\":\\\"Adult\\\"}\",\"product_name\":\"Big Bus Hop-on Hop-off\",\"product_name_en\":\"Big Bus Hop-on Hop-off\",\"product_name_de\":null,\"agency\":\"Big Bus Tours\",\"agency_id\":1,\"image_path\":\"placeholders\\/ag-1.svg\",\"redemption_type\":\"bus_activation\",\"pickup_available\":0,\"pickup_required\":0,\"agency_deposit\":0,\"deposit_fixed_czk\":null,\"deposit_fixed_eur\":null,\"chosen\":[{\"label\":\"Varianta\",\"value\":\"Discover\"},{\"label\":\"Typ pasažéra\",\"value\":\"Adult\"}],\"qty\":2,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":780,\"retail_eur\":31,\"ticket_date\":null,\"ticket_time\":null,\"q\":{\"qty\":2,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":780,\"retail_eur\":31,\"customer_czk\":1560,\"customer_eur\":62,\"agency_czk\":1248,\"agency_eur\":49.6,\"margin_czk\":312,\"margin_eur\":12.4,\"bonus_czk\":31.2,\"bonus_eur\":1.24},\"meeting_label\":null,\"meeting_address\":null,\"is_pickup\":0,\"pickup_addr\":null,\"pickup_time\":null,\"seating\":0,\"seats_note\":null}', 2, 780.00, 31.00, 0.00, 1560.00, 62.00, 20.00, 312.00, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-02 17:24:56'),
(16, 14, 118, 121, '{\"101\":\"Discover\",\"102\":\"Adult\"}', '{\"lid\":\"786f42ad7b84\",\"product_id\":118,\"version_id\":121,\"cell_key\":\"{\\\"101\\\":\\\"Discover\\\",\\\"102\\\":\\\"Adult\\\"}\",\"product_name\":\"Big Bus Hop-on Hop-off\",\"product_name_en\":\"Big Bus Hop-on Hop-off\",\"product_name_de\":null,\"agency\":\"Big Bus Tours\",\"agency_id\":1,\"image_path\":\"placeholders\\/ag-1.svg\",\"redemption_type\":\"bus_activation\",\"pickup_available\":0,\"pickup_required\":0,\"agency_deposit\":0,\"deposit_fixed_czk\":null,\"deposit_fixed_eur\":null,\"chosen\":[{\"label\":\"Varianta\",\"value\":\"Discover\"},{\"label\":\"Typ pasažéra\",\"value\":\"Adult\"}],\"qty\":2,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":780,\"retail_eur\":31,\"ticket_date\":null,\"ticket_time\":null,\"q\":{\"qty\":2,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":780,\"retail_eur\":31,\"customer_czk\":1560,\"customer_eur\":62,\"agency_czk\":1248,\"agency_eur\":49.6,\"margin_czk\":312,\"margin_eur\":12.4,\"bonus_czk\":31.2,\"bonus_eur\":1.24},\"meeting_label\":null,\"meeting_address\":null,\"is_pickup\":0,\"pickup_addr\":null,\"pickup_time\":null,\"seating\":0,\"seats_note\":null}', 2, 780.00, 31.00, 0.00, 1560.00, 62.00, 20.00, 312.00, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-02 17:24:56'),
(17, 15, 105, 151, '{\"140\":\"Per person\"}', '{\"lid\":\"73e7821ea8dc\",\"product_id\":105,\"version_id\":151,\"cell_key\":\"{\\\"140\\\":\\\"Per person\\\"}\",\"product_name\":\"One Prague Tour Castle Side\",\"product_name_en\":null,\"product_name_de\":null,\"agency\":\"PragueWay\",\"agency_id\":15,\"image_path\":\"placeholders\\/ag-15.svg\",\"redemption_type\":\"direct_entry\",\"pickup_available\":0,\"pickup_required\":0,\"agency_deposit\":1,\"deposit_fixed_czk\":null,\"deposit_fixed_eur\":null,\"chosen\":[{\"label\":\"Návštěvník\",\"value\":\"Per person\"}],\"qty\":9,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":1300,\"retail_eur\":52,\"ticket_date\":\"2026-06-02\",\"ticket_time\":\"10:30\",\"q\":{\"qty\":9,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":1300,\"retail_eur\":52,\"customer_czk\":11700,\"customer_eur\":468,\"agency_czk\":9360,\"agency_eur\":374.4,\"margin_czk\":2340,\"margin_eur\":93.6,\"bonus_czk\":234,\"bonus_eur\":9.36},\"meeting_label\":null,\"meeting_address\":null,\"is_pickup\":0,\"pickup_addr\":null,\"pickup_time\":null,\"seating\":0,\"seats_note\":null}', 9, 1300.00, 52.00, 0.00, 11700.00, 468.00, 20.00, 2340.00, NULL, NULL, NULL, NULL, '2026-06-02', '10:30:00', '2026-06-02 17:26:06'),
(18, 16, 111, 157, '{\"146\":\"Per person\"}', '{\"lid\":\"d108066985eb\",\"product_id\":111,\"version_id\":157,\"cell_key\":\"{\\\"146\\\":\\\"Per person\\\"}\",\"product_name\":\"Old Town & Medieval Underground\",\"product_name_en\":null,\"product_name_de\":null,\"agency\":\"PragueWay\",\"agency_id\":15,\"image_path\":\"placeholders\\/ag-15.svg\",\"redemption_type\":\"direct_entry\",\"pickup_available\":0,\"pickup_required\":0,\"agency_deposit\":1,\"deposit_fixed_czk\":null,\"deposit_fixed_eur\":null,\"chosen\":[{\"label\":\"Návštěvník\",\"value\":\"Per person\"}],\"qty\":2,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":1400,\"retail_eur\":56,\"ticket_date\":\"2026-06-02\",\"ticket_time\":\"10:00\",\"q\":{\"qty\":2,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":1400,\"retail_eur\":56,\"customer_czk\":2800,\"customer_eur\":112,\"agency_czk\":2240,\"agency_eur\":89.6,\"margin_czk\":560,\"margin_eur\":22.4,\"bonus_czk\":56,\"bonus_eur\":2.24},\"meeting_label\":null,\"meeting_address\":null,\"is_pickup\":0,\"pickup_addr\":null,\"pickup_time\":null,\"seating\":0,\"seats_note\":null}', 2, 1400.00, 56.00, 0.00, 2800.00, 112.00, 20.00, 560.00, NULL, NULL, NULL, NULL, '2026-06-02', '10:00:00', '2026-06-02 17:27:35'),
(19, 17, 81, 242, '{\"234\":\"Adult\"}', '{\"lid\":\"0f4b02fffa19\",\"product_id\":81,\"version_id\":242,\"cell_key\":\"{\\\"234\\\":\\\"Adult\\\"}\",\"product_name\":\"Čertovka 45min Cruise (Prague Venice)\",\"product_name_en\":\"Čertovka 45min Cruise (Prague Venice)\",\"product_name_de\":null,\"agency\":\"Prague Venice\",\"agency_id\":10,\"image_path\":\"placeholders\\/ag-10.svg\",\"redemption_type\":\"direct_entry\",\"pickup_available\":0,\"pickup_required\":0,\"agency_deposit\":0,\"deposit_fixed_czk\":null,\"deposit_fixed_eur\":null,\"chosen\":[{\"label\":\"Návštěvník\",\"value\":\"Adult\"}],\"qty\":3,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":550,\"retail_eur\":22,\"ticket_date\":\"2026-06-02\",\"ticket_time\":null,\"q\":{\"qty\":3,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":550,\"retail_eur\":22,\"customer_czk\":1650,\"customer_eur\":66,\"agency_czk\":1320,\"agency_eur\":52.8,\"margin_czk\":330,\"margin_eur\":13.2,\"bonus_czk\":33,\"bonus_eur\":1.32},\"meeting_label\":null,\"meeting_address\":null,\"is_pickup\":0,\"pickup_addr\":null,\"pickup_time\":null,\"seating\":0,\"seats_note\":null}', 3, 550.00, 22.00, 0.00, 1650.00, 66.00, 20.00, 330.00, NULL, NULL, NULL, NULL, '2026-06-02', NULL, '2026-06-02 18:15:50'),
(20, 17, 81, 242, '{\"234\":\"Child 2-12\"}', '{\"lid\":\"dcc49cbd135d\",\"product_id\":81,\"version_id\":242,\"cell_key\":\"{\\\"234\\\":\\\"Child 2-12\\\"}\",\"product_name\":\"Čertovka 45min Cruise (Prague Venice)\",\"product_name_en\":\"Čertovka 45min Cruise (Prague Venice)\",\"product_name_de\":null,\"agency\":\"Prague Venice\",\"agency_id\":10,\"image_path\":\"placeholders\\/ag-10.svg\",\"redemption_type\":\"direct_entry\",\"pickup_available\":0,\"pickup_required\":0,\"agency_deposit\":0,\"deposit_fixed_czk\":null,\"deposit_fixed_eur\":null,\"chosen\":[{\"label\":\"Návštěvník\",\"value\":\"Child 2-12\"}],\"qty\":2,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":350,\"retail_eur\":14,\"ticket_date\":\"2026-06-02\",\"ticket_time\":null,\"q\":{\"qty\":2,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":350,\"retail_eur\":14,\"customer_czk\":700,\"customer_eur\":28,\"agency_czk\":560,\"agency_eur\":22.4,\"margin_czk\":140,\"margin_eur\":5.6,\"bonus_czk\":14,\"bonus_eur\":0.56},\"meeting_label\":null,\"meeting_address\":null,\"is_pickup\":0,\"pickup_addr\":null,\"pickup_time\":null,\"seating\":0,\"seats_note\":null}', 2, 350.00, 14.00, 0.00, 700.00, 28.00, 20.00, 140.00, NULL, NULL, NULL, NULL, '2026-06-02', NULL, '2026-06-02 18:15:50'),
(21, 18, 79, 240, '{\"230\":\"Essential\",\"231\":\"Adult\"}', '{\"lid\":\"942789e9bef2\",\"product_id\":79,\"version_id\":240,\"cell_key\":\"{\\\"230\\\":\\\"Essential\\\",\\\"231\\\":\\\"Adult\\\"}\",\"product_name\":\"Crystal Dinner Cruise (3h)\",\"product_name_en\":\"Crystal Dinner Cruise (3h)\",\"product_name_de\":null,\"agency\":\"Prague Boats\",\"agency_id\":9,\"image_path\":\"placeholders\\/ag-9.svg\",\"redemption_type\":\"direct_entry\",\"pickup_available\":0,\"pickup_required\":0,\"agency_deposit\":0,\"deposit_fixed_czk\":null,\"deposit_fixed_eur\":null,\"chosen\":[{\"label\":\"Třída\",\"value\":\"Essential\"},{\"label\":\"Návštěvník\",\"value\":\"Adult\"}],\"qty\":1,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":1980,\"retail_eur\":79,\"ticket_date\":\"2026-06-02\",\"ticket_time\":\"19:00\",\"q\":{\"qty\":1,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":1980,\"retail_eur\":79,\"customer_czk\":1980,\"customer_eur\":79,\"agency_czk\":1584,\"agency_eur\":63.2,\"margin_czk\":396,\"margin_eur\":15.8,\"bonus_czk\":39.6,\"bonus_eur\":1.58},\"meeting_label\":null,\"meeting_address\":null,\"is_pickup\":0,\"pickup_addr\":null,\"pickup_time\":null,\"seating\":0,\"seats_note\":null}', 1, 1980.00, 79.00, 0.00, 1980.00, 79.00, 20.00, 396.00, NULL, NULL, NULL, NULL, '2026-06-02', '19:00:00', '2026-06-02 18:35:21'),
(22, 19, 118, 121, '{\"101\":\"Discover\",\"102\":\"Adult\"}', '{\"lid\":\"c24270528f33\",\"product_id\":118,\"version_id\":121,\"cell_key\":\"{\\\"101\\\":\\\"Discover\\\",\\\"102\\\":\\\"Adult\\\"}\",\"product_name\":\"Big Bus Hop-on Hop-off\",\"product_name_en\":\"Big Bus Hop-on Hop-off\",\"product_name_de\":null,\"agency\":\"Big Bus Tours\",\"agency_id\":1,\"image_path\":\"placeholders\\/ag-1.svg\",\"redemption_type\":\"bus_activation\",\"pickup_available\":0,\"pickup_required\":0,\"agency_deposit\":0,\"deposit_fixed_czk\":null,\"deposit_fixed_eur\":null,\"chosen\":[{\"label\":\"Varianta\",\"value\":\"Discover\"},{\"label\":\"Typ pasažéra\",\"value\":\"Adult\"}],\"qty\":2,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":780,\"retail_eur\":31,\"ticket_date\":null,\"ticket_time\":null,\"q\":{\"qty\":2,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":780,\"retail_eur\":31,\"customer_czk\":1560,\"customer_eur\":62,\"agency_czk\":1248,\"agency_eur\":49.6,\"margin_czk\":312,\"margin_eur\":12.4,\"bonus_czk\":31.2,\"bonus_eur\":1.24},\"meeting_label\":null,\"meeting_address\":null,\"is_pickup\":0,\"pickup_addr\":null,\"pickup_time\":null,\"seating\":0,\"seats_note\":null}', 2, 780.00, 31.00, 0.00, 1560.00, 62.00, 20.00, 312.00, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-02 18:45:54'),
(23, 20, 92, 138, '{\"126\":\"Chomutov (62 m bridge)\"}', '{\"lid\":\"2437bb65ce6a\",\"product_id\":92,\"version_id\":138,\"cell_key\":\"{\\\"126\\\":\\\"Chomutov (62 m bridge)\\\"}\",\"product_name\":\"Bungee Jumping\",\"product_name_en\":null,\"product_name_de\":null,\"agency\":\"Magical Prague\",\"agency_id\":14,\"image_path\":\"placeholders\\/ag-14.svg\",\"redemption_type\":\"direct_entry\",\"pickup_available\":1,\"pickup_required\":1,\"agency_deposit\":1,\"deposit_fixed_czk\":null,\"deposit_fixed_eur\":null,\"chosen\":[{\"label\":\"Lokalita\",\"value\":\"Chomutov (62 m bridge)\"}],\"qty\":1,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":3800,\"retail_eur\":150,\"ticket_date\":\"2026-06-02\",\"ticket_time\":null,\"q\":{\"qty\":1,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":3800,\"retail_eur\":150,\"customer_czk\":3800,\"customer_eur\":150,\"agency_czk\":3040,\"agency_eur\":120,\"margin_czk\":760,\"margin_eur\":30,\"bonus_czk\":76,\"bonus_eur\":3},\"meeting_label\":\"Hotel pickup\",\"meeting_address\":\"Brix\",\"is_pickup\":1,\"pickup_addr\":\"Brix\",\"pickup_time\":\"8:15\",\"seating\":0,\"seats_note\":null}', 1, 3800.00, 150.00, 0.00, 3800.00, 150.00, 20.00, 760.00, NULL, NULL, NULL, NULL, '2026-06-02', NULL, '2026-06-02 18:58:07'),
(24, 21, 110, 156, '{\"145\":\"Per person\"}', '{\"lid\":\"63a687be5f36\",\"product_id\":110,\"version_id\":156,\"cell_key\":\"{\\\"145\\\":\\\"Per person\\\"}\",\"product_name\":\"E-Scooter Grand City Tour\",\"product_name_en\":null,\"product_name_de\":null,\"agency\":\"PragueWay\",\"agency_id\":15,\"image_path\":\"placeholders\\/ag-15.svg\",\"redemption_type\":\"direct_entry\",\"pickup_available\":0,\"pickup_required\":0,\"agency_deposit\":1,\"deposit_fixed_czk\":null,\"deposit_fixed_eur\":null,\"chosen\":[{\"label\":\"Návštěvník\",\"value\":\"Per person\"}],\"qty\":2,\"discount_pct\":10,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":1700,\"retail_eur\":68,\"ticket_date\":\"2026-06-02\",\"ticket_time\":\"17:00\",\"q\":{\"qty\":2,\"discount_pct\":10,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":1700,\"retail_eur\":68,\"customer_czk\":3060,\"customer_eur\":122.4,\"agency_czk\":2720,\"agency_eur\":108.8,\"margin_czk\":340,\"margin_eur\":13.6,\"bonus_czk\":34,\"bonus_eur\":1.36},\"meeting_label\":null,\"meeting_address\":null,\"is_pickup\":0,\"pickup_addr\":null,\"pickup_time\":null,\"seating\":0,\"seats_note\":null}', 2, 1700.00, 68.00, 10.00, 3060.00, 122.40, 20.00, 340.00, NULL, NULL, NULL, NULL, '2026-06-02', '17:00:00', '2026-06-02 19:02:32'),
(25, 22, 11, 169, '{\"158\":\"Adult\"}', '{\"lid\":\"1cab2bec76d5\",\"product_id\":11,\"version_id\":169,\"cell_key\":\"{\\\"158\\\":\\\"Adult\\\"}\",\"product_name\":\"Český Krumlov – UNESCO\",\"product_name_en\":\"Český Krumlov – UNESCO\",\"product_name_de\":null,\"agency\":\"Premiant\",\"agency_id\":2,\"image_path\":\"placeholders\\/ag-2.svg\",\"redemption_type\":\"direct_entry\",\"pickup_available\":1,\"pickup_required\":0,\"agency_deposit\":0,\"deposit_fixed_czk\":null,\"deposit_fixed_eur\":null,\"chosen\":[{\"label\":\"Návštěvník\",\"value\":\"Adult\"}],\"qty\":1,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":1950,\"retail_eur\":78,\"ticket_date\":\"2026-06-02\",\"ticket_time\":null,\"q\":{\"qty\":1,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":1950,\"retail_eur\":78,\"customer_czk\":1950,\"customer_eur\":78,\"agency_czk\":1560,\"agency_eur\":62.4,\"margin_czk\":390,\"margin_eur\":15.6,\"bonus_czk\":39,\"bonus_eur\":1.56},\"meeting_label\":\"Hotel pickup\",\"meeting_address\":\"Hotel Avion\",\"is_pickup\":1,\"pickup_addr\":\"Hotel Avion\",\"pickup_time\":\"8:00\",\"seating\":0,\"seats_note\":null}', 1, 1950.00, 78.00, 0.00, 1950.00, 78.00, 20.00, 390.00, NULL, NULL, NULL, NULL, '2026-06-02', NULL, '2026-06-02 19:06:27'),
(26, 23, 118, 121, '{\"101\":\"Essential\",\"102\":\"Adult\"}', '{\"lid\":\"c66eb243b918\",\"product_id\":118,\"version_id\":121,\"cell_key\":\"{\\\"101\\\":\\\"Essential\\\",\\\"102\\\":\\\"Adult\\\"}\",\"product_name\":\"Big Bus Hop-on Hop-off\",\"product_name_en\":\"Big Bus Hop-on Hop-off\",\"product_name_de\":null,\"agency\":\"Big Bus Tours\",\"agency_id\":1,\"image_path\":\"placeholders\\/ag-1.svg\",\"redemption_type\":\"bus_activation\",\"pickup_available\":0,\"pickup_required\":0,\"agency_deposit\":0,\"deposit_fixed_czk\":null,\"deposit_fixed_eur\":null,\"chosen\":[{\"label\":\"Varianta\",\"value\":\"Essential\"},{\"label\":\"Typ pasažéra\",\"value\":\"Adult\"}],\"qty\":1,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":900,\"retail_eur\":36,\"ticket_date\":null,\"ticket_time\":null,\"q\":{\"qty\":1,\"discount_pct\":0,\"commission_pct\":20,\"bonus_pct\":10,\"retail_czk\":900,\"retail_eur\":36,\"customer_czk\":900,\"customer_eur\":36,\"agency_czk\":720,\"agency_eur\":28.8,\"margin_czk\":180,\"margin_eur\":7.2,\"bonus_czk\":18,\"bonus_eur\":0.72},\"meeting_label\":null,\"meeting_address\":null,\"is_pickup\":0,\"pickup_addr\":null,\"pickup_time\":null,\"seating\":0,\"seats_note\":null}', 1, 900.00, 36.00, 0.00, 900.00, 36.00, 20.00, 180.00, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-02 20:04:29');

-- --------------------------------------------------------

--
-- Struktura tabulky `schema_migrations`
--

CREATE TABLE `schema_migrations` (
  `version` varchar(20) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `applied_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Vypisuji data pro tabulku `schema_migrations`
--

INSERT INTO `schema_migrations` (`version`, `filename`, `applied_at`) VALUES
('001', '001_core_schema.sql', '2026-05-31 16:40:47'),
('002', '002_seed_min.sql', '2026-05-31 16:40:47'),
('003', '003_pricing_schema.sql', '2026-06-01 06:07:44'),
('004', '004_seed_agencies.sql', '2026-06-01 06:07:44'),
('005', '005_seed_products.sql', '2026-06-01 06:52:56'),
('006', '006_product_image.sql', '2026-06-01 07:00:31'),
('007', '007_sales_schema.sql', '2026-06-01 08:08:02'),
('008', '008_commission_bonus.sql', '2026-06-01 08:37:00'),
('009', '009_agency_commission_default.sql', '2026-06-01 08:37:00'),
('010', '010_open_tickets.sql', '2026-06-01 09:07:04'),
('011', '011_variant_cards.sql', '2026-06-01 10:11:45'),
('012', '012_crystal_diagram_features.sql', '2026-06-01 10:57:04'),
('013', '013_prague_boats_descriptions.sql', '2026-06-01 13:46:16'),
('014', '014_bigbus_merge.sql', '2026-06-01 13:46:16'),
('015', '015_prague_boats_seating.sql', '2026-06-01 13:46:16'),
('016', '016_magical_prague_packages.sql', '2026-06-01 13:46:16'),
('017', '017_bigbus_panoramic_fix.sql', '2026-06-01 13:46:16'),
('018', '018_order_instructions.sql', '2026-06-01 14:47:34'),
('020', '020_schedules.sql', '2026-06-01 15:52:23'),
('021', '021_placeholder_images.sql', '2026-06-01 15:52:23'),
('023', '023_catalog_schedules.sql', '2026-06-01 16:10:45'),
('026', '026_product_languages.sql', '2026-06-01 16:46:18'),
('027', '027_featured.sql', '2026-06-01 16:46:18'),
('028', '028_deposit.sql', '2026-06-01 17:53:37'),
('029', '029_meeting_point.sql', '2026-06-01 17:53:37'),
('030', '030_voucher_content.sql', '2026-06-02 12:53:59'),
('031', '031_voucher_content_seed.sql', '2026-06-02 12:55:19'),
('032', '032_meeting_points.sql', '2026-06-02 12:55:47'),
('033', '033_meeting_points_fix.sql', '2026-06-02 13:01:36'),
('034', '034_pricing_aai_cleanup.sql', '2026-06-02 13:01:57'),
('035', '035_aai_prices.sql', '2026-06-02 13:02:20'),
('036', '036_meeting_variants.sql', '2026-06-02 13:02:44'),
('037', '037_seating.sql', '2026-06-02 13:03:39'),
('038', '038_pricing_mozart_magical_folklore.sql', '2026-06-02 13:05:51'),
('039', '039_pricing_magical_prague.sql', '2026-06-02 13:06:52'),
('040', '040_addons.sql', '2026-06-02 13:07:19'),
('041', '041_folklore_details.sql', '2026-06-02 13:08:23'),
('042', '042_prices_pragueway_upavouka_premiant_besttour.sql', '2026-06-02 13:08:48'),
('043', '043_prices_martin_tour.sql', '2026-06-02 13:11:36'),
('044', '044_pragueway_new_and_bohemia_adventures.sql', '2026-06-02 13:11:36'),
('045', '045_prices_mcgees.sql', '2026-06-02 13:11:36'),
('046', '046_prices_prague_boats.sql', '2026-06-02 13:11:36'),
('047', '047_prices_prague_venice.sql', '2026-06-02 13:11:36'),
('048', '048_prices_image_srnec.sql', '2026-06-02 13:11:36'),
('049', '049_prices_wow.sql', '2026-06-02 13:11:36'),
('050', '050_postsale_ops.sql', '2026-06-02 15:10:01'),
('051', '051_bigbus_no_reservation.sql', '2026-06-02 18:08:01'),
('052', '052_deactivate_unpriced.sql', '2026-06-02 18:08:01');

-- --------------------------------------------------------

--
-- Struktura tabulky `sellers`
--

CREATE TABLE `sellers` (
  `id` int(10) UNSIGNED NOT NULL,
  `tenant_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(120) NOT NULL,
  `pin_hash` varchar(255) NOT NULL,
  `role` enum('seller','partner_seller') NOT NULL DEFAULT 'seller',
  `status` enum('active','inactive','archived') NOT NULL DEFAULT 'active',
  `last_login_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Vypisuji data pro tabulku `sellers`
--

INSERT INTO `sellers` (`id`, `tenant_id`, `name`, `pin_hash`, `role`, `status`, `last_login_at`, `created_at`, `updated_at`) VALUES
(1, 1, 'Karel', '$2y$12$AWnzMV1GM0yKkCwPn3G4g.8C3qJKyy6J3BlAoqXa9m10AtD6gfCnS', 'seller', 'active', '2026-06-03 05:50:23', '2026-05-31 17:09:35', '2026-06-03 05:50:23');

-- --------------------------------------------------------

--
-- Struktura tabulky `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(128) NOT NULL,
  `actor_type` enum('seller','admin') DEFAULT NULL,
  `actor_id` int(10) UNSIGNED DEFAULT NULL,
  `tenant_id` int(10) UNSIGNED DEFAULT NULL,
  `station_id` int(10) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `payload` mediumtext NOT NULL,
  `last_activity` int(10) UNSIGNED NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Vypisuji data pro tabulku `sessions`
--

INSERT INTO `sessions` (`id`, `actor_type`, `actor_id`, `tenant_id`, `station_id`, `ip_address`, `user_agent`, `payload`, `last_activity`, `created_at`) VALUES
('0127359a00ad6a07dbc7de3ab0d33292', NULL, NULL, NULL, NULL, '90.180.55.48', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/30.0 Chrome/143.0.0.0 Mobile Safari/537.36', '_csrf|s:64:\"ec4ac5dfa89c771e36843aa4d929ec2b1d99f80d724cecf5aefb0e712a96785c\";actor|a:7:{s:4:\"type\";s:6:\"seller\";s:2:\"id\";i:1;s:4:\"name\";s:5:\"Karel\";s:4:\"role\";s:6:\"seller\";s:9:\"tenant_id\";i:1;s:10:\"station_id\";N;s:8:\"login_at\";i:1780309009;}', 1780325586, '2026-06-01 10:16:49'),
('19e15fbd9106d7289b10ce8c6dfeb47c', NULL, NULL, NULL, NULL, '37.188.201.156', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/30.0 Chrome/143.0.0.0 Mobile Safari/537.36', '_csrf|s:64:\"42594025c0eb6b6d3c295d949ba88c12dacbd17cbc62925f1e05b64d51e844e8\";actor|a:7:{s:4:\"type\";s:5:\"admin\";s:2:\"id\";i:1;s:4:\"name\";s:6:\"Michal\";s:5:\"email\";s:25:\"michal@prague-tourism.com\";s:4:\"role\";s:5:\"owner\";s:9:\"tenant_id\";N;s:8:\"login_at\";i:1780295183;}', 1780295382, '2026-06-01 06:26:23'),
('2a1937299164266d76ec636c5e275266', NULL, NULL, NULL, NULL, '90.180.55.48', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/30.0 Chrome/143.0.0.0 Mobile Safari/537.36', '_csrf|s:64:\"dd2a6cfe3d07c2bef36d0d5612006c08012745e2a5a2c421788f666a8c1b44f6\";actor|a:7:{s:4:\"type\";s:6:\"seller\";s:2:\"id\";i:1;s:4:\"name\";s:5:\"Karel\";s:4:\"role\";s:6:\"seller\";s:9:\"tenant_id\";i:1;s:10:\"station_id\";N;s:8:\"login_at\";i:1780416868;}', 1780419641, '2026-06-02 16:14:28'),
('4228102f74211177eaf95710db457102', NULL, NULL, NULL, NULL, '90.180.55.48', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '_csrf|s:64:\"10c1a9f647104b74242ab6c67a707db28d8c38c0f7a2b0068eda8866807e52eb\";actor|a:7:{s:4:\"type\";s:5:\"admin\";s:2:\"id\";i:1;s:4:\"name\";s:6:\"Michal\";s:5:\"email\";s:25:\"michal@prague-tourism.com\";s:4:\"role\";s:5:\"owner\";s:9:\"tenant_id\";N;s:8:\"login_at\";i:1780416165;}', 1780423712, '2026-06-02 16:02:45'),
('4353e35ca3311abe9e0328710466d240', NULL, NULL, NULL, NULL, '90.180.55.48', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '_csrf|s:64:\"1ef41d7d3fdf196d2bb3b1cd60044ef6abfbab8fe5c97b7cd203c8ae44a34c45\";actor|a:7:{s:4:\"type\";s:6:\"seller\";s:2:\"id\";i:1;s:4:\"name\";s:5:\"Karel\";s:4:\"role\";s:6:\"seller\";s:9:\"tenant_id\";i:1;s:10:\"station_id\";N;s:8:\"login_at\";i:1780420445;}', 1780430783, '2026-06-02 17:14:05'),
('435e8cb6ea9c0f829efbccf60a5fad53', NULL, NULL, NULL, NULL, '90.180.55.48', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/30.0 Chrome/143.0.0.0 Mobile Safari/537.36', '_csrf|s:64:\"449eacd3017dde1378fecfef23362fd779e17d63f833aa2f32a380ce2cae528d\";actor|a:7:{s:4:\"type\";s:6:\"seller\";s:2:\"id\";i:1;s:4:\"name\";s:5:\"Karel\";s:4:\"role\";s:6:\"seller\";s:9:\"tenant_id\";i:1;s:10:\"station_id\";N;s:8:\"login_at\";i:1780288326;}', 1780288327, '2026-06-01 04:32:06'),
('585e5d9c37a626a3023bdf7a97863e64', NULL, NULL, NULL, NULL, '90.180.55.48', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '_csrf|s:64:\"d408608ba9ada43a6a39f9364605514b665cdf30c9efc85044f325c08e08f787\";actor|a:7:{s:4:\"type\";s:6:\"seller\";s:2:\"id\";i:1;s:4:\"name\";s:5:\"Karel\";s:4:\"role\";s:6:\"seller\";s:9:\"tenant_id\";i:1;s:10:\"station_id\";N;s:8:\"login_at\";i:1780465823;}', 1780466566, '2026-06-03 05:50:23'),
('671fec9b985966199f9cd27eb3c68df1', NULL, NULL, NULL, NULL, '90.180.55.48', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '', 1780290418, '2026-06-01 05:06:58'),
('672357fa1371af6c99dd52d726425299', NULL, NULL, NULL, NULL, '90.180.55.48', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '_csrf|s:64:\"971d23e04279b6d95cee291dd061f1edb9fb589a4f389d4b5fbb3faa47ef24a2\";actor|a:7:{s:4:\"type\";s:5:\"admin\";s:2:\"id\";i:1;s:4:\"name\";s:6:\"Michal\";s:5:\"email\";s:25:\"michal@prague-tourism.com\";s:4:\"role\";s:5:\"owner\";s:9:\"tenant_id\";N;s:8:\"login_at\";i:1780248509;}', 1780248510, '2026-05-31 17:28:29'),
('7a0f874be3abff5d153c18b44d3c9da3', NULL, NULL, NULL, NULL, '90.180.55.48', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/30.0 Chrome/143.0.0.0 Mobile Safari/537.36', '_csrf|s:64:\"52a335f0befe744b01a7c0d8f010e5ff6b56a51824f3f5f8a8c5b6285f301dd2\";actor|a:7:{s:4:\"type\";s:6:\"seller\";s:2:\"id\";i:1;s:4:\"name\";s:5:\"Karel\";s:4:\"role\";s:6:\"seller\";s:9:\"tenant_id\";i:1;s:10:\"station_id\";N;s:8:\"login_at\";i:1780375996;}', 1780376181, '2026-06-02 04:53:16'),
('95f544d7f002941bf177c3d15b6c9e35', NULL, NULL, NULL, NULL, '90.180.55.48', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/30.0 Chrome/143.0.0.0 Mobile Safari/537.36', '_csrf|s:64:\"936176041f85c89a732a98179c4943061adb0fd5c836bec5afb45f5c3a57c090\";actor|a:7:{s:4:\"type\";s:6:\"seller\";s:2:\"id\";i:1;s:4:\"name\";s:5:\"Karel\";s:4:\"role\";s:6:\"seller\";s:9:\"tenant_id\";i:1;s:10:\"station_id\";N;s:8:\"login_at\";i:1780379986;}', 1780379987, '2026-06-02 05:59:46'),
('a3c877f6211a57e859aabc2ed1101233', NULL, NULL, NULL, NULL, '90.180.55.48', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '_csrf|s:64:\"db21df8a7a64e4d0f0bc5e95de35833d21792deb9fcb7d7c68081a7d596c1fdc\";actor|a:7:{s:4:\"type\";s:6:\"seller\";s:2:\"id\";i:1;s:4:\"name\";s:5:\"Karel\";s:4:\"role\";s:6:\"seller\";s:9:\"tenant_id\";i:1;s:10:\"station_id\";N;s:8:\"login_at\";i:1780407837;}', 1780409391, '2026-06-02 13:43:57'),
('b9b1b56d79f6c0371f5634ce9c08d4d3', NULL, NULL, NULL, NULL, '90.180.55.48', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/30.0 Chrome/143.0.0.0 Mobile Safari/537.36', '_csrf|s:64:\"a31e87cdc2f3c58e1c9b461d5f3a2b67deb75c720a63c7d8c9a4643a1e341995\";actor|a:7:{s:4:\"type\";s:6:\"seller\";s:2:\"id\";i:1;s:4:\"name\";s:5:\"Karel\";s:4:\"role\";s:6:\"seller\";s:9:\"tenant_id\";i:1;s:10:\"station_id\";N;s:8:\"login_at\";i:1780335791;}', 1780336643, '2026-06-01 17:43:11'),
('e2385c3709198e1698e0c93a4f45c7b7', NULL, NULL, NULL, NULL, '90.180.55.48', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '_csrf|s:64:\"6e154ac9142e4d83a1a89e9ce863174656a8937810b9f0d5656ba3b0b11b4e70\";actor|a:7:{s:4:\"type\";s:6:\"seller\";s:2:\"id\";i:1;s:4:\"name\";s:5:\"Karel\";s:4:\"role\";s:6:\"seller\";s:9:\"tenant_id\";i:1;s:10:\"station_id\";N;s:8:\"login_at\";i:1780308727;}', 1780331729, '2026-06-01 10:12:07'),
('e88c37ca747198b6016a7a97c65ad275', NULL, NULL, NULL, NULL, '90.180.55.48', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/30.0 Chrome/143.0.0.0 Mobile Safari/537.36', '_csrf|s:64:\"35fbd43b3b0d8a17ba047ba7a9c8824452d30e2be5dc808893b4595cb318206e\";', 1780250264, '2026-05-31 17:57:23');

-- --------------------------------------------------------

--
-- Struktura tabulky `stations`
--

CREATE TABLE `stations` (
  `id` int(10) UNSIGNED NOT NULL,
  `tenant_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(120) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `phone` varchar(40) DEFAULT NULL,
  `hours` varchar(190) DEFAULT NULL,
  `status` enum('active','inactive','archived') NOT NULL DEFAULT 'active',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabulky `tenants`
--

CREATE TABLE `tenants` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `login_email` varchar(190) NOT NULL,
  `voucher_footer` varchar(255) DEFAULT NULL,
  `default_station_id` int(10) UNSIGNED DEFAULT NULL,
  `status` enum('active','inactive','archived') NOT NULL DEFAULT 'active',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Vypisuji data pro tabulku `tenants`
--

INSERT INTO `tenants` (`id`, `name`, `login_email`, `voucher_footer`, `default_station_id`, `status`, `created_at`, `updated_at`) VALUES
(1, 'PTI', 'info@prague-tourism.com', 'YOUR SALE: PTI', NULL, 'active', '2026-05-31 16:40:47', '2026-05-31 16:40:47'),
(2, 'Hotel U Šuterů', 'hotel@usuteru.com', 'YOUR SALE: Hotel U Šuterů', NULL, 'active', '2026-05-31 16:40:47', '2026-05-31 16:40:47');

-- --------------------------------------------------------

--
-- Struktura tabulky `vouchers`
--

CREATE TABLE `vouchers` (
  `id` int(10) UNSIGNED NOT NULL,
  `sale_id` int(10) UNSIGNED NOT NULL,
  `language` enum('cs','en','de') NOT NULL DEFAULT 'en',
  `language_secondary` enum('cs','en','de') DEFAULT NULL,
  `page_count` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `pdf_path` varchar(255) DEFAULT NULL,
  `status` enum('issued','voided','reissued') NOT NULL DEFAULT 'issued',
  `reissue_of` int(10) UNSIGNED DEFAULT NULL,
  `generated_at` timestamp NULL DEFAULT NULL,
  `printed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Vypisuji data pro tabulku `vouchers`
--

INSERT INTO `vouchers` (`id`, `sale_id`, `language`, `language_secondary`, `page_count`, `pdf_path`, `status`, `reissue_of`, `generated_at`, `printed_at`, `created_at`) VALUES
(1, 1, 'en', NULL, 1, NULL, 'issued', NULL, '2026-06-01 17:45:37', NULL, '2026-06-01 17:45:37'),
(2, 2, 'en', NULL, 1, NULL, 'issued', NULL, '2026-06-01 17:54:43', NULL, '2026-06-01 17:54:43'),
(3, 3, 'en', NULL, 1, NULL, 'issued', NULL, '2026-06-01 17:57:20', NULL, '2026-06-01 17:57:20'),
(4, 4, 'en', NULL, 1, NULL, 'issued', NULL, '2026-06-01 19:54:32', NULL, '2026-06-01 19:54:32'),
(5, 5, 'en', NULL, 1, NULL, 'issued', NULL, '2026-06-01 20:00:51', NULL, '2026-06-01 20:00:51'),
(6, 6, 'en', NULL, 1, NULL, 'issued', NULL, '2026-06-01 20:04:25', NULL, '2026-06-01 20:04:25'),
(7, 7, 'en', NULL, 1, NULL, 'issued', NULL, '2026-06-01 20:06:40', NULL, '2026-06-01 20:06:40'),
(8, 8, 'en', NULL, 1, NULL, 'issued', NULL, '2026-06-01 21:12:52', NULL, '2026-06-01 21:12:52'),
(9, 9, 'en', NULL, 1, NULL, 'issued', NULL, '2026-06-02 13:20:12', NULL, '2026-06-02 13:20:12'),
(10, 10, 'en', NULL, 1, NULL, 'issued', NULL, '2026-06-02 15:13:28', NULL, '2026-06-02 15:13:28'),
(11, 11, 'en', NULL, 1, NULL, 'issued', NULL, '2026-06-02 16:15:54', NULL, '2026-06-02 16:15:54'),
(12, 12, 'en', NULL, 1, NULL, 'issued', NULL, '2026-06-02 17:17:12', NULL, '2026-06-02 17:17:12'),
(13, 13, 'en', NULL, 1, NULL, 'voided', NULL, '2026-06-02 17:21:50', NULL, '2026-06-02 17:21:50'),
(14, 14, 'en', NULL, 1, NULL, 'issued', NULL, '2026-06-02 17:24:56', NULL, '2026-06-02 17:24:56'),
(15, 15, 'en', NULL, 1, NULL, 'issued', NULL, '2026-06-02 17:26:06', NULL, '2026-06-02 17:26:06'),
(16, 16, 'en', NULL, 1, NULL, 'issued', NULL, '2026-06-02 17:27:35', NULL, '2026-06-02 17:27:35'),
(17, 17, 'en', NULL, 1, NULL, 'issued', NULL, '2026-06-02 18:15:50', NULL, '2026-06-02 18:15:50'),
(18, 18, 'en', NULL, 1, NULL, 'issued', NULL, '2026-06-02 18:35:21', NULL, '2026-06-02 18:35:21'),
(19, 19, 'en', NULL, 1, NULL, 'issued', NULL, '2026-06-02 18:45:54', NULL, '2026-06-02 18:45:54'),
(20, 20, 'en', NULL, 1, NULL, 'issued', NULL, '2026-06-02 18:58:07', NULL, '2026-06-02 18:58:07'),
(21, 21, 'en', NULL, 1, NULL, 'issued', NULL, '2026-06-02 19:02:32', NULL, '2026-06-02 19:02:32'),
(22, 22, 'en', NULL, 1, NULL, 'issued', NULL, '2026-06-02 19:06:27', NULL, '2026-06-02 19:06:27'),
(23, 23, 'en', NULL, 1, NULL, 'issued', NULL, '2026-06-02 20:04:29', NULL, '2026-06-02 20:04:29');

-- --------------------------------------------------------

--
-- Struktura tabulky `voucher_counters`
--

CREATE TABLE `voucher_counters` (
  `tenant_id` int(10) UNSIGNED NOT NULL,
  `year` smallint(5) UNSIGNED NOT NULL,
  `last_seq` int(10) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Vypisuji data pro tabulku `voucher_counters`
--

INSERT INTO `voucher_counters` (`tenant_id`, `year`, `last_seq`) VALUES
(0, 2026, 23);

--
-- Indexy pro exportované tabulky
--

--
-- Indexy pro tabulku `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_admins_email` (`email`),
  ADD KEY `idx_admins_home_tenant` (`home_tenant_id`);

--
-- Indexy pro tabulku `admin_recovery_codes`
--
ALTER TABLE `admin_recovery_codes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_recovery_admin` (`admin_id`);

--
-- Indexy pro tabulku `agencies`
--
ALTER TABLE `agencies`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_agencies_status` (`status`);

--
-- Indexy pro tabulku `audit_log`
--
ALTER TABLE `audit_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_audit_actor` (`actor_type`,`actor_id`),
  ADD KEY `idx_audit_target` (`target_type`,`target_id`),
  ADD KEY `idx_audit_created` (`created_at`);

--
-- Indexy pro tabulku `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_categories_name_cs` (`name_cs`),
  ADD KEY `idx_categories_sort` (`sort_order`);

--
-- Indexy pro tabulku `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id`);

--
-- Indexy pro tabulku `login_attempts`
--
ALTER TABLE `login_attempts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_attempts_lookup` (`scope`,`identifier`,`attempted_at`);

--
-- Indexy pro tabulku `pickups`
--
ALTER TABLE `pickups`
  ADD PRIMARY KEY (`id`),
  ADD KEY `k_item` (`sale_item_id`);

--
-- Indexy pro tabulku `prices`
--
ALTER TABLE `prices`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_price_cell` (`pricing_version_id`,`cell_key`);

--
-- Indexy pro tabulku `pricing_dimensions`
--
ALTER TABLE `pricing_dimensions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_pd_product` (`product_id`);

--
-- Indexy pro tabulku `pricing_versions`
--
ALTER TABLE `pricing_versions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_pv_product` (`product_id`),
  ADD KEY `idx_pv_status` (`status`);

--
-- Indexy pro tabulku `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_products_agency` (`agency_id`),
  ADD KEY `idx_products_status` (`status`);

--
-- Indexy pro tabulku `product_categories`
--
ALTER TABLE `product_categories`
  ADD PRIMARY KEY (`product_id`,`category_id`),
  ADD KEY `idx_pc_category` (`category_id`);

--
-- Indexy pro tabulku `product_schedules`
--
ALTER TABLE `product_schedules`
  ADD PRIMARY KEY (`id`),
  ADD KEY `k_ps_product` (`product_id`);

--
-- Indexy pro tabulku `refunds`
--
ALTER TABLE `refunds`
  ADD PRIMARY KEY (`id`),
  ADD KEY `k_sale` (`sale_id`);

--
-- Indexy pro tabulku `sales`
--
ALTER TABLE `sales`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_voucher_number` (`voucher_number`),
  ADD KEY `k_tenant` (`tenant_id`),
  ADD KEY `k_seller` (`seller_id`),
  ADD KEY `k_status` (`status`);

--
-- Indexy pro tabulku `sale_items`
--
ALTER TABLE `sale_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `k_sale` (`sale_id`);

--
-- Indexy pro tabulku `schema_migrations`
--
ALTER TABLE `schema_migrations`
  ADD PRIMARY KEY (`version`);

--
-- Indexy pro tabulku `sellers`
--
ALTER TABLE `sellers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_sellers_tenant` (`tenant_id`),
  ADD KEY `idx_sellers_status` (`status`);

--
-- Indexy pro tabulku `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_sessions_last_activity` (`last_activity`),
  ADD KEY `idx_sessions_actor` (`actor_type`,`actor_id`);

--
-- Indexy pro tabulku `stations`
--
ALTER TABLE `stations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_stations_tenant` (`tenant_id`);

--
-- Indexy pro tabulku `tenants`
--
ALTER TABLE `tenants`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_tenants_login_email` (`login_email`);

--
-- Indexy pro tabulku `vouchers`
--
ALTER TABLE `vouchers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `k_sale` (`sale_id`);

--
-- Indexy pro tabulku `voucher_counters`
--
ALTER TABLE `voucher_counters`
  ADD PRIMARY KEY (`tenant_id`,`year`);

--
-- AUTO_INCREMENT pro tabulky
--

--
-- AUTO_INCREMENT pro tabulku `admins`
--
ALTER TABLE `admins`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pro tabulku `admin_recovery_codes`
--
ALTER TABLE `admin_recovery_codes`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT pro tabulku `agencies`
--
ALTER TABLE `agencies`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT pro tabulku `audit_log`
--
ALTER TABLE `audit_log`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT pro tabulku `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT pro tabulku `customers`
--
ALTER TABLE `customers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT pro tabulku `login_attempts`
--
ALTER TABLE `login_attempts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT pro tabulku `pickups`
--
ALTER TABLE `pickups`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pro tabulku `prices`
--
ALTER TABLE `prices`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=744;

--
-- AUTO_INCREMENT pro tabulku `pricing_dimensions`
--
ALTER TABLE `pricing_dimensions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=239;

--
-- AUTO_INCREMENT pro tabulku `pricing_versions`
--
ALTER TABLE `pricing_versions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=246;

--
-- AUTO_INCREMENT pro tabulku `products`
--
ALTER TABLE `products`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=143;

--
-- AUTO_INCREMENT pro tabulku `product_schedules`
--
ALTER TABLE `product_schedules`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT pro tabulku `refunds`
--
ALTER TABLE `refunds`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pro tabulku `sales`
--
ALTER TABLE `sales`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT pro tabulku `sale_items`
--
ALTER TABLE `sale_items`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT pro tabulku `sellers`
--
ALTER TABLE `sellers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pro tabulku `stations`
--
ALTER TABLE `stations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pro tabulku `tenants`
--
ALTER TABLE `tenants`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pro tabulku `vouchers`
--
ALTER TABLE `vouchers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- Omezení pro exportované tabulky
--

--
-- Omezení pro tabulku `admins`
--
ALTER TABLE `admins`
  ADD CONSTRAINT `fk_admins_home_tenant` FOREIGN KEY (`home_tenant_id`) REFERENCES `tenants` (`id`);

--
-- Omezení pro tabulku `admin_recovery_codes`
--
ALTER TABLE `admin_recovery_codes`
  ADD CONSTRAINT `fk_recovery_admin` FOREIGN KEY (`admin_id`) REFERENCES `admins` (`id`);

--
-- Omezení pro tabulku `prices`
--
ALTER TABLE `prices`
  ADD CONSTRAINT `fk_price_version` FOREIGN KEY (`pricing_version_id`) REFERENCES `pricing_versions` (`id`);

--
-- Omezení pro tabulku `pricing_dimensions`
--
ALTER TABLE `pricing_dimensions`
  ADD CONSTRAINT `fk_pd_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

--
-- Omezení pro tabulku `pricing_versions`
--
ALTER TABLE `pricing_versions`
  ADD CONSTRAINT `fk_pv_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

--
-- Omezení pro tabulku `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `fk_products_agency` FOREIGN KEY (`agency_id`) REFERENCES `agencies` (`id`);

--
-- Omezení pro tabulku `product_categories`
--
ALTER TABLE `product_categories`
  ADD CONSTRAINT `fk_pc_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`),
  ADD CONSTRAINT `fk_pc_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

--
-- Omezení pro tabulku `sellers`
--
ALTER TABLE `sellers`
  ADD CONSTRAINT `fk_sellers_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`);

--
-- Omezení pro tabulku `stations`
--
ALTER TABLE `stations`
  ADD CONSTRAINT `fk_stations_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

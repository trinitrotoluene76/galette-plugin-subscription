-- Objet: Fichier d'installation des tables du plugin Subscription
-- https://github.com/trinitrotoluene76/galette-plugin-subcription
-- fichier: subscription_tables.sql
-- détails: ce fichier est à placer dans le répertoire "scripts" du plugin subscription. 
-- 			Prérequis: avoir installé galette et éxécuté le fichier de configuration "galette_amaury_config_0.8.x_170129.sql" avant
-- 			Il faut le renommer en "mysql.sql" et cliquer sur le bouton bdd (configuration/plugin) pour qu'il soit pris en compte
--			Installation des tables du plugin et des contraintes.
--
-- Auteur: Amaury Froment
-- Généré le :  29/01/17
-- Version du serveur :  5.6.17
-- Version de PHP :  5.5.12

SET FOREIGN_KEY_CHECKS=0;

--
-- Table structure for table `galette_subscription_activities`
--

DROP TABLE IF EXISTS `galette_subscription_activities`;

CREATE TABLE `galette_subscription_activities` (
  `id_group` int(10) NOT NULL DEFAULT '0',
  `price1` decimal(15,2) unsigned DEFAULT '0.00',
  `price2` decimal(15,2) unsigned DEFAULT '0.00',
  `lieu` text COLLATE utf8_unicode_ci NOT NULL,
  `jours` text COLLATE utf8_unicode_ci NOT NULL,
  `horaires` text COLLATE utf8_unicode_ci,
  `renseignements` text COLLATE utf8_unicode_ci,
  `complet` int(10) DEFAULT NULL,
  `autovalidation` int(10) DEFAULT NULL,
  PRIMARY KEY (`id_group`),
  CONSTRAINT `galette_subscription_activities_ibfk_1` FOREIGN KEY (`id_group`) REFERENCES `galette_groups` (`id_group`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


--
-- Table structure for table `galette_subscription_files`
--

DROP TABLE IF EXISTS `galette_subscription_files`;

CREATE TABLE `galette_subscription_files` (
  `id_doc` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_act` int(10) DEFAULT NULL,
  `id_adh` int(10) unsigned DEFAULT NULL,
  `id_abn` int(10) unsigned DEFAULT NULL,
  `doc_name` varchar(200) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `description` text COLLATE utf8_unicode_ci,
  `emplacement` varchar(200) COLLATE utf8_unicode_ci DEFAULT '',
  `date_record` date NOT NULL DEFAULT '1901-01-01',
  `vierge` int(10) DEFAULT NULL,
  `return_file` int(10) DEFAULT NULL,
  PRIMARY KEY (`id_doc`),
  KEY `galette_subscription_files_ibfk_1` (`id_act`),
  KEY `galette_subscription_files_ibfk_2` (`id_adh`),
  KEY `galette_subscription_files_ibfk_3` (`id_abn`),
  CONSTRAINT `galette_subscription_files_ibfk_1` FOREIGN KEY (`id_act`) REFERENCES `galette_groups` (`id_group`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `galette_subscription_files_ibfk_2` FOREIGN KEY (`id_adh`) REFERENCES `galette_adherents` (`id_adh`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `galette_subscription_files_ibfk_3` FOREIGN KEY (`id_abn`) REFERENCES `galette_subscription_subscriptions` (`id_abn`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



--
-- Table structure for table `galette_subscription_followup`
--

DROP TABLE IF EXISTS `galette_subscription_followup`;

CREATE TABLE `galette_subscription_followup` (
  `id_act` int(10) NOT NULL,
  `id_adh` int(10) unsigned NOT NULL,
  `id_abn` int(10) unsigned NOT NULL,
  `statut_act` int(10) unsigned DEFAULT '0',
  `feedback_act` text COLLATE utf8_unicode_ci,
  `message_adh_act` text COLLATE utf8_unicode_ci,
  `feedback_act_off` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id_act`,`id_adh`,`id_abn`),
  KEY `id_adh` (`id_adh`),
  KEY `id_abn` (`id_abn`),
  CONSTRAINT `galette_subscription_followup_ibfk_1` FOREIGN KEY (`id_act`) REFERENCES `galette_groups` (`id_group`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `galette_subscription_followup_ibfk_2` FOREIGN KEY (`id_adh`) REFERENCES `galette_adherents` (`id_adh`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `galette_subscription_followup_ibfk_3` FOREIGN KEY (`id_abn`) REFERENCES `galette_subscription_subscriptions` (`id_abn`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



--
-- Table structure for table `galette_subscription_subscriptions`
--

DROP TABLE IF EXISTS `galette_subscription_subscriptions`;

CREATE TABLE `galette_subscription_subscriptions` (
  `id_abn` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_adh` int(10) unsigned NOT NULL,
  `date_demande` date NOT NULL DEFAULT '1901-01-01',
  `total_estimme` decimal(15,2) unsigned DEFAULT '0.00',
  `message_abn` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id_abn`),
  KEY `id_adh` (`id_adh`),
  CONSTRAINT `galette_subscription_subscriptions_ibfk_1` FOREIGN KEY (`id_adh`) REFERENCES `galette_adherents` (`id_adh`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


	
SET FOREIGN_KEY_CHECKS=1;

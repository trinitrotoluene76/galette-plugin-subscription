-- Objet: Fichier d'installation de la bdd du plugin subscription
-- https://github.com/trinitrotoluene76/galette-plugin-subcription
-- fichier: mysql.sql
-- détails: ce fichier est à placer dans le répertoire "scripts" du plugin subscription. 
-- 			Il faut le renommer en "mysql.sql" et cliquer sur le bouton bdd (configuration/plugin) pour qu'il soit pris en compte
--			ce fichier est un copier coller des fichiers:
--				galette_amaury_config_0.8.x.sql
--				subscription_tables.sql
--				bdd_test_sql_0.8.x.sql
--
-- Auteur: Amaury Froment
-- Généré le :  29/01/17
-- Version du serveur :  5.6.17
-- Version de PHP :  5.5.12

-- Objet: Fichier de configuration pour que Galette fonctionne avec le plugin Subscription
-- https://github.com/trinitrotoluene76/galette-plugin-subcription
-- fichier: galette_amaury_config_0.8.x_170129.sql
-- détails: ce fichier est à placer dans le répertoire "scripts" du plugin subscription. 
-- 			Il faut le renommer en "mysql.sql" et cliquer sur le bouton bdd (configuration/plugin) pour qu'il soit pris en compte
--			C'est la configuration minimale de galette (version officielle) pour ne pas rencontrer de soucis. Nécessite galette 0.8.3.3 minimum
--
-- Auteur: Amaury Froment
-- Généré le :  29/01/17
-- Version du serveur :  5.6.17
-- Version de PHP :  5.5.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

-- --------------------------------------------------------

--
-- Structure de la table `galette_fields_config`
--

CREATE TABLE IF NOT EXISTS `galette_fields_config` (
  `table_name` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  `field_id` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  `required` tinyint(1) NOT NULL,
  `visible` tinyint(1) NOT NULL,
  `position` int(2) NOT NULL,
  `id_field_category` int(2) NOT NULL,
  PRIMARY KEY (`table_name`,`field_id`),
  KEY `id_field_category` (`id_field_category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Contenu de la table `galette_fields_config`
-- Ces champs sont utilisés par le plugin (vérifications de doublons mail, date de naissance erronnée, privilèges suivant le statut...)
UPDATE `galette_fields_config` SET `required` = '0', `visible` = '2', `position`='6', `id_field_category`='2'WHERE `galette_fields_config`.`field_id` = 'date_modif_adh';
UPDATE `galette_fields_config` SET `required` = '1', `visible` = '1', `position`='5', `id_field_category`='1'WHERE `galette_fields_config`.`field_id` = 'ddn_adh';
UPDATE `galette_fields_config` SET `required` = '1', `visible` = '1', `position`='7', `id_field_category`='3'WHERE `galette_fields_config`.`field_id` = 'email_adh';
UPDATE `galette_fields_config` SET `required` = '0', `visible` = '2', `position`='0', `id_field_category`='2'WHERE `galette_fields_config`.`field_id` = 'id_statut';
UPDATE `galette_fields_config` SET `required` = '1', `visible` = '1', `position`='3', `id_field_category`='2'WHERE `galette_fields_config`.`field_id` = 'login_adh';
UPDATE `galette_fields_config` SET `required` = '1', `visible` = '1', `position`='4', `id_field_category`='2'WHERE `galette_fields_config`.`field_id` = 'mdp_adh';
UPDATE `galette_fields_config` SET `required` = '1', `visible` = '1', `position`='0', `id_field_category`='1'WHERE `galette_fields_config`.`field_id` = 'nom_adh';
UPDATE `galette_fields_config` SET `required` = '1', `visible` = '1', `position`='1', `id_field_category`='1'WHERE `galette_fields_config`.`field_id` = 'prenom_adh';

-- --------------------------------------------------------

--
-- Structure de la table `galette_field_contents_5`
--

CREATE TABLE IF NOT EXISTS `galette_field_contents_5` (
  `id` int(11) NOT NULL,
  `val` varchar(55) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Contenu de la table `galette_field_contents_5`
-- Nécessaire à la gestion des tarifs par le plugin

INSERT INTO `galette_field_contents_5` (`id`, `val`) VALUES
(0, 'Personnel Nexter ou conjoint'),
(1, 'Famille Nexter (enfant)'),
(2, 'Assistance technique, intérimaire, stagiaire, TNS MArs'),
(3, 'Retraité Nexter ou conjoint'),
(4, 'Base de Soutien ou famille (civil ou militaire)'),
(5, 'Extérieur');

-- --------------------------------------------------------

--
-- Structure de la table `galette_field_types`
--

CREATE TABLE IF NOT EXISTS `galette_field_types` (
  `field_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `field_form` varchar(10) COLLATE utf8_unicode_ci NOT NULL,
  `field_index` int(10) NOT NULL DEFAULT '0',
  `field_name` varchar(40) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `field_perm` int(10) NOT NULL DEFAULT '0',
  `field_type` int(10) NOT NULL DEFAULT '0',
  `field_required` tinyint(1) NOT NULL DEFAULT '0',
  `field_pos` int(10) NOT NULL DEFAULT '0',
  `field_width` int(10) DEFAULT NULL,
  `field_height` int(10) DEFAULT NULL,
  `field_size` int(10) DEFAULT NULL,
  `field_repeat` int(10) DEFAULT NULL,
  `field_layout` int(10) DEFAULT NULL,
  PRIMARY KEY (`field_id`),
  KEY `field_form` (`field_form`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=17 ;

--
-- Contenu de la table `galette_field_types`
--

INSERT INTO `galette_field_types` (`field_id`, `field_form`, `field_index`, `field_name`, `field_perm`, `field_type`, `field_required`, `field_pos`, `field_width`, `field_height`, `field_size`, `field_repeat`, `field_layout`) VALUES
(5, 'adh', 1, 'Appartenance', 0, 3, 1, 0, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `galette_groups`
--

CREATE TABLE IF NOT EXISTS `galette_groups` (
  `id_group` int(10) NOT NULL AUTO_INCREMENT,
  `group_name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `creation_date` datetime NOT NULL,
  `parent_group` int(10) DEFAULT NULL,
  PRIMARY KEY (`id_group`),
  UNIQUE KEY `name` (`group_name`),
  KEY `parent_group` (`parent_group`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=29 ;

--
-- Contenu de la table `galette_groups`
--

INSERT INTO `galette_groups` (`id_group`, `group_name`, `creation_date`, `parent_group`) VALUES
(5, 'Mon groupe parent', '2014-03-28 19:31:28', NULL),
(6, 'Groupe 1', '2014-03-28 19:37:40', 5),
(7, 'Groupe 2', '2014-03-28 19:37:59', 5);

-- --------------------------------------------------------

--
-- Structure de la table `galette_statuts`
--

CREATE TABLE IF NOT EXISTS `galette_statuts` (
  `id_statut` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `libelle_statut` varchar(20) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `priorite_statut` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_statut`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=18 ;

--
-- Contenu de la table `galette_statuts`
-- Ajout du responsable de section/ de groupe
DELETE FROM `galette_statuts` WHERE `galette_statuts`.`id_statut` = 1;
DELETE FROM `galette_statuts` WHERE `galette_statuts`.`id_statut` = 2;
DELETE FROM `galette_statuts` WHERE `galette_statuts`.`id_statut` = 3;
DELETE FROM `galette_statuts` WHERE `galette_statuts`.`id_statut` = 4;
DELETE FROM `galette_statuts` WHERE `galette_statuts`.`id_statut` = 5;
DELETE FROM `galette_statuts` WHERE `galette_statuts`.`id_statut` = 6;
DELETE FROM `galette_statuts` WHERE `galette_statuts`.`id_statut` = 7;
DELETE FROM `galette_statuts` WHERE `galette_statuts`.`id_statut` = 8;
DELETE FROM `galette_statuts` WHERE `galette_statuts`.`id_statut` = 9;
DELETE FROM `galette_statuts` WHERE `galette_statuts`.`id_statut` = 10;

INSERT INTO `galette_statuts` (`id_statut`, `libelle_statut`, `priorite_statut`) VALUES
(1, 'President', 0),
(2, 'Treasurer', 10),
(3, 'Secretary', 20),
(4, 'Active member', 30),
(7, 'Old-timer', 60),
(9, 'Non-member', 80),
(10, 'Vice-president', 5),
(11, 'Trésorier adjoint', 10),
(12, 'Encadrant', 99),
(13, 'Membre d''honneur', 99),
(14, 'Responsable section', 99),
(16, 'Secrétaire adjoint', 20);

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
  `price3` decimal(15,2) unsigned DEFAULT '0.00',
  `price4` decimal(15,2) unsigned DEFAULT '0.00',
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

-- Objet: Fichier permettant d'avoir un exemple de 3 personnes
-- https://github.com/trinitrotoluene76/galette-plugin-subcription
-- fichier: bdd_test_sql_0.8.x.sql
-- détails: ce fichier est à placer dans le répertoire "scripts" du plugin subscription. 
-- 			Prérequis: avoir installé galette et éxécuté le fichier de configuration "galette_amaury_config_0.8.x_170129.sql" +"subscription_tables.sql" avant
-- 			Il faut le renommer en "mysql.sql" et cliquer sur le bouton bdd (configuration/plugin) pour qu'il soit pris en compte
--			Hydratation de la base de donnée avec un président, 2 responsables de section/groupes
--				président: login president mdp président
--				responsable de sous groupe: login responsable1 mot de passe: responsable1
--				responsable de sous groupe: login responsable2 mot de passe: responsable2
--
-- Auteur: Amaury Froment
-- Généré le :  29/01/17
-- Version du serveur :  5.6.17
-- Version de PHP :  5.5.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

-- --------------------------------------------------------
--
-- Contenu de la table `galette_adherents`
--

INSERT INTO `galette_adherents` (`id_adh`, `id_statut`, `nom_adh`, `prenom_adh`, `pseudo_adh`, `societe_adh`, `titre_adh`, `ddn_adh`, `sexe_adh`, `adresse_adh`, `adresse2_adh`, `cp_adh`, `ville_adh`, `pays_adh`, `tel_adh`, `gsm_adh`, `email_adh`, `url_adh`, `icq_adh`, `msn_adh`, `jabber_adh`, `info_adh`, `info_public_adh`, `prof_adh`, `login_adh`, `mdp_adh`, `date_crea_adh`, `date_modif_adh`, `activite_adh`, `bool_admin_adh`, `bool_exempt_adh`, `bool_display_info`, `date_echeance`, `pref_lang`, `lieu_naissance`, `gpgid`, `fingerprint`) VALUES
(9, 1, 'nm_president', 'pr_president', '', '', NULL, '1959-12-28', 1, '13 ruexxxx', '', '58963', 'Maurepas', '', '', '', 'fcfgdg@gmail.fr', '', '', '', '', '', '', '', 'president', '$2y$10$5w/I8dxnpNL6fwedezahKeezmaTJE9MU1WGFUJXVYkokxjiL21mBO', '2014-03-28', '2015-09-14', 1, 1, 0, 1, NULL, 'fr_FR', 'xxx', '', ''),
(10, 14, 'Smith2', 'John2', '', '', NULL, '1968-04-18', 1, '1 bis xxxxx', '', '54236', 'cccc', '', '', '', 'dfdf@gmail.fr', '', '', '', '', '', '', 'Ingénieur', 'responsable2', '$2y$10$LVUc2Sc68p2sAVJrQsjnBu/6mpR0Q7zHKZUO9jKfDwyiIkLnOnsha', '2014-06-02', '2015-09-14', 1, 0, 0, 0, NULL, 'fr_FR', 'xxxx', '', ''),
(11, 14, 'Smith', 'John', '', '', NULL, '1956-07-05', 1, '6 route xxxx', '', '59648', 'xxx', '', '', '', 'xfgf@club-internet.fr', '', '', '', '', '', '', 'assistant', 'responsable1', '$2y$10$s9pu9yMmuQ2A9c9v0wlL9.IdZGA.bFDgmBxxe9sLbndTCQUAEFyYW', '2014-06-02', '2015-09-14', 1, 0, 0, 0, NULL, 'fr_FR', 'england', '', '');

-- --------------------------------------------------------
--
-- Contenu de la table `galette_groups_managers`
--

INSERT INTO `galette_groups_managers` (`id_group`, `id_adh`) VALUES
(5, 9),
(7, 10),
(6, 11);

-- --------------------------------------------------------
--
-- Contenu de la table `galette_subscription_activities`
--

INSERT INTO `galette_subscription_activities` (`id_group`, `price1`, `price2`, `price3`, `price4`, `lieu`, `jours`, `horaires`, `renseignements`, `complet`, `autovalidation`) VALUES
(5, '22.00', '11.00', '22.00', '27.00', '', '', '', 'Obligatoire pour toute adhésion lors d\'une première activité et pour les tournois inter services.\r\nPaiement de l\'adhésion AS à  faire avec une des autres sections sélectionnées.\r\nPar contre le paiement des adhésions des sections se fait auprès de chaque responsable de section avec un paiement séparé.', 0, 0),
(6, '12.00', '6.00', '12.00', '20.00', 'Gymnase de la base de soutien', 'Lundi midi\r\nMercredi et Jeudi soir\r\nSamedi matin', '11h30 à  13h30\r\n20h00 à  22h00\r\n08h00 à  12h00', 'Pratique en salle de modèle électrique - Initiation à  l\'activité', 0, 0),
(7, '12.00', '6.00', '12.00', '25.00', 'Bâtiment 220', 'Mardi & Vendredi midi', '', 'Répétitions en salle pour travail en pupitre le mardi et en tutti le vendredi', 0, 0);

-- fin du fichier mysql.sql

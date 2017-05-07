-- Objet: Fichier de configuration pour que Galette fonctionne avec le plugin Subscription
-- https://github.com/trinitrotoluene76/galette-plugin-subcription
-- fichier: galette_amaury_config_0.8.x.sql
-- détails: ce fichier est à placer dans le répertoire "scripts" du plugin subscription. 
-- 			Il faut le renommer en "mysql.sql" et cliquer sur le bouton bdd (configuration/plugin) pour qu'il soit pris en compte
--			C'est la configuration minimale de galette (version officielle) pour ne pas rencontrer de soucis. Nécessite galette 0.8.3.3 minimum
--
-- Auteur: Amaury Froment
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


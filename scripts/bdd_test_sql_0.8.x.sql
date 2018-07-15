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

-- Contenu de la table `galette_dynamic_fields` président=nexter, responsable 2=famille nexter, responsable 1=extérieur
INSERT INTO `galette_dynamic_fields` (`item_id`, `field_id`, `field_form`, `val_index`, `field_val`) VALUES
(9, 5, 'adh', 1, 0),
(10, 5,'adh', 1, 1),
(11, 5, 'adh', 1, 5);

-- --------------------------------------------------------
--
-- Contenu de la table `galette_subscription_activities`
--

INSERT INTO `galette_subscription_activities` (`id_group`, `price1`, `price2`, `lieu`, `jours`, `horaires`, `renseignements`, `complet`, `autovalidation`) VALUES
(5, '22.00', '11.00', '', '', '', 'Obligatoire pour toute adhésion lors d\'une première activité et pour les tournois inter services.\r\nPaiement de l\'adhésion AS à  faire avec une des autres sections sélectionnées.\r\nPar contre le paiement des adhésions des sections se fait auprès de chaque responsable de section avec un paiement séparé.', 0, 0),
(6, '12.00', '6.00', 'Gymnase de la base de soutien', 'Lundi midi\r\nMercredi et Jeudi soir\r\nSamedi matin', '11h30 à  13h30\r\n20h00 à  22h00\r\n08h00 à  12h00', 'Pratique en salle de modèle électrique - Initiation à  l\'activité', 0, 0),
(7, '12.00', '6.00', 'Bâtiment 220', 'Mardi & Vendredi midi', '', 'Répétitions en salle pour travail en pupitre le mardi et en tutti le vendredi', 0, 0);

-- --------------------------------------------------------
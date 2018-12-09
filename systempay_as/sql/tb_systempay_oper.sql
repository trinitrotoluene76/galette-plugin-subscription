-- phpMyAdmin SQL Dump
-- version 4.7.3
-- https://www.phpmyadmin.net/
--
-- Hôte : mysql51-122.perso
-- Généré le :  ven. 10 août 2018 à 11:00
-- Version du serveur :  5.5.55-0+deb7u1-log
-- Version de PHP :  5.6.36-0+deb8u1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `asnextersql`
--

-- --------------------------------------------------------

--
-- Structure de la table `tb_systempay_oper`
--

CREATE TABLE `tb_systempay_oper` (
  `tsp_ID` int(11) NOT NULL,
  `tsp_Mode_Test_Prod` tinyint(4) NOT NULL,
  `tsp_Signature_Ok` tinyint(1) NOT NULL,
  `tsp_Statut_Transaction` tinyint(4) NOT NULL,
  `tsp_Resultat` tinyint(4) NOT NULL,
  `tsp_Montant` int(11) NOT NULL,
  `tsp_Montant_Effectif` int(11) NOT NULL,
  `tsp_Paiement_Config` tinyint(4) NOT NULL,
  `tsp_Num_Sequence` smallint(6) NOT NULL,
  `tsp_Autorisation` tinyint(4) NOT NULL,
  `tsp_Garantie` tinyint(4) NOT NULL,
  `tsp_Threeds` int(11) NOT NULL,
  `tsp_Delai_Avant_Banque` int(11) NOT NULL,
  `tsp_Mode_Validation` tinyint(4) NOT NULL,
  `tsp_Numero_Transaction` int(11) NOT NULL,
  `tsp_Reference_Commande` varchar(64) NOT NULL,
  `tsp_Date_Heure` date NOT NULL,
  `tsp_Reference_Acheteur` int(11) NOT NULL,
  `tsp_Nom_Acheteur` varchar(63) NOT NULL,
  `tsp_Prenom_Acheteur` varchar(63) NOT NULL,
  `tsp_Email` varchar(150) NOT NULL,
  `tsp_Type` tinyint(4) NOT NULL,
  `tsp_Numero_Autorisation` varchar(6) NOT NULL,
  `tsp_order_info` varchar(256) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Liste des opérations effectruées par SystemPay est analysées';

--
-- Déchargement des données de la table `tb_systempay_oper`
--

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `tb_systempay_oper`
--
ALTER TABLE `tb_systempay_oper`
  ADD PRIMARY KEY (`tsp_ID`),
  ADD UNIQUE KEY `tsp_Numero_Transaction` (`tsp_Numero_Transaction`),
  ADD KEY `tsp_Numero_Transaction_2` (`tsp_Numero_Transaction`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `tb_systempay_oper`
--
ALTER TABLE `tb_systempay_oper`
  MODIFY `tsp_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

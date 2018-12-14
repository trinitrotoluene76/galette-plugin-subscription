-- phpMyAdmin SQL Dump
-- version 4.0.10.20
-- https://www.phpmyadmin.net
--
-- Client: localhost
-- Généré le: Ven 10 Août 2018 à 15:21
-- Version du serveur: 5.1.73
-- Version de PHP: 5.6.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de données: `bdSystemPay`
--

-- --------------------------------------------------------

--
-- Structure de la table `tb_systempay_msg`
--

CREATE TABLE IF NOT EXISTS `tb_systempay_msg` (
  `ID` int(2) NOT NULL DEFAULT '0',
  `Cle_Msg` varchar(45) DEFAULT NULL,
  `Fr` varchar(427) DEFAULT NULL,
  `En` varchar(379) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `Cle_Msg` (`Cle_Msg`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Contenu de la table `tb_systempay_msg`
--

INSERT INTO `tb_systempay_msg` (`ID`, `Cle_Msg`, `fr`, `en`) VALUES
(0, 'MSG_NON_TROUVE', 'Valeur non trouvée', 'Not found value'),
(1, 'MSG_PAIEMENT_ABANDONNE', 'Le paiement a été abandonné par le client. La transaction n’a pas été crée sur la plateforme de paiement et n’est donc pas visible dans le back office marchand.', 'The payment was abandonned by the customer. The transaction was not created on the gateway and therefore is not visible on the merchant back office.'),
(2, 'MSG_PAIEMENT_ACCEPTE', 'Le paiement a été accepté et est en attente de remise en banque.', 'The payment is accepted and is waiting to be cashed.'),
(3, 'MSG_PAIEMENT_ETE_REFUSE', 'Le paiement a été refusé.', 'The payment was refused.'),
(4, 'MSG_TRANSACTION_ATTENTE_VALIDATION_MANUELLE', 'La transaction a été acceptée mais elle est en attente de validation manuelle. C''est à la charge du marchand de valider la transaction pour demander la remise en banque depuis le back office marchand ou par requête web service. La transaction pourra être validée tant que le délai de capture n’a pas été dépassé. Si ce délai est dépassé alors le paiement bascule dans le statut Expiré. Ce statut expiré est définitif.', 'The transaction is accepted but it is waiting to be manually validated. It is on the merchant responsability to validate the transaction in order that it can be cashed from the back office or by web service request. The transaction can be validated as long as the capture delay is not expired. If the delay expires the payment status change to Expired. This status is definitive.'),
(5, 'MSG_TRANSACTION_ATTENTE_AUTORISATION', 'La transaction est en attente d’autorisation. Lors du paiement uniquement un prise d’empreinte a été réalisée car le délai de remise en banque est strictement supérieur à 7 jours. Par défaut la demande d’autorisation pour le montant global sera réalisée à j-2 avant la date de remise en banque.', 'The transaction is waiting for an authorisation. During the payment, just an imprint was made because the capture delay is higher than 7 days. By default the auhorisation demand for the global amount will be made 2 days before the bank deposit date.'),
(6, 'MSG_TRANSACTION_EXPIREE', 'La transaction est expirée. Ce statut est définitif, la transaction ne pourra plus être remisée en banque. Une transaction expire dans le cas d''une transaction créée en validation manuelle ou lorsque le délai de remise en banque (capture delay) dépassé.', 'The transaction expired. This status is definitive, the transaction will not be able to be cashed. A transaction expires when it was created in manual validation or when the capture delay is passed.'),
(7, 'MSG_TRANSACTION_ANNULEE', 'La transaction a été annulée au travers du back office marchand ou par une requête web service. Ce statut est définitif, la transaction ne sera jamais remise en banque.', 'The payment was cancelled through the merchant back offfice or by a web service request. This status is definitive, the transaction will never be cashed.'),
(8, 'MSG_TRANSACTION_ATTENTE_AUTO_VALID', 'La transaction est en attente d’autorisation et en attente de validation manuelle. Lors du paiement uniquement un prise d’empreinte a été réalisée car le délai de remise en banque est strictement supérieur à 7 jours et le type de validation demandé est « validation manuelle ». Ce paiement ne pourra être remis en banque uniquement après une validation du marchand depuis le back office marchand ou par un requête web services.', 'The transaction is waiting for an authorisation and a manual validation. During the payment, just an imprint was made because the capture delay is higher than 7 days and the validation type is « manual validation ». This payment will be able to be cashed only after that the merchant validates it from the back office or by web service request.'),
(9, 'MSG_TRANSACTION_REMISE_BANQUE', 'La transaction a été remise en banque. Ce statut est définitif.', 'The payment was cashed. This status is definitive.'),
(10, 'MSG_PAIEMENT_REALISE_SUCCES', 'Paiement réalisé avec succès.', 'Payment successfully completed.'),
(11, 'MSG_COMMERCANT_CONTACTER_BANQUE_PORTEUR', 'Le commerçant doit contacter la banque du porteur.', 'The merchant must contact the holder’s bank.'),
(12, 'MSG_PAIEMENT_REFUSE', 'Paiement refusé.', 'Payment denied.'),
(13, 'MSG_ANNULE_PAR_LE_CLIENT', 'Paiement annulé par le client.', 'Cancellation by customer.'),
(14, 'MSG_ERREUR_FORMAT_RESULTAT', 'Erreur de format de la requête. A mettre en rapport avec la valorisation du champ vads_extra_result.', 'Request format error. To be linked with the value of the vads_extra_result field.'),
(15, 'MSG_ERREUR_TECHNIQUE', 'Erreur technique lors du paiement.', 'Technical error occurred during payment.'),
(16, 'MSG_PAIEMENT_SIMPLE', 'Paiement simple.', 'Unique Payment.'),
(17, 'MSG_TRANSACTION_APPROUVEE', 'Transaction approuvée ou traitée avec succès.', 'Transaction approved or successfully treated.'),
(18, 'MSG_CONTACTER_EMETTEUR', 'Contacter l’émetteur de carte.', 'Contact the card issuer.'),
(19, 'MSG_ACCEPTEUR_INVALIDE', 'Accepteur_invalide.', 'Invalid acceptor.'),
(20, 'MSG_CONSERVER_CARTE', 'Conserver la carte.', 'Keep the card.'),
(21, 'MSG_NE_PAS_HONORER', 'Ne pas honorer.', 'Do not honor.'),
(22, 'MSG_CONSERVER_CARTE_SPECIAL', 'Conserver la carte, conditions spéciales.', 'Keep the card, special conditions.'),
(23, 'MSG_APPROUVER_APRES_IDENTIFICATION', 'Approuver après identification.', 'Approved after identification.'),
(24, 'MSG_TRANSACTION_INVALIDE', 'Transaction invalide.', 'Invalid Transaction.'),
(25, 'MSG_MONTANT_INVALIDE', 'Montant invalide.', 'Invalid Amount.'),
(26, 'MSG_NUMERO_PORTEUR_INVALIDE', 'Numéro de porteur invalide.', 'Invalid holder number.'),
(27, 'MSG_ERREUR_FORMAT_AUTH', 'Erreur de format.', 'Format error.'),
(28, 'MSG_IDENTIFIANT_ORGANISME', 'Identifiant de l’organisme acquéreur inconnu.', 'Unknown buying organization identifier.'),
(29, 'MSG_DATE_VALIDITE_DEPASSEE', 'Date de validité de la carte dépassée.', 'Expired card validity date.'),
(30, 'MSG_SUSPICION_FRAUDE', 'Suspicion de fraude.', 'Fraud suspected.'),
(31, 'MSG_CARTE_PERDUE', 'Carte perdue.', 'Lost card.'),
(32, 'MSG_CARTE_VOLEE', 'Carte volée.', 'Stolen card.'),
(33, 'MSG_PROVISION_INSUFFISANTE', 'Provision insuffisante ou crédit dépassé.', 'Insufficient provision or exceeds credit.'),
(34, 'MSG_CARTE_ABSENTE', 'Carte absente du fichier.', 'Card not in database.'),
(35, 'MSG_TRANSACTION_NON_PERMISE', 'Transaction non permise à ce porteur.', 'Transaction not allowed for this holder.'),
(36, 'MSG_TRANSACTION_INTERDITE', 'Transaction interdite au terminal.', 'Transaction not allowed from this terminal.'),
(37, 'MSG_DEBIT', 'Débit', 'Debit'),
(38, 'MSG_ACCEPTEUR_DOIT_CONTACTER', 'L’accepteur de carte doit contacter l’acquéreur.', 'The card acceptor must contact buyer.'),
(39, 'MSG_MONTANT_RETRAIT_HORS_LIMITE', 'Montant de retrait hors limite.', 'Amount over withdrawal limits.'),
(40, 'MSG_REGLES_SECURITE_NON_RESPECTEES', 'Règles de sécurité non respectées.', 'Does not abide to security rules.'),
(41, 'MSG_REPONSE_NON_PARVENUE', 'Réponse non parvenue ou reçue trop tard.', 'Response not received or received too late.'),
(42, 'MSG_ARRET_MOMENTANE', 'Arrêt momentané du système.', 'System temporarily stopped.'),
(43, 'MSG_EMETTEUR_INACCESSIBLE', 'Emetteur de cartes inaccessible.', 'Inaccessible card issuer.'),
(44, 'MSG_MAUVAIS_FONCTIONNEMENT', 'Mauvais fonctionnement du système.', 'Faulty system.'),
(45, 'MSG_TRANSACTION_DUPLIQUEE', 'Transaction dupliquée.', 'Duplicated transaction.'),
(46, 'MSG_ECHEANCE_TEMPORISATION', 'Echéance de la temporisation de surveillance globale.', 'Global surveillance time out expired.'),
(47, 'MSG_SERVEUR_INDISPONIBLE', 'Serveur indisponible routage réseau demandé à nouveau.', 'Unavailable server, repeat network routing requested.'),
(48, 'MSG_INCIDENT_DOMAINE_INITIATEUR', 'Incident domaine initiateur.', 'Instigator domain incident.'),
(49, 'MSG_PAIEMENT_GARANTI', 'Le paiement est garanti.', 'Payment is guaranteed.'),
(50, 'MSG_PAIEMENT_NON_GARANTI', 'Le paiement n’est pas garanti.', 'Payment is not guaranteed.'),
(51, 'MSG_SUITE_A_ERREUR', 'Suite à une erreur technique, le paiement ne peut pas être garanti.', 'Payment cannot be guaranteed, due to a technical error.'),
(52, 'MSG_GARANTIE_NON_APPLICABLE', 'Garantie de paiement non applicable.', 'Payment guarantee not applicable.'),
(53, 'MSG_AUTHENTIFIE_3DS', 'Authentifié 3DS.', '3DS Authentified.'),
(54, 'MSG_ERREUR_AUTHENTIFICATION', 'Erreur Authentification.', 'Authentification Error.'),
(55, 'MSG_AUTHENTIFICATION_IMPOSSIBLE', 'Authentification impossible.', 'Authentification Impossible.'),
(56, 'MSG_ESSAI_AUTHENTIFICATION', 'Essai d’authentification.', 'Try to authenticate.'),
(57, 'MSG_NON_RENSEIGNE', 'Non renseigné.', 'Non valued.'),
(58, 'MSG_VALIDATION_MANUELLE', 'Validation Manuelle', 'Manual Validation'),
(59, 'MSG_VALIDATION_AUTOMATIQUE', 'Validation Automatique', 'Automatic Validation'),
(60, 'MSG_CONFIGURATION_DEFAUT_BACK_OFFICE_MARCHAND', 'Configuration par défaut du back office marchand', 'Default configuration of the merchant back office'),
(61, 'MSG_ERREUR_CONFIGURATION_PARA', 'Erreur de configuration. Le fichier conf.txt n''est pas correctement paramétré. Vérifier l''identifiant boutique, votre certificat et l''URL de retour.', 'CONFIGURATION ERROR!</u></b></p><p><b>The conf.txt file is not properly set. Please check your shop ID, your certificate and your return URL.'),
(62, 'MSG_SIGNATURE_VALIDE', 'Signature Valide', 'Valid Signature'),
(63, 'MSG_SIGNATURE_INVALIDE', 'Signature Invalide - ne pas prendre en compte le résultat de ce paiement', 'Invalid Signature - do not take this payment result in account'),
(64, 'MSG_TRANSACTION_DEBIT', 'La transaction est un débit ayant comme caractéristiques', 'The transaction is a debit with the following details'),
(65, 'MSG_STATUT', 'Statut', 'Status'),
(66, 'MSG_RESULTAT', 'Résultat', 'Result'),
(67, 'MSG_IDENTIFIANT', 'Identifiant', 'ID'),
(68, 'MSG_MONTANT', 'Montant', 'Account'),
(69, 'MSG_MONTANT_EFFECTIF', 'Montant Effectif', 'Effective Account'),
(70, 'MSG_TYPE_DE_PAIEMENT', 'Type de paiement', 'Payment Type'),
(71, 'MSG_NUMERO_SEQUENCE', 'Numéro de séquence', 'Sequence Number'),
(72, 'MSG_RESULTAT_AUTORISATION', 'Résultat d''autorisation', 'Authorisation Result'),
(73, 'MSG_GARANTIE_PAIEMENT', 'Garantie de paiement', 'Payment Warranty'),
(74, 'MSG_STATUT_3DS', 'Statut 3DS', 'Statut 3DS'),
(75, 'MSG_DELAI_AVANT_REMISE_EN_BANQUE', 'Délai avant Remise en Banque', 'Capture delay'),
(76, 'MSG_MODE_VALIDATION', 'Mode de Validation', 'Validation Mode'),
(77, 'MSG_REDIRECTION_PLATEFORME', 'Redirection vers la plateforme de paiement', 'Payment gateway redirection'),
(78, 'MSG_TEST', 'Test', 'Test'),
(79, 'MSG_PRODUCTION', 'Production', 'Production'),
(80, 'MSG_REDIRECT_SUCCES', 'Paiement réalisé avec succès. Redirection vers la boutique dans quelques instants.', 'Payment successfully completed.'),
(81, 'MSG_REDIRECT_ERREUR', 'Le paiement a été refusé. Redirection vers le site asnexter.fr dans quelques instants.', 'Payment has been refused. Redirection to the site asnexter.fr');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

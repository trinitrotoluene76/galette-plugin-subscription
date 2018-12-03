-- Objet: création de la table de configuration du module de paiement en ligne
-- fichier à intégrer une fois finalisé dans mysql.sql

-- Auteur: Amaury Froment
-- Version du serveur MySQL:  5.7.21
-- Version de PHP :  7.1.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
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
-- Structure de la table `galette_subscription_config_systempay`
--
DROP TABLE IF EXISTS `galette_subscription_config_systempay`;

CREATE TABLE `galette_subscription_config_systempay` (
  `id_conf` int(10) UNSIGNED NOT NULL,
  `field_name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `field_value` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id_conf`),
  KEY `id_conf` (`id_conf`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

INSERT INTO `galette_subscription_config_systempay` (`id_conf`, `field_name`, `field_value`) VALUES
(1, 'global_enable', 0),
(2, 'vads_ctx_mode', 0),
(3, 'vads_url_check', 'http://my_url_notifier.fr/'),
(4, 'url_payment_systempay', 'http://monsite/galette/plugins/galette-plugin-subscription/systempay/sp_form_paiement.php'),
(5, 'systempay_path', './systempay/');

--
-- Table structure for table `tb_systempay_oper`
--

DROP TABLE IF EXISTS `tb_systempay_oper`;

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
  `tsp_Date_Heure` datetime NOT NULL,
  `tsp_Reference_Acheteur` int(11) NOT NULL,
  `tsp_Nom_Acheteur` varchar(63) NOT NULL,
  `tsp_Prenom_Acheteur` varchar(63) NOT NULL,
  `tsp_Email` varchar(150) NOT NULL,
  `tsp_Type` tinyint(4) NOT NULL,
  `tsp_Numero_Autorisation` varchar(6) NOT NULL,
  `tsp_order_info` varchar(256) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Liste des opérations effectuées par SystemPay et analysées';

--
-- Structure de la table `tb_systempay_msg`
--
DROP TABLE IF EXISTS `tb_systempay_msg`;

CREATE TABLE `tb_systempay_msg` (
  `ID` int(2) NOT NULL DEFAULT '0',
  `Cle_Msg` varchar(45) DEFAULT NULL,
  `fr` varchar(427) DEFAULT NULL,
  `en` varchar(379) DEFAULT NULL,
  `de` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `tb_systempay_msg`
--

INSERT INTO `tb_systempay_msg` (`ID`, `Cle_Msg`, `fr`, `en`, `de`) VALUES
(0, 'MSG_NON_TROUVE', 'Valeur non trouvée', 'Not found value', 'Wert nicht gefunden'),
(1, 'MSG_PAIEMENT_ABANDONNE', 'Le paiement a été abandonné par le client. La transaction n’a pas été crée sur la plateforme de paiement et n’est donc pas visible dans le back office marchand.', 'The payment was abandonned by the customer. The transaction was not created on the gateway and therefore is not visible on the merchant back office.', 'Die Zahlung wurde vom Kunden aufgegeben. Die Transaktion wurde nicht auf der Zahlungsplattform erstellt und ist daher nicht im Händler-Back-Office sichtbar.'),
(2, 'MSG_PAIEMENT_ACCEPTE', 'Le paiement a été accepté et est en attente de remise en banque.', 'The payment is accepted and is waiting to be cashed.', 'Die Zahlung wurde akzeptiert und steht noch aus.'),
(3, 'MSG_PAIEMENT_ETE_REFUSE', 'Le paiement a été refusé.', 'The payment was refused.', 'Zahlung wurde abgelehnt'),
(4, 'MSG_TRANSACTION_ATTENTE_VALIDATION_MANUELLE', 'La transaction a été acceptée mais elle est en attente de validation manuelle. C\'est à la charge du marchand de valider la transaction pour demander la remise en banque depuis le back office marchand ou par requête web service. La transaction pourra être validée tant que le délai de capture n’a pas été dépassé. Si ce délai est dépassé alors le paiement bascule dans le statut Expiré. Ce statut expiré est définitif.', 'The transaction is accepted but it is waiting to be manually validated. It is on the merchant responsability to validate the transaction in order that it can be cashed from the back office or by web service request. The transaction can be validated as long as the capture delay is not expired. If the delay expires the payment status change to Expired. This status is definitive.', 'Die Transaktion wurde akzeptiert, muss jedoch noch manuell validiert werden. Es liegt in der Verantwortung des Händlers, die Transaktion zu bestätigen, um die Bank vom Back-Office-Händler anzufordern oder einen Webservice anzufordern. Die Transaktion kann validiert werden, solange die Erfassungszeit nicht überschritten wurde. Wenn diese Zeit überschritten wird, wechselt die Zahlung in den Status \"Abgelaufen\". Dieser abgelaufene Status ist endgültig.'),
(5, 'MSG_TRANSACTION_ATTENTE_AUTORISATION', 'La transaction est en attente d’autorisation. Lors du paiement uniquement un prise d’empreinte a été réalisée car le délai de remise en banque est strictement supérieur à 7 jours. Par défaut la demande d’autorisation pour le montant global sera réalisée à j-2 avant la date de remise en banque.', 'The transaction is waiting for an authorisation. During the payment, just an imprint was made because the capture delay is higher than 7 days. By default the auhorisation demand for the global amount will be made 2 days before the bank deposit date.', 'Die Transaktion steht noch aus. Bei der Bezahlung wurde nur ein Eindruck gemacht, da die Frist für das Bankgeschäft strikt länger als 7 Tage ist. Standardmäßig erfolgt die Autorisierungsanfrage für den Gesamtbetrag am Tag 2 vor dem Datum der Bankeinzahlung.'),
(6, 'MSG_TRANSACTION_EXPIREE', 'La transaction est expirée. Ce statut est définitif, la transaction ne pourra plus être remisée en banque. Une transaction expire dans le cas d\'une transaction créée en validation manuelle ou lorsque le délai de remise en banque (capture delay) dépassé.', 'The transaction expired. This status is definitive, the transaction will not be able to be cashed. A transaction expires when it was created in manual validation or when the capture delay is passed.', 'Die Transaktion ist abgelaufen. Dieser Status ist endgültig, die Transaktion kann nicht mehr in der Bank gespeichert werden. Eine Transaktion verfällt, wenn eine Transaktion bei der manuellen Validierung erstellt wurde oder die Erfassungsverzögerung abgelaufen ist.'),
(7, 'MSG_TRANSACTION_ANNULEE', 'La transaction a été annulée au travers du back office marchand ou par une requête web service. Ce statut est définitif, la transaction ne sera jamais remise en banque.', 'The payment was cancelled through the merchant back offfice or by a web service request. This status is definitive, the transaction will never be cashed.', 'Die Transaktion wurde über das Back-Office des Händlers oder über eine Webservice-Anfrage abgebrochen. Dieser Status ist endgültig, die Transaktion wird niemals in die Bank gesetzt.'),
(8, 'MSG_TRANSACTION_ATTENTE_AUTO_VALID', 'La transaction est en attente d’autorisation et en attente de validation manuelle. Lors du paiement uniquement un prise d’empreinte a été réalisée car le délai de remise en banque est strictement supérieur à 7 jours et le type de validation demandé est « validation manuelle ». Ce paiement ne pourra être remis en banque uniquement après une validation du marchand depuis le back office marchand ou par un requête web services.', 'The transaction is waiting for an authorisation and a manual validation. During the payment, just an imprint was made because the capture delay is higher than 7 days and the validation type is « manual validation ». This payment will be able to be cashed only after that the merchant validates it from the back office or by web service request.', 'Die Transaktion steht vor der Autorisierung und wartet auf die manuelle Validierung. Beim Bezahlen wurde nur ein Eindruck gemacht, weil die Zeit des Bankierens strikt länger als 7 Tage ist und die Art der Validierung \"manuelle Validierung\" ist. Diese Zahlung kann nur nach einer Bestätigung des Händlers im Backoffice des Händlers oder durch eine Anforderung von Webservices in Bank bezahlt werden.'),
(9, 'MSG_TRANSACTION_REMISE_BANQUE', 'La transaction a été remise en banque. Ce statut est définitif.', 'The payment was cashed. This status is definitive.', 'Die Transaktion wurde abgewickelt. Dieser Status ist endgültig.'),
(10, 'MSG_PAIEMENT_REALISE_SUCCES', 'Paiement réalisé avec succès.', 'Payment successfully completed.', 'Zahlung erfolgreich abgeschlossen'),
(11, 'MSG_COMMERCANT_CONTACTER_BANQUE_PORTEUR', 'Le commerçant doit contacter la banque du porteur.', 'The merchant must contact the holder’s bank.', 'Der Händler muss sich an die Bank des Inhabers wenden.'),
(12, 'MSG_PAIEMENT_REFUSE', 'Paiement refusé.', 'Payment denied.', 'Zahlung abgelehnt.'),
(13, 'MSG_ANNULE_PAR_LE_CLIENT', 'Paiement annulé par le client.', 'Cancellation by customer.', 'Zahlung vom Kunden storniert.'),
(14, 'MSG_ERREUR_FORMAT_RESULTAT', 'Erreur de format de la requête. A mettre en rapport avec la valorisation du champ vads_extra_result.', 'Request format error. To be linked with the value of the vads_extra_result field.', 'Abfrageformatfehler In Verbindung mit der Aufwertung des Feldes vads_extra_result.'),
(15, 'MSG_ERREUR_TECHNIQUE', 'Erreur technique lors du paiement.', 'Technical error occurred during payment.', 'Technischer Fehler während der Zahlung.'),
(16, 'MSG_PAIEMENT_SIMPLE', 'Paiement simple.', 'Unique Payment.', 'Einfache Bezahlung'),
(17, 'MSG_TRANSACTION_APPROUVEE', 'Transaction approuvée ou traitée avec succès.', 'Transaction approved or successfully treated.', 'Transaktion genehmigt oder erfolgreich bearbeitet.'),
(18, 'MSG_CONTACTER_EMETTEUR', 'Contacter l’émetteur de carte.', 'Contact the card issuer.', 'Wenden Sie sich an den Kartenaussteller.'),
(19, 'MSG_ACCEPTEUR_INVALIDE', 'Accepteur_invalide.', 'Invalid acceptor.', 'Accepteur_invalide.'),
(20, 'MSG_CONSERVER_CARTE', 'Conserver la carte.', 'Keep the card.', 'Bewahren Sie die Karte auf.'),
(21, 'MSG_NE_PAS_HONORER', 'Ne pas honorer.', 'Do not honor.', 'Ehre nicht'),
(22, 'MSG_CONSERVER_CARTE_SPECIAL', 'Conserver la carte, conditions spéciales.', 'Keep the card, special conditions.', 'Behalten Sie die Karte, Sonderkonditionen.'),
(23, 'MSG_APPROUVER_APRES_IDENTIFICATION', 'Approuver après identification.', 'Approved after identification.', 'Genehmigen Sie nach der Identifizierung.'),
(24, 'MSG_TRANSACTION_INVALIDE', 'Transaction invalide.', 'Invalid Transaction.', 'Ungültige Transaktion'),
(25, 'MSG_MONTANT_INVALIDE', 'Montant invalide.', 'Invalid Amount.', 'Betrag ungültig'),
(26, 'MSG_NUMERO_PORTEUR_INVALIDE', 'Numéro de porteur invalide.', 'Invalid holder number.', 'Ungültige Frachtführernummer'),
(27, 'MSG_ERREUR_FORMAT_AUTH', 'Erreur de format.', 'Format error.', 'Formatierungsfehler'),
(28, 'MSG_IDENTIFIANT_ORGANISME', 'Identifiant de l’organisme acquéreur inconnu.', 'Unknown buying organization identifier.', 'Kennung der unbekannten erwerbenden Organisation.'),
(29, 'MSG_DATE_VALIDITE_DEPASSEE', 'Date de validité de la carte dépassée.', 'Expired card validity date.', 'Gültigkeitsdatum der Karte überschritten.'),
(30, 'MSG_SUSPICION_FRAUDE', 'Suspicion de fraude.', 'Fraud suspected.', 'Verdacht auf Betrug.'),
(31, 'MSG_CARTE_PERDUE', 'Carte perdue.', 'Lost card.', 'Verlorene Karte'),
(32, 'MSG_CARTE_VOLEE', 'Carte volée.', 'Stolen card.', 'Gestohlene Karte'),
(33, 'MSG_PROVISION_INSUFFISANTE', 'Provision insuffisante ou crédit dépassé.', 'Insufficient provision or exceeds credit.', 'Unzureichende Bereitstellung oder Gutschrift überschritten.'),
(34, 'MSG_CARTE_ABSENTE', 'Carte absente du fichier.', 'Card not in database.', 'Karte nicht in der Datei.'),
(35, 'MSG_TRANSACTION_NON_PERMISE', 'Transaction non permise à ce porteur.', 'Transaction not allowed for this holder.', 'Transaktion für diesen Inhaber nicht zulässig.'),
(36, 'MSG_TRANSACTION_INTERDITE', 'Transaction interdite au terminal.', 'Transaction not allowed from this terminal.', 'Transaktion am Terminal verboten.'),
(37, 'MSG_DEBIT', 'Débit', 'Debit', 'Soll'),
(38, 'MSG_ACCEPTEUR_DOIT_CONTACTER', 'L’accepteur de carte doit contacter l’acquéreur.', 'The card acceptor must contact buyer.', 'Der Kartenakzeptor muss sich an den Erwerber wenden.'),
(39, 'MSG_MONTANT_RETRAIT_HORS_LIMITE', 'Montant de retrait hors limite.', 'Amount over withdrawal limits.', 'Auszahlungsbetrag außerhalb des Limits.'),
(40, 'MSG_REGLES_SECURITE_NON_RESPECTEES', 'Règles de sécurité non respectées.', 'Does not abide to security rules.', 'Sicherheitsregeln nicht beachtet.'),
(41, 'MSG_REPONSE_NON_PARVENUE', 'Réponse non parvenue ou reçue trop tard.', 'Response not received or received too late.', 'Antwort nicht oder zu spät erhalten.'),
(42, 'MSG_ARRET_MOMENTANE', 'Arrêt momentané du système.', 'System temporarily stopped.', 'Kurzzeitiges Herunterfahren des Systems.'),
(43, 'MSG_EMETTEUR_INACCESSIBLE', 'Emetteur de cartes inaccessible.', 'Inaccessible card issuer.', 'Kartenaussteller nicht erreichbar.'),
(44, 'MSG_MAUVAIS_FONCTIONNEMENT', 'Mauvais fonctionnement du système.', 'Faulty system.', 'Fehlfunktion des Systems.'),
(45, 'MSG_TRANSACTION_DUPLIQUEE', 'Transaction dupliquée.', 'Duplicated transaction.', 'Doppelte Transaktion'),
(46, 'MSG_ECHEANCE_TEMPORISATION', 'Echéance de la temporisation de surveillance globale.', 'Global surveillance time out expired.', 'Frist für den globalen Überwachungstimer.'),
(47, 'MSG_SERVEUR_INDISPONIBLE', 'Serveur indisponible routage réseau demandé à nouveau.', 'Unavailable server, repeat network routing requested.', 'Server nicht verfügbares Netzwerkrouting erneut angefordert.'),
(48, 'MSG_INCIDENT_DOMAINE_INITIATEUR', 'Incident domaine initiateur.', 'Instigator domain incident.', 'Incident-Initiator-Domäne'),
(49, 'MSG_PAIEMENT_GARANTI', 'Le paiement est garanti.', 'Payment is guaranteed.', 'Zahlung ist garantiert'),
(50, 'MSG_PAIEMENT_NON_GARANTI', 'Le paiement n’est pas garanti.', 'Payment is not guaranteed.', 'Zahlung ist nicht garantiert.'),
(51, 'MSG_SUITE_A_ERREUR', 'Suite à une erreur technique, le paiement ne peut pas être garanti.', 'Payment cannot be guaranteed, due to a technical error.', 'Aufgrund eines technischen Fehlers kann die Zahlung nicht garantiert werden.'),
(52, 'MSG_GARANTIE_NON_APPLICABLE', 'Garantie de paiement non applicable.', 'Payment guarantee not applicable.', 'Zahlungsgarantie nicht anwendbar.'),
(53, 'MSG_AUTHENTIFIE_3DS', 'Authentifié 3DS.', '3DS Authentified.', 'Authentifizierte 3DS.'),
(54, 'MSG_ERREUR_AUTHENTIFICATION', 'Erreur Authentification.', 'Authentification Error.', 'Authentifizierungsfehler'),
(55, 'MSG_AUTHENTIFICATION_IMPOSSIBLE', 'Authentification impossible.', 'Authentification Impossible.', 'Kann sich nicht authentifizieren.'),
(56, 'MSG_ESSAI_AUTHENTIFICATION', 'Essai d’authentification.', 'Try to authenticate.', 'Authentifizierungstest'),
(57, 'MSG_NON_RENSEIGNE', 'Non renseigné.', 'Non valued.', 'Nicht informiert'),
(58, 'MSG_VALIDATION_MANUELLE', 'Validation Manuelle', 'Manual Validation', 'Manuelle Validierung'),
(59, 'MSG_VALIDATION_AUTOMATIQUE', 'Validation Automatique', 'Automatic Validation', 'Automatische Validierung'),
(60, 'MSG_CONFIGURATION_DEFAUT_BACK_OFFICE_MARCHAND', 'Configuration par défaut du back office marchand', 'Default configuration of the merchant back office', 'Standardkonfiguration des Händler-Backoffice'),
(61, 'MSG_ERREUR_CONFIGURATION_PARA', 'Erreur de configuration. Le fichier conf.txt n\'est pas correctement paramétré. Vérifier l\'identifiant boutique, votre certificat et l\'URL de retour.', 'CONFIGURATION ERROR!</u></b></p><p><b>The conf.txt file is not properly set. Please check your shop ID, your certificate and your return URL.', 'Konfigurationsfehler Die Datei conf.txt ist nicht richtig eingestellt. Überprüfen Sie die Geschäfts-ID, Ihr Zertifikat und die Rückgabe-URL.'),
(62, 'MSG_SIGNATURE_VALIDE', 'Signature Valide', 'Valid Signature', 'Unterschrift gültig'),
(63, 'MSG_SIGNATURE_INVALIDE', 'Signature Invalide - ne pas prendre en compte le résultat de ce paiement', 'Invalid Signature - do not take this payment result in account', 'Unterschrift ungültig - das Ergebnis dieser Zahlung nicht berücksichtigen'),
(64, 'MSG_TRANSACTION_DEBIT', 'La transaction est un débit ayant comme caractéristiques', 'The transaction is a debit with the following details', 'Die Transaktion ist eine Belastung mit Merkmalen'),
(65, 'MSG_STATUT', 'Statut', 'Status', 'Status'),
(66, 'MSG_RESULTAT', 'Résultat', 'Result', 'Ergebnis'),
(67, 'MSG_IDENTIFIANT', 'Identifiant', 'ID', 'Login'),
(68, 'MSG_MONTANT', 'Montant', 'Account', 'Betrag'),
(69, 'MSG_MONTANT_EFFECTIF', 'Montant Effectif', 'Effective Account', 'Effektiver Betrag'),
(70, 'MSG_TYPE_DE_PAIEMENT', 'Type de paiement', 'Payment Type', 'Art der Zahlung'),
(71, 'MSG_NUMERO_SEQUENCE', 'Numéro de séquence', 'Sequence Number', 'Folgenummer'),
(72, 'MSG_RESULTAT_AUTORISATION', 'Résultat d\'autorisation', 'Authorisation Result', 'Autorisierungsergebnis'),
(73, 'MSG_GARANTIE_PAIEMENT', 'Garantie de paiement', 'Payment Warranty', 'Zahlungsgarantie'),
(74, 'MSG_STATUT_3DS', 'Statut 3DS', 'Statut 3DS', '3DS-Status'),
(75, 'MSG_DELAI_AVANT_REMISE_EN_BANQUE', 'Délai avant Remise en Banque', 'Capture delay', 'Frist vor Bankzustellung'),
(76, 'MSG_MODE_VALIDATION', 'Mode de Validation', 'Validation Mode', 'Validierungsmodus'),
(77, 'MSG_REDIRECTION_PLATEFORME', 'Redirection vers la plateforme de paiement', 'Payment gateway redirection', 'Umleitung auf die Zahlungsplattform'),
(78, 'MSG_TEST', 'Test', 'Test', 'Test'),
(79, 'MSG_PRODUCTION', 'Production', 'Production', 'Produktion'),
(80, 'MSG_REDIRECT_SUCCES', 'Paiement réalisé avec succès. Redirection vers la boutique dans quelques instants.', 'Payment successfully completed.', 'Zahlung erfolgreich abgeschlossen In wenigen Augenblicken in den Laden umleiten.'),
(81, 'MSG_REDIRECT_ERREUR', 'Le paiement a été refusé. Redirection vers le site asnexter.fr dans quelques instants.', 'Payment has been refused. Redirection to the site asnexter.fr', 'Zahlung wurde abgelehnt Umleitung zur Site asnexter.fr in wenigen Augenblicken.'),
(82, 'MSG_PRESIGNATURE_VALIDE', 'Pré-Signature valide', 'Valid Pre-Signature', 'Pre-Signature gültig'),
(83, 'MSG_PRESIGNATURE_INVALIDE', 'Pré-Signature Invalide - ne pas prendre en compte la demande de paiement', 'Invalid Pre-Signature - do not take into account the payment request', 'Pre-Signature Invalid - Die Zahlungsanforderung nicht berücksichtigen ');

-- Ajout des tables comptables
-- --------------------------------------------------------

--
-- Structure de la table `cpt_CatCompte`
--
DROP TABLE IF EXISTS `cpt_CatCompte`;

CREATE TABLE `cpt_CatCompte` (
  `cat_ID_CatCompte` int(11) NOT NULL,
  `cat_Chemin_CatCompte` text,
  `cat_Nom_CatCompte` text,
  `cat_Commentaire` text NOT NULL,
  `cat_ID_CatCompte_Parent` int(11) DEFAULT NULL,
  `cat_Raccourcis_CatCompte` text,
  `cat_Nom_CatCompte_Parent` varchar(30) NOT NULL,
  `cat_Type_CatCompte` int(11) DEFAULT NULL,
  `cat_Num_Tag_Associes` int(11) DEFAULT NULL,
  `cat_Niveau` int(11) DEFAULT NULL,
  `cat_Virtuel` int(11) DEFAULT NULL,
  `cat_Visible` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Contient tous les comptes ou catégories.';

--
-- Déchargement des données de la table `cpt_CatCompte`
--

INSERT INTO `cpt_CatCompte` (`cat_ID_CatCompte`, `cat_Chemin_CatCompte`, `cat_Nom_CatCompte`, `cat_Commentaire`, `cat_ID_CatCompte_Parent`, `cat_Raccourcis_CatCompte`, `cat_Nom_CatCompte_Parent`, `cat_Type_CatCompte`, `cat_Num_Tag_Associes`, `cat_Niveau`, `cat_Virtuel`, `cat_Visible`) VALUES
(0, '', 'Inexistant', 'Catégorie inexistante', 0, '0', '0', 0, 0, 0, 0, 0),
(1, '', '0_Racine', 'Racine', 0, '0', '-1', 1, 0, 1, 1, 1),
(2, '', '1_Capitaux propres', 'Capitaux propres', 1, '1', '0', 2, 0, 2, 1, 1),
(3, '', '10_Fonds associatifs et réserves', 'Fonds associatifs et réserves', 2, '10', '1', 2, 0, 3, 1, 1),
(4, '', '102_Fonds associatifs sans droit de reprise', 'Fonds associatifs sans droit de reprise', 3, '102', '10', 2, 0, 4, 0, 1),
(5, '', '11_Éléments en instance d\'affectation', 'Éléments en instance d\'affectation', 2, '11', '1', 2, 0, 3, 1, 1),
(6, '', '110_Report à nouveau', 'Report à nouveau', 5, '110', '11', 2, 0, 4, 0, 1),
(7, '', '119_Report à nouveau (solde débiteur)', 'Report à nouveau (solde débiteur)', 5, '119', '11', 2, 0, 4, 0, 1),
(8, '', '12_Résultat net de l\'exercice (excédent ou déficit)', 'Résultat net de l\'exercice (excédent ou déficit)', 2, '12', '1', 2, 0, 3, 1, 1),
(9, '', '120_Résultat de l\'exercice (excédent)', 'Résultat de l\'exercice (excédent)', 8, '120', '12', 2, 0, 4, 0, 1),
(10, '', '129_Résultat de l\'exercice (déficit)', 'Résultat de l\'exercice (déficit)', 8, '129', '12', 2, 0, 4, 0, 1),
(11, '', '14_Provisions réglementées', 'Provisions réglementées', 2, '14', '1', 2, 0, 3, 0, 1),
(12, '', '15_Provisions pour risques et charges', 'Provisions pour risques et charges', 2, '15', '1', 2, 0, 3, 0, 1),
(13, '', '16_Emprunts et dettes assimilées', 'Emprunts et dettes assimilées', 2, '16', '1', 2, 0, 3, 0, 1),
(14, '', '2_Immobilisations', 'Immobilisations', 1, '2', '0', 2, 0, 2, 1, 1),
(15, '', '21_Immobilisations corporelles', 'Immobilisations corporelles', 14, '21', '2', 2, 0, 3, 1, 1),
(16, '', '215_Installations techniques, matériel et outillage industriels', 'Installations techniques, matériel et outillage industriels', 15, '215', '21', 2, 0, 4, 0, 1),
(17, '', '28_Amortissements des immobilisations', 'Amortissements des immobilisations', 14, '28', '2', 2, 0, 3, 1, 1),
(18, '', '281_Amortissements des immobilisations corporelles', 'Amortissements des immobilisations corporelles', 17, '281', '28', 2, 0, 4, 1, 1),
(19, '', '2815_Installations techniques, matériel et outillage industriels', 'Installations techniques, matériel et outillage industriels', 18, '2815', '281', 2, 0, 5, 0, 1),
(20, '', '4_Tiers', 'Tiers', 1, '4', '0', 2, 0, 2, 1, 1),
(21, '', '40_Fournisseurs et comptes rattaches', 'Fournisseurs et comptes rattaches', 20, '40', '4', 2, 0, 3, 1, 1),
(22, '', '401_Fournisseurs', 'Fournisseurs', 21, '401', '40', 2, 0, 4, 1, 1),
(23, '', '401_AS_Fournisseurs', 'Fournisseurs', 22, '401_AS', '401', 2, 0, 5, 0, 1),
(24, '', '401_AU_Fournisseurs', 'Fournisseurs', 22, '401_AU', '401', 2, 0, 5, 0, 1),
(25, '', '401_BA_Fournisseurs', 'Fournisseurs', 22, '401_BA', '401', 2, 0, 5, 0, 1),
(26, '', '401_BX_Fournisseurs', 'Fournisseurs', 22, '401_BX', '401', 2, 0, 5, 0, 1),
(27, '', '401_CC_Fournisseurs', 'Fournisseurs', 22, '401_CC', '401', 2, 0, 5, 0, 1),
(28, '', '401_CH_Fournisseurs', 'Fournisseurs', 22, '401_CH', '401', 2, 0, 5, 0, 1),
(29, '', '401_CP_Fournisseurs', 'Fournisseurs', 22, '401_CP', '401', 2, 0, 5, 0, 1),
(30, '', '401_CY_Fournisseurs', 'Fournisseurs', 22, '401_CY', '401', 2, 0, 5, 0, 1),
(31, '', '401_DS_Fournisseurs', 'Fournisseurs', 22, '401_DS', '401', 2, 0, 5, 0, 1),
(32, '', '401_ES_Fournisseurs', 'Fournisseurs', 22, '401_ES', '401', 2, 0, 5, 0, 1),
(33, '', '401_FO_Fournisseurs', 'Fournisseurs', 22, '401_FO', '401', 2, 0, 5, 0, 1),
(34, '', '401_GO_Fournisseurs', 'Fournisseurs', 22, '401_GO', '401', 2, 0, 5, 0, 1),
(35, '', '401_GY_Fournisseurs', 'Fournisseurs', 22, '401_GY', '401', 2, 0, 5, 0, 1),
(36, '', '401_KM_Fournisseurs', 'Fournisseurs', 22, '401_KM', '401', 2, 0, 5, 0, 1),
(37, '', '401_LO_Fournisseurs', 'Fournisseurs', 22, '401_LO', '401', 2, 0, 5, 0, 1),
(38, '', '401_MN_Fournisseurs', 'Fournisseurs', 22, '401_MN', '401', 2, 0, 5, 0, 1),
(39, '', '401_MU_Fournisseurs', 'Fournisseurs', 22, '401_MU', '401', 2, 0, 5, 0, 1),
(40, '', '401_NL_Fournisseurs', 'Fournisseurs', 22, '401_NL', '401', 2, 0, 5, 0, 1),
(41, '', '401_PA_Fournisseurs', 'Fournisseurs', 22, '401_PA', '401', 2, 0, 5, 0, 1),
(42, '', '401_PE_Fournisseurs', 'Fournisseurs', 22, '401_PE', '401', 2, 0, 5, 0, 1),
(43, '', '401_PI_Fournisseurs', 'Fournisseurs', 22, '401_PI', '401', 2, 0, 5, 0, 1),
(44, '', '401_PL_Fournisseurs', 'Fournisseurs', 22, '401_PL', '401', 2, 0, 5, 0, 1),
(45, '', '401_RC_Fournisseurs', 'Fournisseurs', 22, '401_RC', '401', 2, 0, 5, 0, 1),
(46, '', '401_RO_Fournisseurs', 'Fournisseurs', 22, '401_RO', '401', 2, 0, 5, 0, 1),
(47, '', '401_ST_Fournisseurs', 'Fournisseurs', 22, '401_ST', '401', 2, 0, 5, 0, 1),
(48, '', '401_TA_Fournisseurs', 'Fournisseurs', 22, '401_TA', '401', 2, 0, 5, 0, 1),
(49, '', '401_TE_Fournisseurs', 'Fournisseurs', 22, '401_TE', '401', 2, 0, 5, 0, 1),
(50, '', '401_TI_Fournisseurs', 'Fournisseurs', 22, '401_TI', '401', 2, 0, 5, 0, 1),
(51, '', '401_TT_Fournisseurs', 'Fournisseurs', 22, '401_TT', '401', 2, 0, 5, 0, 1),
(52, '', '401_VO_Fournisseurs', 'Fournisseurs', 22, '401_VO', '401', 2, 0, 5, 0, 1),
(53, '', '401_YO_Fournisseurs', 'Fournisseurs', 22, '401_YO', '401', 2, 0, 5, 0, 1),
(54, '', '401_ZU_Fournisseurs', 'Fournisseurs', 22, '401_ZU', '401', 2, 0, 5, 0, 1),
(55, '', '408_Fournisseurs factures non parvenues', 'Fournisseurs factures non parvenues', 21, '408', '40', 2, 0, 4, 0, 1),
(56, '', '44_État et autres collectivités publiques', 'État et autres collectivités publiques', 20, '44', '4', 2, 0, 3, 1, 1),
(57, '', '441_État subventions à recevoir', 'État subventions à recevoir', 56, '441', '44', 2, 0, 4, 0, 1),
(58, '', '46_Débiteurs divers et créditeurs divers', 'Débiteurs divers et créditeurs divers', 20, '46', '4', 2, 0, 3, 0, 1),
(59, '', '468_Débiteurs divers et créditeurs divers', 'Débiteurs divers et créditeurs divers', 58, '468', '46', 2, 0, 3, 1, 1),
(60, '', '4686_Charges à payer', 'Charges à payer', 59, '4686', '468', 2, 0, 5, 0, 1),
(61, '', '4687_Produits à recevoir', 'Produits à recevoir', 59, '4687', '468', 2, 0, 5, 0, 1),
(62, '', '5_Comptes financiers', 'Comptes financiers', 1, '5', '0', 2, 0, 2, 1, 1),
(63, '', '51_Banques, établissements financiers et assimiles', 'Banques, établissements financiers et assimiles', 62, '51', '5', 2, 0, 3, 1, 1),
(64, '', '512_Banques', 'Banques', 63, '512', '51', 2, 0, 4, 0, 1),
(65, '', '516_Sociétés de bourse', 'Sociétés de bourse', 63, '516', '51', 2, 0, 4, 0, 1),
(66, '', '517_Autres organismes financiers', 'Autres organismes financiers', 63, '517', '51', 2, 0, 4, 1, 1),
(67, '', '5171_Caisse d\'épargne', 'Caisse d\'épargne', 66, '5171', '517', 2, 0, 5, 0, 1),
(68, '', '53_Caisse', 'Caisse', 62, '53', '5', 2, 0, 3, 0, 1),
(69, '', '58_Virements internes', 'Virements internes', 62, '58', '5', 2, 0, 3, 0, 1),
(70, '', '6_Charges', 'Charges', 1, '6', '0', 2, 0, 2, 1, 1),
(71, '', '60_Achats (sauf 603)', 'Achats (sauf 603)', 70, '60', '6', 2, 0, 3, 1, 1),
(72, '', '603_Variation des stocks (approvisionnements et marchandises)', 'Variation des stocks (approvisionnements et marchandises)', 71, '603', '60', 2, 0, 4, 1, 1),
(73, '', '603_AS_Variation des stocks', 'Variation des stocks', 72, '603_AS', '603', 2, 0, 5, 0, 1),
(74, '', '603_AU_Variation des stocks', 'Variation des stocks', 72, '603_AU', '603', 2, 0, 5, 0, 1),
(75, '', '603_BA_Variation des stocks', 'Variation des stocks', 72, '603_BA', '603', 2, 0, 5, 0, 1),
(76, '', '603_BX_Variation des stocks', 'Variation des stocks', 72, '603_BX', '603', 2, 0, 5, 0, 1),
(77, '', '603_CC_Variation des stocks', 'Variation des stocks', 72, '603_CC', '603', 2, 0, 5, 0, 1),
(78, '', '603_CH_Variation des stocks', 'Variation des stocks', 72, '603_CH', '603', 2, 0, 5, 0, 1),
(79, '', '603_CP_Variation des stocks', 'Variation des stocks', 72, '603_CP', '603', 2, 0, 5, 0, 1),
(80, '', '603_CY_Variation des stocks', 'Variation des stocks', 72, '603_CY', '603', 2, 0, 5, 0, 1),
(81, '', '603_DS_Variation des stocks', 'Variation des stocks', 72, '603_DS', '603', 2, 0, 5, 0, 1),
(82, '', '603_ES_Variation des stocks', 'Variation des stocks', 72, '603_ES', '603', 2, 0, 5, 0, 1),
(83, '', '603_FO_Variation des stocks', 'Variation des stocks', 72, '603_FO', '603', 2, 0, 5, 0, 1),
(84, '', '603_GO_Variation des stocks', 'Variation des stocks', 72, '603_GO', '603', 2, 0, 5, 0, 1),
(85, '', '603_GY_Variation des stocks', 'Variation des stocks', 72, '603_GY', '603', 2, 0, 5, 0, 1),
(86, '', '603_KM_Variation des stocks', 'Variation des stocks', 72, '603_KM', '603', 2, 0, 5, 0, 1),
(87, '', '603_LO_Variation des stocks', 'Variation des stocks', 72, '603_LO', '603', 2, 0, 5, 0, 1),
(88, '', '603_MN_Variation des stocks', 'Variation des stocks', 72, '603_MN', '603', 2, 0, 5, 0, 1),
(89, '', '603_MU_Variation des stocks', 'Variation des stocks', 72, '603_MU', '603', 2, 0, 5, 0, 1),
(90, '', '603_NL_Variation des stocks', 'Variation des stocks', 72, '603_NL', '603', 2, 0, 5, 0, 1),
(91, '', '603_PA_Variation des stocks', 'Variation des stocks', 72, '603_PA', '603', 2, 0, 5, 0, 1),
(92, '', '603_PE_Variation des stocks', 'Variation des stocks', 72, '603_PE', '603', 2, 0, 5, 0, 1),
(93, '', '603_PI_Variation des stocks', 'Variation des stocks', 72, '603_PI', '603', 2, 0, 5, 0, 1),
(94, '', '603_PL_Variation des stocks', 'Variation des stocks', 72, '603_PL', '603', 2, 0, 5, 0, 1),
(95, '', '603_RC_Variation des stocks', 'Variation des stocks', 72, '603_RC', '603', 2, 0, 5, 0, 1),
(96, '', '603_RO_Variation des stocks', 'Variation des stocks', 72, '603_RO', '603', 2, 0, 5, 0, 1),
(97, '', '603_ST_Variation des stocks', 'Variation des stocks', 72, '603_ST', '603', 2, 0, 5, 0, 1),
(98, '', '603_TA_Variation des stocks', 'Variation des stocks', 72, '603_TA', '603', 2, 0, 5, 0, 1),
(99, '', '603_TE_Variation des stocks', 'Variation des stocks', 72, '603_TE', '603', 2, 0, 5, 0, 1),
(100, '', '603_TI_Variation des stocks', 'Variation des stocks', 72, '603_TI', '603', 2, 0, 5, 0, 1),
(101, '', '603_TT_Variation des stocks', 'Variation des stocks', 72, '603_TT', '603', 2, 0, 5, 0, 1),
(102, '', '603_VO_Variation des stocks', 'Variation des stocks', 72, '603_VO', '603', 2, 0, 5, 0, 1),
(103, '', '603_YO_Variation des stocks', 'Variation des stocks', 72, '603_YO', '603', 2, 0, 5, 0, 1),
(104, '', '603_ZU_Variation des stocks', 'Variation des stocks', 72, '603_ZU', '603', 2, 0, 5, 0, 1),
(105, '', '604_Achats d\'études et prestations de services', 'Achats d\'études et prestations de services', 71, '604', '60', 2, 0, 4, 1, 1),
(106, '', '604_AS_Achats d\'études et prestations de services', 'Achats d\'études et prestations de services', 105, '604_AS', '604', 2, 0, 5, 0, 1),
(107, '', '604_AU_Achats d\'études et prestations de services', 'Achats d\'études et prestations de services', 105, '604_AU', '604', 2, 0, 5, 0, 1),
(108, '', '604_BA_Achats d\'études et prestations de services', 'Achats d\'études et prestations de services', 105, '604_BA', '604', 2, 0, 5, 0, 1),
(109, '', '604_BX_Achats d\'études et prestations de services', 'Achats d\'études et prestations de services', 105, '604_BX', '604', 2, 0, 5, 0, 1),
(110, '', '604_CC_Achats d\'études et prestations de services', 'Achats d\'études et prestations de services', 105, '604_CC', '604', 2, 0, 5, 0, 1),
(111, '', '604_CH_Achats d\'études et prestations de services', 'Achats d\'études et prestations de services', 105, '604_CH', '604', 2, 0, 5, 0, 1),
(112, '', '604_CP_Achats d\'études et prestations de services', 'Achats d\'études et prestations de services', 105, '604_CP', '604', 2, 0, 5, 0, 1),
(113, '', '604_CY_Achats d\'études et prestations de services', 'Achats d\'études et prestations de services', 105, '604_CY', '604', 2, 0, 5, 0, 1),
(114, '', '604_DS_Achats d\'études et prestations de services', 'Achats d\'études et prestations de services', 105, '604_DS', '604', 2, 0, 5, 0, 1),
(115, '', '604_ES_Achats d\'études et prestations de services', 'Achats d\'études et prestations de services', 105, '604_ES', '604', 2, 0, 5, 0, 1),
(116, '', '604_FO_Achats d\'études et prestations de services', 'Achats d\'études et prestations de services', 105, '604_FO', '604', 2, 0, 5, 0, 1),
(117, '', '604_GO_Achats d\'études et prestations de services', 'Achats d\'études et prestations de services', 105, '604_GO', '604', 2, 0, 5, 0, 1),
(118, '', '604_GY_Achats d\'études et prestations de services', 'Achats d\'études et prestations de services', 105, '604_GY', '604', 2, 0, 5, 0, 1),
(119, '', '604_KM_Achats d\'études et prestations de services', 'Achats d\'études et prestations de services', 105, '604_KM', '604', 2, 0, 5, 0, 1),
(120, '', '604_LO_Achats d\'études et prestations de services', 'Achats d\'études et prestations de services', 105, '604_LO', '604', 2, 0, 5, 0, 1),
(121, '', '604_MN_Achats d\'études et prestations de services', 'Achats d\'études et prestations de services', 105, '604_MN', '604', 2, 0, 5, 0, 1),
(122, '', '604_MU_Achats d\'études et prestations de services', 'Achats d\'études et prestations de services', 105, '604_MU', '604', 2, 0, 5, 0, 1),
(123, '', '604_NL_Achats d\'études et prestations de services', 'Achats d\'études et prestations de services', 105, '604_NL', '604', 2, 0, 5, 0, 1),
(124, '', '604_PA_Achats d\'études et prestations de services', 'Achats d\'études et prestations de services', 105, '604_PA', '604', 2, 0, 5, 0, 1),
(125, '', '604_PE_Achats d\'études et prestations de services', 'Achats d\'études et prestations de services', 105, '604_PE', '604', 2, 0, 5, 0, 1),
(126, '', '604_PI_Achats d\'études et prestations de services', 'Achats d\'études et prestations de services', 105, '604_PI', '604', 2, 0, 5, 0, 1),
(127, '', '604_PL_Achats d\'études et prestations de services', 'Achats d\'études et prestations de services', 105, '604_PL', '604', 2, 0, 5, 0, 1),
(128, '', '604_RC_Achats d\'études et prestations de services', 'Achats d\'études et prestations de services', 105, '604_RC', '604', 2, 0, 5, 0, 1),
(129, '', '604_RO_Achats d\'études et prestations de services', 'Achats d\'études et prestations de services', 105, '604_RO', '604', 2, 0, 5, 0, 1),
(130, '', '604_ST_Achats d\'études et prestations de services', 'Achats d\'études et prestations de services', 105, '604_ST', '604', 2, 0, 5, 0, 1),
(131, '', '604_TA_Achats d\'études et prestations de services', 'Achats d\'études et prestations de services', 105, '604_TA', '604', 2, 0, 5, 0, 1),
(132, '', '604_TE_Achats d\'études et prestations de services', 'Achats d\'études et prestations de services', 105, '604_TE', '604', 2, 0, 5, 0, 1),
(133, '', '604_TI_Achats d\'études et prestations de services', 'Achats d\'études et prestations de services', 105, '604_TI', '604', 2, 0, 5, 0, 1),
(134, '', '604_TT_Achats d\'études et prestations de services', 'Achats d\'études et prestations de services', 105, '604_TT', '604', 2, 0, 5, 0, 1),
(135, '', '604_VO_Achats d\'études et prestations de services', 'Achats d\'études et prestations de services', 105, '604_VO', '604', 2, 0, 5, 0, 1),
(136, '', '604_YO_Achats d\'études et prestations de services', 'Achats d\'études et prestations de services', 105, '604_YO', '604', 2, 0, 5, 0, 1),
(137, '', '604_ZU_Achats d\'études et prestations de services', 'Achats d\'études et prestations de services', 105, '604_ZU', '604', 2, 0, 5, 0, 1),
(138, '', '605_Achats de matériels, équipements et travaux', 'Achats de matériels, équipements et travaux', 71, '605', '60', 2, 0, 4, 1, 1),
(139, '', '605_AS_Achats de matériels, équipements et travaux', 'Achats de matériels, équipements et travaux', 138, '605_AS', '605', 2, 0, 5, 0, 1),
(140, '', '605_AU_Achats de matériels, équipements et travaux', 'Achats de matériels, équipements et travaux', 138, '605_AU', '605', 2, 0, 5, 0, 1),
(141, '', '605_BA_Achats de matériels, équipements et travaux', 'Achats de matériels, équipements et travaux', 138, '605_BA', '605', 2, 0, 5, 0, 1),
(142, '', '605_BX_Achats de matériels, équipements et travaux', 'Achats de matériels, équipements et travaux', 138, '605_BX', '605', 2, 0, 5, 0, 1),
(143, '', '605_CC_Achats de matériels, équipements et travaux', 'Achats de matériels, équipements et travaux', 138, '605_CC', '605', 2, 0, 5, 0, 1),
(144, '', '605_CH_Achats de matériels, équipements et travaux', 'Achats de matériels, équipements et travaux', 138, '605_CH', '605', 2, 0, 5, 0, 1),
(145, '', '605_CP_Achats de matériels, équipements et travaux', 'Achats de matériels, équipements et travaux', 138, '605_CP', '605', 2, 0, 5, 0, 1),
(146, '', '605_CY_Achats de matériels, équipements et travaux', 'Achats de matériels, équipements et travaux', 138, '605_CY', '605', 2, 0, 5, 0, 1),
(147, '', '605_DS_Achats de matériels, équipements et travaux', 'Achats de matériels, équipements et travaux', 138, '605_DS', '605', 2, 0, 5, 0, 1),
(148, '', '605_ES_Achats de matériels, équipements et travaux', 'Achats de matériels, équipements et travaux', 138, '605_ES', '605', 2, 0, 5, 0, 1),
(149, '', '605_FO_Achats de matériels, équipements et travaux', 'Achats de matériels, équipements et travaux', 138, '605_FO', '605', 2, 0, 5, 0, 1),
(150, '', '605_GO_Achats de matériels, équipements et travaux', 'Achats de matériels, équipements et travaux', 138, '605_GO', '605', 2, 0, 5, 0, 1),
(151, '', '605_GY_Achats de matériels, équipements et travaux', 'Achats de matériels, équipements et travaux', 138, '605_GY', '605', 2, 0, 5, 0, 1),
(152, '', '605_KM_Achats de matériels, équipements et travaux', 'Achats de matériels, équipements et travaux', 138, '605_KM', '605', 2, 0, 5, 0, 1),
(153, '', '605_LO_Achats de matériels, équipements et travaux', 'Achats de matériels, équipements et travaux', 138, '605_LO', '605', 2, 0, 5, 0, 1),
(154, '', '605_MN_Achats de matériels, équipements et travaux', 'Achats de matériels, équipements et travaux', 138, '605_MN', '605', 2, 0, 5, 0, 1),
(155, '', '605_MU_Achats de matériels, équipements et travaux', 'Achats de matériels, équipements et travaux', 138, '605_MU', '605', 2, 0, 5, 0, 1),
(156, '', '605_NL_Achats de matériels, équipements et travaux', 'Achats de matériels, équipements et travaux', 138, '605_NL', '605', 2, 0, 5, 0, 1),
(157, '', '605_PA_Achats de matériels, équipements et travaux', 'Achats de matériels, équipements et travaux', 138, '605_PA', '605', 2, 0, 5, 0, 1),
(158, '', '605_PE_Achats de matériels, équipements et travaux', 'Achats de matériels, équipements et travaux', 138, '605_PE', '605', 2, 0, 5, 0, 1),
(159, '', '605_PI_Achats de matériels, équipements et travaux', 'Achats de matériels, équipements et travaux', 138, '605_PI', '605', 2, 0, 5, 0, 1),
(160, '', '605_PL_Achats de matériels, équipements et travaux', 'Achats de matériels, équipements et travaux', 138, '605_PL', '605', 2, 0, 5, 0, 1),
(161, '', '605_RC_Achats de matériels, équipements et travaux', 'Achats de matériels, équipements et travaux', 138, '605_RC', '605', 2, 0, 5, 0, 1),
(162, '', '605_RO_Achats de matériels, équipements et travaux', 'Achats de matériels, équipements et travaux', 138, '605_RO', '605', 2, 0, 5, 0, 1),
(163, '', '605_ST_Achats de matériels, équipements et travaux', 'Achats de matériels, équipements et travaux', 138, '605_ST', '605', 2, 0, 5, 0, 1),
(164, '', '605_TA_Achats de matériels, équipements et travaux', 'Achats de matériels, équipements et travaux', 138, '605_TA', '605', 2, 0, 5, 0, 1),
(165, '', '605_TE_Achats de matériels, équipements et travaux', 'Achats de matériels, équipements et travaux', 138, '605_TE', '605', 2, 0, 5, 0, 1),
(166, '', '605_TI_Achats de matériels, équipements et travaux', 'Achats de matériels, équipements et travaux', 138, '605_TI', '605', 2, 0, 5, 0, 1),
(167, '', '605_TT_Achats de matériels, équipements et travaux', 'Achats de matériels, équipements et travaux', 138, '605_TT', '605', 2, 0, 5, 0, 1),
(168, '', '605_VO_Achats de matériels, équipements et travaux', 'Achats de matériels, équipements et travaux', 138, '605_VO', '605', 2, 0, 5, 0, 1),
(169, '', '605_YO_Achats de matériels, équipements et travaux', 'Achats de matériels, équipements et travaux', 138, '605_YO', '605', 2, 0, 5, 0, 1),
(170, '', '605_ZU_Achats de matériels, équipements et travaux', 'Achats de matériels, équipements et travaux', 138, '605_ZU', '605', 2, 0, 5, 0, 1),
(171, '', '606_Achats non stockés de matières et fournitures', 'Achats non stockés de matières et fournitures', 71, '606', '60', 2, 0, 4, 1, 1),
(172, '', '606_AS_Achats non stockés de matières et fournitures', 'Achats non stockés de matières et fournitures', 171, '606_AS', '606', 2, 0, 5, 0, 1),
(173, '', '606_AU_Achats non stockés de matières et fournitures', 'Achats non stockés de matières et fournitures', 171, '606_AU', '606', 2, 0, 5, 0, 1),
(174, '', '606_BA_Achats non stockés de matières et fournitures', 'Achats non stockés de matières et fournitures', 171, '606_BA', '606', 2, 0, 5, 0, 1),
(175, '', '606_BX_Achats non stockés de matières et fournitures', 'Achats non stockés de matières et fournitures', 171, '606_BX', '606', 2, 0, 5, 0, 1),
(176, '', '606_CC_Achats non stockés de matières et fournitures', 'Achats non stockés de matières et fournitures', 171, '606_CC', '606', 2, 0, 5, 0, 1),
(177, '', '606_CH_Achats non stockés de matières et fournitures', 'Achats non stockés de matières et fournitures', 171, '606_CH', '606', 2, 0, 5, 0, 1),
(178, '', '606_CP_Achats non stockés de matières et fournitures', 'Achats non stockés de matières et fournitures', 171, '606_CP', '606', 2, 0, 5, 0, 1),
(179, '', '606_CY_Achats non stockés de matières et fournitures', 'Achats non stockés de matières et fournitures', 171, '606_CY', '606', 2, 0, 5, 0, 1),
(180, '', '606_DS_Achats non stockés de matières et fournitures', 'Achats non stockés de matières et fournitures', 171, '606_DS', '606', 2, 0, 5, 0, 1),
(181, '', '606_ES_Achats non stockés de matières et fournitures', 'Achats non stockés de matières et fournitures', 171, '606_ES', '606', 2, 0, 5, 0, 1),
(182, '', '606_FO_Achats non stockés de matières et fournitures', 'Achats non stockés de matières et fournitures', 171, '606_FO', '606', 2, 0, 5, 0, 1),
(183, '', '606_GO_Achats non stockés de matières et fournitures', 'Achats non stockés de matières et fournitures', 171, '606_GO', '606', 2, 0, 5, 0, 1),
(184, '', '606_GY_Achats non stockés de matières et fournitures', 'Achats non stockés de matières et fournitures', 171, '606_GY', '606', 2, 0, 5, 0, 1),
(185, '', '606_KM_Achats non stockés de matières et fournitures', 'Achats non stockés de matières et fournitures', 171, '606_KM', '606', 2, 0, 5, 0, 1),
(186, '', '606_LO_Achats non stockés de matières et fournitures', 'Achats non stockés de matières et fournitures', 171, '606_LO', '606', 2, 0, 5, 0, 1),
(187, '', '606_MN_Achats non stockés de matières et fournitures', 'Achats non stockés de matières et fournitures', 171, '606_MN', '606', 2, 0, 5, 0, 1),
(188, '', '606_MU_Achats non stockés de matières et fournitures', 'Achats non stockés de matières et fournitures', 171, '606_MU', '606', 2, 0, 5, 0, 1),
(189, '', '606_NL_Achats non stockés de matières et fournitures', 'Achats non stockés de matières et fournitures', 171, '606_NL', '606', 2, 0, 5, 0, 1),
(190, '', '606_PA_Achats non stockés de matières et fournitures', 'Achats non stockés de matières et fournitures', 171, '606_PA', '606', 2, 0, 5, 0, 1),
(191, '', '606_PE_Achats non stockés de matières et fournitures', 'Achats non stockés de matières et fournitures', 171, '606_PE', '606', 2, 0, 5, 0, 1),
(192, '', '606_PI_Achats non stockés de matières et fournitures', 'Achats non stockés de matières et fournitures', 171, '606_PI', '606', 2, 0, 5, 0, 1),
(193, '', '606_PL_Achats non stockés de matières et fournitures', 'Achats non stockés de matières et fournitures', 171, '606_PL', '606', 2, 0, 5, 0, 1),
(194, '', '606_RC_Achats non stockés de matières et fournitures', 'Achats non stockés de matières et fournitures', 171, '606_RC', '606', 2, 0, 5, 0, 1),
(195, '', '606_RO_Achats non stockés de matières et fournitures', 'Achats non stockés de matières et fournitures', 171, '606_RO', '606', 2, 0, 5, 0, 1),
(196, '', '606_ST_Achats non stockés de matières et fournitures', 'Achats non stockés de matières et fournitures', 171, '606_ST', '606', 2, 0, 5, 0, 1),
(197, '', '606_TA_Achats non stockés de matières et fournitures', 'Achats non stockés de matières et fournitures', 171, '606_TA', '606', 2, 0, 5, 0, 1),
(198, '', '606_TE_Achats non stockés de matières et fournitures', 'Achats non stockés de matières et fournitures', 171, '606_TE', '606', 2, 0, 5, 0, 1),
(199, '', '606_TI_Achats non stockés de matières et fournitures', 'Achats non stockés de matières et fournitures', 171, '606_TI', '606', 2, 0, 5, 0, 1),
(200, '', '606_TT_Achats non stockés de matières et fournitures', 'Achats non stockés de matières et fournitures', 171, '606_TT', '606', 2, 0, 5, 0, 1),
(201, '', '606_VO_Achats non stockés de matières et fournitures', 'Achats non stockés de matières et fournitures', 171, '606_VO', '606', 2, 0, 5, 0, 1),
(202, '', '606_YO_Achats non stockés de matières et fournitures', 'Achats non stockés de matières et fournitures', 171, '606_YO', '606', 2, 0, 5, 0, 1),
(203, '', '606_ZU_Achats non stockés de matières et fournitures', 'Achats non stockés de matières et fournitures', 171, '606_ZU', '606', 2, 0, 5, 0, 1),
(204, '', '61_Services extérieurs', 'Services extérieurs', 70, '61', '6', 2, 0, 3, 1, 1),
(205, '', '613_Locations', 'Locations', 204, '613', '61', 2, 0, 4, 1, 1),
(206, '', '613_AS_Locations', 'Locations', 205, '613_AS', '613', 2, 0, 5, 0, 1),
(207, '', '613_AU_Locations', 'Locations', 205, '613_AU', '613', 2, 0, 5, 0, 1),
(208, '', '613_BA_Locations', 'Locations', 205, '613_BA', '613', 2, 0, 5, 0, 1),
(209, '', '613_BX_Locations', 'Locations', 205, '613_BX', '613', 2, 0, 5, 0, 1),
(210, '', '613_CC_Locations', 'Locations', 205, '613_CC', '613', 2, 0, 5, 0, 1),
(211, '', '613_CH_Locations', 'Locations', 205, '613_CH', '613', 2, 0, 5, 0, 1),
(212, '', '613_CP_Locations', 'Locations', 205, '613_CP', '613', 2, 0, 5, 0, 1),
(213, '', '613_CY_Locations', 'Locations', 205, '613_CY', '613', 2, 0, 5, 0, 1),
(214, '', '613_DS_Locations', 'Locations', 205, '613_DS', '613', 2, 0, 5, 0, 1),
(215, '', '613_ES_Locations', 'Locations', 205, '613_ES', '613', 2, 0, 5, 0, 1),
(216, '', '613_FO_Locations', 'Locations', 205, '613_FO', '613', 2, 0, 5, 0, 1),
(217, '', '613_GO_Locations', 'Locations', 205, '613_GO', '613', 2, 0, 5, 0, 1),
(218, '', '613_GY_Locations', 'Locations', 205, '613_GY', '613', 2, 0, 5, 0, 1),
(219, '', '613_KM_Locations', 'Locations', 205, '613_KM', '613', 2, 0, 5, 0, 1),
(220, '', '613_LO_Locations', 'Locations', 205, '613_LO', '613', 2, 0, 5, 0, 1),
(221, '', '613_MN_Locations', 'Locations', 205, '613_MN', '613', 2, 0, 5, 0, 1),
(222, '', '613_MU_Locations', 'Locations', 205, '613_MU', '613', 2, 0, 5, 0, 1),
(223, '', '613_NL_Locations', 'Locations', 205, '613_NL', '613', 2, 0, 5, 0, 1),
(224, '', '613_PA_Locations', 'Locations', 205, '613_PA', '613', 2, 0, 5, 0, 1),
(225, '', '613_PE_Locations', 'Locations', 205, '613_PE', '613', 2, 0, 5, 0, 1),
(226, '', '613_PI_Locations', 'Locations', 205, '613_PI', '613', 2, 0, 5, 0, 1),
(227, '', '613_PL_Locations', 'Locations', 205, '613_PL', '613', 2, 0, 5, 0, 1),
(228, '', '613_RC_Locations', 'Locations', 205, '613_RC', '613', 2, 0, 5, 0, 1),
(229, '', '613_RO_Locations', 'Locations', 205, '613_RO', '613', 2, 0, 5, 0, 1),
(230, '', '613_ST_Locations', 'Locations', 205, '613_ST', '613', 2, 0, 5, 0, 1),
(231, '', '613_TA_Locations', 'Locations', 205, '613_TA', '613', 2, 0, 5, 0, 1),
(232, '', '613_TE_Locations', 'Locations', 205, '613_TE', '613', 2, 0, 5, 0, 1),
(233, '', '613_TI_Locations', 'Locations', 205, '613_TI', '613', 2, 0, 5, 0, 1),
(234, '', '613_TT_Locations', 'Locations', 205, '613_TT', '613', 2, 0, 5, 0, 1),
(235, '', '613_VO_Locations', 'Locations', 205, '613_VO', '613', 2, 0, 5, 0, 1),
(236, '', '613_YO_Locations', 'Locations', 205, '613_YO', '613', 2, 0, 5, 0, 1),
(237, '', '613_ZU_Locations', 'Locations', 205, '613_ZU', '613', 2, 0, 5, 0, 1),
(238, '', '615_Entretien et réparations', 'Entretien et réparations', 204, '615', '61', 2, 0, 4, 1, 1),
(239, '', '615_AS_Entretien et réparations', 'Entretien et réparations', 238, '615_AS', '615', 2, 0, 5, 0, 1),
(240, '', '615_AU_Entretien et réparations', 'Entretien et réparations', 238, '615_AU', '615', 2, 0, 5, 0, 1),
(241, '', '615_BA_Entretien et réparations', 'Entretien et réparations', 238, '615_BA', '615', 2, 0, 5, 0, 1),
(242, '', '615_BX_Entretien et réparations', 'Entretien et réparations', 238, '615_BX', '615', 2, 0, 5, 0, 1),
(243, '', '615_CC_Entretien et réparations', 'Entretien et réparations', 238, '615_CC', '615', 2, 0, 5, 0, 1),
(244, '', '615_CH_Entretien et réparations', 'Entretien et réparations', 238, '615_CH', '615', 2, 0, 5, 0, 1),
(245, '', '615_CP_Entretien et réparations', 'Entretien et réparations', 238, '615_CP', '615', 2, 0, 5, 0, 1),
(246, '', '615_CY_Entretien et réparations', 'Entretien et réparations', 238, '615_CY', '615', 2, 0, 5, 0, 1),
(247, '', '615_DS_Entretien et réparations', 'Entretien et réparations', 238, '615_DS', '615', 2, 0, 5, 0, 1),
(248, '', '615_ES_Entretien et réparations', 'Entretien et réparations', 238, '615_ES', '615', 2, 0, 5, 0, 1),
(249, '', '615_FO_Entretien et réparations', 'Entretien et réparations', 238, '615_FO', '615', 2, 0, 5, 0, 1),
(250, '', '615_GO_Entretien et réparations', 'Entretien et réparations', 238, '615_GO', '615', 2, 0, 5, 0, 1),
(251, '', '615_GY_Entretien et réparations', 'Entretien et réparations', 238, '615_GY', '615', 2, 0, 5, 0, 1),
(252, '', '615_KM_Entretien et réparations', 'Entretien et réparations', 238, '615_KM', '615', 2, 0, 5, 0, 1),
(253, '', '615_LO_Entretien et réparations', 'Entretien et réparations', 238, '615_LO', '615', 2, 0, 5, 0, 1),
(254, '', '615_MN_Entretien et réparations', 'Entretien et réparations', 238, '615_MN', '615', 2, 0, 5, 0, 1),
(255, '', '615_MU_Entretien et réparations', 'Entretien et réparations', 238, '615_MU', '615', 2, 0, 5, 0, 1),
(256, '', '615_NL_Entretien et réparations', 'Entretien et réparations', 238, '615_NL', '615', 2, 0, 5, 0, 1),
(257, '', '615_PA_Entretien et réparations', 'Entretien et réparations', 238, '615_PA', '615', 2, 0, 5, 0, 1),
(258, '', '615_PE_Entretien et réparations', 'Entretien et réparations', 238, '615_PE', '615', 2, 0, 5, 0, 1),
(259, '', '615_PI_Entretien et réparations', 'Entretien et réparations', 238, '615_PI', '615', 2, 0, 5, 0, 1),
(260, '', '615_PL_Entretien et réparations', 'Entretien et réparations', 238, '615_PL', '615', 2, 0, 5, 0, 1),
(261, '', '615_RC_Entretien et réparations', 'Entretien et réparations', 238, '615_RC', '615', 2, 0, 5, 0, 1),
(262, '', '615_RO_Entretien et réparations', 'Entretien et réparations', 238, '615_RO', '615', 2, 0, 5, 0, 1),
(263, '', '615_ST_Entretien et réparations', 'Entretien et réparations', 238, '615_ST', '615', 2, 0, 5, 0, 1),
(264, '', '615_TA_Entretien et réparations', 'Entretien et réparations', 238, '615_TA', '615', 2, 0, 5, 0, 1),
(265, '', '615_TE_Entretien et réparations', 'Entretien et réparations', 238, '615_TE', '615', 2, 0, 5, 0, 1),
(266, '', '615_TI_Entretien et réparations', 'Entretien et réparations', 238, '615_TI', '615', 2, 0, 5, 0, 1),
(267, '', '615_TT_Entretien et réparations', 'Entretien et réparations', 238, '615_TT', '615', 2, 0, 5, 0, 1),
(268, '', '615_VO_Entretien et réparations', 'Entretien et réparations', 238, '615_VO', '615', 2, 0, 5, 0, 1),
(269, '', '615_YO_Entretien et réparations', 'Entretien et réparations', 238, '615_YO', '615', 2, 0, 5, 0, 1),
(270, '', '615_ZU_Entretien et réparations', 'Entretien et réparations', 238, '615_ZU', '615', 2, 0, 5, 0, 1),
(271, '', '616_Primes d\'assurance', 'Primes d\'assurance', 204, '616', '61', 2, 0, 4, 1, 1),
(272, '', '616_AS_Primes d\'assurance', 'Primes d\'assurance', 271, '616_AS', '616', 2, 0, 5, 0, 1),
(273, '', '616_AU_Primes d\'assurance', 'Primes d\'assurance', 271, '616_AU', '616', 2, 0, 5, 0, 1),
(274, '', '616_BA_Primes d\'assurance', 'Primes d\'assurance', 271, '616_BA', '616', 2, 0, 5, 0, 1),
(275, '', '616_BX_Primes d\'assurance', 'Primes d\'assurance', 271, '616_BX', '616', 2, 0, 5, 0, 1),
(276, '', '616_CC_Primes d\'assurance', 'Primes d\'assurance', 271, '616_CC', '616', 2, 0, 5, 0, 1),
(277, '', '616_CH_Primes d\'assurance', 'Primes d\'assurance', 271, '616_CH', '616', 2, 0, 5, 0, 1),
(278, '', '616_CP_Primes d\'assurance', 'Primes d\'assurance', 271, '616_CP', '616', 2, 0, 5, 0, 1),
(279, '', '616_CY_Primes d\'assurance', 'Primes d\'assurance', 271, '616_CY', '616', 2, 0, 5, 0, 1),
(280, '', '616_DS_Primes d\'assurance', 'Primes d\'assurance', 271, '616_DS', '616', 2, 0, 5, 0, 1),
(281, '', '616_ES_Primes d\'assurance', 'Primes d\'assurance', 271, '616_ES', '616', 2, 0, 5, 0, 1),
(282, '', '616_FO_Primes d\'assurance', 'Primes d\'assurance', 271, '616_FO', '616', 2, 0, 5, 0, 1),
(283, '', '616_GO_Primes d\'assurance', 'Primes d\'assurance', 271, '616_GO', '616', 2, 0, 5, 0, 1),
(284, '', '616_GY_Primes d\'assurance', 'Primes d\'assurance', 271, '616_GY', '616', 2, 0, 5, 0, 1),
(285, '', '616_KM_Primes d\'assurance', 'Primes d\'assurance', 271, '616_KM', '616', 2, 0, 5, 0, 1),
(286, '', '616_LO_Primes d\'assurance', 'Primes d\'assurance', 271, '616_LO', '616', 2, 0, 5, 0, 1),
(287, '', '616_MN_Primes d\'assurance', 'Primes d\'assurance', 271, '616_MN', '616', 2, 0, 5, 0, 1),
(288, '', '616_MU_Primes d\'assurance', 'Primes d\'assurance', 271, '616_MU', '616', 2, 0, 5, 0, 1),
(289, '', '616_NL_Primes d\'assurance', 'Primes d\'assurance', 271, '616_NL', '616', 2, 0, 5, 0, 1),
(290, '', '616_PA_Primes d\'assurance', 'Primes d\'assurance', 271, '616_PA', '616', 2, 0, 5, 0, 1),
(291, '', '616_PE_Primes d\'assurance', 'Primes d\'assurance', 271, '616_PE', '616', 2, 0, 5, 0, 1),
(292, '', '616_PI_Primes d\'assurance', 'Primes d\'assurance', 271, '616_PI', '616', 2, 0, 5, 0, 1),
(293, '', '616_PL_Primes d\'assurance', 'Primes d\'assurance', 271, '616_PL', '616', 2, 0, 5, 0, 1),
(294, '', '616_RC_Primes d\'assurance', 'Primes d\'assurance', 271, '616_RC', '616', 2, 0, 5, 0, 1),
(295, '', '616_RO_Primes d\'assurance', 'Primes d\'assurance', 271, '616_RO', '616', 2, 0, 5, 0, 1),
(296, '', '616_ST_Primes d\'assurance', 'Primes d\'assurance', 271, '616_ST', '616', 2, 0, 5, 0, 1),
(297, '', '616_TA_Primes d\'assurance', 'Primes d\'assurance', 271, '616_TA', '616', 2, 0, 5, 0, 1),
(298, '', '616_TE_Primes d\'assurance', 'Primes d\'assurance', 271, '616_TE', '616', 2, 0, 5, 0, 1),
(299, '', '616_TI_Primes d\'assurance', 'Primes d\'assurance', 271, '616_TI', '616', 2, 0, 5, 0, 1),
(300, '', '616_TT_Primes d\'assurance', 'Primes d\'assurance', 271, '616_TT', '616', 2, 0, 5, 0, 1),
(301, '', '616_VO_Primes d\'assurance', 'Primes d\'assurance', 271, '616_VO', '616', 2, 0, 5, 0, 1),
(302, '', '616_YO_Primes d\'assurance', 'Primes d\'assurance', 271, '616_YO', '616', 2, 0, 5, 0, 1),
(303, '', '616_ZU_Primes d\'assurance', 'Primes d\'assurance', 271, '616_ZU', '616', 2, 0, 5, 0, 1),
(304, '', '618_Divers', 'Divers', 204, '618', '61', 2, 0, 4, 0, 1),
(305, '', '62_Autres services extérieurs', 'Autres services extérieurs', 70, '62', '6', 2, 0, 3, 1, 1),
(306, '', '622_Rémunérations d\'intérimaires et honoraires', 'Rémunérations d\'intérimaires et honoraires', 305, '622', '62', 2, 0, 4, 1, 1),
(307, '', '622_AS_Rémunérations d\'intérimaires et honoraires', 'Rémunérations d\'intérimaires et honoraires', 306, '622_AS', '622', 2, 0, 5, 0, 1),
(308, '', '622_AU_Rémunérations d\'intérimaires et honoraires', 'Rémunérations d\'intérimaires et honoraires', 306, '622_AU', '622', 2, 0, 5, 0, 1),
(309, '', '622_BA_Rémunérations d\'intérimaires et honoraires', 'Rémunérations d\'intérimaires et honoraires', 306, '622_BA', '622', 2, 0, 5, 0, 1),
(310, '', '622_BX_Rémunérations d\'intérimaires et honoraires', 'Rémunérations d\'intérimaires et honoraires', 306, '622_BX', '622', 2, 0, 5, 0, 1),
(311, '', '622_CC_Rémunérations d\'intérimaires et honoraires', 'Rémunérations d\'intérimaires et honoraires', 306, '622_CC', '622', 2, 0, 5, 0, 1),
(312, '', '622_CH_Rémunérations d\'intérimaires et honoraires', 'Rémunérations d\'intérimaires et honoraires', 306, '622_CH', '622', 2, 0, 5, 0, 1),
(313, '', '622_CP_Rémunérations d\'intérimaires et honoraires', 'Rémunérations d\'intérimaires et honoraires', 306, '622_CP', '622', 2, 0, 5, 0, 1),
(314, '', '622_CY_Rémunérations d\'intérimaires et honoraires', 'Rémunérations d\'intérimaires et honoraires', 306, '622_CY', '622', 2, 0, 5, 0, 1),
(315, '', '622_DS_Rémunérations d\'intérimaires et honoraires', 'Rémunérations d\'intérimaires et honoraires', 306, '622_DS', '622', 2, 0, 5, 0, 1),
(316, '', '622_ES_Rémunérations d\'intérimaires et honoraires', 'Rémunérations d\'intérimaires et honoraires', 306, '622_ES', '622', 2, 0, 5, 0, 1),
(317, '', '622_FO_Rémunérations d\'intérimaires et honoraires', 'Rémunérations d\'intérimaires et honoraires', 306, '622_FO', '622', 2, 0, 5, 0, 1),
(318, '', '622_GO_Rémunérations d\'intérimaires et honoraires', 'Rémunérations d\'intérimaires et honoraires', 306, '622_GO', '622', 2, 0, 5, 0, 1),
(319, '', '622_GY_Rémunérations d\'intérimaires et honoraires', 'Rémunérations d\'intérimaires et honoraires', 306, '622_GY', '622', 2, 0, 5, 0, 1),
(320, '', '622_KM_Rémunérations d\'intérimaires et honoraires', 'Rémunérations d\'intérimaires et honoraires', 306, '622_KM', '622', 2, 0, 5, 0, 1),
(321, '', '622_LO_Rémunérations d\'intérimaires et honoraires', 'Rémunérations d\'intérimaires et honoraires', 306, '622_LO', '622', 2, 0, 5, 0, 1),
(322, '', '622_MN_Rémunérations d\'intérimaires et honoraires', 'Rémunérations d\'intérimaires et honoraires', 306, '622_MN', '622', 2, 0, 5, 0, 1),
(323, '', '622_MU_Rémunérations d\'intérimaires et honoraires', 'Rémunérations d\'intérimaires et honoraires', 306, '622_MU', '622', 2, 0, 5, 0, 1),
(324, '', '622_NL_Rémunérations d\'intérimaires et honoraires', 'Rémunérations d\'intérimaires et honoraires', 306, '622_NL', '622', 2, 0, 5, 0, 1),
(325, '', '622_PA_Rémunérations d\'intérimaires et honoraires', 'Rémunérations d\'intérimaires et honoraires', 306, '622_PA', '622', 2, 0, 5, 0, 1),
(326, '', '622_PE_Rémunérations d\'intérimaires et honoraires', 'Rémunérations d\'intérimaires et honoraires', 306, '622_PE', '622', 2, 0, 5, 0, 1),
(327, '', '622_PI_Rémunérations d\'intérimaires et honoraires', 'Rémunérations d\'intérimaires et honoraires', 306, '622_PI', '622', 2, 0, 5, 0, 1),
(328, '', '622_PL_Rémunérations d\'intérimaires et honoraires', 'Rémunérations d\'intérimaires et honoraires', 306, '622_PL', '622', 2, 0, 5, 0, 1),
(329, '', '622_RC_Rémunérations d\'intérimaires et honoraires', 'Rémunérations d\'intérimaires et honoraires', 306, '622_RC', '622', 2, 0, 5, 0, 1),
(330, '', '622_RO_Rémunérations d\'intérimaires et honoraires', 'Rémunérations d\'intérimaires et honoraires', 306, '622_RO', '622', 2, 0, 5, 0, 1),
(331, '', '622_ST_Rémunérations d\'intérimaires et honoraires', 'Rémunérations d\'intérimaires et honoraires', 306, '622_ST', '622', 2, 0, 5, 0, 1),
(332, '', '622_TA_Rémunérations d\'intérimaires et honoraires', 'Rémunérations d\'intérimaires et honoraires', 306, '622_TA', '622', 2, 0, 5, 0, 1),
(333, '', '622_TE_Rémunérations d\'intérimaires et honoraires', 'Rémunérations d\'intérimaires et honoraires', 306, '622_TE', '622', 2, 0, 5, 0, 1),
(334, '', '622_TI_Rémunérations d\'intérimaires et honoraires', 'Rémunérations d\'intérimaires et honoraires', 306, '622_TI', '622', 2, 0, 5, 0, 1),
(335, '', '622_TT_Rémunérations d\'intérimaires et honoraires', 'Rémunérations d\'intérimaires et honoraires', 306, '622_TT', '622', 2, 0, 5, 0, 1),
(336, '', '622_VO_Rémunérations d\'intérimaires et honoraires', 'Rémunérations d\'intérimaires et honoraires', 306, '622_VO', '622', 2, 0, 5, 0, 1),
(337, '', '622_YO_Rémunérations d\'intérimaires et honoraires', 'Rémunérations d\'intérimaires et honoraires', 306, '622_YO', '622', 2, 0, 5, 0, 1),
(338, '', '622_ZU_Rémunérations d\'intérimaires et honoraires', 'Rémunérations d\'intérimaires et honoraires', 306, '622_ZU', '622', 2, 0, 5, 0, 1),
(339, '', '623_Publicité, publications, relations publiques', 'Publicité, publications, relations publiques', 305, '623', '62', 2, 0, 4, 1, 1),
(340, '', '623_AS_Publicité, publications, relations publiques', 'Publicité, publications, relations publiques', 339, '623_AS', '623', 2, 0, 5, 0, 1),
(341, '', '623_AU_Publicité, publications, relations publiques', 'Publicité, publications, relations publiques', 339, '623_AU', '623', 2, 0, 5, 0, 1),
(342, '', '623_BA_Publicité, publications, relations publiques', 'Publicité, publications, relations publiques', 339, '623_BA', '623', 2, 0, 5, 0, 1),
(343, '', '623_BX_Publicité, publications, relations publiques', 'Publicité, publications, relations publiques', 339, '623_BX', '623', 2, 0, 5, 0, 1),
(344, '', '623_CC_Publicité, publications, relations publiques', 'Publicité, publications, relations publiques', 339, '623_CC', '623', 2, 0, 5, 0, 1),
(345, '', '623_CH_Publicité, publications, relations publiques', 'Publicité, publications, relations publiques', 339, '623_CH', '623', 2, 0, 5, 0, 1),
(346, '', '623_CP_Publicité, publications, relations publiques', 'Publicité, publications, relations publiques', 339, '623_CP', '623', 2, 0, 5, 0, 1),
(347, '', '623_CY_Publicité, publications, relations publiques', 'Publicité, publications, relations publiques', 339, '623_CY', '623', 2, 0, 5, 0, 1),
(348, '', '623_DS_Publicité, publications, relations publiques', 'Publicité, publications, relations publiques', 339, '623_DS', '623', 2, 0, 5, 0, 1),
(349, '', '623_ES_Publicité, publications, relations publiques', 'Publicité, publications, relations publiques', 339, '623_ES', '623', 2, 0, 5, 0, 1),
(350, '', '623_FO_Publicité, publications, relations publiques', 'Publicité, publications, relations publiques', 339, '623_FO', '623', 2, 0, 5, 0, 1),
(351, '', '623_GO_Publicité, publications, relations publiques', 'Publicité, publications, relations publiques', 339, '623_GO', '623', 2, 0, 5, 0, 1),
(352, '', '623_GY_Publicité, publications, relations publiques', 'Publicité, publications, relations publiques', 339, '623_GY', '623', 2, 0, 5, 0, 1),
(353, '', '623_KM_Publicité, publications, relations publiques', 'Publicité, publications, relations publiques', 339, '623_KM', '623', 2, 0, 5, 0, 1),
(354, '', '623_LO_Publicité, publications, relations publiques', 'Publicité, publications, relations publiques', 339, '623_LO', '623', 2, 0, 5, 0, 1),
(355, '', '623_MN_Publicité, publications, relations publiques', 'Publicité, publications, relations publiques', 339, '623_MN', '623', 2, 0, 5, 0, 1),
(356, '', '623_MU_Publicité, publications, relations publiques', 'Publicité, publications, relations publiques', 339, '623_MU', '623', 2, 0, 5, 0, 1),
(357, '', '623_NL_Publicité, publications, relations publiques', 'Publicité, publications, relations publiques', 339, '623_NL', '623', 2, 0, 5, 0, 1),
(358, '', '623_PA_Publicité, publications, relations publiques', 'Publicité, publications, relations publiques', 339, '623_PA', '623', 2, 0, 5, 0, 1),
(359, '', '623_PE_Publicité, publications, relations publiques', 'Publicité, publications, relations publiques', 339, '623_PE', '623', 2, 0, 5, 0, 1),
(360, '', '623_PI_Publicité, publications, relations publiques', 'Publicité, publications, relations publiques', 339, '623_PI', '623', 2, 0, 5, 0, 1),
(361, '', '623_PL_Publicité, publications, relations publiques', 'Publicité, publications, relations publiques', 339, '623_PL', '623', 2, 0, 5, 0, 1),
(362, '', '623_RC_Publicité, publications, relations publiques', 'Publicité, publications, relations publiques', 339, '623_RC', '623', 2, 0, 5, 0, 1),
(363, '', '623_RO_Publicité, publications, relations publiques', 'Publicité, publications, relations publiques', 339, '623_RO', '623', 2, 0, 5, 0, 1),
(364, '', '623_ST_Publicité, publications, relations publiques', 'Publicité, publications, relations publiques', 339, '623_ST', '623', 2, 0, 5, 0, 1),
(365, '', '623_TA_Publicité, publications, relations publiques', 'Publicité, publications, relations publiques', 339, '623_TA', '623', 2, 0, 5, 0, 1),
(366, '', '623_TE_Publicité, publications, relations publiques', 'Publicité, publications, relations publiques', 339, '623_TE', '623', 2, 0, 5, 0, 1),
(367, '', '623_TI_Publicité, publications, relations publiques', 'Publicité, publications, relations publiques', 339, '623_TI', '623', 2, 0, 5, 0, 1),
(368, '', '623_TT_Publicité, publications, relations publiques', 'Publicité, publications, relations publiques', 339, '623_TT', '623', 2, 0, 5, 0, 1),
(369, '', '623_VO_Publicité, publications, relations publiques', 'Publicité, publications, relations publiques', 339, '623_VO', '623', 2, 0, 5, 0, 1),
(370, '', '623_YO_Publicité, publications, relations publiques', 'Publicité, publications, relations publiques', 339, '623_YO', '623', 2, 0, 5, 0, 1),
(371, '', '623_ZU_Publicité, publications, relations publiques', 'Publicité, publications, relations publiques', 339, '623_ZU', '623', 2, 0, 5, 0, 1),
(372, '', '625_Déplacements, missions et réceptions', 'Déplacements, missions et réceptions', 305, '625', '62', 2, 0, 4, 1, 1),
(373, '', '625_AS_Déplacements, missions et réceptions', 'Déplacements, missions et réceptions', 372, '625_AS', '625', 2, 0, 5, 0, 1),
(374, '', '625_AU_Déplacements, missions et réceptions', 'Déplacements, missions et réceptions', 372, '625_AU', '625', 2, 0, 5, 0, 1),
(375, '', '625_BA_Déplacements, missions et réceptions', 'Déplacements, missions et réceptions', 372, '625_BA', '625', 2, 0, 5, 0, 1),
(376, '', '625_BX_Déplacements, missions et réceptions', 'Déplacements, missions et réceptions', 372, '625_BX', '625', 2, 0, 5, 0, 1),
(377, '', '625_CC_Déplacements, missions et réceptions', 'Déplacements, missions et réceptions', 372, '625_CC', '625', 2, 0, 5, 0, 1),
(378, '', '625_CH_Déplacements, missions et réceptions', 'Déplacements, missions et réceptions', 372, '625_CH', '625', 2, 0, 5, 0, 1),
(379, '', '625_CP_Déplacements, missions et réceptions', 'Déplacements, missions et réceptions', 372, '625_CP', '625', 2, 0, 5, 0, 1),
(380, '', '625_CY_Déplacements, missions et réceptions', 'Déplacements, missions et réceptions', 372, '625_CY', '625', 2, 0, 5, 0, 1),
(381, '', '625_DS_Déplacements, missions et réceptions', 'Déplacements, missions et réceptions', 372, '625_DS', '625', 2, 0, 5, 0, 1),
(382, '', '625_ES_Déplacements, missions et réceptions', 'Déplacements, missions et réceptions', 372, '625_ES', '625', 2, 0, 5, 0, 1),
(383, '', '625_FO_Déplacements, missions et réceptions', 'Déplacements, missions et réceptions', 372, '625_FO', '625', 2, 0, 5, 0, 1),
(384, '', '625_GO_Déplacements, missions et réceptions', 'Déplacements, missions et réceptions', 372, '625_GO', '625', 2, 0, 5, 0, 1),
(385, '', '625_GY_Déplacements, missions et réceptions', 'Déplacements, missions et réceptions', 372, '625_GY', '625', 2, 0, 5, 0, 1),
(386, '', '625_KM_Déplacements, missions et réceptions', 'Déplacements, missions et réceptions', 372, '625_KM', '625', 2, 0, 5, 0, 1),
(387, '', '625_LO_Déplacements, missions et réceptions', 'Déplacements, missions et réceptions', 372, '625_LO', '625', 2, 0, 5, 0, 1),
(388, '', '625_MN_Déplacements, missions et réceptions', 'Déplacements, missions et réceptions', 372, '625_MN', '625', 2, 0, 5, 0, 1),
(389, '', '625_MU_Déplacements, missions et réceptions', 'Déplacements, missions et réceptions', 372, '625_MU', '625', 2, 0, 5, 0, 1),
(390, '', '625_NL_Déplacements, missions et réceptions', 'Déplacements, missions et réceptions', 372, '625_NL', '625', 2, 0, 5, 0, 1),
(391, '', '625_PA_Déplacements, missions et réceptions', 'Déplacements, missions et réceptions', 372, '625_PA', '625', 2, 0, 5, 0, 1),
(392, '', '625_PE_Déplacements, missions et réceptions', 'Déplacements, missions et réceptions', 372, '625_PE', '625', 2, 0, 5, 0, 1),
(393, '', '625_PI_Déplacements, missions et réceptions', 'Déplacements, missions et réceptions', 372, '625_PI', '625', 2, 0, 5, 0, 1),
(394, '', '625_PL_Déplacements, missions et réceptions', 'Déplacements, missions et réceptions', 372, '625_PL', '625', 2, 0, 5, 0, 1),
(395, '', '625_RC_Déplacements, missions et réceptions', 'Déplacements, missions et réceptions', 372, '625_RC', '625', 2, 0, 5, 0, 1),
(396, '', '625_RO_Déplacements, missions et réceptions', 'Déplacements, missions et réceptions', 372, '625_RO', '625', 2, 0, 5, 0, 1),
(397, '', '625_ST_Déplacements, missions et réceptions', 'Déplacements, missions et réceptions', 372, '625_ST', '625', 2, 0, 5, 0, 1),
(398, '', '625_TA_Déplacements, missions et réceptions', 'Déplacements, missions et réceptions', 372, '625_TA', '625', 2, 0, 5, 0, 1),
(399, '', '625_TE_Déplacements, missions et réceptions', 'Déplacements, missions et réceptions', 372, '625_TE', '625', 2, 0, 5, 0, 1),
(400, '', '625_TI_Déplacements, missions et réceptions', 'Déplacements, missions et réceptions', 372, '625_TI', '625', 2, 0, 5, 0, 1),
(401, '', '625_TT_Déplacements, missions et réceptions', 'Déplacements, missions et réceptions', 372, '625_TT', '625', 2, 0, 5, 0, 1),
(402, '', '625_VO_Déplacements, missions et réceptions', 'Déplacements, missions et réceptions', 372, '625_VO', '625', 2, 0, 5, 0, 1),
(403, '', '625_YO_Déplacements, missions et réceptions', 'Déplacements, missions et réceptions', 372, '625_YO', '625', 2, 0, 5, 0, 1),
(404, '', '625_ZU_Déplacements, missions et réceptions', 'Déplacements, missions et réceptions', 372, '625_ZU', '625', 2, 0, 5, 0, 1),
(405, '', '626_Frais postaux et frais de télécommunications', 'Frais postaux et frais de télécommunications', 305, '626', '62', 2, 0, 4, 0, 1),
(406, '', '627_Services bancaires et assimilés', 'Services bancaires et assimilés', 305, '627', '62', 2, 0, 4, 0, 1),
(407, '', '63_Impôts, taxes et versements assimiles', 'Impôts, taxes et versements assimiles', 70, '63', '6', 2, 0, 3, 0, 1),
(408, '', '65_Autres charges de gestion courantes', 'Autres charges de gestion courantes', 70, '65', '6', 2, 0, 3, 0, 1),
(409, '', '66_Charges financières', 'Charges financières', 70, '66', '6', 2, 0, 3, 0, 1),
(410, '', '67_Charges exceptionnelles', 'Charges exceptionnelles', 70, '67', '6', 2, 0, 3, 0, 1),
(411, '', '68_Dotations aux amortissements, provisions et engagements', 'Dotations aux amortissements, provisions et engagements', 70, '68', '6', 2, 0, 3, 1, 1),
(412, '', '68_AS_Dotations aux amortissements, provisions et engagements', 'Dotations aux amortissements, provisions et engagements', 411, '68_AS', '68', 2, 0, 4, 0, 1);
INSERT INTO `cpt_CatCompte` (`cat_ID_CatCompte`, `cat_Chemin_CatCompte`, `cat_Nom_CatCompte`, `cat_Commentaire`, `cat_ID_CatCompte_Parent`, `cat_Raccourcis_CatCompte`, `cat_Nom_CatCompte_Parent`, `cat_Type_CatCompte`, `cat_Num_Tag_Associes`, `cat_Niveau`, `cat_Virtuel`, `cat_Visible`) VALUES
(413, '', '68_AU_Dotations aux amortissements, provisions et engagements', 'Dotations aux amortissements, provisions et engagements', 411, '68_AU', '68', 2, 0, 4, 0, 1),
(414, '', '68_BA_Dotations aux amortissements, provisions et engagements', 'Dotations aux amortissements, provisions et engagements', 411, '68_BA', '68', 2, 0, 4, 0, 1),
(415, '', '68_BX_Dotations aux amortissements, provisions et engagements', 'Dotations aux amortissements, provisions et engagements', 411, '68_BX', '68', 2, 0, 4, 0, 1),
(416, '', '68_CC_Dotations aux amortissements, provisions et engagements', 'Dotations aux amortissements, provisions et engagements', 411, '68_CC', '68', 2, 0, 4, 0, 1),
(417, '', '68_CH_Dotations aux amortissements, provisions et engagements', 'Dotations aux amortissements, provisions et engagements', 411, '68_CH', '68', 2, 0, 4, 0, 1),
(418, '', '68_CP_Dotations aux amortissements, provisions et engagements', 'Dotations aux amortissements, provisions et engagements', 411, '68_CP', '68', 2, 0, 4, 0, 1),
(419, '', '68_CY_Dotations aux amortissements, provisions et engagements', 'Dotations aux amortissements, provisions et engagements', 411, '68_CY', '68', 2, 0, 4, 0, 1),
(420, '', '68_DS_Dotations aux amortissements, provisions et engagements', 'Dotations aux amortissements, provisions et engagements', 411, '68_DS', '68', 2, 0, 4, 0, 1),
(421, '', '68_ES_Dotations aux amortissements, provisions et engagements', 'Dotations aux amortissements, provisions et engagements', 411, '68_ES', '68', 2, 0, 4, 0, 1),
(422, '', '68_FO_Dotations aux amortissements, provisions et engagements', 'Dotations aux amortissements, provisions et engagements', 411, '68_FO', '68', 2, 0, 4, 0, 1),
(423, '', '68_GO_Dotations aux amortissements, provisions et engagements', 'Dotations aux amortissements, provisions et engagements', 411, '68_GO', '68', 2, 0, 4, 0, 1),
(424, '', '68_GY_Dotations aux amortissements, provisions et engagements', 'Dotations aux amortissements, provisions et engagements', 411, '68_GY', '68', 2, 0, 4, 0, 1),
(425, '', '68_KM_Dotations aux amortissements, provisions et engagements', 'Dotations aux amortissements, provisions et engagements', 411, '68_KM', '68', 2, 0, 4, 0, 1),
(426, '', '68_LO_Dotations aux amortissements, provisions et engagements', 'Dotations aux amortissements, provisions et engagements', 411, '68_LO', '68', 2, 0, 4, 0, 1),
(427, '', '68_MN_Dotations aux amortissements, provisions et engagements', 'Dotations aux amortissements, provisions et engagements', 411, '68_MN', '68', 2, 0, 4, 0, 1),
(428, '', '68_MU_Dotations aux amortissements, provisions et engagements', 'Dotations aux amortissements, provisions et engagements', 411, '68_MU', '68', 2, 0, 4, 0, 1),
(429, '', '68_NL_Dotations aux amortissements, provisions et engagements', 'Dotations aux amortissements, provisions et engagements', 411, '68_NL', '68', 2, 0, 4, 0, 1),
(430, '', '68_PA_Dotations aux amortissements, provisions et engagements', 'Dotations aux amortissements, provisions et engagements', 411, '68_PA', '68', 2, 0, 4, 0, 1),
(431, '', '68_PE_Dotations aux amortissements, provisions et engagements', 'Dotations aux amortissements, provisions et engagements', 411, '68_PE', '68', 2, 0, 4, 0, 1),
(432, '', '68_PI_Dotations aux amortissements, provisions et engagements', 'Dotations aux amortissements, provisions et engagements', 411, '68_PI', '68', 2, 0, 4, 0, 1),
(433, '', '68_PL_Dotations aux amortissements, provisions et engagements', 'Dotations aux amortissements, provisions et engagements', 411, '68_PL', '68', 2, 0, 4, 0, 1),
(434, '', '68_RC_Dotations aux amortissements, provisions et engagements', 'Dotations aux amortissements, provisions et engagements', 411, '68_RC', '68', 2, 0, 4, 0, 1),
(435, '', '68_RO_Dotations aux amortissements, provisions et engagements', 'Dotations aux amortissements, provisions et engagements', 411, '68_RO', '68', 2, 0, 4, 0, 1),
(436, '', '68_ST_Dotations aux amortissements, provisions et engagements', 'Dotations aux amortissements, provisions et engagements', 411, '68_ST', '68', 2, 0, 4, 0, 1),
(437, '', '68_TA_Dotations aux amortissements, provisions et engagements', 'Dotations aux amortissements, provisions et engagements', 411, '68_TA', '68', 2, 0, 4, 0, 1),
(438, '', '68_TE_Dotations aux amortissements, provisions et engagements', 'Dotations aux amortissements, provisions et engagements', 411, '68_TE', '68', 2, 0, 4, 0, 1),
(439, '', '68_TI_Dotations aux amortissements, provisions et engagements', 'Dotations aux amortissements, provisions et engagements', 411, '68_TI', '68', 2, 0, 4, 0, 1),
(440, '', '68_TT_Dotations aux amortissements, provisions et engagements', 'Dotations aux amortissements, provisions et engagements', 411, '68_TT', '68', 2, 0, 4, 0, 1),
(441, '', '68_VO_Dotations aux amortissements, provisions et engagements', 'Dotations aux amortissements, provisions et engagements', 411, '68_VO', '68', 2, 0, 4, 0, 1),
(442, '', '68_YO_Dotations aux amortissements, provisions et engagements', 'Dotations aux amortissements, provisions et engagements', 411, '68_YO', '68', 2, 0, 4, 0, 1),
(443, '', '68_ZU_Dotations aux amortissements, provisions et engagements', 'Dotations aux amortissements, provisions et engagements', 411, '68_ZU', '68', 2, 0, 4, 0, 1),
(444, '', '7_Produits', 'Produits', 1, '7', '0', 3, 0, 2, 1, 1),
(445, '', '70_Ventes de produits finis, prestations de services, marchandises', 'Ventes de produits finis, prestations de services, marchandises', 444, '70', '7', 3, 0, 3, 1, 1),
(446, '', '702_Ventes de produits intermédiaires', 'Ventes de produits intermédiaires', 445, '702', '70', 3, 0, 4, 0, 1),
(447, '', '706_Prestations de services', 'Prestations de services', 445, '706', '70', 3, 0, 4, 0, 1),
(448, '', '708_Produits des activités annexes', 'Produits des activités annexes', 445, '708', '70', 3, 0, 4, 0, 1),
(449, '', '74_Subventions d\'exploitation', 'Subventions d\'exploitation', 444, '74', '7', 3, 0, 3, 0, 1),
(450, '', '75_Autres produits de gestion courante', 'Autres produits de gestion courante', 444, '75', '7', 3, 0, 3, 1, 1),
(451, '', '756_Cotisations', 'Cotisations', 450, '756', '75', 3, 0, 4, 1, 1),
(452, '', '756_AS_Cotisations', 'Cotisations', 451, '756_AS', '756', 3, 0, 5, 0, 1),
(453, '', '756_AU_Cotisations', 'Cotisations', 451, '756_AU', '756', 3, 0, 5, 0, 1),
(454, '', '756_BA_Cotisations', 'Cotisations', 451, '756_BA', '756', 3, 0, 5, 0, 1),
(455, '', '756_BX_Cotisations', 'Cotisations', 451, '756_BX', '756', 3, 0, 5, 0, 1),
(456, '', '756_CC_Cotisations', 'Cotisations', 451, '756_CC', '756', 3, 0, 5, 0, 1),
(457, '', '756_CH_Cotisations', 'Cotisations', 451, '756_CH', '756', 3, 0, 5, 0, 1),
(458, '', '756_CP_Cotisations', 'Cotisations', 451, '756_CP', '756', 3, 0, 5, 0, 1),
(459, '', '756_CY_Cotisations', 'Cotisations', 451, '756_CY', '756', 3, 0, 5, 0, 1),
(460, '', '756_DS_Cotisations', 'Cotisations', 451, '756_DS', '756', 3, 0, 5, 0, 1),
(461, '', '756_ES_Cotisations', 'Cotisations', 451, '756_ES', '756', 3, 0, 5, 0, 1),
(462, '', '756_FO_Cotisations', 'Cotisations', 451, '756_FO', '756', 3, 0, 5, 0, 1),
(463, '', '756_GO_Cotisations', 'Cotisations', 451, '756_GO', '756', 3, 0, 5, 0, 1),
(464, '', '756_GY_Cotisations', 'Cotisations', 451, '756_GY', '756', 3, 0, 5, 0, 1),
(465, '', '756_KM_Cotisations', 'Cotisations', 451, '756_KM', '756', 3, 0, 5, 0, 1),
(466, '', '756_LO_Cotisations', 'Cotisations', 451, '756_LO', '756', 3, 0, 5, 0, 1),
(467, '', '756_MN_Cotisations', 'Cotisations', 451, '756_MN', '756', 3, 0, 5, 0, 1),
(468, '', '756_MU_Cotisations', 'Cotisations', 451, '756_MU', '756', 3, 0, 5, 0, 1),
(469, '', '756_NL_Cotisations', 'Cotisations', 451, '756_NL', '756', 3, 0, 5, 0, 1),
(470, '', '756_PA_Cotisations', 'Cotisations', 451, '756_PA', '756', 3, 0, 5, 0, 1),
(471, '', '756_PE_Cotisations', 'Cotisations', 451, '756_PE', '756', 3, 0, 5, 0, 1),
(472, '', '756_PI_Cotisations', 'Cotisations', 451, '756_PI', '756', 3, 0, 5, 0, 1),
(473, '', '756_PL_Cotisations', 'Cotisations', 451, '756_PL', '756', 3, 0, 5, 0, 1),
(474, '', '756_RC_Cotisations', 'Cotisations', 451, '756_RC', '756', 3, 0, 5, 0, 1),
(475, '', '756_RO_Cotisations', 'Cotisations', 451, '756_RO', '756', 3, 0, 5, 0, 1),
(476, '', '756_ST_Cotisations', 'Cotisations', 451, '756_ST', '756', 3, 0, 5, 0, 1),
(477, '', '756_TA_Cotisations', 'Cotisations', 451, '756_TA', '756', 3, 0, 5, 0, 1),
(478, '', '756_TE_Cotisations', 'Cotisations', 451, '756_TE', '756', 3, 0, 5, 0, 1),
(479, '', '756_TI_Cotisations', 'Cotisations', 451, '756_TI', '756', 3, 0, 5, 0, 1),
(480, '', '756_TT_Cotisations', 'Cotisations', 451, '756_TT', '756', 3, 0, 5, 0, 1),
(481, '', '756_VO_Cotisations', 'Cotisations', 451, '756_VO', '756', 3, 0, 5, 0, 1),
(482, '', '756_YO_Cotisations', 'Cotisations', 451, '756_YO', '756', 3, 0, 5, 0, 1),
(483, '', '756_ZU_Cotisations', 'Cotisations', 451, '756_ZU', '756', 3, 0, 5, 0, 1),
(484, '', '76_Produits financiers', 'Produits financiers', 444, '76', '7', 3, 0, 3, 0, 1),
(485, '', '77_Produits exceptionnels', 'Produits exceptionnels', 444, '77', '7', 3, 0, 3, 0, 1),
(486, '', '78_Reprises sur amortissements et provisions', 'Reprises sur amortissements et provisions', 444, '78', '7', 3, 0, 3, 0, 1),
(487, '', '79_Transferts de charges', 'Transferts de charges', 444, '79', '7', 3, 0, 3, 0, 1),
(488, '', '8_Comptes spéciaux', 'Comptes spéciaux', 1, '8', '0', 3, 0, 2, 1, 1),
(489, '', '86_Emploi des contributions volontaires en nature', 'Emploi des contributions volontaires en nature', 488, '86', '8', 3, 0, 3, 1, 1),
(490, '', '861_Mise à disposition gratuite de biens (locaux, matériel...)', 'Mise à disposition gratuite de biens (locaux, matériel...)', 489, '861', '86', 3, 0, 4, 1, 1),
(491, '', '861_AS_Mise à disposition gratuite de biens (locaux, matériel...)', 'Mise à disposition gratuite de biens (locaux, matériel...)', 490, '861_AS', '861', 3, 0, 5, 0, 1),
(492, '', '861_AU_Mise à disposition gratuite de biens (locaux, matériel...)', 'Mise à disposition gratuite de biens (locaux, matériel...)', 490, '861_AU', '861', 3, 0, 5, 0, 1),
(493, '', '861_BA_Mise à disposition gratuite de biens (locaux, matériel...)', 'Mise à disposition gratuite de biens (locaux, matériel...)', 490, '861_BA', '861', 3, 0, 5, 0, 1),
(494, '', '861_BX_Mise à disposition gratuite de biens (locaux, matériel...)', 'Mise à disposition gratuite de biens (locaux, matériel...)', 490, '861_BX', '861', 3, 0, 5, 0, 1),
(495, '', '861_CC_Mise à disposition gratuite de biens (locaux, matériel...)', 'Mise à disposition gratuite de biens (locaux, matériel...)', 490, '861_CC', '861', 3, 0, 5, 0, 1),
(496, '', '861_CH_Mise à disposition gratuite de biens (locaux, matériel...)', 'Mise à disposition gratuite de biens (locaux, matériel...)', 490, '861_CH', '861', 3, 0, 5, 0, 1),
(497, '', '861_CP_Mise à disposition gratuite de biens (locaux, matériel...)', 'Mise à disposition gratuite de biens (locaux, matériel...)', 490, '861_CP', '861', 3, 0, 5, 0, 1),
(498, '', '861_CY_Mise à disposition gratuite de biens (locaux, matériel...)', 'Mise à disposition gratuite de biens (locaux, matériel...)', 490, '861_CY', '861', 3, 0, 5, 0, 1),
(499, '', '861_DS_Mise à disposition gratuite de biens (locaux, matériel...)', 'Mise à disposition gratuite de biens (locaux, matériel...)', 490, '861_DS', '861', 3, 0, 5, 0, 1),
(500, '', '861_ES_Mise à disposition gratuite de biens (locaux, matériel...)', 'Mise à disposition gratuite de biens (locaux, matériel...)', 490, '861_ES', '861', 3, 0, 5, 0, 1),
(501, '', '861_FO_Mise à disposition gratuite de biens (locaux, matériel...)', 'Mise à disposition gratuite de biens (locaux, matériel...)', 490, '861_FO', '861', 3, 0, 5, 0, 1),
(502, '', '861_GO_Mise à disposition gratuite de biens (locaux, matériel...)', 'Mise à disposition gratuite de biens (locaux, matériel...)', 490, '861_GO', '861', 3, 0, 5, 0, 1),
(503, '', '861_GY_Mise à disposition gratuite de biens (locaux, matériel...)', 'Mise à disposition gratuite de biens (locaux, matériel...)', 490, '861_GY', '861', 3, 0, 5, 0, 1),
(504, '', '861_KM_Mise à disposition gratuite de biens (locaux, matériel...)', 'Mise à disposition gratuite de biens (locaux, matériel...)', 490, '861_KM', '861', 3, 0, 5, 0, 1),
(505, '', '861_LO_Mise à disposition gratuite de biens (locaux, matériel...)', 'Mise à disposition gratuite de biens (locaux, matériel...)', 490, '861_LO', '861', 3, 0, 5, 0, 1),
(506, '', '861_MN_Mise à disposition gratuite de biens (locaux, matériel...)', 'Mise à disposition gratuite de biens (locaux, matériel...)', 490, '861_MN', '861', 3, 0, 5, 0, 1),
(507, '', '861_MU_Mise à disposition gratuite de biens (locaux, matériel...)', 'Mise à disposition gratuite de biens (locaux, matériel...)', 490, '861_MU', '861', 3, 0, 5, 0, 1),
(508, '', '861_NL_Mise à disposition gratuite de biens (locaux, matériel...)', 'Mise à disposition gratuite de biens (locaux, matériel...)', 490, '861_NL', '861', 3, 0, 5, 0, 1),
(509, '', '861_PA_Mise à disposition gratuite de biens (locaux, matériel...)', 'Mise à disposition gratuite de biens (locaux, matériel...)', 490, '861_PA', '861', 3, 0, 5, 0, 1),
(510, '', '861_PE_Mise à disposition gratuite de biens (locaux, matériel...)', 'Mise à disposition gratuite de biens (locaux, matériel...)', 490, '861_PE', '861', 3, 0, 5, 0, 1),
(511, '', '861_PI_Mise à disposition gratuite de biens (locaux, matériel...)', 'Mise à disposition gratuite de biens (locaux, matériel...)', 490, '861_PI', '861', 3, 0, 5, 0, 1),
(512, '', '861_PL_Mise à disposition gratuite de biens (locaux, matériel...)', 'Mise à disposition gratuite de biens (locaux, matériel...)', 490, '861_PL', '861', 3, 0, 5, 0, 1),
(513, '', '861_RC_Mise à disposition gratuite de biens (locaux, matériel...)', 'Mise à disposition gratuite de biens (locaux, matériel...)', 490, '861_RC', '861', 3, 0, 5, 0, 1),
(514, '', '861_RO_Mise à disposition gratuite de biens (locaux, matériel...)', 'Mise à disposition gratuite de biens (locaux, matériel...)', 490, '861_RO', '861', 3, 0, 5, 0, 1),
(515, '', '861_ST_Mise à disposition gratuite de biens (locaux, matériel...)', 'Mise à disposition gratuite de biens (locaux, matériel...)', 490, '861_ST', '861', 3, 0, 5, 0, 1),
(516, '', '861_TA_Mise à disposition gratuite de biens (locaux, matériel...)', 'Mise à disposition gratuite de biens (locaux, matériel...)', 490, '861_TA', '861', 3, 0, 5, 0, 1),
(517, '', '861_TE_Mise à disposition gratuite de biens (locaux, matériel...)', 'Mise à disposition gratuite de biens (locaux, matériel...)', 490, '861_TE', '861', 3, 0, 5, 0, 1),
(518, '', '861_TI_Mise à disposition gratuite de biens (locaux, matériel...)', 'Mise à disposition gratuite de biens (locaux, matériel...)', 490, '861_TI', '861', 3, 0, 5, 0, 1),
(519, '', '861_TT_Mise à disposition gratuite de biens (locaux, matériel...)', 'Mise à disposition gratuite de biens (locaux, matériel...)', 490, '861_TT', '861', 3, 0, 5, 0, 1),
(520, '', '861_VO_Mise à disposition gratuite de biens (locaux, matériel...)', 'Mise à disposition gratuite de biens (locaux, matériel...)', 490, '861_VO', '861', 3, 0, 5, 0, 1),
(521, '', '861_YO_Mise à disposition gratuite de biens (locaux, matériel...)', 'Mise à disposition gratuite de biens (locaux, matériel...)', 490, '861_YO', '861', 3, 0, 5, 0, 1),
(522, '', '861_ZU_Mise à disposition gratuite de biens (locaux, matériel...)', 'Mise à disposition gratuite de biens (locaux, matériel...)', 490, '861_ZU', '861', 3, 0, 5, 0, 1),
(523, '', '864_Personnel bénévole', 'Personnel bénévole', 489, '864', '86', 3, 0, 4, 1, 1),
(524, '', '864_AS_Personnel bénévole', 'Personnel bénévole', 523, '864_AS', '864', 3, 0, 5, 0, 1),
(525, '', '864_AU_Personnel bénévole', 'Personnel bénévole', 523, '864_AU', '864', 3, 0, 5, 0, 1),
(526, '', '864_BA_Personnel bénévole', 'Personnel bénévole', 523, '864_BA', '864', 3, 0, 5, 0, 1),
(527, '', '864_BX_Personnel bénévole', 'Personnel bénévole', 523, '864_BX', '864', 3, 0, 5, 0, 1),
(528, '', '864_CC_Personnel bénévole', 'Personnel bénévole', 523, '864_CC', '864', 3, 0, 5, 0, 1),
(529, '', '864_CH_Personnel bénévole', 'Personnel bénévole', 523, '864_CH', '864', 3, 0, 5, 0, 1),
(530, '', '864_CP_Personnel bénévole', 'Personnel bénévole', 523, '864_CP', '864', 3, 0, 5, 0, 1),
(531, '', '864_CY_Personnel bénévole', 'Personnel bénévole', 523, '864_CY', '864', 3, 0, 5, 0, 1),
(532, '', '864_DS_Personnel bénévole', 'Personnel bénévole', 523, '864_DS', '864', 3, 0, 5, 0, 1),
(533, '', '864_ES_Personnel bénévole', 'Personnel bénévole', 523, '864_ES', '864', 3, 0, 5, 0, 1),
(534, '', '864_FO_Personnel bénévole', 'Personnel bénévole', 523, '864_FO', '864', 3, 0, 5, 0, 1),
(535, '', '864_GO_Personnel bénévole', 'Personnel bénévole', 523, '864_GO', '864', 3, 0, 5, 0, 1),
(536, '', '864_GY_Personnel bénévole', 'Personnel bénévole', 523, '864_GY', '864', 3, 0, 5, 0, 1),
(537, '', '864_KM_Personnel bénévole', 'Personnel bénévole', 523, '864_KM', '864', 3, 0, 5, 0, 1),
(538, '', '864_LO_Personnel bénévole', 'Personnel bénévole', 523, '864_LO', '864', 3, 0, 5, 0, 1),
(539, '', '864_MN_Personnel bénévole', 'Personnel bénévole', 523, '864_MN', '864', 3, 0, 5, 0, 1),
(540, '', '864_MU_Personnel bénévole', 'Personnel bénévole', 523, '864_MU', '864', 3, 0, 5, 0, 1),
(541, '', '864_NL_Personnel bénévole', 'Personnel bénévole', 523, '864_NL', '864', 3, 0, 5, 0, 1),
(542, '', '864_PA_Personnel bénévole', 'Personnel bénévole', 523, '864_PA', '864', 3, 0, 5, 0, 1),
(543, '', '864_PE_Personnel bénévole', 'Personnel bénévole', 523, '864_PE', '864', 3, 0, 5, 0, 1),
(544, '', '864_PI_Personnel bénévole', 'Personnel bénévole', 523, '864_PI', '864', 3, 0, 5, 0, 1),
(545, '', '864_PL_Personnel bénévole', 'Personnel bénévole', 523, '864_PL', '864', 3, 0, 5, 0, 1),
(546, '', '864_RC_Personnel bénévole', 'Personnel bénévole', 523, '864_RC', '864', 3, 0, 5, 0, 1),
(547, '', '864_RO_Personnel bénévole', 'Personnel bénévole', 523, '864_RO', '864', 3, 0, 5, 0, 1),
(548, '', '864_ST_Personnel bénévole', 'Personnel bénévole', 523, '864_ST', '864', 3, 0, 5, 0, 1),
(549, '', '864_TA_Personnel bénévole', 'Personnel bénévole', 523, '864_TA', '864', 3, 0, 5, 0, 1),
(550, '', '864_TE_Personnel bénévole', 'Personnel bénévole', 523, '864_TE', '864', 3, 0, 5, 0, 1),
(551, '', '864_TI_Personnel bénévole', 'Personnel bénévole', 523, '864_TI', '864', 3, 0, 5, 0, 1),
(552, '', '864_TT_Personnel bénévole', 'Personnel bénévole', 523, '864_TT', '864', 3, 0, 5, 0, 1),
(553, '', '864_VO_Personnel bénévole', 'Personnel bénévole', 523, '864_VO', '864', 3, 0, 5, 0, 1),
(554, '', '864_YO_Personnel bénévole', 'Personnel bénévole', 523, '864_YO', '864', 3, 0, 5, 0, 1),
(555, '', '864_ZU_Personnel bénévole', 'Personnel bénévole', 523, '864_ZU', '864', 3, 0, 5, 0, 1),
(556, '', '87_Contributions volontaires en nature', 'Contributions volontaires en nature', 488, '87', '8', 3, 0, 3, 1, 1),
(557, '', '870_Bénévolat', 'Bénévolat', 556, '870', '87', 3, 0, 4, 1, 1),
(558, '', '870_AS_Bénévolat', 'Bénévolat', 557, '870_AS', '870', 3, 0, 5, 0, 1),
(559, '', '870_AU_Bénévolat', 'Bénévolat', 557, '870_AU', '870', 3, 0, 5, 0, 1),
(560, '', '870_BA_Bénévolat', 'Bénévolat', 557, '870_BA', '870', 3, 0, 5, 0, 1),
(561, '', '870_BX_Bénévolat', 'Bénévolat', 557, '870_BX', '870', 3, 0, 5, 0, 1),
(562, '', '870_CC_Bénévolat', 'Bénévolat', 557, '870_CC', '870', 3, 0, 5, 0, 1),
(563, '', '870_CH_Bénévolat', 'Bénévolat', 557, '870_CH', '870', 3, 0, 5, 0, 1),
(564, '', '870_CP_Bénévolat', 'Bénévolat', 557, '870_CP', '870', 3, 0, 5, 0, 1),
(565, '', '870_CY_Bénévolat', 'Bénévolat', 557, '870_CY', '870', 3, 0, 5, 0, 1),
(566, '', '870_DS_Bénévolat', 'Bénévolat', 557, '870_DS', '870', 3, 0, 5, 0, 1),
(567, '', '870_ES_Bénévolat', 'Bénévolat', 557, '870_ES', '870', 3, 0, 5, 0, 1),
(568, '', '870_FO_Bénévolat', 'Bénévolat', 557, '870_FO', '870', 3, 0, 5, 0, 1),
(569, '', '870_GO_Bénévolat', 'Bénévolat', 557, '870_GO', '870', 3, 0, 5, 0, 1),
(570, '', '870_GY_Bénévolat', 'Bénévolat', 557, '870_GY', '870', 3, 0, 5, 0, 1),
(571, '', '870_KM_Bénévolat', 'Bénévolat', 557, '870_KM', '870', 3, 0, 5, 0, 1),
(572, '', '870_LO_Bénévolat', 'Bénévolat', 557, '870_LO', '870', 3, 0, 5, 0, 1),
(573, '', '870_MN_Bénévolat', 'Bénévolat', 557, '870_MN', '870', 3, 0, 5, 0, 1),
(574, '', '870_MU_Bénévolat', 'Bénévolat', 557, '870_MU', '870', 3, 0, 5, 0, 1),
(575, '', '870_NL_Bénévolat', 'Bénévolat', 557, '870_NL', '870', 3, 0, 5, 0, 1),
(576, '', '870_PA_Bénévolat', 'Bénévolat', 557, '870_PA', '870', 3, 0, 5, 0, 1),
(577, '', '870_PE_Bénévolat', 'Bénévolat', 557, '870_PE', '870', 3, 0, 5, 0, 1),
(578, '', '870_PI_Bénévolat', 'Bénévolat', 557, '870_PI', '870', 3, 0, 5, 0, 1),
(579, '', '870_PL_Bénévolat', 'Bénévolat', 557, '870_PL', '870', 3, 0, 5, 0, 1),
(580, '', '870_RC_Bénévolat', 'Bénévolat', 557, '870_RC', '870', 3, 0, 5, 0, 1),
(581, '', '870_RO_Bénévolat', 'Bénévolat', 557, '870_RO', '870', 3, 0, 5, 0, 1),
(582, '', '870_ST_Bénévolat', 'Bénévolat', 557, '870_ST', '870', 3, 0, 5, 0, 1),
(583, '', '870_TA_Bénévolat', 'Bénévolat', 557, '870_TA', '870', 3, 0, 5, 0, 1),
(584, '', '870_TE_Bénévolat', 'Bénévolat', 557, '870_TE', '870', 3, 0, 5, 0, 1),
(585, '', '870_TI_Bénévolat', 'Bénévolat', 557, '870_TI', '870', 3, 0, 5, 0, 1),
(586, '', '870_TT_Bénévolat', 'Bénévolat', 557, '870_TT', '870', 3, 0, 5, 0, 1),
(587, '', '870_VO_Bénévolat', 'Bénévolat', 557, '870_VO', '870', 3, 0, 5, 0, 1),
(588, '', '870_YO_Bénévolat', 'Bénévolat', 557, '870_YO', '870', 3, 0, 5, 0, 1),
(589, '', '870_ZU_Bénévolat', 'Bénévolat', 557, '870_ZU', '870', 3, 0, 5, 0, 1),
(590, '', '875_Dons en nature', 'Dons en nature', 556, '875', '87', 3, 0, 4, 0, 1),
(591, '', 'Espèces', 'Espèces', 0, 'Espèces', '0', 4, 0, 1, 0, 1),
(592, '', 'Compte courant', 'Compte courant', 0, 'Compte courant', '0', 6, 0, 1, 0, 1),
(593, '', 'Livret A', 'Livret A', 0, 'Livret A', '0', 9, 0, 1, 0, 1),
(594, '', 'SystemPay', 'SystemPay', 0, 'SystemPay', '0', 13, 0, 1, 0, 1);

-- --------------------------------------------------------

--
-- Structure de la table `cpt_CompteBancaire`
--
DROP TABLE IF EXISTS `cpt_CompteBancaire`;

CREATE TABLE `cpt_CompteBancaire` (
  `cpt_ID_Compte` int(11) NOT NULL,
  `cpt_Nom` text,
  `cpt_IBAN` text,
  `cpt_Numero` text,
  `cpt_BIC` text,
  `cpt_TypeCompte` int(11) DEFAULT NULL,
  `cpt_Archive` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Contient toutes les informations relatives aux comptes bancaires';

--
-- Déchargement des données de la table `cpt_CompteBancaire`
--

INSERT INTO `cpt_CompteBancaire` (`cpt_ID_Compte`, `cpt_Nom`, `cpt_IBAN`, `cpt_Numero`, `cpt_BIC`, `cpt_TypeCompte`, `cpt_Archive`) VALUES
(1, 'Espèces', '', '', '', -1, -1),
(2, 'Livret A', '', '', '', -1, -1),
(3, 'Compte courant', '', '', '', -1, -1);

-- --------------------------------------------------------

--
-- Structure de la table `cpt_Mode`
--
DROP TABLE IF EXISTS `cpt_Mode`;

CREATE TABLE `cpt_Mode` (
  `mod_ID_Mode` int(11) DEFAULT NULL,
  `mod_Mode` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Contient tous les modes d''opérations pouvant être réalisés, carte, retrait, chèque ...';

--
-- Déchargement des données de la table `cpt_Mode`
--

INSERT INTO `cpt_Mode` (`mod_ID_Mode`, `mod_Mode`) VALUES
(1, 'Versement'),
(2, 'Virement émis'),
(3, 'Virement reçu'),
(4, 'Prélèvement'),
(5, 'Carte'),
(6, 'Chèque émis'),
(7, 'Dépôt de chèque'),
(8, 'Retrait DAB');

-- --------------------------------------------------------

--
-- Structure de la table `cpt_Operation`
--
DROP TABLE IF EXISTS `cpt_Operation`;

CREATE TABLE `cpt_Operation` (
  `opr_ID_Operation` int(11) NOT NULL,
  `opr_Date_Operation` datetime DEFAULT NULL,
  `opr_Date_Valeur` date DEFAULT NULL,
  `opr_Date_Saisie` date DEFAULT NULL,
  `opr_Num_Transaction` varchar(6) NOT NULL,
  `opr_ID_Mode` int(11) DEFAULT NULL,
  `opr_ID_Tiers` int(11) DEFAULT NULL,
  `opr_NumOperation` int(11) DEFAULT NULL,
  `opr_Commentaire` text,
  `opr_Montant` int(11) DEFAULT NULL,
  `opr_ID_Compte_Source` int(11) DEFAULT NULL,
  `opr_ID_Compte_Cible` int(11) DEFAULT NULL,
  `opr_Ventilation` int(11) DEFAULT NULL,
  `opr_Operation_Ventilee` tinyint(1) NOT NULL,
  `opr_Pointage` varchar(1) DEFAULT NULL,
  `opr_Date_Pointage` date DEFAULT NULL,
  `opr_Assurer_Suivi` tinyint(1) DEFAULT NULL,
  `opr_ID_Tag` int(11) DEFAULT NULL,
  `opr_OperationAnnulee` tinyint(1) DEFAULT NULL,
  `opr_OperationGeneree` tinyint(1) DEFAULT NULL,
  `opr_ViaInternet` tinyint(1) DEFAULT NULL,
  `opr_Transfert` tinyint(1) DEFAULT NULL,
  `opr_Estimation` tinyint(1) DEFAULT NULL,
  `opr_Proprietaire` varchar(10) DEFAULT NULL,
  `opr_ModeTest` tinyint(1) NOT NULL,
  `opr_OperationVentilleValide` tinyint(1) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Contient toutes les opérations, pour tous les comptes (montants en centimes)';

-- --------------------------------------------------------

--
-- Structure de la table `cpt_OperationPlanifiee`
--
DROP TABLE IF EXISTS `cpt_OperationPlanifiee`;

CREATE TABLE `cpt_OperationPlanifiee` (
  `opf_ID_Operation_Planifiee` int(11) NOT NULL,
  `opf_ID_Tiers` int(11) DEFAULT NULL,
  `opf_ID_Categorie` int(11) DEFAULT NULL,
  `opf_Frequence` text,
  `opf_Montant` double DEFAULT NULL,
  `opf_Description` text,
  `opf_Date_Prochain` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Contient la liste des opérations planifiées';

-- --------------------------------------------------------

--
-- Structure de la table `cpt_Tag`
--
DROP TABLE IF EXISTS `cpt_Tag`;

CREATE TABLE `cpt_Tag` (
  `tag_ID_Tag` int(11) NOT NULL,
  `tag_Nom_Tag` text,
  `tag_ID_Tag_Parent` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Contient la liste des Tags utilisés pour les opérations';

-- --------------------------------------------------------

--
-- Structure de la table `cpt_Tag_Associe`
--
DROP TABLE IF EXISTS `cpt_Tag_Associe`;

CREATE TABLE `cpt_Tag_Associe` (
  `taa_ID_Tag_Associe` int(11) NOT NULL,
  `taa_Num_Tag_Associe` int(11) NOT NULL,
  `taa_ID_Tag` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='ML : Description à faire';

-- --------------------------------------------------------

--
-- Structure de la table `cpt_Tiers`
--
DROP TABLE IF EXISTS `cpt_Tiers`;

CREATE TABLE `cpt_Tiers` (
  `tie_ID_Tiers` int(11) NOT NULL,
  `tie_Nom_Tiers` text,
  `tie_Nom_sur_CB` text,
  `tie_Raccourcis_Tiers` text,
  `tie_Visible` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Contient la liste des tiers';

-- --------------------------------------------------------

--
-- Structure de la table `cpt_TypeCatCompte`
--
DROP TABLE IF EXISTS `cpt_TypeCatCompte`;

CREATE TABLE `cpt_TypeCatCompte` (
  `tcc_ID_CatCompte` int(11) NOT NULL,
  `tcc_Nom_CatCompte` text,
  `tcc_Description_CatCompte` text,
  `tcc_ID_CatCompte_Parent` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Contient le type de la catégorie ou du compte, débit, crédit ...';

--
-- Déchargement des données de la table `cpt_TypeCatCompte`
--

INSERT INTO `cpt_TypeCatCompte` (`tcc_ID_CatCompte`, `tcc_Nom_CatCompte`, `tcc_Description_CatCompte`, `tcc_ID_CatCompte_Parent`) VALUES
(1, 'Sans objet', 'Sans objet', 1),
(2, 'Dépense', 'Catégories des dépenses', 1),
(3, 'Revenu', 'Catégories des revenus', 1),
(4, 'Espèces', '', 1),
(5, 'Compte en banque', 'Tout type de compte en banque', 1),
(6, 'Compte courant', 'Compte chèque', 4),
(7, 'Carte bancaire', 'Tout type de carte bancaire', 1),
(8, 'Carte de crédit différé', 'Carte bancaire à débit différé', 6),
(9, 'Compte d\'épargne', 'Livret A, livret développement durable ...', 4),
(10, 'Compte de titres', '', 4),
(11, 'Compte Smartphone', 'Compte utilisant les transactions par smartphone', 1),
(12, 'Retraite', '', 1),
(13, 'Paiement en ligne', 'SystemPay', 6);

--
-- Structure de la table `cpt_CodeActivite`
--
DROP TABLE IF EXISTS `cpt_CodeActivite`;

CREATE TABLE `cpt_CodeActivite` (
  `ca_id_group` int(10) NOT NULL,
  `ca_code` varchar(10) COLLATE utf8_unicode_ci NOT NULL,
  `ca_group_name` varchar(50) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Déchargement des données de la table `cpt_CodeActivite`
--

INSERT INTO `cpt_CodeActivite` (`ca_id_group`, `ca_code`, `ca_group_name`) VALUES
(5, 'AS', 'Adhésion AS'),
(7, 'CP', 'Course à pied'),
(8, 'CH', 'Chorale'),
(9, 'CY', 'Cyclotourisme'),
(10, 'ES', 'Escalade'),
(11, 'FO', 'Football'),
(12, 'GO', 'Golf'),
(13, 'GY', 'Gym-entretien'),
(14, 'KM', 'Krav Maga'),
(16, 'MU', 'Musculation'),
(17, 'PE', 'Peinture-dessin'),
(18, 'NL', 'Nage Libre PLO'),
(19, 'PL1', 'Plongée PL1'),
(20, 'PL2', 'Plongée PL2'),
(22, 'ST', 'Stretching'),
(23, 'TE', 'Tennis'),
(24, 'TI', 'Tir'),
(25, 'TA', 'Tir à l\'arc'),
(26, 'ZU', 'Zumba'),
(28, 'RC', 'Rétro-Cars'),
(29, 'MN', 'Marche Nordique'),
(30, 'DS', 'Danse Sportive'),
(31, 'BO', 'Boxe Française'),
(32, 'PA', 'Padel'),
(33, 'PI1', 'Pilates 17h15'),
(34, 'PI2', 'Pilates 18h15'),
(35, 'BA', 'Badminton'),
(36, 'VO', 'Volley'),
(37, 'TT', 'Tennis de table'),
(38, 'RO', 'Robotique'),
(39, 'YO', 'Yoga'),
(40, 'PI3', 'Pilates 19h15');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `cpt_CatCompte`
--
ALTER TABLE `cpt_CatCompte`
  ADD PRIMARY KEY (`cat_ID_CatCompte`),
  ADD UNIQUE KEY `cat_ID_CatCompte` (`cat_ID_CatCompte`);

--
-- Index pour la table `cpt_CodeActivite`
--
ALTER TABLE `cpt_CodeActivite`
  ADD PRIMARY KEY (`ca_id_group`),
  ADD UNIQUE KEY `ca_code` (`ca_code`);

--
-- Index pour la table `cpt_CompteBancaire`
--
ALTER TABLE `cpt_CompteBancaire`
  ADD PRIMARY KEY (`cpt_ID_Compte`),
  ADD UNIQUE KEY `cpt_ID_Compte` (`cpt_ID_Compte`);

--
-- Index pour la table `cpt_Operation`
--
ALTER TABLE `cpt_Operation`
  ADD PRIMARY KEY (`opr_ID_Operation`),
  ADD UNIQUE KEY `opr_ID_Operation` (`opr_ID_Operation`);

--
-- Index pour la table `cpt_OperationPlanifiee`
--
ALTER TABLE `cpt_OperationPlanifiee`
  ADD PRIMARY KEY (`opf_ID_Operation_Planifiee`),
  ADD UNIQUE KEY `opf_ID_Operation_Planifiee` (`opf_ID_Operation_Planifiee`);

--
-- Index pour la table `cpt_Tag`
--
ALTER TABLE `cpt_Tag`
  ADD PRIMARY KEY (`tag_ID_Tag`),
  ADD UNIQUE KEY `tag_ID_Tag` (`tag_ID_Tag`);

--
-- Index pour la table `cpt_Tag_Associe`
--
ALTER TABLE `cpt_Tag_Associe`
  ADD PRIMARY KEY (`taa_ID_Tag_Associe`,`taa_Num_Tag_Associe`),
  ADD UNIQUE KEY `taa_ID_Tag_Associe` (`taa_ID_Tag_Associe`);

--
-- Index pour la table `cpt_Tiers`
--
ALTER TABLE `cpt_Tiers`
  ADD PRIMARY KEY (`tie_ID_Tiers`),
  ADD UNIQUE KEY `tie_ID_Tiers` (`tie_ID_Tiers`);

--
-- Index pour la table `cpt_TypeCatCompte`
--
ALTER TABLE `cpt_TypeCatCompte`
  ADD PRIMARY KEY (`tcc_ID_CatCompte`),
  ADD UNIQUE KEY `tcc_ID_CatCompte` (`tcc_ID_CatCompte`);

--
-- Index pour la table `tb_systempay_msg`
--
ALTER TABLE `tb_systempay_msg`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `Cle_Msg` (`Cle_Msg`);

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
-- AUTO_INCREMENT pour la table `cpt_CatCompte`
--
ALTER TABLE `cpt_CatCompte`
  MODIFY `cat_ID_CatCompte` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=595;
--
-- AUTO_INCREMENT pour la table `cpt_CompteBancaire`
--
ALTER TABLE `cpt_CompteBancaire`
  MODIFY `cpt_ID_Compte` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT pour la table `cpt_Operation`
--
ALTER TABLE `cpt_Operation`
  MODIFY `opr_ID_Operation` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT pour la table `cpt_OperationPlanifiee`
--
ALTER TABLE `cpt_OperationPlanifiee`
  MODIFY `opf_ID_Operation_Planifiee` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT pour la table `cpt_Tag`
--
ALTER TABLE `cpt_Tag`
  MODIFY `tag_ID_Tag` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT pour la table `cpt_Tiers`
--
ALTER TABLE `cpt_Tiers`
  MODIFY `tie_ID_Tiers` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT pour la table `cpt_TypeCatCompte`
--
ALTER TABLE `cpt_TypeCatCompte`
  MODIFY `tcc_ID_CatCompte` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;
--
-- AUTO_INCREMENT pour la table `tb_systempay_oper`
--
ALTER TABLE `tb_systempay_oper`
  MODIFY `tsp_ID` int(11) NOT NULL AUTO_INCREMENT;COMMIT;

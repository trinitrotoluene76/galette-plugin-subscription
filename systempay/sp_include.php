<?php
//*******************************************************
//	Nom ......... : sp_include.php
//	Role ........ : Contient tous les « define » de ce script. Chaque numéro de define est lié aux ID des messages de la table tsp_systempay_msg.
//					Attention à bien maintenir les valeurs des define en fonction des ID de la table !
//	Date de création : 01/09/2018
//	Date de modification : 
//	Auteur ...... : Marc Labé
//	Version ..... : 1.0 du 19/09/2018
//********************************************************

	define("MSG_NON_TROUVE", 0);
	define("MSG_PAIEMENT_ABANDONNE", 1);
	define("MSG_PAIEMENT_ACCEPTE", 2);
	define("MSG_PAIEMENT_ETE_REFUSE", 3);
	define("MSG_TRANSACTION_ATTENTE_VALIDATION_MANUELLE", 4);
	define("MSG_TRANSACTION_ATTENTE_AUTORISATION", 5);
	define("MSG_TRANSACTION_EXPIREE", 6);
	define("MSG_TRANSACTION_ANNULEE", 7);
	define("MSG_TRANSACTION_ATTENTE_AUTO_VALID", 8);
	define("MSG_TRANSACTION_REMISE_BANQUE", 9);
	define("MSG_PAIEMENT_REALISE_SUCCES", 10);
	define("MSG_COMMERCANT_CONTACTER_BANQUE_PORTEUR", 11);
	define("MSG_PAIEMENT_REFUSE", 12);
	define("MSG_ANNULE_PAR_LE_CLIENT", 13);
	define("MSG_ERREUR_FORMAT_RESULTAT", 14);
	define("MSG_ERREUR_TECHNIQUE", 15);
	define("MSG_PAIEMENT_SIMPLE", 16);
	define("MSG_TRANSACTION_APPROUVEE", 17);
	define("MSG_CONTACTER_EMETTEUR", 18);
	define("MSG_ACCEPTEUR_INVALIDE", 19);
	define("MSG_CONSERVER_CARTE", 20);
	define("MSG_NE_PAS_HONORER", 21);
	define("MSG_CONSERVER_CARTE_SPECIAL", 22);
	define("MSG_APPROUVER_APRES_IDENTIFICATION", 23);
	define("MSG_TRANSACTION_INVALIDE", 24);
	define("MSG_MONTANT_INVALIDE", 25);
	define("MSG_NUMERO_PORTEUR_INVALIDE", 26);
	define("MSG_ERREUR_FORMAT_AUTH", 27);
	define("MSG_IDENTIFIANT_ORGANISME", 28);
	define("MSG_DATE_VALIDITE_DEPASSEE", 29);
	define("MSG_SUSPICION_FRAUDE", 30);
	define("MSG_CARTE_PERDUE", 31);
	define("MSG_CARTE_VOLEE", 32);
	define("MSG_PROVISION_INSUFFISANTE", 33);
	define("MSG_CARTE_ABSENTE", 34);
	define("MSG_TRANSACTION_NON_PERMISE", 35);
	define("MSG_TRANSACTION_INTERDITE", 36);
	define("MSG_DEBIT", 37);
	define("MSG_ACCEPTEUR_DOIT_CONTACTER", 38);
	define("MSG_MONTANT_RETRAIT_HORS_LIMITE", 39);
	define("MSG_REGLES_SECURITE_NON_RESPECTEES", 40);
	define("MSG_REPONSE_NON_PARVENUE", 41);
	define("MSG_ARRET_MOMENTANE", 42);
	define("MSG_EMETTEUR_INACCESSIBLE", 43);
	define("MSG_MAUVAIS_FONCTIONNEMENT", 44);
	define("MSG_TRANSACTION_DUPLIQUEE", 45);
	define("MSG_ECHEANCE_TEMPORISATION", 46);
	define("MSG_SERVEUR_INDISPONIBLE", 47);
	define("MSG_INCIDENT_DOMAINE_INITIATEUR", 48);
	define("MSG_PAIEMENT_GARANTI", 49);
	define("MSG_PAIEMENT_NON_GARANTI", 50);
	define("MSG_SUITE_A_ERREUR", 51);
	define("MSG_GARANTIE_NON_APPLICABLE", 52);
	define("MSG_AUTHENTIFIE_3DS", 53);
	define("MSG_ERREUR_AUTHENTIFICATION", 54);
	define("MSG_AUTHENTIFICATION_IMPOSSIBLE", 55);
	define("MSG_ESSAI_AUTHENTIFICATION", 56);
	define("MSG_NON_RENSEIGNE", 57);
	define("MSG_VALIDATION_MANUELLE", 58);
	define("MSG_VALIDATION_AUTOMATIQUE", 59);
	define("MSG_CONFIGURATION_DEFAUT_BACK_OFFICE_MARCHAND", 60);
	define("MSG_ERREUR_CONFIGURATION_PARA", 61);
	define("MSG_SIGNATURE_VALIDE", 62);
	define("MSG_SIGNATURE_INVALIDE", 63);
	
	define("MSG_TRANSACTION_DEBIT", 64);
	define("MSG_STATUT", 65);
	define("MSG_RESULTAT", 66);
	define("MSG_IDENTIFIANT", 67);
	define("MSG_MONTANT", 68);
	define("MSG_MONTANT_EFFECTIF", 69);
	define("MSG_TYPE_DE_PAIEMENT", 70);
	define("MSG_NUMERO_SEQUENCE", 71);
	define("MSG_RESULTAT_AUTORISATION", 72);
	define("MSG_GARANTIE_PAIEMENT", 73);
	define("MSG_STATUT_3DS", 74);
	define("MSG_DELAI_AVANT_REMISE_EN_BANQUE", 75);
	define("MSG_MODE_VALIDATION", 76);
	define("MSG_REDIRECTION_PLATEFORME", 77);
	define("MSG_TEST", 78);
	define("MSG_PRODUCTION", 79);
	
	define("MSG_REDIRECT_SUCCES", 80);
	define("MSG_REDIRECT_ERREUR", 81);
?>
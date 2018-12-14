<?php
//*******************************************************
//	Nom ......... : sp_notif_joomla.php
//	Role ........ : Ce fichier est donné à titre d’exemple de ce qui doit être fait par Joomla ou Galette, il doit alors être copié
//					dans le répertoire Joomla ou appelé avec des « include » pointant sur ce répertoire.
//					Les « include » de ce fichier désignent le chemin de as_systempay de manière absolue et non relative.
//					Il appelle TraiterNotification, cette procédure analyse les paramètres de retour de SystemPay et 
//					enregistre la transaction en base de données et en compta. Cette procédure renvoie true si la signature est valide
//	Date de création : 01/09/2018
//	Date de modification : 
//	Auteur ...... : Marc Labé
//	Version ..... : 1.0 du 19/09/2018
//********************************************************

	$RepSystemPay = $_SERVER["DOCUMENT_ROOT"].'/systempay_as/';
	include_once($RepSystemPay.'sp_outils.php');
	include_once($RepSystemPay.'sp_include.php');
	include_once($RepSystemPay.'configuration/sp_db_config.php');
	include_once($RepSystemPay.'sp_paiement.php');
	include_once($RepSystemPay.'sp_compta.php');
	include_once($RepSystemPay.'sp_retour_notification.php');

	class sp_Notif_Joomla
	{
		private $mysqli;
		public $MsgErreur;

		function __construct()
		{
			//	Ouverture de la Bdd
			// Connexion à MySQL
			$this->mysqli = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_DATABASE);
			if ($this->UTF8)
			{
				$CharSet = 'utf8mb4';	//	ou 'utf8'
			}
			else
			{
				$CharSet = 'latin1';
			}
			$this->mysqli->set_charset($this->UTF8);

			/* Vérification de la connexion */
			if ($this->mysqli->connect_errno)
			{
				printf("Échec de la connexion : %s\n", $this->mysqli->connect_error);
				$this->MsgErreur .= "Échec de la connexion : ".$this->mysqli->connect_error."\n";
				exit();
			}
		}
	}

	
	$Retour_Notif = new sp_Retour_Notification();
	//	Ajoute une ligne dans la table tb_systempay_oper des transactions effectuées via SystemPay
	//	Ajoute les lignes des ventilations dans la table cpt_Operation
	//	Renvoie la validité de la signature
	$bSignatureOk = $Retour_Notif->TraiterNotification();
	$sp_Outils = new sp_Outils();
	if ($bSignatureOk)
	{
		//	Faire le nécessaire dans les tables Joomla
	}
	else
	{
		$sp_Outils::Ecrire_Log($sp_Outils::getNow(false)."\t"."sp_notif_joomla signature en erreur.");
	}
	
	//	Ecriture de log pour un éventuel débogage
	//	$sp_Outils = new sp_Outils();
	//	$sp_Outils::Ecrire_Log($sp_Outils::getNow(false)."\t"."Outils trouvé");
	//	$sp_Outils::EnvoyerMsgErreurParMail($sp_Outils::getNow(false)."\t"."Outils trouvé");
?>


 
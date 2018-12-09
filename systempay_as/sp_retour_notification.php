<?php
//*******************************************************
//	Nom ......... : sp_retour_notification.php
//	Role ........ : Cette page est appelée par le code développé sous Joomla, sous Galette ou sous tout autre fichier php.
//					Elle est appelée le système de notification de Systempay en fin de paiement.
//					Analyse les données $_REQUEST et vérifie la validité de la transaction renvoyée par SuytemPay.
//					Ecrit en BdD un enregistrement avec les principaux paramètres fournis par SystemPay.
//	Date de création : 01/09/2018
//	Date de modification : 
//	Auteur ...... : Marc Labé
//	Version ..... : 1.0 du 19/09/2018
//********************************************************
	include_once('sp_outils.php');
	include_once('sp_include.php');
	include_once('configuration/sp_db_config.php');
	include_once('sp_paiement.php');
	include_once('sp_compta.php');

	class sp_Retour_Notification
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
		
		public function Existe_Transaction($NumTransaction)
		{
			$this->MsgErreur = '';
			//	Liste de toutes les activitées payées, y compris adhésion AS
			$Select = "SELECT * FROM `tb_systempay_oper` WHERE `tsp_Numero_Transaction`='".$NumTransaction."' ";
			$Result = $this->mysqli->query($Select);
			if ($Result === false)
			{
				$this->MsgErreur .= 'Fonction EcrireToutesSubscriptionsPayees en échec ('.$Select.') : '.$this->mysqli->error."<BR>\n";
			}
			while ($row = $Result->fetch_assoc())
			{
				return true; 
			}
			return false;
		}
		
		public function AjouterPaiement($P)
		//	Fonction testée
		{
			//	Vérifier que l'enregistrement n'a pas déjà été écrit.
			if (!$this->Existe_Transaction($P->mNumero_Transaction))
			{
				if (($P->mMode_Test_Prod == 0) || ($P->mMode_Test_Prod == 'TEST'))
				{
					$P->mMode_Test_Prod = MSG_TEST;
				}
				else
				{
					$P->mMode_Test_Prod = MSG_PRODUCTION;
				}
				
				//	Insertion d'un paiement
				$InsertPaiement = "INSERT INTO `tb_systempay_oper`(`tsp_Mode_Test_Prod`, `tsp_Signature_Ok`, `tsp_Statut_Transaction`, `tsp_Resultat`, `tsp_Montant`, ".
				"`tsp_Montant_Effectif`, `tsp_Paiement_Config`, `tsp_Num_Sequence`, `tsp_Autorisation`, `tsp_Garantie`, `tsp_Threeds`, `tsp_Delai_Avant_Banque`, ".
				"`tsp_Mode_Validation`, `tsp_Numero_Transaction`, `tsp_Reference_Commande`, `tsp_Date_Heure`, ".
				"`tsp_Reference_Acheteur`, `tsp_Nom_Acheteur`, `tsp_Prenom_Acheteur`, `tsp_Email`, ".
				"`tsp_Type`, `tsp_Numero_Autorisation`, `tsp_Order_Info`) VALUES ('".
				$P->mMode_Test_Prod."', ".$P->mSignature_Ok.", ".$P->mStatut_Transaction.", ".$P->mResultat.", ".$P->mMontant.", ".$P->mMontant_Effectif.", ".$P->mPaiement_Config.", ".
				$P->mNum_Sequence.", ".$P->mAutorisation.", ".$P->mGarantie.", ".$P->mThreeds.", ".$P->mDelai_Avant_Banque.", ".$P->mMode_Validation.", ".
				$P->mNumero_Transaction.", '".$P->mReference_Commande."', '".$P->mDate_Heure."', ".$P->mReference_Acheteur.", '".
				$P->mNom_Acheteur."', '".$P->mPrenom_Acheteur."', '".$P->mEmail."', '".$P->mType."', '".$P->mNumero_Autorisation."', '".$P->mOrder_Info."')";
				
				$Result = $this->mysqli->query($InsertPaiement);
				if ($Result === false)
				{
					$this->MsgErreur .= 'Fonction AjouterPaiement en échec ('.$InsertPaiement.') : '.$this->mysqli->error."<BR>\n";
				}
			}
			else
			{
				$this->MsgErreur .= 'La transaction '.$P->mNumero_Transaction.' existe déjà dans la base.';
			}
		}
		
		public function TraiterNotification()
		{
			$sp_Outils = new sp_Outils();
			$MonPaiement = new sp_Paiement();

			$bSignature_Ok = $MonPaiement->Lire_Request();
			
			if ($bSignature_Ok == true)
			{
				$this->AjouterPaiement($MonPaiement);

				$MaCompta = new sp_Compta();
				if ($MaCompta->ConvertirTransactionCompta($MonPaiement->mOrder_Info, $MonPaiement->mDate_Heure, $MonPaiement->mNumero_Transaction, $MonPaiement->mReference_Acheteur, $MonPaiement->mMode_Test_Prod, $MonPaiement->mStatut_Transaction, $MonPaiement->mMontant))
				{
					//	$sp_Outils::Ecrire_Log($sp_Outils::getNow(false)."\t"."ConvertirTransactionCompta Ok.");
				}
				else
				{
					//	Le paiement n'est pas au statut Accepté
					$sp_Outils::Ecrire_Log($sp_Outils::getNow(false)."\t"."ConvertirTransactionCompta est en erreur.");
				}
			}
			else
			{
				//	$sp_Outils::Ecrire_Log($sp_Outils::getNow(false)."\t"."Signature invalide");
			}
			return $bSignature_Ok;
		}
	}

	//	Lignes à appeler par le retour de notification
	//	$Retour_Notif = new sp_Retour_Notification();
	//	$Retour_Notif->TraiterNotification();
?>


 
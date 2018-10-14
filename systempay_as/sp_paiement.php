<?php
//*******************************************************
//	Nom ......... : sp_paiement.php
//	Role ........ : Lit et interprète toutes les informations d'un $_REQUEST de retour de SystemPay et les place dans l'objet 
//	Date de création : 01/09/2018
//	Date de modification : 
//	Auteur ...... : Marc Labé
//	Version ..... : 1.0 du 19/09/2018
//********************************************************

	$RepSystemPay = $_SERVER["DOCUMENT_ROOT"].'/systempay_as/';
	include_once($RepSystemPay.'sp_outils.php');
	include_once($RepSystemPay.'sp_include.php');

	class sp_Paiement
	{
		public $mID;
		public $mMode_Test_Prod;
		public $mPreSignature_Ok;
		public $mSignature_Ok;
		public $mStatut_Transaction;
		public $mResultat;
		public $mMontant;
		public $mMontant_Effectif;
		public $mPaiement_Config;
		public $mNum_Sequence;
		public $mAutorisation;
		public $mGarantie;
		public $mThreeds;
		public $mDelai_Avant_Banque;
		public $mMode_Validation;
		public $mNumero_Transaction;
		public $mReference_Commande;
		public $mDate_Heure;
		public $mReference_Acheteur;
		public $mNom_Acheteur;
		public $mPrenom_Acheteur;
		public $mEmail;
		public $mType;
		public $mNumero_Autorisation;
		public $mOrder_Info;

		function __construct()
		{ 
		}
		
		//	Lit les paramètres en entrée de sp_form_paiement, envoyés par le logiciel et destinés à être envoyés à SystemPay
		//	Vérifie le paramètre Presignature (équivalent de Signature lors de l'envoi à SystemPay)
		public function Lire_Param()
		{ 
			$this->mID = 0;
			// --------------------------------------------------------------------------------------
			// Renseigner la valeur du certificat
			// --------------------------------------------------------------------------------------

			$conf_txt = parse_ini_file(sp_configuration);
			if ($conf_txt['vads_ctx_mode'] == "TEST")
			{
				$MonCertificat = $conf_txt['TEST_key'];
			}
			else
			{
				if ($conf_txt['vads_ctx_mode'] == "PRODUCTION")
				{
					$MonCertificat = $conf_txt['PROD_key'];
				}
			}

			// --------------------------------------------------------------------------------------
			// Contrôle de la signature reçue
			// --------------------------------------------------------------------------------------
			$this->mMode_Test_Prod = $conf_txt['vads_ctx_mode'];
			if (isset($_REQUEST['vads_ctx_mode']))
			{
				//	 Je prends en compte en priorité le mode défini en passage de paramètre
				$this->mMode_Test_Prod = $_REQUEST['vads_ctx_mode'];
			}

			$control = false;
			if (isset($_REQUEST['Presignature']))
			{
				$control = $this->Check_Signature($_REQUEST, $MonCertificat);
			}
			
			if ($control == true)
			{
				$this->mPreSignature_Ok = MSG_PRESIGNATURE_VALIDE;
			}
			else
			{
				$this->mPreSignature_Ok = MSG_PRESIGNATURE_INVALIDE;
			}
			return $control;
		}
		
		public function Lire_Request()
		{ 
			$this->mID = 0;
			// --------------------------------------------------------------------------------------
			// Renseigner la valeur du certificat
			// --------------------------------------------------------------------------------------
			
			$conf_txt = parse_ini_file(sp_configuration);
			if ($conf_txt['vads_ctx_mode'] == "TEST")
			{
				$MonCertificat = $conf_txt['TEST_key'];
			}
			else
			{
				if ($conf_txt['vads_ctx_mode'] == "PRODUCTION")
				{
					$MonCertificat = $conf_txt['PROD_key'];
				}
			}

			// --------------------------------------------------------------------------------------
			// Contrôle de la signature reçue
			// --------------------------------------------------------------------------------------
			$this->mMode_Test_Prod = $conf_txt['vads_ctx_mode'];
			if (isset($_REQUEST['vads_ctx_mode']))
			{
				//	 Je prends en compte en priorité le mode défini en passage de paramètre
				$this->mMode_Test_Prod = $_REQUEST['vads_ctx_mode'];
			}

			$control = false;
			if (isset($_REQUEST['signature']))
			{
				$control = $this->Check_Signature($_REQUEST, $MonCertificat);
			}
			
			if ($control == true)
			{
				$this->mSignature_Ok = MSG_SIGNATURE_VALIDE;
			}
			else
			{
				$this->mSignature_Ok = MSG_SIGNATURE_INVALIDE;
			}
			
			if (isset($_REQUEST['vads_trans_status']))
			{
				$this->mStatut_Transaction = $this->get_Transaction_Status($_REQUEST['vads_trans_status']);
			}
			else
			{
				$this->mStatut_Transaction = 0;
			}			
			
			if (isset($_REQUEST['vads_result']))
			{
				$this->mResultat = $this->get_Resultat($_REQUEST['vads_result']);
			}
			else
			{
				$this->mResultat = 0;
			}
			
			if (isset($_REQUEST['vads_amount']))
			{
				$this->mMontant = $_REQUEST['vads_amount'];
			}
			else
			{
				$this->mMontant = 0;
			}
			
			if (isset($_REQUEST['vads_effective_amount']))
			{
				$this->mMontant_Effectif = $_REQUEST['vads_effective_amount'];
			}
			else
			{
				$this->mMontant_Effectif = 0;
			}
			
			if (isset($_REQUEST['vads_payment_config']))
			{
				$this->mPaiement_Config = $this->get_Payment_Config($_REQUEST['vads_payment_config']);
			}
			else
			{
				$this->mPaiement_Config = 0;
			}
			
			if (isset($_REQUEST['vads_sequence_number']))
			{
				$this->mNum_Sequence = $_REQUEST['vads_sequence_number'];
			}
			else
			{
				$this->mNum_Sequence = 0;
			}
			
			if (isset($_REQUEST['vads_auth_result']))
			{
				$this->mAutorisation = $this->get_Auth_Result($_REQUEST['vads_auth_result']);
			}
			else
			{
				$this->mAutorisation = 0;
			}
			
			if (isset($_REQUEST['vads_warranty_result']))
			{
				$this->mGarantie = $this->get_Warranty_Result($_REQUEST['vads_warranty_result']);
			}
			else
			{
				$this->mGarantie = 0;
			}
			
			if (isset($_REQUEST['vads_threeds_status']))
			{
				$this->mThreeds = $this->get_Threeds_Status($_REQUEST['vads_threeds_status']);
			}
			else
			{
				$this->mThreeds = 0;
			}
			
			if (isset($_REQUEST['vads_capture_delay']))
			{
				$this->mDelai_Avant_Banque = $_REQUEST['vads_capture_delay'];
			}
			else
			{
				$this->mDelai_Avant_Banque = 0;
			}
			
			if (isset($_REQUEST['vads_validation_mode']))
			{
				$this->mMode_Validation = ($_REQUEST['vads_validation_mode'] == 0 ? MSG_VALIDATION_AUTOMATIQUE : MSG_VALIDATION_MANUELLE);
			}
			else
			{
				$this->mMode_Validation = 0;
			}
			
			if (isset($_REQUEST['vads_trans_id']))
			{
				$this->mNumero_Transaction = $_REQUEST['vads_trans_id'];
			}
			else
			{
				$this->mNumero_Transaction = 0;
			}
			
			if (isset($_REQUEST['vads_order_id']))
			{
				$this->mReference_Commande = $_REQUEST['vads_order_id'];
			}
			else
			{
				$this->mReference_Commande = 0;
			}
			
			if (isset($_REQUEST['vads_trans_date']))
			{
				$this->mDate_Heure = $_REQUEST['vads_trans_date']; //	sp_$Ecrire_bd::getNow(true);
			}
			else
			{
				$this->mDate_Heure = 0;
			}
			
			if (isset($_REQUEST['vads_cust_id']))
			{
				$this->mReference_Acheteur = $_REQUEST['vads_cust_id'];
			}
			else
			{
				$this->mReference_Acheteur = 0;
			}
			
			if (isset($_REQUEST['vads_cust_last_name']))
			{
				$this->mNom_Acheteur = $_REQUEST['vads_cust_last_name'];
			}
			else
			{
				$this->mNom_Acheteur = "";
			}
			
			if (isset($_REQUEST['vads_cust_first_name']))
			{
				$this->mPrenom_Acheteur = $_REQUEST['vads_cust_first_name'];
			}
			else
			{
				$this->mPrenom_Acheteur = "";
			}

			if (isset($_REQUEST['vads_cust_email']))
			{
				$this->mEmail = $_REQUEST['vads_cust_email'];
			}	
			else
			{
				$this->mEmail = "";
			}
			
			if (isset($_REQUEST['vads_operation_type']))
			{
				$this->mType = ($_REQUEST['vads_operation_type'] == "DEBIT" ? 37 : 0);
			}
			else
			{
				$this->mType = 0;
			}
			
			if (isset($_REQUEST['vads_auth_number']))
			{
				$this->mNumero_Autorisation = $_REQUEST['vads_auth_number'];
			}
			else
			{
				$this->mNumero_Autorisation = 0;
			}

			if (isset($_REQUEST['vads_order_info']))
			{
				$this->mOrder_Info = $_REQUEST['vads_order_info'];
			}
			else
			{
				$this->mOrder_Info = "";
			}
			return $this->mSignature_Ok;
		}
		//--------------------------------------------------------------------------------------------------------------------
		//	Fonction => calcul de la signature
		//--------------------------------------------------------------------------------------------------------------------
		
		public static function get_Signature($field, $MonCertificat)
		{
			ksort($field); // tri des paramètres par ordre alphabétique
			$contenu_signature = "";
			foreach ($field as $nom => $valeur)
			{
				if(substr($nom,0,5) == 'vads_')
				{
					$contenu_signature .= $valeur."+";
				}
			}
			$contenu_signature .= $MonCertificat;	// On ajoute le certificat à la fin de la chaîne.
			$signature = sha1($contenu_signature);
			return ($signature);
		}

		//--------------------------------------------------------------------------------------------------------------------
		//	Fonction => contrôle de la signature reçue
		//--------------------------------------------------------------------------------------------------------------------
		public function Check_Signature($Liste, $MonCertificat)
		{
			$signature = $this->get_Signature($Liste, $MonCertificat);
			if (isset($Liste['signature']) && ($signature == $Liste['signature']))
			{
				return true;
			}
			return false;
		}

		//--------------------------------------------------------------------------------------------------------------------
		//	Renvoie les valeurs littérales en fonction des mots clés
		//--------------------------------------------------------------------------------------------------------------------
		public static function get_Transaction_Status($sTrans_Status)
		{
			switch ($sTrans_Status)
			{
				case 'ABANDONED':	return MSG_PAIEMENT_ABANDONNE;
				case 'AUTHORISED':	return MSG_PAIEMENT_ACCEPTE;
				case 'REFUSED':		return MSG_PAIEMENT_ETE_REFUSE;
				case 'AUTHORISED_TO_VALIDATE':	return MSG_TRANSACTION_ATTENTE_VALIDATION_MANUELLE;
				case 'WAITING_AUTHORISATION':	return MSG_TRANSACTION_ATTENTE_AUTORISATION;
				case 'EXPIRED':		return MSG_TRANSACTION_EXPIREE;
				case 'CANCELLED':	return MSG_TRANSACTION_ANNULEE;
				case 'WAITING_AUTHORISATION_TO_VALIDATE':	return MSG_TRANSACTION_ATTENTE_AUTO_VALID;
				case 'CAPTURED':	return MSG_TRANSACTION_REMISE_BANQUE;
			}
		}

		//--------------------------------------------------------------------------------------------------------------------
		//	Renvoie les valeurs littérales en fonction des mots clés
		//--------------------------------------------------------------------------------------------------------------------
		public static function get_Resultat($sResult)
		{
			switch ($sResult) 
			{
				case '00':	return MSG_PAIEMENT_REALISE_SUCCES;
				case '02':	return MSG_COMMERCANT_CONTACTER_BANQUE_PORTEUR;
				case '05':	return MSG_PAIEMENT_REFUSE;
				case '05':	return MSG_ANNULE_PAR_LE_CLIENT;
				case '30':	return MSG_ERREUR_FORMAT_RESULTAT;
				case '96':	return MSG_ERREUR_TECHNIQUE;
			}
		}

		//--------------------------------------------------------------------------------------------------------------------
		//	Renvoie les valeurs littérales en fonction des mots clés
		//--------------------------------------------------------------------------------------------------------------------
		public static function get_Payment_Config($sPayment_Config)
		{
			switch ($sPayment_Config) 
			{
				case 'SINGLE':	return MSG_PAIEMENT_SIMPLE;
			}
		}

		//--------------------------------------------------------------------------------------------------------------------
		//	Renvoie les valeurs littérales en fonction des mots clés
		//--------------------------------------------------------------------------------------------------------------------
		public static function get_Auth_Result($sAuth_Result)
		{
			switch($sAuth_Result)
			{
				case '00':	return MSG_TRANSACTION_APPROUVEE;
				case '02':	return MSG_CONTACTER_EMETTEUR;
				case '03':	return MSG_ACCEPTEUR_INVALIDE;
				case '04':	return MSG_CONSERVER_CARTE;
				case '05':	return MSG_NE_PAS_HONORER;
				case '07':	return MSG_CONSERVER_CARTE_SPECIAL;
				case '08':	return MSG_APPROUVER_APRES_IDENTIFICATION;
				case '12':	return MSG_TRANSACTION_INVALIDE;
				case '13':	return MSG_MONTANT_INVALIDE;
				case '14':	return MSG_NUMERO_PORTEUR_INVALIDE;
				case '30':	return MSG_ERREUR_FORMAT_AUTH;
				case '31':	return MSG_IDENTIFIANT_ORGANISME;
				case '33':	return MSG_DATE_VALIDITE_DEPASSEE;
				case '34':	return MSG_SUSPICION_FRAUDE;
				case '41':	return MSG_CARTE_PERDUE;
				case '43':	return MSG_CARTE_VOLEE;
				case '51':	return MSG_PROVISION_INSUFFISANTE;
				case '54':	return MSG_DATE_VALIDITE_DEPASSEE;
				case '56':	return MSG_CARTE_ABSENTE;
				case '57':	return MSG_TRANSACTION_NON_PERMISE;
				case '58':	return MSG_TRANSACTION_INTERDITE;
				case '59':	return MSG_SUSPICION_FRAUDE;
				case '60':	return MSG_ACCEPTEUR_DOIT_CONTACTER;
				case '61':	return MSG_MONTANT_RETRAIT_HORS_LIMITE;
				case '63':	return MSG_REGLES_SECURITE_NON_RESPECTEES;
				case '68':	return MSG_REPONSE_NON_PARVENUE;
				case '90':	return MSG_ARRET_MOMENTANE;
				case '91':	return MSG_EMETTEUR_INACCESSIBLE;
				case '96':	return MSG_MAUVAIS_FONCTIONNEMENT;
				case '94':	return MSG_TRANSACTION_DUPLIQUEE;
				case '97':	return MSG_ECHEANCE_TEMPORISATION;
				case '98':	return MSG_SERVEUR_INDISPONIBLE;
				case '99':	return MSG_INCIDENT_DOMAINE_INITIATEUR;
			}
		}
		
		//--------------------------------------------------------------------------------------------------------------------
		//	Renvoie les valeurs littérales en fonction des mots clés
		//--------------------------------------------------------------------------------------------------------------------
		public static function get_Warranty_Result($sWarranty_Result)
		{
			switch($sWarranty_Result)
			{
				case 'YES':	return MSG_PAIEMENT_GARANTI;
				case 'NO':	return MSG_PAIEMENT_NON_GARANTI;
				case 'UNKNOWN':	return MSG_SUITE_A_ERREUR;
				default:	return MSG_GARANTIE_NON_APPLICABLE;
			}
		}

		//--------------------------------------------------------------------------------------------------------------------
		//	Renvoie les valeurs littérales en fonction des mots clés
		//--------------------------------------------------------------------------------------------------------------------
		public static function get_Threeds_Status($sThreeds_Status)
		{
			switch ($sThreeds_Status)
			{
				case 'Y':	return MSG_AUTHENTIFIE_3DS;
				case 'N':	return MSG_ERREUR_AUTHENTIFICATION;
				case 'U':	return MSG_AUTHENTIFICATION_IMPOSSIBLE;
				case 'A':	return MSG_ESSAI_AUTHENTIFICATION;
				default:	return MSG_NON_RENSEIGNE;
			}
		}

		//--------------------------------------------------------------------------------------------------------------------
		//	Renvoie les valeurs littérales en fonction des mots clés
		//--------------------------------------------------------------------------------------------------------------------
		public static function get_Validation_Mode($sValidation_Mode)
		{
			switch ($Validation_Mode)
			{
				case '1':	return MSG_VALIDATION_MANUELLE;
				case '0':	return MSG_VALIDATION_AUTOMATIQUE;
				default:	return MSG_CONFIGURATION_DEFAUT_BACK_OFFICE_MARCHAND;
			}
		}
	}
?>
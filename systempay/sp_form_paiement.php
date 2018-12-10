<?php
//*******************************************************
//	Nom ......... : sp_form_paiement.php
//	Role ........ : Génération du tableau de tous les champs à envoyer à la plateforme
//					Les champs doivent être encodés en UTF8 obligatoirement - Seuls les champs commençant par vads_xxxx sont envoyés.
//					Renvoie false si erreur du fichier de configuration
//	Date de création : 01/09/2018
//	Date de modification : 
//	Auteur ...... : Marc Labé
//	Version ..... : 1.0 du 19/09/2018
//********************************************************

	include_once('sp_outils.php');
	include_once('sp_include.php');
	include_once('configuration/sp_db_config.php');
	include_once('sp_paiement.php');
	include_once('sp_lire_msg_bd.php');
	
	class sp_Form_Paiement
	{
		public $MsgErreur;
		private $mLang;

		function __construct($Lang)
		{
			//	Initialisation de la langue
			$this->mLang = $Lang;
		}
		
		private function get_Trans_id()
		{
			// Dans cet exemple la valeur du compteur est stocké dans un fichier count.txt,incrémenté de 1 et remis à zéro si la valeur est superieure à 899999
			// ouverture/lock 
			$filename = sNomFichierCompteur;// il faut ici indiquer le chemin du fichier.
			$fp = fopen($filename, 'c+');
			flock($fp, LOCK_EX);

			// lecture/incrémentation
			$count = (int)fread($fp, 6);    // (int) = conversion en entier.
			$count++;
			if($count < 0 || $count > 899999)
			{
				$count = 0;
			}

			// on revient au début du fichier
			fseek($fp, 0);
			ftruncate($fp,0);

			// écriture/fermeture/Fin du lock
			fwrite($fp, $count);
			flock($fp, LOCK_UN);
			fclose($fp);

			// le trans_id : on rajoute des 0 au début si nécessaire
			$trans_id = sprintf("%06d",$count);
			return ($trans_id);
		}

		public function Generer_Forme_Paiement($field, &$form)
		{
			$MsgErreur = '';

			// -----------------------------------------------------------------------------------------------------
			// Chargement de la clé
			// -----------------------------------------------------------------------------------------------------
			$conf_txt = parse_ini_file(sp_configuration);
			
			// -----------------------------------------------------------------------------------------------------
			// Renseignement de $field avec la configuration, écrase les éventuelles valeurs de $_REQUEST
			// -----------------------------------------------------------------------------------------------------
			$params = array();

			//	Recopie de toutes les valeurs lues en fichier de configuration dans le tableau params
			foreach ($conf_txt as $nom => $valeur)
			{
				if(substr($nom,0,5) == 'vads_')
				{
					$params[$nom] = $valeur;
				}
			}
			
			// -----------------------------------------------------------------------------------------------------
			// Renseignement de $params avec $field, et bdd
			// -----------------------------------------------------------------------------------------------------

			$Lire_bd = new sp_Lire_Msg_bd($this->mLang);
			$params['vads_redirect_success_message'] = $Lire_bd->Lire_Message("MSG_REDIRECT_SUCCES");
			$params['vads_redirect_error_message'] = $Lire_bd->Lire_Message("MSG_REDIRECT_ERREUR");
			
			//	Recopie de toutes les valeurs passées en paramètre dans le tableau params
			foreach ($field as $nom => $valeur)
			{
				if(substr($nom,0,5) == 'vads_')
				{
					$params[$nom] = $valeur;
				}
			}
			
			$params['vads_ctx_mode'] = strtoupper($params['vads_ctx_mode']);
			if ($params['vads_ctx_mode'] == "TEST")
			{
				$MonCertificat = $conf_txt['TEST_key'];
			}
			else
			{
				if ($params['vads_ctx_mode'] == "PRODUCTION")
				{
					$MonCertificat = $conf_txt['PROD_key'];
				}
			}

			if (isset($_REQUEST['EuroCts']))
			{
				$bEnEuro = (strtoupper($_REQUEST['EuroCts']) === 'EURO');
				if ($bEnEuro)
				{
					$Montant = $_REQUEST['vads_amount'];
					$Montant = str_replace(',', '.', $Montant);
					$Montant = intval(100 * $Montant);
					$params['vads_amount'] = (string) $Montant;
				}
			}

			// -----------------------------------------------------------------------------------------------------
			// Vérification de la configuration et affichage d'une erreur si sp_configuration.txt n'est pas configuré
			// -----------------------------------------------------------------------------------------------------

			if (($conf_txt['vads_site_id'] == "11111111") || 
				($conf_txt['vads_site_id'] == "") || 
				($MonCertificat == "2222222222222222") || 
				($MonCertificat == "3333333333333333") || 
				($MonCertificat == "") || 
				($params['vads_url_return'] == ""))
			{
				return false;
			}

			$params['vads_trans_id'] = $this->get_Trans_id();
			$params['vads_trans_date'] = gmdate("YmdHis", time());
			
			if (isset($field['langue']))
			{
				$params['langue'] = $field['langue'];
			}

			$MonPaiement  = new sp_Paiement();
			$params['signature'] = $MonPaiement->get_Signature($params, $MonCertificat);
			
			// -----------------------------------------------------------------------------------------------------
			// Création de la forme
			// -----------------------------------------------------------------------------------------------------
			$form = '<form name="pay_form" method="POST" action='.$conf_txt['url_systempay_payment'].'>';	// sp_retour_boutique.php

			// -----------------------------------------------------------------------------------------------------
			// Trie le tableau $params suivant les clés, puis place les valeurs dans la forme
			// -----------------------------------------------------------------------------------------------------

			if (ksort($params))
			{
				foreach ($params as $nom => $valeur)
				{
					$form.='<input type="hidden" name="' . $nom . '" value="' . $valeur . '" />';	
				}
			}
			
			// Redirection vers la page de paiement
			$form.= '</form>';
			$form.= '<script language="JavaScript">document.pay_form.submit();</script>';
			return true;
		}
	
		// -----------------------------------------------------------------------------------------------------
		//	Création du formulaire de paiement encodé en UTF8
		//
		//	Le formulaire de paiement est composé de l'ensemble des champs vads_xxxxx contenu dans le tableau $params 
		//	Celui-ci est envoyé à la plateforme de paiement à l'url suivante (fichier sp_configuration.txt) :
		//	https://paiement.systempay.fr/vads-payment/
		// -----------------------------------------------------------------------------------------------------
		public function Envoyer_Form_Paiement($field)
		{
			$form = "";
			//	 Avant de générer la Form de paiement qui sera envoyée à Systempay, je vérifie la signature des paramètres en entrée
			$MonPaiement = new sp_Paiement();
			//	Lit les paramètres du $_REQUEST et vérifie la signature
			$bSignature_Ok = $MonPaiement->Lire_Param();
			$bSignature_Ok = true;
			if ($bSignature_Ok == true)
			{
				if ($this->Generer_Forme_Paiement($_REQUEST, $form) == false)
				{
					$MonMsg = new sp_Lire_Msg_bd($this->mLang);
					$this->sMsgErreur = $MonMsg->Lire_Message("MSG_ERREUR_CONFIGURATION_PARA");
				}
				else
				{
					//	Ecriture de log pour un éventuel débogage
					//	$sp_Outils = new sp_Outils();
					//	$sp_Outils::Ecrire_Log($sp_Outils::getNow(false)."\t"."Page générée avec succès".$form);	

					//	Envoi de la forme vers le site SystemPay
					echo $form;
				}
			}
			else
			{
				$sp_Outils = new sp_Outils();
				$sp_Outils::Ecrire_Log($sp_Outils::getNow(false)."\t"."La présignature n'est pas valide");	
			}
		}
	}
	
	$langue = "fr";
	if (isset($_REQUEST['vads_language']))
	{
		$langue = $_REQUEST['vads_language'];
	}
	$MaFormePaiement = new sp_Form_Paiement($langue);
	$MaFormePaiement->Envoyer_Form_Paiement($_REQUEST);
?>



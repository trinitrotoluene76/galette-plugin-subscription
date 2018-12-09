<?php
//*******************************************************
//	Nom ......... : sp_retour_boutique.php
//	Role ........ : Ce fichier est donné à titre d’exemple, il peut être appelé lors du retour boutique (voir fichier de configuration ou 
//					configuration du BackOffice ou paramètre de transaction. 
//					En règle générale, Galette ou Joomla auront leurs propres fichiers de retour boutique.
//	Date de création : 01/09/2018
//	Date de modification : 
//	Auteur ...... : Marc Labé
//	Version ..... : 1.0 du 19/09/2018
//********************************************************

	include_once('sp_include.php');
	include_once('sp_outils.php');
	include_once('sp_paiement.php');

	class sp_Retour_Boutique
	{
		function __construct()
		{
		}

		public static function Lire_Fichier_html($sNomFichierHtml)
		{
			// Ouverture du fichier de Log en mode Ajout
			if (file_exists($sNomFichierHtml)) 
			{
				$handle = fopen ($sNomFichierHtml, "r");
				$contents = fread ($handle, filesize ($sNomFichierHtml));
				fclose ($handle);			
				return $contents;
			}
			else
			{
				return "";
			}
		}
		
		protected  function Remplacer($PageHTML, $sNomValeursDebug, $ValeursDebug)
		{
			return str_replace('%'.$sNomValeursDebug.'%', $ValeursDebug, $PageHTML);
		}

		public function Generer_Page_html($MonPaiement)
		{
			$PageHTML = '';
			if (isset($_REQUEST['vads_language']))
			{
				$Langue = '_'.strtolower($_REQUEST['vads_language']);
			}
			else
			{
				$Langue = '_fr';
			}
			if (($MonPaiement->mSignature_Ok === MSG_SIGNATURE_VALIDE) && ($MonPaiement->mStatut_Transaction === MSG_PAIEMENT_ACCEPTE))
			{
				if (!file_exists('retour_boutique_valide'.$Langue.'.html'))
				{
					$Langue = '_fr';
				}
				$PageHTML = $this->Lire_Fichier_html('retour_boutique_valide'.$Langue.'.html');
			}
			else
			{
				if (!file_exists('retour_boutique_abandon'.$Langue.'.html'))
				{
					$Langue = '_fr';
				}
				$PageHTML = $this->Lire_Fichier_html('retour_boutique_abandon'.$Langue.'.html');
			}

			$PageHTML = $this->Remplacer($PageHTML, 'vads_cust_last_name', $MonPaiement->mNom_Acheteur);
			$PageHTML = $this->Remplacer($PageHTML, 'vads_cust_first_name', $MonPaiement->mPrenom_Acheteur);
			$PageHTML = $this->Remplacer($PageHTML, 'vads_cust_email', $MonPaiement->mEmail);
			$sMontant = (string) (((double) $MonPaiement->mMontant)/100.0);
			$sMontant = str_replace('.',',',$sMontant);
			$sMontant .= ' €';
			$PageHTML = $this->Remplacer($PageHTML, 'vads_amount', $sMontant);
			$PageHTML = $this->Remplacer($PageHTML, 'vads_sequence_number', $MonPaiement->mNum_Sequence);
			$PageHTML = $this->Remplacer($PageHTML, 'vads_trans_id', $MonPaiement->mNumero_Transaction);
			$PageHTML = $this->Remplacer($PageHTML, 'vads_order_id', $MonPaiement->mReference_Commande);
			$PageHTML = $this->Remplacer($PageHTML, 'vads_trans_date', $MonPaiement->mDate_Heure);
			$PageHTML = $this->Remplacer($PageHTML, 'vads_auth_number', $MonPaiement->mNumero_Autorisation);
			$PageHTML = $this->Remplacer($PageHTML, 'vads_order_info', $MonPaiement->mOrder_Info);

			if (isset($_REQUEST['vads_cust_id']))
			{
				$PageHTML = $this->Remplacer($PageHTML, 'vads_cust_id', $_REQUEST['vads_cust_id']);
			}
			if (isset($_REQUEST['vads_cust_address']))
			{
				$PageHTML = $this->Remplacer($PageHTML, 'vads_cust_address', $_REQUEST['vads_cust_address']);
			}
			if (isset($_REQUEST['vads_cust_zip']))
			{
				$PageHTML = $this->Remplacer($PageHTML, 'vads_cust_zip', $_REQUEST['vads_cust_zip']);
			}
			if (isset($_REQUEST['vads_cust_city']))
			{
				$PageHTML = $this->Remplacer($PageHTML, 'vads_cust_city', $_REQUEST['vads_cust_city']);
			}
			if (isset($_REQUEST['vads_cust_country']))
			{
				$PageHTML = $this->Remplacer($PageHTML, 'vads_cust_country', $_REQUEST['vads_cust_country']);
			}
			if (isset($_REQUEST['vads_cust_phone']))
			{
				$PageHTML = $this->Remplacer($PageHTML, 'vads_cust_phone', $_REQUEST['vads_cust_phone']);
			}

			$ValeursDebug = '';
			foreach ($_REQUEST as $nom => $valeur)
			{
				if(substr($nom,0,5) == "vads_")
				{
					$ValeursDebug .= '<br>'.$nom.' = '.$valeur.'<br/>';	
				}
			}
			$PageHTML = $this->Remplacer($PageHTML, 'ValeursDebug', $ValeursDebug);
			return $PageHTML;
		}
	}
	
	$MonPaiement = new sp_Paiement();
	$bSignature_Ok = $MonPaiement->Lire_Request();
	
	$MonRetourBoutique = new sp_Retour_Boutique();
	$PageHTML = $MonRetourBoutique->Generer_Page_html($MonPaiement);
	echo ($PageHTML);	
?>

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

	include_once('sp_outils.php');
	include_once('sp_paiement.php');

	class sp_Retour_Boutique
	{
		function __construct()
		{
		}
		
		public function Generer_Page_html($MonPaiement)
		{
			$PageHTML = '<html>';
			$PageHTML .= '<head>';
			$PageHTML .= '<meta http-equiv="Content-Type" content="text/html; charset=utf-8">';
			$PageHTML .= '<title>Redirection_vers_la_boutique</title>';
			$PageHTML .= '<link href="style.css" rel="stylesheet" type="text/css"/>';
			$PageHTML .= '</head>';
			$PageHTML .= '<body>';
			$PageHTML .= '<div id="container">';
			$PageHTML .= '<div class="header_title">Retour à la boutique<br/><br/></div>';
			$PageHTML .= '<div id="Info">';
			$PageHTML .= '<br/><br/><b>Liste des parametres receptionnes :</b><br/>';

			$PageHTML .= 'Mode Test / Production = '.$MonPaiement->mMode_Test_Prod.'<br/>';
			$PageHTML .= 'Validité signature = '.$MonPaiement->mSignature_Ok.'<br/>';
			$PageHTML .= 'Statut transaction = '.$MonPaiement->mStatut_Transaction.'<br/>';
			$PageHTML .= 'Résultat = '.$MonPaiement->mResultat.'<br/>';
			$PageHTML .= 'Montant = '.$MonPaiement->mMontant.'<br/>';
			$PageHTML .= 'Montant effectif = '.$MonPaiement->mMontant_Effectif.'<br/>';
			$PageHTML .= 'Paiement config = '.$MonPaiement->mPaiement_Config.'<br/>';
			$PageHTML .= 'Numéro séquence = '.$MonPaiement->mNum_Sequence.'<br/>';
			$PageHTML .= 'Autorisation = '.$MonPaiement->mAutorisation.'<br/>';
			$PageHTML .= 'Garantie = '.$MonPaiement->mGarantie.'<br/>';
			$PageHTML .= '3D Secure = '.$MonPaiement->mThreeds.'<br/>';
			$PageHTML .= 'Délai avant banque = '.$MonPaiement->mDelai_Avant_Banque.'<br/>';
			$PageHTML .= 'Mode validation = '.$MonPaiement->mMode_Validation.'<br/>';
			$PageHTML .= 'Numéro transaction = '.$MonPaiement->mNumero_Transaction.'<br/>';
			$PageHTML .= 'Référence commande = '.$MonPaiement->mReference_Commande.'<br/>';
			$PageHTML .= 'Date = '.$MonPaiement->mDate_Heure.'<br/>';
			$PageHTML .= 'Référence acheteur = '.$MonPaiement->mReference_Acheteur.'<br/>';
			$PageHTML .= 'Nom acheteur = '.$MonPaiement->mNom_Acheteur.'<br/>';
			$PageHTML .= 'Prénom acheteur = '.$MonPaiement->mPrenom_Acheteur.'<br/>';
			$PageHTML .= 'Mail = '.$MonPaiement->mEmail.'<br/>';
			$PageHTML .= 'Type = '.$MonPaiement->mType.'<br/>';
			$PageHTML .= 'Numéro autorisation = '.$MonPaiement->mNumero_Autorisation.'<br/>';
			$PageHTML .= 'Order info = '.$MonPaiement->mOrder_Info.'<br/>';
			$PageHTML .= 'Signature = '.$_REQUEST['signature'].'<br/>';
			if (isset($_REQUEST['langue']))
			{
				$PageHTML .= 'Langue = '.$_REQUEST['langue'].'<br/>';
			}
			$PageHTML .= '<br/><br/>';
			foreach ($_REQUEST as $nom => $valeur)
			{
				if(substr($nom,0,5) == "vads_")
				{
					$PageHTML .= $nom.' = '.$valeur.' <br/>';	
				}
			}

			$PageHTML .= '</div></div></body></html>';
			return $PageHTML;
		}
	}
	
	$MonPaiement = new sp_Paiement();
	$bSignature_Ok = $MonPaiement->Lire_Request();
	
	$MonRetourBoutique = new sp_Retour_Boutique();
	$PageHTML = $MonRetourBoutique->Generer_Page_html($MonPaiement);
	echo ($PageHTML);
?>

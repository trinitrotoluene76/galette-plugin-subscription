<?php
//*******************************************************
//	Nom ......... : sp_compta.php
//	Role ........ : Interprète le champ « vads_order_info » du $_REQUEST de retour de notification SystemPay 
//					et les génère les lignes de comptabilité correspondantes dans la table tb_systempay_oper. 
//	Date de création : 01/09/2018
//	Date de modification : 
//	Auteur ...... : Marc Labé
//	Version ..... : 1.0 du 19/09/2018
//********************************************************

	include_once('sp_outils.php');
	include_once('sp_include.php');
	include_once('configuration/sp_db_config.php');

	class sp_Compta
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
			//	Ce mécanisme sera mis en oeuvre, si desgénérations de transactions intempestives ont lieu.
			//	Par exemple, renvoi de la notification à partir du Backend Systempay
			return false;
/*			
			//	Code à réactiver si nécessaire
			$this->MsgErreur = '';
			//	Liste de toutes les activitées payées, y compris adhésion AS
			$Select = "SELECT * FROM `cpt_Operation` WHERE `opr_Num_Transaction`='".$NumTransaction."' ";
			$Result = $this->mysqli->query($Select);
			if ($Result === false)
			{
				$this->MsgErreur .= 'Fonction Existe_Transaction en échec ('.$Select.') : '.$this->mysqli->error."<BR>\n";
			}
			while ($row = $Result->fetch_assoc())
			{
				return true; 
			}
			return false;
*/
		}

		public function AjouterPaiement($Date_Operation, $Num_Transaction, $ID_Tiers, $Commentaire, $Montant, $ID_Compte_Source, $ID_Compte_Cible, $NumVentilation, $Operation_Ventilee, $Proprietaire, $ModeTest, $bOperationVentileeValide)
		{
			$sp_Outils = new sp_Outils();
			if ($ModeTest == MSG_TEST)
			{
				$bModeTest = true;
			}
			else
			{
				$bModeTest = false;
			}

			//	exemple : vads_order_info = ga|756_BF_4500/756_AS_2400|Ligne de commentaire
			//	Vérifier que l'enregistrement n'a pas déjà été écrit.
			if (!$this->Existe_Transaction('0'))
			{
				$Date_Valeur = $Date_Operation;
				$Date_Saisie = $sp_Outils->getNow(true);
				$ID_Mode = 3;	//	Virement reçu
				$NumOperation = 0;
				$Pointage = '';
				$Date_Pointage = 'null';
				$Assurer_Suivi = 0;
				$ID_Tag = 0;
				$OperationAnnulee = 0;
				$OperationGeneree = 1;
				$ViaInternet = 1;
				$Transfert = 0;
				$Estimation = 0;
				//	Insertion d'un paiement
				$InsertPaiement = "INSERT INTO `cpt_Operation` (`opr_Date_Operation`, `opr_Date_Valeur`, `opr_Date_Saisie`, `opr_Num_Transaction`, `opr_ID_Mode`, `opr_ID_Tiers`, ".
					"`opr_NumOperation`, `opr_Commentaire`, `opr_Montant`, `opr_ID_Compte_Source`, `opr_ID_Compte_Cible`, `opr_Ventilation`,  `opr_Operation_Ventilee`, `opr_Pointage`, ".
					"`opr_Date_Pointage`, `opr_Assurer_Suivi`, `opr_ID_Tag`, `opr_OperationAnnulee`, `opr_OperationGeneree`, `opr_ViaInternet`, `opr_Transfert`, `opr_Estimation`, `opr_Proprietaire`, `opr_ModeTest`, `opr_OperationVentilleValide`) VALUES (";
				$InsertPaiement .= "'".$Date_Operation."', '".$Date_Valeur."', '".$Date_Saisie."', '".$Num_Transaction."', ".$ID_Mode.", ".$ID_Tiers.", ".
					$NumOperation.", '".$Commentaire."', ".$Montant.", ".$ID_Compte_Source.", ".$ID_Compte_Cible.", ".$NumVentilation.", ".$Operation_Ventilee.", '".$Pointage."', '".
					$Date_Pointage."', ".$Assurer_Suivi.", ".$ID_Tag.", ".$OperationAnnulee.", ".$OperationGeneree.", ".$ViaInternet.", ".$Transfert.", ".$Estimation.", '".$Proprietaire."', ".$bModeTest.", ".$bOperationVentileeValide.")";

				//	$sp_Outils::Ecrire_Log($sp_Outils::getNow(false)."\t"."InsertPaiement : ".$InsertPaiement);
			
				$Result = $this->mysqli->query($InsertPaiement);
				if ($Result === false)
				{
					$this->MsgErreur .= 'Fonction Insert_Paiement en échec ('.$InsertPaiement.') : '.$this->mysqli->error."<BR>\n";
				}
			}
			else
			{
				$this->MsgErreur .= 'La transaction '.$Num_Transaction.' existe déjà dans la base.';
			}
		}
		
		public function GetNumVentilation()
		{
			$iNumIncrement = 1;
			//	SELECT auto_increment FROM information_schema.tables WHERE table_schema = 'asnextersql' AND table_name='cpt_operation'	Ne fonctionne pas sous OVH
			$Select = "SELECT MAX(`opr_Ventilation`) as `MaxID` FROM `cpt_Operation`";
			$Result = $this->mysqli->query($Select);
			if ($Result === false)
			{
				$this->MsgErreur .= 'Fonction GetNumVentilation en échec ('.$Select.') : '.$this->mysqli->error.'<BR>';
			}
			else
			{
				while($Row = $Result->fetch_assoc())
				{
					$iNumIncrement = $Row['MaxID']+1;
				}
			}
			return $iNumIncrement;
		}
		
		public function CalculerIDCompte($CodeCompta, $CodeSection)
		{
			//	TODO : ML : Fonction à modifier car particulière à notre asso et au nom raccourci des sections
			$CodeRaccourci = $CodeCompta."_".$CodeSection;
			
			$Select = "SELECT `cat_ID_CatCompte` as `ID_CatCompte` FROM `cpt_CatCompte` where `cat_Raccourcis_CatCompte`='".$CodeRaccourci."'";
			$Result = $this->mysqli->query($Select);
			if ($Result === false)
			{
				$this->MsgErreur .= 'Fonction CalculerIDCompte en échec ('.$Select.') : '.$this->mysqli->error.'<BR>';
				$sp_Outils = new sp_Outils();
				$sp_Outils->Ecrire_Log($sp_Outils->getNow(false)."\t"."Erreur : la section budgétaire n'a pas été trouvée"."\t".$Select);
			}
			else
			{
				while($Row = $Result->fetch_assoc())
				{
					return $Row['ID_CatCompte'];
				}
			}
			return 0;
		}
		
		public function GetCodeActivite($Numcode)
		{
			//	Ce mécanisme sera mis en oeuvre, si desgénérations de transactions intempestives ont lieu.
			//	Par exemple, renvoi de la notification à partir du Backend Systempay
			$this->MsgErreur = '';
			//	Code de l'activité en fonction de son ID sous Galette
			$Select = 'SELECT `ca_code` FROM `cpt_CodeActivite` where `ca_id_group`='.$Numcode;
			$Result = $this->mysqli->query($Select);
			if ($Result === false)
			{
				$this->MsgErreur .= 'Fonction GetCodeActivite en échec ('.$Select.') : '.$this->mysqli->error."<BR>\n";
			}
			while ($row = $Result->fetch_assoc())
			{
				return $row['ca_code']; 
			}
			return 'ADU'.$Numcode;
		}

		public function ConvertirTransactionCompta($Order_Info, $Date_Operation_vads, $Num_Transaction, $ID_Tiers, $ModeTest, $Statut, $MontantTotal)
		{
			$sp_Outils = new sp_Outils();

			if ($Statut != MSG_PAIEMENT_ACCEPTE)
			{
				return false;
			}
			
			//	Remplir $Order_Info si la variable est vide
			if (isset($Order_Info))
			{
				$Order_Info = trim($Order_Info);
			}
			else
				$Order_Info = '';
			
			if (strlen($Order_Info) == 0)
			{
				$Order_Info = 'NC|001_ADU_'.$MontantTotal.'|';
			}
			
			//	exemple : vads_order_info = ga|756_BX_4500/756_AS_2400|Ligne de commentaire
			$Info = explode("|", $Order_Info);
			$Proprietaire = $Info[0]; //	ga ou jo ou test (Galette ou Joomla)
			if (isset($Info[1]))
				$Ventilation = $Info[1];	//	Lignes ventilées

			//	Affecte par défaut un code comptable vide et le montant total
			if ((!isset($Ventilation)) || ((isset($Ventilation)) && (strlen($Ventilation) == 0)))
				$Ventilation = '001_ADU_'.$MontantTotal;

			if (isset($Info[2]))
				$Commentaire = $Info[2];
			$ListeVentil = explode("/", $Ventilation);
			
			//	Convertit la date de type SystemPay en une date de type MySQL
			$Date_Operation = $this->Convertir_vadsDate($Date_Operation_vads);
			//	Récupère un nouveau numéro de ventilation, 
			$NumVentilation = $this->GetNumVentilation();
			$Operation_Ventilee = (count($ListeVentil)> 1) ? 1 : 0;
			$MontantTotalCalcule = 0;
			$iIndice = 0;
			$bOperationVentileeValide = 1;
			
			foreach ($ListeVentil as $keyValue)
			{
				$TransactionVentil = explode("_", $keyValue);
				$CodeCompta = $TransactionVentil[0];
				$CodeSection = $TransactionVentil[1];
				//	Si $CodeSection est composé de lettres, je le conserve, s'il est composé de chiffres, il s'agit d'un code d'activité Galette, je le convertis
				if (is_numeric($CodeSection))
				{
					$CodeSection = $this->GetCodeActivite($CodeSection);
				}
				$Montant = $TransactionVentil[2];
				$MontantTotalCalcule += $Montant;
				
				//	TODO : ML : passer ces valeurs en configuration ou paramètre
				$ID_Compte_Source = 560;	//	Compte courant
				$ID_Compte_Cible = $this->CalculerIDCompte($CodeCompta, $CodeSection);
				
				//	Si la somme des opérations ventilées n'est pas égale à la somme totale de l'opération, il faut écrire l'erreur en BdD
				if (($MontantTotalCalcule != $MontantTotal) && ($iIndice == count($ListeVentil)-1))
				{
					$bOperationVentileeValide = 0;
				}

				$this->AjouterPaiement($Date_Operation, $Num_Transaction, $ID_Tiers, $Commentaire, $Montant, $ID_Compte_Source, $ID_Compte_Cible, $NumVentilation, $Operation_Ventilee, $Proprietaire, $ModeTest, $bOperationVentileeValide);
				$iIndice++;
			}
			return true;
		}
		
		public function Convertir_vadsDate($vadsDate)
		{
			//	20180825052806
			$Annee = substr($vadsDate, 0, 4); 
			$Mois = substr($vadsDate, 4, 2); 
			$Jour = substr($vadsDate, 6, 2); 
			$Heure = substr($vadsDate, 8, 2); 
			$Minute = substr($vadsDate, 10, 2); 
			$Seconde = substr($vadsDate, 12, 2);
			return $Annee.'-'.$Mois.'-'.$Jour.' '.$Heure.':'.$Minute.':'.$Seconde;
		}
	}

	//	Ecriture sur sortie pour un éventuel débogage
	//	Echo $sp_Outils->getNow(false)."\t"."Page de compta de SystemPay.<BR>"."\r\n";
?>


 
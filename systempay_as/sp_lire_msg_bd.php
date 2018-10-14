<?php
//*******************************************************
//	Nom ......... : sp_lire_msg_bd.php
//	Role ........ : Lit les messages fournis par la documentation SystemPay en français ou en anglais dans la BdD
//					Si le message n'est pas trouvé, renvoie le numéro du message initialement demandé
//					Les messages d'erreurs sont cumulatifs, et s'il y a des erreurs rencontrées, celles-ci sont envoyées par mail 
//					en fonction des information configurées en tête de fichier
//	Date de création : 01/09/2018
//	Date de modification : 
//	Auteur ...... : Marc Labé
//	Version ..... : 1.0 du 19/09/2018
//********************************************************

	$RepSystemPay = $_SERVER["DOCUMENT_ROOT"].'/systempay_as/';
	include_once($RepSystemPay.'configuration/sp_db_config.php');

	class sp_Lire_Msg_bd
	{
		private $mLang;
		public $MsgErreur;
		
		function __construct($Lang)
		{
			//	Initialisation de la langue
			$this->mLang = $Lang;
			$this->MsgErreur = '';
			
			//	Ouverture de la Bdd
			include_once ('./configuration/sp_db_config.php');
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
				$this->MsgErreur .= "Échec de la connexion : ".$this->mysqli->connect_error."\n";
				exit();
			}
		}

		public function Lire_Message($sCle)
		//	Fonction testée
		{
			$this->MsgErreur = '';
			//	Liste de toutes les activitées payées, y compris adhésion AS
			$Select = "SELECT `".$this->mLang."` FROM `tb_systempay_msg` WHERE `Cle_Msg`='".$sCle."' ";
			$Result = $this->mysqli->query($Select);
			if ($Result === false)
			{
				$this->MsgErreur .= 'Fonction EcrireToutesSubscriptionsPayees en échec ('.$Select.') : '.$this->mysqli->error."<BR>\n";
			}
			while ($row = $Result->fetch_assoc())
			{
				return $row[$this->mLang]; 
			}
			return "Msg non trouvé / Msg not found : ".$sCle;
		}
	}
?>
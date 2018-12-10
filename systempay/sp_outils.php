<?php
//*******************************************************
//	Nom ......... : sp_outils.php
//	Role ........ : Contient les fonctions statiques, de débogage, envoi de mail, de formatage de dates, hors fonctions liées à systempay
//	Date de création : 01/09/2018
//	Date de modification : 
//	Auteur ...... : Marc Labé
//	Version ..... : 1.0 du 19/09/2018
//********************************************************

	include_once('configuration/sp_db_config.php');

	//	class entièrement static
	class sp_Outils
	{
		public static function Ecrire_Log($sMsg)
		{
			// Ouverture du fichier de Log en mode Ajout
			if (is_writable(sNomFichierLog)) 
			{
				$fp = fopen(sNomFichierLog, 'a+');
				// écriture/fermeture/Fin du lock
				fwrite($fp, $sMsg."\n");
				fclose($fp);
			}
		}
		
		protected static function ChercherBaliseHTML($Message)
		{
			return (stristr($Message, 'html') !== false); 
		}
		
		public static function EnvoyerMail($Destinataire, $Message, $bSilence = false)
		//	Fonction EnvoyerMail : envoyer un message à un destinataire, utilisé notamment pour envoyer les messages d'erreurs rencontrées 
		//	Si bModeSilence est défini à true, la fonction n'affiche aucun message d'erreur si le mail n'a pas pu être envoyé.
		{
			$to = $Destinataire;  
			$from  = "noreply@asnexter.fr";  

			$jour  = date("d/m/Y");
			$heure = date("H:i");

			$sujet = "Notification de paiement SystemPay - $jour $heure";

			if (self::ChercherBaliseHTML($Message))
			{
				$contenu = $Message;
			}
			else
			{
				$contenu = "";
				$contenu .= "<html> \n";
				$contenu .= "<head> \n";
				$contenu .= "<title> Subject </title> \n";
				$contenu .= "</head> \n";
				$contenu .= "<body> \n";
				$contenu .= "<br>$Message<br> \n";
				$contenu .= "</body> \n";
				$contenu .= "</HTML> \n";
			}

			$headers  = "MIME-Version: 1.0 \n";
			$headers .= "Content-Transfer-Encoding: 8bit \n";
			$headers .= "Content-type: text/html; charset=utf-8 \n";
			$headers .= "From: $from  \n";

			$verif_envoi_mail = TRUE;

			$verif_envoi_mail = @mail($to, $sujet, $contenu, $headers);
				
			if ($verif_envoi_mail === FALSE) 
			{
				if (!bModeSilence)
				{
					$errorMessage = error_get_last()['message'];
					echo "Erreur de l'envoi du Mail, ".$errorMessage."<br> \n";
				}
				return false;
			}
			else
			{
				if ((!bModeSilence) && ($bSilence === false))
				{
					echo "Envoi du Mail - avec succ&egrave;s de ".$from." vers ".$to." <br> sujet: ".$sujet." \n"; 
				}
				return true;
			}
		}
		
		public static function getNow($FormatMySQL)
		//	Fonction getNow : Renvoie la date  du jour (au format BdD MySQL $FormatMySQL = true -> Y-m-d sinon jj/mm/aaaa)
		{
			//	Au format MySQL
			if ($FormatMySQL === true)
			{
				return date("Y-m-d"); 
			}
			else
			{
				return date("d/m/Y H:i:s"); 
			}
		}

		public static function EnvoyerMsgErreurParMail($MsgErreur)
		//	Fonction : EnvoyerMsgErreurParMail : envoie un message avec les erreurs détectées si $bEnvoyerMail est à vrai
		{
			if (strlen($MsgErreur) > 0)
			{
				if (bEnvoyerMail)
				{
					self::EnvoyerMail(DestinataireMail, "Erreur lors de la notification de paiement SystemPay à ".self::getNow(false)."<BR>\n".$MsgErreur, false);
				}
			}
		}

		public static function ChaineEnDate($sDate, $Fr)
		{
			if ($Fr)
			{
				$sDate = str_replace("/", "-", $sDate);
				$FormatFr4Y = 'j-m-Y';
				$FormatFr2Y = 'j-m-y';
			}
			else
			{
				$FormatFr4Y = 'Y-m-d';
				$FormatFr2Y = 'y-m-d';
			}

			$DateConvertie = date_create_from_format($FormatFr4Y, $sDate);
			$Annee = date_format($DateConvertie, 'Y');
			if (($DateConvertie == "") || ($Annee < 1970))	//	Cas où l'année est sur 2 caractères
			{
				$DateConvertie = date_create_from_format($FormatFr2Y, $sDate);
			}
			return $DateConvertie;
		}
	}
?>
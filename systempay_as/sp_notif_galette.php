<?php
/**
 * sp_notif_galette for for galette Subscription plugin
 *
 * PHP version 5
 *
 * Copyright © 2009-2016 The Galette Team
 *
 * This file is part of Galette (http://galette.tuxfamily.org).
 *
 * Galette is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Galette is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Galette. If not, see <http://www.gnu.org/licenses/>.
 */
define('GALETTE_BASE_PATH', '../../../');
require_once GALETTE_BASE_PATH . 'includes/galette.inc.php';
use Galette\Entity\Adherent as Adherent;
use Galette\Entity\Group as Group;
use Galette\Core\GaletteMail as GaletteMail;
use Galette\Entity\Contribution as Contribution;
require_once '../_config.inc.php';
 
include_once('sp_outils.php');
include_once('sp_include.php');
include_once('configuration/sp_db_config.php');
include_once('sp_paiement.php');
include_once('sp_compta.php');
include_once('sp_retour_notification.php');

	//activation du traitement si notification du serveur https://paiement.systempay.fr/vads-payment/
	if (isset($_POST["vads_trans_status"]))
		{

		$Retour_Notif = new sp_Retour_Notification();
		//	Ajoute une ligne dans la table tb_systempay_oper des transactions effectuées via SystemPay
		//	Ajoute les lignes des ventilations dans la table cpt_Operation
		//	Renvoie la validité de la signature
		
		//Controle de la signature
		$bSignatureOk = $Retour_Notif->TraiterNotification();
		if ($bSignatureOk)
			{
			//	Faire le nécessaire dans les tables Galette si transaction valide et concerne Galette
			if($_POST['vads_trans_status']=="AUTHORISED" && substr($_POST["vads_order_info"],0,2)=="GA")
				{
				//recopie de management_subs2.php pour la partie "payé"
				//récupération des données liées à l'abonnement:
				$id_adh=$_POST["vads_cust_id"];
				$id_abn=$_POST["vads_order_id"];
				
				//rechercher les infos complémentaires de la transaction dans notre table "tb_systempay_oper", champ "tsp_Numero_Transaction"
				$_POST["vads_trans_id"];
				$montant=$_POST["vads_amount"]/100;
				$date_trans= DateTime::createFromFormat('YmdHis', $_POST["vads_trans_date"]);//20140902094139
				
				//pour chaque activité, on va mettre à jour le statut, le feedback de l'activité et envoyer un mail de synthèse
				//autorise le dl de carte membre via une contribution factice d'un 1an à 1€
				//on ajoute le membre dans le group correspondant
				
					//Extraction de l'identifiant de l'activité:
						//nettoyage du champ vads_order_info= GA|756_id_act_12,00/756_id_act_55,00/|
						$vads_order_info=substr($_POST["vads_order_info"],0,-2);
						$vads_order_info=substr($vads_order_info,3);
					$ListeVentil = explode("/", $vads_order_info);
					$List_sections="";
					foreach ($ListeVentil as $keyValue)
						{
						$TransactionVentil = explode("_", $keyValue);
						$id_act = $TransactionVentil[1];
						
						//copier coller d'une partie du code de management_subs2.php
						$followup=new Followup;
						$followup->id_act=$id_act;
						$followup->id_adh=$id_adh;
						$followup->id_abn=$id_abn;
						$followup->getFollowup($followup);
						
						$followup->feedback_act=$followup->feedback_act."\nTransaction en ligne N°".$_POST["vads_trans_id"]." de ".$montant." € "."le ".$date_trans->format("d/m/Y");
						$followup->statut_act=2;//payé
						$followup->store($followup);
						
						//ajout du membre dans le groupe
						$followup->put_into_group($followup);
						//création de la contribution pour pouvoir dl sa carte depuis son profil. (autant de contribution que de click payé)
							//type=1= cotisation annuelle
							//_payment_type=1 espece, 3 cheque...6 autre.
							$args = array(
								'type'  => '1',
								'payment_type'  => '6',
								'adh'   => $id_adh
							); 
							if ( $preferences->pref_membership_ext != '' ) {
								$args['ext'] = $preferences->pref_membership_ext;
							}
							$contrib = new Contribution($args);
							$contrib->__set(amount,1);//montant contribution factice
							$contrib->store();
						
						//récupération du nom des sections pour le mail
						$group = new Group();
						$group->load($id_act);//value = id_group
						$List_sections=$List_sections.$group->getName().",\n";
						}//fin du for
					
					//----->ENVOI de l'email
						if($preferences->pref_mail_method != GaletteMail::METHOD_DISABLED)
							{
							//récupération des infos de l'adhérent à valider
							$adherent=new Adherent();
							$adherent->load($id_adh);
							$sname1=$adherent->surname." ".$adherent->name;
												
								if ( GaletteMail::isValidEmail($adherent->email) ) 
									{
									$mail = new GaletteMail();
									$mail->setSubject("[".$preferences->pref_nom."] Confirmation de paiement en ligne de l'abonnement N°".$id_abn);
									$mail->setRecipients(
										array(
											$adherent->email => $sname1
										)
									);
									$proto = 'http';
									if ( isset($_SERVER['HTTPS']) ) {
										$proto = 'https';
									}
									
									$mail->html=true;
					
									//création du code pour pouvoir télécharger sa carte d'adhérent depuis le mail
									//génération des données à passer dans l'url (get ?code=): 
									//http://localhost/galette_amaury/galette/plugins/galette-plugin-subscription/carte_adherent2.php?code=%B3%B4620%B4%D050%D650%04%00
									$today= new DateTime("now");
									$date_fin_validite = date_add($today, date_interval_create_from_date_string('1 year'));
									$compressed   = gzdeflate($id_adh.';'.$date_fin_validite->format('Y-m-d'));//id_adh;date de fin de validité
									$compressed =urlencode($compressed );
									//corp du mail
									$mail->setMessage("Bonjour,\r\n\r\n"."Votre abonnement pour la ou les sections :\n".$List_sections."est maintenant payé.\r\n"."L'abonnement concerné est le N°".$followup->id_abn.". Montant payé: ".$montant."€.\r\n\r\n"."Pour voir le suivi de vos abonnements et les montants à payer, connectez-vous à l'adresse suivante (Abonnement/suivi): ".$proto . '://' . $_SERVER['SERVER_NAME'] .dirname($_SERVER['REQUEST_URI'])."/../follow_up_subs.php\r\n\r\n"."Pour télécharger votre carte d'adhérent, cliquer sur le lien ci-dessous:\r".$proto . '://' . $_SERVER['SERVER_NAME'] .dirname($_SERVER['REQUEST_URI'])."/../carte_adherent2.php?code=".$compressed."\r\nCette carte vous sera demandée pour accéder aux installations sportives. Vous pouvez aussi à tout moment télécharger cette carte à partir de votre profil (Navigation/mes informations \"Générer la carte de membre\").\r\n\r\n"."Pour les questions ou réclamations, ne répondez pas à ce mail mais contactez vos responsables de section.\r\nSi vous avez besoin d'une facture, vous pouvez en faire la demande auprès de la trésorière de l'association: ".$preferences->pref_email_newadh."\r\n\r\nCordialement,\r\nLe bureau de ".$preferences->pref_nom.".");
									//envoi de l'email:
									$sent = $mail->send();
														
									}//fin du if	
							}//fin du if						
					//------>Fin envoi email
					//fin du copier coller	
				}
			}	
		}
	//	Ecriture de log pour un éventuel débogage
	//	$sp_Outils = new sp_Outils();
	//	$sp_Outils::Ecrire_Log($sp_Outils::getNow(false)."\t"."Outils trouvé");
	//	$sp_Outils::EnvoyerMsgErreurParMail($sp_Outils::getNow(false)."\t"."Outils trouvé");
?>


 
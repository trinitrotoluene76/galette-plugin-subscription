<?php

/**
 * Subs confirmation for galette Subscription plugin
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
 
define('GALETTE_BASE_PATH', '../../');
require_once GALETTE_BASE_PATH . 'includes/galette.inc.php';
use Galette\Entity\Adherent as Adherent;
use Galette\Entity\Group as Group;
// use Galette\Repository\Groups as Groups;
// use Galette\Entity\DynamicFields as DynamicFields;
// use Galette\DynamicFieldsTypes\DynamicFieldType as DynamicFieldType;
use Galette\Core\GaletteMail as GaletteMail;
// use Galette\Entity\Texts;


if (!$login->isLogged()) {
    header('location: ' . GALETTE_BASE_PATH . 'index.php');
    die();
}
$id_adh = get_numeric_form_value('id_adh', '');

if ( !$login->isSuperAdmin() ) {
    if ( !$login->isAdmin() && !$login->isStaff() && !$login->isGroupManager()
        || $login->isAdmin() && $id_adh == ''
        || $login->isStaff() && $id_adh == ''
        || $login->isGroupManager() && $id_adh == ''
    ) {
        $id_adh = $login->id;
    }
}
require_once '_config.inc.php';

$member = new Adherent();
//on rempli l'Adhérent par ses caractéristiques à l'aide de son id
$member->load($id_adh);
//début evol #55 MAJ date dernière connexion
$member->updateModificationDate();
//fin evol #55
//Fonction de traitement d'un string
//---------------------------------------------------------------------------------->
//between ('@', '.', 'biohazard@online.ge');
    function after ($ca, $inthat)
    {
        if (!is_bool(strpos($inthat, $ca)))
        return substr($inthat, strpos($inthat,$ca)+strlen($ca));
    };

    function after_last ($ca, $inthat)
    {
        if (!is_bool(strrevpos($inthat, $ca)))
        return substr($inthat, strrevpos($inthat, $ca)+strlen($ca));
    };

    function before ($ca, $inthat)
    {
        return substr($inthat, 0, strpos($inthat, $ca));
    };

    function before_last ($ca, $inthat)
    {
        return substr($inthat, 0, strrevpos($inthat, $ca));
    };

    function between ($ca, $that, $inthat)
    {
        return before ($that, after($ca, $inthat));
    };

    function between_last ($ca, $that, $inthat)
    {
     return after_last($ca, before_last($that, $inthat));
    };

// use strrevpos function in case your php version does not include it
function strrevpos($instr, $needle)
{
    $rev_pos = strpos (strrev($instr), strrev($needle));
    if ($rev_pos===false) return false;
    else return strlen($instr) - $rev_pos - strlen($needle);
};
//---------------------------------------------------------------------------------->Fin fonction traitement string

//traitement des données envoyées en POST
//---------------------------------------------------------------------------------->
$total=$_POST['total_estimme'];
$subscription= new Subscription;
$today= new DateTime("now");
$subscription->date_demande=$today->format('Y-m-d');
$subscription->total_estimme=$total;
$subscription->id_adh=$id_adh;
$subscription->message_abn=$_POST['message_abn'];
$valid = $subscription->check($_POST);
			
//si les données sont valides on les enregistres -> continuer à bosser cette partie
	if ( $valid == true )
		{
		$subscription->store();
		}
$files=array ();
// $file[id_group][$k]
foreach ($_POST as $key => $value) 
		{
		//si id_group(0, 1, 2)=id_group alors $value=id_group
		if(substr($key,0,8)=='id_group')
			{
			$followups[$value]=new Followup;
			$followups[$value]->id_act=$value;
			$followups[$value]->id_adh=$id_adh;
			$followups[$value]->id_abn=$subscription->id_abn;
			
			
			//création d'une activité pour évaluer son autovalidation
			$activity= new Activity;
			$activity->id_group=$value;
			//hydrate l'activité
			$activity->getActivity($activity);
			if($activity->autovalidation == 1)
						{
						//statut activity = Validé (1)
						$followups[$value]->statut_act=1;
						//enregistrement afin d'utiliser getStatusSub
						$followups[$value]->store();
			
						//recherche et calcul du statut abn
						$statut_abn=$followups[$value]->getStatusSub($subscription->id_abn);
						}
					else
						{//Statut abn = en cours
						$statut_abn=0;
						$followups[$value]->statut_act=0;
						$followups[$value]->store();
						}
			
			
			//---------------------------------------------------------------->ENVOI de l'email de confirmation
			if($preferences->pref_mail_method != GaletteMail::METHOD_DISABLED)
				{
				//Pour chaque activité concernée, on récupère les managers avec id_act et on leur envoi un mail
				$group = new Group();
				$group->load($value);//value = id_group
				//affiche le nom,tel,mail du manager de group + pour changer la manager de group, allez dans la page gestion group
				$managers=array();
				$managers=$group->getManagers();
				
				//récupération des infos de l'adhérent à valider
				$adherent=new Adherent();
				$adherent->load($id_adh);
				
				foreach ($managers as $key => $manager) 
					{
					$sname=$manager->surname." ".$manager->name;
					
					if ( GaletteMail::isValidEmail($manager->email) ) 
						{
						$mail = new GaletteMail();
						$mail->setSubject("[".$preferences->pref_nom."] Nouvelle inscription pour la section ".$group->getName());
						$mail->setRecipients(
							array(
								$manager->email => $sname
							)
						);
						$proto = 'http';
						if ( isset($_SERVER['HTTPS']) ) {
							$proto = 'https';
						}
						
						$mail->html=true;
						$mail->setMessage("Bonjour,\r\n\r\n"."connectez vous sur Galette pour valider la nouvelle inscription de ".$adherent->surname." ".$adherent->name." pour la section ".$group->getName().".\r\n"."Allez dans l'onglet Abonnement/Gestion des abonnés. L'abonnement concerné est le N°".$subscription->id_abn.".\r\n".$proto . '://' . $_SERVER['SERVER_NAME'] .dirname($_SERVER['REQUEST_URI'])."/management_subs.php\r\n\r\n"."Cordialement,\r\n"."le bureau.");
						//envoi de l'email:
						$sent = $mail->send();
						}//fin du if
					}//fin pour chaque manager	
				 }//fin du if 
					
			//------------------------------------------------------------------>Fin envoi email


			}//fin du if id group
			
		//si message_adh_act(id_group)=message_adh_act
		if(substr($key,0,15)=='message_adh_act')
			{
			$followups[substr($key,15,3)]->message_adh_act=$value;
			$followups[substr($key,15,3)]->store();
			}//fin du if message
		
		//si POST['description'_id_act_N°]=description_5_1
		if(substr($key,0,11)=='description')
			{
			$id_group=between("_", "_", $key); //5=id_group
			$number=after_last( "_", $key);//1=doc N°1

			//création de l'objet file pour description
			$files[$id_group][$number]= new File();
			//hydratation (les id_act et _id_adh son remplis par l'upload_process.php)
			$files[$id_group][$number]->id_abn=$subscription->id_abn;
			$files[$id_group][$number]->id_act=$id_group;
			$files[$id_group][$number]->id_adh=$id_adh;
			$files[$id_group][$number]->description=$value;
			}//fin du if description
		
		//si POST['doc_name'id_act_N°]=doc_name5_1
		if(substr($key,0,8)=='doc_name')
			{
			//hydratation
			$files[$id_group][$number]->doc_name=$value;
			}//fin du if doc_name
			
		//si POST['emplacementk2]=emplacement
		if(substr($key,0,11)=='emplacement')
			{
			$files[$id_group][$number]->emplacement=$value;
			//recherche d'un potentiel doublon (évite d'enregistrer au rafraichissement de page)			
			$res=$files[$id_group][$number]->isFileExist($files[$id_group][$number]);
			//si le fichier n'existe pas déjà, on l'enregistre
			if($res==0 && $files[$id_group][$number]->emplacement!=null)
				{
				$today= new DateTime("now");
				$files[$id_group][$number]->date_record=$today->format('Y-m-d');
				$files[$id_group][$number]->emplacement=$value;
				$files[$id_group][$number]->store();
				}		
			}
		
		}//fin du foreach
			
//------------------------------------------------------------------------------------>FIN	du traitement du $_POST

$tpl->assign('page_title', _T("Validation"));
$tpl->assign('subscription',$subscription);
$tpl->assign('statut_abn',$statut_abn);

//Set the path to the current plugin's templates,
//but backup main Galette's template path before
$orig_template_path = $tpl->template_dir;
$tpl->template_dir = 'templates/' . $preferences->pref_theme;

$content = $tpl->fetch('subs_confirmation.tpl', SUBSCRIPTION_SMARTY_PREFIX);
$tpl->assign('content', $content);
//Set path to main Galette's template
$tpl->template_dir = $orig_template_path;
$tpl->display('page.tpl', SUBSCRIPTION_SMARTY_PREFIX);
?>

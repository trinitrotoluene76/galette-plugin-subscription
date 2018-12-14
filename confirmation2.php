<?php

/**
 * Confirmation 2 for for galette Subscription plugin
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

require_once 'includes/tarif.php';

$subscription= new Subscription;

if(isset($_POST['id_abn']))
	{
	$subscription->id_abn=$_POST['id_abn'];
	}
if(isset($_GET['id_abn']))
	{
	$subscription->id_abn=$_GET['id_abn'];
	}
$subscription->getSubscription($subscription);
//formatage de la date pour affichage
$date=DateTime::createFromFormat('Y-m-d', $subscription->date_demande);
$subscription->date_demande=$date->format(_T("Y-m-d"));

//retourner la liste des activités d'un abn
$followup=new Followup;
$followup->id_abn=$subscription->id_abn;

$res=array();
$res=$followup->getFollowupAct($followup);
$activities=array();

//calcul du total due:
$total=0.00;

foreach ( $res as  $key => $value ) 
				{
				$activity=new Activity;
				$activity->id_group=$value;
				$activity->getActivity($activity);
				$activities[]=$activity;
				
				$followup=new Followup;
				$followup->id_act=$activity->id_group;
				$followup->id_adh=$member->id;
				$followup->id_abn=$subscription->id_abn;
				$followup->getFollowup($followup);
				$followups[]=$followup;
				
				//si l'adhésion à l'activité est validée par le responsable de group statut_act == 1, alors on met à jour le total due
				if(	$followup->statut_act == 1)
					{
					switch ($category)
						{
						case 0:
						$total=$total+$activity->floatprice($activity->price1); break;
						case 1:
						$total=$total+$activity->floatprice($activity->price2); break;
						default:
						$total=$total+$activity->floatprice($activity->price2); break;
						}
					}//fin du if
				}//fin du foreach

//récupération de l'url de notification:	
	//définition de la table de la bdd
	$table="subscription_config_systempay";
	$select = $zdb->select($table);
	$select->where(array('field_name'=> 'vads_url_check'))
						->limit(1);
	$results = $zdb->execute($select);
	$result = array();
	foreach ( $results as $row ) {
		$result[] = $row;
	}
	$vads_url_check=$result[0]->field_value;

//récupération de l'url de paiement:	
	$select = $zdb->select($table);
	$select->where(array('field_name'=> 'url_payment_systempay'))
						->limit(1);
	$results = $zdb->execute($select);
	$result = array();
	foreach ( $results as $row ) {
		$result[] = $row;
	}
	$url_payment_systempay=$result[0]->field_value;

//récupération du global_enable:	
	$select = $zdb->select($table);
	$select->where(array('field_name'=> 'global_enable'))
						->limit(1);
	$results = $zdb->execute($select);
	$result = array();
	foreach ( $results as $row ) {
		$result[] = $row;
	}
	$Sytempay_enable=$result[0]->field_value;
	
//récupération du mode TEST ou PRODUCTION	
	$select = $zdb->select($table);
	$select->where(array('field_name'=> 'vads_ctx_mode'))
						->limit(1);
	$results = $zdb->execute($select);
	$result = array();
	foreach ( $results as $row ) {
		$result[] = $row;
	}
	$vads_ctx_mode=$result[0]->field_value;

//définition du path absolue nécessaire à vads_url_return. (confirmation2.php)
$protocol = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off' || $_SERVER['SERVER_PORT'] == 443) ? "https://" : "http://";
$path_abs=$protocol.$_SERVER['SERVER_NAME'].$_SERVER["SCRIPT_NAME"];
	
$tpl->assign('page_title', _T("Follow up & Payment"));
$tpl->assign('subscription',$subscription);
$tpl->assign('activities',$activities);
$tpl->assign('followups',$followups);
$tpl->assign('category',$category);
$tpl->assign('total',$total);
$tpl->assign('vads_url_check',$vads_url_check);
$tpl->assign('url_payment_systempay',$url_payment_systempay);
$tpl->assign('Sytempay_enable',$Sytempay_enable);
$tpl->assign('path_abs',$path_abs);
$tpl->assign('vads_ctx_mode',$vads_ctx_mode);

//Set the path to the current plugin's templates,
//but backup main Galette's template path before
$orig_template_path = $tpl->template_dir;
$tpl->template_dir = 'templates/' . $preferences->pref_theme;

$content = $tpl->fetch('confirmation2.tpl', SUBSCRIPTION_SMARTY_PREFIX);
$tpl->assign('content', $content);
//Set path to main Galette's template
$tpl->template_dir = $orig_template_path;
$tpl->display('page.tpl', SUBSCRIPTION_SMARTY_PREFIX);
?>

<?php

/**
 * Configuration of systempay module for galette Subscription plugin
 *
 * PHP version 7
 *
 * Copyright © 2009-2018 The Galette Team
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

if (!$login->isLogged() || !$login->isSuperAdmin()) {
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
//définition de la table de la bdd
$table="subscription_config_systempay";

//récupération des nouvelles valeurs à enregistrer en base
if(isset($_POST['global_enable']))
	{
	$global_enable=$_POST['global_enable'];
	$mode=$_POST['mode'];
	$vads_url_check=$_POST['vads_url_check'];
	$url_payment_systempay=$_POST['url_payment_systempay'];
	$systempay_path=$_POST['systempay_path'];
	
	//Enregistrement
	$update = $zdb->update($table);
    $update->set(array('field_value'=> $global_enable));
    $update->where(array('field_name'=> 'global_enable'));
	$edit = $zdb->execute($update);
	
	$update = $zdb->update($table);
    $update->set(array('field_value'=> $mode));
    $update->where(array('field_name'=> 'vads_ctx_mode'));
	$edit = $zdb->execute($update);
	
	$update = $zdb->update($table);
    $update->set(array('field_value'=> $vads_url_check));
    $update->where(array('field_name'=> 'vads_url_check'));
	$edit = $zdb->execute($update);
	
	$update = $zdb->update($table);
    $update->set(array('field_value'=> $url_payment_systempay));
    $update->where(array('field_name'=> 'url_payment_systempay'));
	$edit = $zdb->execute($update);
	
	$update = $zdb->update($table);
    $update->set(array('field_value'=> $systempay_path));
    $update->where(array('field_name'=> 'systempay_path'));
	$edit = $zdb->execute($update);
	}

//Valeurs lues en base	
$select = $zdb->select($table);
$results = $zdb->execute($select);
$result = array();
foreach ( $results as $row ) {
	$result[] = $row;
}
			
$tpl->assign('page_title', _T("Configuration of Systempay"));
$tpl->assign('result',$result);
		
//Set the path to the current plugin's templates,
//but backup main Galette's template path before
$orig_template_path = $tpl->template_dir;
$tpl->template_dir = 'templates/' . $preferences->pref_theme;
$content = $tpl->fetch('config_systempay.tpl', SUBSCRIPTION_SMARTY_PREFIX);
$tpl->assign('content', $content);
//Set path to main Galette's template
$tpl->template_dir = $orig_template_path;
$tpl->display('page.tpl', SUBSCRIPTION_SMARTY_PREFIX);
?>

<?php

/**
 * Send files for galette Subscription plugin
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

//-------------------------------------------------------------------------->Détection du navigateur
require_once GALETTE_BASE_PATH. 'includes/navigator_detection.php';
//--------------------------------------------------------------------------->FIN détection

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

//check si l'adhérent a une photo (0/1)
$picture=$member->picture->hasPicture();

//on charge tous les groupes. (j'ai une erreur qui n'empeche pas le fonctionnement mais qui apparait dans le log "Non-static method Activity::getList() should not be called statically"
	$group=Activity::getList(true);
	$activities=array();//=$activity0, $activity1, $activity2...
	$files_vierges=array();//files vierges
	foreach ($group as $key => $value) 
		{
			if(isset($_POST['total']))
				{
				//parsage de tout ce qui est POSTé
				foreach ( $_POST as $k_post=>$val_post ) 
					{
					//si case coché=id_group,on créé une nouvelle activity, ou si l'activité est une activité parente
					if($k_post==$group[$key]->getId() || ($k_post=="id_parent_group_checked" && $val_post==$group[$key]->getId()))
						{
						//création de l'objet activité
						$activity = new Activity();
						//récupération de l'id_group ainsi que le nom du groupe managé
						$activity->id_group = $group[$key]->getId();
						//$activity->group_name = $group[$key]->getName();

						//hydrate l'activité avec les données de la bdd. L'objet passé en paramètre doit être une activité avec un id_group valide
						$activity->getActivity($activity);
						$activities[$key]=$activity;
						
						//chaque activité comporte 0 ou plusieurs fichiers vierges
						$file=new File();
						$file->id_act=$activity->id_group;
						$files_vierges[$activity->id_group]=$file->getFileListVierge();
						}
						
					}//fin du foreach post
						
				$total=$_POST['total'];
				}//fin du isset	
			
		}//fin du foreach
$subscription= new Subscription;
$subscription->total_estimme=$total;
$subscription->id_adh=$id_adh;

//2 utilisateurs du formulaire doivent avoir 0.1s minimum de différence 
//entre le chargement de leur pagepour avoir un nom de fichier différent
//temps en s*10 (centieme de s)
$timestamp=intval(microtime(true)*10-13992330840);
		
$tpl->assign('page_title', _T("Send Files"));
$tpl->assign('activities',$activities);
$tpl->assign('picture',$picture);
$tpl->assign('timestamp',$timestamp);
$tpl->assign('subscription',$subscription);
$tpl->assign('files_vierges',$files_vierges);

//Set the path to the current plugin's templates,
//but backup main Galette's template path before
$orig_template_path = $tpl->template_dir;
$tpl->template_dir = 'templates/' . $preferences->pref_theme;

$content = $tpl->fetch('send_files.tpl', SUBSCRIPTION_SMARTY_PREFIX);
$tpl->assign('content', $content);
//Set path to main Galette's template
$tpl->template_dir = $orig_template_path;
$tpl->display('page.tpl', SUBSCRIPTION_SMARTY_PREFIX);
?>

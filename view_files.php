<?php

/**
 * View files for galette Subscription plugin
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

//------------------------------------------------------------------------->
// enregistrement de la description
$file= new File();
$file->id_adh=$id_adh;

if(isset($_GET['id_adh']))
		{
		$file->id_adh=$_GET['id_adh'];
		}

//supprimer un fichier à partir de son emplacement et de son nom
//------------------------------------------------------------------------------------>
$deleteok=2;
if(isset($_GET['delete']))
		{
		if($_GET['delete']==1)
			{
			$file_del=new File();
			$file_del->id_doc=$_GET['id_doc'];
			$file_del->getFile($file_del);
			if($file_del->emplacement)
				{
				$res=$file_del->remove("./upload/files/".$file_del->emplacement,$file_del->emplacement);
				$deleteok=$res;
				}
			}
		}
//------------------------------------------------------------------------------------>FIN supression




//affichage de la liste des fichiers
	
		$personnal_files=array();
		$personnal_files=$file->getFileList();
		
		$activities=array();
		if($personnal_files>0)
		{
			foreach ($personnal_files as $key => $file) 
			{
			$activity= new Activity();
			$activity->id_group=$file->id_act;
			$activity->getActivity($activity);
			$activities[$key]=$activity;
			}
		}
		

//passage des informations au template
$tpl->assign('page_title', _T("My Files"));
//Set the path to the current plugin's templates,
//but backup main Galette's template path before
$orig_template_path = $tpl->template_dir;
$tpl->template_dir = 'templates/' . $preferences->pref_theme;



//liste des fichiers de l'adhérent pour l'activité
$tpl->assign('files',$personnal_files);
//confirmation de suppression d'un fichier
$tpl->assign('deleteok',$deleteok);
$tpl->assign('activities',$activities);

$content = $tpl->fetch('view_files.tpl', SUBSCRIPTION_SMARTY_PREFIX);

$tpl->assign('content', $content);
//Set path to main Galette's template
$tpl->template_dir = $orig_template_path;
$tpl->display('page.tpl', SUBSCRIPTION_SMARTY_PREFIX);


?>

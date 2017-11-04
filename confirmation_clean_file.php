<?php

/**
 * Confirmation clean file for galette Subscription plugin
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
$del=new File();
//supprime tous les fichiers non présent dans la bdd mais présent dans le répertoire
	$files1=array();
	$file=new File();
	$pathrep="./upload/files/";
	$res1=$file->listrep($pathrep);
	
	if (count($res1) > 0) 
			{
				foreach ( $res1 as $row ) 
				{
					$file1 = new File();
					$file1->emplacement=$row;
					$path="./upload/files/".$file1->emplacement;
					$files1[$row]=$file1;
					if(isset($_GET['clean_files']))
						{
							$file1->remove($path,$file1->emplacement);
						}
				}
			}
	if($res1==-1)
		{
			$error=-1;
			//"Répertoire non accessible !";
		}
	if($res1==-2)
		{
			$error=-2;
			//"repertoire vide";
		}
	

//supprime tous les fichiers vieux de 2 ans ou plus (hors formulaire)	
	$files2=array();
	$res2=$file->get_FileList_old();
	if ($res2->count() > 0) 
			{
			foreach ( $res2 as $row ) 
				{
					$path="./upload/files/".$row->emplacement;
					if(isset($_GET['clean_files']))
						{
							$del->remove($path,$row->emplacement);
						}
					$files2[$row->id_doc]=$row;
				}
			}//fin du if

//supprime tous les fichiers de la bdd qui sont inexistant dans le répertoire
	$res3=$file->get_FileList_bdd();
	if ($res3->count() > 0) 
			{
				foreach ( $res3 as $row ) 
				{
					$path="./upload/files/".$row->emplacement;
					if (file_exists($path)) 
						{
							//var_dump ("Le fichier $row->emplacement existe.");
						} else {
							//var_dump ("Le fichier ".$row->emplacement." n'existe pas dans le répertoire, il va être supprimé de la BDD");
							if(isset($_GET['clean_files']))
								{
									$del->remove("",$row->emplacement);
								}
							$files3[$row->id_doc]=$row;
						}
				}
			}//fin du if
//s'il n'y a pas de fichiers à supprimer, on lève une successbox
if($res3->count() == 0 && $res2->count()==0 && count($res1)==0)
{
	$error=-3;
}
if(isset($_GET['clean_files']))
	{
		$files1=0;
		$files2=0;
		$files3=0;
	}
$tpl->assign('error', $error);
$tpl->assign('files1', $files1);
$tpl->assign('files2', $files2);
$tpl->assign('files3', $files3);
$tpl->assign('page_title', _T("Confirmation to clean files"));

//Set the path to the current plugin's templates,
//but backup main Galette's template path before
$orig_template_path = $tpl->template_dir;
$tpl->template_dir = 'templates/' . $preferences->pref_theme;

$content = $tpl->fetch('confirmation_clean_file.tpl', SUBSCRIPTION_SMARTY_PREFIX);
$tpl->assign('content', $content);
//Set path to main Galette's template
$tpl->template_dir = $orig_template_path;
$tpl->display('page.tpl', SUBSCRIPTION_SMARTY_PREFIX);
?>

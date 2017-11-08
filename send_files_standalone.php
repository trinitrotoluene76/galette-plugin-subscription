<?php

/**
 * Send files standalone for galette Subscription plugin
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
// enregistrement des éléments transmis par le formulaire send_files_standalone.tpl
$file= new File();
$file->id_adh=$id_adh;

if(isset($_GET['id_adh']))
		{
		$file->id_adh=$_GET['id_adh'];
		}
if(isset($_GET['id_act']))
		{
		$file->id_act=$_GET['id_act'];
		$activity= new Activity();
		$activity->id_group=$file->id_act;
		$activity->getActivity($activity);
		}
if(isset($_GET['id_abn']))
		{
		$file->id_abn=$_GET['id_abn'];
		}
//si "vierge" : 0= document quelconque / 1=document provenant de la page de gestion des groupes
if(isset($_GET['vierge']))
		{
		$file->vierge=$_GET['vierge'];
		}
if(isset($_POST['return_file']))
		{
		$file->return_file=$_POST['return_file'];
		}
//si return_file: 0= document informatif / 1=formulaire à télécharger, remplir et à retourner. un simple adh ne peut pas retourner de formulaire, d'où return_file=0
else 
	{
		$file->return_file=0;
	}
//hydratation du nom et de l'emplacement du fichier
if(isset($_POST['emplacement']) && isset($_POST['doc_name']))
		{
		$file->emplacement=$_POST['emplacement'];
		$file->doc_name=$_POST['doc_name'];
		}
//hydratation de la description si elle existe		
if(isset($_POST['description']))
		{
		//un fichier se nomme timestamp_id_act_id_fichier.extension (id_fichier=1, 2, 3...)
		$file->description=$_POST['description'];
		}//fin du if description
//recherche d'un potentiel doublon (évite d'enregistrer au rafraichissement de page)			
$res=$file->isFileExist($file);
//si le fichier n'existe pas déjà, on l'enregistre
if($res==0 && $file->emplacement!=null)
	{
	$today= new DateTime("now");
	$file->date_record=$today->format('Y-m-d');
	$file->store();
	}		
//------------------------------------------------------------------------------->FIN
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
			$res=$file_del->remove("./upload/files/".$file_del->emplacement,$file_del->emplacement);
			$deleteok=$res;
			}
		}
//------------------------------------------------------------------------------------>FIN supression

//affichage de la liste des fichiers
	//si la page précédante est la page de gestion des groupes, $GET['vierge']==1, on affiche la liste des fichiers vierges uniquement et on autorise le return file, 
	//sinon on affiche la liste des fichiers de l'adhérent + liste des fichers verges
	$personnal_files=0;
	$files_vierges=array();
	$files_vierges=$file->getFileListVierge();
		
	if($file->vierge != 1)
		{
		$personnal_files=array();
		$personnal_files=$file->getFileListAdh();
		}


//passage des informations au template
$tpl->assign('page_title', _T("Add File"));
//Set the path to the current plugin's templates,
//but backup main Galette's template path before
$orig_template_path = $tpl->template_dir;
$tpl->template_dir = 'templates/' . $preferences->pref_theme;

//2 utilisateurs du formulaire doivent avoir 0.1s minimum de différence 
//entre le chargement de leur pagepour avoir un nom de fichier différent
//temps en s*10 (centieme de s)
$timestamp=intval(microtime(true)*10-13992330840);
	
$tpl->assign('timestamp', $timestamp);
$tpl->assign('file',$file);
//liste des fichiers concernant l'activité (informatifs ou à retourner)
$tpl->assign('files_vierges',$files_vierges);
$tpl->assign('vierge',$file->vierge);
//liste des fichiers de l'adhérent pour l'activité
$tpl->assign('personnal_files',$personnal_files);
//confirmation de suppression d'un fichier
$tpl->assign('deleteok',$deleteok);
$tpl->assign('activity',$activity);
$content = $tpl->fetch('send_files_standalone.tpl', SUBSCRIPTION_SMARTY_PREFIX);

$tpl->assign('content', $content);
//Set path to main Galette's template
$tpl->template_dir = $orig_template_path;
$tpl->display('page.tpl', SUBSCRIPTION_SMARTY_PREFIX);


?>

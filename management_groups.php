<?php

/**
 * Management group for galette Subscription plugin
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
 *
 * @category  Plugins
 * @package   GaletteSubscription
 *
 * @author    Amaury FROMENT <amaury.froment@gmail.com>
 * @copyright 2009-2016 The Galette Team
 * @license   http://www.gnu.org/licenses/gpl-3.0.html GPL License 3.0 or (at your option) any later version
 * @version   0.7.8
 * @link      http://galette.tuxfamily.org
 * @since     Available since 0.7.8
 */
 
define('GALETTE_BASE_PATH', '../../');
require_once GALETTE_BASE_PATH . 'includes/galette.inc.php';
use Galette\Entity\Adherent as Adherent;
use Galette\Entity\Group as Group;
use Galette\Repository\Groups as Groups;


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
// Si l'adhérent est un groupmanager, on charge l'activité correspondante (on a donc besoin de id_group)
$member = new Adherent();
//on rempli l'Adhérent par ses caractéristiques à l'aide de son id
$member->load($id_adh);

//Si la personne loggé gère un group on affiche son group uniquement
if($member->managed_groups && !$login->isSuperAdmin() && !$login->isAdmin() && !$login->isStaff())
	{
	//passage des informations au template
	$tpl->assign('page_title', _T("Groups Management"));
	//Set the path to the current plugin's templates,
	//but backup main Galette's template path before
	$orig_template_path = $tpl->template_dir;
	$tpl->template_dir = 'templates/' . $preferences->pref_theme;

	//on charge les groupes pour lesquels il est manager
	$group=Groups::loadManagedGroups($id_adh);

	//affiche le nom,tel,mail du manager de group + pour changer la manager de group, allez dans la page gestion group

	$activities;//=$activity0, $activity1, $activity2...
	foreach ($group as $key => $value) 
		{
		$group[$key];
		//on prend le 1er group managé
		//création de l'objet activité
		$activity = new Activity();
		//récupération de l'id_group ainsi que le nom du groupe managé
		$activity->id_group = $group[$key]->getId();
		$activity->group_name = $group[$key]->getName();
		$nbinscr[$key]=$group[$key]->getMemberCount(true);
		 
		//hydrate l'activité avec les données de la bdd. L'objet passé en paramètre doit être une activité avec un id_group valide
		$activity->getActivity($activity);

		//affiche le nom,tel,mail du manager de group + pour changer la manager de group, allez dans la page gestion group
		$managers[$key]=$group[$key]->getManagers();
		
		//si le formulaire est envoyé
		if(isset($_POST['id_form']))
			{
			//on récupère l'id du formulaire correspondant: $_POST['id_form']
			$k=$_POST['id_form'];
			if($k==$key)
				{
				$valid = $activity->check($_POST);
				
				//si les données sont valides on les enregistres -> continuer à bosser cette partie
				if ( $valid == true ) 
					{
					//enregistrement des infos dans la bdd
					$store = $activity->store();
					
					//on errore l'update si l'enregistrement est ok
					if ( $store == true ) 
						{
						$tpl->assign('error',0);
						}
					else
						{
						$tpl->assign('error',1);
						}
					}
				else 
					{
					$tpl->assign('error',1);
					}
				}//fin du if key
			}//fin du if $Post
		
		else 
				{
				$tpl->assign('error','2');
				}
		$activities[$key]=$activity;
		}//fin du foreach
		$tpl->assign('activities',$activities);
		$tpl->assign('managers',$managers);
		$tpl->assign('nbinscr',$nbinscr);
		
	}//fin du if member
	
//si la personne loggé fait parti du staff sans pour autant gérer un group alors on affiche tous les groups
if($login->isSuperAdmin() || $login->isAdmin() || $login->isStaff())
	{
	//passage des informations au template
	$tpl->assign('page_title', _T("Groups Management for staff"));
	//Set the path to the current plugin's templates,
	//but backup main Galette's template path before
	$orig_template_path = $tpl->template_dir;
	$tpl->template_dir = 'templates/' . $preferences->pref_theme;

	//on charge tous les groupes
	$groups = new Groups();
	$group=$groups->getList();
	
	$activities;//=$activity0, $activity1, $activity2...
	foreach ($group as $key => $value) 
		{
		$group[$key];
		//on prend le 1er group managé
		//affiche le nom,tel,mail du manager de group + pour changer la manager de group, allez dans la page gestion group
		$managers[$key]=$group[$key]->getManagers();
			
		//création de l'objet activité
		$activity = new Activity();
		//récupération de l'id_group ainsi que le nom du groupe managé
		$activity->id_group = $group[$key]->getId();
		$activity->group_name = $group[$key]->getName();
		//récupération du nombre d'inscrits
		$nbinscr[$key]=$group[$key]->getMemberCount(true);
		 
		//hydrate l'activité avec les données de la bdd. L'objet passé en paramètre doit être une activité avec un id_group valide
		$activity->getActivity($activity);
		
		//si le formulaire est envoyé
		if(isset($_POST['id_form']))
			{
			//on récupère l'id du formulaire correspondant: $_POST['id_form']
			$k=$_POST['id_form'];
			if($k==$key)
				{
				$valid = $activity->check($_POST);
				//si les données sont valides on les enregistres -> continuer à bosser cette partie
				if ( $valid == true ) 
					{
					//enregistrement des infos dans la bdd
					$store = $activity->store();
					
					//on errore l'update si l'enregistrement est ok
					if ( $store == true ) 
						{
						$tpl->assign('error',0);
						}
					else
						{
						$tpl->assign('error',1);
						echo ('check= true,store =false');
						}
					}
				else 
					{
					$tpl->assign('error',1);
					echo ('check= false');
					}
				}//fin du if key
			}//fin du if $Post
		
		else 
				{
				$tpl->assign('error','2');
				}
		$activities[$key]=$activity;
		
		}//fin du foreach
		$tpl->assign('activities',$activities);
		$tpl->assign('managers',$managers);
		$tpl->assign('nbinscr',$nbinscr);
		
	}//fin du if staff
	

$content = $tpl->fetch('management_groups.tpl', SUBSCRIPTION_SMARTY_PREFIX);
$tpl->assign('content', $content);
//Set path to main Galette's template
$tpl->template_dir = $orig_template_path;
$tpl->display('page.tpl', SUBSCRIPTION_SMARTY_PREFIX);
?>

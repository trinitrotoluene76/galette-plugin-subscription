<?php

/**
 * Management subs for galette Subscription plugin
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
use Galette\Filters\MembersList as MembersList;//#evol 55
use Galette\Repository\Members as Members;//evol #55
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

$member = new Adherent();
//on rempli l'Adhérent par ses caractéristiques à l'aide de son id
$member->load($id_adh);

// management group pour avoir les groupes managés
//------------------------------------------------------------------------------------------------->
//Si la personne loggé gère un group on affiche son group uniquement
if($member->managed_groups && !$login->isSuperAdmin() && !$login->isAdmin() && !$login->isStaff())
	{
	
	//passage des informations au template
	$tpl->assign('page_title', _T("Subscriptions Management"));
	$groups=array();
	//on charge les groupes pour lesquels il est manager
	$groups=Groups::loadManagedGroups($id_adh);
	$activities=array();
	$nbinscr=array();
	$followups=array();
	$subscriptions=array();
	$members=array();
	$statuts=array();//statuts adh
			
	$id_abns=array();
		
	foreach ( $groups as  $key2 => $value2 ) 
		{
		//ma partie
		//------------------------------------------------------->		
		//récupération des abonnements de l'activité
		$followup= new Followup;
		$id_act2=$groups[$key2]->getId();
		$followup->id_act=$id_act2;
		
		//si c'est une nouvelle saison pour l'activité on supprime suivi, doc et on retire le membre du group. 
		//Si l'abonnement ne contient plus d'activité, on le supprime
		
			if(isset($_GET['remove_id_act']))
				{
				if($_GET['remove_id_act']==$id_act2)
					{
										
					//suppression des suivis concernant l'activité en question pour tout adhérent
					$followup2=new Followup();
					$followup2->id_act=$id_act2;
						//suppression des abonnements mono activité .
						//l'abonnement n'est pas supprimé s'il reste plus d'une activité dans l'abonnement avec une saison en cours
						$id_anbs2=$followup2->getFollowupSub($followup2);
						//pour chaque abn compter le nb d'activité (getFollowupAct)
						foreach ( $id_anbs2 as $key5 => $id_abn2)
							{
							$followup2->id_abn=$id_abn2;
							$followup2->getFollowupAct($followup2);
							//si plusieurs activités sont concernées par l'abonnement
							if(count($followup2->getFollowupAct($followup2))>1)
								{
								//supprime le suivi sur le paramètre id_act	
								$followup2->remove($followup2);
								}//fin du if
							//si il ne reste plus qu'une acitvité, on supprime l'abonnement qui supprime le reste en cascade	
							else
								{
								$subscription2= new Subscription;
								$subscription2->id_abn=$id_abn2;
								$subscription2->remove($subscription2);
								}
							}//fin du foreach
					
					
					//Lorsqu'un membre du staff supprime un fichier quelconque, ceci lance la fonction de nettoyage file/clean_file()
					
					//on retire les membres de l'activité/du groupe en fin de saison
					$activity2=new Activity();
					$activity2->remove($id_act2);
					$valid=$id_act2;
					}//fin du if $_GET
				}//fin du isset GET
		//fin de la nouvelle saison		
		//-------------------------------------------------------------------------------------------------------------->
		
		//évol #42 tri et selection du nombre de résultat par page
		//récupération du nombre de lignes à afficher
		if(isset($_GET["nbligne"]) && isset($_GET["id_act"]))
			{
			switch($_GET["nbligne"])
				{
				case "0":
					$select_nbligne=0;
					$nblignesmax=5;
				break;
				case "1":
					$select_nbligne=1;
					$nblignesmax=10;
				break;
				case "2":
					$select_nbligne=2;
					$nblignesmax=20;
				break;
				case "3":
					$select_nbligne=3;
					$nblignesmax=50;
				break;
				case "4":
					$select_nbligne=4;
					$nblignesmax=10000;
				break;
				}
			}
		else
			{
			$select_nbligne=1;
			$nblignesmax=10;
			}
		
		//récupération de la page courrante à afficher
		if(isset($_GET["currentpage"]) && isset($_GET["id_act"]))
			{
			if($_GET["id_act"]==$followup->id_act)
				{
				$numpages=$_GET["currentpage"];
				}
			else
				{
				$numpages=1;
				}
			}
		else
			{
			$numpages=1;
			}
			
		//Calcul du nb de page:
			$respage=array();
			//$nblignesmax=1;
			//$numpages=1;
			$respage=$followup->getFollowupTotSub($followup, $nblignesmax);
			$nbpages[$followup->id_act]=$respage[0];
			$currentpages[$followup->id_act]=$numpages;
			
		//retourne les abonnements triés correspondant au suivi d'une activité
		//évol #42
		//trier par 1: id_abn desc
		//		  2: id_abn asc
		//		  3: Nom desc, id_abn
		//		  4: Nom asc, id_abn
		//		  7 (0 || null): Statut_act desc, id_abn
		//		  8: Statut_act asc, id_abn
		$order=0;	
		//si on a cliqué sur un tri
		if(isset($_GET['order']))
			{
			//pour afficher la position de la flèche de tri
			$order=$_GET['order'];
			
			//retourne les abonnements correspondant au suivi d'une activité
			$id_abns=$followup->getFollowupSub($followup, $_GET['order'], $numpages, $nblignesmax);
			}
		else
			{
			$id_abns=$followup->getFollowupSub($followup, 0, $numpages, $nblignesmax);
			}
		//fin évol #42
		
		//pour chaque activité activité
			$activity = new Activity();
			//récupération de l'id_group ainsi que le nom du groupe managé
			$activity->id_group = $followup->id_act;
			//récupération du nombre d'inscrits
			$group2=new Group();
			$group2->load($followup->id_act);
			$nbinscr[$followup->id_act]=$group2->getMemberCount(true);
			 
			//hydrate l'activité avec les données de la bdd. L'objet passé en paramètre doit être une activité avec un id_group valide
			$activity->getActivity($activity);
			$activities[$followup->id_act]=$activity;
			
		//pour chaque abonnement
		foreach ( $id_abns as  $key => $value ) 
			{
			$followup= new Followup;
			$followup->id_act=$id_act2;
			$followup->id_abn=$value;
			$followup->getAdh($followup);//récupère l'id_adh
			$followup->getFollowup($followup);
			$followups[$id_act2][$value]=$followup;
			//récupération de la date et du statut act
			$subscription= new Subscription;
			$subscription->id_abn=$value;
			$subscription->getSubscription($subscription);
			//formatage de la date pour affichage
			$date=DateTime::createFromFormat('Y-m-d', $subscription->date_demande);
			$subscription->date_demande=$date->format('d-m-Y');
			
			$subscriptions[$id_act2][$value]=$subscription;
			
			//récupération du nom d'adhérent
			$member = new Adherent();
			//on rempli l'Adhérent par ses caractéristiques à l'aide de son id
			$member->load($followup->id_adh);
			$members[$id_act2][$value]=$member;
			$members[$id_act2][$value]=$member;
			$id_adh=$followup->id_adh;
			require 'includes/tarif.php';
			
			$statuts[$id_act2][$value]=$statut;
			
			
			}//fin du foreach abn

		//---------------------------------------------------------------------------------->
		
		
		}//fin du foreach activité
		
	}//fin du if member
			
//si la personne loggé fait parti du staff sans pour autant gérer un group alors on affiche tous les groups
if($login->isSuperAdmin() || $login->isAdmin() || $login->isStaff())
	{
	//passage des informations au template
	$tpl->assign('page_title', _T("Subscriptions Management for staff"));
	$groups=array();
	//on charge tous les groupes
	$groups=Groups::getList();
	$activities=array();
	$nbinscr=array();
	$followups=array();
	$subscriptions=array();
	$members=array();
	$statuts=array();//statuts adh
			
	$id_abns=array();
	
	//evol#55 suppression des adherents non abonnés depuis 2 ans (staff et managers de group exclus)
	if(isset($_GET['clean_adh']))
		{
				
				 $filters = new MembersList();
				 $members2 = new Members($filters);
				 $adherent_del=new Adherent();
				 $members_list = $members2->getMembersList(1,null,0,0,0,0,0);
				
				 //creation d'une boucle
				 foreach ( $members_list as  $keydel => $valuedel ) 
					{
					 $adherent_del=$members_list[$keydel];
						 
					if($adherent_del->isStaff2()==false)
						{
						$lastsubsdate= \DateTime::createFromFormat('j/m/Y',$adherent_del->modification_date);
						$today= new \DateTime("now");
						$elapse=$lastsubsdate->diff($today);
						$elapse=$elapse->format('%Y');
						if( $elapse>=2)
							{
							$members2->removeMembers($adherent_del->id);
							}
						}//fin if staff
					}//fin foreach
				
		}//fin evol #55	
		
	foreach ( $groups as  $key2 => $value2 ) 
		{
		//ma partie
		//------------------------------------------------------->		
		//récupération des abonnements de l'activité
		$followup= new Followup;
		$id_act2=$groups[$key2]->getId();
		$followup->id_act=$id_act2;

		//si c'est une nouvelle saison pour l'activité on supprime suivi, doc et on retire le membre du group. 
		//Si l'abonnement ne contient plus d'activité, on le supprime
		
			if(isset($_GET['remove_id_act']))
				{
				if($_GET['remove_id_act']==$id_act2)
					{
										
					//suppression des suivis concernant l'activité en question pour tout adhérent
					$followup2=new Followup();
					$followup2->id_act=$id_act2;
						//suppression des abonnements mono activité .
						//l'abonnement n'est pas supprimé s'il reste plus d'une activité dans l'abonnement avec une saison en cours
						$id_anbs2=$followup2->getFollowupSub($followup2);
						//pour chaque abn compter le nb d'activité (getFollowupAct)
						foreach ( $id_anbs2 as $key5 => $id_abn2)
							{
							$followup2->id_abn=$id_abn2;
							$followup2->getFollowupAct($followup2);
							//si plusieurs activités sont concernées par l'abonnement
							if(count($followup2->getFollowupAct($followup2))>1)
								{
								//supprime le suivi sur le paramètre id_act	
								$followup2->remove($followup2);
								}//fin du if
							//si il ne reste plus qu'une activité, on supprime l'abonnement qui supprime le reste en cascade	
							else
								{
								$subscription2= new Subscription;
								$subscription2->id_abn=$id_abn2;
								$subscription2->remove($subscription2);
								}
							}//fin du foreach
					
					
					//Lorsqu'un membre du staff supprime un fichier quelconque, ceci lance la fonction de nettoyage file/clean_file() 
					
					//on retire les membres de l'activité/du groupe en fin de saison
					$activity2=new Activity();
					$activity2->remove($id_act2);
					$valid=$id_act2;
					}//fin du if $_GET
				}//fin du isset GET
		//fin de la nouvelle saison		
		//-------------------------------------------------------------------------------------------------------------->
		
		
		//évol #42 tri et selection du nombre de résultat par page
		//récupération du nombre de lignes à afficher
		if(isset($_GET["nbligne"]) && isset($_GET["id_act"]))
			{
			switch($_GET["nbligne"])
				{
				case "0":
					$select_nbligne=0;
					$nblignesmax=5;
				break;
				case "1":
					$select_nbligne=1;
					$nblignesmax=10;
				break;
				case "2":
					$select_nbligne=2;
					$nblignesmax=20;
				break;
				case "3":
					$select_nbligne=3;
					$nblignesmax=50;
				break;
				case "4":
					$select_nbligne=4;
					$nblignesmax=10000;
				break;
				}
			}
		else
			{
			$select_nbligne=1;
			$nblignesmax=10;
			}
		
		//récupération de la page courrante à afficher
		if(isset($_GET["currentpage"]) && isset($_GET["id_act"]))
			{
			if($_GET["id_act"]==$followup->id_act)
				{
				$numpages=$_GET["currentpage"];
				}
			else
				{
				$numpages=1;
				}
			}
		else
			{
			$numpages=1;
			}
			
		//Calcul du nb de page:
			$respage=array();
			//$nblignesmax=1;
			//$numpages=1;
			$respage=$followup->getFollowupTotSub($followup, $nblignesmax);
			$nbpages[$followup->id_act]=$respage[0];
			$currentpages[$followup->id_act]=$numpages;
			
		//retourne les abonnements triés correspondant au suivi d'une activité
		//évol #42
		//trier par 1: id_abn desc
		//		  2: id_abn asc
		//		  3: Nom desc, id_abn
		//		  4: Nom asc, id_abn
		//		  7 (0 || null): Statut_act desc, id_abn
		//		  8: Statut_act asc, id_abn
		$order=0;	
		//si on a cliqué sur un tri
		if(isset($_GET['order']))
			{
			//pour afficher la position de la flèche de tri
			$order=$_GET['order'];
			
			//retourne les abonnements correspondant au suivi d'une activité
			$id_abns=$followup->getFollowupSub($followup, $_GET['order'], $numpages, $nblignesmax);
			}
		else
			{
			$id_abns=$followup->getFollowupSub($followup, 0, $numpages, $nblignesmax);
			}
		//fin évol #42
		
		//pour chaque activité
			$activity = new Activity();
			//récupération de l'id_group ainsi que le nom du groupe managé
			$activity->id_group = $followup->id_act;
			//récupération du nombre d'inscrits
			$group2=new Group();
			$group2->load($followup->id_act);
			$nbinscr[$followup->id_act]=$group2->getMemberCount(true);
			 
			//hydrate l'activité avec les données de la bdd. L'objet passé en paramètre doit être une activité avec un id_group valide
			$activity->getActivity($activity);
			$activities[$followup->id_act]=$activity;
			
		//pour chaque abonnement
		foreach ( $id_abns as  $key => $value ) 
			{
			$followup= new Followup;
			$followup->id_act=$id_act2;
			$followup->id_abn=$value;
			$followup->getAdh($followup);//récupère l'id_adh
			$followup->getFollowup($followup);
			$followups[$id_act2][$value]=$followup;
			//récupération de la date et du statut act
			$subscription= new Subscription;
			$subscription->id_abn=$value;
			$subscription->getSubscription($subscription);
			//formatage de la date pour affichage
			$date=DateTime::createFromFormat('Y-m-d', $subscription->date_demande);
			$subscription->date_demande=$date->format('d-m-Y');
			
			$subscriptions[$id_act2][$value]=$subscription;
			
			//récupération du nom d'adhérent
			$member = new Adherent();
			//on rempli l'Adhérent par ses caractéristiques à l'aide de son id
			$member->load($followup->id_adh);
			$members[$id_act2][$value]=$member;
			
			$id_adh=$followup->id_adh;
			require 'includes/tarif.php';
			
			$statuts[$id_act2][$value]=$statut;
			
			}//fin du foreach abn

		//---------------------------------------------------------------------------------->
		
		
		}//fin du foreach act
	
	}//fin du if staff

	
$tpl->assign('subscriptions',$subscriptions);
$tpl->assign('members',$members);
$tpl->assign('order',$order);
$tpl->assign('activities',$activities);
$tpl->assign('followups',$followups);
$tpl->assign('statuts',$statuts);
$tpl->assign('nbinscr',$nbinscr);
$tpl->assign('nbpages',$nbpages);
$tpl->assign('currentpages',$currentpages);
$tpl->assign('select_nbligne',$select_nbligne);
$tpl->assign('valid',$valid);

//traitement de la sélection de l'activité, evol#48
if(isset($_GET["id_act"]))
	{
	$id_act_s=$_GET["id_act"];
	$tpl->assign('id_act_s',$id_act_s);
	//activté sélectionnée dans la liste déroulante
	}
//fin de l'évol + voir assign


//Set the path to the current plugin's templates,
//but backup main Galette's template path before
$orig_template_path = $tpl->template_dir;
$tpl->template_dir = 'templates/' . $preferences->pref_theme;

$content = $tpl->fetch('management_subs.tpl', SUBSCRIPTION_SMARTY_PREFIX);
$tpl->assign('content', $content);
//Set path to main Galette's template
$tpl->template_dir = $orig_template_path;
$tpl->display('page.tpl', SUBSCRIPTION_SMARTY_PREFIX);
?>

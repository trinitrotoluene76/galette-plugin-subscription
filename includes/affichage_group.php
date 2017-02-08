<?php
/**
 * code call by About_group.php and new_subscription.php for galette Subscription plugin
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

//on charge tous les groupes. (j'ai une erreur qui n'empeche pas le fonctionnement mais qui apparait dans le log "Non-static method Activity::getList() should not be called statically"
	$group=Activity::getList(true);
	//recherche des groupes parents
	$parent_groups=Activity::get_parentgrouplist();
	$parent_group_name=$parent_groups[0]->getName();
	$is_parent_member=$member->isGroupMember($parent_group_name);
	
	$activities;//=$activity0, $activity1, $activity2...
	foreach ($group as $key => $value) 
		{
			$group[$key];
			//création de l'objet activité
			$activity = new Activity();
			//récupération de l'id_group ainsi que le nom du groupe managé
			$activity->id_group = $group[$key]->getId();
			$activity->group_name = $group[$key]->getName();
			 
			//recherche les groupes de l'adhérent
			$members[$key]=$member->isGroupMember($group[$key]->getName());
			
			//hydrate l'activité avec les données de la bdd. L'objet passé en paramètre doit être une activité avec un id_group valide
			$activity->getActivity($activity);
			$activities[$key]=$activity;
		}//fin du foreach

?>
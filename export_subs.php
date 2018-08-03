<?php

/**
 * ATTENTION CE FICHIER EST SPECIFIQUE AS NEXTER POUR L'INSTANT.
 * Export for galette Subscription plugin
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
use Galette\IO\Csv;
use Galette\IO\CsvOut;

$csv = new CsvOut();
$written = array();
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

//début création du fichier d'export
//récupération du id_act
if(isset($_GET['id_act']))
{
$id_act=$_GET['id_act'];
}
else
{
$id_act=0;
}

//Création des fichiers excel au chargement de cette page.

//Liste des abonnements de la section concernée (avec l'appartenance et le statut de l'abn RAJOUTER données de l'objet subscription):
//fichier nommé: liste_abn_appartenance_statut_'.$id_act.'.csv'

$select = $zdb->select('subscription_followup', 'f2');
            $select->join(array('s' => 'galette_subscription_subscriptions'),
								's.id_abn=f2.id_abn');
			$select->join(array('d' => 'galette_dynamic_fields'),
								'd.item_id=f2.id_adh');
			$select->join(array('f' => 'galette_field_contents_5'),
								'f.id=d.field_val');
			$select->join(array('a' => 'galette_adherents'),
								'a.id_adh=f2.id_adh');
			$select->where(array('f2.id_act'=> $id_act,
					  'd.field_id'=> '5'))//filtre sur l'activité concernée
										  //filtre sur le champ dynamique 5 = appartenance
				   ->group('f2.id_abn');
			$results = $zdb->execute($select);
			$result = array();
			foreach ( $results as $row ) {
				 $result[] = $row;
            }
//ajout des entetes
	array_unshift($result,array ('id_act','id_adh','id_abn (identifiant de l\'abonnement)','statut_act: 0=en cours, 1=validé, 2=payé, 3=refusé','feedback act','message adh act (Message de l\'abonné pour l\'activité)','feedback off','date de la demande d\'abonnement', 'total estimmé lors de l\'abonnement','message de l\'abonné concernant l\'abonnement','id_adh','item_id','field_id','field_form','val_index','id','Appartenance','id_statut','nom_adh','prenom_adh','pseudo','société','titre adh','date de naissance','sexe (0=non spécifié, 1=M, 2=F)','adresse','adresse2','code postal','ville','pays','tel','gsm','mail','url','icq','msn','jabber','info','info publique','profession','login','mdp','date de création du profil','date de modification du profil','activite_adh','bool admin','bool exempt','bool display','date echeance','pref lanque','lieu de naissance','gpgid','fingerprint','parent_id'));
        if ( $results->count() > 0 ) {
            $filename ='liste_abn_appartenance_statut_'.$id_act.'.csv';
            $filepath = CsvOut::DEFAULT_DIRECTORY . $filename;
            $fp = fopen($filepath, 'w');
            if ( $fp ) {
                $res = $csv->export(
                    $result,
					Csv::DEFAULT_SEPARATOR,
                    Csv::DEFAULT_QUOTE,
                    true,
                    $fp
                );
                fclose($fp);
                $written[] = array(
                    'name' => $filename,
                    'file' => $filepath
                );
            }
		}

//Création du fichier excel: liste des adhérents de la section (avec l'appartenance):
$select = $zdb->select('adherents', 'a');
            $select->join(array('g' => 'galette_groups_members'),
								'g.id_adh=a.id_adh');
			$select->join(array('d' => 'galette_dynamic_fields'),
								'd.item_id=a.id_adh');
			$select->join(array('f' => 'galette_field_contents_5'),
								'f.id=d.field_val');
			$select->where(array('g.id_group'=> $id_act,
								'd.field_id'=> '5')
								)//filtre sur l'activité concernée
								//filtre sur le champ dynamique 5 = appartenance
					->group('a.id_adh');
			$results = $zdb->execute($select);
			$result = array();
			foreach ( $results as $row ) {
				 $result[] = $row;
            }
//ajout des entetes
	array_unshift($result,array ('id_adh','id_statut','nom_adh','prenom_adh','pseudo','société','titre adh','date de naissance','sexe (0=non spécifié, 1=M, 2=F)','adresse','adresse2','code postal','ville','pays','tel','gsm','mail','url','icq','msn','jabber','info','info publique','profession','login','mot de passe crypté','date de création du profil','date de modification du profil','activite_adh','bool admin','bool exempt','bool display','date echeance','pref lanque','lieu de naissance','gpgid','fingerprint','parent_id','id_group','id_adh','item_id','field_id','field_form','val_index','id','Appartenance'));
        if ( $results->count() > 0 ) {
            $filename ='liste_adherents_appartenance_'.$id_act.'.csv';
            $filepath = CsvOut::DEFAULT_DIRECTORY . $filename;
            $fp = fopen($filepath, 'w');
            if ( $fp ) {
                $res = $csv->export(
                    $result,
                    Csv::DEFAULT_SEPARATOR,
                    Csv::DEFAULT_QUOTE,
                    true,
                    $fp
                );
				fclose($fp);
                $written[] = array(
                    'name' => $filename,
                    'file' => $filepath
                );
            }
		}

//
//Liste des abonnements toutes sections:
//fichier nommé: liste_abn_appartenance_statut_globale.csv'

$select = $zdb->select('subscription_followup', 'f2');
            $select->join(array('s' => 'galette_subscription_subscriptions'),
								's.id_abn=f2.id_abn');
			$select->join(array('b' => 'galette_subscription_activities'),
								'b.id_group=f2.id_act');
			$select->join(array('d' => 'galette_dynamic_fields'),
								'd.item_id=f2.id_adh');
			$select->join(array('f' => 'galette_field_contents_5'),
								'f.id=d.field_val');
			$select->join(array('g' => 'galette_groups'),
								'g.id_group=f2.id_act');
			$select->join(array('a' => 'galette_adherents'),
								'a.id_adh=f2.id_adh');
			$select->where(array('d.field_id'=> '5'));//filtre sur le champ dynamique 5 = appartenance
			$results = $zdb->execute($select);
			$result = array();
			foreach ( $results as $row ) {
				 $result[] = $row;
            }
//ajout des entetes
	array_unshift($result,array ('id_act','id_adh','id_abn (identifiant de l\'abonnement)','statut_act: 0=en cours, 1=validé, 2=payé, 3=refusé','feedback act','message adh act (Message de l\'abonné pour l\'activité)','feedback off','date de la demande d\'abonnement', 'total estimmé lors de l\'abonnement','message de l\'abonné concernant l\'abonnement','id_group','Tarif Nexter','Tarif Enfant NS moins 18ans','Tarif Enfant NS moins de 25 ans','Tarif Exterieur','lieu','jours','horaires','renseignements','complet','autovalidation','id_adh','item_id','field_id','field_form','val_index','id','Appartenance','nom de la section', 'date de creation de la section', 'id_section parente', 'id_statut','nom_adh','prenom_adh','pseudo','société','titre adh','date de naissance','sexe (0=non spécifié, 1=M, 2=F)','adresse','adresse2','code postal','ville','pays','tel','gsm','mail','url','icq','msn','jabber','info','info publique','profession','login','mdp','date de création du profil','date de modification du profil','activite_adh','bool admin','bool exempt','bool display','date echeance','pref lanque','lieu de naissance','gpgid','fingerprint','parent_id'));
        if ( $results->count() > 0 ) {
            $filename ='liste_abn_appartenance_statut_global.csv';
            $filepath = CsvOut::DEFAULT_DIRECTORY . $filename;
            $fp = fopen($filepath, 'w');
            if ( $fp ) {
                $res = $csv->export(
                    $result,
					Csv::DEFAULT_SEPARATOR,
                    Csv::DEFAULT_QUOTE,
                    true,
                    $fp
                );
                fclose($fp);
                $written[] = array(
                    'name' => $filename,
                    'file' => $filepath
                );
            }
		}		
//-------->fin création du fichier


$tpl->assign('page_title', _T("Export"));

$tpl->assign('id_act',$id_act);
		
//Set the path to the current plugin's templates,
//but backup main Galette's template path before
$orig_template_path = $tpl->template_dir;
$tpl->template_dir = 'templates/' . $preferences->pref_theme;

$content = $tpl->fetch('export_subs.tpl', SUBSCRIPTION_SMARTY_PREFIX);
$tpl->assign('content', $content);
//Set path to main Galette's template
$tpl->template_dir = $orig_template_path;
$tpl->display('page.tpl', SUBSCRIPTION_SMARTY_PREFIX);
?>
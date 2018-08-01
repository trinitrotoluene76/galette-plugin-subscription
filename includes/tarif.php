<?php
/**
 * Tarif for galette Subscription plugin
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
use Galette\Entity\DynamicFields as DynamicFields;
use Galette\DynamicFieldsTypes\DynamicFieldType as DynamicFieldType;

//Nom du champ dynamique comportant les différents choix
$Field_name='Appartenance';

//--------------------------------->récupération des valeurs du champ dynamique "Appartenance":
$dyn_fields = new DynamicFields();

// declare dynamic field values
$adherent0 = $dyn_fields->getFields('adh', $id_adh, true);

// - declare dynamic fields for display
$disabled['dyn'] = array();
$dynamic_fields = $dyn_fields->prepareForDisplay(
    'adh',
    $adherent0,
    $disabled['dyn'],
    0
);
foreach ( $dynamic_fields as $k => $v ) 
	{
	//modification pour bug #40
	if($dynamic_fields[$k]['field_name'] == $Field_name || $dynamic_fields[$k]['field_name'] == $Field_name." (not translated)")
	//fin de la modif
		{
		//récupération des statuts (personnel NS, ext...)
		$form_name=$dynamic_fields[$k]['choices'];

		}
	}
//------------------------------------------------>récupération des valeurs du champ dynamique "Appartenance" fin


/**
 * Exécute une requête SQL retournant le statut (champ dynamique "Appartenance") de l'adhérent (ne fonctionne pas pour le super admin)
 * Retourne $statut
 * 
 * $statut=0 si il y a une erreur
 *
 * @param id_adh: l'id de l'adhérent et field_name: le nom du champ recherché, ici "Appartenance"
 */
 
	global $zdb;
		$statut=0;
		// dans un 1er temps on retourne le field_id et le field_val
		$select = $zdb->select(DynamicFields::TABLE, 'a');
		$select->join(
					array('b' => PREFIX_DB . DynamicFieldType::TABLE),
					'b.field_id = a.field_id'
					)
                ->where(array(
								'b.field_name'=> $Field_name,
								'a.item_id'=> $id_adh
							));
		$results = $zdb->execute($select);
		if ($results->count() == 1) 
			{
			$resultat= $results->current();
            $field_val=$resultat->field_val;
			$field_id=$resultat->field_id;
			
			//dans un 2eme temps on retourne la valeur du statut de l'adhérent
			$select2 = $zdb->select('field_contents_'.$field_id);
			$select2->where(array('id'=> $field_val));
			$results2 = $zdb->execute($select2);
			if ($results2->count() == 1) 
				{
				$resultat2= $results2->current();
				$statut=$resultat2->val;
				}//fin du 2eme if
			
			}//fin du 1er if
	
/**
 * classe l'adhérent dans une catégorie tarifaire
 * retourne $category
 * $category=[0]=Personnel Nexter et assimilés
 * $category=[1]=Extérieurs

$form_name
array (size=7)
Appartenance	
	[0] Nexter - Personnel 	Tarif 1 (€€)
	[1] Nexter - Conjoint ou Enfant	Tarif 1 (€€)
	[2] Nexter -  Prestataire, 	Tarif 1 (€€)
	[3] Nexter -  intérimaire, stagiaire, 	Tarif 1 (€€)
	[4] Nexter -  Filiales TNS MArs,  Nexter Training, Nexter Robotics	Tarif 1 (€€)
	[5] Extérieur - Retraité Nexter ou conjoint	Tarif 1 (€€)
	[6] Extérieur	Tarif 2 (€€€)
 */

 //si personnel différent de "extérieur" cf champ appartenance
if($statut!=$form_name[6])
	{
	$category=0; //Tarif 1 (€€)
	}

else
	{
	$category=1; //Tarif 2 (€€€)
	}

//---------------------------------------------------> 
?>
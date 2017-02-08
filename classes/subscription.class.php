<?php

/**
 * Subscription class for galette Subscription plugin
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
 
class Subscription {

    const TABLE = 'subscriptions';
    //clé primaire de la table subscriptions
	const PK = 'id_abn';

	//champs de la table subscriptions de la bdd
    private $_fields = array(
        '_id_abn' => 'integer',
        '_id_adh' => 'integer',
        '_date_demande' => 'datetime',
		'_total_estimme' => 'decimal',
        '_message_abn' => 'varchar(200)'
    );
	
	//variables le l'objet
    private $_id_abn;
    private $_id_adh;
    private $_date_demande;
    private $_total_estimme = 0.0;
    private $_message_abn = '';
    
    

    /**
     * Construit une nouvellle activité à partir de la BDD (à partir de son ID) ou vierge
     * 
     * @param int|object $args Peut être null, un ID ou une ligne de la BDD
     */
    public function __construct($args = null) {
        global $zdb;

        if (is_int($args)) {
            try {
                $select = $zdb->select(SUBSCRIPTION_PREFIX . self::TABLE);
                $select->where(self::PK . ' = ' . $args);
                $results = $zdb->execute($select);
            
				if ($results->count() == 1) {
                    $this->_loadFromRS($results->current());
                }
                
            } catch (Exception $e) {
                Analog\Analog::log(
                        'Something went wrong :\'( | ' . $e->getMessage() . "\n" .
                        $e->getTraceAsString(), Analog\Analog::ERROR
                );
            }
        } else if (is_object($args)) {
            $this->_loadFromRS($args);
        }
    }

    

    /**
     * Protège les guillemets et apostrophes en les transformant en caractères qui ne gênent pas en HTML
     * 
     * @param string $str Chaîne à transformée
     * 
     * @return string Chaîne protégée
     */
    private static function protectQuote($str) {
        return str_replace(array('\'', '"'), array('’', '“'), $str);
    }

  /**
	 * Exécute une requête SQL pour savoir si l'id_abn existe
     * Retourne 1 si l’id existe dans la table->update
	 * 0 s’il n’existe pas dans la table->insert
	 * $result=0
	 *
     * @param Subcription $object L'abonnement dont on cherche l'id abn
     */
    public function is_id_abn($object) 
		{
		global $zdb;
		$result=0;
		if($object->id_abn!=null)
			{		
			$req1 = $zdb->select(SUBSCRIPTION_PREFIX . self::TABLE);
			$req1->where(array('id_abn'=> $object->id_abn))
					->limit(1);
			$results = $zdb->execute($req1);		
			if ($results->count() == 1) 
				{
				$result=1;
				}//fin du 1er if
			}//fin du 1er if
		return $result;
		}//fin de la fonction
	
 

  /** Enregistre l'élément en cours que ce soit en insert ou update
     * 
     * @return bool False si l'enregistrement a échoué, true si aucune erreur
     */
    public function store() {
        global $zdb;

        try {
            $values = array();

            foreach ($this->_fields as $k => $v) {
                $values[substr($k, 1)] = $this->$k;
            }
			$res=$this->is_id_abn($this);
            if ($res=='0') 
				{
				$insert = $zdb->insert(SUBSCRIPTION_PREFIX . self::TABLE);
                $insert->values($values);
                $add = $zdb->execute($insert);
                if ($add > 0) 
					{
						$this->_id_abn = $zdb->driver->getLastGeneratedValue();
					} else {
							throw new Exception(_T("Subscription.AJOUT insert ECHEC"));
							}
				} 
			if ($res=='1') 
				{
				$update = $zdb->update(SUBSCRIPTION_PREFIX . self::TABLE);
                $update->set($values);
                $update->where(
                    self::PK . '=' . $this->_id_abn
                );
				$edit = $zdb->execute($update);
				if ($edit > 0) 
					{
					}else {
								throw new Exception(_T("Subscription.AJOUT update ECHEC"));
								}
				}
				
            return true;
			} catch (Exception $e) {
					Analog\Analog::log(
                    'Something went wrong :' . $e->getMessage() . "\n" .
                    $e->getTraceAsString(), Analog\Analog::ERROR
					);
            return false;
        }
    }

   /**
	 *
     * Exécute une requête SQL pour supprimer un abonnement
     * Retourne 1 si l'abonnement est supprimé, 0 sinon.
     * 
     * @param Subscription $object La subscription supprimer contenant l'id_abn.
     */
    static function remove($object) {
        global $zdb;

        $delete = $zdb->delete(SUBSCRIPTION_PREFIX . self::TABLE);
                $delete->where(
                    self::PK . ' = ' . $object->id_abn
                );
        $rem=$zdb->execute($delete);

		return $rem;
    }
 
    /**
	 *
     * Exécute une requête SQL pour récupérer les infos d'une subsription
     * Ne retourne rien.
     * 
     * @param Subscription $object La subscription à hydrater contenant l'id_abn.
     */
    static function getSubscription($object) {
        global $zdb;

        // Statut
        $select_id_abn = $zdb->select(SUBSCRIPTION_PREFIX . self::TABLE);
        $select_id_abn->where(array('id_abn'=> $object->id_abn))
                ->limit(1);
        $results = $zdb->execute($select_id_abn);
                            
        if ($results->count() == 1) {
            $subscription = $results->current();
            $object->_id_adh = $subscription->id_adh;
            $object->_date_demande = $subscription->date_demande;
            $object->_total_estimme = $subscription->total_estimme;
            $object->_message_abn = $subscription->message_abn;
        }
    }
 
 /**
	 *
     * Exécute une requête SQL pour récupérer la liste des subsriptions d'un adhérent
     * Retourne un tableau d'id_abn
     * 
     * @param Subscription $object La subscription à hydrater contenant l'id_adh.
     */
    static function getSubscriptionList($object) {
        global $zdb;

        // Statut
        $select_id_abn = $zdb->select(SUBSCRIPTION_PREFIX . self::TABLE);
        $select_id_abn->where(array('id_adh'=> $object->id_adh));
        $subscriptions = $zdb->execute($select_id_abn);
        $result=0;
        if ($subscriptions->count() > 0) 
			{
				$result=array();
				foreach ( $subscriptions as  $key => $value ) 
					{
					$result[]=$value->id_abn;
					}
			}//fin du if
			
		return $result;
    }

	    /**
     * Retrieve fields from database.copy past from Adherent
     *
     * @return array
     */
    public static function getDbFields()
    {
     global $zdb;
        $columns = $zdb->getColumns(SUBSCRIPTION_PREFIX . self::TABLE);
        $fields = array();
        foreach ( $columns as $col ) {
            $fields[] = $col->getName();
        }
        return $fields;
	}
	
	
	 /**
	 * Check posted values validity
	 *
	 * @param array $values   All values to check, basically the $_POST array
	 *                        after sending the form
	 *
	 * @return true|array
	 */
	public function check($values)
	{
		global $zdb;
		$valid = '1';
		$fields = self::getDbFields();
	foreach ( $fields as $key ) {
				//first of all, let's sanitize values
				$key = strtolower($key);
				if ( isset($values[$key]) ) {
					$value = stripslashes(trim($values[$key]));
					$this->$key=$value;
				}			
			}
			
	return $valid;
	}			
 
 
    /**
     * Global getter method
     *
     * @param string $name name of the property we want to retrive
     *
     * @return false|object the called property
     */
    public function __get($name) {
        $rname = '_' . $name;
        if (substr($rname, 0, 3) == '___') {
            return false;
        }
        switch ($name) {
            case 'message_abn':
                return str_replace('\'', '’', $this->_message_abn);
            case 'total_estimme':
               // return number_format($this->_total_estimme, 2, ',', ' ');
            
            default:
                return $this->$rname;
		 
        }
    }

    /**
     * Global setter method
     *
     * @param string $name  name of the property we want to assign a value to
     * @param object $value a relevant value for the property
     *
     * @return void
     */
    public function __set($name, $value) {
        $rname = '_' . $name;
        $this->$rname = $value;
    }

}

?>

<?php

/**
 * File class for galette Subscription plugin
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
 
class File {

    const TABLE = 'files';
    //clé primaire de la table files
	const PK = 'id_doc';

	//champs de la table files de la bdd
    private $_fields = array(
        '_id_doc' => 'integer',
        '_id_act' => 'integer',
        '_id_adh' => 'integer',
        '_id_abn' => 'integer',
        '_doc_name' => 'varchar(200)',
        '_description' => 'varchar(200)',
        '_emplacement' => 'varchar(200)',
        '_date_record' => 'datetime',
		'_vierge' => 'integer',
		'_return_file' => 'integer'
    );
	
	//variables le l'objet
    private $_id_doc;
	private $_id_act;
	private $_id_adh;
	private $_id_abn;
	private $_doc_name='';
	private $_description='';
	private $_emplacement='';
	private $_date_record='';
	private $_vierge=0;//0= document quelconque / 1=document provenant de la page de gestion des groupes
	private $_return_file=0;//0= document informatif / 1=formulaire à télécharger, remplir et à retourner
	    
    

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
     * Populate object from a resultset row
     *
     * @param ResultSet $r the resultset row
     *
     * @return void
     */
    private function _loadFromRS($r)
    {
        $this->_id_doc = $r->id_doc;
		$this->_id_act= $r->id_act;
		$this->_id_adh= $r->id_adh;
		$this->_id_abn= $r->id_abn;
		$this->_doc_name=$r->doc_name;
		$this->_description= $r->description;
		$this->_emplacement= $r->emplacement;
		$this->_date_record= $r->date_record;
		$this->_vierge= $r->vierge;
		$this->_return_file= $r->return_file;
        
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
	 * Exécute une requête SQL pour savoir si l'id_doc à créer est valide (est présent dans la table file)
     * Retourne 1 si l’id existe dans la table file->update
	 * 0 s’il n’y est pas
	 * $result=0
	 *
     * @param 
     */
    public function is_id_doc() 
		{
		global $zdb;
		$result=0;
		if($this->_id_doc!=NULL)
			{
			$req1 = $zdb->select(SUBSCRIPTION_PREFIX . self::TABLE);
			$req1->where(array('id_doc'=> $this->_id_doc))
					->limit(1);
			$results = $zdb->execute($req1);		
			if ($results->count() == 1) 
				{
				$result=1;
				}//fin du 1er if
			}
		return $result;
		}//fin de la fonction
	


  /** 
     * Enregistre l'élément en cours que ce soit en insert ou update
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
			$res=$this->is_id_doc();
            if ($res=='0') 
				{
				$insert = $zdb->insert(SUBSCRIPTION_PREFIX . self::TABLE);
				$insert->values($values);
                $add = $zdb->execute($insert);
                if ($add->count() > 0) 
					{
						$this->_id_doc = $zdb->driver->getLastGeneratedValue();
					} else {
							throw new Exception(_T("file.AJOUT ECHEC"));
							}
				} 
			if ($res=='1') 
				{
				$update = $zdb->update(SUBSCRIPTION_PREFIX . self::TABLE);
                $update->set($values);
                $update->where(
                    self::PK . '=' . $this->_id_doc
                );
                $edit = $zdb->execute($update);
				}else {
								throw new Exception(_T("file.AJOUT ECHEC"));
								}
            return true;
			} catch (Exception $e) {
					Analog\Analog::log(
                    'Something went wrong :\'( | ' . $e->getMessage() . "\n" .
                    $e->getTraceAsString(), Analog\Analog::ERROR
					);
            return false;
        }
    }

  /**
     * supprime le doc de la table file et de son emplacement sur le serveur
     *
     * @param path le chemin + nom du fichier à supprimer
	 *		  nom le nom du fichier en question
	 * Return 1 si ok, 0 sinon
	 * exemple $file_del->remove("./upload/files/".$file_del->emplacement,$file_del->emplacement);
     */
	 
	 static function remove($path,$nom) {
	 
        global $zdb;
		$where=array(
					"emplacement='".$nom."'"
					); 
		$delete = $zdb->delete(SUBSCRIPTION_PREFIX . self::TABLE);
        $delete->where($where);
        $res2=$zdb->execute($delete);
		if(file_exists($path))
			{
			$res1=unlink($path);
			$res=0;
			if($res1==1 && $res2==true)
				{
				$res=1;
				}
			
			}
		
		return $res;
    }
	
	/**
     * Liste les fichiers d'un répertoire si le fichier n'est pas dans la bdd, il est stocké dans un tableau de résultat (ne concerne pas les répertoires)
     *
     * @param $pathrep emplacement du répertoire
	 * Return un tableau contenant les emplacements des fichiers non présent en base (123587_5_1.jpg, mother.pdf...)
				-1 si Répertoire non accessible !
				-2 si repertoire vide
     */
	 

	static function listrep($pathrep)
	{
	global $zdb;
	$res =-1;
		//si le répertoire existe, on l'ouvre
		if ($rep = opendir($pathrep)) 
		{
			//tant q'il y a des fichiers
			while ($element = readdir($rep))
			{
			   $ext=strrchr($element,'.');
			   //si le fichier n'est pas un répertoire
			   if (!is_dir($pathrep.'/'.$element) && $ext)
				{
				
				//on execute une requete SQL pour savoir s'il est ds la bdd sinon on le stocke dans un tableau
				 $select_empl = $zdb->select(SUBSCRIPTION_PREFIX . self::TABLE);
				 $select_empl->where(array('emplacement'=> $element))
						->limit(1);
				 $results = $zdb->execute($select_empl);		
					if ($results->count() < 1) 
						{
						//on stocke son emplacement dans un tableau en vue de sa suppression
						$tri[$element] = $element;
						}
				}//fin du if
			}//fin du while
			closedir($rep);
			
			//si le tableau contient des fichiers
			if(isset($tri))
				{
				//Tri du tableau sur le nom.
				sort($tri);
				$res = $tri;
				}
			else
				{
				//repertoire vide
				$res= -2;
				}
		}
		else
			{
			//Répertoire non accessible !
			}
	return $res;
	}

	/**
     * Execute une requete SQL pour obtenir tous les vieux fichiers
	 * recherche dans la bdd si le fichier est dans la bdd + non vierge && date_record >2ans && fichier existe->delete + delete bdd
	 * script appelé par un bouton dédié dans management_subs.tpl
     *
     * @param rien
	 * Return les fichiers à supprimer
     */
	 
	 static function get_FileList_old() {
        //Liste les fichiers (hors formulaires) vieux de plus de 2 ans
		//paramètres
		$duree1=2;//en année
		
		global $zdb;
		$select =  $zdb->select(SUBSCRIPTION_PREFIX . self::TABLE);
		$left='date_record';
		$right=date("Y-m-d", strtotime('-'.$duree1.' years'));
		$select->where('vierge=0')
			   ->where->lessThanOrEqualTo($left,$right);
		$results = $zdb->execute($select);
        return $results;
	}
	
	/**
     * Execute une requete SQL pour obtenir tous les fichiers
	 *
     * @param 
	 *
	 * Return -1 s'il n'y a aucun fichier et les fichiers sinon
     */
	 
	 static function get_FileList_bdd() {
       	global $zdb;
		$results=-1;
		$select = $zdb->select(SUBSCRIPTION_PREFIX . self::TABLE);
        $results = $zdb->execute($select);
        return $results;
	 }
	
    /**
	*
     * Exécute une requête SQL pour récupérer les données d'un fichier à partir de son id_doc (fichier non vierge)
     * 
     * Ne retourne rien.
     * 
     * @param File $object Le fichier à hydrater
     */
    static function getFile($object) {
        global $zdb;

        // Statut
        $select_id_doc = $zdb->select(SUBSCRIPTION_PREFIX . self::TABLE);
        $select_id_doc->where(array('id_doc'=> $object->id_doc))
                ->limit(1);
        $results = $zdb->execute($select_id_doc);        
        if ($results->count() == 1) {
            $file = $results->current();
            $object->_id_act = $file->id_act;
            $object->_id_adh = $file->id_adh;
            $object->_id_abn = $file->id_abn;
            $object->_doc_name = $file->doc_name;
            $object->_description = $file->description;
            $object->_emplacement = $file->emplacement;
            $object->_date_record = $file->date_record;
            $object->_vierge = $file->vierge;
            $object->_return_file = $file->return_file;
            
        }
    }
	
	/**
	*
     * Exécute une requête SQL pour récupérer la liste des fichiers à partir de l'id_adh
     * 
     * Retourne un tableau de files si ils existent, 0 sinon
     * 
     * @param id_adh
     */
    public function getFileList() {
        global $zdb;
		$result=0;
		
		if($this->id_adh != NULL)
			{
			$where_id_adh=array('id_adh'=>$this->id_adh);
			}
		else
			{
			$where_id_adh='id_adh IS NULL';
			}
		
			$where_vierge=array('vierge'=>0);
			
        $select = $zdb->select(SUBSCRIPTION_PREFIX . self::TABLE);
        $select->where($where_vierge)
				->where($where_id_adh)
				->order('id_act');
        $results = $zdb->execute($select);        
        if ($results->count() > 0) 
			{
			$files = array();
            foreach ( $results as $row ) 
				{
				$files[] = new File($row);
				}
            $result=$files;
			}//fin du if
			
		return $result;
    }
	
	/**
	*
     * Exécute une requête SQL pour récupérer la liste des fichiers à partir de l'id_adh et id_act
     * 
     * Retourne un tableau de files si ils existent, 0 sinon
     * 
     * @param id_act, id_adh
     */
    public function getFileListAdh() {
        global $zdb;
		$result=0;
        
		if($this->id_act != NULL)
			{
			$where_id_act=array('id_act'=>$this->id_act);
			}
		else
			{
			$where_id_act='id_act IS NULL';
			}
		
		if($this->id_adh != NULL)
			{
			$where_id_adh=array('id_adh'=>$this->id_adh);
			}
		else
			{
			$where_id_adh='id_adh IS NULL';
			}
		
			$where_vierge=array('vierge'=>0);
			
		$select =$zdb->select(SUBSCRIPTION_PREFIX . self::TABLE);
        $select->where($where_vierge)
				->where($where_id_act)
				->where($where_id_adh)
				->order('id_doc');
        $results = $zdb->execute($select);  
        if ($results->count() > 0) 
			{
			$files = array();
            foreach ( $results as $row ) 
				{
					$files[] = new File($row);
				}
            $result=$files;
			
			}//fin du if
			
		return $result;
    }
	
	/**
	*
     * Exécute une requête SQL pour récupérer la liste des fichiers vierges (=provenant de la page mangement_group)
     * 
     * Retourne un tableau de files si ils existent, 0 sinon
     * 
     * @param id_act, id_abn, vierge optionnels
     */
    public function getFileListVierge() {
        global $zdb;
		$result=0;
        
		if($this->id_act != NULL)
			{
			$where_id_act=array('id_act'=>$this->id_act);
			}
		else
			{
			$where_id_act='id_act IS NULL';
			}
			$where_vierge=array('vierge'=>1);
			
		$select = $zdb->select(SUBSCRIPTION_PREFIX . self::TABLE);
        $select->where($where_vierge)
				->where($where_id_act)
				->order('id_doc');
        $results = $zdb->execute($select);  
        if ($results->count() > 0) 
			{
			$files = array();
            foreach ( $results as $row ) 
				{
					$files[] = new File($row);
				}
            $result=$files;
			}//fin du if
		return $result;
    }
	

	/**
	*
     * Exécute une requête SQL pour si un fichier existe dans la bdd à partir de son nom sur le disque {timestamp}_{id_act}_{id_fichier}.{extension}
     * 
     * Retourne 1 si le fichier a été trouvé 0 sinon.
     * 
     * @param File $object Le fichier à hydrater contenant le timestamp réduit nombre.(extension)
     */
    static function isFileExist($object) {
        global $zdb;
		$result=0;
		$select_timestamp = $zdb->select(SUBSCRIPTION_PREFIX . self::TABLE);
        $select_timestamp->where->Like('emplacement', $object->emplacement);
		$select_timestamp->limit(1);
        $results = $zdb->execute($select_timestamp); 
		if ($results->count() == 1) {
           $result=1;
        }
		return $result;
    }
	    /**
     * Retrieve fields from database
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
            case 'doc_name':
                return str_replace('\'', '’', $this->_doc_name);
            case 'decsription':
                return str_replace('\'', '’', $this->_decsription);
            case 'emplacement':
                return str_replace('\'', '’', $this->_emplacement);
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

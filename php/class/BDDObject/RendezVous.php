<?php

namespace BDDObject;

use DB;
use ErrorController as EC;
use SessionController as SC;
use MeekroDBException;

final class RendezVous extends Item
{
  protected static $BDDName = "rendezVous";
  protected static $BDDParentName = "offreRendezVous";

  ##################################### METHODES STATIQUES #####################################

  protected static function champs()
  {
    return array(
      'idOffre' => array( 'def' => "", 'type' => 'integer'),  // id du rdv parent
      'date' => array( 'def' => "", 'type'=> 'dateHeure'),  // jour et heure du rendez-vous
      'description' => array( 'def' => "", 'type'=> 'string'), // informations complémentaires pouvant être affichées
      'idEntUser' => array( 'def'=> "", 'type'=>'string')
      );
  }

  public static function getList($options = array())
  {
    require_once BDD_CONFIG;
    try {
      if (isset($options['idEntUser']))
      {
        $idEntUser = $options['idEntUser'];
        return DB::query("SELECT id, idOffre, date, description, idEntUser FROM ".PREFIX_BDD.self::$BDDName." WHERE idEntUser = %s", $idEntUser);
      }
      elseif (isset($options['idOffre']))
      {
        $idOffre = $options['idOffre'];
        return DB::query("SELECT id, idOffre, date, description, idEntUser FROM ".PREFIX_BDD.self::$BDDName." WHERE idOffre = %i", $idOffre);
      }
      else
      {
        return DB::query("SELECT id, idOffre, date, description, idEntUser FROM ".PREFIX_BDD.self::$BDDName);
      }
    } catch(MeekroDBException $e) {
      if (DEV) return array('error'=>true, 'message'=>"#RendezVous/getList : ".$e->getMessage());
      return array('error'=>true, 'message'=>'Erreur BDD');
    }
  }

  public static function deleteList($options = array())
  {
    if (self::SAVE_IN_SESSION) {
      SC::get()->unsetParam("creneauRendezVous");
    }
    require_once BDD_CONFIG;
    try {
      if (isset($options['idOffre'])) {
        DB::delete(PREFIX_BDD.self::$BDDName, "idOffre=%i", $options['idOffre']);
      } else if (isset($options['idEntUser'])) {
        DB::delete(PREFIX_BDD.self::$BDDName, "idEntUser=%s", $options['idEntUser']);
      } else if (isset($options['date'])) {
        DB::delete(PREFIX_BDD.self::$BDDName, "date < %s", $options['date']);
      }
      return true;
    } catch(MeekroDBException $e) {
      EC::addBDDError($e->getMessage(), "CreneauRendezVous/Suppression liste");
    }
    return false;
  }

  ##################################### METHODES #####################################

  public function insert_validation($data=array())
  {
    $errors = array();

    if (!isset($data['idOffre']))
    {
      $errors['idOffre'] = "Il faut préciser une offre";
    }

    if (!isset($data['date']))
    {
      $errors['date'] = "Il faut préciser une date et heure";
    }

    if (count($errors)>0)
      return $errors;
    else
      return true;
  }

  public function getParent()
  {
    return OffreRendezVous::getObject($this->values["idOffre"]);
  }
}

?>

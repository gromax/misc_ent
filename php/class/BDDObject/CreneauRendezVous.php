<?php

namespace BDDObject;

use DB;
use ErrorController as EC;
use SessionController as SC;
use MeekroDBException;

final class CreneauRendezVous extends Item
{
  protected static $BDDName = "creneauRendezVous";
  protected static $BDDParentName = "rendezVous";

  ##################################### METHODES STATIQUES #####################################

  protected static function champs()
  {
    return array(
      'idOffre' => array( 'def' => "", 'type' => 'integer'),  // id du rdv parent
      'date' => array( 'def' => "", 'type'=> 'date'),  // jour du créneau
      'debut' => array( 'def' => "Titre", 'type'=> 'time'),  // heure du début
      'fin' => array( 'def' => "", 'type'=> 'time'),  // heure de fin
      );
  }

  public static function getList($options = array())
  {
    require_once BDD_CONFIG;
    try {
      if (isset($options['idEntUser']))
      {
        $idEntUser = $options['idEntUser'];
        return DB::query("SELECT p.id, p.idOffre, p.date, p.debut, p.fin FROM (".PREFIX_BDD.self::$BDDName." p JOIN ".PREFIX_BDD.self::$BDDParentName." r ON r.id = p.idOffre) WHERE r.idEntUser = %s", $idEntUser);
      }
      elseif (isset($options['idOffre']))
      {
        $idOffre = $options['idOffre'];
        return DB::query("SELECT id, idOffre, date, debut, fin FROM ".PREFIX_BDD.self::$BDDName." WHERE idOffre = %i", $idOffre);
      }
      else
      {
        return DB::query("SELECT id, idOffre, date, debut, fin FROM ".PREFIX_BDD.self::$BDDName);
      }
    } catch(MeekroDBException $e) {
      if (DEV) return array('error'=>true, 'message'=>"#CreneauRendezVous/getList : ".$e->getMessage());
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

    if (!isset($data['date']))
    {
      $errors['idEntUser'] = "Il faut préciser l'id ENT de l'utilisateur";
    }

    if (!isset($data['debut']))
    {
      $errors['debut'] = "Il faut préciser une heure de début";
    }

    if (!isset($data['fin']))
    {
      $errors['fin'] = "Il faut préciser une heure de fin";
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

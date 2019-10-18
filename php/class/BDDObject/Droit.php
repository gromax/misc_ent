<?php

# Liste des droits
# 1 - créer rendez-vous

namespace BDDObject;

use DB;
use ErrorController as EC;
use SessionController as SC;
use MeekroDBException;

final class Droit extends Item
{
  protected static $BDDName = "droits";

  ##################################### METHODES STATIQUES #####################################

  protected static function champs()
  {
    return array(
      'idEntUser' => array( 'def' => "", 'type' => 'string'),  // id Ent de l'utilisateur
      'idDroit' => array( 'def' => 0, 'type'=> 'integer'),  // id du droit concerné
      );
  }

  public static function getList($options = array())
  {
    require_once BDD_CONFIG;
    try {
      if (isset($options['idEntUser']))
      {
        $idEntUser = $options['idEntUser'];
        return DB::query("SELECT id, idEntUser, idDroit FROM ".PREFIX_BDD."droits WHERE idEntUser = %s", $idEntUser);
      }
      else
      {
        return DB::query("SELECT id, idEntUser, idDroit FROM ".PREFIX_BDD."droits");
      }
    } catch(MeekroDBException $e) {
      if (DEV) return array('error'=>true, 'message'=>"#Droits/getList : ".$e->getMessage());
      return array('error'=>true, 'message'=>'Erreur BDD');
    }
  }

  public static function deleteList($options = array())
  {
    if (self::SAVE_IN_SESSION) {
      SC::get()->unsetParam("droits");
    }
    require_once BDD_CONFIG;
    try {
      if (isset($options['idEntUser'])) {
        DB::delete(PREFIX_BDD."droits", "idEntUser=%s", $options['idEntUser']);
      }
      return true;
    } catch(MeekroDBException $e) {
      EC::addBDDError($e->getMessage(), "Evenement/Suppression liste");
    }
    return false;
  }

  ##################################### METHODES #####################################

  public function insert_validation($data=array())
  {
    $errors = array();

    if (!isset($data['idEntUser']))
    {
      $errors['idEntUser'] = "Il faut préciser l'id ENT de l'utilisateur";
    }

    if (!isset($data['idDroit']))
    {
      $errors['idDroit'] = "Il faut préciser un droit";
    }

    if (isset($data['idEntUser']) && isset($data['idDroit']))
    {
      // il faut vérifier l'inexistance d'un couple de valeurs
      require_once BDD_CONFIG;
      try {
        $bdd_result = DB::queryFirstRow("SELECT id FROM ".PREFIX_BDD."droits WHERE idEntUser=%s AND idDroit=%i", $data['idEntUser'], $data['idDroit']);
      }
      catch(MeekroDBException $e)
      {
        if (DEV) return array('error'=>true, 'message'=>"#Droit/insert_validation : ".$e->getMessage());
        return array('error'=>true, 'message'=>'Erreur BDD');
      }
      if ($bdd_result !== null)
      {
        $errors['droit'] = "Ce utilisateur a déjà ce droit";
      }
    }

    if (count($errors)>0)
      return $errors;
    else
      return true;
  }
}

?>

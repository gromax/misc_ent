<?php

namespace BDDObject;

use DB;
use ErrorController as EC;
use SessionController as SC;
use MeekroDBException;

final class OffreRendezVous extends Item
{
  protected static $BDDName = "offreRendezVous";

  ##################################### METHODES STATIQUES #####################################

  protected static function champs()
  {
    return array(
      'idEntUser' => array( 'def' => "", 'type' => 'string'),  // id Ent de l'utilisateur
      'emailUser' => array( 'def' => "", 'type'=> 'string'),  // email de l'utilisateur
      'title' => array( 'def' => "Titre", 'type'=> 'string'),  // titre du rdv pour menu
      'description' => array( 'def' => "", 'type'=> 'string'),  // description détaillée
      'filter' => array( 'def' => "", 'type'=> 'string'),  // filtre pour classe...
      'rdvTime' => array( 'def' => 30, 'type'=> 'integer'),  // durée d'un rendez-vous, en min
      );
  }

  public static function getList($options = array())
  {
    require_once BDD_CONFIG;
    try {
      if (isset($options['idEntUser']))
      {
        $idEntUser = $options['idEntUser'];
        return DB::query("SELECT id, idEntUser, emailUser, title, description, filter, rdvTime FROM ".PREFIX_BDD.self::$BDDName." WHERE idEntUser = %s", $idEntUser);
      }
      else
      {
        return DB::query("SELECT id, idEntUser, emailUser, title, description, filter, rdvTime FROM ".PREFIX_BDD.self::$BDDName);
      }
    } catch(MeekroDBException $e) {
      if (DEV) return array('error'=>true, 'message'=>"#OffreRendezVous/getList : ".$e->getMessage());
      return array('error'=>true, 'message'=>'Erreur BDD');
    }
  }

  public static function deleteList($options = array())
  {
    if (self::SAVE_IN_SESSION) {
      SC::get()->unsetParam("offreRendezVous");
    }
    require_once BDD_CONFIG;
    try {
      if (isset($options['idEntUser'])) {
        DB::delete(PREFIX_BDD.self::$BDDName, "idEntUser=%s", $options['idEntUser']);
      }
      return true;
    } catch(MeekroDBException $e) {
      EC::addBDDError($e->getMessage(), "OffreRendezVous/Suppression liste");
    }
    return false;
  }

  ##################################### METHODES #####################################

  public function customDelete()
  {
    $options = array("idOffre"=>$this->id);
    return (CreneauRendezVous::deleteList($options));
  }

  public function insert_validation($data=array())
  {
    $errors = array();

    if (!isset($data['idEntUser']))
    {
      $errors['idEntUser'] = "Il faut préciser l'id ENT de l'utilisateur";
    }

    if (!isset($data['title']))
    {
      $errors['title'] = "Il faut préciser un titre";
    }

    if (isset($data['emailUser']) && ($data['emailUser']!="") && !preg_match("#^[a-zA-Z0-9_-]+(.[a-zA-Z0-9_-]+)*@[a-zA-Z0-9._-]{2,}\.[a-z]{2,4}$#", $data['emailUser']))
    {
      $errors['emailUser'] = "Adresse email invalide";
    }

    if (count($errors)>0)
      return $errors;
    else
      return true;
  }

  public function isOwner($idEntUser)
  {
    return ($this->values['idEntUser'] == $idEntUser);
  }

  public function getCreneauxList()
  {
    $liste = CreneauRendezVous::getList(array("idOffre"=>$this->id));
    if (isset($liste['error']))
    {
      return array();
    }
    else
    {
      return $liste;
    }
  }
}

?>

<?php

namespace RouteController;
use ErrorController as EC;
use AuthController as AC;
use BDDObject\OffreRendezVous;
use BDDObject\CreneauRendezVous;
use BDDObject\Droit;

class rendezVousManager
{
    /**
     * paramères de la requète
     * @array
     */
    private $params;
    /**
     * Constructeur
     */
    public function __construct($params)
    {
        $this->params = $params;
    }

    public function fetch()
    {
        $ac = new AC();
        $user = $ac->getloggedUserData();
        if ($user["type"]=="off")
        {
            EC::set_error_code(401);
            return false;
        }

        $id = (integer) $this->params['id'];
        $item=OffreRendezVous::getObject($id);
        if ($item === null)
        {
            EC::set_error_code(404);
            return false;
        }

        return array(
            "offre" => $item->getValues(),
            "creneaux" => $item->getCreneauxList()
        );
    }

    public function fetchList()
    {
        $ac = new AC();
        $user = $ac->getloggedUserData();
        if ($user["type"]=="off")
        {
            EC::set_error_code(401);
            return false;
        }
        return OffreRendezVous::getList();
    }

    public function delete()
    {
        $ac = new AC();
        $user = $ac->getloggedUserData();
        if (!Droit::has($user["login"], 1))
        {
            // vérification du droit d'écrire les rendez-vous
            EC::set_error_code(403);
            return false;
        }

        $id = (integer) $this->params['id'];
        $item=OffreRendezVous::getObject($id);
        if ($item === null)
        {
            EC::set_error_code(404);
            return false;
        }

        if ($item->delete())
        {
            return array( "message" => "Model successfully destroyed!");
        }
        EC::set_error_code(501);
        return false;
    }

    public function deleteCreneau()
    {
        $ac = new AC();
        $user = $ac->getloggedUserData();
        if ($user["type"]=="off")
        {
            EC::set_error_code(401);
            return false;
        }
        $id = (integer) $this->params['id'];
        $itemCreneau = CreneauRendezVous::getObject($id);
        if ($itemCreneau === null)
        {
            EC::set_error_code(404);
            return false;
        }
        if (!Droit::has($user["login"], 1))
        {
            // vérification du droit d'écrire les rendez-vous
            // Peut-être l'utilisateur est le propriétaire
            $itemParent = $itemCreneau.getParent();
            if (($itemParent === null)||!$itemParent->isOwner($user["login"]))
            {
                EC::set_error_code(403);
                return false;
            }
        }
        if ($itemCreneau->delete())
        {
            return array( "message" => "Model successfully destroyed!");
        }
        EC::set_error_code(501);
        return false;
    }

    public function insert()
    {
        $ac = new AC();
        $user = $ac->getloggedUserData();
        if (!Droit::has($user["login"], 1))
        {
            // vérification du droit d'écrire les rendez-vous
            EC::set_error_code(403);
            return false;
        }

        $data = json_decode(file_get_contents("php://input"),true);
        $item = new OffreRendezVous();
        $id = $item->update($data);
        if ($id!==null)
        {
            $out = $item->getValues();
            return $out;
        }

        EC::set_error_code(501);
        return false;
    }

    public function insertCreneau()
    {
        $ac = new AC();
        $user = $ac->getloggedUserData();
        if ($user["type"]=="off")
        {
            EC::set_error_code(401);
            return false;
        }
        $data = json_decode(file_get_contents("php://input"),true);
        if (!isset($data["idOffre"]))
        {
            EC::set_error_code(501);
            return false;
        }
        $idOffre = (integer) $data["idOffre"];
        if (!Droit::has($user["login"], 1))
        {
            // vérification du droit d'écrire les rendez-vous
            // Peut-être l'utilisateur est le propriétaire
            $itemParent = OffreRendezVous::getObject($idOffre);
            if (($itemParent === null)||!$itemParent->isOwner($user["login"]))
            {
                EC::set_error_code(403);
                return false;
            }
        }
        # l'utilisateur a le droit d'ajouter le créneau
        # Dans un premier temps je ne vérifie pas la cohérence...

        $item = new CreneauRendezVous();
        $id = $item->update($data);
        if ($id!==null)
        {
            $out = $item->getValues();
            return $out;
        }

        EC::set_error_code(501);
        return false;
    }

}
?>

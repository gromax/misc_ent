<?php

namespace RouteController;
use ErrorController as EC;
use AuthController as AC;
use BDDObject\RendezVous;
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


    public function fetchList()
    {
        $ac = new AC();
        $user = $ac->getloggedUserData();
        if ($user["type"]=="off")
        {
            EC::set_error_code(401);
            return false;
        }
        return RendezVous::getList();
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
        $item=RendezVous::getObject($id);
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
        $item = new RendezVous();
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

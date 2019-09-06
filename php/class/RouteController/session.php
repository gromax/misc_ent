<?php

namespace RouteController;
use ErrorController as EC;
use AuthController as AC;
use SessionController as SC;

class session
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
        return $ac->getloggedUserData();
    }

    public function delete()
    {
        SC::get()->destroy();
        return $this->fetch();
    }

    public function cas()
    {
        if ($this->params["dev"])
        {
            $ac = new AC();
            $ac->devGetCasSession();
        }
        else
        {
            $ac = new AC();
            $ac->getCasSession();
        }
    }
}
?>

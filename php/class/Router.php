<?php

/**
 * @author Olivier ROGER <roger.olivier[ at ]gmail.com>
 * @version $Revision: 231 $
 * @license Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
 */

/**
 * Router permettant la mise en place du pattern MVC
 * Permet un routage simple ou � base de r�gle de routage.
 *
 * @version 1.2.2
 * @copyright  2007-2012 Olivier ROGER <roger.olivier[ at ]gmail.com>
 *
 * <code>
 * $router = Router::getInstance();
 * $router->setPath(ROOT_PATH.'includes/controllers/'); // Chemin vers les controlleurs
 * $router->addRule('test/regles/:id/hello',array('controller'=>'index','action'=>'withRule'));
 * </code>
 */

use ErrorController as EC;

class Router
{
    /**
     * Instance du router
     * @static
     * @var Router
     */
    static private $instance;
    /**
     * Controller � utiliser. Par defaut index
     * @var string
     */
    private $controller;

    /**
     * Router en mode dev
     * @var boolean
     */
    private $devMode;

    /**
     * Action du controller. Par d�faut index
     * @var string
     */
    private $action;

    /**
     * Tableau des param�tres
     * @var array
     */
    private $params;

    /**
     * Liste des r�gles de routage
     * @var array
     */
    private $rules;

    /**
     * Chemin vers le dossier contenant les controllers
     * @var string
     */
    private $path;

    /**
     * Fichier � inclure
     * @var string
     */
    private $file;

    /**
     * Controller par defaut (index)
     * @var string
     */
    private $defaultController;

    /**
     * Action par defaut (index)
     * @var string
     */
    private $defaultAction;

    static function getInstance($devMode = false)
    {
        if (!isset(self::$instance))
            self::$instance = new Router($devMode);
        return self::$instance;
    }

    /**
     * Charge le controller demand�.
     * Prend en compte les r�gles de routages si n�cessaire
     */
    public function load()
    {
        $url        = $_SERVER['REQUEST_URI'];
        $script     = $_SERVER['SCRIPT_NAME'];
        $method     = $_SERVER['REQUEST_METHOD'];
        //Permet de nettoyer l'url des �ventuels sous dossier
        $tabUrl     = $this->formatUrl($url, $script);

        //Supression des �ventuelles parties vides de l'url
        $this->clear_empty_value($tabUrl);

        if (!empty($this->rules))
        {
            foreach ($this->rules as $key => $data) {
                if ($method == $data['method'])
                {
                    $params = $this->matchRules($data['rule'], $tabUrl);
                    if ($params)
                    {
                        $this->controller   = $data['controller'];
                        $this->action       = $data['action'];
                        // modification du code : si $params === true,
                        // on envoie un tableau vide
                        if ($params === true)
                            $this->params   = array();
                        else
                            $this->params   = $params;
                        // ancien code
                        // $this->params       = $params;
                        // fin de la modification
                        break;
                    } else {
                    }
                }
            }
        }

        $this->controller   = (!empty($this->controller)) ? $this->controller : $this->defaultController;
        $this->action       = (!empty($this->action)) ? $this->action : $this->defaultAction;
        $class = 'RouteController\\'.$this->controller;

        if (!class_exists($class))
        {
            EC::addDebugError("Classe ".$class." introuvable.", "Routeur");
            EC::set_error_code(501);
            return false;
        }

        $params = $this->getParameters();
        $params["dev"] = $this->devMode;
        $controller = new $class($params);

        if (!is_callable(array($controller, $this->action)))
        {
            EC::addDebugError("Action ".$this->action." n'est pas ex�cutable.", "Routeur");
            EC::set_error_code(501);
            return false;
        }
        else
        {
            $action = $this->action;
        }

        return $controller->$action();
    }

    /**
     * Ajoute une r�gle de routage.
     *
     * @param string $rule R�gles de routage : /bla/:param1/blabla/:param2/blabla
     * @param array $target Cible de la r�gle : array('controller'=>'index','action'=>'test')
     */
    public function addRule($rule, $controller, $action, $method)
    {
        if ($rule[0] != '/')
            $rule = '/' . $rule; //Ajout du slashe de d�but si absent
        $this->rules[] = array( "rule"=> $rule, "controller"=> $controller, "action"=> $action, "method"=> $method);
    }

    /**
     * V�rifie si l'url correspond � une r�gle de routage
     * @link http://blog.sosedoff.com/2009/07/04/simpe-php-url-routing-controller/
     * @param string $rule
     * @param array $dataItems
     * @return boolean|array
     */
    public function matchRules($rule, $dataItems)
    {
        $ruleItems = explode('/', $rule);
        $this->clear_empty_value($ruleItems);

        if (count($ruleItems) == count($dataItems))
        {
            $result = array();
            foreach ($ruleItems as $rKey => $rValue) {
                if ($rValue[0] == ':')
                {
                    $rValue = substr($rValue, 1); //Supprime les : de la cl�
                    $result[$rValue] = $dataItems[$rKey];
                }
                else
                {
                    if ($rValue != $dataItems[$rKey])
                        return false;
                }
            }

            if (empty($result))
                return true;
            else
                return $result;
        }
        return false;
    }

    /**
     * D�fini le controller et l'action par d�faut
     * @param string $controller
     * @param string $action
     */
    public function setDefaultControllerAction($controller, $action)
    {
        $this->defaultController    = $controller;
        $this->defaultAction        = $action;
    }

    /**
     * Renvoi les param�tres disponibles
     * @return array
     */
    public function getParameters()
    {
        return $this->params;
    }

    /**
     * Supprime d'un tableau tous les �lements vide
     * @param array $array
     */
    private function clear_empty_value(&$array)
    {
        foreach ($array as $key => $value) {
            if (empty($value))
                unset($array[$key]);
        }
        $array = array_values($array); // R�organise les cl�s
    }

    /**
     * Supprime les sous dossier d'une url si n�cessaire
     * @param string $url
     * @return string
     */
    private function formatUrl($url, $script)
    {
        $i = strpos($url, "?");
        if ($i!==false)
        {
            $url = substr($url,0,$i);
        }
        $tabUrl     = explode('/', $url);
        $tabScript  = explode('/', $script);
        $size       = count($tabScript);

        for ($i = 0; $i < $size; $i++)
            if ($tabScript[$i] == $tabUrl[$i])
                unset($tabUrl[$i]);

        return array_values($tabUrl);
    }

    /**
     * Constructeur
     */
    private function __construct($devMode=false)
    {
        $this->devMode              = ($devMode===true);
        $this->rules = array();
        $this->defaultController    = 'defaultController';
        $this->defaultAction        = 'alert';
    }

}

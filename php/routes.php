<?php
require "../php/class/Router.php";

function loadRouter($devMode=false)
{
  $router = Router::getInstance($devMode);

  // chemin CAS
  $router->addRule('api/cas', 'session', 'cas', 'GET'); // Session active
  // session
  $router->addRule('api/session', 'session', 'fetch', 'GET'); // Session active
  $router->addRule('api/session/:id', 'session', 'delete', 'DELETE'); // Déconnexion



  return $router;

}

?>

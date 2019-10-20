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
  // Droits
  $router->addRule('api/droits', 'droits', 'fetchList', 'GET'); // liste des droits, pour admin
  $router->addRule('api/droits', 'droits', 'insert', 'POST'); // insertion droit, pour admin
  $router->addRule('api/droits/:id', 'droits', 'delete', 'DELETE'); // suppression droit, pour admin
  // RendezVous
  $router->addRule('api/rendezVous/offres', 'rendezVousManager', 'fetchList', 'GET'); // liste des rendezVous
  $router->addRule('api/rendezVous/offres', 'rendezVousManager', 'insert', 'POST'); // insertion droit, pour ayant droit 1
  $router->addRule('api/rendezVous/offres/:id', 'rendezVousManager', 'delete', 'DELETE'); // suppression droit, pour ayant droit 1
  $router->addRule('api/rendezVous/offres/:id', 'rendezVousManager', 'fetch', 'GET'); // chargement d'un rendezVous avec les créneaux enfants
  $router->addRule('api/rendezVous/creneaux/:id', 'rendezVousManager', 'deleteCreneau', 'DELETE'); // suppresion d'un créneau
  $router->addRule('api/rendezVous/creneaux', 'rendezVousManager', 'insertCreneau', 'POST'); // insertion d'un créneau

  return $router;

}

?>

<?php
  define("PATH_TO_MEEKRODB", "../vendor/sergeytsalkov/meekrodb/db.class.php");
  define("PATH_TO_UPLOAD", "../up/");
  define("PATH_TO_CLASS", "../php/class");

  // Chemin du dossier
  define("BDD_CONFIG","../php/config/bddConfig.php");

  if (file_exists("../php/config/customConfig.php"))
  {
    require_once("../php/config/customConfig.php");
  }
  else
  {
    require_once("../php/defConfig.php");
  }


?>

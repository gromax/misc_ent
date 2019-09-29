<?php
use SessionController as SC;

class AuthController
{
  const TIME_OUT = 5400; // durée d'inactivité avant déconnexion = 90min
  private $loggedUserData = null;
  ##################################### METHODES STATIQUES #####################################

  public function __construct()
  {
    $loggedUserData = SC::get()->getParam("loggedUserData", null);
    if ( $loggedUserData !==null )
    {
      $this->loggedUserData = $loggedUserData;
    }
    else
    {
      $this->loggedUserData = array("type" => "off");
    }
  }

  public function getloggedUserData()
  {
    return $this->loggedUserData;
  }

  public static function devGetCasSession()
  {
    $login = USER_LOGIN_DEV;
    $isAdmin = (in_array($login,explode(";",ADMIN_ACCOUNTS)));
    $loggedUserData = array(
      "login" => $login,
      "displayName" => "Utilisateur de test",
      "type" => "Élève",
      "isAdmin" => $isAdmin
    );
    SC::get()->setParam("loggedUserData", $loggedUserData);
    header('HTTP/1.0 302 Found');
    header("Location: ".PATH_TO_SITE."#home");
    exit();
  }

  public static function getCasSession()
  {
    if (isset($_GET['ticket'])) {
        $ticket = $_GET['ticket'];
        // Get CURL resource
        $curl = curl_init();
        // Set some options - we are passing in a useragent too here
        curl_setopt_array($curl, array(
            CURLOPT_RETURNTRANSFER => 1,
            CURLOPT_URL => PATH_TO_ENT_CAS_VALIDATE."?ticket=$ticket&service=".PATH_TO_AUTH,
            CURLOPT_USERAGENT => 'User Agent X'
        ));
        // Send the request & save response to $resp
        $resp = curl_exec($curl);
        // Close request to clear up some resources
        curl_close($curl);
        if (preg_match("#<cas:authenticationSuccess>#", $resp)){
          $error = false;
          $isAdmin = false;
          // capture du login cas
          $pattern ="#<cas:user>(.+)</cas:user>#";
          preg_match($pattern, $resp, $matches, PREG_OFFSET_CAPTURE);
          if(count($matches) > 0)
          {
              $login = $matches[1][0];
              $isAdmin = (in_array($login,explode(";",ADMIN_ACCOUNTS)));
          }
          else
          {
              $error = true;
          }

          // capture du nom
          $pattern ='#<displayName xmlns="">(.+)</displayName>#';
          preg_match($pattern, $resp, $matches, PREG_OFFSET_CAPTURE);
          if(count($matches) > 0)
          {
              $displayName = $matches[1][0];
          }
          else
          {
              $error = true;
          }

          // capture du type de compte
          $pattern ='#<type xmlns="">\["(.+)"\]</type>#';
          preg_match($pattern, $resp, $matches, PREG_OFFSET_CAPTURE);
          if(count($matches) > 0)
          {
              $type = $matches[1][0];
          }
          else
          {
              $error = true;
          }

          if ($error)
          {
            $loggedUserData =  array("type" => "off");
          }
          else
          {
            $loggedUserData = array("login" => $login, "displayName" => $displayName, "type" => $type, "isAdmin" => $isAdmin );
          }
          SC::get()->setParam("loggedUserData", $loggedUserData);
          header('HTTP/1.0 302 Found');
          header("Location: ".PATH_TO_SITE."#home");
          exit();
        }
        $loggedUserData =  array("type" => "off");
        SC::get()->setParam("loggedUserData", $loggedUserData);
        header('HTTP/1.0 302 Found');
        header("Location: ".PATH_TO_SITE."#erreurlogincas");
        exit();
    } else {
        header('HTTP/1.0 302 Found');
        header("Location: ".PATH_TO_ENT_CAS);
        exit();
    }
  }
}

?>

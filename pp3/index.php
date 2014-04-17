<?php
/**
 * Copyright 2011 Facebook, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may
 * not use this file except in compliance with the License. You may obtain
 * a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations
 * under the License.
 */

require 'facebook.php';

// Create our Application instance (replace this with your appId and secret).
$facebook = new Facebook(array(
  'appId'  => '715517181827004',
  'secret' => 'cdb91efe7e41d1035a3bf969d49f4791'
));

// Get User ID
$user = $facebook->getUser();

// We may or may not have this data based on whether the user is logged in.
//
// If we have a $user id here, it means we know the user is logged into
// Facebook, but we don't know if the access token is valid. An access
// token is invalid if the user logged out of Facebook.

if ($user) {
  try {
    // Proceed knowing you have a logged in user who's authenticated.
    $user_profile = $facebook->api('/me');
  } catch (FacebookApiException $e) {
    error_log($e);
    $user = null;
  }
}

// Login or logout url will be needed depending on current user state.
if ($user) {
  $logoutUrl = $facebook->getLogoutUrl();
} else {
  $statusUrl = $facebook->getLoginStatusUrl();
  
  
  $params = array(
    'scope' => 'email, user_friends, user_location',    
	'redirect_uri' => 'https://apps.facebook.com/715517181827004/?fb_source=search&ref=ts&fref=ts',
    );

    $loginUrl = $facebook->getLoginUrl($params);
}

    //TO DO:
	//Determine whether or not this is user's first time here. If so, insert list of his friends to the database, along with his 
	//own info. If not, then do nothing.		
    if ($user) //Only check this if user is logged in the game
    {
	     
		$host="localhost"; // Host name
        $db_user="root"; // Mysql username
        $pass=""; // Mysql password
        $db_name="portpilot"; // Database name 
		 
	    //$host="localhost"; // Host name
        //$db_user="dbu1101772"; // Mysql username
        //$pass="ervAvfHe81voa4iBhdRAivaoijev98ayhev"; // Mysql password
        //$db_name="db1101772-pp"; // Database name
          
        $dbh = mysqli_connect($host, $db_user, $pass, $db_name);
       	
		$playerFacebookId = $_SESSION["fb_715517181827004_user_id"];
        $sql="SELECT * FROM users WHERE facebook_id=$playerFacebookId";
		
		$result = mysqli_query($dbh, $sql);
		
        $count = mysqli_num_rows($result);
		
        $new_user=false;
		if($count==0)
        {
		    $new_user=true;
            $row = mysqli_fetch_row($result);
            $uid = $row[user_id];
        }
        
		/*
		*/
		
        if($new_user)    
	    {
		    
		    $playerFacebookId = $_SESSION["fb_715517181827004_user_id"];
		    
            $sql="INSERT INTO users(`first_name`,`last_name`, `facebook_id`, `email`, `join_date`) VALUES('".$user_profile['first_name']."','".$user_profile['last_name']."', ".$playerFacebookId.",'".$user_profile['email']."',now())";    
     
            $host="localhost"; // Host name
            $user="root"; // Mysql username
            $pass=""; // Mysql password
            $db_name="portpilot"; // Database name
		 
		    //$host="localhost"; // Host name
            //$db_user="dbu1101772"; // Mysql username
            //$pass="ervAvfHe81voa4iBhdRAivaoijev98ayhev"; // Mysql password
            //$db_name="db1101772-pp"; // Database name
           
            $dbh = mysqli_connect($host, $db_user, $pass, $db_name);
            
		    $result = mysqli_query($dbh, $sql);
		    $count = mysqli_num_rows($result);
		
            $sql="SELECT * FROM users WHERE facebook_id=$playerFacebookId";
      
            $result = mysqli_query($dbh, $sql);
            // Mysql_num_row is counting table rows
            $count = mysqli_num_rows($result);
            if($count==1)
            {
                $row = mysqli_fetch_row($result);
                $uid = $row[user_id];
            } 
			
			/*
		    */
        }			
		
    }

// This call will always work since we are fetching public data.
$naitik = $facebook->api('/naitik');




?>
<!doctype html>
<html xmlns:fb="http://www.facebook.com/2008/fbml">
  <head>
    <title>php-sdk</title>
    <style>
      body {
        font-family: 'Lucida Grande', Verdana, Arial, sans-serif;
      }
      h1 a {
        text-decoration: none;
        color: #3b5998;
      }
      h1 a:hover {
        text-decoration: underline;
      }
    </style>
	
	<script>
	window.onload=function()
    {
        // initialize the library with your Facebook API key
        FB.init({ apiKey: 'cdb91efe7e41d1035a3bf969d49f4791' });
	}                        
	</script>
  </head>
  <body>
    <h1>php-sdk</h1>

    <?php if ($user): ?>
      <!-- <a href="<?php echo $logoutUrl; ?>">Logout</a>  -->
	  <input type="button" onclick="FB.logout()" value="Logout" />
    <?php else: ?>
      <div>
        Check the login status using OAuth 2.0 handled by the PHP SDK:
        <a href="<?php echo $statusUrl; ?>">Check the login status</a>
      </div>
      <div>
        Login using OAuth 2.0 handled by the PHP SDK:
        <a target="_top" href="<? echo $loginUrl; ?>">Login with Facebook</a>	
      </div>
    <?php endif ?>

    <h3>PHP Session</h3>
    <pre><?php print_r($_SESSION); ?></pre>

    <?php if ($user): ?>
	<div id="fb-root"></div>
    <script>
      window.fbAsyncInit = function() {
        FB.init({
          appId      : '715517181827004',
          status     : true,
          xfbml      : true
        });
      };

      (function(d, s, id){
         var js, fjs = d.getElementsByTagName(s)[0];
         if (d.getElementById(id)) {return;}
         js = d.createElement(s); js.id = id;
         js.src = "//connect.facebook.net/en_US/all.js";
         fjs.parentNode.insertBefore(js, fjs);
       }(document, 'script', 'facebook-jssdk'));
    </script>
      <h3>You</h3>
      <img src="https://graph.facebook.com/<?php echo $user; ?>/picture">

      <h3>Your User Object (/me)</h3>
      <pre><?php print_r($user_profile); ?></pre>
    <?php else: ?>
      <strong><em>You are not Connected.</em></strong>
    <?php endif ?>

    <h3>Public profile of Naitik</h3>
    <img src="https://graph.facebook.com/naitik/picture">
    <?php echo $naitik['name']; ?>
	
	<br/>Friends List:<br>
    <?php
    $friends = $facebook->api('/me/friends');

    //echo '<ul>';
    //foreach ($friends["data"] as $value) {
    //    echo '<li>';
    //    echo '<div class="pic">';
    //    echo '<img src="https://graph.facebook.com/' . $value["id"] . '/picture"/>';
    //    echo 'https://graph.facebook.com/'.$value["id"].'/picture/>';
    //    echo '</div>';
    //    echo '<div>'.$value["name"].'</div>'; 
    //    echo '</li>';
    //}
    //echo '</ul>';	
	
	?>
	<object width="800" height="600" data="test3.swf"></object> 
  </body>
</html>

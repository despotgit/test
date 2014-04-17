<?php
    
    //TO DO:
    //Things to return hrough this file:	
	//0.Insert the new score into database
    //1.Find top 10 global results, and pack them for JSON. This is for global top 10 list.
    //2.Take user's facebook id, find user in the database, find all his/her friends' best results, or 
	//false if user doesn't have any active friends. Pack this for JSON response. This will be used as user's facebook
	//friends' top 10 list.
    //3.Take user's facebook_id, fetch from database all his friends who are not yet players of the game (there is no record for them
	//in the users table). Pack the results in the JSON response. This will be used as the list of user's friends so that he can invite 
	//them.
    //
    //
    //
	
    $playerFacebookId = $_SESSION["fb_715517181827004_user_id"];
    $sql="SELECT * FROM users WHERE facebook_id=$playerFacebookId";    
    
    $host="localhost"; // Host name
    $user="root"; // Mysql username
    $pass=""; // Mysql password
    $db_name="portpilot"; // Database name
        
    $this->dbh = mysqli_connect($this->host, $this->user, $this->pass, $this->db_name);
        
    $sql="SELECT * FROM users WHERE facebook_id=$playerFacebookId";
      
    $result = mysqli_query($this->dbh, $sql);
        // Mysql_num_row is counting table rows
    $count = mysqli_num_rows($result);
    if($count==1)
    {
        $row = mysqli_fetch_row($result);
        $uid = $row[user_id];
    }
    
    
    
    
    
    
    
?>
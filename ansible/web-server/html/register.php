<?php 
	session_start();
	if($_POST['submit']){
		include("config.php")
		$username = strip_tags($_POST['username']);
		$password = strip_tags($_POST['password']);
		$first_name = strip_tags($_POST['first_name']);
		$last_name = strip_tags($_POST['last_name']);
		$email = strip_tags($_POST['email']);
		$query = "INSERT INTO `user` (`password`, `first_name`, `last_name`, `email`, `username`, `group_id`) VALUES ($password, $first_name, $last_name, $email, $username, 3)";
		$result = mysqli_query($db,$query);
		if($result) {
			echo "Succesfully registered";
			header('Location: index.php');
		}
		else {
			echo "Failed to register";
		}
	}
?>

<!DOCTYPE html>
<html>
<head>
	<title>Register</title>
</head>
<body>
<h1>Register</h1>
<form method="post" action="register.php">
	<input type="text" name = "username" placeholder="Enter username">
	<input type="password" name="password" placeholder="Enter password here">
	<input type="first_name" name="first_name" placeholder="Enter first_name here">
	<input type="last_name" name="last_name" placeholder="Enter last_name here">
	<input type="email" name="email" placeholder="Enter email here">
	<input type="submit" name="submit" value="Register">
</form>
<a href = "index.php" >Login</a>

</body>
</html>
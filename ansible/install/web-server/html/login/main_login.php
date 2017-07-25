<?php
session_start();
if (isset($_SESSION['username'])) {
    header("location:../index.php");
}
?>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Bootstrap -->
    <link href="../css/bootstrap.css" rel="stylesheet" media="screen">
    <link href="../css/main.css" rel="stylesheet" media="screen">
  </head>

  <body>
    <div class="container">
      <div class="form-signin-heading">
        <h1>Target - Web Server</h1>
      </div>
      <div class="form-signin">
        <form name="form1" method="post" action="checklogin.php"> 
          <input name="myusername" id="myusername" type="text" class="form-control" placeholder="Username" autofocus>
          <input name="mypassword" id="mypassword" type="password" class="form-control" placeholder="Password">
          <!-- The checkbox remember me is not implemented yet...
          <label class="checkbox">
            <input type="checkbox" value="remember-me"> Remember me
          </label>
          -->
          <button name="Submit" id="submit" class="btn btn-lg btn-primary btn-block" type="submit">Log in</button>
          <div id="message">
          </div>
        </form>
        <center>Don't have an account? <a href="signup.php">Sign up</a></center>
      
        <h3> Existing Users </h3>
        <table class="table">
          <thead>
            <tr>
              <th>#</th>
              <th>Username</th>
              <th>Password</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <th scope="row">1</th>
              <td>root</td>
              <td>root</td>
            </tr>
            <tr>
              <th scope="row">2</th>
              <td>target@fazio.com</td>
              <td>target</td>
            </tr>
            <tr>
              <th scope="row">3</th>
              <td>contractor@fazio.com</td>
              <td>password</td>
            </tr>            <tr>
              <th scope="row">4</th>
              <td>vendor-1@fazio.com</td>
              <td>vendor-1</td>
            </tr>
            <tr>
              <th scope="row">5</th>
              <td>vendor-2@fazio.com</td>
              <td>vendor-2</td>
            </tr>
            <tr>
              <th scope="row">6</th>
              <td>vendor-3@fazio.com</td>
              <td>vendor-3</td>
            </tr>
          </tbody>
        </table>      
      </div>

        


    </div> <!-- /container -->

    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="js/jquery-2.2.4.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script type="text/javascript" src="js/bootstrap.js"></script>
    <!-- The AJAX login script -->
    <script src="js/login.js"></script>

  </body>
</html>

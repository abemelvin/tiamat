<?php require "login/loginheader.php"; ?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Index</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="css/style.css"/>
    <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
    <script src="js/bootstrap.min.js"></script>


</head>
<body>
    <div class="middle-frame">
        <div class="big-heading">
            <h1>Target - Web Server</h1>
        </div>
        <div class="small-heading">
            <h2>Order Database</h2>
        </div>
        <div class="file-upload">
            <form action="upload.php" method="post" enctype="multipart/form-data">
                <h3>Upload invoice</h3>
                <label class="btn btn-default btn-file">
                     <input type="file" name="invoice" id="invoice">
                </label>
                <button type="submit" class="btn btn-primary" name="submit">upload</button>
                <!-- <input class="bnt-default" type="submit" value="Upload" name="submit"> -->
            </form>
        </div>

        <div class="search-area">
            <form action="index.php" method="GET">
                <h3>Search user by username:</h3>
                <input id="search-input" type="text" name="query_user" />
                <button type="submit" class="btn btn-primary" >search</button>
            </form>
        </div>

        <div class="search-area">
            <form action="index.php" method="GET">
                <h3>Search order by content:</h3>
                <input id="search-input" type="text" name="query_order" />
                <button type="submit" class="btn btn-primary" >search</button>
            </form>
        </div>

    </div>

<?php
    if (!empty($_GET)){

        include("config.php");

        if (!empty($_GET['query_order'])){
            
            $query_order = $_GET['query_order'];

            if ($_SESSION['username'] == "root"){
                $sql = "SELECT username, datetime, content FROM targetOrder t WHERE content LIKE '%".$query_order."%' GROUP BY username ORDER BY datetime DESC";
            }
            else{
                $sql = "SELECT username, datetime, content FROM targetOrder t WHERE username = '".$_SESSION['username']."' AND content LIKE '%".$query_order."%' ORDER BY datetime DESC";
            }

            $result = $db->query($sql);
            $order_id = 1;

            print "<div class='order-table'>";
            print "<table class='table'>\n";
            print "<thead class='thead-inverse'>";
            print "\t<tr>\n";
            print "\t\t<th>Order_ID</th>\n";
            print "\t\t<th>Timestamp</th>\n";
            print "\t\t<th>Content</th>\n";
            print "\t\t<th>Owner</th>\n";
            print "\t</tr>\n";
            print "</thead>";
            while($row = $result->fetch_assoc()) {
                print "\t<tr>\n";
                $datetime = $row['datetime'];
                $content = $row['content'];
                $username = $row['username'];

                print "\t\t<th scope='row'>$order_id</th>\n";
                print "\t\t<td>$datetime</td>\n";
                print "\t\t<td>$content</td>\n";
                print "\t\t<td>$username</td>\n";
                print "\t</tr>\n";
                $order_id += 1;
            }
            print "<table>\n";
            print "</div>";
        }

        else if (!empty($_GET['query_user'])){
            $query_user = $_GET['query_user'];
            
            if ($_SESSION['username'] == "root"){
                $sql = "SELECT username, password, email, verified, mod_timestamp FROM members WHERE username LIKE '%".$query_user."%'";   
                $result = $db->query($sql);

                print "<div class='order-table'>";
                print "<table class='table'>\n";
                print "<thead class='thead-inverse'>";
                print "\t<tr>\n";
                print "\t\t<th>Username</th>\n";
                print "\t\t<th>Password</th>\n";
                print "\t\t<th>Email</th>\n";
                print "\t\t<th>Verified</th>\n";
                print "\t\t<th>Mod_timestamp</th>\n";
                print "\t</tr>\n";
                print "</thead>";
                while($row = $result->fetch_assoc()) {
                    print "\t<tr>\n";
                    $username = $row['username'];
                    $password = $row['password'];
                    $email = $row['email'];
                    $verified = $row['verified'];
                    $mod_timestamp = $row['mod_timestamp'];

                    print "\t\t<th scope='row'>$username</th>\n";
                    print "\t\t<td>$password</td>\n";
                    print "\t\t<td>$email</td>\n";
                    print "\t\t<td>$verified</td>\n";
                    print "\t\t<td>$mod_timestamp</td>\n";
                    print "\t</tr>\n";
                }
                print "<table>\n";
                print "</div>";

            }
            else {
                $sql = "SELECT username, email FROM members WHERE username != 'root' and username LIKE '%".$query_user."%'";  
                $result = $db->query($sql);

                print "<div class='order-table'>";
                print "<table class='table'>\n";
                print "<thead class='thead-inverse'>";
                print "\t<tr>\n";
                print "\t\t<th>Username</th>\n";
                print "\t\t<th>Email</th>\n";
                print "\t</tr>\n";
                print "</thead>";
                while($row = $result->fetch_assoc()) {
                    print "\t<tr>\n";
                    $username = $row['username'];
                    $email = $row['email'];

                    print "\t\t<th scope='row'>$username</th>\n";
                    print "\t\t<td>$email</td>\n";
                    print "\t</tr>\n";
                }
                print "<table>\n";
                print "</div>";

            }

        }

        mysqli_free_result($result);
        $db->close();
    }
    
?>

</body>
</html>



<?php

   // include('session.php');
?>

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
                <h3>Upload invoice:</h3>
                <label class="btn btn-default btn-file">
                     <input type="file" name="image" id="image">
                </label>
                <button type="submit" class="btn btn-primary" name="submit">upload</button>
                <!-- <input class="bnt-default" type="submit" value="Upload" name="submit"> -->
            </form>
        </div>

        <div class="search-area">
            <form action="index.php" method="GET">
                <h3>Search order by content:</h3>
                <input id="search-input" type="text" name="query" />
                <button type="submit" class="btn btn-primary" >search</button>
            </form>
        </div>

    </div>

<?php
    if (!empty($_GET)){
        include("config.php");
        $query = $_GET['query'];
        
        // Check connection
        if ($db->connect_error) {
            die("Connection failed: " . $db->connect_error);
        } 
        $sql = "SELECT t.id AS id, t.datetime AS datetime, t.content AS content, u.username AS username FROM target_order t, user u WHERE t.owner_id = u.id AND u.group_id = 3 AND t.content LIKE '%".$query."%'";
        // $sql = "SELECT t.id AS id, t.datetime AS datetime, t.content AS content, u.username AS username FROM target_order t, user u WHERE t.owner_id = u.id AND u.username = 'stcurry' AND t.content LIKE '%".$query."%'";
        $result = $db->query($sql);

        // if ($result->num_rows > 0) {
            // output data of each row
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
                $id = $row['id'];
                $datetime = $row['datetime'];
                $content = $row['content'];
                $username = $row['username'];

                print "\t\t<th scope='row'>$id</th>\n";
                print "\t\t<td>$datetime</td>\n";
                print "\t\t<td>$content</td>\n";
                print "\t\t<td>$username</td>\n";
                // foreach ($row as $col_value) {
                //     print "\t\t<td>$col_value</td>\n";
                // }
                print "\t</tr>\n";
            }
            print "<table>\n";
            print "</div>";
        // } else {
        //     echo "0 results";
        // }

        mysqli_free_result($result);

        $db->close();
    }
    
?>

</body>
</html>



<?php
   include("config.php");
   // include('session.php');
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Search results</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="css/style.css"/>
</head>
<body>
    <div class="big-heading">
        <h1>Target - Web Server</h1>
    </div>
    
<?php
    $query = $_GET['query'];
    
    // Check connection
    if ($db->connect_error) {
        die("Connection failed: " . $db->connect_error);
    } 
    $sql = "SELECT t.id AS id, t.datetime AS datetime, t.content AS content, u.username AS username FROM target_order t, user u WHERE t.owner_id = u.id AND u.group_id = 3 AND t.content LIKE '%".$query."%'";
    $result = $db->query($sql);

    // if ($result->num_rows > 0) {
        // output data of each row
        print "<table>\n";
        print "\t<tr>\n";
        print "\t\t<td>Order_ID</td>\n";
        print "\t\t<td>Timestamp</td>\n";
        print "\t\t<td>Content</td>\n";
        print "\t\t<td>Owner</td>\n";
        print "\t</tr>\n";
        while($row = $result->fetch_assoc()) {
            print "\t<tr>\n";
            $id = $row['id'];
            $datetime = $row['datetime'];
            $content = $row['content'];
            $username = $row['username'];

            print "\t\t<td>$id</td>\n";
            print "\t\t<td>$datetime</td>\n";
            print "\t\t<td>$content</td>\n";
            print "\t\t<td>$username</td>\n";
            // foreach ($row as $col_value) {
            //     print "\t\t<td>$col_value</td>\n";
            // }
            print "\t</tr>\n";
        }
        print "<table>\n";
    // } else {
    //     echo "0 results";
    // }

    mysqli_free_result($result);

    $db->close();
?>

</body>
</html>


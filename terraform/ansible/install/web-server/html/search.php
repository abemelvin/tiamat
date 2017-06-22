<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Search results</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="style.css"/>
</head>
<body>
    <div class="big-heading">
        <h2>Target - Web Server</h2>
    </div>
    
<?php
    $input = $_GET['query'];
    echo "Get parameter";
    /* Connect to database */
    $link = mysql_connect("localhost", "phpmyadmin", "root")
        or die("Could not connect : " . mysql_error());

    mysql_select_db("target_exemplar", $link) or die("Could not select database");

    /* Perform SQL query */

    $query = "SELECT * FROM target_order
            WHERE (`content` LIKE '%".$input."%')";
    $result = mysql_query($query) 
            or die("Query failed : " . mysql_error());

    /* Print results in HTML */
    print "<table>\n";
    while ($line = mysql_fetch_array($result, MYSQL_ASSOC)) {
        print "\t<tr>\n";
        foreach ($line as $col_value) {
            print "\t\t<td>$col_value</td>\n";
        }
        print "\t</tr>\n";
    }
    print "</table>\n";
    mysql_free_result($result);

    /* Close connection */
    mysql_close($link);
?>

</body>
</html>


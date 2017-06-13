<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Search</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="style.css"/>
</head>
<body>
    <div class="big-heading">
        <h2>Target - Web Server</h2>
    </div>
    <div class="search-area">
        <form action="search.php" method="GET">
            <label>Enter Order Info:</label>
            <input type="text" name="query" />
            <input type="submit" value="Search" />
        </form>
    </div>

    <div class="file-upload">
        <form action="upload.php" method="post" enctype="multipart/form-data">
            <label>Select picture to upload:</label>
            <input type="file" name="image" id="image">
            <input type="submit" value="Upload Image" name="submit">
        </form>
    </div>
</body>
</html>



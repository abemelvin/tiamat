<?php
// include('session.php');
$target_dir = "images/";
$target_file = $target_dir . basename($_FILES["image"]["name"]);
$uploadOk = 1;
$imageFileType = pathinfo($target_file,PATHINFO_EXTENSION);
// Check if image file is a actual image or fake image
// if(isset($_POST["submit"])) {
//     $check = getimagesize($_FILES["image"]["tmp_name"]);
//     if($check !== false) {
//         echo "File is an image - " . $check["mime"] . ".";
//         $uploadOk = 1;
//     } else {
//         echo "File is not an image.";
//         $uploadOk = 0;
//     }
// }
// Check if file already exists
if (file_exists($target_file)) {
    print "Sorry, file already exists.";
    $uploadOk = 0;
}
// Check file size
if ($_FILES["image"]["size"] > 5000000) {
    print "Sorry, your file is too large.";
    $uploadOk = 0;
}
// // Allow certain file formats
// if($imageFileType != "jpg" && $imageFileType != "png" && $imageFileType != "jpeg"
// && $imageFileType != "gif" ) {
//     print "Sorry, only JPG, JPEG, PNG & GIF files are allowed.";
//     $uploadOk = 0;
// }
// Check if $uploadOk is set to 0 by an error
if ($uploadOk == 0) {
    print "Sorry, your file was not uploaded.";
// if everything is ok, try to upload file
} else {
    if (move_uploaded_file($_FILES["image"]["tmp_name"], $target_file)) {
        print "The file ". basename( $_FILES["image"]["name"]). " has been uploaded.";
    } else {
        print "Sorry, there was an error uploading your file.";
    }
}
// print "You will be redirected to main page in 3 seconds";
print "\nPlease go back to the main page.";

?>
<?php
// sleep(5);
// header("location:index.php");
?>

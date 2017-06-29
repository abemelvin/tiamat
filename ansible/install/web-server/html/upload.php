<?php require "login/loginheader.php"; ?>

<?php
$target_dir = "images/";
$target_file = $target_dir . basename($_FILES["invoice"]["name"]);
$uploadOk = 1;
$imageFileType = pathinfo($target_file,PATHINFO_EXTENSION);

$message = "Uploaded successfully!";
// Check if invoice file is a actual invoice or fake invoice
// if(isset($_POST["submit"])) {
//     $check = getimagesize($_FILES["invoice"]["tmp_name"]);
//     if($check !== false) {
//         echo "File is an invoice - " . $check["mime"] . ".";
//         $uploadOk = 1;
//     } else {
//         echo "File is not an invoice.";
//         $uploadOk = 0;
//     }
// }
// Check if file already exists
if (file_exists($target_file)) {
    $message = "Sorry, file already exists.";
    $uploadOk = 0;
}
// Check file size
if ($_FILES["invoice"]["size"] > 5000000) {
    $message = "Sorry, your file is too large.";
    $uploadOk = 0;
}
// // Allow certain file formats
// if($imageFileType != "jpg" && $imageFileType != "png" && $imageFileType != "jpeg"
// && $imageFileType != "gif" ) {
//     $message = "Sorry, only JPG, JPEG, PNG & GIF files are allowed.";
//     $uploadOk = 0;
// }
// Check if $uploadOk is set to 0 by an error
if ($uploadOk == 0) {
    // $message = "Sorry, your file was not uploaded.";
// if everything is ok, try to upload file
} else {
    if (move_uploaded_file($_FILES["invoice"]["tmp_name"], $target_file)) {
        $message = "The file ". basename( $_FILES["invoice"]["name"]). " has been uploaded.";
    } else {
        $message = "Sorry, there was an error uploading your file.";
    }
}
// $message = "You will be redirected to main page in 3 seconds";

$_SESSION['message'] = $message;
header('Location: index.php?message='.$message);

?>

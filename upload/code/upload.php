<?php
/*!
  FileDrop Revamped - server-side upload handler for subscription plugin
  in public domain  | http://filedropjs.org

*/
//définition des constantes
$chemin="../files";//relatif à ce fichier upload.php

// If an error causes output to be generated before headers are sent - catch it.
ob_start();

// Callback name is passed if upload happens via iframe, not AJAX (FileAPI).
$callback = &$_REQUEST['fd-callback'];

// Upload data can be POST'ed as raw form data or uploaded via <iframe> and <form>
// using regular multipart/form-data enctype (which is handled by PHP $_FILES).
if (!empty($_FILES['fd-file']) and is_uploaded_file($_FILES['fd-file']['tmp_name'])) {
  // Regular multipart/form-data upload.
  $name = $_FILES['fd-file']['name'];
  $data = file_get_contents($_FILES['fd-file']['tmp_name']);
} else {
  // Raw POST data.
  $name = urldecode(@$_SERVER['HTTP_X_FILE_NAME']);
  $data = file_get_contents("php://input");
}

//écriture du fichier
$fp = fopen($chemin.'/'.$name, 'w');
fwrite($fp, $data); //User will see Hello World!
fclose($fp);


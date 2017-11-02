<?php
/*!
  FileDrop Revamped - server-side upload handler for subscription plugin
  in public domain  | http://filedropjs.org

 * Upload process for galette Subscription plugin
 *
 * PHP version 5
 *
 * Copyright © 2009-2016 The Galette Team
 *
 * This file is part of Galette (http://galette.tuxfamily.org).
 *
 * Galette is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Galette is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Galette. If not, see <http://www.gnu.org/licenses/>.
 */
 
//define path of uploaded files
$chemin="../files";//path is relative to this file upload.php

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

//writing the file
$fp = fopen($chemin.'/'.$name, 'w');
fwrite($fp, $data); //User will see Hello World!
fclose($fp);


<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * Copy past from get_export.php of galette. Get an exported file
 *
 * PHP version 5
 *
 * Copyright © 2011-2014 The Galette Team
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
define('GALETTE_BASE_PATH', '../../');
use Analog\Analog;

/** @ignore */
require_once GALETTE_BASE_PATH .'includes/galette.inc.php';

if ( !isset($_GET['file']) ) {
    Analog::log(
        'No requested file',
        Analog::INFO
    );
    header("HTTP/1.1 500 Internal Server Error");
    die();
}

$filename = $_GET['file'];

use Galette\IO\CsvOut;

//Exports main contain user confidential data, they're accessible only for
//admins or staff members
//Modification d'Amaury pour l'evol#52 export des fichiers pour les responsables de groupe en plus du staff et de l'admin.
//mon plugin subscription/export_subs.php fabrique un fichier filtré sur ce que doit voir le responsable de section.
//export_subs.tpl fournit le lien de ce fichier vers get_export.php. Ainsi le responsable de section n'a pas accès à toute la base ni au menu d'export natif de Galette
if ( $login->isAdmin() || $login->isStaff()|| $login->isGroupManager() ) {

    if (file_exists(CsvOut::DEFAULT_DIRECTORY . $filename) ) {
        header('Content-Type: text/csv');
        header('Content-Disposition: attachment; filename="' . $filename . '";');
        header('Pragma: no-cache');
        readfile(CsvOut::DEFAULT_DIRECTORY . $filename);
    } else {
        Analog::log(
            'A request has been made to get an exported file named `' .
            $filename .'` that does not exists.',
            Analog::WARNING
        );
        header('HTTP/1.0 404 Not Found');
    }
} else {
    Analog::log(
        'A non authorized person asked to retrieve exported file named `' .
        $filename . '`. Access has not been granted.',
        Analog::WARNING
    );
    header('HTTP/1.0 403 Forbidden');
}

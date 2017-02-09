/**
 * form.js for galette Subscription plugin
 * This function calculate the total price of the subscription in live
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
 *
 * @category  Plugins
 * @package   GaletteSubscription
 *
 * @author    Amaury FROMENT <amaury.froment@gmail.com>
 * @copyright 2009-2016 The Galette Team
 * @license   http://www.gnu.org/licenses/gpl-3.0.html GPL License 3.0 or (at your option) any later version
 * @version   0.7.8
 * @link      http://galette.tuxfamily.org
 * @since     Available since 0.7.8
 */
 
 function reponse(form1) 
{ 
var result = 0 ;
var total=0;

function virgule(texte) {
   while(texte.indexOf(',')>-1){
    texte=texte.replace(",",".");
	}
 
     return texte
}

for (var i=0; i<form1.length;i++)
	{
		if (form1[i].checked)
		{
		result = result+virgule(form1[i].value)*1 ;
		}
	}
document.form1.total.value=result;
} 
{if $deleteok eq 1}
   <div id="successbox">{_T string="File deleted"}</div> 
{/if}
{if $deleteok eq 0}
   <div id="errorbox">{_T string="Your file hasn't been found"}</div> 
{/if}

	 
	<form action="send_files_standalone.php?id_act={$file->id_act}{if $file->vierge eq 1}&vierge=1{/if}{if $file->vierge eq 0}&vierge=0{/if}&timestamp={$timestamp}{if $file->id_abn != NULL}&id_abn={$file->id_abn}{/if}{if $file->id_adh != NULL}&id_adh={$file->id_adh}{/if}" method="post" enctype="multipart/form-data" id="form">
			
	<div class="bigtable wrmenu">
		<table class="details">
			<caption class="ui-state-active ui-corner-top">{_T string="Add file by fill up this panel for the group:"} {$activity->group_name}</caption>
			
			<tr>
				<th>{_T string="1. Send your file"}</th>
				<td>
				    <div id="container">
						<noscript style="color: maroon">
						  <h2>{_T string="Activate javascript in your browser to upload a file"}</h2>
						</noscript>

						<!-- A FileDrop area. Can contain any text or elements, or be empty.
							 Can be of any HTML tag too, not necessary fieldset. -->
						<fieldset id="zone" onclick="getfile();">
						  <legend>{_T string="Drag and drop a file"}</legend>
						  <p id="consigne">{_T string="or click here"} <em>{_T string="Browse"}</em>...</p>

						  <!-- Putting another element on top of file input so it overlays it
							   and user can interact with it freely. -->
							<p id="txtprogress"></p>
							<p>
								<span id="bar_zone"></span>
							</p>
						</fieldset>
						<!-- visible après le téléchargement -->
						<p id="lien" style="display:none">lien du fichier</p>
					</div>
				</td>
			
			
			</tr>
			<tr>
				<th>{_T string="2. Add a description"}</th>
				<td>
					<TEXTAREA NAME="description" ROWS=2 COLS=50></TEXTAREA>
				</td>
			</tr>
		{if $file->vierge eq 1}
			<tr>
				<th>{_T string="3. Form to fill up?"}</th>
				<td>
					<select name="return_file">
						<option name="0"  value="0">{_T string="no"}
						<option name="1" value="1">{_T string="yes"}
					</select>
					
				</td>
			</tr>
		{/if}	
		</table>
	</div>
				
			<div class="button-container">
				<a id="prev" class="button" href="" onclick="javascript:window.close()">{_T string="Previous"}</a>
				<input type="submit" name="valid" id="btnsave" value="{_T string="Save"}"/>
				<input type="hidden" id="doc_name" name="doc_name" value=""/>
				<input type="hidden" id="emplacement" name="emplacement" value=""/>
			</div>
	</form> 
	
	</BR>
	
{if $files_vierges> 0}
<b><u>{_T string="Files of group:"} {$activity->group_name}</b></u>
	<div class="bigtable wrmenu" >
        <table class="listing adherents" >
            <thead>
               <tr>
                    <th class="left date_row">
						{_T string="Link"}
                    </th>
                    <th class="left date_row">
						{_T string="Description"}
                    </th>
                    
					<th class="left date_row">
                        {_T string="Form to fill up?"}
                    </th>
                {if $file->vierge eq 1}
                    <th class="left">
                        {_T string="Delete"}
                    </th>
				{/if}
                </tr>
            </thead>
			
				
	{foreach from=$files_vierges key=k item=file2}
										
				<tr>
					<td>
						<a href="{$galette_base_path}{$subscription_dir}upload/files/{$file2->emplacement|escape}" title="{$file2->description|escape}" target="blank">{$file2->doc_name|escape} </a>
					</td>
					<td>
						{$file2->description|escape}
					</td>
					<td>
						{if $file2->return_file == 0}
						{_T string="No"}
						{/if}
						{if $file2->return_file == 1}
							<b>{_T string="Yes"}</b>
						{/if}
					</td>
				{if $file->vierge eq 1}
					<td>
						<a id="histreset" class="button" href="{$galette_base_path}{$subscription_dir}send_files_standalone.php?id_act={$file2->id_act}{if $file2->vierge eq 1}&vierge=1{/if}{if $file2->vierge eq 0}&vierge=0{/if}&delete=1&id_doc={$file2->id_doc}{if $file->id_abn != NULL}&id_abn={$file->id_abn}{/if}{if $file->id_adh != NULL}&id_adh={$file->id_adh}{/if}">{_T string="Delete"}</a>
					</td>
				{/if}
				</tr>
	{/foreach}			
				
        </table>
</div>
{/if}

</BR>
	
{if $personnal_files> 0 && $vierge == 0}
<b><u>{_T string="Personnal files of group:"} {$activity->group_name}</u></b>
	<div class="bigtable wrmenu" >
        <table class="listing adherents" >
            <thead>
               <tr>
                    <th class="left date_row">
						{_T string="Link"}
                    </th>
                    <th class="left date_row">
						{_T string="Description"}
                    </th>
                                        
                    <th class="left">
                        {_T string="Date"}
                    </th>
					 <th class="left">
                        {_T string="Subscription"}
                    </th>
					<th class="left">
                        {_T string="Delete"}
                    </th>
                </tr>
            </thead>
			
				
	{foreach from=$personnal_files key=k item=file}
										
				<tr>
					<td>
						<a href="{$galette_base_path}{$subscription_dir}upload/files/{$file->emplacement|escape}" title="{$file->description|escape}" target="blank">{$file->doc_name|escape} </a>
					</td>
					<td>
						{$file->description|escape}
					</td>
					<td>
						{$file->date_record|escape}
					</td>
					<td>
						{$file->id_abn}
					</td>
					
					<td>
						<a id="histreset" class="button" href="{$galette_base_path}{$subscription_dir}send_files_standalone.php?id_act={$file->id_act}{if $file->vierge eq 1}&vierge=1{/if}{if $file->vierge eq 0}&vierge=0{/if}&delete=1&id_doc={$file->id_doc}{if $file->id_abn != NULL}&id_abn={$file->id_abn}{/if}{if $file->id_adh != NULL}&id_adh={$file->id_adh}{/if}">{_T string="Delete"}</a>
					</td>
				</tr>
	{/foreach}			
				
        </table>
</div>
{/if}	
<script type="text/javascript">
	function getfile(){
		document.getElementsByClassName('fd-file')[0].click();
		}
	function cancel()
		{
		fd.byID('zone').style.display="block";
		fd.byID('lien').style.display="none";
		fd.byID('consigne').innerHTML="ou cliquez ici <em>Parcourir</em>...";
		}
	//For IE because includes() not supported natively
	function includes(container, value) 
		{
		var returnValue = false;
		var pos = container.indexOf(value);
		if (pos >= 0) 
			{
			returnValue = true;
			}
		return returnValue;
		}
	//Variables globales
      // Tell FileDrop we can deal with iframe uploads using this URL:
	  {*//chemin erronné {$galette_base_path}{$subscription_dir}upload/code/ impossible à cause de {literal}. Sinon smarty n'arrive pas à lire cette ligne *}
      {literal}var options = {iframe: {url: 'upload.php'}};{/literal}
      // Attach FileDrop to an area ('zone' is an ID but you can also give a DOM node):
      var zone = new FileDrop('zone', options);
	  var filesize_max=2;//Mo
	  var old_filename;
	  var authorized_extensions=["application/gzip",
								"application/x-zip-compressed",
								"application/x-7z-compressed",
								"application/x-rar-compressed",
								"application/x-tar",
								"application/x-bzip",
								"application/x-bzip2",
								"application/msword",
								"application/pdf",
								"application/vnd.cups-pdf",
								"application/vnd.kde.kword",
								"application/vnd.lotus-wordpro",
								"application/vnd.ms-excel",
								"application/vnd.ms-excel.addin.macroEnabled.12",
								"application/vnd.ms-excel.sheet.binary.macroEnabled.12",
								"application/vnd.ms-excel.sheet.macroEnabled.12",
								"application/vnd.ms-excel.template.macroEnabled.12",
								"application/vnd.ms-officetheme",
								"application/vnd.ms-powerpoint",
								"application/vnd.ms-powerpoint.addin.macroEnabled.12",
								"application/vnd.ms-powerpoint.presentation.macroEnabled.12",
								"application/vnd.ms-powerpoint.slide.macroEnabled.12",
								"application/vnd.ms-powerpoint.slideshow.macroEnabled.12",
								"application/vnd.ms-powerpoint.template.macroEnabled.12",
								"application/vnd.ms-word.document.macroEnabled.12",
								"application/vnd.ms-word.template.macroEnabled.12",
								"application/vnd.oasis.opendocument.chart",
								"application/vnd.oasis.opendocument.chart-template",
								"application/vnd.oasis.opendocument.database",
								"application/vnd.oasis.opendocument.formula",
								"application/vnd.oasis.opendocument.formula-template",
								"application/vnd.oasis.opendocument.graphics",
								"application/vnd.oasis.opendocument.graphics-template",
								"application/vnd.oasis.opendocument.image",
								"application/vnd.oasis.opendocument.image-template",
								"application/vnd.oasis.opendocument.presentation",
								"application/vnd.oasis.opendocument.presentation-template",
								"application/vnd.oasis.opendocument.spreadsheet",
								"application/vnd.oasis.opendocument.spreadsheet-template",
								"application/vnd.oasis.opendocument.text",
								"application/vnd.oasis.opendocument.text-master",
								"application/vnd.oasis.opendocument.text-template",
								"application/vnd.oasis.opendocument.text-web",
								"application/vnd.openxmlformats-officedocument.custom-properties+xml",
								"application/vnd.openxmlformats-officedocument.customXmlProperties+xml",
								"application/vnd.openxmlformats-officedocument.drawing+xml",
								"application/vnd.openxmlformats-officedocument.drawingml.chart+xml",
								"application/vnd.openxmlformats-officedocument.drawingml.chartshapes+xml",
								"application/vnd.openxmlformats-officedocument.drawingml.diagramColors+xml",
								"application/vnd.openxmlformats-officedocument.drawingml.diagramData+xml",
								"application/vnd.openxmlformats-officedocument.drawingml.diagramLayout+xml",
								"application/vnd.openxmlformats-officedocument.drawingml.diagramStyle+xml",
								"application/vnd.openxmlformats-officedocument.extended-properties+xml",
								"application/vnd.openxmlformats-officedocument.presentationml.commentAuthors+xml",
								"application/vnd.openxmlformats-officedocument.presentationml.comments+xml",
								"application/vnd.openxmlformats-officedocument.presentationml.handoutMaster+xml",
								"application/vnd.openxmlformats-officedocument.presentationml.notesMaster+xml",
								"application/vnd.openxmlformats-officedocument.presentationml.notesSlide+xml",
								"application/vnd.openxmlformats-officedocument.presentationml.presentation",
								"application/vnd.openxmlformats-officedocument.presentationml.presentation.main+xml",
								"application/vnd.openxmlformats-officedocument.presentationml.presProps+xml",
								"application/vnd.openxmlformats-officedocument.presentationml.slide",
								"application/vnd.openxmlformats-officedocument.presentationml.slide+xml",
								"application/vnd.openxmlformats-officedocument.presentationml.slideLayout+xml",
								"application/vnd.openxmlformats-officedocument.presentationml.slideMaster+xml",
								"application/vnd.openxmlformats-officedocument.presentationml.slideshow",
								"application/vnd.openxmlformats-officedocument.presentationml.slideshow.main+xml",
								"application/vnd.openxmlformats-officedocument.presentationml.slideUpdateInfo+xml",
								"application/vnd.openxmlformats-officedocument.presentationml.tableStyles+xml",
								"application/vnd.openxmlformats-officedocument.presentationml.tags+xml",
								"application/vnd.openxmlformats-officedocument.presentationml-template",
								"application/vnd.openxmlformats-officedocument.presentationml.template.main+xml",
								"application/vnd.openxmlformats-officedocument.presentationml.viewProps+xml",
								"application/vnd.openxmlformats-officedocument.spreadsheetml.calcChain+xml",
								"application/vnd.openxmlformats-officedocument.spreadsheetml.chartsheet+xml",
								"application/vnd.openxmlformats-officedocument.spreadsheetml.comments+xml",
								"application/vnd.openxmlformats-officedocument.spreadsheetml.connections+xml",
								"application/vnd.openxmlformats-officedocument.spreadsheetml.dialogsheet+xml",
								"application/vnd.openxmlformats-officedocument.spreadsheetml.externalLink+xml",
								"application/vnd.openxmlformats-officedocument.spreadsheetml.pivotCacheDefinition+xml",
								"application/vnd.openxmlformats-officedocument.spreadsheetml.pivotCacheRecords+xml",
								"application/vnd.openxmlformats-officedocument.spreadsheetml.pivotTable+xml",
								"application/vnd.openxmlformats-officedocument.spreadsheetml.queryTable+xml",
								"application/vnd.openxmlformats-officedocument.spreadsheetml.revisionHeaders+xml",
								"application/vnd.openxmlformats-officedocument.spreadsheetml.revisionLog+xml",
								"application/vnd.openxmlformats-officedocument.spreadsheetml.sharedStrings+xml",
								"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
								"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml",
								"application/vnd.openxmlformats-officedocument.spreadsheetml.sheetMetadata+xml",
								"application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml",
								"application/vnd.openxmlformats-officedocument.spreadsheetml.table+xml",
								"application/vnd.openxmlformats-officedocument.spreadsheetml.tableSingleCells+xml",
								"application/vnd.openxmlformats-officedocument.spreadsheetml-template",
								"application/vnd.openxmlformats-officedocument.spreadsheetml.template.main+xml",
								"application/vnd.openxmlformats-officedocument.spreadsheetml.userNames+xml",
								"application/vnd.openxmlformats-officedocument.spreadsheetml.volatileDependencies+xml",
								"application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml",
								"application/vnd.openxmlformats-officedocument.theme+xml",
								"application/vnd.openxmlformats-officedocument.themeOverride+xml",
								"application/vnd.openxmlformats-officedocument.vmlDrawing",
								"application/vnd.openxmlformats-officedocument.wordprocessingml.comments+xml",
								"application/vnd.openxmlformats-officedocument.wordprocessingml.document",
								"application/vnd.openxmlformats-officedocument.wordprocessingml.document.glossary+xml",
								"application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml",
								"application/vnd.openxmlformats-officedocument.wordprocessingml.endnotes+xml",
								"application/vnd.openxmlformats-officedocument.wordprocessingml.fontTable+xml",
								"application/vnd.openxmlformats-officedocument.wordprocessingml.footer+xml",
								"application/vnd.openxmlformats-officedocument.wordprocessingml.footnotes+xml",
								"application/vnd.openxmlformats-officedocument.wordprocessingml.numbering+xml",
								"application/vnd.openxmlformats-officedocument.wordprocessingml.settings+xml",
								"application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml",
								"application/vnd.openxmlformats-officedocument.wordprocessingml-template",
								"application/vnd.openxmlformats-officedocument.wordprocessingml.template.main+xml",
								"application/vnd.openxmlformats-officedocument.wordprocessingml.webSettings+xml",
								"application/vnd.rar",
								"application/vnd.software602.filler.form-xml-zip",
								"application/zip",
								"image/bmp",
								"image/gif",
								"image/jpeg",
								"image/png",
								"image/tiff",
								"image/tiff-fx",
								"image/vnd.adobe.photoshop",
								"text/css",
								"text/csv",
								"text/csv-schema",
								"text/enriched",
								"text/markdown",
								"text/plain",
								"text/richtext",
								"text/rtf",
								"text/rtx",
								"text/vnd.latex-z",
								"text/xml"];
      // Do something when a user chooses or drops a file:
      zone.event('send', function (files) {
		// Depending on browser support files (FileList) might contain multiple items.
		files.each(function (file) {
			//controle de l'extension
			if(includes(authorized_extensions,file.type)==true)
				{
				//controle de la taille
				var filesize=file.size/Math.pow(10,6);//en Mo
				if(filesize<filesize_max)
					{
					old_filename=file.name;	
					// Reset the progress when a new upload starts:
					file.event('sendXHR', function () {
						fd.byID('bar_zone').style.width = "0%"
						})
					file.event('progress', function (sent, total) {
						fd.byID('consigne').innerHTML="";	
						fd.byID('txtprogress').textContent = '{_T string="Progress"} ' + Math.round(sent / total * 100) + '%';
						var width = sent / total * 100 + '%';
						fd.byID('bar_zone').style.width = width;
						})
					// React on successful AJAX upload:
					file.event('done', function (xhr) {
						// 'this' here points to fd.File instance that has triggered the event.
						//alert('Done uploading ' + this.name + ', response:\n\n' + xhr.responseText);
						fd.byID('zone').style.display="none";
						fd.byID('bar_zone').style.width = "0%";
						fd.byID('txtprogress').textContent ="";
						fd.byID('lien').style.display="block";
						fd.byID('lien').innerHTML = '{_T string="File"} <a target="_blank" href=\"{$galette_base_path}{$subscription_dir}upload/files/'+file.name+'\">'+old_filename+'</a> {_T string="uploaded"}. <input  type="button" id="histreset" class="button" formnovalidate="formnovalidate" onClick="cancel()" value="{_T string="Delete"}">';
						});
						
					//rename the file timestamp.extension
					//Extraction de l'extension
					var re = /(?:\.([^.]+))?$/;
					var ext = re.exec(file.name)[1]; 
					//récupération du timestamp
					file.name={$timestamp}+'_'+{$file->id_act}+'_1'+'.'+ext;
					document.getElementById('emplacement').value=file.name;
					document.getElementById('doc_name').value=old_filename;
					
					// Send the file:
					file.sendTo('{$galette_base_path}{$subscription_dir}upload/code/upload.php');
					}
					else { alert('{_T string="The file is too big (limit size:"} '+filesize_max+' Mo)');}
				}
			else { alert('{_T string="File type not allowed"}');}
			});
		});

      // React on successful iframe fallback upload (this is separate mechanism
      // from proper AJAX upload hence another handler):
      zone.event('iframeDone', function (xhr) {
			alert('Done uploading via <iframe>, response:\n\n' + xhr.responseText);
		  });

	</script>
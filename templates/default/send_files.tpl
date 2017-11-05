 <p> 
{_T string="Form"} ->  <b><u>{_T string="Send files"}</u></b> -> {_T string="Validation"} -> {_T string="Payement"}
 </p>      

 </BR>
  {_T string="You've chosen the following activities:"}
 </BR></BR>
 <FORM NAME="form" action="subs_confirmation.php" method="post" enctype="multipart/form-data"> 
  <div class="bigtable wrmenu">
		{assign "kinput" 0}	<!-- number of input buton to upload files -->
		{foreach from=$activities key=k item=activity}
		<table class="details">
			<caption class="ui-state-active ui-corner-top">{$activity->group_name|escape}</caption>
			<tr>
				<th colspan=2> {_T string="Add a message for the manager of activity"}</th>
				<td >
					<input type="hidden" name="id_group{$activity->id_group}" value="{$activity->id_group}"/>
					<TEXTAREA NAME="message_adh_act{$activity->id_group}" ROWS=2 COLS=20></TEXTAREA>					
				</td>
			</tr>
		{if $files_vierges[{$activity->id_group}] >0}
			<tr>
				<td colspan=3>----------------------------------------------------------------------------------------------------
				</td>
			</tr>
			<tr>
					<th colspan=3>{_T string="List of needed files"}
					</th>
					
			</tr>			
         
			<tr>
				<th>1. {_T string="File name to fill up"}</th>
				<th>2. {_T string="Upload your file filled up"}</th>
				<th>3. {_T string="Add informations about your file"}</th>
			</tr>
			{foreach from=$files_vierges[{$activity->id_group}] key=k2 item=file}	
				<tr>
					<td><div align="center"><a href="{$galette_base_path}{$subscription_dir}upload/files/{$file->emplacement}" title="{$file->description|escape}" target="_blank">{$file->doc_name|escape} <img src="templates/default/images/download.png" height="30px" width="30px"></div></a></td>
				{if	$file->return_file == 1}
					<td>
						<div><!-- contain upload module Filedrop -->
							<noscript style="color: maroon"><!-- Filedrop needs javascript -->
							  <h2>{_T string="Activate javascript in your browser to upload a file"}</h2>
							</noscript>

							<!-- A FileDrop area. Can contain any text or elements, or be empty.
								 Can be of any HTML tag too, not necessary fieldset. -->
							<fieldset id="zone{$k}_{$k2}" onclick="getfile{$k}_{$k2}();">
							  <legend>{_T string="Drag and drop a file"}</legend>
							  <p id="consigne{$k}_{$k2}">{_T string="or click here"} <em>{_T string="Browse"}</em>...</p>
							  <p id="txtprogress{$k}_{$k2}"></p><!-- percentage -->
							  <p>
								<span id="bar_zone{$k}_{$k2}" class="bar_zone"></span><!-- progressbar -->
							  </p>
							</fieldset>
							<p id="lien{$k}_{$k2}" style="display:none">lien du fichier</p><!-- visible after the full download -->
						</div>
					</td>
					<td>
						<TEXTAREA NAME="description_{$activity->id_group}_{$k2}" ROWS=3 COLS=25></TEXTAREA>
						<input type="hidden" id="doc_name{$k}_{$k2}" name="doc_name{$activity->id_group}_{$k2}" value=""/>
						<input type="hidden" id="emplacement{$k}_{$k2}" name="emplacement{$activity->id_group}_{$k2}" value=""/>
					</td>
				
				{else}
					<td>
					</td>
					<td>
					</td>
				{/if}
				
				</tr>
				{if	$file->return_file == 1}
					<!-- Filedrop script -->
					<script type="text/javascript">
						//Function added to call the browser btn without see it
						function getfile{$k}_{$k2}(){
							document.getElementsByClassName('fd-file')[{$kinput}].click();
							}
						//Cancel btn to reset visibility of elements
						function cancel{$k}_{$k2}()
							{
							var increment='{$k}_{$k2}';
							fd.byID('zone'+increment).style.display="block";
							fd.byID('lien'+increment).style.display="none";
							fd.byID('consigne'+increment).innerHTML="ou cliquez ici <em>Parcourir</em>...";
							}
						//For IE because includes() not supported natively. Used for extension check
						function includes{$k}_{$k2}(container, value) 
							{
							var returnValue = false;
							var pos = container.indexOf(value);
							if (pos >= 0) 
								{
								returnValue = true;
								}
							return returnValue;
							}
						//Global Variables
						  // Tell FileDrop we can deal with iframe uploads using this URL:
						  {*//chemin erronné {$galette_base_path}{$subscription_dir}upload/code/ impossible à cause de {literal}. Sinon smarty n'arrive pas à lire cette ligne *}
						  {literal}var options = {iframe: {url: 'upload.php'}};{/literal}
						  // Attach FileDrop to an area ('zone' is an ID but you can also give a DOM node):
						  var zone{$k}_{$k2} = new FileDrop('zone{$k}_{$k2}', options);
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
						  zone{$k}_{$k2}.event('send', function (files) {
							// Depending on browser support files (FileList) might contain multiple items.
							files.each(function (file) {
								var increment='{$k}_{$k2}';
								//Extension check
								if(includes{$k}_{$k2}(authorized_extensions,file.type)==true)
									{
									//size check
									var filesize=file.size/Math.pow(10,6);//in Mo
									if(filesize<filesize_max)
										{
										old_filename=file.name;	
										// Reset the progress when a new upload starts:
										file.event('sendXHR', function () {
											fd.byID('bar_zone'+increment).style.width = "0%"
											})
										file.event('progress', function (sent, total) {
											fd.byID('consigne'+increment).innerHTML="";	
											fd.byID('txtprogress'+increment).textContent = '{_T string="Progress"} ' + Math.round(sent / total * 100) + '%';
											var width = sent / total * 100 + '%';
											fd.byID('bar_zone'+increment).style.width = width;
											})
										// React on successful AJAX upload:
										file.event('done', function (xhr) {
											fd.byID('zone'+increment).style.display="none";
											fd.byID('bar_zone'+increment).style.width = "0%";
											fd.byID('txtprogress'+increment).textContent ="";
											fd.byID('lien'+increment).style.display="block";
											fd.byID('lien'+increment).innerHTML = '{_T string="File"} <a target="_blank" href=\"{$galette_base_path}{$subscription_dir}upload/files/'+file.name+'\">'+old_filename+'</a> {_T string="uploaded"}. <input  type="button" id="histreset" class="button" formnovalidate="formnovalidate" onClick="cancel'+increment+'()" value="{_T string="Delete"}">';
											});
											
										//rename the file timestamp.extension
										//Extract the extension
										var re = /(?:\.([^.]+))?$/;
										var ext = re.exec(file.name)[1]; 
										//Use php timestamp to name the file on the server. Format: timestamp_id_act_increment.ext
										file.name={$timestamp}+'_'+{$file->id_act}+'_'+increment+'.'+ext;
										document.getElementById('emplacement'+increment).value=file.name;
										document.getElementById('doc_name'+increment).value=old_filename;
										
										// Send the file to the server:
										file.sendTo('{$galette_base_path}{$subscription_dir}upload/code/upload.php');
										}
										else { alert('{_T string="The file is too big (limit size:"} '+filesize_max+' Mo)');}
									}
								else { alert('{_T string="File type not allowed"}');}
								});
							});

						  // React on successful iframe fallback upload (this is separate mechanism
						  // from proper AJAX upload hence another handler):
						  zone{$k}_{$k2}.event('iframeDone', function (xhr) {
								alert('Done uploading via <iframe>, response:\n\n' + xhr.responseText);
							  });
			
					</script>
				{assign var=kinput value=$kinput+1}
				{/if}
			{/foreach}
		{/if}	
		</table>
		{/foreach}
		
	</div>
  <div class="bigtable wrmenu">
		<table class="details">
			<caption class="ui-state-active ui-corner-top">{_T string="Subscription"}</caption>
			
			{if $picture == 0}
				<tr>
					<th>{_T string="You haven't got a picture on your profile. We need one for the licence"}</BR></th>
					<td>
						<a href="{$galette_base_path}voir_adherent.php" title="{_T string="Add picture on my profile"}" target="_blank">{_T string="Add picture on my profile"}</a>
					</td>
				</tr>
			{/if}
			
			<tr>
				<th>{_T string="Add a message for subscription"}</th>
				<td>
					<TEXTAREA NAME="message_abn" ROWS=2 COLS=20></TEXTAREA>
				</td>
			</tr>
			<tr>
				<th>{_T string="Estimated TOTAL:"}</th>
				<td>
					{$subscription->total_estimme} &euro;
					<input type="hidden" name="total_estimme" value="{$subscription->total_estimme}"/>
				</td>
			</tr>
			
		</table>
	</div>
</BR>
 <div class="button-container">
	<a id="histreset" class="button" href="{$galette_base_path}voir_adherent.php">{_T string="Cancel my request"}</a>
	<input type="submit" name="next" id="next" value="{_T string="Send my request"}"/>
</FORM>
</div>
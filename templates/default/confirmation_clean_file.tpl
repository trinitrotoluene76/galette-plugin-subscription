{if isset($error)}
	{if $error==-1}
		<div id="errorbox">{_T string="Folder not find"}</div>
	{/if}
	{if $error==-2}
		<div id="errorbox">{_T string="Folder empty"}</div>
	{/if}
	<div class="button-container">
		<a id="histreset" class="button" href="{$galette_base_path}{$subscription_dir}management_subs.php">{_T string="Previous"}</a>
	</div> 
{else}

{_T string="Do you really want to delete this files?"}
	<div class="button-container">
		<a id="histreset" class="button" href="{$galette_base_path}{$subscription_dir}management_subs.php">{_T string="Previous"}</a>
		<a class="button" id="next" href="{$galette_base_path}{$subscription_dir}confirmation_clean_file.php?clean_files=1">{_T string="Yes"}</a>
	</div> 
		<p> 
			<b>{_T string="File list to delete"}: </b>
		 </p> 
		 
			<div class="bigtable">
				<table class="listing adherents" >
				  <caption>{_T string="Files on the server but not in database:"}</caption>
					<thead>
					   <tr>
							<th width=10em>
								{_T string="Record date"}
							</th>
							<th width=38em>
								{_T string="Doc name"}
							</th>
							<th width=20em>
								{_T string="Name on the server"}
							</th>
							<th>
								{_T string="Description"}
							</th>
						</tr>
					</thead>
					{foreach from=$files1 key=k1 item=file1}	
							<tr>
								<td>
									{$file1->date_record}						
								</td>
								<td>
									{$file1->doc_name}						
								</td>
								<td>
									{$file1->emplacement}						
								</td>
								<td>
									{$file1->description}						
								</td>					
							</tr>
					{/foreach}	
				</table>
			</BR>	
				<table class="listing adherents" >
				  <caption>{_T string="Old files from 2 years or more (exept forms):"}</caption>
					<thead>
					   <tr>
							<th width=10em>
								{_T string="Record date"}
							</th>
							<th width=38em>
								{_T string="Doc name"}
							</th>
							<th width=20em>
								{_T string="Name on the server"}
							</th>
							<th>
								{_T string="Description"}
							</th>
						</tr>
					</thead>
					{foreach from=$files2 key=k2 item=file2}	
							<tr>
								<td>
									{$file2->date_record}						
								</td>
								<td>
									{$file2->doc_name}						
								</td>
								<td>
									{$file2->emplacement}						
								</td>
								<td>
									{$file2->description}						
								</td>					
							</tr>
					{/foreach}	
				</table>
				</BR>	
				<table class="listing adherents" >
				  <caption>{_T string="Files in database but not on the server:"}</caption>
					<thead>
					   <tr>
							<th width=10em>
								{_T string="Record date"}
							</th>
							<th width=38em>
								{_T string="Doc name"}
							</th>
							<th width=20em>
								{_T string="Name on the server"}
							</th>
							<th>
								{_T string="Description"}
							</th>
						</tr>
					</thead>
					{foreach from=$files3 key=k3 item=file3}	
							<tr>
								<td>
									{$file3->date_record}						
								</td>
								<td>
									{$file3->doc_name}						
								</td>
								<td>
									{$file3->emplacement}						
								</td>
								<td>
									{$file3->description}						
								</td>					
							</tr>
					{/foreach}	
				</table>
			</div>
		 
	</BR>
	</BR>
{/if}
			
	

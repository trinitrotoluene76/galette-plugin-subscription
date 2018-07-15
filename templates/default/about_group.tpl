     
<div class="bigtable wrmenu" >
        <table class="listing adherents" >
            <thead>
               <tr>
                   
                    <th class="left date_row">
						{_T string="List of activities"}
                    </th>
                    
					<th class="left date_row">
                        {_T string="Price* (&euro;)"}
                    </th>
                    
                    <th class="left">
                        {_T string="Details"}
                    </th>
                </tr>
            </thead>
			
				
	{foreach from=$activities key=k item=activity}
										
				<tr>
					
					<td>
						{$activity->group_name|escape}
					</td>
					<td>
						{if $category == 0}
							{$activity->price1|escape} &euro;
						{/if}
						{if $category == 1}
							{$activity->price2|escape} &euro;
						{/if}
					</td>
					<td>
						<a href="{$galette_base_path}{$subscription_dir}view_activity.php?id_group={$activity->id_group}" title="{_T string="view details of activity"}" target="_blank">{_T string="view details"}</a>
					</td>
				</tr>
	{/foreach}			
				
        </table>
</div>
</BR>

<p>
{_T string="*Prices are function of your status. View details of activities for more informations"}</BR>
{_T string="Your status is:"} {$statut}

</p>
<form action="config_systempay.php" method="post" enctype="multipart/form-data" id="form">								
	<div class="bigtable wrmenu">
		<table class="details">
			<caption class="ui-state-active ui-corner-top">{_T string="Parameters of online payment"}</caption>
			<thead>
			   <tr>
				   <th class="left date_row">
						{_T string="field"}
					</th>
					<th class="left date_row">
						{_T string="value"}
					</th>
				</tr>
			</thead>
				<tr>
					<td>
						{_T string="Online Galette Payment function"}
					</td>
					<td>
						<select name="global_enable">
							{if {$result[0]->field_value} == 0}
								<option name="0"  value="0">{_T string="disable"}
								<option name="1" value="1">{_T string="enable"}
							{/if}
							{if {$result[0]->field_value} == 1}
								<option name="1" value="1">{_T string="enable"}
								<option name="0"  value="0">{_T string="disable"}
							{/if}
						</select>
						{_T string="Actual value"}: 
						{if {$result[0]->field_value} == 0}
							{_T string="disable"}
						{/if}
						{if {$result[0]->field_value} == 1}
							<b>{_T string="enable"}</b>
						{/if}
					</td>
				</tr>
				<tr>
					<td>
						<label title="{_T string="TEST for testing mode or PRODUCTION for real payment"}">{$result[1]->field_name}</label>
					</td>
					<td>
						<select name="mode">
						{if {$result[1]->field_value} == 0}
							<option name="0"  value="0">{_T string="TEST"}
							<option name="1" value="1">{_T string="PRODUCTION"}
						{/if}
						{if {$result[1]->field_value} == 1}
							<option name="1" value="1">{_T string="PRODUCTION"}
							<option name="0"  value="0">{_T string="TEST"}
						{/if}
						</select>
						{_T string="Actual value"}: 
						{if {$result[1]->field_value} == 0}
							{_T string="TEST"}
						{/if}
						{if {$result[1]->field_value} == 1}
							<b>{_T string="PRODUCTION"}</b>
						{/if}
					</td>
				</tr>
				<tr>
					<td>
						<label title="{_T string="Absolute URL of the web page to notify at the end of the payment."}">{$result[2]->field_name}</label>
					</td>
					<td>
						<INPUT TYPE="TEXT" title="{_T string="Absolute URL of the web page to notify at the end of the payment."}" NAME="vads_url_check" VALUE="{$result[2]->field_value}"  SIZE=100 MAXLENGTH=200>
					</td>
				</tr>
				<tr>
					<td>
						<label title="{_T string="Absolute URL of the web page to pay"}">{$result[3]->field_name}</label>
					</td>
					<td>
						<INPUT TYPE="TEXT" title="{_T string="Absolute URL of the web page to pay"}" NAME="url_payment_systempay" VALUE="{$result[3]->field_value}"  SIZE=100 MAXLENGTH=200>
					</td>
				</tr>
				<tr>
					<td>
						<label title="{_T string="Relative URL of the folder systempay"}">{$result[4]->field_name}</label>
					</td>
					<td>
						<INPUT TYPE="TEXT" title="{_T string="Relative URL of the folder systempay"}" NAME="systempay_path" VALUE="{$result[4]->field_value}"  SIZE=100 MAXLENGTH=200>
					</td>
				</tr>					
		</table>
	</div>
	<div class="button-container">
		<input type="submit" name="valid" id="btnsave" value="{_T string="Save"}"/>
	</div>
</form> 
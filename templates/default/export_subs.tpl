<a href="{$galette_base_path}{$subscription_dir}get_export.php?file=liste_adherents_appartenance_{$id_act}.csv"  target="_blank">telecharger la liste des membres de la section {$id_act}</a>
</br>
<a href="{$galette_base_path}{$subscription_dir}get_export.php?file=liste_abn_appartenance_statut_{$id_act}.csv"  target="_blank">telecharger la liste des abonnements pour la section {$id_act}</a>
</br>
{if $login->isStaff()==1 || $login->isSuperAdmin()==1 || $login->isAdmin()==1}
<a href="{$galette_base_path}{$subscription_dir}get_export.php?file=liste_abn_appartenance_statut_global.csv"  target="_blank">telecharger la liste globale des abonnements</a>
{/if}
<div class="button-container">
	<a id="histreset" class="button" href="" onclick="javascript:window.close()">{_T string="Close"}</a>
</div>
</br>
<a href="{$galette_base_path}{$subscription_dir}download/Guide_exportation_indE.pdf" target="_blank">Guide_exportation_indE.pdf</a>

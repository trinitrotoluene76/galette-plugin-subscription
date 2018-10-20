SELECT `tsp_ID` as `ID`, `test`.`FR` as `Test`, `signature`.`FR` as `Signature`, `statut_trans`.`FR` as `Statut`, `resultat`.`FR` as `Resultat`, `tsp_Montant`, `tsp_Montant_Effectif`, `paiement_conf`.`FR` as `Config`, 
`tsp_Num_Sequence`, `autorisation`.`FR` as `Autorisation`, `garantie`.`FR` as `Garantie`, `threeds`.`FR` as `Threeds`, `tsp_Delai_Avant_Banque`, `mode_valid`.`FR` as `Validation`, `tsp_Numero_Transaction`, `tsp_Reference_Commande`, 
`tsp_Date_Heure`, `tsp_Reference_Acheteur`, `tsp_Nom_Acheteur`, `tsp_Email`, `mod_type`.`FR` as `Mode_Type`, `tsp_Numero_Autorisation` as `N° Autorisation`, `tsp_order_info` as `Order_info`
FROM `tb_systempay_oper` 
inner join `tb_systempay_msg` as `test` on `tsp_Mode_Test_Prod`=`test`.`ID`
inner join `tb_systempay_msg` as `signature` on `tsp_Signature_Ok`=`signature`.`ID`
inner join `tb_systempay_msg` as `statut_trans` on `tsp_Statut_Transaction`=`statut_trans`.`ID`
inner join `tb_systempay_msg` as `resultat` on `tsp_Resultat`=`resultat`.`ID`
inner join `tb_systempay_msg` as `paiement_conf` on `tsp_Paiement_Config`=`paiement_conf`.`ID`
inner join `tb_systempay_msg` as `autorisation` on `tsp_Autorisation`=`autorisation`.`ID`
inner join `tb_systempay_msg` as `garantie` on `tsp_Garantie`=`garantie`.`ID`
inner join `tb_systempay_msg` as `threeds` on `tsp_Threeds`=`threeds`.`ID`
inner join `tb_systempay_msg` as `mode_valid` on `tsp_Mode_Validation`=`mode_valid`.`ID`
inner join `tb_systempay_msg` as `mod_type` on `tsp_Type`=`mod_type`.`ID`

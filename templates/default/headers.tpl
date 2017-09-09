<script type="text/javascript" src="{$galette_base_path}{$subscription_tpl_dir}form.js" ></script>{* This file calculate the total price of the subscription in live *}
<script type="text/javascript" src="{$galette_base_path}{$subscription_dir}upload/code/filedrop-min.js" ></script>{* This file give tools to upload files *}
<style type="text/css">{* CCS for uploading module *}
	/***
	  Styles below are only required if you're using <iframe> fallback in
	  addition to HTML5 drag & drop (only working in Firefox/Chrome).
	 ***/

	/* Essential FileDrop zone element configuration: */
	.fd-zone {
	  position: relative;
	  overflow: hidden;
	  /* The following are not required but create a pretty box: */
	  width: auto;
	  margin: 5px auto;
	  text-align: center;
	  cursor:pointer;
	}

	/* Hides <input type="file"> while simulating "Browse" button: */
	.fd-file {
	  display:none;
	}

	#bar_zone {
		display:block; 
		background-color:red; 
		width:0;
		height: 2px;
	}

	/* Provides visible feedback when use drags a file over the drop zone: */
	.fd-zone.over { border-color: maroon; background: #eee; }
</style>
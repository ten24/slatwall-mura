/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.editorConfig = function( config )
{
	// Define changes to default configuration here. For example:
	// config.language = 'fr';
	// config.uiColor = '#AADC6E';
	config.filebrowserBrowseUrl = slatwall.rootURL + '/org/ckfinder/ckfinder.html';
	config.filebrowserImageBrowseUrl = slatwall.rootURL + '/org/ckfinder/ckfinder.html?Type=Image';
	config.filebrowserFlashBrowseUrl = slatwall.rootURL + '/org/ckfinder/ckfinder.html?Type=Flash';
	config.filebrowserUploadUrl = slatwall.rootURL + '/org/ckfinder/core/connector/cfm/connector.cfm?command=QuickUpload&type=Files';
	config.filebrowserImageUploadUrl = slatwall.rootURL + '/org/ckfinder/core/connector/cfm/connector.cfm?command=QuickUpload&type=Image';
	config.filebrowserFlashUploadUrl = slatwall.rootURL + '/org/ckfinder/core/connector/cfm/connector.cfm?command=QuickUpload&type=Flash';
};

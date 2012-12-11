component extends="Slatwall.admin.controllers.BaseController" output="false" accessors="true"  {

	property name="utilityFileService" type="any";

	this.secureMethods="default,updateviews";
	
	public void function updateViews() {
		var baseSlatwallPath = getDirectoryFromPath(expandPath("/muraWRM/plugins/Slatwall/frontend/views/")); 
		var baseSitePath = getDirectoryFromPath(expandPath("/muraWRM/#rc.siteid#/includes/display_objects/custom/slatwall/"));

		getUtilityFileService().duplicateDirectory(baseSlatwallPath,baseSitePath,true,true,".svn");
		getFW().redirect(action="admin:main");
	}
	
}
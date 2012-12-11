component extends="Slatwall.admin.controllers.BaseController" {

	this.secureMethods="default,syncpush,syncpull,syncall";

	public void function syncPush() {
		
		var syncUtility = new Slatwall.integrationServices.endicia.model.SyncUtility();

		var responseBean = syncUtility.syncPush();
		
		if( !responseBean.hasErrors() ) {
			showMessage("Pushing endicia update files executed sucessfully!", "success");
		} else {
			responseBean.showErrorMessages();
		}
			
		getFW().setView("endicia:main.default");
	}
	
	public void function syncPull() {
		
		var syncUtility = new Slatwall.integrationServices.endicia.model.SyncUtility();
		
		var responseBean = syncUtility.syncPull();
		
		if( !responseBean.hasErrors() ) {
			showMessage("Pulling endicia update files executed sucessfully!", "success");
		} else {
			responseBean.showErrorMessages();
		}
		
		getFW().setView("endicia:main.default");
	}
	
	public void function syncAll() {
		
		var syncUtility = new Slatwall.integrationServices.endicia.model.SyncUtility();
		
		var pullResult = syncUtility.syncPull();
		
		if( !pullResult.hasErrors() ) {
			showMessage("Pulling endicia update files executed sucessfully!", "success");
			
			var pushResult = syncUtility.syncPush();
			
			if( !pushResult.hasErrors() ) {
				showMessage("Pulling endicia update files executed sucessfully!", "success");
			} else {
				pushResult.showErrorMessages();
			}
		
		} else {
			pullResult.showErrorMessages();
		}
		
		getFW().setView("endicia:main.default");
	}
	
	
	
}
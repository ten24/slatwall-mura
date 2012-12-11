/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

*/
component extends="BaseController" output=false accessors=true {

	// fw1 Auto-Injected Service Properties
	property name="productService" type="any";
	property name="orderService" type="any";
	property name="vendorService" type="any";
	property name="dataService" type="any";
	property name="imageService" type="any";
	property name="updateService" type="any";
	
	this.publicMethods='';
	this.publicMethods=listAppend(this.publicMethods, 'noaccess');
	this.publicMethods=listAppend(this.publicMethods, 'error');
	
	this.anyAdminMethods='';
	this.anyAdminMethods=listAppend(this.anyAdminMethods, 'default');
	this.anyAdminMethods=listAppend(this.anyAdminMethods, 'createImage');
	this.anyAdminMethods=listAppend(this.anyAdminMethods, 'deleteImage');
	this.anyAdminMethods=listAppend(this.anyAdminMethods, 'detailImage');
	this.anyAdminMethods=listAppend(this.anyAdminMethods, 'editImage');
	
	this.secureMethods='';
	this.secureMethods=listAppend(this.secureMethods, 'ckfinder');
	this.secureMethods=listAppend(this.secureMethods, 'about');
	this.secureMethods=listAppend(this.secureMethods, 'update');
	
	public void function default(required struct rc) {
		
		rc.productSmartList = getProductService().getProductSmartList();
		rc.productSmartList.addOrder("modifiedDateTime|DESC");
		rc.productSmartList.setPageRecordsShow(10);
		
		rc.orderSmartList = getOrderService().getOrderSmartList();
		rc.orderSmartList.addFilter("orderStatusType.systemCode", "ostNew");
		rc.orderSmartList.addOrder("orderOpenDateTime|DESC");
		rc.orderSmartList.setPageRecordsShow(10);
		
		rc.productReviewSmartList = getProductService().getProductReviewSmartList();
		rc.productReviewSmartList.addFilter("activeFlag", 0);
		rc.productReviewSmartList.setPageRecordsShow(10);
		
		rc.vendorOrderSmartList = getVendorService().getVendorOrderSmartList();
		rc.vendorOrderSmartList.addOrder("modifiedDateTime|DESC");
		rc.vendorOrderSmartList.setPageRecordsShow(10);
		
	}

	public void function saveImage(required struct rc){
		
		var image = getImageService().getImage(rc.imageID, true);
		image.setDirectory(rc.directory);
		
		if(rc.imageFile != ''){
			var documentData = fileUpload(getTempDirectory(),'imageFile','','makeUnique');
			
			if(len(image.getImageFile()) && fileExists(expandpath(image.getImageDirectory()) & image.getImageFile())){
				fileDelete(expandpath(image.getImageDirectory()) & image.getImageFile());	
			}
			
			//need to handle validation at some point
			if(documentData.contentType eq 'image'){
				fileMove(documentData.serverDirectory & '/' & documentData.serverFile, expandpath(image.getImageDirectory()) & documentData.serverFile);
				rc.imageFile = documentData.serverfile;
			}else if (fileExists(expandpath(image.getImageDirectory()) & image.getImageFile())){
				fileDelete(expandpath(image.getImageDirectory()) & image.getImageFile());	
			}
			
		}else if(structKeyExists(rc,'deleteImage') && fileExists(expandpath(image.getImageDirectory()) & image.getImageFile())){
			fileDelete(expandpath(image.getImageDirectory()) & image.getImageFile());	
			rc.imageFile='';
		}else{
			rc.imageFile = image.getImageFile();
		}
		
		super.genericSaveMethod('Image',rc);
		
	}
	
	public void function update(required struct rc) {
		param name="rc.process" default="0";
		
		if(rc.process) {
			logSlatwall("Update Called", true);
			getUpdateService().update(branch=rc.updateBranch);
			logSlatwall("Update Finished, Now Calling Reload", true);
			getFW().redirect(action="admin:main.update", queryString="reload=1&messageKeys=admin.main.update_success");
		}
		
		var versions = getUpdateService().getAvailableVersions();
		rc.availableDevelopVersion = versions.develop;
		rc.availableMasterVersion = versions.master;

		rc.currentVersion = getApplicationValue('version');
		if(find("-", rc.currentVersion)) {
			rc.currentBranch = "develop";
		} else {
			rc.currentBranch = "master";
		}
	}
	

}

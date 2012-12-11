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
	property name="SkuService" type="any";
	property name="OptionService" type="any";
	property name="UtilityORMService" type="any";
	property name="ImageService" type="any";
	
	this.publicMethods='';
	
	this.anyAdminMethods='';
	
	this.secureMethods='';
	this.secureMethods=listAppend(this.secureMethods, '**brand');
	this.secureMethods=listAppend(this.secureMethods, '**product');
	this.secureMethods=listAppend(this.secureMethods, '**productReview');
	this.secureMethods=listAppend(this.secureMethods, '**productType');
	this.secureMethods=listAppend(this.secureMethods, '**optionGroup');
	this.secureMethods=listAppend(this.secureMethods, '*option');
	this.secureMethods=listAppend(this.secureMethods, '**subscriptionTerm');
	this.secureMethods=listAppend(this.secureMethods, '**subscriptionBenefit');
	
	public void function default(required struct rc) {
		getFW().redirect(action="admin:product.listproduct");
	}
	
	public void function createMerchandiseProduct(required struct rc) {
		rc.product = getProductService().newProduct();
		rc.baseProductType = "merchandise";
		
		rc.pageTitle = replace(rbKey('admin.define.create'), '${itemEntityName}', rbKey('entity.product')); 
		rc.listAction = "admin:product.listproduct"; 
		rc.saveAction = "admin:product.saveproduct";
		rc.cancelAction = "admin:product.listproduct";
		
		rc.edit = true;
		getFW().setView("admin:product.createproduct");
	}
	
	public void function createSubscriptionProduct(required struct rc) {
		rc.product = getProductService().newProduct();
		rc.baseProductType = "subscription";
		
		rc.pageTitle = replace(rbKey('admin.define.create'), '${itemEntityName}', rbKey('entity.product')); 
		rc.listAction = "admin:product.listproduct"; 
		rc.saveAction = "admin:product.saveproduct";
		rc.cancelAction = "admin:product.listproduct";
				
		rc.edit = true;
		getFW().setView("admin:product.createproduct");
	}
	
	public void function createContentAccessProduct(required struct rc) {
		rc.product = getProductService().newProduct();
		rc.baseProductType = "contentAccess";
				
		rc.pageTitle = replace(rbKey('admin.define.create'), '${itemEntityName}', rbKey('entity.product')); 
		rc.listAction = "admin:product.listproduct"; 
		rc.saveAction = "admin:product.saveproduct";
		rc.cancelAction = "admin:product.listproduct";
		
		rc.edit = true;
		getFW().setView("admin:product.createproduct");
	}
	
	public void function createMerchandiseProductType(required struct rc) {
		rc.producttype = getProductService().newProductType();
		rc.baseProductType = "merchandise";
		
		rc.listAction = "admin:product.listproducttype"; 
		rc.saveAction = "admin:product.saveproducttype";
		rc.cancelAction = "admin:product.listproducttype";
		
		rc.edit = true;
		getFW().setView("admin:product.detailproducttype");
	}
	
	public void function createSubscriptionProductType(required struct rc) {
		rc.producttype = getProductService().newProductType();
		rc.baseProductType = "subscription";
		
		rc.listAction = "admin:product.listproducttype"; 
		rc.saveAction = "admin:product.saveproducttype";
		rc.cancelAction = "admin:product.listproducttype";
		
		rc.edit = true;
		getFW().setView("admin:product.detailproducttype");
	}
	
	public void function createContentAccessProductType(required struct rc) {
		rc.producttype = getProductService().newProductType();
		rc.baseProductType = "contentAccess";
		
		rc.listAction = "admin:product.listproducttype"; 
		rc.saveAction = "admin:product.saveproducttype";
		rc.cancelAction = "admin:product.listproducttype";
		
		rc.edit = true;
		getFW().setView("admin:product.detailproducttype");
	}
	
	public void function saveSku(required struct rc){
		var sku = getSkuService().getSku(rc.skuID,true);
		var imageNameToUse='';
		
		if(structKeyExists(rc,'imageFileUpload') && rc.imageFileUpload != ''){
			var documentData = fileUpload(getTempDirectory(),'imageFileUpload','','makeUnique');
			
			//if overwriting old image, delete image			
			if(len(sku.getImageFile()) && fileExists(expandpath(sku.getImageDirectory()) & sku.getImageFile())){
				fileDelete(expandpath(sku.getImageDirectory()) & sku.getImageFile());	
			}
			
			
			//set up image name
			if(structKeyExists(rc,'imageExclusive') && rc.imageExclusive){
				if(left(setting('globalImageExtension'),1) eq '.') {
					imageNameToUse = rc.skucode & setting('globalImageExtension');	
				} else {
					imageNameToUse = rc.skucode & '.' & setting('globalImageExtension');
				}
			}else{
				imageNameToUse=sku.getImageFile();
			}
			
			//need to handle validation at some point
			if(documentData.contentType eq 'image'){
				if(fileExists(expandpath(sku.getImageDirectory()) & imageNameToUse)){
					fileDelete(expandpath(sku.getImageDirectory()) & imageNameToUse);
				}
				
				if( !directoryExists( replaceNoCase(expandPath(sku.getImageDirectory()), 'index.cfm/', '', 'all') )) {
					directoryCreate( replaceNoCase(expandPath(sku.getImageDirectory()), 'index.cfm/', '', 'all') );
				}
				
				fileMove(documentData.serverDirectory & '/' & documentData.serverFile, replaceNoCase(expandPath(sku.getImageDirectory()), 'index.cfm/', '', 'all') & imageNameToUse);
				
				rc.imageFile = imageNameToUse;
				
			}else{
				fileDelete(documentData.serverDirectory & '/' & documentData.serverFile);	
			}
			
			getImageService().clearImageCache(sku.getImageDirectory(),sku.getImageFile());
			
		}else if(structKeyExists(rc,'deleteImage') && rc.deleteImage && fileExists(expandpath(sku.getImageDirectory()) & sku.getImageFile())){
			// Clear the cache
			getImageService().clearImageCache(sku.getImageDirectory(),sku.getImageFile());
			
			// Delete the file
			fileDelete( expandPath(sku.getImageDirectory()) & sku.getImageFile());
			
			// Set the imageName back to whatever automatically gets generated
			rc.imageFile=sku.generateImageFileName();
		}else{
			
			rc.imageFile = sku.getImageFile();
		}
		
		super.genericSaveMethod('Sku', rc);
	}
	
	public void function saveOption(required struct rc){
		var option = getOptionService().getOption(rc.optionID,true);
		
		if(rc.optionImage != ''){
			var documentData = fileUpload(getTempDirectory(),'optionImage','','makeUnique');
			
			if(len(option.getOptionImage()) && fileExists(expandpath(option.getImageDirectory()) & option.getOptionImage())){
				fileDelete(expandpath(option.getImageDirectory()) & option.getOptionImage());	
			}
			
			//need to handle validation at some point
			if(documentData.contentType eq 'image'){
				fileMove(documentData.serverDirectory & '/' & documentData.serverFile, expandpath(option.getImageDirectory()) & documentData.serverFile);
				rc.optionImage = documentData.serverfile;
			}else if (fileExists(expandpath(option.getImageDirectory()) & option.getOptionImage())){
				fileDelete(expandpath(option.getImageDirectory()) & option.getOptionImage());	
			}
			
		}else if(structKeyExists(rc,'deleteImage') && fileExists(expandpath(option.getImageDirectory()) & option.getOptionImage())){
			fileDelete(expandpath(option.getImageDirectory()) & option.getOptionImage());	
			rc.optionImage='';
		}else{
			rc.optionImage = option.getOptionImage();
		}
		
		super.genericSaveMethod('Option',rc);
	}
}
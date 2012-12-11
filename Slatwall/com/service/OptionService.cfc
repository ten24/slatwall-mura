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
component extends="BaseService" accessors="true" {

	property name="productService" type="any";

	
	private void function processImageUpload(required any entity, required struct imageUploadResult) {
		var imageName = createUUID() & "." & arguments.imageUploadResult.serverFileExt;
		var filePath = arguments.entity.getImageDirectory() & imageName;
		var imageSaved = getService("imageService").saveImageFile(uploadResult=arguments.imageUploadResult,filePath=filePath);
		if(imageSaved) {
			// if this was a new image where a pre-existing one existed for this object, delete the old image
			if(arguments.entity.hasImage()) {
				removeImage(arguments.entity);
			}
			if(arguments.entity.getClassName() == "SlatwallOption") {
				arguments.entity.setOptionImage(imageName);
			} else if(arguments.entity.getClassName() == "SlatwallOptionGroup") {
				arguments.entity.setOptionGroupImage(imageName);
			}
		}
	}
	
	public array function getOptionsForSelect(required any options){
		var sortedOptions = [];
		
		for(i=1; i <= arrayLen(arguments.options); i++){
			arrayAppend(sortedOptions,{name=arguments.options[i].getOptionName(),value=arguments.options[i].getOptionID()});
		}
		
		return sortedOptions;
	}
	
	
	// ===================== START: Logical Methods ===========================
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	public array function getUnusedProductOptions(required string productID, required string existingOptionGroupIDList){
		return getDAO().getUnusedProductOptions(argumentCollection=arguments);
	}
	
	public array function getUnusedProductOptionGroups(required string existingOptionGroupIDList){
		return getDAO().getUnusedProductOptionGroups(argumentCollection=arguments);
	}
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	public any function saveOptionGroup(required any entity, required struct data) {
		
		// This also saves options that were passed in the correct format by using base object populate that will automatically call saveOption() in this service
		super.save(argumentcollection=arguments);
		
		if(!arguments.entity.hasErrors()) {
			// remove image if option is checked (unless a new image is set, in which case the old image is removed by processUpload
			if(structKeyExists(arguments.data,"removeImage") and arguments.entity.hasImage() and !structKeyExists(arguments.data,"imageUploadResult")) {
				removeImage(arguments.entity);
			}
			// process image if one was uploaded
			if(structKeyExists(arguments.data,"imageUploadResult")) {
				processImageUpload(arguments.entity,arguments.data.imageUploadResult);
			} 
		} else {
			// delete image if one was uploaded
			if(structKeyExists(arguments.data,"imageUploadResult")) {
				var result = arguments.data.imageUploadResult;
				var uploadPath = result.serverDirectory & "/" & result.serverFile;
				fileDelete(uploadPath);
			} 
		}
		
		return arguments.entity;
	}
	
	public any function saveOption(required any entity, required struct data) {
		
		super.save(argumentcollection=arguments);
		
		if(!arguments.entity.hasErrors()) {
			// remove image if option is checked (unless a new image is set, in which case the old image is removed by processUpload
			if(structKeyExists(arguments.data,"removeImage") and arguments.entity.hasImage() and !structKeyExists(arguments.data,"imageUploadResult")) {
				removeImage(arguments.entity);
			}
			// process image if one was uploaded
			if(structKeyExists(arguments.data,"imageUploadResult")) {
				processImageUpload(arguments.entity,arguments.data.imageUploadResult);
			} 
		} else {
			// delete image if one was uploaded
			if(structKeyExists(arguments.data,"imageUploadResult")) {
				var result = arguments.data.imageUploadResult;
				var uploadPath = result.serverDirectory & "/" & result.serverFile;
				fileDelete(uploadPath);
			} 
		}
		
		return arguments.entity;
	}
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
}

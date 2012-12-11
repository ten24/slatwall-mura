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
component displayname="Image Service" persistent="false" extends="BaseService" output="false" accessors="true"{
	property name="utilityTagService" type="any";
		
	// Image File Methods
	public string function getResizedImagePath(required string imagePath, numeric width=0, numeric height=0, string resizeMethod="scale", string cropLocation="", numeric cropXStart=0, numeric cropYStart=0,numeric scaleWidth=100,numeric scaleHeight=100,string missingImagePath) {
		var resizedImagePath = "";
		
		
		// If the image can't be found default to a missing image
		if(!fileExists(expandPath(arguments.imagePath))) {
			if(structKeyExists(arguments, "missingImagePath") && fileExists(expandPath(arguments.missingImagePath))) {
				arguments.imagePath = arguments.missingImagePath;
			} else if ( fileExists(expandPath(setting('globalMissingImagePath'))) ) {
				arguments.imagePath = setting('globalMissingImagePath');
			} else {
				arguments.imagePath = "#getSlatwallRootPath()#/assets/images/missingimage.jpg";	
			}
		}
		
		if(!arguments.width && !arguments.height) {
			// if no width and height is passed in, display the original image
			resizedImagePath = arguments.imagePath;
		} else {
			// if dimensions are passed in, check to see if the image has already been created. If so, display it, if not create it first and then display it
			var imageNameSuffix = (arguments.width && arguments.height) ? "_#arguments.width#w_#arguments.height#h" : (arguments.width ? "_#arguments.width#w" : "_#arguments.height#h");
			// image name will reflect that resize method (defaults to "scale" so that one isn't indicated)
			if(arguments.resizeMethod == "scaleAndCrop") {
				imageNameSuffix &= "_sc_#arguments.cropLocation#";
			} else if(arguments.resizeMethod == "crop") {
				if(arguments.cropXStart || arguments.cropYStart) {
					imageNameSuffix &= "_c_#arguments.cropXStart#x_#arguments.cropYStart#y";
				} else {
					imageNameSuffix &= "_c_#arguments.cropLocation#";
				}
				if(arguments.scaleWidth != 100) {
					imageNameSuffix &= "_#arguments.scaleWidth#sw";
				}
				if(arguments.scaleHeight != 100) {
					imageNameSuffix &= "_#arguments.scaleHeight#sh";
				}
			}
			var imageExt = listLast(arguments.imagePath,".");
			
			var cacheDirectory = replaceNoCase(expandPath(arguments.imagePath), listLast(arguments.imagePath, "/\"), "cache/");
			
			if(!directoryExists(cacheDirectory)) {
				directoryCreate(cacheDirectory);
			}
			
			var resizedImagePath = replaceNoCase(replaceNoCase(arguments.imagePath, listLast(arguments.imagePath, "/\"), "cache/#listLast(arguments.imagePath, "/\")#"),".#imageExt#","#imageNameSuffix#.#imageExt#");
			
			// Make sure that if a cached images exists that it is newer than the original
			if(fileExists(expandPath(resizedImagePath))) {
				var originalFileObject = createObject("java","java.io.File").init(expandPath(arguments.imagePath));
				var resizedFileObject = createObject("java","java.io.File").init(expandPath(resizedImagePath));
				var originalLastModified = createObject("java","java.util.Date").init(originalFileObject.lastModified());
				var resizedLastModified = createObject("java","java.util.Date").init(resizedFileObject.lastModified());;
				
				if(originalLastModified > resizedLastModified) {
					fileDelete(expandPath(resizedImagePath));
				}
			}
			
			if(!fileExists(expandPath(resizedImagePath))) {
				// wrap image functions in a try-catch in case the image uploaded is "problematic" for CF to work with
				try{
					var img = imageRead(expandPath(arguments.imagePath));
					// scale to fit if both height and width are specified, else resize accordingly
					if(arguments.resizeMethod == "scale") {
						if(arguments.width && arguments.height) {
							imageScaleToFit(img,arguments.width,arguments.height);
						} else {
							if(!arguments.width) {
								arguments.width = "";
							} else if(!arguments.height) {
								arguments.height = "";
							}
							imageResize(img,arguments.width,arguments.height);
						}
					} else if(arguments.resizeMethod == "scaleAndCrop") {
						if(!arguments.width) {
							arguments.width = arguments.height;
						}
						if(!arguments.height) {
							arguments.height = arguments.width;
						}
						// default location of scale and crop to center of image
						if(len(arguments.cropLocation) == 0) {
							arguments.cropLocation = "center";
						}
						// use aspectCrop() method for scale and crop
						img = aspectCrop(img,arguments.width,arguments.height,arguments.cropLocation);
					} else if(arguments.resizeMethod == "crop") {
						if(!arguments.width) {
						arguments.width = arguments.height;
						}
						if(!arguments.height) {
							arguments.height = arguments.width;
						}
						img = customCrop(img,arguments.width,arguments.height,arguments.cropLocation,arguments.cropXStart,arguments.cropYStart,arguments.scaleWidth,arguments.scaleHeight);
					}
					imageWrite(img,expandPath(resizedImagePath));					
				}
				catch(any e) {
					// log the error
					logSlatwallException(e);
				}
			}
		}
		return resizedImagePath;
	}
	
	public string function displayImage(required string imagePath, numeric width=0, numeric height=0,string alt="",string class="") {
		var resizedImagePath = getResizedImagePath(imagePath=arguments.imagePath, width=arguments.width, height=arguments.height);
		var img = imageRead(expandPath(resizedImagePath));
		var imageDisplay = '<img src="#resizedImagePath#" width="#imageGetWidth(img)#" height="#imageGetHeight(img)#" alt="#arguments.alt#" class="#arguments.class#" />';
		return imageDisplay;
	}

	public boolean function saveImageFile(required struct uploadResult, required string filePath, string allowedExtensions="", boolean overwrite=true) {
		var result = arguments.uploadResult;
		if(result.fileWasSaved){
			var uploadPath = result.serverDirectory & "/" & result.serverFile;
			var validFile = isImageFile(uploadPath);
			if(len(arguments.allowedExtensions)) {
				validFile = listFindNoCase(arguments.allowedExtensions,result.serverFileExt);
			}
			if(validFile) {
				var img=imageRead(uploadPath);
				var absPath = expandPath(arguments.filePath);
				if(!directoryExists(getDirectoryFromPath(absPath))) {
					directoryCreate(getDirectoryFromPath(absPath));
				}
				imageWrite(img,absPath,arguments.overwrite);
				return true;
			} else {
				// file was not a valid image, so delete it
				fileDelete(uploadPath);
				return false;
			}	
		} else {
			// upload was not successful
			return false;
		}
	}
	
	public boolean function removeImage(required string filePath) {
		var fileName = right(arguments.filePath,len(arguments.filePath)-len(getDirectoryFromPath(arguments.filePath)));
		// pop off leading slash
		if(fileName.startsWith("/") or fileName.startsWith("\")) {
			fileName = right(fileName,len(filename)-1);
		}
		// get file name without extension
		var baseFileName = listFirst(fileName,".");
		var fileList = directoryList(expandPath(getDirectoryFromPath(arguments.filePath)),true,"query");
		// loop through directory and delete base image and all resized versions in the cache subdirectory
		for(var i = 1; i<= fileList.recordCount; i++) {
			if(fileList.type[i] == "file" && fileList.name[i].startsWith(baseFileName)) {
				fileDelete(fileList.directory[i] & "/" & fileList.name[i]);
			}
		}
		return true;
	}
	
	public void function clearImageCache(string directoryPath, string imageName){
		var cacheFolder = expandpath(arguments.directoryPath & "/cache/");

		var files = getUtilityTagService().cfdirectory(action="list",directory=cacheFolder);
		
		cachedFiles = new Query();
	    cachedFiles.setDBType('query');
	    cachedFiles.setAttributes(rs=files); 
	    cachedFiles.addParam(name='filename', value='#listgetat(arguments.imageName,1,'.')#%', cfsqltype='cf_sql_varchar');
	    cachedFiles.setSQL('SELECT * FROM rs where NAME like :filename');
	    cachedFiles = cachedFiles.execute().getResult();
	    
		for(i=1; i <= cachedFiles.recordcount; i++){
			if(fileExists(cachedFiles.directory[i] & '/' & cachedFiles.name)) {
				fileDelete(cachedFiles.directory[i] & '/' & cachedFiles.name);	
			}
		}
	}
		
	/*
	Function: aspectCrop
	Author: Emmet McGovern
	http://www.illequipped.com/blog
	emmet@fullcitymedia.com
	2/29/2008 - Leap Day!
	Part of ImageUtils.cfc library (http://imageutils.riaforge.org/)
	Adapted for Slatwall by Tony Garcia 6/28/11
	*/
	public any function aspectCrop(required any image, required numeric cropWidth, required numeric cropHeight, required position="center") {
		
		// Define local variables.
		var nPercent = "";
		var wPercent = "";
		var hPercent = "";
		var px = "";
		var ycrop = "";
		var xcrop = "";
		
		// if not image, assume path
		if( !isImage(arguments.image) && !isImageFile(arguments.image) ) {
			throw(message="The value passed to aspectCrop was not an image.");
		}
		
		//  If we were given a path to an image, read the image into a ColdFusion image object. 
		if(isImageFile(arguments.image)) {
			arguments.image = imageRead(arguments.image);
		}
		
		// Resize image without going over crop dimensions
		wPercent = arguments.cropwidth / arguments.image.width;
		hPercent = arguments.cropheight / arguments.image.height;
		
		if(wPercent > hPercent) {
			nPercent = wPercent;
			px = arguments.image.width * nPercent + 1;
			imageResize(arguments.image,px,"");
		} else {
			nPercent = hPercent;
			px = arguments.image.height * nPercent + 1;
			imageResize(arguments.image,"",px);	
		}
		
		//Set the xy offset for cropping, if not provided defaults to center 
		if(listfindnocase("topleft,left,bottomleft", arguments.position)) {
			xcrop = 0;
		} else if( listfindnocase("topcenter,center,bottomcenter", arguments.position) ) {
			xcrop = (arguments.image.width - arguments.cropwidth)/2;
		} else if( listfindnocase("topright,right,bottomright", arguments.position) ) {
			xcrop = arguments.image.width - arguments.cropwidth;
		} else {
			xcrop = (arguments.image.width - arguments.cropwidth)/2;
		}
	
		if( listfindnocase("topleft,topcenter,topright", arguments.position) ) {
			ycrop = 0;
		} else if( listfindnocase("left,center,right", arguments.position) ) {
			ycrop = (arguments.image.height - arguments.cropheight)/2;
		} else if( listfindnocase("bottomleft,bottomcenter,bottomright", arguments.position) ) {
			ycrop = arguments.image.height - arguments.cropheight;
		} else {
			ycrop = (arguments.image.height - arguments.cropheight)/2;
		}
	
		// Return new cropped image.
		imageCrop(arguments.image,xcrop,ycrop,arguments.cropwidth,arguments.cropheight);
		
		return arguments.image;
	}
	
	public any function customCrop(required any image, required numeric width, required numeric height, string cropLocation="", numeric cropXStart=0, numeric cropYStart=0,numeric scaleWidth=0,numeric scaleHeight=0) {
		
		// Set the xy offset for cropping from location, if passed in
		if(len(arguments.cropLocation) > 0) {
			if(listfindnocase("topleft,left,bottomleft", arguments.croplocation)) {
				arguments.cropXStart = 0;
			} else if( listfindnocase("topcenter,center,bottomcenter", arguments.croplocation) ) {
				arguments.cropXStart = (arguments.image.width - arguments.width)/2;
			} else if( listfindnocase("topright,right,bottomright", arguments.croplocation) ) {
				arguments.cropXStart = arguments.image.width - arguments.width;
			} 
		
			if( listfindnocase("topleft,topcenter,topright", arguments.croplocation) ) {
				arguments.cropYStart = 0;
			} else if( listfindnocase("left,center,right", arguments.croplocation) ) {
				arguments.cropYStart = (arguments.image.height - arguments.height)/2;
			} else if( listfindnocase("bottomleft,bottomcenter,bottomright", arguments.position) ) {
				arguments.cropYStart = arguments.image.height - arguments.height;
			}
		}
		
		if(!arguments.scaleHeight && !arguments.scaleWidth) {
		// if no scaling arguments are passed in, we simply crop the image using imageCrop
			imageCrop(arguments.image,arguments.cropXStart,arguments.cropYStart,arguments.width,arguments.height);
			return arguments.image;
		} else {
			// handle setting the scaling on the other dimension if only one was passed in.
			if(!arguments.scaleHeight) {
				arguments.scaleHeight = arguments.scaleWidth;
			} else if (!arguments.scaleWidth) {
				arguments.scaleWidth = arguments.scaleHeight;
			}
			// get the height and width of the crop on the original image from the scale arguments
			var cropWidth = arguments.image.width * (arguments.scaleWidth/100);
			var cropHeight = arguments.image.height * (arguments.scaleHeight/100);
			
			//crop the original image
			imageCrop(arguments.image,arguments.cropXStart,arguments.cropYStart,cropWidth,cropHeight);
			
			// resize the cropped image to the passed in dimensions
			// in case the aspect ratio of the size of the desired image is different than the aspect ratio calculated from scale arguments, we use the aspectCrop() method from the center of the image
			return aspectCrop(arguments.image,arguments.width,arguments.height,"center");			
		}
	}

	// ===================== START: Logical Methods ===========================
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
}

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
component displayname="Utility - File Service" persistent="false" accessors="true" extends="BaseService" output="false" hint="This is a utility component which handles common file operations" {
	property name="utilityTagService" type="any"; 
	
	public string function filterFilename(required string filename) {
		// Lower Case The Filename
		arguments.filename = lcase(trim(arguments.filename));
		
		// Remove anything that isn't alphanumeric
		arguments.filename = reReplace(arguments.filename, "[^a-z|0-9| ]", "", "all");
		
		// Remove any spaces that are multiples to a single spaces
		arguments.filename = reReplace(arguments.filename, "[ ]{1,} ", " ", "all");
		
		// Replace any spaces with a dash
		arguments.filename = replace(arguments.filename, " ", "-", "all");
		
		return arguments.filename;
	}

	public void function duplicateDirectory(required string source, required string destination, boolean overwrite=false, boolean recurse=true, string copyContentExclusionList='', boolean deleteDestinationContent=false, string deleteDestinationContentExclusionList="" ){
		arguments.source = replace(arguments.source,"\","/","all");
		arguments.destination = replace(arguments.destination,"\","/","all");
		
		// set baseSourceDir so it's persisted through recursion
		if(isNull(arguments.baseSourceDir)){
			arguments.baseSourceDir = arguments.source;
		}
		
		// set baseDestinationDir so it's persisted through recursion, baseDestinationDir is passed in recursion so, this will run only once
		if(isNull(arguments.baseDestinationDir)){
			arguments.baseDestinationDir = arguments.destination;
			// Loop through destination and delete the files and folder if needed
			if(arguments.deleteDestinationContent){
				var destinationDirList = directoryList(arguments.destination,false,"query");
				for(var i = 1; i <= destinationDirList.recordCount; i++){
					if(destinationDirList.type[i] == "Dir"){
						// get the current directory without the base path
						var currentDir = replacenocase(replacenocase(destinationDirList.directory[i],'\','/','all'),arguments.baseDestinationDir,'') & "/" & destinationDirList.name[i];
						// if the directory exists and not part of exclusion the delete
						if(directoryExists("#arguments.destination##currentDir#") && findNoCase(currentDir,arguments.deleteDestinationContentExclusionList) EQ 0){
							try {
								directoryDelete("#arguments.destination##currentDir#",true);	
							} catch(any e) {
								writeLog(file="Slatwall", text="Could not delete the directory: #arguments.destination##currentDir# most likely because it is in use by the file system");
							}
						}
					} else if(destinationDirList.type[i] == "File") {
						// get the current file path without the base path
						var currentFile = replacenocase(replacenocase(destinationDirList.directory[i],'\','/','all'),arguments.baseDestinationDir,'') & "/" & destinationDirList.name[i];
						// if the file exists and not part of exclusion the delete
						if(fileExists("#arguments.destination##currentFile#") && findNoCase(currentFile,arguments.deleteDestinationContentExclusionList) EQ 0){
							try {
								fileDelete("#arguments.destination##currentFile#");	
							} catch(any e) {
								writeLog(file="Slatwall", text="Could not delete file: #arguments.destination##currentFile# most likely because it is in use by the file system");
							}
						}
					}
				}
			}
		}
		
		var dirList = directoryList(arguments.source,false,"query");
		for(var i = 1; i <= dirList.recordCount; i++){
			if(dirList.type[i] == "File" && !listFindNoCase(arguments.copyContentExclusionList,dirList.name[i])){
				var copyFrom = "#replace(dirList.directory[i],'\','/','all')#/#dirList.name[i]#";
				var copyTo = "#arguments.destination##replacenocase(replacenocase(dirList.directory[i],'\','/','all'),arguments.baseSourceDir,'')#/#dirList.name[i]#";
				copyFile(copyFrom,copyTo,arguments.overwrite);
			} else if(dirList.type[i] == "Dir" && arguments.recurse && !listFindNoCase(arguments.copyContentExclusionList,dirList.name[i])){
				duplicateDirectory(source="#dirList.directory[i]#/#dirList.name[i]#", destination=arguments.destination, overwrite=arguments.overwrite, recurse=arguments.recurse, copyContentExclusionList=arguments.copyContentExclusionList, deleteDestinationContent=arguments.deleteDestinationContent, deleteDestinationContentExclusionList=arguments.deleteDestinationContentExclusionList, baseSourceDir=arguments.baseSourceDir, baseDestinationDir=arguments.baseDestinationDir);
			}
		}
		
		// set the file permission in linux
		if(!findNoCase(server.os.name,"Windows")){
			fileSetAccessMode(arguments.destination, "775");
		}
	}
	
	private void function copyFile(required string source, required string destination, boolean overwrite=false){
		var destinationDir = getdirectoryFromPath(arguments.destination);
		//create directory
		if(!directoryExists(destinationDir)){
			directoryCreate(destinationDir);
		}
		//copy file if it doens't exist in destination
		if(arguments.overwrite || !fileExists(arguments.destination)) {
			fileCopy(arguments.source,arguments.destination);
		}
	}
	
	// helper method for downloading a file
	public void function downloadFile(required string fileName, required string filePath, string contentType = 'application/unknown', boolean deleteFile = false) {
		getUtilityTagService().cfheader(name="Content-Disposition", value="inline; filename=#arguments.fileName#"); 
		getUtilityTagService().cfcontent(type="#arguments.contentType#", file="#arguments.filePath#", deletefile="#arguments.deleteFile#");
	}
	
}

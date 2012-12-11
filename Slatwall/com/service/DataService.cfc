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
component displayname="Data Service" extends="BaseService" {
	
	public string function createUniqueURLTitle(required string titleString, required string tableName) {
		
		var addon = 1;
		
		var urlTitle = reReplace(lcase(trim(arguments.titleString)), "[^a-z0-9 \-]", "", "all");
		urlTitle = reReplace(urlTitle, "[ ]+", "-", "all");
		
		var returnTitle = urlTitle;
		
		var unique = getDAO().verifyUniqueTableValue(tableName=arguments.tableName, column="urlTitle", value=returnTitle);
		
		while(!unique) {
			addon++;
			returnTitle = "#urlTitle#-#addon#";
			unique = getDAO().verifyUniqueTableValue(tableName=arguments.tableName, column="urlTitle", value=returnTitle);
		}
		
		return returnTitle;
	}
	
	public boolean function loadDataFromXMLDirectory(required string xmlDirectory) {
		var dirList = directoryList(arguments.xmlDirectory);
				
		// Because some records might depend on other records already being in the DB (fk constraints) we catch errors and re-loop over records
		var retryCount=0;
		var runPopulation = true;
		
		do{
			// Set to false so that it will only rerun if an error occurs
			runPopulation = false;
			
			// Loop over files, read them, and send to loadData function 
			for(var i=1; i<= arrayLen(dirList); i++) {
				if(listLast(dirList[i],".") == "xml"){
					var xmlRaw = FileRead(dirList[i]);
					
					try{
						loadDataFromXMLRaw(xmlRaw);
					} catch (any e) {
						// If we haven't retried 3 times, then incriment the retry counter and re-run the population
						if(retryCount <= 3) {
							retryCount += 1;
							runPopulation = true;
						} else {
							throw(e);
						}
					}
										
				}
			}	
		} while (runPopulation);
		
		return true;
	}
	
	public void function loadDataFromXMLRaw(required string xmlRaw) {
		var xmlRawEscaped = replace(xmlRaw,"&","&amp;","all");
		var xmlData = xmlParse(xmlRawEscaped);
		var columns = {};
		var idColumns = "";
		
		// Loop over each column to parse xml
		for(var ii=1; ii<= arrayLen(xmlData.Table.Columns.xmlChildren); ii++) {
			columns[  xmlData.Table.Columns.xmlChildren[ii].xmlAttributes.name ] = xmlData.Table.Columns.xmlChildren[ii].xmlAttributes;
			if(structKeyExists(xmlData.Table.Columns.xmlChildren[ii].xmlAttributes, "fieldType") && xmlData.Table.Columns.xmlChildren[ii].xmlAttributes.fieldtype == "id") {
				idColumns = listAppend(idColumns, xmlData.Table.Columns.xmlChildren[ii].xmlAttributes.name);
			}
		}

		// Loop over each record to insert or update
		for(var r=1; r <= arrayLen(xmlData.Table.Records.xmlChildren); r++) {
			
			var updateData = {};
			var insertData = {};
			
			for(var rp = 1; rp <= listLen(structKeyList(xmlData.Table.Records.xmlChildren[r].xmlAttributes)); rp ++) {
				
				var thisColumnName = listGetAt(structKeyList(xmlData.Table.Records.xmlChildren[r].xmlAttributes), rp);
				
				// Create the column data details
				var columnRecord = {
					value = xmlData.Table.Records.xmlChildren[r].xmlAttributes[ thisColumnName ],
					dataType = 'varchar'
				};
				
				// Check for a custom dataType for this column
				if(structKeyExists(columns[ thisColumnName ], 'dataType')) {
					columnRecord.dataType = columns[ thisColumnName ].dataType;
				}
				
				// Add this column record to the insert
				insertData[ thisColumnName ] = columnRecord;
				
				// Check to see if this column either has no update attribute, or it is set to true
				if(!structKeyExists(columns[ thisColumnName ], 'update') || columns[ thisColumnName ].update == true) {
					updateData[ thisColumnName ] = columnRecord;
				}
			}
			getDAO().recordUpdate(xmlData.table.xmlAttributes.tableName, idColumns, updateData, insertData);
		}
	}
	
	public boolean function isUniqueProperty( required string propertyName, required any entity ) {
		return getDAO().isUniqueProperty(argumentcollection=arguments);
	}
	
	public any function toBundle(required any bundle, required string tableList) {
		getDAO().toBundle(argumentcollection=arguments);
	}
	
	public any function fromBundle(required any bundle, required string tableList) {
		getDAO().toBundle(argumentcollection=arguments);
	}
	
	public any function updateRecordSortOrder(required string recordIDColumn, required string recordID, required string tableName, required numeric newSortOrder) {
		getDAO().updateRecordSortOrder(argumentcollection=arguments);
	}
	
	public any function getTableTopSortOrder(required string tableName, string contextIDColumn, string contextIDValue) {
		return getDAO().getTableTopSortOrder(argumentcollection=arguments);
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
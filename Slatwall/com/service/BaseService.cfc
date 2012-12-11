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
component displayname="Base Service" persistent="false" accessors="true" output="false" extends="Slatwall.com.utility.BaseObject" hint="This is a base service that all services will extend" {

	property name="DAO" type="any";
	property name="utilityFileService" type="any";
	
	public any function init() {
		return super.init();
	}
	
	public any function get(required string entityName, required any idOrFilter, boolean isReturnNewOnNotFound = false ) {
		return getDAO().get(argumentcollection=arguments);
	}

	public any function list(required string entityName, struct filterCriteria = {}, string sortOrder = '', struct options = {} ) {
		return getDAO().list(argumentcollection=arguments);
	}

	public any function new(required string entityName ) {
		return getDAO().new(argumentcollection=arguments);
	}

	public any function count(required string entityName ) {
		return getDAO().count(argumentcollection=arguments);
	}

	public any function getSmartList(string entityName, struct data={}){
		var smartList = getDAO().getSmartList(argumentcollection=arguments);
		
		if(structKeyExists(arguments.data, "keyword") || structKeyExists(arguments.data, "keywords")) {
			var example = this.new(arguments.entityName);
			smartList.addKeywordProperty(propertyIdentifier=example.getSimpleRepresentationPropertyName(), weight=1);
		}
		
		return smartList;
	}
	
	public boolean function delete(required any entity){
		
		// If the entity Passes validation
		if(arguments.entity.isDeletable()) {
			
			// Remove any Many-to-Many relationships
			arguments.entity.removeAllManyToManyRelationships();
			
			getService("settingService").removeAllEntityRelatedSettings( entity=arguments.entity );
			
			// Call delete in the DAO
			getDAO().delete(target=arguments.entity);
			
			// Return that the delete was sucessful
			return true;
			
		}
			
		// Setup ormHasErrors because it didn't pass validation
		getSlatwallScope().setORMHasErrors( true );

		return false;
	}
	
	
	// @hint the default save method will populate, validate, and if not errors delegate to the DAO where entitySave() is called.
    public any function save(required any entity, struct data, string context="save") {
    	
    	if(!isObject(arguments.entity) || !arguments.entity.isPersistent()) {
    		throw("The entity being passed to this service is not a persistent entity. READ THIS!!!! -> Make sure that you aren't calling the oMM method with named arguments. Also, make sure to check the spelling of your 'fieldname' attributes.");
    	}
    	
		// If data was passed in to this method then populate it with the new data
        if(structKeyExists(arguments,"data")){
        	
        	// Populate this object
			arguments.entity.populate(argumentCollection=arguments);

		    // Validate this object now that it has been populated
		    arguments.entity.validate(context=arguments.entity.getValidationContext( arguments.context ));
        }
        
        // If the object passed validation then call save in the DAO, otherwise set the errors flag
        if(!arguments.entity.hasErrors()) {
            arguments.entity = getDAO().save(target=arguments.entity);
        } else {
            getSlatwallScope().setORMHasErrors( true );
        }

        // Return the entity
        return arguments.entity;
    }
    
	/**
	* exports the given query/array to file.
	* 
	* @param data      Data to export. (Required) (Currently only supports query).
	* @param columns      list of columns to export. (optional, default: all)
	* @param columnNames      list of column headers to export. (optional, default: none)
	* @param fileName      file name for export. (default: uuid)
	* @param fileType      file type for export. (default: csv)
	*/
	public void function export(required any data, string columns, string columnNames, string fileName, string fileType = 'csv') {
		if(!structKeyExists(arguments,"fileName")){
			arguments.fileName = createUUID() ;
		}
		var fileNameWithExt = arguments.fileName & "." & arguments.fileType ;
		var filePath = getSlatwallVFSRootDirectory() & "/" & fileNameWithExt ;
		if(isQuery(data) && !structKeyExists(arguments,"columns")){
			arguments.columns = arguments.data.columnList;
		}
		if(structKeyExists(arguments,"columns") && !structKeyExists(arguments,"columnNames")){
			arguments.columnNames = arguments.columns;
		}
		var columnArray = listToArray(arguments.columns);
		var columnCount = arrayLen(columnArray);
		
		if(arguments.fileType == 'csv'){
			var dataArray=[arguments.columnNames];
			for(var i=1; i <= data.recordcount; i++){
				var row = [];
				for(var j=1; j <= columnCount; j++){
					arrayAppend(row,'"#data[columnArray[j]][i]#"');
				}
				arrayAppend(dataArray,arrayToList(row));
			}
			var outputData = arrayToList(dataArray,"#chr(13)##chr(10)#");
			fileWrite(filePath,outputData);
		} else {
			throw("Implement export for fileType #arguments.fileType#");
		}

		// Open / Download File
		getUtilityFileService().downloadFile(fileNameWithExt,filePath,"application/#arguments.fileType#",true);
	}
		
		    
 	/**
	 * Generic ORM CRUD methods and dynamic methods by convention via onMissingMethod.
	 *
	 * See all onMissing* method comments and other method signatures for usage.
	 *
	 * CREDIT:
	 *   Heavily influenced by ColdSpring 2.0-pre-alpha's coldspring.orm.hibernate.AbstractGateway.
 	 *   So, thank you Mark Mandel and Bob Silverberg :)
	 *
	 * Provides dynamic methods, by convention, on missing method:
	 *
	 *   newXXX()
	 *
	 *   countXXX()
	 *
	 *   saveXXX( required any xxxEntity )
	 *
	 *   deleteXXX( required any xxxEntity )
	 *
	 *   getXXX( required any ID, boolean isReturnNewOnNotFound = false )
	 *
	 *   getXXXByYYY( required any yyyFilterValue, boolean isReturnNewOnNotFound = false )
	 *
	 *   getXXXByYYYANDZZZ( required array [yyyFilterValue,zzzFilterValue], boolean isReturnNewOnNotFound = false )
	 *		AND here is case sensetive to avoid matching in property name i.e brAND
	 *
	 *   listXXX( struct filterCriteria, string sortOrder, struct options )
	 *
	 *   listXXXFilterByYYY( required any yyyFilterValue, string sortOrder, struct options )
	 *
	 *   listXXXOrderByZZZ( struct filterCriteria, struct options )
	 *
	 *   listXXXFilterByYYYOrderByZZZ( required any yyyFilterValue, struct options )
	 *
	 * ...in which XXX is an ORM entity name, and YYY and ZZZ are entity property names.
	 *
	 *	 exportXXX()
	 *
	 * NOTE: Ordered arguments only--named arguments not supported.
	*/
	public any function onMissingMethod( required string missingMethodName, required struct missingMethodArguments ) {
		var lCaseMissingMethodName = lCase( missingMethodName );

		if ( lCaseMissingMethodName.startsWith( 'get' ) ) {
			if(right(lCaseMissingMethodName,9) == "smartlist") {
				return onMissingGetSmartListMethod( missingMethodName, missingMethodArguments );
			} else {
				return onMissingGetMethod( missingMethodName, missingMethodArguments );
			}
		} else if ( lCaseMissingMethodName.startsWith( 'new' ) ) {
			return onMissingNewMethod( missingMethodName, missingMethodArguments );
		} else if ( lCaseMissingMethodName.startsWith( 'list' ) ) {
			return onMissingListMethod( missingMethodName, missingMethodArguments );
		} else if ( lCaseMissingMethodName.startsWith( 'save' ) ) {
			return onMissingSaveMethod( missingMethodName, missingMethodArguments );
		} else if ( lCaseMissingMethodName.startsWith( 'delete' ) )	{
			return onMissingDeleteMethod( missingMethodName, missingMethodArguments );
		} else if ( lCaseMissingMethodName.startsWith( 'count' ) ) {
			return onMissingCountMethod( missingMethodName, missingMethodArguments );
		} else if ( lCaseMissingMethodName.startsWith( 'export' ) ) {
			return onMissingExportMethod( missingMethodName, missingMethodArguments );
		}

		throw( 'No matching method for #missingMethodName#().' );
	}
	


	/********** PRIVATE ************************************************************/
	private function onMissingDeleteMethod( required string missingMethodName, required struct missingMethodArguments ) {
		return delete( missingMethodArguments[ 1 ] );
	}


	/**
	 * Provides dynamic get methods, by convention, on missing method:
	 *
	 *   getXXX( required any ID, boolean isReturnNewOnNotFound = false )
	 *
	 *   getXXXByYYY( required any yyyFilterValue, boolean isReturnNewOnNotFound = false )
	 *
	 *   getXXXByYYYAndZZZ( required array [yyyFilterValue,zzzFilterValue], boolean isReturnNewOnNotFound = false )
	 *		AND here is case sensetive to avoid matching in property name i.e brAND
	 *
	 * ...in which XXX is an ORM entity name, and YYY is an entity property name.
	 *
	 * NOTE: Ordered arguments only--named arguments not supported.
	 */
	private function onMissingGetMethod( required string missingMethodName, required struct missingMethodArguments ){
		var isReturnNewOnNotFound = structKeyExists( missingMethodArguments, '2' ) ? missingMethodArguments[ 2 ] : false;

		var entityName = missingMethodName.substring( 3 );

		if ( entityName.matches( '(?i).+by.+' ) ) {
			var tokens = entityName.split( '(?i)by', 2 );
			entityName = tokens[ 1 ];
			if( tokens[ 2 ].matches( '.+AND.+' ) ) {
				tokens = tokens[ 2 ].split( 'AND' );
				var filter = {};
				for(var i = 1; i <= arrayLen(tokens); i++) {
					filter[ tokens[ i ] ] = missingMethodArguments[ 1 ][ i ];
				}
				return get( entityName, filter, isReturnNewOnNotFound );
			} else {
				var filter = { '#tokens[ 2 ]#' = missingMethodArguments[ 1 ] };
				return get( entityName, filter, isReturnNewOnNotFound );
			}
		} else {
			var id = missingMethodArguments[ 1 ];
			return get( entityName, id, isReturnNewOnNotFound );
		}
	}

	/**
	 * Provides dynamic getSmarList method, by convention, on missing method:
	 *
	 *   getXXXSmartList( struct data )
	 *
	 * ...in which XXX is an ORM entity name
	 *
	 * NOTE: Ordered arguments only--named arguments not supported.
	 */
	 
	private function onMissingGetSmartListMethod( required string missingMethodName, required struct missingMethodArguments ){
		var smartListArgs = {};
		var entityNameLength = len(arguments.missingMethodName) - 12;
		
		var entityName = missingMethodName.substring( 3,entityNameLength + 3 );
		var data = {};
		if( structCount(missingMethodArguments) && !isNull(missingMethodArguments[ 1 ]) && isStruct(missingMethodArguments[ 1 ]) ) {
			data = missingMethodArguments[ 1 ];
		}
		
		return getSmartList(entityName=entityName, data=data);
	} 
	 

	/**
	 * Provides dynamic list methods, by convention, on missing method:
	 *
	 *   listXXX( struct filterCriteria, string sortOrder, struct options )
	 *
	 *   listXXXFilterByYYY( required any yyyFilterValue, string sortOrder, struct options )
	 *
	 *   listXXXOrderByZZZ( struct filterCriteria, struct options )
	 *
	 *   listXXXFilterByYYYOrderByZZZ( required any yyyFilterValue, struct options )
	 *
	 * ...in which XXX is an ORM entity name, and YYY and ZZZ are entity property names.
	 *
	 * NOTE: Ordered arguments only--named arguments not supported.
	 */
	private function onMissingListMethod( required string missingMethodName, required struct missingMethodArguments ){
		var listMethodForm = 'listXXX';

		if ( findNoCase( 'FilterBy', missingMethodName ) ) {
			listMethodForm &= 'FilterByYYY';
		}

		if ( findNoCase( 'OrderBy', missingMethodName ) ) {
			listMethodForm &= 'OrderByZZZ';
		}

		switch( listMethodForm ) {
			case 'listXXX':
				return onMissingListXXXMethod( missingMethodName, missingMethodArguments );

			case 'listXXXFilterByYYY':
				return onMissingListXXXFilterByYYYMethod( missingMethodName, missingMethodArguments );

			case 'listXXXOrderByZZZ':
				return onMissingListXXXOrderByZZZMethod( missingMethodName, missingMethodArguments );

			case 'listXXXFilterByYYYOrderByZZZ':
				return onMissingListXXXFilterByYYYOrderByZZZMethod( missingMethodName, missingMethodArguments );
		}
	}


	/**
	 * Provides dynamic list method, by convention, on missing method:
	 *
	 *   listXXX( struct filterCriteria, string sortOrder, struct options )
	 *
	 * ...in which XXX is an ORM entity name.
	 *
	 * NOTE: Ordered arguments only--named arguments not supported.
	 */
	private function onMissingListXXXMethod( required string missingMethodName, required struct missingMethodArguments ) {
		var listArgs = {};

		listArgs.entityName = missingMethodName.substring( 4 );
		
		if ( structKeyExists( missingMethodArguments, '1' ) ) {
			listArgs.filterCriteria = missingMethodArguments[ '1' ];

			if ( structKeyExists( missingMethodArguments, '2' ) ) {
				listArgs.sortOrder = missingMethodArguments[ '2' ];

				if ( structKeyExists( missingMethodArguments, '3' ) ) {
					listArgs.options = missingMethodArguments[ '3' ];
				}
			}
		}

		return list( argumentCollection = listArgs );
	}


	/**
	 * Provides dynamic list method, by convention, on missing method:
	 *
	 *   listXXXFilterByYYY( required any yyyFilterValue, string sortOrder, struct options )
	 *
	 * ...in which XXX is an ORM entity name, and YYY is an entity property name.
	 *
	 * NOTE: Ordered arguments only--named arguments not supported.
	 */
	private function onMissingListXXXFilterByYYYMethod( required string missingMethodName, required struct missingMethodArguments )
	{
		var listArgs = {};

		var temp = missingMethodName.substring( 4 );

		var tokens = temp.split( '(?i)FilterBy', 2 );

		listArgs.entityName = tokens[ 1 ];

		listArgs.filterCriteria = { '#tokens[ 2 ]#' = missingMethodArguments[ 1 ] };

		if ( structKeyExists( missingMethodArguments, '2' ) )
		{
			listArgs.sortOrder = missingMethodArguments[ '2' ];

			if ( structKeyExists( missingMethodArguments, '3' ) )
			{
				listArgs.options = missingMethodArguments[ '3' ];
			}
		}

		return list( argumentCollection = listArgs );
	}


	/**
	 * Provides dynamic list method, by convention, on missing method:
	 *
	 *   listXXXFilterByYYYOrderByZZZ( required any yyyFilterValue, struct options )
	 *
	 * ...in which XXX is an ORM entity name, and YYY and ZZZ are entity property names.
	 *
	 * NOTE: Ordered arguments only--named arguments not supported.
	 */
	private function onMissingListXXXFilterByYYYOrderByZZZMethod( required string missingMethodName, required struct missingMethodArguments )
	{
		var listArgs = {};

		var temp = missingMethodName.substring( 4 );

		var tokens = temp.split( '(?i)FilterBy', 2 );

		listArgs.entityName = tokens[ 1 ];

		tokens = tokens[ 2 ].split( '(?i)OrderBy', 2 );

		listArgs.filterCriteria = { '#tokens[ 1 ]#' = missingMethodArguments[ 1 ] };

		listArgs.sortOrder = tokens[ 2 ];

		if ( structKeyExists( missingMethodArguments, '2' ) )
		{
			listArgs.options = missingMethodArguments[ '2' ];
		}

		return list( argumentCollection = listArgs );
	}


	/**
	 * Provides dynamic list method, by convention, on missing method:
	 *
	 *   listXXXOrderByZZZ( struct filterCriteria, struct options )
	 *
	 * ...in which XXX is an ORM entity name, and ZZZ is an entity property name.
	 *
	 * NOTE: Ordered arguments only--named arguments not supported.
	 */
	private function onMissingListXXXOrderByZZZMethod( required string missingMethodName, required struct missingMethodArguments )
	{
		var listArgs = {};

		var temp = missingMethodName.substring( 4 );

		var tokens = temp.split( '(?i)OrderBy', 2 );

		listArgs.entityName = tokens[ 1 ];

		listArgs.sortOrder = tokens[ 2 ];

		if ( structKeyExists( missingMethodArguments, '1' ) )
		{
			listArgs.filterCriteria = missingMethodArguments[ '1' ];

			if ( structKeyExists( missingMethodArguments, '2' ) )
			{
				listArgs.options = missingMethodArguments[ '2' ];
			}
		}

		return list( argumentCollection = listArgs );
	}


	/**
	 * Provides dynamic count methods, by convention, on missing method:
	 *
	 *   countXXX()
	 *
	 * ...in which XXX is an ORM entity name.
	 */
	private function onMissingCountMethod( required string missingMethodName, required struct missingMethodArguments ){
		var entityName = missingMethodName.substring( 5 );

		return count( entityName );
	}


	private function onMissingNewMethod( required string missingMethodName, required struct missingMethodArguments )
	{
		var entityName = missingMethodName.substring( 3 );

		return new( entityName );
	}


	private function onMissingSaveMethod( required string missingMethodName, required struct missingMethodArguments ) {
		if ( structKeyExists( missingMethodArguments, '2' ) ) {
			return save( entity=missingMethodArguments[1], data=missingMethodArguments[2]);
		} else {
			return save( entity=missingMethodArguments[1] );
		}
	}
	
	/**
	 * Provides dynamic export methods, by convention, on missing method:
	 *
	 *   exportXXX()
	 *
	 * ...in which XXX is an ORM entity name.
	 */
	private function onMissingExportMethod( required string missingMethodName, required struct missingMethodArguments ){
		var entityName = missingMethodName.substring( 6 );
		var exportQry = getDAO().getExportQuery(entityName = entityName);
		
		export(data=exportQry);
	}

}

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

	property name="entityServiceMapping" type="struct";

	// @hint returns the correct service on a given entityName.  This is very useful for creating abstract code
	public any function getServiceByEntityName( required string entityName ) {
		
		// This removes the Slatwall Prefix to the entityName when needed.
		if(left(arguments.entityName, 8) == "Slatwall") {
			arguments.entityName = right(arguments.entityName, len(arguments.entityName) - 8);
		}
		
		if(structKeyExists(getEntityServiceMapping(), arguments.entityName)) {
			return getService( getEntityServiceMapping()[ arguments.entityName ] );
		}
		
		throw("You have requested the service for the entity of '#arguments.entityName#' and that entity was not defined in the coldspring config.xml so please add it, and the appropriate service it should use.")
	}
	
	// @hint returns the primary id property name of a given entityName
	public string function getPrimaryIDPropertyNameByEntityName( required string entityName ) {
		
		arguments.entityName = getProperlyCasedFullEntityName ( arguments.entityName );
		
		var idColumnNames = getIdentifierColumnNamesByEntityName( arguments.entityName );
		
		if( arrayLen(idColumnNames) == 1) {
			return idColumnNames[1];
		} else {
			throw("There is not a single primary ID property for the entity: #arguments.entityName#");
		}
	}
	
	// @hint returns an array of ID columns based on the entityName
	public array function getIdentifierColumnNamesByEntityName( required string entityName ) {
		
		arguments.entityName = getProperlyCasedFullEntityName ( arguments.entityName );
		
		if( !listFindNoCase("SlatwallSetting,SlatwallContent,SlatwallCategory", arguments.entityName)) {
			getProperlyCasedFullEntityName( arguments.entityName );
		}
		
		var returnVal = ormGetSessionFactory().getClassMetadata( arguments.entityName ).getIdentifierColumnNames();
		
		return returnVal;
		
	}
	
	public string function getProperlyCasedFullEntityName( required string entityName ) {
		var shortEntityName = arguments.entityName;
		
		if(left(shortEntityName, 8) == "Slatwall") {
			shortEntityName = right(shortEntityName, len(shortEntityName)-8);
		}
		
		if( structKeyExists(getEntityServiceMapping(), shortEntityName) ) {
			var keyList = StructKeyList(getEntityServiceMapping());
			var keyIndex = listFindNoCase(keyList, shortEntityName);
			return "Slatwall#listGetAt(keyList, keyIndex)#";
		}
		
		throw("The entity name that you have requested: #arguments.entityname# is not in the ORM Library of entity names that is setup in coldsrping.  Please add #shortEntityName# to the list of entity mappings in coldspring.");
	}

}

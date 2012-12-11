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
component output="false" accessors="true" extends="Slatwall.com.utility.BaseObject" {
	
	public any function init() {
		return this;
	}
	
	public any function get( required string entityName, required any idOrFilter, boolean isReturnNewOnNotFound = false ) {
		// Adds the Slatwall Prefix to the entityName when needed.
		if(left(arguments.entityName,8) != "Slatwall") {
			arguments.entityName = "Slatwall#arguments.entityName#";
		}
		
		if ( isSimpleValue( idOrFilter ) && len( idOrFilter ) && idOrFilter != 0 ) {
			var entity = entityLoadByPK( entityName, idOrFilter );
		} else if ( isStruct( idOrFilter ) ){
			var entity = entityLoad( entityName, idOrFilter, true );
		}
		
		if ( !isNull( entity ) ) {
			entity.updateCalculatedProperties();
			return entity;
		}

		if ( isReturnNewOnNotFound ) {
			return new( entityName );
		}
	}

	public any function list( string entityName, struct filterCriteria = {}, string sortOrder = '', struct options = {} ) {
		// Adds the Slatwall Prefix to the entityName when needed.
		if(left(arguments.entityName,8) != "Slatwall") {
			arguments.entityName = "Slatwall#arguments.entityName#";
		}
		
		return entityLoad( entityName, filterCriteria, sortOrder, options );
	}


	public any function new( required string entityName ) {
		// Adds the Slatwall Prefix to the entityName when needed.
		if(left(arguments.entityName,8) != "Slatwall") {
			arguments.entityName = "Slatwall#arguments.entityName#";
		}
		
		return entityNew( entityName );
	}


	public any function save( required target ) {
		entitySave( target );
		return target;
	}
	
	public void function delete(required target) {
		if(isArray(target)) {
			for(var object in target) {
				delete(object);
			}
		} else {
			entityDelete(target);	
		}
	}
	
	public any function count(required any entityName) {
		// Adds the Slatwall Prefix to the entityName when needed.
		if(left(arguments.entityName,8) != "Slatwall") {
			arguments.entityName = "Slatwall#arguments.entityName#";
		}
		return ormExecuteQuery("SELECT count(*) FROM #arguments.entityName#",true);
	}
	
	public void function reloadEntity(required any entity) {
    	entityReload(arguments.entity);
    }
    
    public void function flushORMSession() {
    	ormFlush();	
    	// flush again to persist any changes done during ORM Event handler
		ormFlush();	
    }
    
    public void function clearORMSession() {
    	ormClearSession();
    }
    
    public any function getSmartList(required string entityName, struct data={}){
		// Adds the Slatwall Prefix to the entityName when needed.
		if(left(arguments.entityName,8) != "Slatwall") {
			arguments.entityName = "Slatwall#arguments.entityName#";
		}
		
		var smartList = new Slatwall.com.utility.SmartList(argumentCollection=arguments);

		return smartList;
	}
	
	public any function getExportQuery(required string entityName) {
		var qry = new query();
		qry.setName("exportQry");
		var result = qry.execute(sql="SELECT * FROM Slatwall#arguments.entityName#"); 
    	exportQry = result.getResult(); 
		return exportQry;
	}
	
	
	
	// ===================== START: Private Helper Methods ===========================
	
	// =====================  END: Private Helper Methods ============================
	
	
}

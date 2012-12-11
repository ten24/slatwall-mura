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
component extends="BaseService" accessors="true" output="false" {

	// Injected via Coldspring
	property name="accountService" type="any";
	property name="integrationService" type="any";

	// Properties used for Caching values in the application scope
	property name="permissions" type="struct";
	
	// Uses the current mura user to check security against a given action
	public boolean function secureDisplay(required string action, any account) {
		if(!structKeyExists(arguments, "account")) {
			arguments.account = getSlatwallScope().getCurrentAccount();
		}
		
		// Check if the user is a super admin, if true no need to worry about security
		if( findNoCase("*", arguments.account.getAllPermissions()) ) {
			return true;
		}
		
		var subsystemName = listFirst( arguments.action, ":" );
		var sectionName = listFirst( listLast(arguments.action, ":"), "." );
		var itemName = listLast( arguments.action, "." );
		
		//check if the page is public, if public no need to worry about security
		if(listFindNocase(getPermissions()[ subsystemName ][ sectionName ].publicMethods, itemName)){
			return true;
		}	
		
		// Look for the anyAdmin methods next to see if this is an anyAdmin method, and this user is some type of admin
		if(listFindNocase(getPermissions()[ subsystemName ][ sectionName ].anyAdminMethods, itemName) && len(arguments.account.getAllPermissions())) {
			return true;
		}
		
		// Check if the acount has access to a secure method
		if( listFindNoCase(arguments.account.getAllPermissions(), replace(replace(arguments.action, ".", "", "all"), ":", "", "all")) ) {
			return true;
		}
		
		// If this is a save method, then we can check create and edit
		if(left(listLast(arguments.action, "."),4) eq "save") {
			var createAction = replace(arguments.action, '.save', '.create');
			var editAction = replace(arguments.action, '.save', '.edit');
			if( listFindNoCase(arguments.account.getAllPermissions(), replace(replace(createAction, ".", "", "all"), ":", "", "all")) ) {
				return true;
			}
			if( listFindNoCase(arguments.account.getAllPermissions(), replace(replace(editAction, ".", "", "all"), ":", "", "all")) ) {
				return true;
			}
		}
		
		return false;
	}
	
	public void function clearPermissionCache(){
		if(structKeyExists(variables, "permissions")) {
			structDelete(variables, "permissions");
		}
	}
	
	public struct function getPermissions(){
		if(!structKeyExists(variables, "permissions")){
			var allPermissions={
				admin={}
			};
			
			// Setup Admin Permissions
			var adminDirectoryList = directoryList( expandPath("/Slatwall/admin/controllers"), false, "path", "*.cfc" );
			for(var i=1; i <= arrayLen(adminDirectoryList); i++){
				
				var section = listFirst(listLast(adminDirectoryList[i],"/\"),".");
				var obj = createObject('component','Slatwall.admin.controllers.' & section);
				
				allPermissions.admin[ section ] = {
					publicMethods = "",
					anyAdminMethods = "",
					secureMethods = "",
					securePermissionOptions = []
				};
				
				if(structKeyExists(obj, 'publicMethods')){
					allPermissions.admin[ section ].publicMethods = obj.publicMethods;
				}
				if(structKeyExists(obj, 'anyAdminMethods')){
					allPermissions.admin[ section ].anyAdminMethods = obj.anyAdminMethods;
				}
				if(structKeyExists(obj, 'secureMethods')){	
					allPermissions.admin[ section ].secureMethods = obj.secureMethods;
					
					for(j=1; j <= listLen(allPermissions.admin[ section ].secureMethods); j++){
						
						var item = listGetAt(allPermissions.admin[ section ].secureMethods, j);
						
						if(left(item, 2) eq '**') {
							arrayAppend(allPermissions.admin[ section ].securePermissionOptions, {name=replace(rbKey( 'admin.define.list_permission'), '${itemEntityName}', rbKey('entity.#right(item, len(item)-2)#')), value="admin#section#list#item#"});
							arrayAppend(allPermissions.admin[ section ].securePermissionOptions, {name=replace(rbKey( 'admin.define.detail_permission'), '${itemEntityName}', rbKey('entity.#right(item, len(item)-2)#')), value="admin#section#detail#item#"});
							arrayAppend(allPermissions.admin[ section ].securePermissionOptions, {name=replace(rbKey( 'admin.define.create_permission'), '${itemEntityName}', rbKey('entity.#right(item, len(item)-2)#')), value="admin#section#create#item#"});
							arrayAppend(allPermissions.admin[ section ].securePermissionOptions, {name=replace(rbKey( 'admin.define.edit_permission'), '${itemEntityName}', rbKey('entity.#right(item, len(item)-2)#')), value="admin#section#edit#item#"});
							arrayAppend(allPermissions.admin[ section ].securePermissionOptions, {name=replace(rbKey( 'admin.define.delete_permission'), '${itemEntityName}', rbKey('entity.#right(item, len(item)-2)#')), value="admin#section#delete#item#"});
						} else if(left(item, 1) eq '*') {
							arrayAppend(allPermissions.admin[ section ].securePermissionOptions, {name=replace(rbKey( 'admin.define.detail_permission'), '${itemEntityName}', rbKey('entity.#right(item, len(item)-1)#')), value="admin#section#detail#item#"});
							arrayAppend(allPermissions.admin[ section ].securePermissionOptions, {name=replace(rbKey( 'admin.define.create_permission'), '${itemEntityName}', rbKey('entity.#right(item, len(item)-1)#')), value="admin#section#create#item#"});
							arrayAppend(allPermissions.admin[ section ].securePermissionOptions, {name=replace(rbKey( 'admin.define.edit_permission'), '${itemEntityName}', rbKey('entity.#right(item, len(item)-1)#')), value="admin#section#edit#item#"});
							arrayAppend(allPermissions.admin[ section ].securePermissionOptions, {name=replace(rbKey( 'admin.define.delete_permission'), '${itemEntityName}', rbKey('entity.#right(item, len(item)-1)#')), value="admin#section#delete#item#"});
						} else {
							
							var permissionTitle = rbKey( 'admin.#section#.#item#_permission' );
							
							if(right(permissionTitle, 8) eq "_missing") {
								if(left(item, 4) eq "list") {
									permissionTitle = replace(rbKey( 'admin.define.list_permission'), '${itemEntityName}', rbKey('entity.#right(item, len(item)-4)#'));
								} else if (left(item, 6) eq "detail") {
									permissionTitle = replace(rbKey( 'admin.define.detail_permission'), '${itemEntityName}', rbKey('entity.#right(item, len(item)-6)#'));
								} else if (left(item, 6) eq "create") {
									permissionTitle = replace(rbKey( 'admin.define.create_permission'), '${itemEntityName}', rbKey('entity.#right(item, len(item)-6)#'));
								} else if (left(item, 4) eq "edit") {
									permissionTitle = replace(rbKey( 'admin.define.edit_permission'), '${itemEntityName}', rbKey('entity.#right(item, len(item)-4)#'));
								} else if (left(item, 6) eq "delete") {
									permissionTitle = replace(rbKey( 'admin.define.delete_permission'), '${itemEntityName}', rbKey('entity.#right(item, len(item)-6)#'));
								} else if (left(item, 7) eq "process") {
									permissionTitle = replace(rbKey( 'admin.define.process_permission'), '${itemEntityName}', rbKey('entity.#right(item, len(item)-7)#'));
								}
							}
							
							arrayAppend(allPermissions.admin[ section ].securePermissionOptions, {name=permissionTitle, value="admin#section##item#"});
						}
					}
				}
			}
			
			// Setup Integration Permissions
			var activeFW1Integrations = getIntegrationService().getActiveFW1Subsystems();
			for(var i=1; i <= arrayLen(activeFW1Integrations); i++){
				
				allPermissions[ activeFW1Integrations[i].subsystem ] = {};
				
				var integrationDirectoryList = directoryList( expandPath("/Slatwall/integrationServices/#activeFW1Integrations[i].subsystem#/controllers"), false, "path", "*.cfc" );
				for(var j=1; j <= arrayLen(integrationDirectoryList); j++){
					
					var section = listFirst(listLast(integrationDirectoryList[j],"/\"),".");
					var obj = createObject('component','Slatwall.integrationServices.#activeFW1Integrations[i].subsystem#.controllers.#section#');
					
					allPermissions[ activeFW1Integrations[i].subsystem ][ section ] = {
						publicMethods = "",
						secureMethods = "",
						anyAdminMethods = "",
						securePermissionOptions = []
					};
					
					if(structKeyExists(obj, 'publicMethods')){
						allPermissions[ activeFW1Integrations[i].subsystem ][ section ].publicMethods = obj.publicMethods;
					}
					if(structKeyExists(obj, 'anyAdminMethods')){
						allPermissions[ activeFW1Integrations[i].subsystem ][ section ].anyAdminMethods = obj.anyAdminMethods;
					}
					if(structKeyExists(obj, 'secureMethods')){	
						allPermissions[ activeFW1Integrations[i].subsystem ][ section ].secureMethods = obj.secureMethods;
					
						for(k=1; k <= listLen(allPermissions[ activeFW1Integrations[i].subsystem ][ section ].secureMethods); k++){
							
							var item = listGetAt(allPermissions[ activeFW1Integrations[i].subsystem ][ section ].secureMethods, k);
							
							arrayAppend(allPermissions[ activeFW1Integrations[i].subsystem ][ section ].securePermissionOptions, {
								name=rbKey("#activeFW1Integrations[i].subsystem#.#section#.#item#_permission"),
								value="#activeFW1Integrations[i].subsystem##section##item#"
							});
						}
					}
					
				}
			}
			
			variables.permissions = allPermissions;
		}
		return variables.permissions;
	}
	
	public function setupDefaultPermissions(){
		logSlatwall("Default Permission Flush", true);
		
		// Flush the session so that the currentAccount is persisted
		getDAO().flushORMSession();
		
		var accounts = getDAO().getMissingUserAccounts();
		var permissionGroup = this.getPermissionGroup('4028808a37037dbf01370ed2001f0074');
		
		logSlatwall("There are #accounts.recordcount# super users that need to be setup with default permissions", true);
		for(i=1; i <= accounts.recordcount; i++){
			// Get the account
			account = getAccountService().getAccount( accounts.accountID[i] );
			
			// Set the permission group
			account.addPermissionGroup( permissionGroup );
			
			logSlatwall("Account Flush", true);
			
			// Flush the session
			getDAO().flushORMSession();
		}
		
	}
	
}
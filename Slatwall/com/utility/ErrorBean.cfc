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
component displayName="Error Bean" persistent="false" accessors="true" hint="Bean to manage validation errors" output="false" {

	// @hint stores any validation errors for the entity
	property name="errors" type="struct";

	// @hint Constructor for error bean. Initializes the error bean.
	public function init() {
		variables.errors = structNew();
		
		return this;
	}
	
	// @hint Adds a new error to the error structure.
	public void function addError(required string errorName, required string errorMessage) {
		if(!structKeyExists(variables.errors, arguments.errorName)) {
			variables.errors[arguments.errorName] = [];
		}
		arrayAppend(variables.errors[arguments.errorName], arguments.errorMessage);
	}
	
	// @hint Returns an array of error messages from the error structure.
	public array function getError(required string errorName) {
		if(hasError(errorName=arguments.errorName)){
			return variables.errors[arguments.name];
		}
		
		throw("The Error #arguments.errorName# doesn't Exist");
	}
	
	// @hint Returns true if the error exists within the error structure.
	public string function hasError(required string errorName) {
		return structKeyExists(variables.errors, arguments.errorName) ;
	}
	
	// @hint Returns true if there is at least one error.
	public boolean function hasErrors() {
		return !structIsEmpty(variables.errors) ;
	}
	
	
	
}


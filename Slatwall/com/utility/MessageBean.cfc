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
component displayName="Message Bean" persistent="false" accessors="true" hint="Bean to manage validation errors" output="false" {

	// @hint stores any validation errors for the entity
	property name="messages" type="struct";

	// @hint Constructor for error bean. Initializes the error bean.
	public function init() {
		variables.messages = structNew();
		return this;
	}
	
	// @hint Adds a new message to the messages structure.
	public void function addMessage(required string messageName, required string message) {
		if(!structKeyExists(variables.messages, arguments.messageName)) {
			variables.messages[arguments.messageName] = [];
		}
		arrayAppend(variables.messages[arguments.messageName], arguments.message);
	}
	
	// @hint Returns an array of error messages from the error structure.
	public array function getMessage(required string messageName) {
		if(hasMessage(messageName=arguments.messageName)){
			return variables.messages[arguments.messageName];
		}
		
		throw("The Message #arguments.messageName# doesn't Exist");
	}
	
	// @hint Returns true if the error exists within the error structure.
	public string function hasMessage(required string messageName) {
		return structKeyExists(variables.messages, arguments.messageName) ;
	}
	
	// @hint Returns true if there is at least one error.
	public boolean function hasMessages() {
		return !structIsEmpty(variables.messages) ;
	}
	
}
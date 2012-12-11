/*

    Slatwall - An e-commerce plugin for Mura CMS
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
component displayname="Email" entityname="SlatwallEmail" table="SlatwallEmail" persistent="true" accessors="true" extends="BaseEntity" {
	
	// Persistent Properties
	property name="emailID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="emailName" ormtype="string";
	property name="eventName" ormtype="string";
	
	// Related Object Properties (many-to-one)
	property name="emailTemplate" cfc="EmailTemplate" fieldtype="many-to-one" fkcolumn="emailTemplateID";
	
	// Related Object Properties (one-to-many)
	
	// Related Object Properties (many-to-many)
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties



	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================

	// Email Template (many-to-one)
	public void function setEmailTemplate(required any emailTemplate) {
		variables.emailTemplate = arguments.emailTemplate;
		if(isNew() or !arguments.emailTemplate.hasEmail( this )) {
			arrayAppend(arguments.emailTemplate.getEmails(), this);
		}
	}
	public void function removeEmailTemplate(any emailTemplate) {
		if(!structKeyExists(arguments, "emailTemplate")) {
			arguments.emailTemplate = variables.emailTemplate;
		}
		var index = arrayFind(arguments.emailTemplate.getEmails(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.emailTemplate.getEmails(), index);
		}
		structDelete(variables, "emailTemplate");
	}

	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}
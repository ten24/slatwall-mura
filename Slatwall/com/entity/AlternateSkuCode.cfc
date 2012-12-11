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
component displayname="Alternate Sku Code" entityname="SlatwallAlternateSkuCode" table="SlatwallAlternateSkuCode" persistent=true accessors=true output=false extends="BaseEntity" {
	
	// Persistent Properties
	property name="alternateSkuCodeID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="alternateSkuCode" ormtype="string";
	
	// Related Object Properties (Many-To-One)
	property name="alternateSkuCodeType" cfc="Type" fieldtype="many-to-one" fkcolumn="skuTypeID";
	property name="sku" cfc="Sku" fieldtype="many-to-one" fkcolumn="skuID";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// Sku (many-to-one)
	public void function setSku(required any sku) {
		variables.sku = arguments.sku;
		if(isNew() or !arguments.sku.hasAlternateSkuCode( this )) {
			arrayAppend(arguments.sku.getAlternateSkuCodes(), this);
		}
	}
	public void function removeSku(any sku) {
		if(!structKeyExists(arguments, "sku")) {
			arguments.sku = variables.sku;
		}
		var index = arrayFind(arguments.sku.getAlternateSkuCodes(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.sku.getAlternateSkuCodes(), index);
		}
		structDelete(variables, "sku");
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentationPropertyName() {
		return "alternateSkuCode";
	}
	
	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}

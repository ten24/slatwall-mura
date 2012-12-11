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
	
	List of Appliet Type
	
	orderItem 
*/
component displayname="Tax Applied" entityname="SlatwallTaxApplied" table="SlatwallTaxApplied" persistent="true" output="false" accessors="true" extends="BaseEntity" {
	
	// Persistent Properties
	property name="taxAppliedID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="taxAmount" ormtype="big_decimal";
	property name="taxRate" ormtype="big_decimal";
	property name="appliedType" ormtype="string";
	property name="currencyCode" ormtype="string" length="3";
	
	// Related Properties (many-to-one)
	property name="taxCategoryRate" cfc="TaxCategoryRate" fieldtype="many-to-one" fkcolumn="taxCategoryRateID";
	property name="orderItem" cfc="OrderItem" fieldtype="many-to-one" fkcolumn="orderItemID" cascadeCalculated="true";
	
	// Remote properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Order Item (many-to-one)
	public void function setOrderItem(required any orderItem) {
		variables.orderItem = arguments.orderItem;
		if(isNew() or !arguments.orderItem.hasAppliedTax( this )) {
			arrayAppend(arguments.orderItem.getAppliedTaxes(), this);
		}
	}
	public void function removeOrderItem(any orderItem) {
		if(!structKeyExists(arguments, "orderItem")) {
			arguments.orderItem = variables.orderItem;
		}
		var index = arrayFind(arguments.orderItem.getAppliedTaxes(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.orderItem.getAppliedTaxes(), index);
		}
		structDelete(variables, "orderItem");
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}
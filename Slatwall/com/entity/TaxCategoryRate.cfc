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
component displayname="Tax Category Rate" entityname="SlatwallTaxCategoryRate" table="SlatwallTaxCategoryRate" persistent="true" output="false" accessors="true" extends="BaseEntity" {
	
	// Persistent Properties
	property name="taxCategoryRateID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="taxRate" ormtype="float" formatType="percentage";
	
	// Related Object Properties
	property name="addressZone" cfc="AddressZone" fieldtype="many-to-one" fkcolumn="addressZoneID" nullRBKey="define.all";
	property name="taxCategory" cfc="TaxCategory" fieldtype="many-to-one" fkcolumn="taxCategoryID";
	
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
	
	// Tax Category (many-to-one)
	public void function setTaxCategory(required any taxCategory) {
		variables.taxCategory = arguments.taxCategory;
		if(isNew() or !arguments.taxCategory.hasTaxCategoryRate( this )) {
			arrayAppend(arguments.taxCategory.getTaxCategoryRates(), this);
		}
	}
	public void function removeTaxCategory(any taxCategory) {
		if(!structKeyExists(arguments, "taxCategory")) {
			arguments.taxCategory = variables.taxCategory;
		}
		var index = arrayFind(arguments.taxCategory.getTaxCategoryRates(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.taxCategory.getTaxCategoryRates(), index);
		}
		structDelete(variables, "taxCategory");
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================
	
	// ============== START: Overridden Implicet Getters ===================
	
	// ==============  END: Overridden Implicet Getters ====================

	// ================== START: Overridden Methods ========================
	
	
	public string function getSimpleRepresentation() {
		var sr = getTaxCategory().getTaxCategoryName();
		if( !isNull(getAddressZone()) ) {
			sr = listAppend(sr, getAddressZone().getAddressZoneName(), " - ");
		} else {
			sr = listAppend(sr, rbKey('define.all'), " - ");
		}
		sr = listAppend(sr, getTaxRate(), " - ");
		return sr;// getTaxCategory().getTaxCategoryName() & " - " & getAddressZone().getAddressZoneName() & " - " & getTaxRate();
	}
	
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================
}
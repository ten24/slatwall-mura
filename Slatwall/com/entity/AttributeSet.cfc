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
component displayname="AttributeSet" entityname="SlatwallAttributeSet" table="SlatwallAttributeSet" persistent="true" output="false" accessors="true" extends="BaseEntity" {
	
	// Persistent Properties
	property name="attributeSetID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="activeFlag" ormtype="boolean";
	property name="attributeSetName" ormtype="string";
	property name="attributeSetCode" ormtype="string";
	property name="attributeSetDescription" ormtype="string" length="2000" ;
	property name="globalFlag" ormtype="boolean" default="1";
	property name="requiredFlag" ormtype="boolean";
	property name="accountSaveFlag" ormtype="boolean";
	property name="additionalCharge" ormtype="big_decimal";
	property name="sortOrder" ormtype="integer";
	
	// Related Object Properties (many-to-one)
	property name="attributeSetType" cfc="Type" fieldtype="many-to-one" fkcolumn="attributeSetTypeID" systemCode="attributeSetType" hint="This is used to define if this attribute is applied to a profile, account, product, ext";
	
	// Related Object Properties (one-to-many)
	property name="attributes" singularname="attribute" cfc="Attribute" fieldtype="one-to-many" fkcolumn="attributeSetID" inverse="true" cascade="all-delete-orphan" orderby="sortOrder";
	
	// Related Object Properties (many-to-many - owner)
	property name="productTypes" singularname="productType" cfc="ProductType" type="array" fieldtype="many-to-many" linktable="SlatwallAttributeSetProductType" fkcolumn="attributeSetID" inversejoincolumn="productTypeID";

	// Related Object Properties (many-to-many - inverse)
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	public array function getAttributes(orderby, sortType="text", direction="asc") {
		if(!structKeyExists(arguments, "orderby")) {
			return variables.Attributes;
		} else {
			return getService("utilityService").sortObjectArray(variables.Attributes,arguments.orderby,arguments.sortType,arguments.direction);
		}
	}

    
   	public numeric function getAttributeCount() {
		return arrayLen(this.getAttributes());
	}

	// ============ START: Non-Persistent Property Methods =================
    
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// Attributes (one-to-many)
	public void function addAttribute(required any attribute) {
		arguments.attribute.setAttributeSet( this );
	}
	public void function removeAttribute(required any attribute) {
		arguments.attribute.removeAttributeSet( this );
	}
	
	// Product Types (many-to-many - owner)
	public void function addProductType(required any productType) {    
		if(arguments.productType.isNew() or !hasProductType(arguments.productType)) {    
			arrayAppend(variables.productTypes, arguments.productType);    
		}
		if(isNew() or !arguments.productType.hasAttributeSet( this )) {    
			arrayAppend(arguments.productType.getAttributeSets(), this);    
		}    
	}
	public void function removeProductType(required any productType) {    
		var thisIndex = arrayFind(variables.productTypes, arguments.productType);    
		if(thisIndex > 0) {    
			arrayDeleteAt(variables.productTypes, thisIndex);    
		}    
		var thatIndex = arrayFind(arguments.productType.getAttributeSets(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.productType.getAttributeSets(), thatIndex);    
		}
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}

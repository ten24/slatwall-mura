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
component displayname="Vendor" entityname="SlatwallVendor" table="SlatwallVendor" persistent="true" accessors="true" output="false" extends="BaseEntity" {
	
	// Persistent Properties
	property name="vendorID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="vendorName" ormtype="string";
	property name="vendorWebsite" ormtype="string";
	property name="accountNumber" ormtype="string";
	
	// Related Object Properties (many-to-one)
	property name="primaryEmailAddress" cfc="VendorEmailAddress" fieldtype="many-to-one" fkcolumn="primaryEmailAddressID";
	property name="primaryPhoneNumber" cfc="VendorPhoneNumber" fieldtype="many-to-one" fkcolumn="primaryPhoneNumberID";
	property name="primaryAddress" cfc="VendorAddress" fieldtype="many-to-one" fkcolumn="primaryAddressID";
	
	// Related Object Properties (one-to-many)
	property name="attributeValues" singularname="attributeValue" cfc="AttributeValue" type="array" fieldtype="one-to-many" fkcolumn="vendorID" cascade="all-delete-orphan" inverse="true";
	property name="vendorOrders" singularname="vendorOrder" type="array" cfc="VendorOrder" fieldtype="one-to-many" fkcolumn="vendorID" cascade="save-update" inverse="true";
	property name="vendorAddresses" singularname="vendorAddress" type="array" cfc="VendorAddress" fieldtype="one-to-many" fkcolumn="vendorID" cascade="all-delete-orphan" inverse="true";
	property name="vendorPhoneNumbers" singularname="vendorPhoneNumber" type="array" cfc="VendorPhoneNumber" fieldtype="one-to-many" fkcolumn="vendorID" cascade="all-delete-orphan" inverse="true";
	property name="vendorEmailAddresses" singularname="vendorEmailAddress" type="array" cfc="VendorEmailAddress" fieldtype="one-to-many" fkcolumn="vendorID" cascade="all-delete-orphan" inverse="true";
	
	// Related Object Properties (many-to-many - owner)
	property name="brands" singularname="brand" cfc="Brand" fieldtype="many-to-many" linktable="SlatwallVendorBrand" fkcolumn="vendorID" inversejoincolumn="brandID";
	property name="products" singularname="product" cfc="Product" fieldtype="many-to-many" linktable="SlatwallVendorProduct" fkcolumn="vendorID" inversejoincolumn="productID";
	
	// Remote properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties
	property name="vendorSkusSmartList" persistent="false";
	
	
	public string function getEmailAddress() {
		return getPrimaryEmailAddress().getEmailAddress();
	}
	
	public string function getPhoneNumber() {
		return getPrimaryPhoneNumber().getPhoneNumber();
	}
	
	public string function getAddress() {
		return getPrimaryAddress().getAddress();
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	public any function getVendorSkusSmartList() {
		if(!structKeyExists(variables, "vendorSkusSmartList")) {
			variables.vendorSkusSmartList = getService("vendorService").getVendorSkusSmartList(vendorID=getVendorID());
		}
		return variables.vendorSkusSmartList;
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	
	// Attribute Values (one-to-many)
	public void function addAttributeValue(required any attributeValue) {
		arguments.attributeValue.setVendor( this );
	}
	public void function removeAttributeValue(required any attributeValue) {
		arguments.attributeValue.removeVendor( this );
	}
	
	// Vendor Email Addresses (one-to-many)
	public void function addVendorEmailAddress(required any vendorEmailAddress) {
	   arguments.vendorEmailAddress.setVendor(this);
	}
	public void function removeVendorEmailAddress(required any vendorEmailAddress) {
	   arguments.vendorEmailAddress.removeVendor(this);
	}
	
	// Vendor Phone Numbers (one-to-many)
	public void function addVendorPhoneNumber(required any vendorPhoneNumber) {
	   arguments.vendorPhoneNumber.setVendor(this);
	}
	public void function removeVendorPhoneNumber(required any vendorPhoneNumber) {
	   arguments.vendorPhoneNumber.removeVendor(this);
	}
	
	// Vendor Addresses (one-to-many)
	public void function addVendorAddress(required any vendorAddress) {
	   arguments.vendorAddress.setVendor(this);
	}
	public void function removeVendorAddress(required any vendorAddress) {
	   arguments.vendorAddress.removeVendor(this);
	}
	
	// Vendor Orders (one-to-many)
	public void function addVendorOrder(required any vendorOrder) {
		arguments.vendorOrder.setVendor( this );
	}
	public void function removeVendorOrder(required any vendorOrder) {
		arguments.vendorOrder.removeVendor( this );
	}
	
	// Products (many-to-many - owner)
	public void function addProduct(required any product) {
		if(arguments.product.isNew() or !hasProduct(arguments.product)) {
			arrayAppend(variables.products, arguments.product);
		}
		if(isNew() or !arguments.product.hasVendor( this )) {
			arrayAppend(arguments.product.getVendors(), this);
		}
	}
	public void function removeProduct(required any product) {
		var thisIndex = arrayFind(variables.products, arguments.product);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.products, thisIndex);
		}
		var thatIndex = arrayFind(arguments.product.getVendors(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.product.getVendors(), thatIndex);
		}
	}
	
	// Brands (many-to-many - owner)
	public void function addBrand(required any brand) {
		if(arguments.brand.isNew() or !hasBrand(arguments.brand)) {
			arrayAppend(variables.brands, arguments.brand);
		}
		if(isNew() or !arguments.brand.hasVendor( this )) {
			arrayAppend(arguments.brand.getVendors(), this);
		}
	}
	public void function removeBrand(required any brand) {
		var thisIndex = arrayFind(variables.brands, arguments.brand);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.brands, thisIndex);
		}
		var thatIndex = arrayFind(arguments.brand.getVendors(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.brand.getVendors(), thatIndex);
		}
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	public any function getPrimaryEmailAddress() {
		if(!isNull(variables.primaryEmailAddress)) {
			return variables.primaryEmailAddress;
		} else if (arrayLen(getVendorEmailAddresses())) {
			setPrimaryEmailAddress(getVendorEmailAddresses()[i]);
			return getVendorEmailAddresses()[i];
		} else {
			return getService("vendorService").newVendorEmailAddress();
		}
	}
	
	public any function getPrimaryPhoneNumber() {
		if(!isNull(variables.primaryPhoneNumber)) {
			return variables.primaryPhoneNumber;
		} else if (arrayLen(getVendorPhoneNumbers())) {
			setPrimaryPhoneNumber(getVendorPhoneNumbers()[i]);
			return getVendorPhoneNumbers()[i];
		} else {
			return getService("vendorService").newVendorPhoneNumber();
		}
	}
	
	public any function getPrimaryAddress() {
		if(!isNull(variables.primaryAddress)) {
			return variables.primaryAddress;
		} else if (arrayLen(getVendorAddresses())) {
			setPrimaryAddress(getVendorAddresses()[i]);
			return getVendorAddresses()[i];
		} else {
			return getService("vendorService").newVendorAddress();
		}
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}
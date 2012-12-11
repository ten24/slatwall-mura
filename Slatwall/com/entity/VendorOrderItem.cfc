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
component displayname="Vendor Order Item" entityname="SlatwallVendorOrderItem" table="SlatwallVendorOrderItem" persistent="true" accessors="true" output="false" extends="BaseEntity" {
	
	// Persistent Properties
	property name="vendorOrderItemID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="quantity" ormtype="integer" default=0;
	property name="cost" ormtype="big_decimal" formatType="currency";
	property name="currencyCode" ormtype="string" length="3";
	property name="estimatedReceivalDateTime" ormtype="timestamp";
	
	// Related Object Properties (Many-to-One)
	property name="vendorOrder" cfc="VendorOrder" fieldtype="many-to-one" fkcolumn="vendorOrderID";
	property name="stock" cfc="Stock" fieldtype="many-to-one" fkcolumn="stockID";
	
	// Related Object Properties (One-to-Many)
	property name="stockReceiverItems" singularname="stockReceiverItem" cfc="StockReceiverItem" type="array" fieldtype="one-to-many" fkcolumn="vendorOrderItemID" cascade="all-delete-orphan" inverse="true";
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	
	// Non-persistant properties
	property name="extendedCost" persistent="false" formatType="currency";
	property name="quantityReceived" persistent="false";
	property name="quantityUnreceived" persistent="false";
	
	// ============ START: Non-Persistent Property Methods =================
	
	public numeric function getExtendedCost() {
		if(!isNull(getCost())) {
			return getCost() * getQuantity();	
		}
		return 0;
		
	}
	
	public numeric function getQuantityReceived() {
		var quantityReceived = 0;
		
		for( var i=1; i<=arrayLen(getStockReceiverItems()); i++){
			quantityReceived += getStockReceiverItems()[i].getQuantity();
		}
		
		return quantityReceived;
	}
	
	public numeric function getQuantityUnreceived() {
		return getQuantity() - getQuantityReceived();
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Vendor Order (many-to-one)
	public void function setVendorOrder(required any vendorOrder) {
		variables.vendorOrder = arguments.vendorOrder;
		if(isNew() or !arguments.vendorOrder.hasVendorOrderItem( this )) {
			arrayAppend(arguments.vendorOrder.getVendorOrderItems(), this);
		}
	}
	public void function removeVendorOrder(any vendorOrder) {
		if(!structKeyExists(arguments, "vendorOrder")) {
			arguments.vendorOrder = variables.vendorOrder;
		}
		var index = arrayFind(arguments.vendorOrder.getVendorOrderItems(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.vendorOrder.getVendorOrderItems(), index);
		}
		structDelete(variables, "vendorOrder");
	}
	
	// Stock Receiver Items (one-to-many)    
	public void function addStockReceiverItem(required any stockReceiverItem) {    
		arguments.stockReceiverItem.setVendorOrderItem( this );    
	}
	public void function removeStockReceiverItem(required any stockReceiverItem) {    
		arguments.stockReceiverItem.removeVendorOrderItem( this );    
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
		if(!isNull(getStock().getSku().getProduct().getCalculatedTitle())) {
			return getStock().getSku().getProduct().getCalculatedTitle();
		}
		return getStock().getSku().getProduct().getTitle(); 
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================
	
}

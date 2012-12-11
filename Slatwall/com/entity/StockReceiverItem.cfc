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
component displayname="Stock Receiver Item" entityname="SlatwallStockReceiverItem" table="SlatwallStockReceiverItem" persistent=true accessors=true output=false extends="BaseEntity" {
	
	// Persistent Properties
	property name="stockReceiverItemID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="quantity" ormtype="integer";
	property name="cost" ormtype="big_decimal";
	property name="currencyCode" ormtype="string" length="3";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	
	// Related Object Properties (many-to-one)
	property name="stock" fieldtype="many-to-one" fkcolumn="stockID" cfc="Stock" cascadeCalculate="true";
	property name="stockReceiver" fieldtype="many-to-one" fkcolumn="stockReceiverID" cfc="StockReceiver";
	property name="orderItem" cfc="OrderItem" fieldtype="many-to-one" fkcolumn="orderItemID";
	property name="vendorOrderItem" cfc="VendorOrderItem" fieldtype="many-to-one" fkcolumn="vendorOrderItemID";
	property name="stockAdjustmentItem" cfc="StockAdjustmentItem" fieldtype="many-to-one" fkcolumn="stockAdjustmentItemID";
	
	private boolean function hasOneAndOnlyOneRelatedItem() {
    	var relationshipCount = 0;
    	if(!isNull(getVendorOrderItem())) {
    		relationshipCount++;
    	}
    	if(!isNull(getOrderItem())) {
    		relationshipCount++;
    	}
    	if(!isNull(getStockAdjustmentItem())) {
    		relationshipCount++;
    	}
    	return relationshipCount == 1;
    }
    
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Stock Receiver (many-to-one)    
	public void function setStockReceiver(required any stockReceiver) {    
		variables.stockReceiver = arguments.stockReceiver;    
		if(isNew() or !arguments.stockReceiver.hasStockReceiverItem( this )) {    
			arrayAppend(arguments.stockReceiver.getStockReceiverItems(), this);    
		}    
	}    
	public void function removeStockReceiver(any stockReceiver) {    
		if(!structKeyExists(arguments, "stockReceiver")) {    
			arguments.stockReceiver = variables.stockReceiver;    
		}    
		var index = arrayFind(arguments.stockReceiver.getStockReceiverItems(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.stockReceiver.getStockReceiverItems(), index);    
		}    
		structDelete(variables, "stockReceiver");    
	}

	// Stock Adjustment Item (many-to-one)    
	public void function setStockAdjustmentItem(required any stockAdjustmentItem) {    
		variables.stockAdjustmentItem = arguments.stockAdjustmentItem;    
		if(isNew() or !arguments.stockAdjustmentItem.hasStockReceiverItem( this )) {    
			arrayAppend(arguments.stockAdjustmentItem.getStockReceiverItems(), this);    
		}    
	}    
	public void function removeStockAdjustmentItem(any stockAdjustmentItem) {    
		if(!structKeyExists(arguments, "stockAdjustmentItem")) {    
			arguments.stockAdjustmentItem = variables.stockAdjustmentItem;    
		}    
		var index = arrayFind(arguments.stockAdjustmentItem.getStockReceiverItems(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.stockAdjustmentItem.getStockReceiverItems(), index);    
		}    
		structDelete(variables, "stockAdjustmentItem");    
	}
	
	// Order Item (many-to-one)
	public void function setOrderItem(required any orderItem) {
		variables.orderItem = arguments.orderItem;
		if(isNew() or !arguments.orderItem.hasStockReceiverItem( this )) {
			arrayAppend(arguments.orderItem.getStockReceiverItems(), this);
		}
	}
	public void function removeOrderItem(any orderItem) {
		if(!structKeyExists(arguments, "orderItem")) {
			arguments.orderItem = variables.orderItem;
		}
		var index = arrayFind(arguments.orderItem.getStockReceiverItems(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.orderItem.getStockReceiverItems(), index);
		}
		structDelete(variables, "orderItem");
	}
	
	// Vendor Order Item (many-to-one)
	public void function setVendorOrderItem(required any vendorOrderItem) {
		variables.vendorOrderItem = arguments.vendorOrderItem;
		if(isNew() or !arguments.vendorOrderItem.hasStockReceiverItem( this )) {	
			arrayAppend(arguments.vendorOrderItem.getStockReceiverItems(), this);
		}
	}
	public void function removeVendorOrderItem(any vendorOrderItem) {
		if(!structKeyExists(arguments, "vendorOrderItem")) {
			arguments.vendorOrderItem = variables.vendorOrderItem;
		}
		var index = arrayFind(arguments.vendorOrderItem.getStockReceiverItems(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.vendorOrderItem.getStockReceiverItems(), index);
		}
		structDelete(variables, "vendorOrderItem");
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// =================== START: ORM Event Hooks  =========================
	
	public void function preInsert(){
		if(!hasOneAndOnlyOneRelatedItem()) {
			throw("The Stock Receiver Item Needs to have a relationship with 'OrderItem', 'VendorOrderItem', or 'StockAdjustmentItem' and only one of those can exist.");
		}
		super.preInsert();
		getService("inventoryService").createInventory( this );
	}
	
	public void function preUpdate(Struct oldData){
		throw("Updates to Stock Receiver Items are not allowed because this illustrates a fundamental flaw in inventory tracking.");
	}
	
	// ===================  END:  ORM Event Hooks  =========================
}
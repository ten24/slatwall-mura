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
component displayname="Stock Adjustment Item" entityname="SlatwallStockAdjustmentItem" table="SlatwallStockAdjustmentItem" persistent="true" accessors="true" output="false" extends="BaseEntity" {

	// Persistent Properties
	property name="stockAdjustmentItemID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="quantity" ormtype="integer" default=0;
	
	// Related Object Properties (many-to-one)
	property name="stockAdjustment" cfc="StockAdjustment" fieldtype="many-to-one" fkcolumn="stockAdjustmentID";
	property name="fromStock" cfc="Stock" fieldtype="many-to-one" fkcolumn="fromStockID";
	property name="toStock" cfc="Stock" fieldtype="many-to-one" fkcolumn="toStockID";
	
	// Related Object Properties (one-to-many)
	property name="stockAdjustmentDeliveryItems" singularname="stockAdjustmentDeliveryItem" cfc="StockAdjustmentDeliveryItem" type="array" fieldtype="one-to-many" fkcolumn="stockAdjustmentItemID" cascade="all-delete-orphan" inverse="true";
	property name="stockReceiverItems" singularname="stockReceiverItem" cfc="StockReceiverItem" type="array" fieldtype="one-to-many" fkcolumn="stockAdjustmentItemID" cascade="all-delete-orphan" inverse="true";
	
	
	// For use with Adjustment Items interface, get one stock that we will use displaying sku info. 
	public any function getOneStock() {
		if(!isNull(variables.fromStock)) {
			return getFromStock();
		} else {
			return getToStock();
		}
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================

	// Stock Adjustment (many-to-one)    
	public void function setStockAdjustment(required any stockAdjustment) {    
		variables.stockAdjustment = arguments.stockAdjustment;    
		if(isNew() or !arguments.stockAdjustment.hasStockAdjustmentItem( this )) {    
			arrayAppend(arguments.stockAdjustment.getStockAdjustmentItems(), this);    
		}    
	}    
	public void function removeStockAdjustment(any stockAdjustment) {    
		if(!structKeyExists(arguments, "stockAdjustment")) {    
			arguments.stockAdjustment = variables.stockAdjustment;    
		}    
		var index = arrayFind(arguments.stockAdjustment.getStockAdjustmentItems(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.stockAdjustment.getStockAdjustmentItems(), index);    
		}    
		structDelete(variables, "stockAdjustment");    
	}
	
	// Stock Adjustment Delivery Items (one-to-many)
	public void function addStockAdjustmentDeliveryItem(required any stockAdjustmentDeliveryItem) {
		arguments.stockAdjustmentDeliveryItem.setStockAdjustmentItem( this );
	}
	public void function removeStockAdjustmentDeliveryItem(required any stockAdjustmentDeliveryItem) {
		arguments.stockAdjustmentDeliveryItem.removeStockAdjustmentItem( this );
	}
	
	// Stock Receiver Items (one-to-many)
	public void function addStockReceiverItem(required any stockReceiverItem) {
		arguments.stockReceiverItem.setStockAdjustmentItem( this );
	}
	public void function removeStockReceiverItem(required any stockReceiverItem) {
		arguments.stockReceiverItem.removeStockAdjustmentItem( this );
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
		return getOneStock().getSku().getProduct().getTitle() & " - " & getOneStock().getSku().getOptionsDisplay();
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================
	
	
}
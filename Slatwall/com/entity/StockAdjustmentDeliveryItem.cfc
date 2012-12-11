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
component displayname="StockAdjustment Delivery Item" entityname="SlatwallStockAdjustmentDeliveryItem" table="SlatwallStockAdjustmentDeliveryItem" persistent="true" accessors="true" output="false" extends="BaseEntity" {
	
	// Persistent Properties
	property name="stockAdjustmentDeliveryItemID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="quantity" ormtype="integer";
	
	// Related Object Properties (many-to-one)
	property name="stockAdjustmentDelivery" cfc="StockAdjustmentDelivery" fieldtype="many-to-one" fkcolumn="stockAdjustmentDeliveryID";
	property name="stockAdjustmentItem" cfc="StockAdjustmentItem" fieldtype="many-to-one" fkcolumn="stockAdjustmentItemID";
	property name="stock" cfc="Stock" fieldtype="many-to-one" fkcolumn="stockID";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";

	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// Stock Adjustment Delivery (many-to-one)
	public void function setStockAdjustmentDelivery(required any stockAdjustmentDelivery) {
		variables.stockAdjustmentDelivery = arguments.stockAdjustmentDelivery;
		if(isNew() or !arguments.stockAdjustmentDelivery.hasStockAdjustmentDeliveryItem( this )) {
			arrayAppend(arguments.stockAdjustmentDelivery.getStockAdjustmentDeliveryItems(), this);
		}
	}
	public void function removeStockAdjustmentDelivery(any stockAdjustmentDelivery) {
		if(!structKeyExists(arguments, "stockAdjustmentDelivery")) {
			arguments.stockAdjustmentDelivery = variables.stockAdjustmentDelivery;
		}
		var index = arrayFind(arguments.stockAdjustmentDelivery.getStockAdjustmentDeliveryItems(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.stockAdjustmentDelivery.getStockAdjustmentDeliveryItems(), index);
		}
		structDelete(variables, "stockAdjustmentDelivery");
	}
	
	// Stock Adjustment Item (many-to-one)
	public void function setStockAdjustmentItem(required any stockAdjustmentItem) {
		variables.stockAdjustmentItem = arguments.stockAdjustmentItem;
		if(isNew() or !arguments.stockAdjustmentItem.hasStockAdjustmentDeliveryItem( this )) {
			arrayAppend(arguments.stockAdjustmentItem.getStockAdjustmentDeliveryItems(), this);
		}
	}
	public void function removeStockAdjustmentItem(any stockAdjustmentItem) {
		if(!structKeyExists(arguments, "stockAdjustmentItem")) {
			arguments.stockAdjustmentItem = variables.stockAdjustmentItem;
		}
		var index = arrayFind(arguments.stockAdjustmentItem.getStockAdjustmentDeliveryItems(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.stockAdjustmentItem.getStockAdjustmentDeliveryItems(), index);
		}
		structDelete(variables, "stockAdjustmentItem");
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	public void function preInsert(){
		super.preInsert();
		getService("inventoryService").createInventory( this );
	}
	
	public void function preUpdate(Struct oldData){
		throw("Updates to StockAdjustment Delivery Items are not allowed because this illustrates a fundamental flaw in inventory tracking.");
	}
	
	// ===================  END:  ORM Event Hooks  =========================
}

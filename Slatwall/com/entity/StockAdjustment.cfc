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
component displayname="Stock Adjustment" entityname="SlatwallStockAdjustment" table="SlatwallStockAdjustment" persistent="true" accessors="true" output="false" extends="BaseEntity" {

	// Persistent Properties
	property name="stockAdjustmentID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	
	// Related Object Properties (many-to-one)
	property name="fromLocation" cfc="Location" fieldtype="many-to-one" fkcolumn="fromLocationID";
	property name="toLocation" cfc="Location" fieldtype="many-to-one" fkcolumn="toLocationID";
	property name="stockAdjustmentType" cfc="Type" fieldtype="many-to-one" fkcolumn="stockAdjustmentTypeID";
	property name="stockAdjustmentStatusType" cfc="Type" fieldtype="many-to-one" fkcolumn="stockAdjustmentStatusTypeID";
	
	// Related Object Properties (one-to-many)
	property name="stockAdjustmentItems" singularname="stockAdjustmentItem" cfc="StockAdjustmentItem" fieldtype="one-to-many" fkcolumn="stockAdjustmentID" inverse="true" cascade="all-delete-orphan";
	property name="stockReceivers" singularname="stockReceiver" cfc="StockReceiver" type="array" fieldtype="one-to-many" fkcolumn="stockAdjustmentID" cascade="all" inverse="true";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties
	property name="displayName" persistent="false";
	property name="statusCode" persistent="false";
	property name="adjustmentSkuOptions" persistent="false";
	
	public string function getStatusCode() {
		return getStockAdjustmentStatusType().getSystemCode();
	}
	
	public any function getAdjustmentSkuOptions() {
		if(!structKeyExists(variables, "adjustmentSkuOptions")) {
			variables.adjustmentSkuOptions = getService("skuService").listSku({activeFlag=1}); 
		}
		return variables.adjustmentSkuOptions;
	}
	
	// For use with Adjustment Items interface, get one location that we will use for stock lookup. 
	public any function getOneLocation() {
		if(getStockAdjustmentType().getSystemCode() == "satLocationTransfer" || getStockAdjustmentType().getSystemCode() == "satManualIn") {
			return getToLocation();
		} else {
			return getFromLocation();
		}
	}
	
	public any function getStockAdjustmentItemForSku(required any sku) {
		return getService("StockService").getStockAdjustmentItemForSku(arguments.sku, this);
	}
	
	// Returns an array of structs, each struct containing a product, and an array of stockAdjustmentItems
	public any function getStockAdjustmentItemsByProduct() {
		var keyByProductId = {};
	
		for(var i=1; i <= ArrayLen(getStockAdjustmentItems()); i++) {
			var product = getStockAdjustmentItems()[i].getOneStock().getSku().getProduct();
			if(structKeyExists(keyByProductId, product.getProductId())) {
				// We already have this product in the array, so simply append the stockAdjustmentItem to the items array
				arrayAppend(keyByProductId[product.getProductId()].stockAdjustmentItems, getStockAdjustmentItems()[i]);
			} else {
				// We did not find the product, so add it to the array
				var struct = {
					product = product, 
					stockAdjustmentItems = [getStockAdjustmentItems()[i]]
				};
				keyByProductId[product.getProductId()] = struct;
			}
		}
		
		// Transform the assocaitive array into an array
		var local.arr = [];
		for (var struct IN keyByProductId) {
			arrayAppend(local.arr, keyByProductId[struct]);
		}

		return local.arr;
	}
	
	public boolean function isNotDeletable() {
		return getStockAdjustmentStatusType().getSystemCode() == "sastClosed";
	}
	
	public string function getDisplayName(){
		var displayName = "#getStockAdjustmentType().getType()#:";
		if(!isNull(getFromLocation())) {
			displayName = listAppend(displayName, getFromLocation().getLocationName(), " ");
		}
		if(!isNull(getFromLocation()) && !isNull(getToLocation())) {
			displayName = listAppend(displayName, "-", " ");
		}
		if(!isNull(getToLocation())) {
			displayName = listAppend(displayName, getToLocation().getLocationName(), " ");
		}
		return displayName;
	}
	
	
	
	// ============ START: Non-Persistent Property Methods =================
	
	// Stock Adjustment Items (one-to-many)
	public void function addStockAdjustmentItem(required any stockAdjustmentItem) {
	   arguments.stockAdjustmentItem.setStockAdjustment( this );
	}
	
	public void function removeStockAdjustmentItem(required any stockAdjustmentItem) {
	   arguments.stockAdjustmentItem.removeStockAdjustment( this );
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Stock Receivers (one-to-many)
	public void function addStockReceiver(required any stockReceiver) {
		arguments.stockReceiver.setStockAdjustment( this );
	}
	public void function removeStockReceiver(required any stockReceiver) {
		arguments.stockReceiver.removeStockAdjustment( this );
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ============== START: Overridden Implicet Getters ===================

	public any function getStockAdjustmentType() {
		if( !structKeyExists(variables, "stockAdjustmentType") ) {
			variables.stockAdjustmentType = getService("typeService").getTypeBySystemCode("satLocationTransfer");
		}
		return variables.stockAdjustmentType;
	}
	
	public any function getStockAdjustmentStatusType() {
		if( !structKeyExists(variables, "stockAdjustmentStatusType") ) {
			variables.stockAdjustmentStatusType = getService("typeService").getTypeBySystemCode("sastNew");
		}
		return variables.stockAdjustmentStatusType;
	}
	
	public string function getSimpleRepresentationPropertyName() {
		return "displayName";
	}
	
	// ==============  END: Overridden Implicet Getters ====================
	
	// =================== START: ORM Event Hooks  =========================
	
	public void function preInsert(){
		super.preInsert();
		
		// Verify Defaults are Set
		getStockAdjustmentType();
		getStockAdjustmentStatusType();
	}
	
	// ===================  END:  ORM Event Hooks  =========================
}
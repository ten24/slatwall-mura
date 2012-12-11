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
component extends="BaseService" accessors="true" output="false" {

	property name="commentService" type="any";
	property name="locationService" type="any";
	property name="skuService" type="any";
	property name="typeService" type="any";
	
	public any function getStockBySkuAndLocation(required any sku, required any location){
		var stock = getDAO().getStockBySkuAndLocation(argumentCollection=arguments);
		
		if(isNull(stock)) {
			
			if(getSlatwallScope().hasValue("stock_#arguments.sku.getSkuID()#_#arguments.location.getLocationID()#")) {
				// Set the stock in the requestCache so that duplicates for this stock don't get created.
				stock = getSlatwallScope().getValue("stock_#arguments.sku.getSkuID()#_#arguments.location.getLocationID()#");
				
			} else {
				stock = this.newStock();
				stock.setSku(arguments.sku);
				stock.setLocation(arguments.location);
				getDAO().save(stock);
				
				// Set the stock in the requestCache so that duplicates for this stock don't get created.
				getSlatwallScope().setValue("stock_#arguments.sku.getSkuID()#_#arguments.location.getLocationID()#", stock);
				
			}
		}
		
		return stock;
	}
	
	public any function getStockAdjustmentItemForSku(required any sku, required any stockAdjustment){
		var stockAdjustmentItem = getDAO().getStockAdjustmentItemForSku(arguments.sku, arguments.stockAdjustment);
		
		if(isNull(stockAdjustmentItem)) {
			stockAdjustmentItem = this.newStockAdjustmentItem();
		}

		return stockAdjustmentItem;
	}
	
	public any function getEstimatedReceivalDetails(required string productID) {
		return createEstimatedReceivalDataStruct( getDAO().getEstimatedReceival(arguments.productID) );
	}
	
	private struct function createEstimatedReceivalDataStruct(required array receivalArray) {
		
		var returnStruct = {};
		var insertedAt = 0;
		
		returnStruct.locations = {};
		returnStruct.skus = {};
		returnStruct.stocks = {};
		returnStruct.estimatedReceivals = [];
		
		for(var i=1; i<=arrayLen(arguments.receivalArray); i++) {
			
			var skuID = arguments.receivalArray[i]["skuID"];
			var locationID = arguments.receivalArray[i]["locationID"];
			var stockID = arguments.receivalArray[i]["stockID"];
			
			// Setup the estimate data
			var data = {};
			data.quantity = arguments.receivalArray[i]["orderedQuantity"] - arguments.receivalArray[i]["receivedQuantity"];
			if(structKeyExists(arguments.receivalArray[i], "orderItemEstimatedReceival")) {
				data.estimatedReceivalDateTime = arguments.receivalArray[i]["orderItemEstimatedReceival"];	
			} else {
				data.estimatedReceivalDateTime = arguments.receivalArray[i]["orderEstimatedReceival"];	
			}
			
			// First do the product level addition
			inserted = false;
			for(var e=1; e<=arrayLen(returnStruct.estimatedReceivals); e++) {
				if(returnStruct.estimatedReceivals[e].estimatedReceivalDateTime eq data.estimatedReceivalDateTime) {
					returnStruct.estimatedReceivals[e].quantity += data.quantity;
					inserted = true;
					break;
				} else if (returnStruct.estimatedReceivals[e].estimatedReceivalDateTime gt data.estimatedReceivalDateTime) {
					arrayInsertAt(returnStruct.estimatedReceivals, e, duplicate(data));
					inserted = true;
					break;
				}
			}
			if(!inserted) {
				arrayAppend(returnStruct.estimatedReceivals, duplicate(data));
			}
			
			
			// Do the sku level addition
			if(!structKeyExists(returnStruct.skus, skuID)) {
				returnStruct.skus[ skuID ] = {};
				returnStruct.skus[ skuID ].locations = {};
				returnStruct.skus[ skuID ].estimatedReceivals = [];
			}
			inserted = false;
			for(var e=1; e<=arrayLen(returnStruct.skus[ skuID ].estimatedReceivals); e++) {
				if(returnStruct.skus[ skuID ].estimatedReceivals[e].estimatedReceivalDateTime eq data.estimatedReceivalDateTime) {
					returnStruct.skus[ skuID ].estimatedReceivals[e].quantity += data.quantity;
					inserted = true;
					break;
				} else if (returnStruct.skus[ skuID ].estimatedReceivals[e].estimatedReceivalDateTime gt data.estimatedReceivalDateTime) {
					arrayInsertAt(returnStruct.skus[ skuID ].estimatedReceivals, e, duplicate(data));
					inserted = true;
					break;
				}
			}
			if(!inserted) {
				arrayAppend(returnStruct.skus[ skuID ].estimatedReceivals, duplicate(data));
			}
			// Add the location break up to this sku
			if(!structKeyExists(returnStruct.skus[ skuID ].locations, locationID)) {
				returnStruct.skus[ skuID ].locations[ locationID ] = [];
			}
			inserted = false;
			for(var e=1; e<=arrayLen(returnStruct.skus[ skuID ].locations[ locationID ] ); e++) {
				if(returnStruct.skus[ skuID ].locations[ locationID ][e].estimatedReceivalDateTime eq data.estimatedReceivalDateTime) {
					returnStruct.skus[ skuID ].locations[ locationID ][e].quantity += data.quantity;
					inserted = true;
					break;
				} else if (returnStruct.skus[ skuID ].locations[ locationID ][e].estimatedReceivalDateTime gt data.estimatedReceivalDateTime) {
					arrayInsertAt(returnStruct.skus[ skuID ].locations[ locationID ], e, duplicate(data));
					inserted = true;
					break;
				}
			}
			if(!inserted) {
				arrayAppend(returnStruct.skus[ skuID ].locations[ locationID ], duplicate(data));
			}
			
			
			
			// Do the location level addition
			if(!structKeyExists(returnStruct.locations, locationID)) {
				returnStruct.locations[ locationID ] = [];
			}
			inserted = false;
			for(var e=1; e<=arrayLen(returnStruct.locations[ locationID ]); e++) {
				if(returnStruct.locations[ locationID ][e].estimatedReceivalDateTime eq data.estimatedReceivalDateTime) {
					returnStruct.locations[ locationID ][e].quantity += data.quantity;
					inserted = true;
					break;
				} else if (returnStruct.locations[ locationID ][e].estimatedReceivalDateTime gt data.estimatedReceivalDateTime) {
					arrayInsertAt(returnStruct.locations[ locationID ], e, duplicate(data));
					inserted = true;
					break;
				}
			}
			if(!inserted) {
				arrayAppend(returnStruct.locations[ locationID ], duplicate(data));
			}
			
			// Do the stock level addition
			if(!structKeyExists(returnStruct.stocks, stockID)) {
				returnStruct.stocks[ stockID ] = [];
			}
			inserted = false;
			for(var e=1; e<=arrayLen(returnStruct.stocks[ stockID ]); e++) {
				if(returnStruct.stocks[ stockID ][e].estimatedReceivalDateTime eq data.estimatedReceivalDateTime) {
					returnStruct.stocks[ stockID ][e].quantity += data.quantity;
					inserted = true;
					break;
				} else if (returnStruct.stocks[ stockID ][e].estimatedReceivalDateTime gt data.estimatedReceivalDateTime) {
					arrayInsertAt(returnStruct.stocks[ stockID ], e, duplicate(data));
					inserted = true;
					break;
				}
			}
			if(!inserted) {
				arrayAppend(returnStruct.stocks[ stockID ], duplicate(data));
			}
			
			
		}
		
		return returnStruct;
	}
	
	
	// ===================== START: Logical Methods ===========================
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	public any function processStockAdjustment(required any stockAdjustment, struct data={}, string processContext="process") {
		
		if(arguments.processcontext eq 'addItems'){
				
			for(var i=1; i<=arrayLen(arguments.data.records); i++) {
				
				var thisRecord = arguments.data.records[i];
				
				if(val(thisRecord.quantity)) {
					
					var foundItem = false;
					var sku = getSkuService().getSku( thisRecord.skuid );
					
					if( listFindNoCase("satLocationTransfer,satManualOut", arguments.stockAdjustment.getStockAdjustmentType().getSystemCode()) ) {
						var fromStock = getStockBySkuAndLocation(sku, arguments.stockAdjustment.getFromLocation());	
					}
					if( listFindNoCase("satLocationTransfer,satManualIn", arguments.stockAdjustment.getStockAdjustmentType().getSystemCode()) ) {
						var toStock = getStockBySkuAndLocation(sku, arguments.stockAdjustment.getToLocation());
					}
					
					
					// Look for the orderItem in the vendorOrder
					for(var ai=1; ai<=arrayLen(arguments.stockAdjustment.getStockAdjustmentItems()); ai++) {
						// If the location, sku, cost & estimated arrival are already the same as an item on the order then we can merge them.  Otherwise seperate
						if( ( listFindNoCase("satLocationTransfer,satManualOut", arguments.stockAdjustment.getStockAdjustmentType().getSystemCode()) && arguments.stockAdjustment.getStockAdjustmentItems()[ai].getFromStock().getSku().getSkuID() == thisRecord.skuid )
							||
							( listFindNoCase("satLocationTransfer,satManualIn", arguments.stockAdjustment.getStockAdjustmentType().getSystemCode()) && arguments.stockAdjustment.getStockAdjustmentItems()[ai].getToStock().getSku().getSkuID() == thisRecord.skuid )
							) {
								
							foundItem = true;
							arguments.stockAdjustment.getStockAdjustmentItems()[ai].setQuantity( arguments.stockAdjustment.getStockAdjustmentItems()[ai].getQuantity() + int(thisRecord.quantity) );
						}
					}
					
					
					if(!foundItem) {
						
						var stockAdjustmentItem = this.newStockAdjustmentItem();
						stockAdjustmentItem.setQuantity( int(thisRecord.quantity) );
						if( listFindNoCase("satLocationTransfer,satManualOut", arguments.stockAdjustment.getStockAdjustmentType().getSystemCode()) ) {
							stockAdjustmentItem.setFromStock( fromStock );
						}
						if( listFindNoCase("satLocationTransfer,satManualIn", arguments.stockAdjustment.getStockAdjustmentType().getSystemCode()) ) {
							stockAdjustmentItem.setToStock( toStock );
						}
						stockAdjustmentItem.setStockAdjustment( arguments.stockAdjustment );
						
					}
					
				}
			}
			
		} else if(arguments.processcontext eq 'processAdjustment'){
			
			// Incoming
			if(arguments.stockAdjustment.getStockAdjustmentType().getSystemCode() == "satLocationTransfer" || arguments.stockAdjustment.getStockAdjustmentType().getSystemCode() == "satManualIn") {
				var stockReceiver = this.newStockReceiver();
				stockReceiver.setReceiverType("stockAdjustment");
				stockReceiver.setStockAdjustment(arguments.stockAdjustment);
				
				for(var i=1; i <= ArrayLen(arguments.stockAdjustment.getStockAdjustmentItems()); i++) {
					var stockAdjustmentItem = arguments.stockAdjustment.getStockAdjustmentItems()[i];
					var stockReceiverItem = this.newStockReceiverItem();
					stockReceiverItem.setStockReceiver( stockReceiver );
					stockReceiverItem.setStockAdjustmentItem( stockAdjustmentItem );
					stockReceiverItem.setQuantity(stockAdjustmentItem.getQuantity());
					stockReceiverItem.setCost(0);
					stockReceiverItem.setStock(stockAdjustmentItem.getToStock());
				}
				
				this.saveStockReceiver( stockReceiver );
			}
			
			// Outgoing
			if(arguments.stockAdjustment.getStockAdjustmentType().getSystemCode() == "satLocationTransfer" || arguments.stockAdjustment.getStockAdjustmentType().getSystemCode() == "satManualOut") {
				var stockAdjustmentDelivery = this.newStockAdjustmentDelivery();
				stockAdjustmentDelivery.setStockAdjustment(arguments.stockAdjustment);
				
				for(var i=1; i <= ArrayLen(arguments.stockAdjustment.getStockAdjustmentItems()); i++) {
					var stockAdjustmentItem = arguments.stockAdjustment.getStockAdjustmentItems()[i];
					var stockAdjustmentDeliveryItem = this.newStockAdjustmentDeliveryItem();
					stockAdjustmentDeliveryItem.setStockAdjustmentDelivery(stockAdjustmentDelivery);
					stockAdjustmentDeliveryItem.setStockAdjustmentItem(stockAdjustmentItem);
					stockAdjustmentDeliveryItem.setQuantity(stockAdjustmentItem.getQuantity());
					stockAdjustmentDeliveryItem.setStock(stockAdjustmentItem.getFromStock());
				}
				
				this.saveStockAdjustmentDelivery(stockAdjustmentDelivery);
			}
			
			
			// Set the status to closed
			arguments.stockAdjustment.setStockAdjustmentStatusType( getTypeService().getTypeBySystemCode("sastClosed") );
		}
		
		return arguments.stockAdjustment;
	}
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Status Methods ===========================
	
	// ======================  END: Status Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
	// ===================== START: Delete Overrides ==========================
	
	public any function deleteStockAdjustment(required any entity) {
		
		// If the entity Passes validation
		if(arguments.entity.isDeletable()) {
			
			// Remove any Many-to-Many relationships
			arguments.entity.removeAllManyToManyRelationships();
			
			// Remove any Settings
			getService("settingService").removeAllEntityRelatedSettings( entity=arguments.entity );
			
			// Remove any comments
			getCommentService().deleteAllRelatedCommentsForEntity("stockAdjustmentID", arguments.entity.getStockAdjustmentID());
			
			// Call delete in the DAO
			getDAO().delete(target=arguments.entity);
			
			// Return that the delete was sucessful
			return true;
			
		}
			
		// Setup ormHasErrors because it didn't pass validation
		getSlatwallScope().setORMHasErrors( true );

		return false;
		
	}

	// =====================  END: Delete Overrides ===========================
	
	
}
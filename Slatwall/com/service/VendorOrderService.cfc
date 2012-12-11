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
component extends="BaseService" persistent="false" accessors="true" output="false" {
	
	property name="addressService";
	property name="taxService";
	property name="skuService";
	property name="stockService";
	property name="locationService";
	property name="productService";
	property name="DAO";
	
	public any function getVendorOrderSmartList(struct data={}) {
		arguments.entityName = "SlatwallVendorOrder";
		
		var smartList = getDAO().getSmartList(argumentCollection=arguments);
		
		smartList.joinRelatedProperty("SlatwallVendorOrder","vendor");
			
		smartList.addKeywordProperty(propertyIdentifier="vendorOrderNumber", weight=9);
		smartList.addKeywordProperty(propertyIdentifier="vendor.vendorName", weight=4);	
		
		return smartList;
	}
	
	public any function getStockReceiverSmartList(string vendorOrderID) {
		var smartList = getStockService().getStockReceiverSmartlist();	
		smartList.addFilter("stockReceiverItems_vendorOrderItem_vendorOrder_vendorOrderID",arguments.vendorOrderID);
		return smartList;
	}
	
	public any function getStockReceiverItemSmartList(any stockReceiver) {
		var smartList = getStockService().getStockReceiverItemSmartlist();	
		smartList.addFilter("stockReceiver.stockReceiverID",arguments.stockReceiver.getStockReceiverID());
		return smartList;
	}
		
	public any function isProductInVendorOrder(required any productID, required any vendorOrderID){
		return getDAO().isProductInVendorOrder(arguments.productID, arguments.vendorOrderID);
	}
	
	public any function getQuantityOfStockAlreadyOnOrder(required any vendorOrderID, required any skuID, required any stockID) {
		return getDAO().getQuantityOfStockAlreadyOnOrder(arguments.vendorOrderId, arguments.skuID, arguments.stockID);
	}
	
	public any function getQuantityOfStockAlreadyReceived(required any vendorOrderID, required any skuID, required any stockID) {
		return getDAO().getQuantityOfStockAlreadyReceived(arguments.vendorOrderId, arguments.skuID, arguments.stockID);
	}
	
	public any function getSkusOrdered(required any vendorOrderID) {
		return getDAO().getSkusOrdered(arguments.vendorOrderId);
	}
	
	// ===================== START: Logical Methods ===========================
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	public any function processVendorOrder(required any vendorOrder, struct data={}, string processContext="process"){
		
		switch(arguments.processcontext){
			case 'addOrderItems':
				
				for(var i=1; i<=arrayLen(arguments.data.records); i++) {
					
					var thisRecord = arguments.data.records[i];
					
					if(val(thisRecord.quantity)) {
						
						var foundItem = false;
						var sku = getSkuService().getSku( thisRecord.skuid );
						var location = getLocationService().getLocation( arguments.data.locationID );
						var stock = getStockService().getStockBySkuAndLocation( sku, location );
						
						// Look for the orderItem in the vendorOrder
						for(var oi=1; oi<=arrayLen(arguments.vendorOrder.getVendorOrderItems()); oi++) {
							
							// If the location, sku, cost & estimated arrival are already the same as an item on the order then we can merge them.  Otherwise seperate
							if(arguments.vendorOrder.getVendorOrderItems()[oi].getStock().getLocation().getLocationID() == arguments.data.locationID
								&&
								arguments.vendorOrder.getVendorOrderItems()[oi].getStock().getSku().getSkuID() == thisRecord.skuid
								&&
								coalesce(arguments.vendorOrder.getVendorOrderItems()[oi].getCost(),"") == thisRecord.cost
								&&
								coalesce(arguments.vendorOrder.getVendorOrderItems()[oi].getEstimatedReceivalDateTime(),"") == thisRecord.estimatedReceivalDateTime
								) {
									
								foundItem = true;
								arguments.vendorOrder.getVendorOrderItems()[oi].setQuantity( arguments.vendorOrder.getVendorOrderItems()[oi].getQuantity() + int(thisRecord.quantity) );
							}
						}
						
						if(!foundItem) {
							var vendorOrderItem = new('VendorOrderItem');
					
							vendorOrderItem.populate( thisRecord );
							vendorOrderItem.setStock( stock );
							vendorOrderItem.setVendorOrder( arguments.vendorOrder );	
						}
						
					}
				}
				break;
			
			case 'receiveStock':
			
				var stockReceiver = getStockService().newStockReceiver();
				stockReceiver.setReceiverType("vendorOrder");
				stockReceiver.populate(arguments.data);
				
				stockReceiver.setVendorOrder( arguments.vendorOrder );
				
				var location = getLocationService().getLocation( arguments.data.locationID );
				
				for(var i=1; i<=arrayLen(arguments.data.records); i++) {
					
					var thisRecord = arguments.data.records[i];
					
					if(val(thisRecord.quantity) gt 0) {
						
						var foundItem = false;
						var vendorOrderItem = this.getVendorOrderItem( thisRecord.vendorOrderItemID );
						var stock = getStockService().getStockBySkuAndLocation( vendorOrderItem.getStock().getSku(), location );
						
						var stockreceiverItem = getStockService().newStockReceiverItem();
					
						stockreceiverItem.setQuantity( thisRecord.quantity );
						stockreceiverItem.setStock( stock );
						stockreceiverItem.setVendorOrderItem( vendorOrderItem );
						stockreceiverItem.setStockReceiver( stockReceiver );
						
					}
				}
				
				break;
		}
		
		return arguments.vendorOrder;
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
	
}

<!---

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

--->
<cfcomponent extends="BaseDAO">

	<cfscript>
	
		public any function getStockBySkuAndLocation(required any sku, required any location) {
			return entityLoad("SlatwallStock", {location=arguments.location, sku=arguments.sku}, true);
		}
		
		public any function getStockAdjustmentItemForSku(required any sku, required any stockAdjustment) {
			var params = [arguments.sku.getSkuID(), arguments.stockAdjustment.getStockAdjustmentID()];
			
		 	// Epic hack. In order to find the stockAdjustment Item for this Sku, we don't know if it will be in the fromStock or toStock, so try them both.
			var hql = " SELECT i
						FROM SlatwallStockAdjustmentItem i
						WHERE i.fromStock.sku.skuID = ? 
						AND i.stockAdjustment.stockAdjustmentID = ? ";
		
			var stockAdjustmentItem =  ormExecuteQuery(hql, params, true);
			
			if(!isNull(stockAdjustmentItem)) {
				return stockAdjustmentItem;
			}
			
			var hql = " SELECT i
						FROM SlatwallStockAdjustmentItem i
						WHERE i.toStock.sku.skuID = ? 
						AND i.stockAdjustment.stockAdjustmentID = ? ";
		
			var stockAdjustmentItem = ormExecuteQuery(hql, params, true);
			
			if(!isNull(stockAdjustmentItem)) {
				return stockAdjustmentItem;
			} else {
				// Return void
				return;
			}
	
		}
		
		public array function getEstimatedReceival(required string productID) {
			var params = [arguments.productID];
			
			var hql = "SELECT NEW MAP(
							vendorOrder.estimatedReceivalDateTime as orderEstimatedReceival,
							vendorOrderItem.estimatedReceivalDateTime as orderItemEstimatedReceival,
							vendorOrderItem.quantity as orderedQuantity,
							(SELECT coalesce( sum(stockReceiverItem.quantity), 0 ) FROM SlatwallStockReceiverItem stockReceiverItem WHERE stockReceiverItem.vendorOrderItem.vendorOrderItemID = vendorOrderItem.vendorOrderItemID) as receivedQuantity,
							vendorOrderItem.stock.sku.skuID as skuID,
							vendorOrderItem.stock.stockID as stockID,
							vendorOrderItem.stock.location.locationID as locationID,
							vendorOrderItem.stock.sku.product.productID as productID)
						FROM
							SlatwallVendorOrderItem vendorOrderItem
						  INNER JOIN
						  	vendorOrderItem.vendorOrder vendorOrder
						  INNER JOIN
						  	vendorOrderItem.stock stock
						  INNER JOIN
						  	stock.sku sku
						  INNER JOIN
						  	sku.product product
						WHERE
							vendorOrder.vendorOrderStatusType.systemCode != 'ostClosed'
						  AND
						  	vendorOrder.vendorOrderType.systemCode = 'votPurchaseOrder'
						  AND
							product.productID = ?
						  AND
						  	(vendorOrderItem.estimatedReceivalDateTime IS NOT NULL OR vendorOrder.estimatedReceivalDateTime IS NOT NULL)
						  AND
							(SELECT coalesce( sum(sri.quantity), 0 ) FROM SlatwallStockReceiverItem sri INNER JOIN sri.vendorOrderItem voi WHERE voi.vendorOrderItemID = vendorOrderItem.vendorOrderItemID) < vendorOrderItem.quantity
						";
			
			return ormExecuteQuery(hql, params);
		}
	
	</cfscript>
</cfcomponent>
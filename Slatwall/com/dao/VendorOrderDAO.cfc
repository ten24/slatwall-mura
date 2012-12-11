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
component extends="BaseDAO" {

	public any function isProductInVendorOrder(productId, vendorOrderId) {
		var params = [arguments.productId, arguments.vendorOrderId];				
		var hql = " SELECT  o 
					FROM SlatwallVendorOrder o
					INNER JOIN o.vendorOrderItems i
					INNER JOIN i.stock s
					INNER JOIN s.sku sk
					INNER JOIN sk.product p
					WHERE p.productID = ?    
					AND o.vendorOrderID = ?			";
	
		return !isNull(ormExecuteQuery(hql, params, true));	
	}	
	
	/*public numeric function getQuantityOfStockAlreadyOnOrder(required any vendorOrderID, required any stockID) {
		var params = [arguments.vendorOrderID, arguments.stockID];	

		var hql = " SELECT new map(sum(sri.quantity) as quantity)
					FROM SlatwallStockReceiverItem sri
					WHERE sri.stockReceiver.vendorOrder.vendorOrderID = ?    
					AND sri.stock.stockID = ?                ";
	
		var result = ormExecuteQuery(hql, params);
		
		
		if(!structKeyExists(result[1], "quantity")) {
			return 0;
		} else {
			return result[1]["quantity"];
		}
	}*/
	
	public numeric function getQuantityOfStockAlreadyOnOrder(required any vendorOrderID, required any skuID, required any locationID) {
		var params = [arguments.vendorOrderID, arguments.skuID, arguments.locationID];	
		var hql = " SELECT new map(sum(voi.quantity) as quantity)
					FROM SlatwallVendorOrderItem voi
					WHERE voi.vendorOrder.vendorOrderID = ?
					AND voi.stock.sku.skuID = ?    
					AND voi.stock.location.locationID = ?                ";
	
		var result = ormExecuteQuery(hql, params);

		if(!structKeyExists(result[1], "quantity")) {
			return 0;
		} else {
			return result[1]["quantity"];
		}
	}
	
	public numeric function getQuantityOfStockAlreadyReceived(required any vendorOrderID, required any skuID, required any locationID) {
		var params = [arguments.vendorOrderID, arguments.skuID, arguments.locationID];	
		var hql = " SELECT new map(sum(sri.quantity) as quantity)
					FROM SlatwallStockReceiverItem sri
					WHERE sri.stockReceiver.vendorOrder.vendorOrderID = ?    
					AND sri.stock.sku.skuID = ?  
					AND sri.stock.location.locationID = ?                 ";
	
		var result = ormExecuteQuery(hql, params);

		if(!structKeyExists(result[1], "quantity")) {
			return 0;
		} else {
			return result[1]["quantity"];
		}
	}
	
	public array function getSkusOrdered(required any vendorOrderID) {
		var params = [arguments.vendorOrderID];           
		var hql = " SELECT distinct sk
					FROM SlatwallSku sk, SlatwallVendorOrder vo
					INNER JOIN vo.vendorOrderItems voi
					INNER JOIN voi.stock s
					WHERE s.sku.skuID = sk.skuID
					AND vo.vendorOrderID = ?
					                ";              
	
		var result = ormExecuteQuery(hql, params);

		return result;
	}
	
	
}

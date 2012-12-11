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
component displayname="Order Delivery" entityname="SlatwallOrderDelivery" table="SlatwallOrderDelivery" persistent="true" accessors="true" output="false" extends="BaseEntity" {
	
	// Persistent Properties
	property name="orderDeliveryID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="trackingNumber" ormtype="string";
	
	// Related Object Properties (Many-To-One)
	property name="order" cfc="Order" fieldtype="many-to-one" fkcolumn="orderID";
	property name="location" cfc="Location" fieldtype="many-to-one" fkcolumn="locationID";
	property name="fulfillmentMethod" cfc="FulfillmentMethod" fieldtype="many-to-one" fkcolumn="fulfillmentMethodID";
	property name="shippingMethod" cfc="ShippingMethod" fieldtype="many-to-one" fkcolumn="shippingMethodID";
	property name="shippingAddress" cfc="Address" fieldtype="many-to-one" fkcolumn="shippingAddressID";
	
	// Related Object Properties (One-To-Many)
	property name="orderDeliveryItems" singularname="orderDeliveryItem" cfc="OrderDeliveryItem" fieldtype="one-to-many" fkcolumn="orderDeliveryID" cascade="all-delete-orphan" inverse="true";
	
	// Remote properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties
	property name="totalQuantityDelivered" persistent="false" type="numeric" formatType="numeric";
	
	public any function getTotalQuantityDelivered() {
		var totalDelivered = 0;
		for(var i=1; i<=arrayLen(getOrderDeliveryItems()); i++) {
			totalDelivered += getOrderDeliveryItems()[i].getQuantity();
		}
		return totalDelivered;
	}
   
    // ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// Order (many-to-one)
	public void function setOrder(required any order) {
		variables.order = arguments.order;
		if(isNew() or !arguments.order.hasOrderDelivery( this )) {
			arrayAppend(arguments.order.getOrderDeliveries(), this);
		}
	}
	public void function removeOrder(any order) {
		if(!structKeyExists(arguments, "order")) {
			arguments.order = variables.order;
		}
		var index = arrayFind(arguments.order.getOrderDeliveries(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.order.getOrderDeliveries(), index);
		}
		structDelete(variables, "order");
	}
	
	// Order Delivery Items (one-to-many)
	public void function addOrderDeliveryItem(required any orderDeliveryItem) {
		arguments.orderDeliveryItem.setOrderDelivery( this );
	}
	public void function removeOrderDeliveryItem(required any orderDeliveryItem) {
		arguments.orderDeliveryItem.removeOrderDelivery( this );
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentation() {
		return "Delivery for - " & getOrder().getOrderNumber();
	}
	
	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}

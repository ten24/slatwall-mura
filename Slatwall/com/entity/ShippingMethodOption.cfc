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
component displayname="Shipping Method Option" entityname="SlatwallShippingMethodOption" table="SlatwallShippingMethodOption" persistent=true accessors=true output=false extends="BaseEntity" {

	// Persistent Properties
	property name="shippingMethodOptionID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="totalCharge" ormtype="big_decimal";
	property name="currencyCode" ormtype="string" length="3";
	property name="totalShippingWeight" ormtype="string";
	property name="totalShippingItemPrice" ormtype="string";
	property name="shipToPostalCode" ormtype="string";
	property name="shipToStateCode" ormtype="string";
	property name="shipToCountryCode" ormtype="string";
	property name="shipToCity" ormtype="string";

	// Related Object Properties (many-To-one)
	property name="shippingMethodRate" cfc="ShippingMethodRate" fieldtype="many-to-one" fkcolumn="shippingMethodRateID";
	property name="orderFulfillment" cfc="OrderFulfillment" fieldtype="many-to-one" fkcolumn="orderFulfillmentID";
	
	// Related Object Properties (one-to-many)
	
	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)
	
	// Audit Properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	
	// Non-Persistent Properties
	property name="discountAmountDetails" persistent="false";
	property name="totalChargeAfterDiscount" persistent="false" formatType="currency";
	
	public struct function getDiscountAmountDetails() {
		if(!structKeyExists(variables, "discountAmountDetails")) {
			variables.discountAmountDetails = getService("promotionService").getShippingMethodOptionsDiscountAmountDetails(shippingMethodOption=this);
		}
		return variables.discountAmountDetails;
	}
	
	public numeric function getDiscountAmount() {
		return getDiscountAmountDetails().discountAmount;
	}
	
	public numeric function getTotalChargeAfterDiscount() {
		return precisionEvaluate(getTotalCharge() - getDiscountAmount());
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Order Fulfillment (many-to-one)
	public void function setOrderFulfillment(required any orderFulfillment) {
		variables.orderFulfillment = arguments.orderFulfillment;
		if(isNew() or !arguments.orderFulfillment.hasfulfillmentShippingMethodOption( this )) {
			arrayAppend(arguments.orderFulfillment.getfulfillmentShippingMethodOptions(), this);
		}
	}
	public void function removeOrderFulfillment(any orderFulfillment) {
		if(!structKeyExists(arguments, "orderFulfillment")) {
			arguments.orderFulfillment = variables.orderFulfillment;
		}
		var index = arrayFind(arguments.orderFulfillment.getfulfillmentShippingMethodOptions(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.orderFulfillment.getfulfillmentShippingMethodOptions(), index);
		}
		structDelete(variables, "orderFulfillment");
	}

	// Shipping Method Rate (many-to-one)
	public void function setShippingMethodRate(required any shippingMethodRate) {
		variables.shippingMethodRate = arguments.shippingMethodRate;
		if(isNew() or !arguments.shippingMethodRate.hasShippingMethodOption( this )) {
			arrayAppend(arguments.shippingMethodRate.getShippingMethodOptions(), this);
		}
	}
	public void function removeShippingMethodRate(any shippingMethodRate) {
		if(!structKeyExists(arguments, "shippingMethodRate")) {
			arguments.shippingMethodRate = variables.shippingMethodRate;
		}
		var index = arrayFind(arguments.shippingMethodRate.getShippingMethodOptions(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.shippingMethodRate.getShippingMethodOptions(), index);
		}
		structDelete(variables, "shippingMethodRate");
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}
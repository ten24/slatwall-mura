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
component displayname="Shipping Method" entityname="SlatwallShippingMethod" table="SlatwallShippingMethod" persistent=true output=false accessors=true extends="BaseEntity" {
	
	// Persistent Properties
	property name="shippingMethodID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="activeFlag" ormtype="boolean";
	property name="shippingMethodName" ormtype="string";
	property name="sortOrder" ormtype="integer" sortContext="fulfillmentMethod";
	
	// Related Object Properties (many-to-one)
	property name="fulfillmentMethod" cfc="FulfillmentMethod" fieldtype="many-to-one" fkcolumn="fulfillmentMethodID";
	
	// Related Object Properties (one-to-many)
	property name="shippingMethodRates" singularname="shippingMethodRate" cfc="ShippingMethodRate" fieldtype="one-to-many" fkcolumn="shippingMethodID" inverse="true" cascade="all-delete-orphan";
	property name="orderFulfillments" singularname="orderFulfillment" cfc="OrderFulfillment" fieldtype="one-to-many" fkcolumn="shippingMethodID" inverse="true" lazy="extra";
	
	// Related Object Properties (many-to-many - owner)
	
	// Related Object Properties (many-to-many - inverse)
	property name="promotionRewards" singularname="promotionReward" cfc="PromotionReward" fieldtype="many-to-many" linktable="SlatwallPromotionRewardShippingMethod" fkcolumn="shippingMethodID" inversejoincolumn="promotionRewardID" inverse="true";
	property name="promotionQualifiers" singularname="promotionQualifier" cfc="PromotionQualifier" fieldtype="many-to-many" linktable="SlatwallPromotionQualifierShippingMethod" fkcolumn="shippingMethodID" inversejoincolumn="promotionQualifierID" inverse="true";

	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	


	public array function getShippingMethodRateIntegrationOptions() {
		var optionsSL = getService("integrationService").getIntegrationSmartList();
		optionsSL.addFilter('shippingActiveFlag', '1');
		optionsSL.addSelect('integrationName', 'name');
		optionsSL.addSelect('integrationID', 'value');
		return optionsSL.getRecords();
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Promotion Qualifiers (many-to-many - inverse)    
	public void function addPromotionQualifier(required any promotionQualifier) {    
		arguments.promotionQualifier.addShippingMethod( this );    
	}    
	public void function removePromotionQualifier(required any promotionQualifier) {    
		arguments.promotionQualifier.removeShippingMethod( this );    
	}
	
	// Promotion Rewards (many-to-many - inverse)    
	public void function addPromotionReward(required any promotionReward) {    
		arguments.promotionReward.addShipppingMethod( this );    
	}    
	public void function removePromotionReward(required any promotionReward) {    
		arguments.promotionReward.removeShipppingMethod( this );    
	}
	
	// Shipping Method Rates (one-to-many)    
	public void function addShippingMethodRate(required any shippingMethodRate) {    
		arguments.shippingMethodRate.setShippingMethod( this );    
	}    
	public void function removeShippingMethodRate(required any shippingMethodRate) {    
		arguments.shippingMethodRate.removeShippingMethod( this );    
	}
	
	// Fulfillment Method (many-to-one)
	public void function setFulfillmentMethod(required any fulfillmentMethod) {
		variables.fulfillmentMethod = arguments.fulfillmentMethod;
		if(isNew() or !arguments.fulfillmentMethod.hasShippingMethod( this )) {
			arrayAppend(arguments.fulfillmentMethod.getShippingMethods(), this);
		}
	}
	public void function removeFulfillmentMethod(any fulfillmentMethod) {
		if(!structKeyExists(arguments, "fulfillmentMethod")) {
			arguments.fulfillmentMethod = variables.fulfillmentMethod;
		}
		var index = arrayFind(arguments.fulfillmentMethod.getShippingMethods(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.fulfillmentMethod.getShippingMethods(), index);
		}
		structDelete(variables, "fulfillmentMethod");
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}

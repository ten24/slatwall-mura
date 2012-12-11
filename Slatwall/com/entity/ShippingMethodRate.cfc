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
component displayname="Shipping Method Rate" entityname="SlatwallShippingMethodRate" table="SlatwallShippingMethodRate" persistent=true output=false accessors=true extends="BaseEntity" {
	
	// Persistent Properties
	property name="shippingMethodRateID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="sortOrder" ormtype="int" sortContext="shippingMethod";
	property name="minimumShipmentWeight" ormtype="int";
	property name="maximumShipmentWeight" ormtype="int";
	property name="minimumShipmentItemPrice" ormtype="big_decimal";
	property name="maximumShipmentItemPrice" ormtype="big_decimal";
	property name="defaultAmount" ormtype="big_decimal" formatType="custom";
	property name="shippingIntegrationMethod" ormtype="string";
	
	// Related Object Properties (many-to-one)
	property name="shippingIntegration" cfc="Integration" fieldtype="many-to-one" fkcolumn="shippingIntegrationID";
	property name="shippingMethod" cfc="ShippingMethod" fieldtype="many-to-one" fkcolumn="shippingMethodID";
	property name="addressZone" cfc="AddressZone" fieldtype="many-to-one" fkcolumn="addressZoneID";
	
	// Related Object Properties (one-to-many)
	property name="shippingMethodOptions" singularname="shippingMethodOption" cfc="ShippingMethodOption" type="array" fieldtype="one-to-many" fkcolumn="shippingMethodRateID" cascade="all-delete-orphan" inverse="true";
	
	// Related Object Properties (many-to-many - owner)
	
	// Related Object Properties (many-to-many - inverse)
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non Persistent
	property name="shippingIntegrationMethodOptions" type="array" persistent="false";
	property name="addressZoneOptions" type="array" persistent="false";
	property name="shipmentWeightRange" type="string" persistent="false";
	property name="shipmentItemPriceRange" type="string" persistent="false";
	property name="shippingMethodRateName" type="string" persistent="false";
	
	
	// ============ START: Non-Persistent Property Methods =================
	
	public array function getAddressZoneOptions() {
		if(!structKeyExists(variables, "addressZoneOptions")) {
			var smartList = new Slatwall.com.utility.SmartList(entityName="SlatwallAddressZone");
			smartList.addSelect(propertyIdentifier="addressZoneName", alias="name");
			smartList.addSelect(propertyIdentifier="addressZoneID", alias="value"); 
			smartList.addOrder("addressZoneName|ASC");
			variables.addressZoneOptions = smartList.getRecords();
			arrayPrepend(variables.addressZoneOptions, {value="", name=rbKey('define.all')});
		}
		return variables.addressZoneOptions;
	}
	
	public string function getShipmentWeightRange() {
		if(!structKeyExists(variables, "shipmentWeightRange")) {
			variables.shipmentWeightRange = "";
			
			var lower = 0;
			var upper = 0;
			
			if(!isNull(getMinimumShipmentWeight()) && getMinimumShipmentWeight() gt 0) {
				lower = getMinimumshipmentWeight();
			}
			
			if(!isNull(getMaximumShipmentWeight()) && getMaximumShipmentWeight() gt 0) {
				upper = getMaximumShipmentWeight();
			}
			
			if(lower == 0 && upper == 0) {
				variables.shipmentWeightRange = rbKey('define.any');
			} else {
				variables.shipmentWeightRange = formatValue(lower, "weight") & " - ";
				if(upper gt 0) {
					variables.shipmentWeightRange &= formatValue(upper, "weight");
				} else {
					variables.shipmentWeightRange &= rbKey('define.any');
				}
			}
		}
		return variables.shipmentWeightRange;
	}
		
	public string function getShipmentItemPriceRange() {
		if(!structKeyExists(variables, "shipmentItemPriceRange")) {
			variables.shipmentItemPriceRange = "";
			var lower = 0;
			var upper = 0;
			
			if(!isNull(getMinimumShipmentItemPrice()) && getMinimumShipmentItemPrice() gt 0) {
				lower = getMinimumShipmentItemPrice();
			}
			
			if(!isNull(getMaximumShipmentItemPrice()) && getMaximumShipmentItemPrice() gt 0) {
				upper = getMaximumShipmentItemPrice();
			}
			
			if(lower == 0 && upper == 0) {
				variables.shipmentItemPriceRange = rbKey('define.any');
			} else {
				variables.shipmentItemPriceRange = formatValue(lower, "currency") & " - ";
				if(upper gt 0) {
					variables.shipmentItemPriceRange &= formatValue(upper, "currency");
				} else {
					variables.shipmentItemPriceRange &= rbKey('define.any');
				}
			}
		}
		return variables.shipmentItemPriceRange;
	}
	
	public string function getShippingMethodRateName() {
		if(!structKeyExists(variables, "shippingMethodRateName")) {
			variables.shippingMethodRateName = "";
			
			var addressZoneName = "#rbKey('define.all')# #rbKey('entity.addressZone_plural')#";
			var shippingMethodName = "";
			
			if(!isNull(getAddressZone())) {
				addressZoneName = getAddressZone().getAddressZoneName();
			}
			
			if( !isNull(getShippingIntegration()) ) {
				var shippingMethodOptions = getShippingIntegration().getShippingMethodOptions();
				for(var i=1; i<=arrayLen(shippingMethodOptions); i++) {
					if(shippingMethodOptions[i]['value'] == getShippingIntegrationMethod()) {
						shippingMethodName = shippingMethodOptions[i]['name'];		
						break;
					}
				}
				
				variables.shippingMethodRateName = "#getShippingIntegration().getIntegrationName()#: #shippingMethodName#";
			} else {
				variables.shippingMethodRateName = "#rbKey('define.manual')#";
			}
		}
		
		return variables.shippingMethodRateName;
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Shipping Method (many-to-one)
	public void function setShippingMethod(required any shippingMethod) {
		variables.shippingMethod = arguments.shippingMethod;
		if(isNew() or !arguments.shippingMethod.hasShippingMethodRate( this )) {
			arrayAppend(arguments.shippingMethod.getShippingMethodRates(), this);
		}
	}
	public void function removeShippingMethod(any shippingMethod) {
		if(!structKeyExists(arguments, "shippingMethod")) {
			arguments.shippingMethod = variables.shippingMethod;
		}
		var index = arrayFind(arguments.shippingMethod.getShippingMethodRates(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.shippingMethod.getShippingMethodRates(), index);
		}
		structDelete(variables, "shippingMethod");
	}
	
	// Shipping Method Options (one-to-many)    
	public void function addShippingMethodOption(required any shippingMethodOption) {    
		arguments.shippingMethodOption.setShippingMethodRate( this );    
	}    
	public void function removeShippingMethodOption(required any shippingMethodOption) {    
		arguments.shippingMethodOption.removeShippingMethodRate( this );    
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	public string function getDefaultAmountFormatted() {
		if(isNull(getDefaultAmount())) {
			return rbKey('define.none');
		}
		return formatValue(getDefaultAmount(), "currency");
	}
	
	// ===============  END: Custom Formatting Methods =====================
	
	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentationPropertyName() {
		return "shippingMethodRateName";
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}
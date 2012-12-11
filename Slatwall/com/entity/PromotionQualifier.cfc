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
component displayname="Promotion Qualifier" entityname="SlatwallPromotionQualifier" table="SlatwallPromotionQualifier" persistent="true" extends="BaseEntity" {
	
	// Persistent Properties
	property name="promotionQualifierID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="qualifierType" ormtype="string" formatType="rbKey";
	
	property name="minimumOrderQuantity" ormtype="integer" formatType="custom";
	property name="maximumOrderQuantity" ormtype="integer" formatType="custom";
	property name="minimumOrderSubtotal" ormtype="big_decimal" formatType="custom";
	property name="maximumOrderSubtotal" ormtype="big_decimal" formatType="custom";
	property name="minimumItemQuantity" ormtype="integer" formatType="custom";
	property name="maximumItemQuantity" ormtype="integer" formatType="custom";
	property name="minimumItemPrice" ormtype="big_decimal" formatType="custom";
	property name="maximumItemPrice" ormtype="big_decimal" formatType="custom";
	property name="minimumFulfillmentWeight" ormtype="big_decimal" formatType="custom";
	property name="maximumFulfillmentWeight" ormtype="big_decimal" formatType="custom";
	property name="rewardMatchingType" ormtype="string" formatType="rbKey" formFieldType="select";
	
	// Related Entities (many-to-one)
	property name="promotionPeriod" cfc="PromotionPeriod" fieldtype="many-to-one" fkcolumn="promotionPeriodID";
	
	// Related Entities (one-to-many)
	
	// Related Entities (many-to-many - owner)
	property name="fulfillmentMethods" singularname="fulfillmentMethod" cfc="FulfillmentMethod" fieldtype="many-to-many" linktable="SlatwallPromotionQualifierFulfillmentMethod" fkcolumn="promotionQualifierID" inversejoincolumn="fulfillmentMethodID";
	property name="shippingMethods" singularname="shippingMethod" cfc="ShippingMethod" fieldtype="many-to-many" linktable="SlatwallPromotionQualifierShippingMethod" fkcolumn="promotionQualifierID" inversejoincolumn="shippingMethodID";
	property name="shippingAddressZones" singularname="shippingAddressZone" cfc="AddressZone" fieldtype="many-to-many" linktable="SlatwallPromotionQualifierShippingAddressZone" fkcolumn="promotionQualifierID" inversejoincolumn="addressZoneID";
	
	property name="brands" singularname="brand" cfc="Brand" fieldtype="many-to-many" linktable="SlatwallPromotionQualifierBrand" fkcolumn="promotionQualifierID" inversejoincolumn="brandID";
	property name="options" singularname="option" cfc="Option" fieldtype="many-to-many" linktable="SlatwallPromotionQualifierOption" fkcolumn="promotionQualifierID" inversejoincolumn="optionID";
	property name="skus" singularname="sku" cfc="Sku" fieldtype="many-to-many" linktable="SlatwallPromotionQualifierSku" fkcolumn="promotionQualifierID" inversejoincolumn="skuID";
	property name="products" singularname="product" cfc="Product" fieldtype="many-to-many" linktable="SlatwallPromotionQualifierProduct" fkcolumn="promotionQualifierID" inversejoincolumn="productID";
	property name="productTypes" singularname="productType" cfc="ProductType" fieldtype="many-to-many" linktable="SlatwallPromotionQualifierProductType" fkcolumn="promotionQualifierID" inversejoincolumn="productTypeID";
	
	property name="excludedBrands" singularname="excludedBrand" cfc="Brand" type="array" fieldtype="many-to-many" linktable="SlatwallPromotionQualifierExcludedBrand" fkcolumn="promotionQualifierID" inversejoincolumn="brandID";
	property name="excludedOptions" singularname="excludedOption" cfc="Option" type="array" fieldtype="many-to-many" linktable="SlatwallPromotionQualifierExcludedOption" fkcolumn="promotionQualifierID" inversejoincolumn="optionID";
	property name="excludedSkus" singularname="excludedSku" cfc="Sku" fieldtype="many-to-many" linktable="SlatwallPromotionQualifierExcludedSku" fkcolumn="promotionQualifierID" inversejoincolumn="skuID";
	property name="excludedProducts" singularname="excludedProduct" cfc="Product" fieldtype="many-to-many" linktable="SlatwallPromotionQualifierExcludedProduct" fkcolumn="promotionQualifierID" inversejoincolumn="productID";
	property name="excludedProductTypes" singularname="excludedProductType" cfc="ProductType" fieldtype="many-to-many" linktable="SlatwallPromotionQualifierExcludedProductType" fkcolumn="promotionQualifierID" inversejoincolumn="productTypeID";
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";

	// Non-persistent entities
	property name="qualifierApplicationTypeOptions" type="array" persistent="false";
	
	// ============ START: Non-Persistent Property Methods =================
	
	public array function getRewardMatchingTypeOptions() {
		return [
			{name=rbKey('entity.promotionQualifier.rewardMatchingType.any'), value="any"},
			{name=rbKey('entity.promotionQualifier.rewardMatchingType.sku'), value="sku"},
			{name=rbKey('entity.promotionQualifier.rewardMatchingType.product'), value="product"},
			{name=rbKey('entity.promotionQualifier.rewardMatchingType.productType'), value="productType"},
			{name=rbKey('entity.promotionQualifier.rewardMatchingType.brand'), value="brand"}
		];
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Promotion Period (many-to-one)
	public void function setPromotionPeriod(required any promotionPeriod) {
		variables.promotionPeriod = arguments.promotionPeriod;
		if(isNew() or !arguments.promotionPeriod.hasPromotionQualifier( this )) {
			arrayAppend(arguments.promotionPeriod.getPromotionQualifiers(), this);
		}
	}
	public void function removePromotionPeriod(any promotionPeriod) {
		if(!structKeyExists(arguments, "promotionPeriod")) {
			arguments.promotionPeriod = variables.promotionPeriod;
		}
		var index = arrayFind(arguments.promotionPeriod.getPromotionQualifiers(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.promotionPeriod.getPromotionQualifiers(), index);
		}
		structDelete(variables, "promotionPeriod");
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	public any function getMinimumOrderQuantityFormatted() {
		if(isNull(getMinimumOrderQuantity()) || !isNumeric(getMinimumOrderQuantity()) || getMinimumOrderQuantity() == 0) {
			return 0;
		}
		return getMinimumOrderQuantity();
	}
	
	public any function getMaximumOrderQuantityFormatted() {
		if(isNull(getMaximumOrderQuantity()) || !isNumeric(getMaximumOrderQuantity()) || getMaximumOrderQuantity() == 0) {
			return rbKey('define.unlimited');
		}
		return getMaximumOrderQuantity();
	}
	
	public any function getMinimumOrderSubtotalFormatted() {
		if(isNull(getMinimumOrderSubtotal()) || !isNumeric(getMinimumOrderSubtotal()) || getMinimumOrderSubtotal() == 0) {
			return formatValue(0, "currency");
		}
		return formatValue(getMinimumOrderSubtotal(), "currency");
	}
	
	public any function getMaximumOrderSubtotalFormatted() {
		if(isNull(getMaximumOrderSubtotal()) || !isNumeric(getMaximumOrderSubtotal()) || getMaximumOrderSubtotal() == 0) {
			return rbKey('define.unlimited');
		}
		return formatValue(getMaximumOrderSubtotal(), "currency");
	}

	public any function getMinimumItemQuantityFormatted() {
		if(isNull(getMinimumItemQuantity()) || !isNumeric(getMinimumItemQuantity()) || getMinimumItemQuantity() == 0) {
			return 0;
		}
		return getMinimumItemQuantity();
	}
	
	public any function getMaximumItemQuantityFormatted() {
		if(isNull(getMaximumItemQuantity()) || !isNumeric(getMaximumItemQuantity()) || getMaximumItemQuantity() == 0) {
			return rbKey('define.unlimited');
		}
		return getMaximumItemQuantity();
	}

	public any function getMinimumItemPriceFormatted() {
		if(isNull(getMinimumItemPrice()) || !isNumeric(getMinimumItemPrice()) || getMinimumItemPrice() == 0) {
			return formatValue(0, "currency");
		}
		return formatValue(getMinimumItemPrice(), "currency");
	}
	
	public any function getMaximumItemPriceFormatted() {
		if(isNull(getMinimumItemPrice()) || !isNumeric(getMinimumItemPrice()) || getMinimumItemPrice() == 0) {
			return rbKey('define.unlimited');
		}
		return formatValue(getMinimumItemPrice(), "currency");
	}
	
	public any function getMinimumFulfillmentWeightFormatted() {
		if(isNull(getMinimumFulfillmentWeight()) || !isNumeric(getMinimumFulfillmentWeight()) || getMinimumFulfillmentWeight() == 0) {
			return formatValue(0, "weight");
		}
		return formatValue(getMinimumFulfillmentWeight(), "weight");
	}
	
	public any function getMaximumFulfillmentWeightFormatted() {
		if(isNull(getMaximumFulfillmentWeight()) || !isNumeric(getMaximumFulfillmentWeight()) || getMaximumFulfillmentWeight() == 0) {
			return rbKey('define.unlimited');
		}
		return formatValue(getMaximumFulfillmentWeight(), "weight");
	}
	
	// ===============  END: Custom Formatting Methods =====================
	
	// ============== START: Overridden Implicet Getters ===================
	
	// ==============  END: Overridden Implicet Getters ====================

	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentationPropertyName() {
		return "qualifierType";
	}
	
	public boolean function isDeletable() {
		return !getPromotionPeriod().isExpired() && getPromotionPeriod().getPromotion().isDeletable();
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================
	
}
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
component displayname="Setting" entityname="SlatwallSetting" table="SlatwallSetting" persistent="true" accessors="true" output="false" extends="BaseEntity" {
	
	// Persistent Properties
	property name="settingID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="settingName" ormtype="string";
	property name="settingValue" ormtype="string";
	
	// Non-Constrained related entity
	property name="cmsContentID" ormtype="string";
	
	// Related Object Properties (many-to-one)
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="brand" cfc="Brand" fieldtype="many-to-one" fkcolumn="brandID";
	property name="content" cfc="Content" fieldtype="many-to-one" fkcolumn="contentID";
	property name="fulfillmentMethod" cfc="FulfillmentMethod" fieldtype="many-to-one" fkcolumn="fulfillmentMethodID"; 
	property name="product" cfc="Product" fieldtype="many-to-one" fkcolumn="productID" cascadeCalculate="true";
	property name="productType" cfc="ProductType" fieldtype="many-to-one" fkcolumn="productTypeID";
	property name="sku" cfc="Sku" fieldtype="many-to-one" fkcolumn="skuID";
	property name="shippingMethod" cfc="ShippingMethod" fieldtype="many-to-one" fkcolumn="shippingMethodID";
	property name="shippingMethodRate" cfc="ShippingMethodRate" fieldtype="many-to-one" fkcolumn="shippingMethodRateID";
	property name="paymentMethod" cfc="PaymentMethod" fieldtype="many-to-one" fkcolumn="paymentMethodID";
	property name="email" cfc="Email" fieldtype="many-to-one" fkcolumn="emailID";
	property name="emailTemplate" cfc="EmailTemplate" fieldtype="many-to-one" fkcolumn="emailTemplateID";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";

	public struct function getSettingMetaData() {
		return getService("settingService").getSettingMetaData(settingName=getSettingName());
	}

	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================
	
	public string function getPropertyFieldType(required string propertyName) {
		if(propertyName == "settingValue") {
			return getService("settingService").getSettingMetaData(getSettingName()).fieldType;	
		}
		return super.getPropertyFieldType(propertyName=arguments.propertyName);
	}
	
	public string function getPropertyTitle(required string propertyName) {
		if(propertyName == "settingValue") {
			
			if(left(getSettingName(), 11) == "integration") {
				for(var settingName in getService("integrationService").getAllSettings()) {
					if(settingName == getSettingName()) {
						return getService("integrationService").getAllSettings()[settingName].displayName;
					}
				}
			}
			
			return rbKey('setting.#getSettingName()#');
		}
		return super.getPropertyTitle(propertyName=arguments.propertyName);
	}

	public array function getSettingValueOptions() {
		return getService("settingService").getSettingOptions(getSettingName());
	}
	
	public any function getSettingValueOptionsSmartList() {
		return getService("settingService").getSettingOptionsSmartList(getSettingName());	
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	public void function preInsert() {
		getService("settingService").clearAllSettingsQuery();
	}
	
	public void function preUpdate(struct oldData) {
		getService("settingService").clearAllSettingsQuery();
	}
	
	public void function preDelete() {
		getService("settingService").clearAllSettingsQuery();
	}
	
	// ===================  END:  ORM Event Hooks  =========================
}
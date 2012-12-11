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
component displayname="Integration" entityname="SlatwallIntegration" table="SlatwallIntegration" persistent=true output=false accessors=true extends="BaseEntity" {
	
	// Persistent Properties
	property name="integrationID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="integrationPackage" ormtype="string" unique="true";
	property name="integrationName" ormtype="string";
	property name="installedFlag" ormtype="boolean";
	
	property name="customReadyFlag" ormtype="boolean";
	property name="customActiveFlag" ormtype="boolean";
	property name="fw1ReadyFlag" ormtype="boolean";
	property name="fw1ActiveFlag" ormtype="boolean";
	property name="paymentReadyFlag" ormtype="boolean";
	property name="paymentActiveFlag" ormtype="boolean";
	property name="shippingReadyFlag" ormtype="boolean";
	property name="shippingActiveFlag" ormtype="boolean";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	
	public array function getShippingMethodOptions( ) {
		if(!structKeyExists(variables, "shippingMethodOptions")) {
			variables.shippingMethodOptions = [];
			var shippingMethodsStruct = getService("integrationService").getShippingIntegrationCFC( this ).getShippingMethods();
			for(var key in shippingMethodsStruct) {
				arrayAppend(variables.shippingMethodOptions, {name=shippingMethodsStruct[key], value=key});
			}
		}
		return variables.shippingMethodOptions;
	}
	
	
	public any function getIntegrationCFC( string integrationType="" ) {
		switch (arguments.integrationType) {
			case "payment" : {
				return getService("integrationService").getPaymentIntegrationCFC(this);
				break;
			}
			case "shipping" : {
				return getService("integrationService").getShippingIntegrationCFC(this);
				break;
			}
			default : {
				return getService("integrationService").getIntegrationCFC(this);
			}
		}
	}
	
	public any function getSettings() {
		return getIntegrationCFC().getSettings();
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	public boolean function isDeletable() {
		return false;
	}
	
	// @hint helper function to return a Setting
	public any function setting(required string settingName, array filterEntities=[], formatValue=false) {
		if(structKeyExists(getSettings(), arguments.settingName)) {
			return getService("settingService").getSettingValue(settingName="integration#getIntegrationPackage()##arguments.settingName#", object=this, filterEntities=arguments.filterEntities, formatValue=arguments.formatValue);	
		}
		return super.setting(argumentcollection=arguments);
	}
	
	
	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}

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
component accessors="true" output="false" displayname="UPS" extends="Slatwall.integrationServices.BaseIntegration" implements="Slatwall.integrationServices.IntegrationInterface" {
	
	public any function init() {
		return this;
	}
	
	public string function getIntegrationTypes() {
		return "shipping";
	}
		
	public string function getDisplayName() {
		return "UPS";
	}

	public struct function getSettings() {
		var settings = {
			apiKey = {fieldType="text", displayName="API Key"},
			username = {fieldType="text", displayName="UPS Username"},
			password = {fieldType="password", displayName="UPS Password", encryptValue=true},
			testingFlag = {fieldType="yesno", displayName="Test Mode", defaultValue="1"},
			shipperNumber = {fieldType="text", displayName="Shipper Number"},
			shipFromCity = {fieldType="text", displayName="Shipping From City"},
			shipFromStateCode = {fieldType="text", displayName="Shipping From State Code"},
			shipFromPostalCode = {fieldType="text", displayName="Shipping From Postal Code"},
			shipFromCountryCode = {fieldType="text", displayName="Shipping From Country Code"},
			pickupTypeCode = {fieldType="text", displayName="Pickup Type Code (advanced optional)", defaultValue="03"},
			customerClassificationCode = {fieldType="text", displayName="Customer Classification Code (advanced optional)", defaultValue="04"}
		};
		
		return settings;
	}
}
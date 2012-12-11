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
component extends="BaseController" output="false" accessors="true" {
	
	// Slatwall Service Injection		
	property name="addressService" type="any";
	property name="attributeService" type="any";
	property name="currencyService" type="any";
	property name="measurementUnitService" type="any";
	property name="productCacheService" type="any";
	property name="scheduleService" type="any";
	property name="settingService" type="any";
	property name="updateService" type="any";
	property name="utilityFileService" type="any";
	
	this.publicMethods='';
	
	this.anyAdminMethods='';
	this.anyAdminMethods=listAppend(this.anyAdminMethods, 'deleteSetting');
	this.anyAdminMethods=listAppend(this.anyAdminMethods, 'detailSetting');
	this.anyAdminMethods=listAppend(this.anyAdminMethods, 'editSetting');
	
	this.secureMethods='';
	this.secureMethods=listAppend(this.secureMethods, 'settings');
	this.secureMethods=listAppend(this.secureMethods, '**addressZone');
	this.secureMethods=listAppend(this.secureMethods, '**addressZoneLocation');
	this.secureMethods=listAppend(this.secureMethods, '**attributeSet');
	this.secureMethods=listAppend(this.secureMethods, '*attribute');
	this.secureMethods=listAppend(this.secureMethods, '*attributeOption');
	this.secureMethods=listAppend(this.secureMethods, '**category');
	this.secureMethods=listAppend(this.secureMethods, '**content');
	this.secureMethods=listAppend(this.secureMethods, '**country');
	this.secureMethods=listAppend(this.secureMethods, '**currency');
	this.secureMethods=listAppend(this.secureMethods, '**email');
	this.secureMethods=listAppend(this.secureMethods, '**emailTemplate');
	this.secureMethods=listAppend(this.secureMethods, '**fulfillmentMethod');
	this.secureMethods=listAppend(this.secureMethods, '**location');
	this.secureMethods=listAppend(this.secureMethods, '**measurementUnit');
	this.secureMethods=listAppend(this.secureMethods, '**orderOrigin');
	this.secureMethods=listAppend(this.secureMethods, '**paymentMethod');
	this.secureMethods=listAppend(this.secureMethods, '**paymentTerm');
	this.secureMethods=listAppend(this.secureMethods, '**roundingRule');
	this.secureMethods=listAppend(this.secureMethods, '**schedule');
	this.secureMethods=listAppend(this.secureMethods, '*shippingMethod');
	this.secureMethods=listAppend(this.secureMethods, '*shippingMethodRate');
	this.secureMethods=listAppend(this.secureMethods, '**task');
	this.secureMethods=listAppend(this.secureMethods, '**taskSchedule');
	this.secureMethods=listAppend(this.secureMethods, 'detailTaskHistory');
	this.secureMethods=listAppend(this.secureMethods, 'processTask');
	this.secureMethods=listAppend(this.secureMethods, 'processTaskSchedule');
	this.secureMethods=listAppend(this.secureMethods, '**taxCategory');
	this.secureMethods=listAppend(this.secureMethods, '*taxCategoryRate');
	this.secureMethods=listAppend(this.secureMethods, '**term');
	this.secureMethods=listAppend(this.secureMethods, '**type');
	
	
	public void function default() {
		getFW().redirect(action="admin:setting.listsetting");
	}
	
	public void function createAddressZoneLocation(required struct rc) {
		editAddressZoneLocation(rc);
	}
	
	public void function editAddressZoneLocation(required struct rc) {
		param name="rc.addressZoneID" default="";
		param name="rc.addressID" default="";
		
		rc.addressZoneLocation = getAddressService().getAddress( rc.addressID, true );
		rc.addressZone = getAddressService().getAddressZone( rc.addressZoneID );
		rc.edit=true;
		
		getFW().setView("admin:setting.detailaddresszonelocation");
	}
	
	public void function deleteAddressZoneLocation(required struct rc) {
		param name="rc.addressZoneID" default="";
		param name="rc.addressID" default="";
		
		rc.addressZoneLocation = getAddressService().getAddress( rc.addressID, true );
		rc.addressZone = getAddressService().getAddressZone( rc.addressZoneID );
		
		rc.addressZone.removeAddressZoneLocation( rc.addressZoneLocation );
		
		getFW().redirect(action="admin:setting.detailaddresszone", queryString="addressZoneID=#rc.addressZoneID#&messageKeys=admin.setting.deleteaddresszonelocation_success");
	}
	
	public void function saveTask(required struct rc){
		
		rc.runningFlag=false;
		
		super.genericSaveMethod('Task',rc);
	}
	
	public void function saveTaskSchedule(required struct rc){
		
		rc.nextRunDateTime = getScheduleService().getSchedule(rc.schedule.scheduleid).getNextRunDateTime(rc.startDateTime,rc.endDateTime); 	
		
		super.genericSaveMethod('TaskSchedule',rc);
	}
	
	public void function editSetting(required struct rc) {
		rc.setting = getSettingService().getSetting(rc.settingID, true);
		rc.edit = true;
		getFW().setView("admin:setting.detailsetting");
	}
	
	public void function editMeasurementUnit(required struct rc) {
		rc.measurementUnit = getMeasurementUnitService().getMeasurementUnit(rc.unitCode);
		rc.edit = true;
		getFW().setView("admin:setting.detailmeasurementunit");
	}
	
	public void function detailMeasurementUnit(required struct rc) {
		rc.measurementUnit = getMeasurementUnitService().getMeasurementUnit(rc.unitCode);
	}
	
	public void function editCountry(required struct rc) {
		rc.country = getAddressService().getCountry(rc.countryCode);
		rc.edit = true;
		getFW().setView("admin:setting.detailcountry");
	}
	
	public void function detailCountry(required struct rc) {
		rc.country = getAddressService().getCountry(rc.countryCode);
	}
	
	public void function editCurrency(required struct rc) {
		rc.currency = getCurrencyService().getCurrency(rc.currencyCode);
		rc.edit = true;
		getFW().setView("admin:setting.detailcurrency");
	}
	
	public void function detailCurrency(required struct rc) {
		rc.currency = getCurrencyService().getCurrency(rc.currencyCode);
	}
	
	// Deprecated Methods
	public void function detailSlatwallUpdate(required struct rc) {
		getFW().redirect(action="admin:main.update");
	}

	public void function updateSlatwall(required struct rc) {
		getFW().redirect(action="admin:main.update");	
	}
	
}

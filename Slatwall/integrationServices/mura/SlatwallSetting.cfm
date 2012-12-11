<!---

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

--->
<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.settingName" type="string" />
	<cfparam name="attributes.settingObject" type="any" default="" />
	<cfparam name="attributes.settingFilterEntities" type="array" default="#arrayNew(1)#" />
	<cfparam name="attributes.settingDetails" type="any" default="" />
	
	<cfif isObject(attributes.settingObject)>
		<cfset attributes.settingDetails = attributes.settingObject.getSettingDetails(settingName=attributes.settingName, filterEntities=attributes.settingFilterEntities) />
	<cfelse>
		<cfset attributes.settingDetails = request.slatwallScope.getService("settingService").getSettingDetails(settingName=attributes.settingName, filterEntities=attributes.settingFilterEntities) />
	</cfif>
	
	<cfset settingMetaData = request.slatwallScope.getService("settingService").getSettingMetaData(attributes.settingName) />
	<cfset value = attributes.settingDetails.settingValue />
	<cfif attributes.settingDetails.settingInherited>
		<cfoutput><input type="hidden" name="#attributes.settingName#Inherited" value="#value#" /></cfoutput>
		<cfset value = "" />
	<cfelse>
		<cfoutput><input type="hidden" name="#attributes.settingName#Inherited" value="" /></cfoutput>
	</cfif>
	<cfset valueOptions = [] />
	<cfset fieldtype = settingMetaData.fieldType />
	<cfif settingMetaData.fieldType EQ "select">
		<cfset valueOptions = request.slatwallScope.getService("settingService").getSettingOptions(attributes.settingName) />
		<cfset arrayPrepend(valueOptions,{name="Inherited (#attributes.settingDetails.settingValue EQ ''?'Not Defined':attributes.settingDetails.settingValueFormatted#)",value=""}) />
	<cfelseif settingMetaData.fieldType EQ "yesno">
		<cfset fieldtype = "radiogroup" />
		<cfset valueOptions = [{name="Yes",value="1"},{name="No",value="0"},{name="Inherited (#attributes.settingDetails.settingValueFormatted#)",value=""}] />
	</cfif>
	<cf_SlatwallFieldDisplay title="#request.slatwallScope.rbKey("setting.#attributes.settingName#_hint")#" fieldName="slatwallData.setting.#attributes.settingName#" fieldType="#fieldtype#" valueOptions="#valueOptions#" value="#value#" edit="true">
</cfif>

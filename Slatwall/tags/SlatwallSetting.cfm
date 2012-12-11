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
	<cfparam name="attributes.settingDisplayName" type="string" default="" />
	<cfparam name="attributes.settingHint" type="string" default="" > 
	
	<cfif isObject(attributes.settingObject)>
		<cfset attributes.settingDetails = attributes.settingObject.getSettingDetails(settingName=attributes.settingName, filterEntities=attributes.settingFilterEntities) />
	<cfelse>
		<cfset attributes.settingDetails = request.slatwallScope.getService("settingService").getSettingDetails(settingName=attributes.settingName, filterEntities=attributes.settingFilterEntities) />
	</cfif>
	
	<cfif left(attributes.settingName, 11) eq "integration">
		<cfloop collection="#attributes.settingObject.getSettings()#" item="simpleSettingName">
			<cfif attributes.settingName eq "integration#attributes.settingObject.getIntegrationPackage()##simpleSettingName#" and structKeyExists(attributes.settingObject.getSettings()[simpleSettingName], "displayName")>
				<cfset attributes.settingDisplayName = attributes.settingObject.getSettings()[simpleSettingName].displayName />
				<cfif structKeyExists(attributes.settingObject.getSettings()[simpleSettingName], "hint")>
					<cfset attributes.settingHint = attributes.settingObject.getSettings()[simpleSettingName].hint />
				</cfif>
			</cfif>
		</cfloop>
	<cfelse>
		<cfset attributes.settingDisplayName = request.slatwallScope.rbKey("setting.#attributes.settingName#") />
		<cfset attributes.settingHint = request.slatwallScope.rbKey("setting.#attributes.settingName#_hint") />
		<cfif right(attributes.settingHint, 8) eq "_missing">
			<cfset attributes.settingHint = "" />
		</cfif>
	</cfif>
	
	<cfassociate basetag="cf_SlatwallSettingTable" datacollection="settings">
</cfif>
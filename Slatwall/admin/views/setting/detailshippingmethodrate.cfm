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
<cfparam name="rc.shippingMethodRate" type="any" />
<cfparam name="rc.shippingMethod" type="any" default="#rc.shippingMethodRate.getShippingMethod()#" />
<cfparam name="rc.integration" type="any" default="" />
<cfparam name="rc.edit" type="boolean" />

<cfif not isNull(rc.shippingMethodRate.getShippingIntegration())>
	<cfset rc.integration = rc.shippingMethodRate.getShippingIntegration() />
</cfif>

<cfoutput>
	<cf_SlatwallDetailForm object="#rc.shippingMethodRate#" edit="#rc.edit#">
		<cf_SlatwallActionBar type="detail" object="#rc.shippingMethodRate#" edit="#rc.edit#" backAction="admin:setting.detailShippingMethod" backQueryString="shippingMethodID=#rc.shippingMethod.getShippingMethodID()#"></cf_SlatwallActionBar>
		
		<cfif rc.edit>
			<input type="hidden" name="shippingMethod.shippingMethodID" value="#rc.shippingMethod.getShippingMethodID()#" />
			<cfif isObject(rc.integration)>
				<input type="hidden" name="shippingIntegration.integrationID" value="#rc.integration.getIntegrationID()#" />
			</cfif>
		</cfif>
		
		<cf_SlatwallDetailHeader>
			<cf_SlatwallPropertyList>
				<cfif isObject(rc.integration)>
					<cf_SlatwallPropertyDisplay object="#rc.shippingMethodRate#" property="shippingIntegration" edit="false" value="#rc.integration.getIntegrationName()#">
					<cf_SlatwallPropertyDisplay object="#rc.shippingMethodRate#" property="shippingIntegrationMethod" edit="#rc.edit#" fieldtype="select" valueOptions="#rc.integration.getShippingMethodOptions(rc.integration.getIntegrationID())#">
				</cfif>
				<cf_SlatwallPropertyDisplay object="#rc.shippingMethodRate#" property="addressZone" edit="#rc.edit#">
				<cf_SlatwallPropertyDisplay object="#rc.shippingMethodRate#" property="minimumShipmentWeight" edit="#rc.edit#">
				<cf_SlatwallPropertyDisplay object="#rc.shippingMethodRate#" property="maximumShipmentWeight" edit="#rc.edit#">
				<cf_SlatwallPropertyDisplay object="#rc.shippingMethodRate#" property="minimumShipmentItemPrice" edit="#rc.edit#">
				<cf_SlatwallPropertyDisplay object="#rc.shippingMethodRate#" property="maximumShipmentItemPrice" edit="#rc.edit#">
				<cf_SlatwallPropertyDisplay object="#rc.shippingMethodRate#" property="defaultAmount" edit="#rc.edit#">
			</cf_SlatwallPropertyList>
		</cf_SlatwallDetailHeader>
		
		<cf_SlatwallTabGroup object="#rc.shippingMethodRate#">
			<cf_SlatwallTab view="admin:setting/shippingmethodratetabs/shippingmethodratesettings" />
		</cf_SlatwallTabGroup>
		
	</cf_SlatwallDetailForm>
</cfoutput>
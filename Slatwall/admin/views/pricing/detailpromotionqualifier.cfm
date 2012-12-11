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
<cfparam name="rc.promotionQualifier" type="any">
<cfparam name="rc.promotionPeriod" type="any" default="#rc.promotionQualifier.getPromotionPeriod()#" />
<cfparam name="rc.qualifierType" type="string" default="#rc.promotionQualifier.getQualifierType()#" />
<cfparam name="rc.edit" type="boolean">

<!--- prevent editing promotion qualifier if its promotion period has expired --->
<cfif rc.edit and rc.promotionperiod.isExpired()>
	<cfset rc.edit = false />
	<cfset arrayAppend(rc.messages,{message=rc.$.slatwall.rbKey('admin.pricing.promotionqualifier.edit_disabled'),messageType="info"}) />
</cfif>

<cfset local.qualifierType = rc.promotionQualifier.getQualifierType() />

<cfoutput>
	<cf_SlatwallDetailForm object="#rc.promotionQualifier#" edit="#rc.edit#">
		<cf_SlatwallActionBar type="detail" object="#rc.promotionQualifier#" edit="#rc.edit#" 
							  cancelAction="admin:pricing.detailpromotionperiod"
							  cancelQueryString="promotionperiodID=#rc.promotionperiod.getpromotionperiodID()###tabpromotionqualifiers" 
							  backAction="admin:pricing.detailpromotionperiod" 
							  backQueryString="promotionperiodID=#rc.promotionperiod.getpromotionperiodID()###tabpromotionqualifiers" />
		
		<input type="hidden" name="qualifierType" value="#rc.qualifierType#" />
		<input type="hidden" name="promotionperiod.promotionperiodID" value="#rc.promotionperiod.getPromotionperiodID()#" />
		
		<cf_SlatwallDetailHeader>
			<cf_SlatwallPropertyList>
				<cfif listFindNoCase("merchandise,subscription,contentaccess", rc.qualifierType)>
					<cf_SlatwallPropertyDisplay object="#rc.promotionQualifier#" property="minimumItemQuantity" edit="#rc.edit#" data-emptyvalue="0" />
					<cf_SlatwallPropertyDisplay object="#rc.promotionQualifier#" property="maximumItemQuantity" edit="#rc.edit#" data-emptyvalue="#$.slatwall.rbKey('define.unlimited')#" />
					<cf_SlatwallPropertyDisplay object="#rc.promotionQualifier#" property="minimumItemPrice" edit="#rc.edit#" data-emptyvalue="0" />
					<cf_SlatwallPropertyDisplay object="#rc.promotionQualifier#" property="maximumItemPrice" edit="#rc.edit#" data-emptyvalue="#$.slatwall.rbKey('define.unlimited')#" />
					<cf_SlatwallPropertyDisplay object="#rc.promotionQualifier#" property="rewardMatchingType" edit="#rc.edit#" />
				<cfelseif rc.qualifierType eq "fulfillment">
					<cf_SlatwallPropertyDisplay object="#rc.promotionQualifier#" property="minimumFulfillmentWeight" edit="#rc.edit#" data-emptyvalue="0" />
					<cf_SlatwallPropertyDisplay object="#rc.promotionQualifier#" property="maximumFulfillmentWeight" edit="#rc.edit#" data-emptyvalue="#$.slatwall.rbKey('define.unlimited')#" />
				<cfelseif rc.qualifierType eq "order">
					<cf_SlatwallPropertyDisplay object="#rc.promotionQualifier#" property="minimumOrderQuantity" edit="#rc.edit#" data-emptyvalue="0" />
					<cf_SlatwallPropertyDisplay object="#rc.promotionQualifier#" property="maximumOrderQuantity" edit="#rc.edit#" data-emptyvalue="#$.slatwall.rbKey('define.unlimited')#" />
					<cf_SlatwallPropertyDisplay object="#rc.promotionQualifier#" property="minimumOrderSubtotal" edit="#rc.edit#" data-emptyvalue="0" />
					<cf_SlatwallPropertyDisplay object="#rc.promotionQualifier#" property="maximumOrderSubtotal" edit="#rc.edit#" data-emptyvalue="#$.slatwall.rbKey('define.unlimited')#" />
				</cfif>
			</cf_SlatwallPropertyList>
		</cf_SlatwallDetailHeader>
		
		<cf_SlatwallTabGroup object="#rc.promotionQualifier#">
			<cfif listFindNoCase("merchandise,subscription,contentaccess", rc.qualifierType)>
				<cf_SlatwallTab view="admin:pricing/promotionqualifiertabs/producttypes" />
				<cf_SlatwallTab view="admin:pricing/promotionqualifiertabs/products" />
				<cf_SlatwallTab view="admin:pricing/promotionqualifiertabs/skus" />
				<cf_SlatwallTab view="admin:pricing/promotionqualifiertabs/brands" />
				<cfif rc.qualifierType eq "merchandise">
					<cf_SlatwallTab view="admin:pricing/promotionqualifiertabs/options" />
				</cfif>
			<cfelseif rc.qualifierType eq "fulfillment">
				<cf_SlatwallTab view="admin:pricing/promotionqualifiertabs/fulfillmentMethods" />
				<cf_SlatwallTab view="admin:pricing/promotionqualifiertabs/shippingMethods" />
				<cf_SlatwallTab view="admin:pricing/promotionqualifiertabs/shippingAddressZones" />
			</cfif>
		</cf_SlatwallTabGroup>
		
	</cf_SlatwallDetailForm>
</cfoutput>
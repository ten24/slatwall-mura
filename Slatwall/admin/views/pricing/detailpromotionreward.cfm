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
<cfparam name="rc.promotionreward" type="any">
<cfparam name="rc.promotionperiod" type="any" default="#rc.promotionreward.getPromotionPeriod()#" />
<cfparam name="rc.rewardType" type="string" default="#rc.promotionReward.getRewardType()#">
<cfparam name="rc.edit" type="boolean">

<!--- prevent editing promotion reward if its promotion period has expired --->
<cfif rc.edit and rc.promotionperiod.isExpired()>
	<cfset rc.edit = false />
	<cfset rc.$.slatwall.showMessageKey('admin.pricing.promotionperiod.editdisabled_info') />
</cfif>
<cfif rc.edit>
	<cfset rc.promotionReward.setRewardType(rc.rewardType) />
</cfif>

<cfoutput>
	<cf_SlatwallDetailForm object="#rc.promotionreward#" edit="#rc.edit#">
		<cf_SlatwallActionBar type="detail" object="#rc.promotionreward#" edit="#rc.edit#" 
							  cancelAction="admin:pricing.detailpromotionperiod"
							  cancelQueryString="promotionperiodID=#rc.promotionperiod.getpromotionperiodID()###tabpromotionrewards" 
							  backAction="admin:pricing.detailpromotionperiod" 
							  backQueryString="promotionperiodID=#rc.promotionperiod.getpromotionperiodID()###tabpromotionrewards" />
		<cf_SlatwallDetailHeader>
			<cf_SlatwallPropertyList>
				<input type="hidden" name="rewardType" value="#rc.rewardType#" />
				<input type="hidden" name="promotionperiod.promotionperiodID" value="#rc.promotionperiod.getPromotionperiodID()#" />
				
				<cf_SlatwallPropertyDisplay object="#rc.promotionreward#" property="amountType" fieldType="select" edit="#rc.edit#" />
				<cf_SlatwallPropertyDisplay object="#rc.promotionreward#" property="amount" edit="#rc.edit#" />
				<cf_SlatwallPropertyDisplay object="#rc.promotionreward#" property="roundingRule" edit="#rc.edit#" />
				
				<cfif listFindNoCase("merchandise,subscription,contentaccess", rc.rewardType)>
					<cfif rc.rewardType eq "subscription">
						<cf_SlatwallPropertyDisplay object="#rc.promotionreward#" property="applicableTerm" edit="#rc.edit#" />
					</cfif>
					<cf_SlatwallPropertyDisplay object="#rc.promotionreward#" property="maximumUsePerOrder" edit="#rc.edit#" data-emptyvalue="#$.slatwall.rbKey('define.unlimited')#" />
					<cf_SlatwallPropertyDisplay object="#rc.promotionreward#" property="maximumUsePerItem" edit="#rc.edit#" data-emptyvalue="#$.slatwall.rbKey('define.unlimited')#" />
					<cf_SlatwallPropertyDisplay object="#rc.promotionreward#" property="maximumUsePerQualification" edit="#rc.edit#" data-emptyvalue="#$.slatwall.rbKey('define.unlimited')#" />
				</cfif>
			</cf_SlatwallPropertyList>
		</cf_SlatwallDetailHeader>
		
		<cf_SlatwallTabGroup object="#rc.promotionreward#">
			<cfif listFindNoCase("merchandise,subscription,contentaccess", rc.rewardType)>
				<cf_SlatwallTab view="admin:pricing/promotionrewardtabs/producttypes" />
				<cf_SlatwallTab view="admin:pricing/promotionrewardtabs/products" />
				<cf_SlatwallTab view="admin:pricing/promotionrewardtabs/skus" />
				<cf_SlatwallTab view="admin:pricing/promotionrewardtabs/brands" />
				<cfif rc.rewardType eq "merchandise">
					<cf_SlatwallTab view="admin:pricing/promotionrewardtabs/options" />
				</cfif>
			<cfelseif rc.rewardType eq "fulfillment">
				<cf_SlatwallTab view="admin:pricing/promotionrewardtabs/fulfillmentMethods" />
				<cf_SlatwallTab view="admin:pricing/promotionrewardtabs/shippingMethods" />
				<cf_SlatwallTab view="admin:pricing/promotionrewardtabs/shippingAddressZones" />
			</cfif>
		</cf_SlatwallTabGroup>

	</cf_SlatwallDetailForm>
</cfoutput>
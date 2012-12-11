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
<cfparam name="rc.promotion" type="any">
<cfparam name="rc.edit" type="boolean">

<cfif arrayLen(rc.promotion.getPromotionPeriods()) eq 1 and !arrayLen(rc.promotion.getPromotionPeriods()[1].getPromotionRewards())>
	<cfset request.slatwallScope.showMessageKey('admin.pricing.detailpromotion.norewards_info') />
</cfif>

<cfoutput>
	<cf_SlatwallDetailForm object="#rc.promotion#" edit="#rc.edit#">
		<cf_SlatwallActionBar type="detail" object="#rc.promotion#" edit="#rc.edit#" />
		
		<cf_SlatwallDetailHeader>
			<cf_SlatwallPropertyList>
				<cf_SlatwallPropertyDisplay object="#rc.Promotion#" property="activeFlag" edit="#rc.edit#">
				<cf_SlatwallPropertyDisplay object="#rc.Promotion#" property="promotionName" edit="#rc.edit#">
				<cfif rc.promotion.isNew()>
					<hr />
					<h4>#$.slatwall.rbKey('admin.pricing.detailpromotion.initialperiod')#</h4><br />
					<cf_SlatwallPropertyDisplay object="#rc.promotionPeriod#" fieldName="promotionPeriods[1].startDateTime" property="startDateTime" edit="#rc.edit#">
					<cf_SlatwallPropertyDisplay object="#rc.promotionPeriod#" fieldName="promotionPeriods[1].endDateTime" property="endDateTime" edit="#rc.edit#">
					<cf_SlatwallPropertyDisplay object="#rc.promotionPeriod#" fieldName="promotionPeriods[1].maximumUseCount" property="maximumUseCount" edit="#rc.edit#" data-emptyvalue="#$.slatwall.rbKey('define.unlimited')#">
					<cf_SlatwallPropertyDisplay object="#rc.promotionPeriod#" fieldName="promotionPeriods[1].maximumAccountUseCount" property="maximumAccountUseCount" edit="#rc.edit#" data-emptyvalue="#$.slatwall.rbKey('define.unlimited')#">
					<input type="hidden" name="promotionPeriods[1].promotionPeriodID" value="#rc.promotionPeriod.getPromotionPeriodID()#" />
				</cfif>
			</cf_SlatwallPropertyList>
		</cf_SlatwallDetailHeader>
		
		<cf_SlatwallTabGroup object="#rc.promotion#">
			<cf_SlatwallTab view="admin:pricing/promotiontabs/promotionperiods" />
			<cf_SlatwallTab view="admin:pricing/promotiontabs/promotioncodes" />
			<cf_SlatwallTab view="admin:pricing/promotiontabs/promotionsummary" />
			<cf_SlatwallTab view="admin:pricing/promotiontabs/promotiondescription" />
		</cf_SlatwallTabGroup>
		
	</cf_SlatwallDetailForm>
</cfoutput>

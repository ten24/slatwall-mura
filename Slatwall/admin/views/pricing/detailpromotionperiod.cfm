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
<cfparam name="rc.promotionperiod" type="any">
<cfparam name="rc.promotion" type="any" default="#rc.promotionPeriod.getPromotion()#">
<cfparam name="rc.edit" type="boolean">

<!--- prevent editing promotion period if it has expired --->
<cfif rc.edit and rc.promotionperiod.isExpired()>
	<cfset rc.edit = false />
	<cfset rc.$.slatwall.showMessageKey('admin.pricing.promotionperiod.editdisabled_info') />
</cfif>

<cfoutput>
	<cf_SlatwallDetailForm object="#rc.promotionperiod#"
						   saveAction="admin:pricing.savepromotionperiod"
						   saveActionQueryString="promotionID=#rc.promotion.getPromotionID()#"
						   edit="#rc.edit#">
						   	   
		<cf_SlatwallActionBar type="detail" object="#rc.promotionPeriod#" edit="#rc.edit#"
							  backAction="admin:pricing.detailpromotion"
							  backQueryString="promotionID=#rc.promotion.getPromotionID()#"
							  cancelAction="admin:pricing.detailpromotion"
							  cancelQueryString="promotionID=#rc.promotion.getPromotionID()#"/>
							  	  
		<input type="hidden" name="promotion.promotionID" value="#rc.promotion.getPromotionID()#" />

		<cf_SlatwallDetailHeader>
			<cf_SlatwallPropertyList>
				<cf_SlatwallPropertyDisplay object="#rc.promotionperiod#" property="startdatetime" edit="#rc.edit#" fieldclass="noautofocus">
				<cf_SlatwallPropertyDisplay object="#rc.promotionperiod#" property="enddatetime" edit="#rc.edit#">
				<cf_SlatwallPropertyDisplay object="#rc.promotionperiod#" property="maximumusecount" edit="#rc.edit#" data-emptyvalue="#$.slatwall.rbKey('define.unlimited')#">
				<cf_SlatwallPropertyDisplay object="#rc.promotionperiod#" property="maximumaccountusecount" edit="#rc.edit#" data-emptyvalue="#$.slatwall.rbKey('define.unlimited')#">
			</cf_SlatwallPropertyList>
		</cf_SlatwallDetailHeader>

	</cf_SlatwallDetailForm>
	
	<cf_SlatwallTabGroup object="#rc.promotionperiod#">
			<cf_SlatwallTab view="admin:pricing/promotionperiodtabs/promotionrewards" />
			<cf_SlatwallTab view="admin:pricing/promotionperiodtabs/promotionqualifiers" />
	</cf_SlatwallTabGroup>
	
</cfoutput>

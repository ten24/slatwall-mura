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
<cfparam name="rc.edit" default="false" />
<cfparam name="rc.attributeSet" type="any" />

<cfoutput>
	
<cf_SlatwallDetailForm object="#rc.attributeSet#" edit="#rc.edit#">
	<cf_SlatwallActionBar type="detail" object="#rc.attributeSet#" edit="#rc.edit#">
		<cf_SlatwallActionCaller action="admin:setting.createattribute" queryString="attributesetid=#rc.attributeset.getAttributeSetID()#" type="list" modal=true />
	</cf_SlatwallActionBar>
	
	<cf_SlatwallDetailHeader>
		<cf_SlatwallPropertyList divclass="span6">
			<cf_SlatwallPropertyDisplay object="#rc.attributeSet#" property="activeFlag" edit="#rc.edit#">
			<cf_SlatwallPropertyDisplay object="#rc.attributeSet#" property="attributeSetType" edit="#rc.attributeSet.isNew()#">
			<cf_SlatwallPropertyDisplay object="#rc.attributeSet#" property="attributeSetName" edit="#rc.edit#">
			<cf_SlatwallPropertyDisplay object="#rc.attributeSet#" property="attributeSetCode" edit="#rc.edit#">
		</cf_SlatwallPropertyList>
		
		<cfif rc.attributeSet.isNew()>
			<input type="hidden" name="globalFlag" value="1" />
		<cfelse>
			<cf_SlatwallPropertyList divclass="span6">
				<cfset local.canEditGlobal = listFind( "astProduct,astOrderItem", rc.attributeSet.getAttributeSetType().getSystemCode() ) && rc.edit />
				<cf_SlatwallPropertyDisplay object="#rc.attributeSet#" property="globalFlag" edit="#local.canEditGlobal#">
				<cfif listFind( "astOrderItem", rc.attributeSet.getAttributeSetType().getSystemCode() )>
					<cf_SlatwallPropertyDisplay object="#rc.attributeSet#" property="requiredFlag" edit="#rc.edit#">
					<cf_SlatwallPropertyDisplay object="#rc.attributeSet#" property="accountSaveFlag" edit="#rc.edit#">
					<cf_SlatwallPropertyDisplay object="#rc.attributeSet#" property="additionalCharge" edit="#rc.edit#">
				</cfif>
			</cf_SlatwallPropertyList>
		</cfif>
	</cf_SlatwallDetailHeader>
	
	<cf_SlatwallTabGroup object="#rc.attributeSet#">
		<cf_SlatwallTab view="admin:setting/attributesettabs/attributes" />
		<cf_SlatwallTab view="admin:setting/attributesettabs/description" />
		<cfif not rc.attributeSet.getGlobalFlag()>
			<cf_SlatwallTab view="admin:setting/attributesettabs/producttypes" />
		</cfif>
	</cf_SlatwallTabGroup>
	
</cf_SlatwallDetailForm>

</cfoutput>

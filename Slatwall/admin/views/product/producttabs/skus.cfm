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
<cfoutput>
	<cfset local.skusSmartList = rc.product.getSkusSmartList() />
	<cfset local.skusSmartList.joinRelatedProperty("SlatwallSku", "options", "left", true) />
	
	<cf_SlatwallListingDisplay smartList="#local.skusSmartList#"
							   edit="#rc.edit#"
							   recordDetailAction="admin:product.detailsku"
							   recordDetailQueryString="productID=#rc.product.getProductID()#"
							   recordEditAction="admin:product.editsku"
							   recordEditQueryString="productID=#rc.product.getProductID()#"
							   recordDeleteAction="admin:product.deletesku"
							   recordDeleteQueryString="returnaction=product.editproduct&productID=#rc.product.getProductID()#"
							   selectFieldName="defaultSku.skuID"
							   selectValue="#rc.product.getDefaultSku().getSkuID()#"
							   selectTitle="#$.slatwall.rbKey('define.default')#">
		<cf_SlatwallListingColumn tdclass="primary" propertyIdentifier="skuCode" />
		<cfif rc.product.getBaseProductType() eq "merchandise">
			<cfloop collection="#rc.product.getOptionGroupsStruct()#" item="local.optionGroup">
				<cf_SlatwallListingColumn propertyIdentifier="#rc.product.getOptionGroupsStruct()[local.optionGroup].getOptionGroupID()#" title="#rc.product.getOptionGroupsStruct()[local.optionGroup].getOptionGroupName()#" sort="false" />
			</cfloop>
		<cfelseif  rc.product.getProductType().getBaseProductType() eq "subscription">
			<cf_SlatwallListingColumn propertyIdentifier="subscriptionTerm.subscriptionTermName" />
		<cfelseif rc.product.getProductType().getBaseProductType() eq "contentAccess">
			<!--- Sumit says nothing is ok --->
		</cfif>
		<cf_SlatwallListingColumn propertyIdentifier="imageFile" />
		<cfif isNull(rc.product.getDefaultSku().getUserDefinedPriceFlag()) || !rc.product.getDefaultSku().getUserDefinedPriceFlag()>
			<cf_SlatwallListingColumn propertyIdentifier="listPrice" range="true" />
			<cf_SlatwallListingColumn propertyIdentifier="price" range="true" />
			<cf_SlatwallListingColumn propertyIdentifier="salePrice" range="true" />
		</cfif>
	</cf_SlatwallListingDisplay>
	
	<cf_SlatwallProcessCaller entity="#rc.product#" action="admin:product.processproduct" processContext="addOptionGroup" querystring="productID=#rc.product.getProductID()#" class="btn btn-inverse" icon="plus icon-white" modal="true" />
	<cf_SlatwallProcessCaller entity="#rc.product#" action="admin:product.processproduct" processContext="addOption" querystring="productID=#rc.product.getProductID()#" class="btn btn-inverse" icon="plus icon-white" modal="true" />
	<cf_SlatwallProcessCaller entity="#rc.product#" action="admin:product.processproduct" processContext="addSubscriptionTerm" querystring="productID=#rc.product.getProductID()#" class="btn btn-inverse" icon="plus icon-white" modal="true" />
</cfoutput>

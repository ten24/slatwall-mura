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
<cfparam name="rc.product" type="any" />
<cfparam name="rc.baseProductType" type="string" />

<cfoutput>
	<cf_SlatwallDetailForm object="#rc.product#" edit="true">
		<cf_SlatwallActionBar type="detail" object="#rc.product#" edit="true"></cf_SlatwallActionBar>
		
		<cf_SlatwallDetailHeader>
			<cf_SlatwallPropertyList>
				<cf_SlatwallPropertyDisplay object="#rc.product#" property="productName" edit="true">
				<cf_SlatwallPropertyDisplay object="#rc.product#" property="productCode" edit="true">
				<cf_SlatwallPropertyDisplay object="#rc.product#" property="brand" edit="true" createAction="admin:product.createbrand">
				<cf_SlatwallPropertyDisplay object="#rc.product#" property="productType" edit="true" valueOptions="#rc.product.getProductTypeOptions( rc.baseProductType )#">
				<cf_SlatwallPropertyDisplay object="#rc.product#" property="price" edit="true">
				<cf_SlatwallPropertyDisplay object="#rc.product#" property="listPrice" edit="true">
			</cf_SlatwallPropertyList>
		</cf_SlatwallDetailHeader>
		
		<cfif rc.baseProductType eq "merchandise">
			<div class="row-fluid">
				<cfset optionsSmartList = $.slatwall.getService("optionService").getOptionSmartList() />
				<cfset optionsSmartList.addOrder("optionGroup.sortOrder|ASC") />
				<cfif optionsSmartList.getRecordsCount()>
					<cf_SlatwallListingDisplay smartList="#optionsSmartList#" multiselectfieldname="options" edit="true">
						<cf_SlatwallListingColumn propertyIdentifier="optionGroup.optionGroupName" filter=true />
						<cf_SlatwallListingColumn propertyIdentifier="optionName" tdclass="primary" />
					</cf_SlatwallListingDisplay>
				</cfif>
			</div>
		<cfelseif rc.baseProductType eq "subscription">
			<div class="row-fluid">
				<div class="span6">
					<h5>#$.slatwall.rbKey('admin.product.createproduct.selectsubscriptionbenifits')#</h5>
					<br />
					<cf_SlatwallErrorDisplay object="#rc.product#" errorName="subscriptionBenefits" />
					<cf_SlatwallListingDisplay smartList="SubscriptionBenefit" multiselectFieldName="subscriptionBenefits" edit="true">
						<cf_SlatwallListingColumn propertyIdentifier="subscriptionBenefitName" tdclass="primary" />
					</cf_SlatwallListingDisplay>
					<h5>#$.slatwall.rbKey('admin.product.createproduct.selectrenewalsubscriptionbenifits')#</h5>
					<br />
					<cf_SlatwallErrorDisplay object="#rc.product#" errorName="renewalsubscriptionBenefits" />
					<cf_SlatwallListingDisplay smartList="SubscriptionBenefit" multiselectFieldName="renewalSubscriptionBenefits" edit="true">
						<cf_SlatwallListingColumn propertyIdentifier="subscriptionBenefitName" tdclass="primary" />
					</cf_SlatwallListingDisplay>
				</div>
				<div class="span6">
					<h5>#$.slatwall.rbKey('admin.product.createproduct.selectsubscriptionterms')#</h5>
					<br />
					<cf_SlatwallErrorDisplay object="#rc.product#" errorName="subscriptionTerms" />
					<cf_SlatwallListingDisplay smartList="SubscriptionTerm" multiselectFieldName="subscriptionTerms" edit="true">
						<cf_SlatwallListingColumn propertyIdentifier="subscriptionTermName" tdclass="primary" />
					</cf_SlatwallListingDisplay>
				</div>
			</div>
		<cfelseif rc.baseProductType eq "contentAccess">
			<cfset contentAccessList = $.slatwall.getService("contentService").getContentSmartList() />
			<cfset contentAccessList.addFilter("allowPurchaseFlag", 1) />
			<cf_SlatwallErrorDisplay object="#rc.product#" errorName="accessContents" />
			<cf_SlatwallFieldDisplay fieldType="yesno" fieldName="bundleContentAccess" value="0" title="Would you like to bundle all pages selected into a single sku?" edit="true" />
			<cf_SlatwallListingDisplay smartList="#contentAccessList#" multiselectFieldName="accessContents" edit="true">
				<cf_SlatwallListingColumn propertyIdentifier="title" tdclass="primary" />
			</cf_SlatwallListingDisplay>
		</cfif>
	</cf_SlatwallDetailForm>
</cfoutput>
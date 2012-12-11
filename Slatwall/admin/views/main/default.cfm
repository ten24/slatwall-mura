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
<cfparam name="rc.orderSmartList" type="any" />
<cfparam name="rc.productSmartList" type="any" />
<cfparam name="rc.productReviewSmartList" type="any" />
<cfparam name="rc.vendorOrderSmartList" type="any" />

<cfsilent>
	<cfif application.configBean.getTrackSessionInNewThread() NEQ "0" && listLast(application.autoUpdater.getCurrentCompleteVersion(), ".") lt 4970>
		<cfset $.slatwall.showMessageKey('dashboard.tracksessionissue_error') />
	</cfif>
</cfsilent>

<cfoutput>
	<cf_SlatwallMessageDisplay />
	
	<div class="row-fluid">
		<div class="span6">
			<h4>#request.slatwallScope.rbKey("admin.main.dashboard.neworders")#</h4>
			<cf_SlatwallListingDisplay smartList="#rc.orderSmartList#" 
					recordDetailAction="admin:order.detailorder">
				<cf_SlatwallListingColumn propertyIdentifier="orderNumber" />
				<cf_SlatwallListingColumn tdclass="primary" propertyIdentifier="account.fullName" />
				<cf_SlatwallListingColumn propertyIdentifier="orderOpenDateTime" />
			</cf_SlatwallListingDisplay>
		</div>
		<div class="span6">
			<h4>#request.slatwallScope.rbKey("admin.main.dashboard.recentproductupdates")#</h4>
			<cf_SlatwallListingDisplay smartList="#rc.productSmartList#" 
					recordDetailAction="admin:product.detailproduct">
				<cf_SlatwallListingColumn propertyIdentifier="brand.brandName" />
				<cf_SlatwallListingColumn tdclass="primary" propertyIdentifier="productName" />
				<cf_SlatwallListingColumn propertyIdentifier="modifiedDateTime" />
				<cf_SlatwallListingColumn propertyIdentifier="modifiedByAccount.fullname" />
			</cf_SlatwallListingDisplay>
		</div>
	</div>
	<div class="row-fluid">
		<div class="span6">
			<h4>#request.slatwallScope.rbKey("admin.main.dashboard.recentvendororderupdates")#</h4>
			<cf_SlatwallListingDisplay smartList="#rc.vendorOrderSmartList#" 
					recordDetailAction="admin:vendor.detailvendororder">
				<cf_SlatwallListingColumn propertyIdentifier="vendorOrderNumber" />
				<cf_SlatwallListingColumn tdclass="primary" propertyIdentifier="vendor.vendorName" />
				<cf_SlatwallListingColumn propertyIdentifier="modifiedDateTime" />
				<cf_SlatwallListingColumn propertyIdentifier="modifiedByAccount.fullname" />
			</cf_SlatwallListingDisplay>
		</div>
		<div class="span6">
			<h4>#request.slatwallScope.rbKey("admin.main.dashboard.recentproductreviews")#</h4>
			<cf_SlatwallListingDisplay smartList="#rc.productReviewSmartList#" 
					recordDetailAction="admin:product.detailproductreview">
				<cf_SlatwallListingColumn tdclass="primary" propertyIdentifier="product.calculatedTitle" />
				<cf_SlatwallListingColumn propertyIdentifier="reviewerName" />
				<cf_SlatwallListingColumn propertyIdentifier="reviewTitle" />
			</cf_SlatwallListingDisplay>
		</div>
	</div>
</cfoutput>
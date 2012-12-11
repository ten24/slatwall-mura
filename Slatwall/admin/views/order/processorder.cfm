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
<cfparam name="rc.returnAction" type="string" default="admin:order.listorder" />
<cfparam name="rc.processOrderSmartList" type="any" />
<cfparam name="rc.multiProcess" type="boolean" />
<cfparam name="rc.processContext" type="string" />

<cfoutput>
	<cf_SlatwallProcessForm addcomment="true">
		
		<cf_SlatwallActionBar type="process" />
		
		<cfif rc.processContext eq "placeOrder">
			
			This feature is currently disabled
			
		<cfelseif rc.processContext eq "addOrderPayment">
			
			This feature is currently disabled
			
		<cfelseif listFindNoCase("placeOnHold,takeOffHold,closeOrder,cancelOrder", rc.processContext)>
			
			<input type="hidden" name="orderID" value="#rc.processOrderSmartList.getRecords()[1].getOrderID()#" />
			<cf_SlatwallProcessOptionBar allowComment="true" />
			
		<cfelseif rc.processContext eq "createReturn">
			
			<cf_SlatwallProcessOptionBar allowComment="true">
				<cf_SlatwallProcessOption data="returnLocationID" fieldType="select" valueOptions="#$.slatwall.getService("locationService").getLocationOptions()#" />
				<cf_SlatwallProcessOption data="fulfillmentChargeRefundAmount" fieldType="text" fieldClass="number" value="0" />
				<cf_SlatwallProcessOption data="referencedOrderPaymentID" fieldType="select" value="rc.processOrderSmartList.getRecords()[1].getOrderPaymentRefundOptions()[1]['value']" valueOptions="#rc.processOrderSmartList.getRecords()[1].getOrderPaymentRefundOptions()#" />
				<cf_SlatwallProcessOption data="autoProcessReceiveReturnFlag" fieldType="yesno" value="0" />
				<cf_SlatwallProcessOption data="autoProcessReturnPaymentFlag" fieldType="yesno" value="0" />
			</cf_SlatwallProcessOptionBar>
			
			<cf_SlatwallProcessListing processSmartList="#rc.processOrderSmartList#" processRecordsProperty="orderItems" processHeaderString="Order: ${order.orderNumber}">
				<cf_SlatwallProcessColumn tdClass="primary" propertyIdentifier="sku.product.title" />
				<cf_SlatwallProcessColumn propertyIdentifier="sku.skuCode" />
				<cf_SlatwallProcessColumn propertyIdentifier="sku.optionsDisplay" />
				<cf_SlatwallProcessColumn propertyIdentifier="price" />
				<cf_SlatwallProcessColumn propertyIdentifier="quantityDelivered" />
				<cf_SlatwallProcessColumn data="returnPrice" fieldType="text" value="${price}" fieldClass="span1 number" />
				<cf_SlatwallProcessColumn data="returnQuantity" fieldType="text" value="0" fieldClass="span1 number" />
			</cf_SlatwallProcessListing>
			
		</cfif>
		
	</cf_SlatwallProcessForm>
</cfoutput>
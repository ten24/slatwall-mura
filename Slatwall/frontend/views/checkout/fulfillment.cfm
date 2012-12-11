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
<cfparam name="rc.edit" type="string" default="" />
<cfparam name="rc.orderRequirementsList" type="string" default="" />
<cfparam name="local.showHeader" type="boolean" default="false" />

<!--- if the only fulfillment is auto, don't display header --->
<cfloop array="#request.slatwallScope.cart().getOrderFulfillments()#" index="local.fulfillment">
	<cfif local.fulfillment.getFulfillmentMEthodType() NEQ "auto">
		<cfset local.showHeader = true />
		<cfbreak />
	</cfif>
</cfloop>

<cfoutput>
	<div class="svocheckoutfulfillment">
		<cfif local.showHeader><h3 id="checkoutFulfillmentTitle" class="titleBlick">Delivery<cfif not listFind(rc.orderRequirementsList, 'fulfillment')> <a href="?edit=fulfillment">Edit</a></cfif></h3></cfif>
		<cfif not listFind(rc.orderRequirementsList, 'account') and (rc.edit eq "" or rc.edit eq "fulfillment")>
			<div id="checkoutFulfillmentContent" class="contentBlock">
				<cfif listFind(rc.orderRequirementsList, 'fulfillment') || (rc.edit eq "fulfillment")>
					<form name="fulfillmentShipping" method="post" action="?update=1">
						<input type="hidden" name="slatAction" value="frontend:checkout.saveOrderFulfillments" />
				</cfif>
				<cfset local.orderFulfillmentIndex = 1 />
				<cfloop array="#request.slatwallScope.cart().getOrderFulfillments()#" index="local.fulfillment">
					<div class="fulfillmentOptions">
						<cfset params = structNew() />
						<cfset params.orderFulfillment = local.fulfillment />
						<cfset params.orderFulfillmentIndex = local.orderFulfillmentIndex />
						<cfset local.orderFulfillmentIndex += 1 />
						<cfif listFind(rc.orderRequirementsList, local.fulfillment.getOrderFulfillmentID())
							OR rc.edit eq local.fulfillment.getOrderFulfillmentID()
							OR (rc.edit eq "fulfillment" and arrayLen($.slatwall.cart().getOrderFulfillments())) eq 1>
							<cfset params.edit = true />
						<cfelse>
							<cfset params.edit = false />
						</cfif>
						#view("frontend:checkout/fulfillment/#local.fulfillment.getFulfillmentMethodType()#", params)# 
					</div>
					<cfif arrayLen($.slatwall.cart().getOrderFulfillments()) gt 1>
						<div class="fulfillmentItems">
							<cfloop array="#local.fulfillment.getOrderFulfillmentItems()#" index="local.fulfillmentItem">
								<dl class="orderItem">
									<dt class="title"><a href="#local.fulfillmentItem.getSku().getProduct().getProductURL()#" title="#local.fulfillmentItem.getSku().getProduct().getTitle()#">#local.fulfillmentItem.getSku().getProduct().getTitle()#</a></dt>
									<dd class="options">#local.fulfillmentItem.getSku().displayOptions()#</dd>
									<dd class="quantity">#NumberFormat(local.fulfillmentItem.getQuantity(),"0")#</dd>
								</dl>
							</cfloop>
						</div>
					</cfif>
				</cfloop>
				<cfif listFind(rc.orderRequirementsList, 'fulfillment') || (rc.edit eq "fulfillment")>
						<button type="submit">Save & Continue</button>
					</form>
				</cfif>
			</div>
		</cfif>
	</div>
</cfoutput>
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
<cfparam name="rc.eligiblePaymentMethodDetails" type="array" />
<cfparam name="rc.activePaymentMethods" type="array" /> <!--- IMPORTANT: This value is deprecated --->

<cfset local.paymentShown = false />

<cfoutput>
	<div class="svoorderpayment">
		<cfif not listFind(rc.orderRequirementsList, 'account') and not listFind(rc.orderRequirementsList, 'fulfillment')>
			<form name="processOrder" method="post" action="?update=1">
				<input type="hidden" name="slatAction" value="frontend:checkout.processOrder" />
				<h3 id="checkoutPaymentTitle" class="titleBlock">Payment</h3>
				
				<cfset local.orderPaymentIndex = 1 />
				
				<!--- Existing Payments to update, or fix errors --->
				<cfloop array="#$.slatwall.cart().getOrderPayments()#" index="local.orderPayment">
					
					<cfset params = structNew() />
					<cfset params.paymentMethod = local.orderPayment.getPaymentMethod() />
					<cfset params.orderPayment = local.orderPayment />
					<cfset params.orderPaymentIndex = local.orderPaymentIndex />
					
					<cfset local.orderPaymentIndex += 1 />
					
					<cfif local.orderPayment.hasErrors() or (local.orderPayment.getAmountAuthorized() eq 0 and params.paymentMethod.setting("paymentMethodCheckoutTransactionType") neq "none")>
						<cfset local.paymentShown = true />
						<cfset params.edit = true />
					<cfelse>
						<cfset params.edit = false />
					</cfif>
					 
					#view("frontend:checkout/payment/#local.orderPayment.getPaymentMethodType()#", params)# 
				</cfloop>
				
				<!--- New payment methods to use --->
				<cfif not local.paymentShown>
					
					<!--- Only 1 option for payment method --->
					<cfif arrayLen(rc.eligiblePaymentMethodDetails) eq 1>
						
						<cfset params = rc.eligiblePaymentMethodDetails[1] />
						<cfset params.edit = true />
						<cfset params.orderPayment = $.slatwall.getService("paymentService").newOrderPayment() />
						<cfset params.orderPaymentIndex = local.orderPaymentIndex />
						<cfset local.orderPaymentIndex += 1 />
						
						#view("frontend:checkout/payment/#rc.eligiblePaymentMethodDetails[1].paymentMethod.getPaymentMethodType()#", params)#
						
					<!--- More than 1 option for payment method --->
					<cfelse>
						<cfset local.newOrderPaymentIndex = 0 />
						<cfloop array="#rc.eligiblePaymentMethodDetails#" index="local.paymentMethodDetails">
							<cfset local.newOrderPaymentIndex += 1 />
							<dl>
								<dt><input type="radio" name="newOrderPaymentIndex" value="#local.newOrderPaymentIndex#"> #local.paymentMethodDetails.paymentMethod.getPaymentMethodName()#</dt>
								<dd>
									<cfset params = local.paymentMethodDetails />
									<cfset params.edit = true />
									<cfset params.orderPayment = $.slatwall.getService("paymentService").newOrderPayment() />
									<cfset params.orderPaymentIndex = local.orderPaymentIndex />
									<cfset local.orderPaymentIndex += 1 />
									#view("frontend:checkout/payment/#local.paymentMethodDetails.paymentMethod.getPaymentMethodType()#", params)#
								</dd>
							</dl>
						</cfloop>
					</cfif>
				</cfif>
				
				<input type="hidden" name="orderID" value="#$.slatwall.cart().getOrderID()#" />
				<button type="submit">Submit</button>
			</form>
		</cfif>
	</div>
</cfoutput>
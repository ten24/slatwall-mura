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
<cfparam name="rc.processOrderPaymentSmartList" type="any" />
<cfparam name="rc.multiProcess" type="boolean" />
<cfparam name="rc.processContext" type="string" />

<cfsilent>
	<cfset local.amount = 0 />
	<cfset local.amountReceived = 0 />
	<cfset local.amountCredited = 0 />
	
	<cfset local.orderPayment = rc.processOrderPaymentSmartList.getRecords()[1] />
	
	<cfif rc.processContext eq "chargePreAuthorization" >
		<cfset local.amount = local.orderPayment.getAmountUncaptured() />
	<cfelseif rc.processContext eq "authorizeAndCharge">
		<cfset local.amount = local.orderPayment.getAmountUnreceived() />
	<cfelseif rc.processContext eq "authorize" >
		<cfset local.amount = local.orderPayment.getAmountUnauthorized() />
	<cfelseif rc.processContext eq "credit" >
		<cfset local.amount = local.orderPayment.getAmountUncredited() />
	<cfelseif rc.processContext eq "offlineTransaction">
		<cfif local.orderPayment.getAmountUnreceived() gt 0>
			<cfset local.amountReceived = local.orderPayment.getAmountUnreceived() />
		<cfelseif local.orderPayment.getAmountUncredited() gt 0>
			<cfset local.amountCredited = local.orderPayment.getAmountUncredited() />
		</cfif>
	</cfif>
</cfsilent>

<cfoutput>
	<cf_SlatwallProcessForm>
		<cf_SlatwallActionBar type="process" />
		
		<input type="hidden" name="orderPaymentID" value="#local.orderPayment.getOrderPaymentID()#" />
			
		<cf_SlatwallProcessOptionBar>
			<cfif rc.processContext eq "offlineTransaction">
				<cf_SlatwallProcessOption data="transactionDateTime" fieldType="datetime" value="#$.slatwall.formatValue(now(), "datetime")#" />
				<cf_SlatwallProcessOption data="amountReceived" fieldType="text" value="#local.amountReceived#" />
				<cf_SlatwallProcessOption data="amountCredited" fieldType="text" value="#local.amountCredited#" />
			<cfelse>
				<cf_SlatwallProcessOption data="amount" fieldType="text" value="#local.amount#" />	
			</cfif>
		</cf_SlatwallProcessOptionBar>
		
	</cf_SlatwallProcessForm>
</cfoutput>
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
<cfparam name="rc.order" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfsilent>
	<cfset local.chargeList = duplicate(rc.order.getOrderPaymentsSmartList()) />
	<cfset local.chargeList.addFilter('orderPaymentType.systemCode', 'optCharge') />
	
	<cfset local.creditList = duplicate(rc.order.getOrderPaymentsSmartList()) />
	<cfset local.creditList.addFilter('orderPaymentType.systemCode', 'optCredit') />
</cfsilent>

<cfoutput>
	<cfif local.chargeList.getRecordsCount() gt 0>
		<h4>#$.slatwall.rbKey('admin.order.ordertabs.orderpayments.charges')#</h4>
		<cf_SlatwallListingDisplay smartList="#local.chargeList#" 
				recordDetailAction="admin:order.detailorderpayment"
				recordEditAction="admin:order.editorderpayment"
				recordProcessAction="admin:order.processorderpayment"
				recordProcessModal="true">
			<cf_SlatwallListingColumn tdclass="primary" propertyIdentifier="paymentMethod.paymentMethodName" />
			<cf_SlatwallListingColumn tdclass="primary" propertyIdentifier="orderPaymentType.type" />
			<cf_SlatwallListingColumn propertyIdentifier="amount" />
			<cf_SlatwallListingColumn propertyIdentifier="amountReceived" />
			<cf_SlatwallListingColumn propertyIdentifier="amountCredited" />
		</cf_SlatwallListingDisplay>
	</cfif>
	
	<cfif local.creditList.getRecordsCount() gt 0>
		<h4>#$.slatwall.rbKey('admin.order.ordertabs.orderpayments.credits')#</h4>
		<cf_SlatwallListingDisplay smartList="#local.creditList#" 
				recordDetailAction="admin:order.detailorderpayment"
				recordEditAction="admin:order.editorderpayment"
				recordProcessAction="admin:order.processorderpayment"
				recordProcessModal="true">
			<cf_SlatwallListingColumn tdclass="primary" propertyIdentifier="paymentMethod.paymentMethodName" />
			<cf_SlatwallListingColumn tdclass="primary" propertyIdentifier="orderPaymentType.type" />
			<cf_SlatwallListingColumn propertyIdentifier="amount" />
			<cf_SlatwallListingColumn propertyIdentifier="amountReceived" />
			<cf_SlatwallListingColumn propertyIdentifier="amountCredited" />
		</cf_SlatwallListingDisplay>
	</cfif>
	
	<cfif rc.order.getPaymentAmountTotal() neq rc.order.getTotal()>
		<cf_SlatwallActionCallerDropdown title="#$.slatwall.rbKey('define.add')#" icon="plus" buttonClass="btn-inverse">
			<cfloop array="#rc.order.getPaymentMethodOptionsSmartList().getRecords()#" index="local.paymentMethod">
				<cfif rc.order.getPaymentAmountTotal() lt rc.order.getTotal()> 
					<cf_SlatwallActionCaller text="#$.slatwall.rbKey('define.add')# #local.paymentMethod.getPaymentMethodName()# #$.slatwall.rbKey('define.charge')#" action="admin:order.createorderpayment" querystring="orderID=#rc.orderID#&paymentMethodID=#local.paymentMethod.getPaymentMethodID()#&orderPaymentTypeSystemCode=optCharge" modal=true />
				<cfelse>
					<cf_SlatwallActionCaller text="#$.slatwall.rbKey('define.add')# #local.paymentMethod.getPaymentMethodName()# #$.slatwall.rbKey('define.refund')#" action="admin:order.createorderpayment" querystring="orderID=#rc.orderID#&paymentMethodID=#local.paymentMethod.getPaymentMethodID()#&orderPaymentTypeSystemCode=optCredit" modal=true />
				</cfif>
			</cfloop>
		</cf_SlatwallActionCallerDropdown>
	</cfif>
	
</cfoutput>
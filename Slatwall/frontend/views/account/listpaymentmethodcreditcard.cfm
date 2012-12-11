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
<cfparam name="rc.account" type="any" />
<cfparam name="local.paymentMethod" type="any" />
<cfset local.accountPaymentMethodSmartList = rc.account.getAccountPaymentMethodsSmartList() />
<cfset local.accountPaymentMethodSmartList.addFilter(propertyIdentifier="paymentMethod_paymentMethodType", value="creditCard")/>
<cfset local.accountPaymentMethods = local.accountPaymentMethodSmartList.getRecords() />

<cfoutput>
	<div class="svoaccountlistpaymentmethodcreditcard">
		<cfif arrayLen(local.accountPaymentMethods)>
			<table>
				<tr>
					<th>#rc.$.Slatwall.rbKey("entity.accountPaymentMethod.nameOnCreditCard")#</th>
					<th>#rc.$.Slatwall.rbKey("entity.accountPaymentMethod.creditCardType")#</th>
					<th>#rc.$.Slatwall.rbKey("entity.accountPaymentMethod.creditCardLastFour")#</th>
					<th>#rc.$.Slatwall.rbKey("entity.accountPaymentMethod.expirationMonth")#</th>
					<th>&nbsp</th>
				</tr>
				<cfloop array="#local.accountPaymentMethods#" index="local.accountPaymentMethod">
					<tr>
						<td>#Local.accountPaymentMethod.getNameOnCreditCard()#</td>
						<td>#Local.accountPaymentMethod.getCreditCardType()#</td>
						<td>#Local.accountPaymentMethod.getCreditCardLastFour()#</td>
						<td>#Local.accountPaymentMethod.getExpirationMonth()# / #Local.accountPaymentMethod.getExpirationYear()#</td>
						<td><a href="#$.createHREF(filename='my-account', queryString='showitem=editPaymentMethod&accountPaymentMethodID=#local.accountPaymentMethod.getAccountPaymentMethodID()#')#">Edit Payment Method</a></td>
					</tr>
				</cfloop>
			</table>
		</cfif>
	</div>
	<div class="svoaccountcreatepaymentmethodcreditcard">
		<a href="#$.createHREF(filename='my-account', queryString='showitem=createPaymentMethod&paymentMethodID=#local.paymentMethod.getPaymentMethodID()#')#">Add Credit Card</a>
	</div>
</cfoutput>
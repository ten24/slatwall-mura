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
<cfparam name="rc.sku" type="any" />

<cfoutput>
	<table class="table table-striped table-bordered table-condensed">
		<tr>
			<th>#$.slatwall.rbKey('entity.currency')#</th>
			<th>#$.slatwall.rbKey('entity.sku.listPrice')#</th>
			<th>#$.slatwall.rbKey('entity.sku.price')#</th>
			<th>#$.slatwall.rbKey('entity.currency.currencyCode')#</th>
			<th class="admin admin1"></th>
		</tr>
		<cfloop list="#rc.sku.setting('skuEligibleCurrencies')#" index="local.currencyCode">
			<cfset local.currency = $.slatwall.getService("currencyService").getCurrency( local.currencyCode ) />
			<cfif local.currency.getCurrencyCode() eq rc.sku.setting('skuCurrency')>
				<tr class="highlight-yellow">
			<cfelse>
				<tr>
			</cfif>
				<td class="primary">#local.currency.getCurrencyName()#</td>
				<cfif structKeyExists(rc.sku.getCurrencyDetails()[ local.currency.getCurrencyCode() ], "listPriceFormatted")>
					<td>#rc.sku.getCurrencyDetails()[ local.currency.getCurrencyCode() ].listPriceFormatted#</td>
				<cfelse>
					<td></td>
				</cfif>
				<td>#rc.sku.getCurrencyDetails()[ local.currency.getCurrencyCode() ].priceFormatted#</td>
				<td>#local.currencyCode#</td>
				<td>
					<cfif local.currency.getCurrencyCode() eq rc.sku.setting('skuCurrency')>
						<cf_SlatwallActionCaller action="admin:product.editSkuCurrency" class="btn btn-mini" icon="pencil" icononly="true" modal="true" disabled="true" />
					<cfelseif rc.sku.getCurrencyDetails()[ local.currency.getCurrencyCode() ].converted>
						<cf_SlatwallActionCaller action="admin:product.createSkuCurrency" querystring="currencyCode=#local.currencyCode#&skuID=#rc.sku.getSkuID()#&returnAction=admin:product.detailsku" class="btn btn-mini" icon="pencil" icononly="true" modal="true" />
					<cfelse>
						<cf_SlatwallActionCaller action="admin:product.editSkuCurrency" querystring="skuCurrencyID=#rc.sku.getCurrencyDetails()[ local.currency.getCurrencyCode() ].skuCurrencyID#&currencyCode=#local.currencyCode#&skuID=#rc.sku.getSkuID()#&returnAction=admin:product.detailsku" class="btn btn-mini" icon="pencil" icononly="true" modal="true" />
					</cfif>
				</td>
			</tr>
		</cfloop>
	</table>
</cfoutput>
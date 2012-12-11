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

<cfset local.scriptHasErrors = false />

<cfdbinfo datasource="#application.configBean.getDataSource()#" type="Tables" name="local.infoTables" />

<!--- Update payment methods to use the new paymentIntegrationID value instead of provider gateway --->
<cftry>
	<cfdbinfo datasource="#application.configBean.getDataSource()#" type="Columns" table="SlatwallPaymentMethod" name="local.infoColumns" />
	
	<cfquery name="local.hasColumn" dbtype="query">
		SELECT
			* 
		FROM
			infoColumns
		WHERE
			COLUMN_NAME = 'providerGateway'
	</cfquery>
	
	<cfif local.hasColumn.recordCount>
		<cfquery name="local.updateData">
			UPDATE
				SlatwallPaymentMethod
			SET
				paymentIntegrationID = (SELECT integrationID FROM SlatwallIntegration WHERE SlatwallIntegration.integrationPackage = SlatwallPaymentMethod.providerGateway)
			WHERE
				paymentIntegrationID IS NULL
			  AND
			  	providerGateway IS NOT NULL
		</cfquery>
	</cfif>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update paymentIntegrationID on SlatwallPaymentMethod Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<!--- Update creditCard transactions and move them into the paymentTransaction table --->
<cftry>
	<cfquery name="local.hasTable" dbtype="query">
		SELECT
			* 
		FROM
			infoTables
		WHERE
			TABLE_NAME = 'SlatwallCreditCardTransaction'
	</cfquery>
	
	<cfif local.hasTable.recordCount>
		<cfquery name="local.updateData">
			SELECT
				creditCardTransactionID,
				transactionType,
				providerTransactionID,
				authorizationCode,
				amountAuthorized,
				amountCharged,
				amountCredited,
				avsCode,
				statusCode,
				message,
				orderPaymentID,
				createdDateTime,
				createdByAccountID,
				modifiedDateTime,
				modifiedByAccountID
			FROM
				SlatwallCreditCardTransaction
			WHERE NOT EXISTS( SELECT paymentTransactionID FROM SlatwallPaymentTransaction WHERE SlatwallPaymentTransaction.paymentTransactionID = SlatwallCreditCardTransaction.creditCardTransactionID )
		</cfquery>
		
		<cfloop query="local.updateData">
			<cfquery name="local.change">
				INSERT INTO SlatwallPaymentTransaction (
					paymentTransactionID,
					transactionType,
					providerTransactionID,
					transactionDateTime,
					authorizationCode,
					amountAuthorized,
					amountCharged,
					amountCredited,
					avsCode,
					statusCode,
					message,
					orderPaymentID,
					createdDateTime,
					createdByAccountID,
					modifiedDateTime,
					modifiedByAccountID
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.updateData.creditCardTransactionID#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.updateData.transactionType#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(local.updateData.providerTransactionID)#" value="#local.updateData.providerTransactionID#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(local.updateData.createdDateTime)#" value="#local.updateData.createdDateTime#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(local.updateData.authorizationCode)#" value="#local.updateData.authorizationCode#" />,
					<cfqueryparam cfsqltype="cf_sql_money" value="#local.updateData.amountAuthorized#" />,
					<cfqueryparam cfsqltype="cf_sql_money" value="#local.updateData.amountCharged#" />,
					<cfqueryparam cfsqltype="cf_sql_money" value="#local.updateData.amountCredited#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(local.updateData.avsCode)#" value="#local.updateData.avsCode#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(local.updateData.statusCode)#" value="#local.updateData.statusCode#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(local.updateData.message)#" value="#local.updateData.message#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(local.updateData.orderPaymentID)#" value="#local.updateData.orderPaymentID#" />,
					<cfqueryparam cfsqltype="cf_sql_timestamp" null="#not len(local.updateData.createdDateTime)#" value="#local.updateData.createdDateTime#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(local.updateData.createdByAccountID)#" value="#local.updateData.createdByAccountID#" />,
					<cfqueryparam cfsqltype="cf_sql_timestamp" null="#not len(local.updateData.modifiedDateTime)#" value="#local.updateData.modifiedDateTime#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(local.updateData.modifiedByAccountID)#" value="#local.updateData.modifiedByAccountID#" />
				)
			</cfquery>
		</cfloop>
	</cfif>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - move credit card transactions to payment transactions has error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cftry>
	<cfquery name="local.change">
		UPDATE
			SlatwallOrder
		SET
			currencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="USD" />
		WHERE
			currencyCode is null
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update currencyCode on SlatwallOrder Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cftry>
	<cfquery name="local.change">
		UPDATE
			SlatwallOrderFulfillment
		SET
			currencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="USD" />
		WHERE
			currencyCode is null
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update currencyCode on SlatwallOrderFulfillment Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cftry>
	<cfquery name="local.change">
		UPDATE
			SlatwallOrderReturn
		SET
			currencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="USD" />
		WHERE
			currencyCode is null
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update currencyCode on SlatwallOrderReturn Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cftry>
	<cfquery name="local.change">
		UPDATE
			SlatwallOrderPayment
		SET
			currencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="USD" />
		WHERE
			currencyCode is null
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update currencyCode on SlatwallOrderPayment Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cftry>
	<cfquery name="local.change">
		UPDATE
			SlatwallPaymentTransaction
		SET
			currencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="USD" />
		WHERE
			currencyCode is null
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update currencyCode on SlatwallPaymentTransaction Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cftry>
	<cfquery name="local.change">
		UPDATE
			SlatwallPromotionApplied
		SET
			currencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="USD" />
		WHERE
			currencyCode is null
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update currencyCode on SlatwallPromotionApplied Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cftry>
	<cfquery name="local.change">
		UPDATE
			SlatwallShippingMethodOption
		SET
			currencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="USD" />
		WHERE
			currencyCode is null
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update currencyCode on SlatwallShippingMethodOption Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cftry>
	<cfquery name="local.change">
		UPDATE
			SlatwallStockReceiverItem
		SET
			currencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="USD" />
		WHERE
			currencyCode is null
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update currencyCode on SlatwallStockReceiverItem Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cftry>
	<cfquery name="local.change">
		UPDATE
			SlatwallSubscriptionUsage
		SET
			currencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="USD" />
		WHERE
			currencyCode is null
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update currencyCode on SlatwallSubscriptionUsage Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cftry>
	<cfquery name="local.change">
		UPDATE
			SlatwallTaxApplied
		SET
			currencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="USD" />
		WHERE
			currencyCode is null
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update currencyCode on SlatwallTaxApplied Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cftry>
	<cfquery name="local.change">
		UPDATE
			SlatwallVendorOrder
		SET
			currencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="USD" />
		WHERE
			currencyCode is null
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update currencyCode on SlatwallVendorOrder Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cftry>
	<cfquery name="local.change">
		UPDATE
			SlatwallVendorOrderItem
		SET
			currencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="USD" />
		WHERE
			currencyCode is null
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update currencyCode on SlatwallVendorOrderItem Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cftry>
	<cfquery name="local.change">
		UPDATE
			SlatwallVendorSkuStock
		SET
			currencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="USD" />
		WHERE
			currencyCode is null
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update currencyCode on SlatwallVendorSkuStock Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cftry>
	<cfquery name="local.change">
		UPDATE
			SlatwallOrderItem
		SET
			currencyCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="USD" />
		WHERE
			currencyCode is null
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update currencyCode on SlatwallOrderItem Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<!--- Move amountCharged into amountReceived --->
<cftry>
	<cfdbinfo datasource="#application.configBean.getDataSource()#" type="Columns" table="SlatwallPaymentTransaction" name="local.infoColumns" />
	
	<cfquery name="local.hasColumn" dbtype="query">
		SELECT
			* 
		FROM
			infoColumns
		WHERE
			COLUMN_NAME = 'amountCharged'
	</cfquery>
	
	<cfif local.hasColumn.recordCount>
		<cfquery name="local.updateData">
			UPDATE
				SlatwallPaymentTransaction
			SET
				amountReceived = amountCharged,
				amountCharged = 0
			WHERE
				amountCharged IS NOT NULL
			  AND
			  	amountCharged > 0
		</cfquery>
	<cfelse>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - WHAT!!!!">
	</cfif>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update amountCharged column into amountReceived column Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script v2_2 had errors when running">
	<cfthrow detail="Part of Script v2_2 had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script v2_2 has run with no errors">
</cfif>
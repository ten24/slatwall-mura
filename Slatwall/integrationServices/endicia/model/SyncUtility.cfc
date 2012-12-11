<cfcomponent extends="Slatwall.com.utility.BaseObject" output="false">
	
	<cffunction name="syncPush" access="public" returntype="Any" >
		
		<cfset var responseBean = new Slatwall.com.utility.ResponseBean() />
		<cfset var integration = getService("integrationService").getIntegrationByIntegrationPackage("endicia") /> 
		
		<!--- Setup Remote Dropoff File Location --->
		<cfset var remoteFullFilePath = integration.setting('syncFTPSiteDropoffDirectory') />
		<cfif right(remoteFullFilePath, 1) eq "/" or right(remoteFullFilePath, 1) eq "\">
			<cfset remoteFullFilePath &= integration.setting('syncFTPSiteDropoffFilename') />
		<cfelse>
			<cfset remoteFullFilePath &= "/#integration.setting('syncFTPSiteDropoffFilename')#" />
		</cfif>
		
		<!--- Get all of the order fulfillments we are going to export --->
		<cfset var orderFulfillmentSmartList = getService("orderService").getOrderFulfillmentSmartList() />
		<cfset orderFulfillmentSmartList.addInFilter("fulfillmentMethod.fulfillmentMethodType", "shipping") />
		<cfset orderFulfillmentSmartList.addInFilter("order.orderStatusType.systemCode", "ostNew,ostProcessing,ostOnHold") />
		
		<!--- Setup Local File Name --->
		<cfset localFullFilePath = getTempDirectory() & "endiciaPush.txt" />
		
		<!--- Create a line Array that will be used to write to the file --->
		<cfset var lineArray = arrayNew(1) />
		
		<!--- 1 --->	<cfset arrayAppend(lineArray, "orderFulfillmentID") />
		<!--- 2 --->	<cfset arrayAppend(lineArray, "fulfillmentCharge") />
		<!--- 3 --->	<cfset arrayAppend(lineArray, "order_orderID") />
		<!--- 4 --->	<cfset arrayAppend(lineArray, "order_orderNumber") />
		<!--- 5 --->	<cfset arrayAppend(lineArray, "order_account_accountID") />
		<!--- 6 --->	<cfset arrayAppend(lineArray, "order_account_firstName") />
		<!--- 7 --->	<cfset arrayAppend(lineArray, "order_account_lastName") />
		<!--- 8 --->	<cfset arrayAppend(lineArray, "order_account_emailAddress") />
		<!--- 9 --->	<cfset arrayAppend(lineArray, "order_account_phoneNumber") />
		<!--- 10 --->	<cfset arrayAppend(lineArray, "address_name") />
		<!--- 11 --->	<cfset arrayAppend(lineArray, "address_company") />
		<!--- 12 --->	<cfset arrayAppend(lineArray, "address_phone") />
		<!--- 13 --->	<cfset arrayAppend(lineArray, "address_streetAddress") />
		<!--- 14 --->	<cfset arrayAppend(lineArray, "address_street2Address") />
		<!--- 15 --->	<cfset arrayAppend(lineArray, "address_locality") />
		<!--- 16 --->	<cfset arrayAppend(lineArray, "address_city") />
		<!--- 17 --->	<cfset arrayAppend(lineArray, "address_stateCode") />
		<!--- 18 --->	<cfset arrayAppend(lineArray, "address_postalCode") />
		<!--- 19 --->	<cfset arrayAppend(lineArray, "address_countryCode") />
		<!--- 20 --->	<cfset arrayAppend(lineArray, "shippingMethod_shippingMethodID") />
		<!--- 21 --->	<cfset arrayAppend(lineArray, "shippingMethod_shippingMethodName") />
		<!--- 22 --->	<cfset arrayAppend(lineArray, "shippingMethodRate_shippingMethodRateID") />
		<!--- 23 --->	<cfset arrayAppend(lineArray, "shippingMethodRate_shippingIntegrationMethod") />
		<!--- 24 --->	<cfset arrayAppend(lineArray, "shippingMethodRate_shippingIntegration_integrationPackage") />
		
		<!--- Write First Line Of New File --->
		<cffile action="write" file="#localFullFilePath#" output="#arrayToList(lineArray, chr(9))#" />
		
		<!--- Loop over order fulfillments and append each one to a new line in the file --->
		<cfset var orderFulfillment = "" />
		<cfloop array="#orderFulfillmentSmartList.getRecords()#" index="orderFulfillment">
			<cftry>
				
				<!--- Create fulfillment line --->
				<cfset lineArray = arrayNew(1) />
				
				<!--- 1 --->	<cfset arrayAppend(lineArray, orderFulfillment.getOrderFulfillmentID()) />
				<!--- 2 --->	<cfset arrayAppend(lineArray, coalesce(orderFulfillment.getFulfillmentCharge(), 0)) />
				<!--- 3 --->	<cfset arrayAppend(lineArray, orderFulfillment.getOrder().getOrderID()) />
				<!--- 4 --->	<cfset arrayAppend(lineArray, orderFulfillment.getOrder().getOrderNumber()) />
				<!--- 5 --->	<cfset arrayAppend(lineArray, orderFulfillment.getOrder().getAccount().getAccountID()) />
				<!--- 6 --->	<cfset arrayAppend(lineArray, orderFulfillment.getOrder().getAccount().getFirstName()) />
				<!--- 7 --->	<cfset arrayAppend(lineArray, orderFulfillment.getOrder().getAccount().getLastName()) />
				<!--- 8 --->	<cfset arrayAppend(lineArray, orderFulfillment.getOrder().getAccount().getEmailAddress()) />
				<!--- 9 --->	<cfset arrayAppend(lineArray, orderFulfillment.getOrder().getAccount().getPhoneNumber()) />
				<!--- 10 --->	<cfset arrayAppend(lineArray, coalesce(orderFulfillment.getAddress().getName(), "")) />
				<!--- 11 --->	<cfset arrayAppend(lineArray, coalesce(orderFulfillment.getAddress().getCompany(), "")) />
				<!--- 12 --->	<cfset arrayAppend(lineArray, coalesce(orderFulfillment.getAddress().getPhone(), "")) />
				<!--- 13 --->	<cfset arrayAppend(lineArray, coalesce(orderFulfillment.getAddress().getStreetAddress(), "")) />
				<!--- 14 --->	<cfset arrayAppend(lineArray, coalesce(orderFulfillment.getAddress().getStreet2Address(), "")) />
				<!--- 15 --->	<cfset arrayAppend(lineArray, coalesce(orderFulfillment.getAddress().getLocality(), "")) />
				<!--- 16 --->	<cfset arrayAppend(lineArray, coalesce(orderFulfillment.getAddress().getCity(), "")) />
				<!--- 17 --->	<cfset arrayAppend(lineArray, coalesce(orderFulfillment.getAddress().getStateCode(), "")) />
				<!--- 18 --->	<cfset arrayAppend(lineArray, coalesce(orderFulfillment.getAddress().getPostalCode(), "")) />
				<!--- 19 --->	<cfset arrayAppend(lineArray, coalesce(orderFulfillment.getAddress().getCountryCode(), "")) />
				<!--- 20 --->	<cfset arrayAppend(lineArray, orderFulfillment.getShippingMethod().getShippingMethodID()) />
				<!--- 21 --->	<cfset arrayAppend(lineArray, orderFulfillment.getShippingMethod().getShippingMethodName()) />
				<cfif not isNull(orderFulfillment.getShippingMethodRate())>
					<!--- 22 --->	<cfset arrayAppend(lineArray, orderFulfillment.getShippingMethodRate().getShippingMethodRateID()) />
					<!--- 23 --->	<cfset arrayAppend(lineArray, orderFulfillment.getShippingMethodRate().getShippingIntegrationMethod()) />
					<cfif not isNull(orderFulfillment.getShippingMethodRate().getShippingIntegration())>
						<!--- 24 --->	<cfset arrayAppend(lineArray, orderFulfillment.getShippingMethodRate().getShippingIntegration().getIntegrationPackage()) />
					<cfelse>
						<!--- 24 --->	<cfset arrayAppend(lineArray, "") />
					</cfif>
				<cfelse>
					<!--- 22 --->	<cfset arrayAppend(lineArray, "") />
					<!--- 23 --->	<cfset arrayAppend(lineArray, "") />
					<!--- 24 --->	<cfset arrayAppend(lineArray, "") />
				</cfif>
				
				<!--- Write this line to the file --->
				<cffile action="append" file="#localFullFilePath#" output="#arrayToList(lineArray, chr(9))#" addnewline="true" />
				
				<cfcatch>
					<cfset responseBean.addError("line", "There was an error adding one of the order fulfillments to the export file, but others may have exported") />
				</cfcatch>
			</cftry>
		</cfloop>
		
		<cftry>
			
			<!---[SEVER CONDITIONAL]--->
			<cfif not structKeyExists(server, "railo")>
				<cfftp action="putfile" server="#integration.setting('syncFTPSite')#" username="#integration.setting('syncFTPSiteUsername')#" password="#integration.setting('syncFTPSitePassword')#" port="#integration.setting('syncFTPSitePort')#" remotefile="#remoteFullFilePath#" localfile="#localFullFilePath#">
			<cfelse>
				<cfinclude template="cfftp_acfonly.cfm" />
			</cfif>

			<cfcatch>
				<cfset logSlatwallException(cfcatch) />
				<cfset responseBean.addError("ftp", "There was an error connecting to the sync ftp server.  Please check your setting credentials and try again") />
			</cfcatch>
		</cftry>
		
		<cfreturn responseBean />	
	</cffunction>
	
	<cffunction name="syncPull" access="public" returntype="Any" >
		<cfset var responseBean = new Slatwall.com.utility.ResponseBean() />
		
		<cfset responseBean.addError("test", "This is a test error") />
		
		<cfreturn responseBean />		
	</cffunction>
</cfcomponent>
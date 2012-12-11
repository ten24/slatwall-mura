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
<cfcomponent extends="BaseDAO">
	
	<cffunction name="getOrderReport" returntype="Query" access="public">
		<cfargument name="startDate" default="" />
		<cfargument name="endDate" default="#now()#" />
		
		<cfset var i = 0 />
		<cfset var cd = "" /> <!--- Used in loops for "Current Date" --->
		<cfset var cc = "" /> <!--- Used in loops for "Current Column" --->
		<cfset var cq = "" /> <!--- Used in loops for "Current Query" --->
		<cfset var rs = queryNew('empty') />
		<cfset var cartCreated = queryNew('empty') />
		<cfset var orderPlaced = queryNew('empty') />
		<cfset var orderClosed = queryNew('empty') />
		<cfset var queryList = "cartCreated,orderPlaced,orderClosed" />
		<cfset var columnList = "
				OrderCount,
				SubtotalBeforeDiscount,
				SubtotalAfterDiscount,
				ItemDiscount,
				FulfillmentBeforeDiscount,
				FulfillmentAfterDiscount,
				FulfillmentDiscount,
				TaxBeforeDiscount,
				TaxAfterDiscount,
				TaxDiscount,
				OrderDiscount,
				TotalBeforeDiscount,
				TotalAfterDiscount," />
				
		<cfset var fullColumnList = "Day,Month,Year" />
		
		<cfloop list="#queryList#" index="cq">
			<cfloop list="#columnList#" index="cc">
				<cfset fullColumnList = listAppend(fullColumnList, "#trim(cq)##trim(cc)#") />
			</cfloop>
		</cfloop>
		
		<cfset var orderReport = queryNew(fullColumnList) />
		
		<cfif arguments.startDate eq "">
			<cfquery name="rs">
				SELECT min(createdDateTime) as 'createdDateTime' FROM SlatwallOrder
			</cfquery>
			<cfif rs.recordCount>
				<cfset startDate = rs.createdDateTime />
			</cfif>
		</cfif>
		
		<cfquery name="cartCreated">
			SELECT
				#MSSQL_DATEPART('DD', 'SlatwallOrder.createdDateTime')# as 'DD',
				#MSSQL_DATEPART('MM', 'SlatwallOrder.createdDateTime')# as 'MM',
				#MSSQL_DATEPART('YYYY', 'SlatwallOrder.createdDateTime')# as 'YYYY',
				COUNT(SlatwallOrder.orderID) as 'OrderCount',
				SUM(SlatwallOrderItem.price * SlatwallOrderItem.quantity) as 'SubtotalBeforeDiscount',
				SUM(SlatwallOrderItem.price * SlatwallOrderItem.quantity) - COALESCE(SUM(SlatwallPromotionApplied.discountAmount),0) as 'SubtotalAfterDiscount',
				SUM(SlatwallPromotionApplied.discountAmount) as 'ItemDiscount',
				SUM(SlatwallOrderFulfillment.fulfillmentCharge) as 'FulfillmentBeforeDiscount',
				SUM(SlatwallOrderFulfillment.fulfillmentCharge) as 'FulfillmentAfterDiscount',
				0 as 'FulfillmentDiscount',
				SUM(SlatwallTaxApplied.taxAmount) as 'TaxBeforeDiscount',
				SUM(SlatwallTaxApplied.taxAmount) as 'TaxAfterDiscount',
				0 as 'TaxDiscount',
				0 as 'OrderDiscount',
				(SUM(SlatwallOrderItem.price * SlatwallOrderItem.quantity) + SUM(SlatwallOrderFulfillment.fulfillmentCharge) + SUM(SlatwallTaxApplied.taxAmount)) as 'TotalBeforeDiscount',
				(SUM(SlatwallOrderItem.price * SlatwallOrderItem.quantity) + SUM(SlatwallOrderFulfillment.fulfillmentCharge) + SUM(SlatwallTaxApplied.taxAmount)) -
				  COALESCE(SUM(SlatwallPromotionApplied.discountAmount),0) as 'TotalAfterDiscount'
			FROM
				SlatwallOrder
			  INNER JOIN
			  	SlatwallOrderItem on SlatwallOrder.orderID = SlatwallOrderItem.orderID
			  LEFT JOIN
			  	SlatwallTaxApplied on SlatwallOrderItem.orderItemID = SlatwallTaxApplied.orderItemID
			  LEFT JOIN
			  	SlatwallPromotionApplied on SlatwallOrderItem.orderItemID = SlatwallPromotionApplied.orderItemID
			  LEFT JOIN
			  	SlatwallOrderFulfillment on SlatwallOrder.orderID = SlatwallOrderFulfillment.orderID
			WHERE
				SlatwallOrder.createdDateTime is not null
			  and
			  	SlatwallOrder.createdDateTime >= <cfqueryparam cfsqltype="cf_sql_date" value="#startDate#">
			  and
			  	SlatwallOrder.createdDateTime <= <cfqueryparam cfsqltype="cf_sql_date" value="#endDate + 1#">
			GROUP BY
				#MSSQL_DATEPART('DD', 'SlatwallOrder.createdDateTime')#,
				#MSSQL_DATEPART('MM', 'SlatwallOrder.createdDateTime')#,
				#MSSQL_DATEPART('YYYY', 'SlatwallOrder.createdDateTime')#
			ORDER BY
				#MSSQL_DATEPART('YYYY', 'SlatwallOrder.createdDateTime')# asc,
				#MSSQL_DATEPART('MM', 'SlatwallOrder.createdDateTime')# asc,
				#MSSQL_DATEPART('DD', 'SlatwallOrder.createdDateTime')# asc
		</cfquery>
		<cfquery name="orderPlaced">
			SELECT
				#MSSQL_DATEPART('DD', 'SlatwallOrder.orderOpenDateTime')# as 'DD',
				#MSSQL_DATEPART('MM', 'SlatwallOrder.orderOpenDateTime')# as 'MM',
				#MSSQL_DATEPART('YYYY', 'SlatwallOrder.orderOpenDateTime')# as 'YYYY',
				COUNT(SlatwallOrder.orderID) as 'OrderCount',
				SUM(SlatwallOrderItem.price * SlatwallOrderItem.quantity) as 'SubtotalBeforeDiscount',
				SUM(SlatwallOrderItem.price * SlatwallOrderItem.quantity) - COALESCE(SUM(SlatwallPromotionApplied.discountAmount),0) as 'SubtotalAfterDiscount',
				SUM(SlatwallPromotionApplied.discountAmount) as 'ItemDiscount',
				SUM(SlatwallOrderFulfillment.fulfillmentCharge) as 'FulfillmentBeforeDiscount',
				SUM(SlatwallOrderFulfillment.fulfillmentCharge) as 'FulfillmentAfterDiscount',
				0 as 'FulfillmentDiscount',
				SUM(SlatwallTaxApplied.taxAmount) as 'TaxBeforeDiscount',
				SUM(SlatwallTaxApplied.taxAmount) as 'TaxAfterDiscount',
				0 as 'TaxDiscount',
				0 as 'OrderDiscount',
				(SUM(SlatwallOrderItem.price * SlatwallOrderItem.quantity) + SUM(SlatwallOrderFulfillment.fulfillmentCharge) + SUM(SlatwallTaxApplied.taxAmount)) as 'TotalBeforeDiscount',
				(SUM(SlatwallOrderItem.price * SlatwallOrderItem.quantity) + SUM(SlatwallOrderFulfillment.fulfillmentCharge) + SUM(SlatwallTaxApplied.taxAmount)) -
				  COALESCE(SUM(SlatwallPromotionApplied.discountAmount),0) as 'TotalAfterDiscount'
			FROM
				SlatwallOrder
			  INNER JOIN
			  	SlatwallOrderItem on SlatwallOrder.orderID = SlatwallOrderItem.orderID
			  LEFT JOIN
			  	SlatwallTaxApplied on SlatwallOrderItem.orderItemID = SlatwallTaxApplied.orderItemID
			  LEFT JOIN
			  	SlatwallPromotionApplied on SlatwallOrderItem.orderItemID = SlatwallPromotionApplied.orderItemID
			  LEFT JOIN
			  	SlatwallOrderFulfillment on SlatwallOrder.orderID = SlatwallOrderFulfillment.orderID
			WHERE
				SlatwallOrder.orderOpenDateTime is not null
			  and
			  	SlatwallOrder.orderOpenDateTime >= <cfqueryparam cfsqltype="cf_sql_date" value="#startDate#">
			  and
			  	SlatwallOrder.orderOpenDateTime <= <cfqueryparam cfsqltype="cf_sql_date" value="#endDate + 1#">
			GROUP BY
				#MSSQL_DATEPART('DD', 'SlatwallOrder.orderOpenDateTime')#,
				#MSSQL_DATEPART('MM', 'SlatwallOrder.orderOpenDateTime')#,
				#MSSQL_DATEPART('YYYY', 'SlatwallOrder.orderOpenDateTime')#
			ORDER BY
				#MSSQL_DATEPART('YYYY', 'SlatwallOrder.orderOpenDateTime')# asc,
				#MSSQL_DATEPART('MM', 'SlatwallOrder.orderOpenDateTime')# asc,
				#MSSQL_DATEPART('DD', 'SlatwallOrder.orderOpenDateTime')# asc
		</cfquery>
		<cfquery name="orderClosed">
			SELECT
				#MSSQL_DATEPART('DD', 'SlatwallOrder.orderCloseDateTime')# as 'DD',
				#MSSQL_DATEPART('MM', 'SlatwallOrder.orderCloseDateTime')# as 'MM',
				#MSSQL_DATEPART('YYYY', 'SlatwallOrder.orderCloseDateTime')# as 'YYYY',
				COUNT(SlatwallOrder.orderID) as 'OrderCount',
				SUM(SlatwallOrderItem.price * SlatwallOrderItem.quantity) as 'SubtotalBeforeDiscount',
				SUM(SlatwallOrderItem.price * SlatwallOrderItem.quantity) - COALESCE(SUM(SlatwallPromotionApplied.discountAmount),0) as 'SubtotalAfterDiscount',
				SUM(SlatwallPromotionApplied.discountAmount) as 'ItemDiscount',
				SUM(SlatwallOrderFulfillment.fulfillmentCharge) as 'FulfillmentBeforeDiscount',
				SUM(SlatwallOrderFulfillment.fulfillmentCharge) as 'FulfillmentAfterDiscount',
				0 as 'FulfillmentDiscount',
				SUM(SlatwallTaxApplied.taxAmount) as 'TaxBeforeDiscount',
				SUM(SlatwallTaxApplied.taxAmount) as 'TaxAfterDiscount',
				0 as 'TaxDiscount',
				0 as 'OrderDiscount',
				(SUM(SlatwallOrderItem.price * SlatwallOrderItem.quantity) + SUM(SlatwallOrderFulfillment.fulfillmentCharge) + SUM(SlatwallTaxApplied.taxAmount)) as 'TotalBeforeDiscount',
				(SUM(SlatwallOrderItem.price * SlatwallOrderItem.quantity) + SUM(SlatwallOrderFulfillment.fulfillmentCharge) + SUM(SlatwallTaxApplied.taxAmount)) -
				  COALESCE(SUM(SlatwallPromotionApplied.discountAmount),0) as 'TotalAfterDiscount'
			FROM
				SlatwallOrder
			  INNER JOIN
			  	SlatwallOrderItem on SlatwallOrder.orderID = SlatwallOrderItem.orderID
			  LEFT JOIN
			  	SlatwallTaxApplied on SlatwallOrderItem.orderItemID = SlatwallTaxApplied.orderItemID
			  LEFT JOIN
			  	SlatwallPromotionApplied on SlatwallOrderItem.orderItemID = SlatwallPromotionApplied.orderItemID
			  LEFT JOIN
			  	SlatwallOrderFulfillment on SlatwallOrder.orderID = SlatwallOrderFulfillment.orderID
			WHERE
				SlatwallOrder.orderCloseDateTime is not null
			  and
			  	SlatwallOrder.orderCloseDateTime >= <cfqueryparam cfsqltype="cf_sql_date" value="#startDate#">
			  and
			  	SlatwallOrder.orderCloseDateTime <= <cfqueryparam cfsqltype="cf_sql_date" value="#endDate + 1#">
			GROUP BY
				#MSSQL_DATEPART('DD', 'SlatwallOrder.orderCloseDateTime')#,
				#MSSQL_DATEPART('MM', 'SlatwallOrder.orderCloseDateTime')#,
				#MSSQL_DATEPART('YYYY', 'SlatwallOrder.orderCloseDateTime')#
			ORDER BY
				#MSSQL_DATEPART('YYYY', 'SlatwallOrder.orderCloseDateTime')# asc,
				#MSSQL_DATEPART('MM', 'SlatwallOrder.orderCloseDateTime')# asc,
				#MSSQL_DATEPART('DD', 'SlatwallOrder.orderCloseDateTime')# asc
		</cfquery>
		
		<cfset queryAddRow(orderReport, dateDiff("d", arguments.startDate, arguments.endDate)+1) />
		
		<cfset i=0 />
		<cfloop from="#arguments.startDate#" to="#arguments.endDate#" index="cd">
			<cfset i++ />
			
			<cfset orderReport['Day'][i] = dateFormat(cd, "DD") />
			<cfset orderReport['Month'][i] = dateFormat(cd, "MM") />
			<cfset orderReport['Year'][i] = dateFormat(cd, "YYYY") />
		</cfloop>
		
		<cfset i=0 />
		<cfloop from="#arguments.startDate#" to="#arguments.endDate#" index="cd">
			<cfset i++ />
						
			<cfloop list="#queryList#" index="cq" >
				<cfquery dbtype="query" name="rs">
					SELECT
						OrderCount,
						SubtotalBeforeDiscount,
						SubtotalAfterDiscount,
						ItemDiscount,
						FulfillmentBeforeDiscount,
						FulfillmentAfterDiscount,
						FulfillmentDiscount,
						TaxBeforeDiscount,
						TaxAfterDiscount,
						TaxDiscount,
						OrderDiscount,
						TotalBeforeDiscount,
						TotalAfterDiscount
					FROM
						<cfif cq eq "cartCreated">
							cartCreated
						<cfelseif cq eq "orderPlaced">
							orderPlaced
						<cfelseif cq eq "orderClosed">
							orderClosed
						</cfif>
					WHERE
						DD = <cfqueryparam cfsqltype="cf_sql_integer" value="#dateFormat(cd, "DD")#">
					  AND
						MM = <cfqueryparam cfsqltype="cf_sql_integer" value="#dateFormat(cd, "MM")#">
					  AND
						YYYY = <cfqueryparam cfsqltype="cf_sql_integer" value="#dateFormat(cd, "YYYY")#">
				</cfquery>
				
				<cfloop list="#columnList#" index="cc">
					<cfif rs.recordCount gt 0 and isNumeric(rs[ "#trim(cc)#" ][1])>
						<cfset querySetCell(orderReport,'#trim(cq)##trim(cc)#',rs[ "#trim(cc)#" ][1],i) />
					<cfelse>
						<cfset querySetCell(orderReport,'#trim(cq)##trim(cc)#',0,i) />
					</cfif>
				</cfloop>
			</cfloop>
		</cfloop>
		
		<cfreturn orderReport />
	</cffunction>
	
	<cffunction name="MSSQL_DATEPART" access="private">
		<cfargument name="datePart" type="string" hint="Values for this are: DD, MM, YYYY" />
		<cfargument name="dateColumn" type="string" />
		
		<cfif application.configBean.getDBType() eq "mssql">
			<cfreturn "DATEPART(#arguments.datePart#, #arguments.dateColumn#)" />
		<cfelseif application.configBean.getDBType() eq "mysql">
			
			<cfif arguments.datePart eq "DD">
				<cfset arguments.datePart = "DAY" />
			<cfelseif arguments.datePart eq "MM">
				<cfset arguments.datePart = "MONTH" />
			<cfelseif arguments.datePart eq "YYYY">
				<cfset arguments.datePart = "YEAR" />
			</cfif>
			
			<cfreturn "EXTRACT(#arguments.datePart# FROM #arguments.dateColumn#)" />
		</cfif>
		
		<cfreturn "" />
	</cffunction>
	
</cfcomponent>

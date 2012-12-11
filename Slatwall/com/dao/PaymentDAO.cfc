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
<cfcomponent extends="BaseDAO" output="false">
	
	<cffunction name="isDuplicatePaymentTransaction" access="public" returntype="boolean" output="false">
		<cfargument name="paymentID" type="string" required="true" />
		<cfargument name="idColumnName" type="string" required="true" />
		<cfargument name="paymentType" type="string" required="true" />
		<cfargument name="transactionType" type="string" required="true" />
		<cfargument name="transactionAmount" type="numeric" required="true" />
		
		<cfset var rs = "" />
		
		<!--- check for any transaction for this payment in last 60 sec with same type and amount --->
		<cfquery name="rs" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			SELECT
				#idColumnName#
			FROM
				SlatwallPaymentTransaction 
			WHERE
				#idColumnName# = <cfqueryparam value="#arguments.paymentID#" cfsqltype="cf_sql_varchar" />
			  AND
				transactionType = <cfqueryparam value="#arguments.transactionType#" cfsqltype="cf_sql_varchar" />
			  AND
				modifiedDateTime > <cfqueryparam value="#DateAdd("n",-60,now())#" cfsqltype="cf_sql_date" />
			  AND 
				(
					amountAuthorized = <cfqueryparam value="#arguments.transactionAmount#" cfsqltype="cf_sql_numeric" />
					OR
					amountReceived = <cfqueryparam value="#arguments.transactionAmount#" cfsqltype="cf_sql_numeric" />
					OR
					amountCredited = <cfqueryparam value="#arguments.transactionAmount#" cfsqltype="cf_sql_numeric" />
				)
		</cfquery>
		
		<cfreturn rs.recordcount />
	</cffunction>

</cfcomponent>
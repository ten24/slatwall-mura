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
	
	<cffunction name="getUnusedProductOptions" returntype="any" access="public">
		<cfargument name="productID" type="string" required="true" />
		<cfargument name="existingOptionGroupIDList" type="string" required="true" />
		
		<cfset var rs = "" />
		<cfset var result = [] />
		
		<cfquery name="rs">
			SELECT
				SlatwallOption.optionID,
				slatwallOption.optionName,
				slatwallOptionGroup.optionGroupName
			FROM
				slatwallOption
			  INNER JOIN
			  	slatwallOptionGroup on slatwallOptionGroup.optionGroupID = slatwallOption.optionGroupID
			WHERE
				slatwallOption.optionGroupID IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.existingOptionGroupIDList#" list="true">)
			  AND
			  	NOT EXISTS(
			  		SELECT DISTINCT
						a.optionID
					FROM
					  	SlatwallSkuOption a
					  INNER JOIN
					  	SlatwallSku b on a.skuID = b.skuID
					WHERE
					  	b.productID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productID#">
					  AND
					  	a.optionID = SlatwallOption.optionID 
			  	)
			ORDER BY
				SlatwallOptionGroup.optionGroupName,
				SlatwallOption.optionName
		</cfquery>
		
		<cfloop query="rs">
			<cfset arrayAppend(result, {name="#rs.optionGroupName# - #rs.optionName#", value=rs.optionID}) />
		</cfloop>
		
		<cfreturn result />
	</cffunction>
	
	<cffunction name="getUnusedProductOptionGroups">
		<cfargument name="existingOptionGroupIDList" type="string" required="true" />
		
		<cfset var result = [] />
		<cfset var rs = "" />
		
		<cfquery name="rs">
			SELECT
				SlatwallOptionGroup.optionGroupID,
				slatwallOptionGroup.optionGroupName
			FROM
				SlatwallOptionGroup
			WHERE
				SlatwallOptionGroup.optionGroupID NOT IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.existingOptionGroupIDList#" list="true">)
			ORDER BY 
				SlatwallOptionGroup.optionGroupName
		</cfquery>
		
		<cfloop query="rs">
			<cfset arrayAppend(result, {name=rs.optionGroupName, value=rs.optionGroupID}) />
		</cfloop>
		
		<cfreturn result />
	</cffunction>

</cfcomponent>

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
	
	<cffunction name="getTableTopSortOrder">
		<cfargument name="tableName" type="string" required="true" />
		<cfargument name="contextIDColumn" type="string" />
		<cfargument name="contextIDValue" type="string" />
		
		<cfset var rs = "" />
		
		<cfquery name="rs">
			SELECT
				COALESCE(max(sortOrder), 0) as topSortOrder
			FROM
				#tableName#
			<cfif structKeyExists(arguments, "contextIDColumn") && structKeyExists(arguments, "contextIDValue")>
				WHERE
					#contextIDColumn# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contextIDValue#" />		
			</cfif>
		</cfquery>
		
		<cfreturn rs.topSortOrder />
	</cffunction>
	
	<cffunction name="updateRecordSortOrder">
		<cfargument name="recordIDColumn" />
		<cfargument name="recordID" />
		<cfargument name="tableName" />
		<cfargument name="newSortOrder" />
		<cfargument name="contextIDColumn" />
		<cfargument name="contextIDValue" />
		
		<cfset var rs = "" />
		<cfset var topSortOrder = getTableTopSortOrder(argumentcollection=arguments) />
		
		<cftry>
			<cflock timeout="60" name="updateSortOrder#arguments.tableName#">
				<cftransaction>
					<!--- Get the records original sort order --->
					<cfquery name="rs">
						SELECT COALESCE(sortOrder,0) as sortOrder FROM #arguments.tableName# WHERE #recordIDColumn# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.recordID#" />
					</cfquery>
					
					<!--- If the original sort order doesn't exist, then set it as the max + 1 --->
					<cfif rs.sortOrder eq 0>
						<cfset rs.sortOrder = 1000000 />
					</cfif>
					
					<cfif rs.sortOrder eq 1000000 and arguments.newSortOrder gt topSortOrder>
						<cfset arguments.newSortOrder = topSortOrder + 1 />
					<cfelseif arguments.newSortOrder gt topSortOrder>
						<cfset arguments.newSortOrder = topSortOrder />
					</cfif>
					
					<!--- Move everything after the record's old sortOrder down 1 --->
					<cfquery name="rs">
						UPDATE
							#arguments.tableName#
						SET
							sortOrder = sortOrder - 1
						WHERE
							sortOrder > <cfqueryparam cfsqltype="cf_sql_integer" value="#rs.sortOrder#" />
							<cfif structKeyExists(arguments, "contextIDColumn") and len(arguments.contextIDColumn)>
							  and
								#arguments.contextIDColumn# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contextIDValue#" />
							</cfif>
					</cfquery>
					
					
					<!--- Move everything including the existing record in the spot of the new sortOrder up 1 --->
					<cfquery name="rs">
						UPDATE
							#arguments.tableName#
						SET
							sortOrder = sortOrder + 1
						WHERE
							sortOrder >= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.newSortOrder#" />
							<cfif structKeyExists(arguments, "contextIDColumn") and len(arguments.contextIDColumn)>
							  and
								#arguments.contextIDColumn# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contextIDValue#" />
							</cfif>
					</cfquery>
					
					<!--- Update the record with it's new sort order --->
					<cfquery name="rs">
						UPDATE
							#arguments.tableName#
						SET
							sortOrder = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.newSortOrder#" />
						WHERE
							#recordIDColumn# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.recordID#" />
					</cfquery>
				</cftransaction>
			</cflock>
			<cfcatch>
				<cfset getService("UtilityLogService").logException(cfcatch) />
			</cfcatch>
		</cftry>
		
	</cffunction>
	
	<cffunction name="recordUpdate" returntype="void">
		<cfargument name="tableName" required="true" type="string" />
		<cfargument name="idColumns" required="true" type="string" />
		<cfargument name="updateData" required="true" type="struct" />
		<cfargument name="insertData" required="true" type="struct" />
		
		<cfset var keyList = structKeyList(arguments.updateData) />
		<cfset var rs = "" />
		<cfset var sqlResult = "" />
		<cfset var i = 0 />
		
		<cfquery datasource="#application.configBean.getDataSource()#" name="rs" result="sqlResult">
			UPDATE
				#arguments.tableName#
			SET
				<cfloop from="1" to="#listLen(keyList)#" index="i">
					<cfif arguments.updateData[ listGetAt(keyList, i) ].value eq "NULL">
						#listGetAt(keyList, i)# = <cfqueryparam cfsqltype="cf_sql_#arguments.updateData[ listGetAt(keyList, i) ].dataType#" value="" null="yes">
					<cfelse>
						#listGetAt(keyList, i)# = <cfqueryparam cfsqltype="cf_sql_#arguments.updateData[ listGetAt(keyList, i) ].dataType#" value="#arguments.updateData[ listGetAt(keyList, i) ].value#">
					</cfif>
					<cfif listLen(keyList) gt i>, </cfif>
				</cfloop>
			WHERE
				<cfloop from="1" to="#listLen(arguments.idColumns)#" index="i">
					#listGetAt(arguments.idColumns, i)# = <cfqueryparam cfsqltype="cf_sql_#arguments.updateData[ listGetAt(arguments.idColumns, i) ].datatype#" value="#arguments.updateData[ listGetAt(arguments.idColumns, i) ].value#">
					<cfif listLen(arguments.idColumns) gt i>AND </cfif>
				</cfloop>
		</cfquery>
		<cfif !sqlResult.recordCount>
			<cfset recordInsert(tableName=arguments.tableName, insertData=arguments.insertData) />
		</cfif>
	</cffunction>
	
	<cffunction name="recordInsert" returntype="void">
		<cfargument name="tableName" required="true" type="string" />
		<cfargument name="insertData" required="true" type="struct" />
		
		<cfset var keyList = structKeyList(arguments.insertData) />
		<cfset var rs = "" />
		<cfset var sqlResult = "" />
		<cfset var i = 0 />
		
		<cfquery datasource="#application.configBean.getDataSource()#" name="rs" result="sqlResult"> 
			INSERT INTO	#arguments.tableName# (
				#keyList#
			) VALUES (
				<cfloop from="1" to="#listLen(keyList)#" index="i">
					<cfif arguments.insertData[ listGetAt(keyList, i) ].value eq "NULL">
						<cfqueryparam cfsqltype="cf_sql_#arguments.insertData[ listGetAt(keyList, i) ].dataType#" value="" null="yes">
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_#arguments.insertData[ listGetAt(keyList, i) ].dataType#" value="#arguments.insertData[ listGetAt(keyList, i) ].value#">
					</cfif>
					<cfif listLen(keyList) gt i>,</cfif>
				</cfloop>
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="verifyUniqueTableValue" returntype="boolean">
		<cfargument name="tableName" type="string" required="true" />
		<cfargument name="column" type="string" required="true" />
		<cfargument name="value" type="string" required="true" />
		
		<cfset var rs="" />
		
		<cfquery name="rs">
			SELECT #arguments.column# FROM #arguments.tableName# WHERE #arguments.column# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.value#" /> 
		</cfquery>
		
		<cfif rs.recordCount>
			<cfreturn false />
		</cfif>
		
		<cfreturn true />
	</cffunction>
	
	<!--- hint: This method is for doing validation checks to make sure a property value isn't already in use --->
	<cffunction name="isUniqueProperty">
		<cfargument name="propertyName" required="true" />
		<cfargument name="entity" required="true" />
		
		<cfset var property = arguments.entity.getPropertyMetaData( arguments.propertyName ).name />  
		<cfset var entityName = arguments.entity.getEntityName() />
		<cfset var entityID = arguments.entity.getPrimaryIDValue() />
		<cfset var entityIDproperty = arguments.entity.getPrimaryIDPropertyName() />
		<cfset var propertyValue = arguments.entity.getValueByPropertyIdentifier( arguments.propertyName ) />
		
		<cfset var results = ormExecuteQuery(" from #entityName# e where e.#property# = :propertyValue and e.#entityIDproperty# != :entityID", {propertyValue=propertyValue, entityID=entityID}) />
		
		<cfif arrayLen(results)>
			<cfreturn false />
		</cfif>
		
		<cfreturn true />		
	</cffunction>

</cfcomponent>
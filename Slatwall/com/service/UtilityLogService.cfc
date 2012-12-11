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
<cfcomponent extends="BaseService" persistent="false" accessors="true" output="false">
	
	<cffunction name="logException" returntype="void" access="public">
		<cfargument name="exception" required="true" />
		
		<!--- All logic in this method is inside of a cftry so that it doesnt cause an exception ---> 
		<cftry>
			<cflog file="Slatwall" text="START EXCEPTION" />
			<cfif structKeyExists(arguments.exception, "detail") and isSimpleValue(arguments.exception.detail)>
				<cflog file="Slatwall" text="#arguments.exception.detail#" />
			</cfif>
			<cfif structKeyExists(arguments.exception, "errNumber") and isSimpleValue(arguments.exception.errNumber)>
				<cflog file="Slatwall" text="#arguments.exception.errNumber#" />
			</cfif>
			<cfif structKeyExists(arguments.exception, "message") and isSimpleValue(arguments.exception.message)>
				<cflog file="Slatwall" text="#arguments.exception.message#" />
			</cfif>
			<cfif structKeyExists(arguments.exception, "stackTrace") and isSimpleValue(arguments.exception.stackTrace)>
				<cflog file="Slatwall" text="#arguments.exception.stackTrace#" />
			</cfif>
			<cflog file="Slatwall" text="END EXCEPTION" />
			<cfcatch>
				<cflog file="Slatwall" text="Log Exception Error" />
			</cfcatch>
		</cftry>   
	</cffunction>
	
	<cffunction name="logMessage" returntype="void" access="public">
		<cfargument name="message" default="" />
		<cfargument name="messageType" default="" />
		<cfargument name="messageCode" default="" />
		<cfargument name="templatePath" default="" />
		<cfargument name="logType" default="Information" /><!--- Information  |  Error  |  Fatal  |  Warning  --->
		<cfargument name="generalLog" type="boolean" default="false" />
		
		<cfif setting("globalLogMessages") neq "none" and (setting("globalLogMessages") eq "detail" or arguments.generalLog)>
			<cfif generalLog>
				<cfset var logText = "General Log" />
			<cfelse>
				<cfset var logText = "Detail Log" />
			</cfif>
			
			<cfif arguments.messageType neq "" and isSimpleValue(arguments.messageType)>
				<cfset logText &= " - #arguments.messageType#" />
			</cfif>
			<cfif arguments.messageCode neq "" and isSimpleValue(arguments.messageCode)>
				<cfset logText &= " - #arguments.messageCode#" />
			</cfif>
			<cfif arguments.templatePath neq "" and isSimpleValue(arguments.templatePath)>
				<cfset logText &= " - #arguments.templatePath#" />
			</cfif>
			<cfif arguments.message neq "" and isSimpleValue(arguments.message)>
				<cfset logText &= " - #arguments.message#" />
			</cfif>
			
			<!--- Verify that the log type was correct --->
			<cfif not ListFind("Information,Error,Fatal,Warning", arguments.logType)>
				<cfset logMessage(messageType="Internal Error", messageCode = "500", message="The Log type that was attempted was not valid", logType="Warning") />
				<cfset arguments.logType = "Information" />
			</cfif>
			
			<cflog file="Slatwall" text="#logText#" type="#arguments.logType#" />
		</cfif>
		
	</cffunction>
	
</cfcomponent>
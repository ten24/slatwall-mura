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
<cfcomponent output="false" extends="BaseService">
	
	<cffunction name="init">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="cfcookie">
		<cfargument name="name" type="string" required="true" />
		<cfargument name="value" type="any" required="true" />
		<cfargument name="expires" type="string" default="session only" />
		<cfargument name="secure" type="boolean" default="false" />
		
		<cfcookie name="#arguments.name#" value="#arguments.value#" expires="#arguments.expires#" secure="#arguments.secure#">
	</cffunction>
	
	<cffunction name="cfhtmlhead">
		<cfargument name="text" type="string" required="true" />
		<cfhtmlhead text="#arguments.text#">
	</cffunction>
	
	<cffunction name="cfinvoke" output="false">
		<cfargument name="component" type="any" required="true" hint="CFC name or instance." />
		<cfargument name="method" type="string" required="true" hint="Method name to be invoked." />
		<cfargument name="theArgumentCollection" type="struct" default="#structNew()#" hint="Argument collection to pass to method invocation." />

		<cfset var returnVariable = 0 />
		
		<cfinvoke
			component="#arguments.component#"
			method="#arguments.method#"
			argumentcollection="#arguments.theArgumentCollection#"
			returnvariable="returnVariable"
		/>

		<cfif not isNull( returnVariable )>
			<cfreturn returnVariable />
		</cfif>
	
	</cffunction>
	
	<cffunction name="cfmail" output="false">
		<cfargument name="from" type="string" required="true" />
		<cfargument name="to" type="string" required="true" />
		<cfargument name="subject" default="" />
		<cfargument name="body" default="" />
		<cfargument name="type" default="html" />
		
		<cftry>
			<cfmail attributeCollection="#arguments#">
				#arguments.body#
			</cfmail>
			<cfcatch type="any">
				<cfset logSlatwallException(cfcatch) />
			</cfcatch>
		</cftry>

	</cffunction>
	
	<!--- The script version of http doesn't suppose tab delimiter, it throws error.
		Use this method only when you want to return a query. --->
	<cffunction name="cfhttp" output="false">
		<cfargument name="method" default="" />
		<cfargument name="url" default="" />
		<cfargument name="delimiter" default="" />
		<cfargument name="textqualifier" default="" />
		
		<cfhttp method="#arguments.method#" url="#arguments.url#" name="result" firstrowasheaders="true" textqualifier="#arguments.textqualifier#" delimiter="#arguments.delimiter#">
		
		<cfreturn result />
	</cffunction>
	
	<cffunction name="cfsetting" output="false">
		<cfargument name="enablecfoutputonly" type="boolean" default="false" />
		<cfargument name="requesttimeout" type="numeric" default="30" />
		<cfargument name="showdebugoutput" type="boolean" default="false" />
		
		<cfsetting attributecollection="#arguments#" />
	</cffunction>
	
	<cffunction name="cffile" output="false">
		<cfargument name="action" type="string" />
		
		<cfset var result = "" />
		<cfset var attributes = duplicate(arguments) />
		<cfset structDelete(attributes, "action") />
		
		<cffile attributecollection="#attributes#" action="#arguments.action#" result="result" >
		
		<cfreturn result />
	</cffunction>
	
	<cffunction name="cfdirectory" output="false">
		<cfargument name="action" type="string" />
		
		<cfset var result = "" />
		<cfset var attributes = duplicate(arguments) />
		<cfset structDelete(attributes, "action") />
		
		<cfdirectory attributecollection="#attributes#" action="#arguments.action#" name="result" >
		
		<cfreturn result />
	</cffunction>
	
	<cffunction name="cfcontent" output="false">
		<cfargument name="type" type="string" />
		<cfargument name="file" type="string" />
		<cfargument name="deletefile" type="boolean" default="false" />
		
		<cfcontent attributecollection="#arguments#"  />
	</cffunction>
	
	<cffunction name="cfheader" output="false">
		<cfargument name="name" type="string" />
		<cfargument name="value" type="string" />
		
		<cfheader attributecollection="#arguments#"  />
	</cffunction>
	
</cfcomponent>

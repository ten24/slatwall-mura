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
<cfcomponent extends="mura.plugin.plugincfc" output="false" >
	
	<cfset variables.config = "" />
	
	<cffunction name="init">
		<cfargument name="config" type="any" />
		
		<cfset variables.config = arguments.config />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="install">
		
		<cfset application.appInitialized=false />
	</cffunction>
	
	<cffunction name="update">
		
		<cfset application.appInitialized=false />
	</cffunction>
	
	<cffunction name="delete">
		
		<!--- Remove Slatwall settings from cfApplication.cfm file --->
		<cfset var newCFApplication = "" />
		<cfset var line = "" />
		<cfset var addLine = true />
		
		<cfloop file="#expandPath('/muraWRM/config/cfapplication.cfm')#" index="line" >
			<cfif findNoCase("<!---[START_SLATWALL_CONFIG]--->", line)>
				<cfset addLine = false />
			</cfif>
			<cfif addLine>
				<cfset listAppend(newCFApplication, line, chr(13)) />
			</cfif>
			<cfif findNoCase("<!---[END_SLATWALL_CONFIG]--->", line)>
				<cfset addLine = true />
			</cfif>
		</cfloop>
		
		<cffile action="write" file="#expandPath('/muraWRM/config/cfapplication.cfm')#" output="#additionalCFApplicationContent#" > 
			
		<cfset application.appInitialized=false />
	</cffunction>
	
	<cffunction name="toBundle">
		
		
		<!---
		//Add DB Data to the /plugin/customSettings folder
	    var bundleUtility = createObject("component", "Slatwall.integrationServices.mura.bundleUtility").init();
	    bundleUtility.toBundle(argumentcollection=arguments);
	    --->
	</cffunction>
	
	<cffunction name="fromBundle">
		
			
	</cffunction>
	
</cfcomponent>

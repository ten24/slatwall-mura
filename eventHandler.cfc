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
<cfcomponent extends="mura.plugin.pluginGenericEventHandler">
	
	<cfset variables.config="" />
	
	<cffunction name="init" access="public" returntype="any">
		<cfargument name="config" type="any" />
		
		<cfset variables.config = arguments.config />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="onApplicationLoad" access="public" returntype="any">
		<cfargument name="$" />
		
		<!--- Verify that Slatwall is installed --->
		<cfif not directoryExists(getDirectoryFromPath(getCurrentTemplatePath()) & "Slatwall")>
			
			<!--- Define what the Slatwall directory will be ---> 
			<cfset slatwallDirectoryPath = "#getDirectoryFromPath(getCurrentTemplatePath())#Slatwall" /> 
			
			<!--- start download --->
			<cfhttp url="https://github.com/ten24/Slatwall/archive/feature-standalone.zip" method="get" path="#getTempDirectory()#" file="slatwall.zip" />
			
			<!--- Unzip downloaded file --->
			<cfset var slatwallZipDirectoryList = "" />
			<cfzip action="unzip" destination="#getTempDirectory()#" file="#getTempDirectory()#slatwall.zip" >
			<cfzip action="list" file="#getTempDirectory()#slatwall.zip" name="slatwallZipDirectoryList" >
			
			<!--- Move the directory from where it is in the temp location to this directory --->
			<cfdirectory action="rename" directory="#getTempDirectory()##listFirst(listFirst(slatwallZipDirectoryList.DIRECTORY, "\"), "/")#/" newdirectory="#slatwallDirectoryPath#" />
			
			<!--- Set Application Datasource in custom Slatwall config --->
			<cffile action="write" file="#slatwallDirectoryPath#/config/custom/configApplication.cfm" output='<cfset this.datasource.name = "#$.globalConfig('datasource')#" />'>
			
			<!--- Add the proper mappings to the cfApplication.cfm file --->
			<cfset var oldCFApplication = "" />
			<cffile action="read" file="#expandPath('/muraWRM/config/cfapplication.cfm')#" variable="oldCFApplication" />
			<cfif not findNoCase("<!---[START_SLATWALL_CONFIG]--->", oldCFApplication)>
				<cfset var additionalCFApplicationContent = "" />
				<cffile action="read" file="#slatwallDirectoryPath#/integrationServices/mura/setup/cfapplication.cfm" variable="additionalCFApplicationContent" />
				<cfset additionalCFApplicationContent = replace(additionalCFApplicationContent, "{pathToSlatwallSetupOnInstall}", "#slatwallDirectoryPath#", "all") />
				<cffile action="append" file="#expandPath('/muraWRM/config/cfapplication.cfm')#" output="#additionalCFApplicationContent#" > 
			</cfif> 
				
			<!--- De-Initialize the app so that this can be called again and load the eventHandler --->
			<cfset application.appInitialized = false />
		<cfelse>
			<!--- Add the eventHandler inside of the mura integration to this app --->
			<cfset var slatwallEventHandler = createObject("component", "Slatwall.integrationServices.mura.handler.eventHandler") />
			
			<!--- Add the rest of those methods to the eventHandler --->
			<cfset variables.config.addEventHandler( slatwallEventHandler ) />
		</cfif>
		
		<!--- Setup slatwall as not initialized so that it loads on next request --->
		<cfset application.slatwall.initialized = false />
	</cffunction>
	
	<cffunction name="getCFApplicationCode">
		
	</cffunction>
</cfcomponent>
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
		
		<cfif (not structKeyExists(getAppMeta(), "Mappings") or not structKeyExists(getAppMeta().Mappings, "/Slatwall") and not structKeyExists(application, "slatwallReset"))>
			
			<cfset application.appInitialized=false />
			<cfset application.slatwallReset=true />
			
			<cfset var muraContext = application.configBean.getContext() />
			<cfset var slatwallDirectoryPath = expandPath('#muraContext#/') & "Slatwall" />
			<cfset var slatwallRootPath = expandPath("/Slatwall") />
			<cfset var deleteDestinationContentExclusionList = '/.git,/apps,/integrationServices,/custom,/WEB-INF,/.project,/setting.xml,/.htaccess,/web.config,/.settings,/.gitignore' />
			<cfset var downloadUUID = createUUID() />
			<cfset var downloadFileName = "slatwall-#downloadUUID#.zip" />
			
			<!--- Verify that Slatwall is installed --->
			<cfif not directoryExists(slatwallDirectoryPath)>
				
				<!--- Git Slatwall Fetching --->
				<cfif not variables.config.getSetting('legacyInstallMode')>
					<cfset var repoBranchVersion = variables.config.getSetting('repoBranchVersion') />
					<cfset var repoBranchURL = variables.config.getSetting('repoBranchURL') />
					
					<!--- Using 'master' or 'develop' branch --->
					<cfif repoBranchVersion neq 'branch'>
						<cfset repoBranchURL = "https://github.com/ten24/slatwall/archive/#variables.config.getSetting('repoBranchVersion')#.zip" />
					</cfif>
					
					<cfhttp url="#repoBranchURL#" method="get" path="#getTempDirectory()#" file="#downloadFileName#" throwonerror="true" />
					<!--- <cfdirectory action="create" directory="#slatwallDirectoryPath#"> --->
					
					<!--- Unzip downloaded file --->
					<!--- <cfzip action="unzip" destination="#slatwallDirectoryPath#" file="#getTempDirectory()##downloadFileName#" > --->
					
					<!--- Unzip downloaded file --->
					<cfset var slatwallZipDirectoryList = "" />
					<cfzip action="unzip" destination="#getDirectoryFromPath(expandPath('/'))#" file="#getTempDirectory()##downloadFileName#" >
					<cfzip action="list" file="#getTempDirectory()##downloadFileName#" name="slatwallZipDirectoryList" >
	
					<!--- Move the directory from where it is in the temp location to this directory --->
					<cfdirectory action="rename" directory="#getDirectoryFromPath(expandPath('/'))##listFirst(listFirst(slatwallZipDirectoryList.DIRECTORY, "\"), "/")#" newdirectory="#slatwallDirectoryPath#" />
					
					<!--- Delete the meta directory --->
					<cfif variables.config.getSetting('metaDirectoryRemoval')>
						<cfdirectory action="delete" directory="#slatwallDirectoryPath#/meta" recurse="true" />
					</cfif>
					
					<!--- Set Application Datasource in custom Slatwall config --->
					<cffile action="write" file="#slatwallDirectoryPath#/custom/config/configApplication.cfm" output='<cfif fileExists("../../../config/applicationSettings.cfm")>#chr(13)&chr(10)&chr(09)#<cfinclude template="../../../config/applicationSettings.cfm" />#chr(13)&chr(10)&chr(09)#<cfinclude template="../../../config/mappings.cfm" />#chr(13)&chr(10)#<cfelse>#chr(13)&chr(10)&chr(09)#<cfinclude template="../../../core/appcfc/applicationSettings.cfm" />#chr(13)&chr(10)#</cfif>#chr(13)&chr(10)#<cfinclude template="../../../plugins/mappings.cfm" />'>
					
				<!--- Legacy Installation Mode / AWS Slatwall Fetching --->
				<cfelse>
					<cfset var zipName  = 'slatwall-latest'/> 	
					<cfset var downloadURL = "https://s3.amazonaws.com/slatwall-releases/#zipName#.zip" />
					<cfset var downloadHashURL = "https://s3.amazonaws.com/slatwall-releases/#zipName#.md5.txt" />
					<cfset var downloadHashFileName = "slatwall-#downloadUUID#.md5.txt" />
					
					<!--- start download of zip & hash --->
					<cfhttp url="#downloadURL#" method="get" path="#getTempDirectory()#" file="#downloadFileName#" throwonerror="true" />
					<cfhttp url="#downloadHashURL#" method="get" path="#getTempDirectory()#" file="#downloadHashFileName#" throwonerror="true" />
		
					<!--- Get the MD5 hash of the downloaded file --->
					<cfset var downloadedZipHash = hash(fileReadBinary("#getTempDirectory()##downloadFileName#"), "MD5") />
					<cfset var hashFileValue = listFirst(fileRead("#getTempDirectory()##downloadHashFileName#"), " ") />
		
					<cfif downloadedZipHash eq hashFileValue>
						
						<cfdirectory action="create" directory="#slatwallDirectoryPath#">
	
						<!--- Unzip downloaded file --->
						<cfzip action="unzip" destination="#slatwallDirectoryPath#" file="#getTempDirectory()##downloadFileName#" >
						
						<!--- Delete the meta directory --->
						<cfif variables.config.getSetting('metaDirectoryRemoval')>
							<cfdirectory action="delete" directory="#slatwallDirectoryPath#/meta" recurse="true" />
						</cfif>
						
						<!--- Set Application Datasource in custom Slatwall config --->
						<cffile action="write" file="#slatwallDirectoryPath#/custom/config/configApplication.cfm" output='<cfif fileExists("../../../config/applicationSettings.cfm")>#chr(13)&chr(10)&chr(09)#<cfinclude template="../../../config/applicationSettings.cfm" />#chr(13)&chr(10)&chr(09)#<cfinclude template="../../../config/mappings.cfm" />#chr(13)&chr(10)#<cfelse>#chr(13)&chr(10)&chr(09)#<cfinclude template="../../../core/appcfc/applicationSettings.cfm" />#chr(13)&chr(10)#</cfif>#chr(13)&chr(10)#<cfinclude template="../../../plugins/mappings.cfm" />'>
					
					</cfif>
				</cfif>
			</cfif>
			
			<!--- Add the proper mappings to the cfApplication.cfm file --->
			<cfset var oldCFApplication = "" />
			<cffile action="read" file="#expandPath('/muraWRM/config/cfapplication.cfm')#" variable="oldCFApplication" />
			<cfif not findNoCase("<!---[START_SLATWALL_CONFIG]--->", oldCFApplication)>
				<cfset var additionalCFApplicationContent = "" />
				<cffile action="read" file="#slatwallDirectoryPath#/integrationServices/mura/config/setup/cfapplication.cfm" variable="additionalCFApplicationContent" />
				<cffile action="append" file="#expandPath('/muraWRM/config/cfapplication.cfm')#" output="#additionalCFApplicationContent#"> 
			</cfif>
			
			<!--- Run any pre-update scripts --->
			<cfif not fileExists("#slatwallDirectoryPath#/custom/config/lastFullUpdate.txt.cfm") or not fileExists("#slatwallDirectoryPath#/custom/config/preUpdatesRun.txt.cfm")>
				<cfset var preUpdatesRun = "" />
				<cfset var preUpdateFiles = "" />
				
				<cfif application.configBean.getDbType() eq "mssql">
					<cfset this.ormSettings.dialect = "MicrosoftSQLServer" />	
				<cfelseif application.configBean.getDbType() eq "mysql">
					<cfset this.ormSettings.dialect = "MySQL" />
				<cfelseif application.configBean.getDbType() eq "oracle">
					<cfset this.ormSettings.dialect = "Oracle10g" />
				</cfif>
				
				<cfset this.datasource.name = application.configBean.getDatasource() />
				<cfset this.datasource.username = application.configBean.getDBUsername() />
				<cfset this.datasource.password = application.configBean.getDBPassword() />
					
				<cfif not fileExists("#slatwallDirectoryPath#/custom/config/preUpdatesRun.txt.cfm")>
					<cffile action="write" file="#slatwallDirectoryPath#/custom/config/preUpdatesRun.txt.cfm" output="" />
				</cfif>
				
				<cffile action="read" file="#slatwallDirectoryPath#/custom/config/preUpdatesRun.txt.cfm" variable="preUpdatesRun" />
				
				<cfdirectory action="list" directory="#slatwallDirectoryPath#/config/scripts/preupdate" name="preUpdateFiles" />
				
				<cfloop query="preUpdateFiles">
					<cfset var thisFilename = preUpdateFiles.name />
					
					<cfif not listFindNoCase(preUpdatesRun, thisFilename)>
						<cfinclude template="../../Slatwall/config/scripts/preupdate/#thisFilename#" />
						<cfset preUpdatesRun = listAppend(preUpdatesRun, thisFilename) />
					</cfif>
				</cfloop>
				
				<cffile action="write" file="#slatwallDirectoryPath#/custom/config/preUpdatesRun.txt.cfm" output="#preUpdatesRun#" /> 
			</cfif>
			
			<!--- Redirect the user to the same page they are on --->
			<cfparam name="session.siteid" default="default" />
			<cfset applicationStop() />
			<cflocation url="#muraContext#/admin?muraAction=csettings.list&siteID=#session.siteID#" addtoken="false" />
			
		<cfelseif structKeyExists(getAppMeta(), "Mappings") and structKeyExists(getAppMeta().Mappings, "/Slatwall")>
			
			<!--- Add the rest of those methods to the eventHandler --->
			<cfset variables.config.addEventHandler( getSlatwallEventHandler() ) />
			
			<!--- Call Reload on the Slatwall application so that the verify setup re-instantiates --->
			<cfset getSlatwallApplication().reloadApplication() />
			
			<!--- call the verifySetup method in the event handler, so that we can do any setup stuff --->
			<cfset getSlatwallEventHandler().verifySetup( $=arguments.$ ) />
		</cfif>
		
		<cfset structDelete(application, "slatwallReset") />
	</cffunction>
	
	<cffunction name="onContentEdit" access="public" returntype="any">
		<cfif getBean('configBean').getVersion() lt 6.1> 
			<cfset getSlatwallEventHandler().onContentEdit( argumentcollection=arguments ) />
		</cfif>
	</cffunction>
	
	<cffunction name="getSlatwallEventHandler" returntype="any">
		<cfif not structKeyExists(variables, "slatwallEventHandler")>
			<cfset variables.slatwallEventHandler = createObject("component", "Slatwall.integrationServices.mura.model.handler.MuraEventHandler") />
		</cfif>
		<cfreturn variables.slatwallEventHandler />
	</cffunction>
	
	<cffunction name="getSlatwallApplication" returntype="any">
		<cfif not structKeyExists(variables, "slatwallApplication")>
			<cfset variables.slatwallApplication = createObject("component", "Slatwall.Application") />
		</cfif>
		<cfreturn variables.slatwallApplication />
	</cffunction>
	
	<cffunction name="getAppMeta">
		<cfif listFirst(server.coldfusion.productVersion,",") gte 10 >
			<cfreturn getApplicationMetadata() />
		<cfelse>
			<cfreturn application.getApplicationSettings() />
		</cfif>
	</cffunction>
	
</cfcomponent>

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
		
		<!--- Add the eventHandler inside of the mura integration to this app --->
		<cfset var slatwallEventHandler = createObject("component", "Slatwall.integrationServices.mura.handler.eventHandler") />
		
		<!--- Add the rest of those methods to the eventHandler --->
		<cfset variables.config.addEventHandler( slatwallEventHandler ) />
		
		<!--- Reload the slatwall application --->
		<cfset getSlatwallApplication().reloadApplication() />
		
		<!--- Do a gloabl request setup so that we know the application get setup --->
		<cfset getSlatwallApplication().setupGlobalRequest() />
		
		<!--- call the verifySetup method in the event handler, so that we can do any setup stuff --->
		<cfset slatwallEventHandler.verifySetup( $=arguments.$, config=variables.config ) />
	</cffunction>
	
	<cffunction name="getSlatwallApplication" returntype="any">
		<cfif structKeyExists(variables, "getSlatwallApplication")>
			<cfset variables.slatwallApplication = createObject("component", "Slatwall.Application") />
		</cfif>
		<cfreturn variables.slatwallApplication />
	</cffunction>
	
</cfcomponent>
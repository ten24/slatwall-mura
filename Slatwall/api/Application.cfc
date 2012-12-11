/*

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
	*/

component extends="taffy.core.api" {
	
	// This file gets updated by the onApplicationLoad of the slatwall plugin.  It doesn't exist until the app is reloaded
	include "../../../config/applicationSettings.cfm";
	include "../../../config/mappings.cfm";
	include "../../mappings.cfm";
	
	this.mappings["/taffy"] = getDirectoryFromPath(getCurrentTemplatePath()) & "taffy";
	this.mappings["/resources"] = getDirectoryFromPath(getCurrentTemplatePath()) & "resources";
	
	//use this instead of onApplicationStart()
	public void function applicationStartEvent(){
		
	}
	
	private any function getSlatwallFW1Application() {
		if(!structKeyExists(request, "slatwallFW1Application")) {
			request.slatwallFW1Application = createObject("component", "Slatwall.Application");
		}
		return request.slatwallFW1Application;
	}
	
	//use this instead of onRequestStart()
	public void function requestStartEvent(){
		if(!isDefined('url.reload')) {
			
			// Setup this request with all of the standard Slatwall Stuff including permissions
			getSlatwallFW1Application().onRequestStart(cgi.script_name);
			
			// Make sure that nobody outside of S2 is using the dashboard
			if(structKeyExists(url, "dashboard") && !request.muraScope.currentUser().getS2()) {
				abort;
			}
			
		}
	}
	
	public any function onTaffyRequest(string verb, string cfc, struct requestArguments, string mimeExt, struct headers) {
		if(!isDefined('url.reload')) {
			if(request.muraScope.currentUser().getS2()) {
				return true;
			}
			
			// Identify the API Key and the Resource Requested
			var apiKey = "";
			var resource = "";
			if(structKeyExists(arguments.requestArguments, "apiKey")){
				apiKey = arguments.requestArguments.apiKey;
			}
			if(arguments.cfc == "GenericAbstractResource" && structKeyExists(arguments.requestArguments, "entityNameOrServiceName")) {
				if( right(arguments.requestArguments.entityNameOrServiceName, 7) == "service" ) {
					resource = arguments.requestArguments.entityNameOrServiceName & '/' & arguments.requestArguments.idOrFilterOrServiceMethod;
				} else {
					resource = arguments.requestArguments.entityNameOrServiceName;
				}
			} else {
				resource = arguments.cfc;
			}

			// Check the session to see if that API Key was granted for that resource
			if(request.slatwallScope.getService("sessionService").verifyAPIKey(resource=resource, verb=arguments.verb, apiKey=apiKey)){
				return true;
			}
			
			return createObject("component", "taffy.core.nativeJsonRepresentation").noData().withStatus(403);
		}
	}
	
	//override the onRequest so that we can invoke our lifecycle end
	public void function onRequest( targetPage ){
		var result = super.onRequest( targetPage );
		if(!isDefined('url.reload')) {
			getSlatwallFW1Application().endSlatwallLifecycle();
		}
	}
}
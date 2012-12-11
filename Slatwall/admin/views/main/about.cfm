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
<cfoutput>
<div class="svohelpabout">
	<strong>Documentation: </strong><a href="http://docs.getslatwall.com">http://docs.getslatwall.com</a><br /><br />
	<strong>Google Group: </strong><a href="http://groups.google.com/group/slatwallecommerce">http://groups.google.com/group/slatwallecommerce</a><br /><br />
	<strong>Feature & Bug Tracking: </strong><a href="https://github.com/ten24/Slatwall/issues">https://github.com/ten24/Slatwall/issues</a><br /><br />
	<strong>Debugging Details: </strong>Please Copy & Paste these debugging details to any issues submitted<br /><br />
	<textarea name="debugDetails" style="width:100%; height:500px;">
Operating System:	#server.os.name#
CFML Server:		#server.coldfusion.productName#: <cfif structKeyExists(server,"railo")>#server.railo.version#<cfelse>#server.coldfusion.productVersion#</cfif>
DB Dialect: 		#application.configBean.getDBType()#
Slatwall Version:	#rc.$.slatwall.getApplicationValue('version')#
Current User Perm:	#$.slatwall.getCurrentAccount().getAllPermissions()#
	</textarea>
</div>
</cfoutput>

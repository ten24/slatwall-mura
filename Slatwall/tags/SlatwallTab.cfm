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
<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.view" type="string" />
	<cfparam name="attributes.tabid" type="string" default="" />
	<cfparam name="attributes.text" type="string" default="" />
	<cfparam name="attributes.params" type="struct" default="#structNew()#" />
	<cfparam name="attributes.count" type="string" default="0" />
	
	<cfif not len(attributes.tabid)>
		<cfset attributes.tabid = "tab" & listLast(attributes.view, '/') />
	</cfif>
	
	<cfif not len(attributes.text)>
		<cfset attributes.text = request.slatwallScope.rbKey( replace( replace(attributes.view, '/', '.', 'all') ,':','.','all' ) ) />
	</cfif>
	
	<cfassociate basetag="cf_SlatwallTabGroup" datacollection="tabs">
</cfif>
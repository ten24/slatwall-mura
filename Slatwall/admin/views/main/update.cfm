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
<cfparam name="rc.currentVersion" type="string" />
<cfparam name="rc.currentBranch" type="string" />
<cfparam name="rc.availableDevelopVersion" type="string" />
<cfparam name="rc.availableMasterVersion" type="string" />

<cfset local.updateOptions = [{name="Stable", value="master"},{name="Bleeding Edge", value="develop"}] />

<cfif rc.currentBranch eq 'master'>
	<cfset local.currentReleaseType = $.slatwall.rbKey('define.master') />
<cfelse>
	<cfset local.currentReleaseType = $.slatwall.rbKey('define.develop') />
</cfif>

<cfoutput>
	
	
	<cf_SlatwallActionBar type="none"></cf_SlatwallActionBar>
	
	<cf_SlatwallPropertyList divClass="span12">
		<cf_SlatwallFieldDisplay title="#$.slatwall.rbKey('admin.main.update.currentVersion')#" value="#rc.currentVersion#" />
		<cfif rc.currentBranch eq 'master'>
			<cf_SlatwallFieldDisplay title="#$.slatwall.rbKey('admin.main.update.currentReleaseType')#" value="#$.slatwall.rbKey('admin.main.update.stable')#" />
		<cfelse>
			<cf_SlatwallFieldDisplay title="#$.slatwall.rbKey('admin.main.update.currentReleaseType')#" value="#$.slatwall.rbKey('admin.main.update.bleedingEdge')#" />
		</cfif>
		<cf_SlatwallFieldDisplay title="#$.slatwall.rbKey('admin.main.update.availableStableVersion')#" value="#rc.availableMasterVersion#" />
		<cf_SlatwallFieldDisplay title="#$.slatwall.rbKey('admin.main.update.availableBleedingEdgeVersion')#" value="#rc.availableDevelopVersion#" />
		<hr />
		<form method="post">
			<input type="hidden" name="slatAction" value="admin:main.update" />
			<input type="hidden" name="process" value="1" />
			
			<select name="updateBranch">
				<cfloop array="#local.updateOptions#" index="local.updateOption" >
					<option value="#local.updateOption.value#" <cfif rc.currentBranch eq local.updateOption.value>selected="selected"</cfif>>#local.updateOption.name#</option>
				</cfloop>
			</select><br />
			<button class="btn adminmainupdate btn-primary" title="#$.slatwall.rbKey('admin.main.update_title')#" type="submit">#$.slatwall.rbKey('admin.main.update_title')#</button>
		</form>
	</cf_SlatwallPropertyList>
</cfoutput>
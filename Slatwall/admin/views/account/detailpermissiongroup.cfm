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
<cfparam name="rc.permissionGroup" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfif rc.permissionGroup.getPermissions() eq "*">
	<cfset $.slatwall.showMessageKey('admin.account.detailpermissiongroup.superuser_info') />
</cfif>

<cfoutput>
	<cf_SlatwallDetailForm object="#rc.permissionGroup#" edit="#rc.edit#">
		<cf_SlatwallActionBar type="detail" object="#rc.permissionGroup#" edit="#rc.edit#"></cf_SlatwallActionBar>
		
		<input type="hidden" name="permissions" value="#rc.permissionGroup.getPermissions()#">
		
		<cf_SlatwallDetailHeader>
			<cf_SlatwallPropertyList>
				<cf_SlatwallPropertyDisplay object="#rc.permissionGroup#" property="permissionGroupName" edit="#rc.edit#">
			</cf_SlatwallPropertyList>
		</cf_SlatwallDetailHeader>
		
		<cfif rc.permissionGroup.getPermissions() neq "*">
			<cf_SlatwallTabGroup object="#rc.permissionGroup#">
				<cf_SlatwallTab view="admin:account/permissiongrouptabs/permissionsection" text="#$.slatwall.rbKey('permission.main')# #$.slatwall.rbKey('define.permissions')#" tabid="tabadminmain" params="#rc.permissions.admin.main#">
				<cf_SlatwallTab view="admin:account/permissiongrouptabs/permissionsection" text="#$.slatwall.rbKey('permission.product')# #$.slatwall.rbKey('define.permissions')#" tabid="tabadminproduct" params="#rc.permissions.admin.product#">
				<cf_SlatwallTab view="admin:account/permissiongrouptabs/permissionsection" text="#$.slatwall.rbKey('permission.pricing')# #$.slatwall.rbKey('define.permissions')#" tabid="tabadminpricing" params="#rc.permissions.admin.pricing#">
				<cf_SlatwallTab view="admin:account/permissiongrouptabs/permissionsection" text="#$.slatwall.rbKey('permission.account')# #$.slatwall.rbKey('define.permissions')#" tabid="tabadminaccount" params="#rc.permissions.admin.account#">
				<cf_SlatwallTab view="admin:account/permissiongrouptabs/permissionsection" text="#$.slatwall.rbKey('permission.vendor')# #$.slatwall.rbKey('define.permissions')#" tabid="tabadminvendor" params="#rc.permissions.admin.vendor#">
				<cf_SlatwallTab view="admin:account/permissiongrouptabs/permissionsection" text="#$.slatwall.rbKey('permission.order')# #$.slatwall.rbKey('define.permissions')#" tabid="tabadminorder" params="#rc.permissions.admin.order#">
				<cf_SlatwallTab view="admin:account/permissiongrouptabs/permissionsection" text="#$.slatwall.rbKey('permission.warehouse')# #$.slatwall.rbKey('define.permissions')#" tabid="tabadminwarehouse" params="#rc.permissions.admin.warehouse#">
				<cf_SlatwallTab view="admin:account/permissiongrouptabs/permissionsection" text="#$.slatwall.rbKey('permission.integration')# #$.slatwall.rbKey('define.permissions')#" tabid="tabadminintegration" params="#rc.permissions.admin.integration#">
				<cf_SlatwallTab view="admin:account/permissiongrouptabs/permissionsection" text="#$.slatwall.rbKey('permission.setting')# #$.slatwall.rbKey('define.permissions')#" tabid="tabadminsetting" params="#rc.permissions.admin.setting#">
				
				<cfloop collection="#rc.permissions#" item="local.subsystem">
					<cfif subsystem neq "admin">
						<cfset local.integration = $.slatwall.getService("integrationService").getIntegrationByIntegrationPackage(local.subsystem)>
						<cfloop collection="#rc.permissions[local.subsystem]#" item="local.section">
							<cfif len(rc.permissions[local.subsystem][local.section].secureMethods)>
								<cf_SlatwallTab view="admin:account/permissiongrouptabs/permissionsection" text="#local.integration.getIntegrationName()# - #local.section#" tabid="tabadmin#local.subsystem#" params="#rc.permissions[local.subsystem][local.section]#">
							</cfif>	
						</cfloop>
					</cfif>
				</cfloop>
			</cf_SlatwallTabGroup>
		</cfif>
	</cf_SlatwallDetailForm>
</cfoutput>
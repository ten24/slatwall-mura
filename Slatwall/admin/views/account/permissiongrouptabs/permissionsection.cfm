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
<cfparam name="rc.permissiongroup" type="any" />
<cfparam name="rc.edit" type="boolean" />
<cfparam name="params.publicMethods" type="string" />
<cfparam name="params.secureMethods" type="string" />
<cfparam name="params.securePermissionOptions" type="array" />

<cfoutput>
	<table class="table table-striped table-bordered table-condensed table-multiselect" data-multiselectfield="permissions">
		<thead>
			<tr>
				<th class="multiselect">&nbsp;</th>
				<th class="data primary" data-propertyidentifier="permission">#$.slatwall.rbKey('define.permissions')#</th>
			</tr>
		</thead>
		<tbody>
			<cfloop array="#params.securePermissionOptions#" index="local.permission">
				<tr id="#local.permission.value#">
					<td><a href="##" class="table-action-multiselect<cfif !rc.edit> disabled</cfif>" data-idvalue="#local.permission.value#"><i class="slatwall-ui-checkbox"></i></a></td>
					<td class="primary">#local.permission.name#</td>
				</tr>
			</cfloop>
		</tbody>
	</table>
</cfoutput>


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
	<cfparam name="attributes.action" type="string" />
	<cfparam name="attributes.type" type="string" default="link">
	<cfparam name="attributes.querystring" type="string" default="" />
	<cfparam name="attributes.text" type="string" default="">
	<cfparam name="attributes.title" type="string" default="">
	<cfparam name="attributes.class" type="string" default="">
	<cfparam name="attributes.icon" type="string" default="">
	<cfparam name="attributes.iconOnly" type="boolean" default="false">
	<cfparam name="attributes.submit" type="boolean" default="false">
	<cfparam name="attributes.confirm" type="boolean" default="false" />
	<cfparam name="attributes.disabled" type="boolean" default="false" />
	<cfparam name="attributes.modal" type="boolean" default="false" />
	
	<cfset attributes.class = Replace(Replace(attributes.action, ":", "", "all"), ".", "", "all") & " " & attributes.class />
	
	<cfif request.context.slatAction eq attributes.action>
		<cfset attributes.class = "#attributes.class# active" />
	</cfif>
	
	<cfif attributes.icon neq "">
		<cfset attributes.icon = '<i class="icon-#attributes.icon#"></i> ' />
	</cfif>
	
	<cfset actionItem = listLast(attributes.action, ".") />
			
	<cfif left(actionItem, 4) eq "list" and len(actionItem) gt 4>
		<cfset actionItemEntityName = right( actionItem, len(actionItem)-4) />
	<cfelseif left(actionItem, 4) eq "edit" and len(actionItem) gt 4>
		<cfset actionItemEntityName = right( actionItem, len(actionItem)-4) />
	<cfelseif left(actionItem, 4) eq "save" and len(actionItem) gt 4>
		<cfset actionItemEntityName = right( actionItem, len(actionItem)-4) />
	<cfelseif left(actionItem, 6) eq "create" and len(actionItem) gt 6>
		<cfset actionItemEntityName = right( actionItem, len(actionItem)-6) />
	<cfelseif left(actionItem, 6) eq "detail" and len(actionItem) gt 6>
		<cfset actionItemEntityName = right( actionItem, len(actionItem)-6) />
	<cfelseif left(actionItem, 6) eq "delete" and len(actionItem) gt 6>
		<cfset actionItemEntityName = right( actionItem, len(actionItem)-6) />
	</cfif>
	
	<cfif attributes.text eq "" and not attributes.iconOnly>
		<cfset attributes.text = request.slatwallScope.rbKey("#Replace(attributes.action, ":", ".", "all")#_nav") />
		
		<cfif right(attributes.text, 8) eq "_missing" >
			
			<cfif left(actionItem, 4) eq "list" and len(actionItem) gt 4>
				<cfset attributes.text = replace(request.slatwallScope.rbKey('admin.define.list_nav'), "${itemEntityNamePlural}", request.slatwallScope.rbKey('entity.#actionItemEntityName#_plural'), "all") />
			<cfelseif left(actionItem, 4) eq "edit" and len(actionItem) gt 4>
				<cfset attributes.text = replace(request.slatwallScope.rbKey('admin.define.edit_nav'), "${itemEntityName}", request.slatwallScope.rbKey('entity.#actionItemEntityName#'), "all") />
			<cfelseif left(actionItem, 4) eq "save" and len(actionItem) gt 4>
				<cfset attributes.text = replace(request.slatwallScope.rbKey('admin.define.save_nav'), "${itemEntityName}", request.slatwallScope.rbKey('entity.#actionItemEntityName#'), "all") />
			<cfelseif left(actionItem, 6) eq "create" and len(actionItem) gt 6>
				<cfset attributes.text = replace(request.slatwallScope.rbKey('admin.define.create_nav'), "${itemEntityName}", request.slatwallScope.rbKey('entity.#actionItemEntityName#'), "all") />
			<cfelseif left(actionItem, 6) eq "detail" and len(actionItem) gt 6>
				<cfset attributes.text = replace(request.slatwallScope.rbKey('admin.define.detail_nav'), "${itemEntityName}", request.slatwallScope.rbKey('entity.#actionItemEntityName#'), "all") />
			<cfelseif left(actionItem, 6) eq "delete" and len(actionItem) gt 6>
				<cfset attributes.text = replace(request.slatwallScope.rbKey('admin.define.delete_nav'), "${itemEntityName}", request.slatwallScope.rbKey('entity.#actionItemEntityName#'), "all") />
			</cfif>
			
		</cfif>
	</cfif>
	
	<cfif attributes.title eq "">
		<cfset attributes.title = request.slatwallScope.rbKey("#Replace(attributes.action, ":", ".", "all")#_title") />
		<cfif right(attributes.title, 8) eq "_missing" >
			
			<cfif left(actionItem, 4) eq "list" and len(actionItem) gt 4>
				<cfset attributes.title = replace(request.slatwallScope.rbKey('admin.define.list_title'), "${itemEntityNamePlural}", request.slatwallScope.rbKey('entity.#actionItemEntityName#_plural'), "all") />
			<cfelseif left(actionItem, 4) eq "edit" and len(actionItem) gt 4>
				<cfset attributes.title = replace(request.slatwallScope.rbKey('admin.define.edit_title'), "${itemEntityName}", request.slatwallScope.rbKey('entity.#actionItemEntityName#'), "all") />
			<cfelseif left(actionItem, 4) eq "save" and len(actionItem) gt 4>
				<cfset attributes.title = replace(request.slatwallScope.rbKey('admin.define.save_title'), "${itemEntityName}", request.slatwallScope.rbKey('entity.#actionItemEntityName#'), "all") />
			<cfelseif left(actionItem, 6) eq "create" and len(actionItem) gt 6>
				<cfset attributes.title = replace(request.slatwallScope.rbKey('admin.define.create_title'), "${itemEntityName}", request.slatwallScope.rbKey('entity.#actionItemEntityName#'), "all") />
			<cfelseif left(actionItem, 6) eq "detail" and len(actionItem) gt 6>
				<cfset attributes.title = replace(request.slatwallScope.rbKey('admin.define.detail_title'), "${itemEntityName}", request.slatwallScope.rbKey('entity.#actionItemEntityName#'), "all") />
			<cfelseif left(actionItem, 6) eq "delete" and len(actionItem) gt 6>
				<cfset attributes.title = replace(request.slatwallScope.rbKey('admin.define.delete_title'), "${itemEntityName}", request.slatwallScope.rbKey('entity.#actionItemEntityName#'), "all") />
			</cfif>
			
		</cfif>
	</cfif>
	
	<cfif attributes.disabled>
	    <cfset attributes.disabledtext = request.slatwallScope.rbKey("#Replace(attributes.action, ":", ".", "all")#_disabled") />
		<cfif right(attributes.disabledtext, "8") eq "_missing">
			<cfif left(listLast(attributes.action, "."), 6) eq "delete">
				<cfset attributes.disabledtext = replace(request.slatwallScope.rbKey("admin.define.delete_disabled"),'${itemEntityName}', request.slatwallScope.rbKey('entity.#actionItemEntityName#'), "all") />
			<cfelseif left(listLast(attributes.action, "."), 4) eq "edit">
				<cfset attributes.disabledtext = replace(request.slatwallScope.rbKey("admin.define.edit_disabled"),'${itemEntityName}', request.slatwallScope.rbKey('entity.#actionItemEntityName#'), "all") />
			</cfif>
		</cfif>
		<cfset attributes.class &= " disabled alert-disabled" />
		<cfset attributes.confirm = false />
	<cfelse>
		<cfif attributes.confirm>
			<cfset attributes.confirmtext = request.slatwallScope.rbKey("#Replace(attributes.action, ":", ".", "all")#_confirm") />
			<cfif right(attributes.confirmtext, "8") eq "_missing">
				<cfset attributes.confirmtext = replace(request.slatwallScope.rbKey("admin.define.delete_confirm"),'${itemEntityName}', request.slatwallScope.rbKey('entity.#actionItemEntityName#'), "all") />
			</cfif>
			<cfset attributes.class &= " alert-confirm" />
		</cfif>
	</cfif>
	
	<cfif attributes.modal && not attributes.disabled>
		<cfset attributes.class &= " modalload" />
	</cfif>
	
	<cfif not request.slatwallScope.secureDisplay(action=attributes.action)>
		<cfset attributes.class &= " disabled" />
	</cfif>


	<cfif request.slatwallScope.secureDisplay(action=attributes.action) || (attributes.type eq "link" && attributes.iconOnly)>
		<cfif attributes.type eq "link">
			<cfoutput><a title="#attributes.title#" class="#attributes.class#" href="#request.context.fw.buildURL(action=attributes.action,querystring=attributes.querystring)#"<cfif attributes.modal && not attributes.disabled> data-toggle="modal" data-target="##adminModal"</cfif><cfif attributes.disabled> data-disabled="#attributes.disabledtext#"<cfelseif attributes.confirm> data-confirm="#attributes.confirmtext#"</cfif>>#attributes.icon##attributes.text#</a></cfoutput>
		<cfelseif attributes.type eq "list">
			<cfoutput><li><a title="#attributes.title#" class="#attributes.class#" href="#request.context.fw.buildURL(action=attributes.action,querystring=attributes.querystring)#"<cfif attributes.modal && not attributes.disabled> data-toggle="modal" data-target="##adminModal"</cfif><cfif attributes.disabled> data-disabled="#attributes.disabledtext#"<cfelseif attributes.confirm> data-confirm="#attributes.confirmtext#"</cfif>>#attributes.icon##attributes.text#</a></li></cfoutput> 
		<cfelseif attributes.type eq "button">
			<cfoutput><button class="btn #attributes.class#" title="#attributes.title#"<cfif attributes.modal && not attributes.disabled> data-toggle="modal" data-target="##adminModal"</cfif><cfif attributes.disabled> data-disabled="#attributes.disabledtext#"<cfelseif attributes.confirm> data-confirm="#attributes.confirmtext#"</cfif><cfif attributes.submit>type="submit"</cfif>>#attributes.icon##attributes.text#</button></cfoutput>
		<cfelseif attributes.type eq "submit">
			<cfoutput>This action caller type has been discontinued</cfoutput>
		</cfif>
	</cfif>
</cfif>

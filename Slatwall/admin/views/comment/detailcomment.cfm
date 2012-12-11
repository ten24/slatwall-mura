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
<cfparam name="rc.comment" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfset local.returnActionQueryString = "" />
<cfset local.hiddenKeyFields = "" />
<cfset local.lastIndex = 0 />

<cfloop collection="#rc#" item="local.key" >
	<cfif local.key neq "settingID" and right(local.key, 2) eq "ID" and isSimpleValue(rc[local.key]) and len(rc[local.key]) gt 30>
		<cfset local.lastIndex++ />
		<cfset local.returnActionQueryString = listAppend(local.returnActionQueryString, '#local.key#=#rc[local.key]#', '&') />
		<cfset local.hiddenKeyFields = listAppend(local.hiddenKeyFields, '<input type="hidden" name="commentRelationships[#local.lastIndex#].commentRelationshipID" value="" />', chr(13)) />
		<cfset local.hiddenKeyFields = listAppend(local.hiddenKeyFields, '<input type="hidden" name="commentRelationships[#local.lastIndex#].#left(local.key, len(local.key)-2)#.#local.key#" value="#rc[local.key]#" />', chr(13)) />	
	</cfif>
</cfloop>

<cfoutput>
	<cf_SlatwallDetailForm object="#rc.comment#" edit="#rc.edit#" saveActionQueryString="#local.returnActionQueryString###tabComments">
		<cf_SlatwallActionBar type="detail" object="#rc.comment#" />
		
		<!--- Only Runs if new --->
		<Cfif rc.comment.isNew()>#local.hiddenKeyFields#</cfif>
		
		<cf_SlatwallDetailHeader>
			<cf_SlatwallPropertyList>
				<cf_SlatwallPropertyDisplay object="#rc.comment#" property="publicFlag" edit="#rc.edit#">
				<cfif !rc.comment.isNew()>
					<cf_SlatwallPropertyDisplay object="#rc.comment#" property="createdDateTime">
					<cf_SlatwallPropertyDisplay object="#rc.comment#" property="createdByAccount">
				</cfif>
				<hr />
				<cf_SlatwallPropertyDisplay object="#rc.comment#" property="comment" displaytype="plain" edit="#rc.comment.isNew()#">
			</cf_SlatwallPropertyList>
		</cf_SlatwallDetailHeader>
		
	</cf_SlatwallDetailForm>
</cfoutput>
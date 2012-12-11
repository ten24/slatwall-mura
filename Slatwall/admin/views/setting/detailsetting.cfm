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
<cfparam name="rc.setting" type="any">
<cfparam name="rc.settingName" type="string">
<cfparam name="rc.edit" type="boolean">

<cfset local.returnActionQueryString = "" />
<cfset local.hiddenKeyFields = "" />
<cfset local.hasRelationshipKey = false />

<cfloop collection="#rc#" item="local.key" >
	<cfif local.key neq "settingID" and right(local.key, 2) eq "ID" and isSimpleValue(rc[local.key]) and len(rc[local.key]) gt 30>
		<cfset local.hasRelationshipKey = true />
		<cfset local.returnActionQueryString = listAppend(local.returnActionQueryString, '#local.key#=#rc[local.key]#', '&') />
		<cfif local.key eq "contentID">
			<cfset rc.content = $.slatwall.getService("contentService").getContent(rc.contentID) />
			<cfset local.hiddenKeyFields = listAppend(local.hiddenKeyFields, '<input type="hidden" name="cmsContentID" value="#rc.content.getCMSContentID()#" />', chr(13)) />	
		<cfelse>
			<cfset local.hiddenKeyFields = listAppend(local.hiddenKeyFields, '<input type="hidden" name="#left(local.key, len(local.key)-2)#.#local.key#" value="#rc[local.key]#" />', chr(13)) />	
		</cfif>
	</cfif>
</cfloop>

<!--- This logic set the setting name if the setting entity is new --->
<cfset rc.setting.setSettingName(rc.settingName) />

<cfoutput>
	<cf_SlatwallDetailForm object="#rc.setting#" edit="#rc.edit#" saveActionQueryString="#local.returnActionQueryString#">
		<cf_SlatwallActionBar type="detail" object="#rc.setting#" />
		
		<input type="hidden" name="settingName" value="#rc.settingName#" />
		#local.hiddenKeyFields#
		
		<cf_SlatwallDetailHeader>
			<cf_SlatwallPropertyList>
				<cfif not rc.setting.isNew() and structKeyExists(rc.setting.getSettingMetaData(), "encryptValue")>
					<cf_SlatwallPropertyDisplay object="#rc.setting#" property="settingValue" edit="#rc.edit#" data-emptyvalue="********">
				<cfelse>
					<cf_SlatwallPropertyDisplay object="#rc.setting#" property="settingValue" edit="#rc.edit#">
				</cfif>
			</cf_SlatwallPropertyList>
			<cfif !rc.setting.isNew() and local.hasRelationshipKey>
				<cf_SlatwallActionCaller action="admin:setting.deletesetting" queryString="settingID=#rc.setting.getSettingID()#&returnAction=#request.context.returnAction#&#local.returnActionQueryString#" class="btn btn-danger" />
			</cfif>
		</cf_SlatwallDetailHeader>
	</cf_SlatwallDetailForm>
</cfoutput>

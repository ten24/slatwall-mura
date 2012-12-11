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
<cfif thisTag.executionMode eq "end">
	<cfparam name="attributes.smartList" type="any" default="" />
	<cfparam name="attributes.allowComment" type="boolean" default="false" />
	<cfparam name="attributes.dataCollectionPropertyIdentifier" type="string" default="" />
	
	<!--- ThisTag Variables used just inside --->
	<cfparam name="thistag.options" type="array" default="#arrayNew(1)#" />
	
	<cfsilent>
		<cfset dataOptions = [] />
		<cfset printEmailOptions = [] />
		<cfset sections = 0 />
		<cfset divclass = "" />
		<cfloop array="#thistag.options#" index="option">
			<cfif len(option.data)>
				<cfset arrayAppend(dataOptions, option) />
			<cfelseif len(option.print)>
				<cfset arrayAppend(printEmailOptions, option) />
			<cfelseif len(option.email)>
				<cfset arrayAppend(printEmailOptions, option) />
			</cfif>
		</cfloop>
		<cfif len(attributes.dataCollectionPropertyIdentifier)>
			<cfset sections++ />
		</cfif>
		<cfif arrayLen(dataOptions)>
			<cfset sections++ />
		</cfif>
		<cfif arrayLen(printEmailOptions)>
			<cfset sections++ />
		</cfif>
		<cfif attributes.allowComment>
			<cfset sections++ />
		</cfif>
		<cfif sections eq 1>
			<cfset divclass="span12" />
		<cfelseif sections eq 2>
			<cfset divclass="span6" />
		<cfelseif sections eq 3>
			<cfset divclass="span4" />
		<cfelseif sections eq 4>
			<cfset divclass="span3" />
		</cfif>
	</cfsilent>
	
	<cfoutput>
		<div class="row-fluid">
			<cfif arrayLen(dataOptions)>
				<cf_SlatwallPropertyList divclass="#divclass#">
					<cfif sections gt 1>
						<h4>Process Options</h4>
						<br />
					</cfif>
					<cfloop array="#dataOptions#" index="option">
						<cfset hint = request.slatwallScope.rbKey( replace(request.context.slatAction, ':', '.') & ".processOption.#option.data#_hint" ) />
						<cfif right(hint, 8) eq "_missing">
							<cfset hint = "" />
						</cfif>
						<cf_SlatwallFieldDisplay edit="true" fieldname="processOptions.#option.data#" fieldtype="#option.fieldtype#" value="#option.value#" valueOptions="#option.valueOptions#" title="#request.slatwallScope.rbKey( replace(request.context.slatAction, ':', '.') & ".processOption.#option.data#" )#" hint="#hint#">
					</cfloop>
				</cf_SlatwallPropertyList>
			</cfif>
			<cfif arrayLen(printEmailOptions)>
				<cf_SlatwallPropertyList divclass="#divclass#">
					<cfif sections gt 1>
						<h4>Email / Print Options</h4>
						<br />
					</cfif>
					<cfloop array="#printEmailOptions#" index="option">
						<cfif len(option.print)>
							<cf_SlatwallFieldDisplay edit="true" fieldname="processOptions.print.#option.print#" fieldtype="yesno" value="#option.value#" title="#request.slatwallScope.rbKey('define.print')# #request.slatwallScope.rbKey('print.#option.print#')#">
						</cfif>
						<cfif len(option.email)>
							<cf_SlatwallFieldDisplay edit="true" fieldname="processOptions.email.#option.email#" fieldtype="yesno" value="#option.value#" title="#request.slatwallScope.rbKey('define.email')# #request.slatwallScope.rbKey('email.#option.email#')#">
						</cfif>
					</cfloop>
				</cf_SlatwallPropertyList>
			</cfif>
			<cfif len(attributes.dataCollectionPropertyIdentifier)>
				<cf_SlatwallPropertyList divclass="#divclass#">
					<cfif sections gt 1>
						<h4>Data Collection</h4>
						<br />
					</cfif>
					<cf_SlatwallFieldDisplay edit="true" fieldname="dataCollector" fieldtype="text" title="Scan" fieldclass="firstfocus">
					<button class="btn">Upload Data File</button>
				</cf_SlatwallPropertyList>
			</cfif>
			<cfif attributes.allowComment>
				<cf_SlatwallPropertyList divclass="#divclass#">
					<cfif sections gt 1>
						<h4>Optional Comment</h4>
						<br />
					</cfif>
					<cf_SlatwallFieldDisplay edit="true" fieldname="processComment.publicFlag" fieldtype="yesno" value="0" title="#request.slatwallScope.rbKey('entity.comment.publicFlag')#">
					<cf_SlatwallFieldDisplay edit="true" fieldname="processComment.comment" fieldClass="processComment" fieldtype="textarea" value="" title="#request.slatwallScope.rbKey('entity.comment.comment')#">		
				</cf_SlatwallPropertyList>
			</cfif>
		</div>
		<hr />
	</cfoutput>
</cfif>

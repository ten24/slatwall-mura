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
	
	<cfparam name="attributes.type" type="string" />
	<cfparam name="attributes.object" type="any" default="" />
	<cfparam name="attributes.edit" type="boolean" default="#request.context.edit#" />
	<cfparam name="attributes.pageTitle" type="string" default="#request.context.pageTitle#" />
	<cfparam name="attributes.pageSubTitle" type="string" default="" />
	<cfparam name="attributes.createAction" type="string" default="#request.context.createAction#" />
	<cfparam name="attributes.createModal" type="boolean" default="false" />
	<cfparam name="attributes.createReturnAction" type="string" default="#request.context.slatAction#" />
	<cfparam name="attributes.backAction" type="string" default="#request.context.listAction#" />
	<cfparam name="attributes.backQueryString" type="string" default="" />
	<cfparam name="attributes.cancelAction" type="string" default="#request.context.cancelAction#" />
	<cfparam name="attributes.cancelQueryString" type="string" default="" />
	<cfparam name="attributes.showedit" type="boolean" default="true" />
	<cfparam name="attributes.showdelete" type="boolean" default="true" />
	<cfsilent>
		<cfif attributes.type eq "detail" and not attributes.object.isNew() and attributes.pageSubTitle eq "">
			<cfset attributes.pageSubTitle = attributes.object.getSimpleRepresentation() />
		</cfif>
	</cfsilent>
	
<cfelse>
	<cfif not structKeyExists(request.context, "modal") or not request.context.modal>
		
		<cfoutput>
			<div class="actionnav well well-small">
				<div class="row-fluid">
					<div class="span4">
						<h1>#attributes.pageTitle#</h1>
					</div>
					<div class="span8">
						<div class="btn-toolbar">
							<!--- Listing --->
							<cfif attributes.type eq "listing" >
								<cfparam name="request.context.keywords" default="" />
								
								<form name="search" class="action-bar-search btn-group" action="/plugins/Slatwall/" method="get">
									<input type="hidden" name="slatAction" value="#request.context.slatAction#" />
									<input type="text" name="keywords" value="#request.context.keywords#" placeholder="#request.slatwallScope.rbKey('define.search')# #attributes.pageTitle#" data-tableid="LD#replace(attributes.object.getSavedStateID(),'-','','all')#">
								</form>
								
								<div class="btn-group">
									<button class="btn dropdown-toggle" data-toggle="dropdown"><i class="icon-list-alt"></i> #request.slatwallScope.rbKey('define.actions')# <span class="caret"></span></button>
									<ul class="dropdown-menu">
										<cf_SlatwallActionCaller action="#request.context.exportAction#" text="#request.slatwallScope.rbKey('define.exportlist')#" type="list">
										<!---#thistag.generatedcontent#--->
									</ul>
								</div>

								<cfif len(attributes.createAction) or len(thistag.generatedcontent)>
									<div class="btn-group">
										<cfif listLen(attributes.createAction) eq 1>
											<cfif attributes.createModal>
												<cf_SlatwallActionCaller action="#attributes.createAction#" class="btn btn-primary" icon="plus icon-white" modal="true" queryString="returnAction=#attributes.createReturnAction#">
											<cfelse>
												<cf_SlatwallActionCaller action="#attributes.createAction#" class="btn btn-primary" icon="plus icon-white">
											</cfif>
										<cfelse>
											<cf_SlatwallActionCallerDropdown title="#request.slatwallScope.rbKey('define.add')#" icon="plus" dropdownClass="pull-right">
												<cfloop list="#attributes.createAction#" index="action">
													<cf_SlatwallActionCaller action="#action#" type="list" queryString="returnAction=#attributes.createReturnAction#" modal="#attributes.createModal#" /> 
												</cfloop>
												#thistag.generatedcontent#
											</cf_SlatwallActionCallerDropdown>
										</cfif>
										
									</div>
								</cfif>
							<!--- Detail --->
							<cfelseif attributes.type eq "detail">
								<!--- set default value for cancel action querystring --->
								<cfset attributes.cancelQueryString = (len(trim(attributes.cancelQueryString)) gt 0) ? attributes.cancelQueryString : "#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#" />
								<div class="btn-group">
									<cf_SlatwallActionCaller action="#attributes.backAction#" queryString="#attributes.backQueryString#" class="btn" icon="arrow-left">
								</div>
								<cfif !attributes.object.isNew() && len(thistag.generatedcontent)>
									<div class="btn-group">
										<button class="btn dropdown-toggle" data-toggle="dropdown"><i class="icon-list-alt"></i> #request.slatwallScope.rbKey('define.actions')# <span class="caret"></span></button>
										<ul class="dropdown-menu pull-right">
										#thistag.generatedcontent#	
										</ul>
									</div>
								</cfif>
								<div class="btn-group">
									<cfif attributes.edit>
										<cfif not attributes.object.isNew()><cf_SlatwallActionCaller action="#request.context.deleteAction#" querystring="#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#&returnAction=#attributes.backAction#&#attributes.backQueryString#" text="#request.slatwallScope.rbKey('define.delete')#" class="btn btn-inverse" icon="trash icon-white" confirm="true" disabled="#attributes.object.isNotDeletable()#"></cfif>
										<cf_SlatwallActionCaller action="#attributes.cancelAction#" querystring="#attributes.cancelQueryString#" text="#request.slatwallScope.rbKey('define.cancel')#" class="btn btn-inverse" icon="remove icon-white">
										<cf_SlatwallActionCaller action="#request.context.saveAction#" text="#request.slatwallScope.rbKey('define.save')#" class="btn btn-success" type="button" submit="true" icon="ok icon-white">
									<cfelse>
										<cfif attributes.showdelete><cf_SlatwallActionCaller action="#request.context.deleteAction#" querystring="#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#&returnAction=#attributes.backAction#&#attributes.backQueryString#" text="#request.slatwallScope.rbKey('define.delete')#" class="btn btn-inverse" icon="trash icon-white" confirm="true" disabled="#attributes.object.isNotDeletable()#"></cfif>
										<cfif attributes.showedit><cf_SlatwallActionCaller action="#request.context.editAction#" querystring="#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#" text="#request.slatwallScope.rbKey('define.edit')#" class="btn btn-primary" icon="pencil icon-white" submit="true" disabled="#attributes.object.isNotEditable()#"></cfif>
									</cfif>
								</div>
							<!--- Process --->
							<cfelseif attributes.type eq "process">
								<div class="btn-group">
									<button type="submit" class="btn btn-primary"><i class="icon-cog icon-white"></i> #request.slatwallScope.rbKey('define.process')#</button>
								</div>
							</cfif>
							<cfset thistag.generatedcontent = "" />
						</div>
					</div>
				</div>
			</div>
		</cfoutput>
		
		<cf_SlatwallMessageDisplay />
	<cfelse>
		<cfset thistag.generatedcontent = "" />
	</cfif>
	
</cfif>

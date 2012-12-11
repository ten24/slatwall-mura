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
<cfparam name="attributes.object" type="any" default="" />
<cfparam name="attributes.allowComments" type="boolean" default="false">
<cfparam name="attributes.allowCustomAttributes" type="boolean" default="false">

<cfset variables.fw = caller.this />

<cfif (not isObject(attributes.object) || not attributes.object.isNew()) and (not structKeyExists(request.context, "modal") or not request.context.modal)>
	<cfif thisTag.executionMode is "end">
		
			<cfparam name="thistag.tabs" default="#arrayNew(1)#" />
			<cfparam name="activeTab" default="tabSystem" />
			
			<cfif arrayLen(thistag.tabs)>
				<cfset activeTab = thistag.tabs[1].tabid />
			</cfif>
			
			<div class="tabbable tabs-left row-fluid">
				<div class="tabsLeft">
					<ul class="nav nav-tabs">
						<cfloop array="#thistag.tabs#" index="tab">
							<cfoutput><li <cfif activeTab eq tab.tabid>class="active"</cfif>><a href="###tab.tabid#" data-toggle="tab">#tab.text#<cfif tab.count> <span class="badge">#tab.count#</span></cfif></a></li></cfoutput>
						</cfloop>
						<cfif isObject(attributes.object) && attributes.allowCustomAttributes>
							<cfloop array="#attributes.object.getAssignedAttributeSetSmartList().getRecords()#" index="attributeSet">
								<cfoutput><li><a href="##tab#lcase(attributeSet.getAttributeSetCode())#" data-toggle="tab">#attributeSet.getAttributeSetName()#</a></li></cfoutput>
							</cfloop>
						</cfif>
						<cfif isObject(attributes.object) && attributes.allowComments>
							<cfoutput><li><a href="##tabComments" data-toggle="tab">#request.slatwallScope.rbKey('entity.comment_plural')# <cfif arrayLen(attributes.object.getComments())><span class="badge">#arrayLen(attributes.object.getComments())#</span></cfif></a></li></cfoutput>
						</cfif>
						<cfif isObject(attributes.object)>
							<cfoutput><li><a href="##tabSystem" data-toggle="tab">#request.slatwallScope.rbKey('define.system')#</a></li></cfoutput>
						</cfif>
					</ul>
				</div>
				<div class="tabsRight">
					<div class="tab-content">
						<cfloop array="#thistag.tabs#" index="tab">
							<cfoutput>
								<div <cfif activeTab eq tab.tabid>class="tab-pane active"<cfelse>class="tab-pane"</cfif> id="#tab.tabid#">
									<div class="row-fluid">
										#variables.fw.view(tab.view, {rc=request.context, params=tab.params})#
									</div>
								</div>
							</cfoutput>
						</cfloop>
						<cfif isObject(attributes.object) && attributes.allowCustomAttributes>
							<cfloop array="#attributes.object.getAssignedAttributeSetSmartList().getRecords()#" index="attributeSet">
								<cfoutput>
									<div class="tab-pane" id="tab#lcase(attributeSet.getAttributeSetCode())#">
										<div class="row-fluid">
											<cf_SlatwallAttributeSetDisplay attributeSet="#attributeSet#" entity="#attributes.object#" edit="#request.context.edit#" />
										</div>
									</div>
								</cfoutput>
							</cfloop>
						</cfif>
						<cfif isObject(attributes.object) && attributes.allowComments>
							<div class="tab-pane" id="tabComments">
								<cfoutput>
									<cfif arrayLen(attributes.object.getComments()) gt 0>
										<table class="table table-striped table-bordered table-condensed">
											<tr>
												<th class="primary">#request.slatwallScope.rbKey("entity.comment.comment")#</th>
												<th>#request.slatwallScope.rbKey("entity.comment.publicFlag")#</th>
												<th>#request.slatwallScope.rbKey("entity.define.createdByAccount")#</th>
												<th>#request.slatwallScope.rbKey("entity.define.createdDateTime")#</th>
												<th class="admin1">&nbsp;</th>
											</tr>
											<cfloop array="#attributes.object.getComments()#" index="commentRelationship">
												<tr>
													<cfif commentRelationship['referencedRelationshipFlag']>
														<cfset originalEntity = commentRelationship['comment'].getPrimaryRelationship().getRelationshipEntity() />
														<cfswitch expression="#originalEntity.getClassName()#">
															<cfcase value="Order">
																<td class="primary highlight-ltblue" colspan="2">This #attributes.object.getClassName()# was referenced in a comment on <a href="?slatAction=order.detailorder&orderID=#originalEntity.getOrderID()###tabComments">Order Number #originalEntity.getOrderNumber()#</a></td>
																<td class="highlight-ltblue">#commentRelationship['comment'].getCreatedByAccount().getFullName()#</td>
																<td class="highlight-ltblue">#request.slatwallScope.formatValue(commentRelationship['comment'].getCreatedDateTime(), "datetime")#</td>
																<td class="admin1 highlight-ltblue">&nbsp;</td>
															</cfcase>
															<cfdefaultcase>
																<td class="primary" colspan="5">??? Programming Issue for #originalEntity.getClassName()# entity comments</td>
															</cfdefaultcase>
														</cfswitch>
													<cfelse>
														<td class="primary" style="white-space:normal;">#commentRelationship['comment'].getCommentWithLinks()#</td>
														<td>#request.slatwallScope.formatValue(commentRelationship['comment'].getPublicFlag(), "yesno")#</td>
														<td>#commentRelationship['comment'].getCreatedByAccount().getFullName()#</td>
														<td>#request.slatwallScope.formatValue(commentRelationship['comment'].getCreatedDateTime(), "datetime")#</td>
														<td class="admin1"><cf_SlatwallActionCaller action="admin:comment.editcomment" queryString="commentID=#commentRelationship['comment'].getCommentID()#&#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#&returnAction=#request.context.detailAction#" modal="true" class="btn btn-mini" icon="pencil" iconOnly="true" /></td>
													</cfif>
												</tr>
											</cfloop>
										</table>
									</cfif>
									<cf_SlatwallActionCaller action="admin:comment.createcomment" querystring="#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#&returnAction=#request.context.detailAction#" modal="true" class="btn btn-inverse" icon="plus icon-white" />
								</cfoutput>
							</div>
						</cfif>
						<cfif isObject(attributes.object)>
							<div <cfif arrayLen(thistag.tabs)>class="tab-pane"<cfelse>class="tab-pane active"</cfif> id="tabSystem">
								<div class="row-fluid">
									<cf_SlatwallPropertyList> 
										<cf_SlatwallPropertyDisplay object="#attributes.object#" property="#attributes.object.getPrimaryIDPropertyName()#" />
										<cfif request.slatwallScope.setting('globalRemoteIDShowFlag') && attributes.object.hasProperty('remoteID')>
											<cf_SlatwallPropertyDisplay object="#attributes.object#" property="remoteID" edit="#iif(request.context.edit && request.slatwallScope.setting('globalRemoteIDEditFlag'), true, false)#" />
										</cfif>
										<cf_SlatwallPropertyDisplay object="#attributes.object#" property="createdDateTime" />
										<cf_SlatwallPropertyDisplay object="#attributes.object#" property="createdByAccount" />
										<cf_SlatwallPropertyDisplay object="#attributes.object#" property="modifiedDateTime" />
										<cf_SlatwallPropertyDisplay object="#attributes.object#" property="modifiedByAccount" />
									</cf_SlatwallPropertyList>
								</div>
							</div>
						</cfif>
					</div>
				</div>
			</div>
	</cfif>
</cfif>
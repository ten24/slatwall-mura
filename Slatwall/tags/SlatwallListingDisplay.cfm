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
	<!--- Required --->
	<cfparam name="attributes.smartList" type="any" />
	<cfparam name="attributes.edit" type="boolean" default="false" />
	
	<!--- Admin Actions --->
	<cfparam name="attributes.recordEditAction" type="string" default="" />
	<cfparam name="attributes.recordEditQueryString" type="string" default="" />
	<cfparam name="attributes.recordEditModal" type="boolean" default="false" />
	<cfparam name="attributes.recordEditDisabled" type="boolean" default="false" />
	<cfparam name="attributes.recordDetailAction" type="string" default="" />
	<cfparam name="attributes.recordDetailQueryString" type="string" default="" />
	<cfparam name="attributes.recordDetailModal" type="boolean" default="false" />
	<cfparam name="attributes.recordDeleteAction" type="string" default="" />
	<cfparam name="attributes.recordDeleteQueryString" type="string" default="" />
	<cfparam name="attributes.recordProcessAction" type="string" default="" />
	<cfparam name="attributes.recordProcessQueryString" type="string" default="" />
	<cfparam name="attributes.recordProcessContext" type="string" default="process" />
	<cfparam name="attributes.recordProcessModal" type="boolean" default="false" />

	<!--- Hierarchy Expandable --->
	<cfparam name="attributes.parentPropertyName" type="string" default="" />  <!--- Setting this value will turn on Expanable --->
	
	<!--- Sorting --->
	<cfparam name="attributes.sortProperty" type="string" default="" />  			<!--- Setting this value will turn on Sorting --->
	<cfparam name="attributes.sortContextColumn" type="string" default="" />  		
	<cfparam name="attributes.sortContextID" type="string" default="" />  					
	
	<!--- Single Select --->
	<cfparam name="attributes.selectFieldName" type="string" default="" />			<!--- Setting this value will turn on single Select --->
	<cfparam name="attributes.selectValue" type="string" default="" />
	<cfparam name="attributes.selectTitle" type="string" default="" />
	
	<!--- Multiselect --->
	<cfparam name="attributes.multiselectFieldName" type="string" default="" />		<!--- Setting this value will turn on Multiselect --->
	<cfparam name="attributes.multiselectValues" type="string" default="" />
	
	<!--- Helper / Additional / Custom --->
	<cfparam name="attributes.tableattributes" type="string" default="" />  <!--- Pass in additional html attributes for the table --->
	<cfparam name="attributes.tableclass" type="string" default="" />  <!--- Pass in additional classes for the table --->	
	<cfparam name="attributes.adminattributes" type="string" default="" />
	
	<!--- ThisTag Variables used just inside --->
	<cfparam name="thistag.columns" type="array" default="#arrayNew(1)#" />
	<cfparam name="thistag.allpropertyidentifiers" type="string" default="" />
	<cfparam name="thistag.selectable" type="string" default="false" />
	<cfparam name="thistag.multiselectable" type="string" default="false" />
	<cfparam name="thistag.expandable" type="string" default="false" />
	<cfparam name="thistag.sortable" type="string" default="false" />
	<cfparam name="thistag.exampleEntity" type="string" default="" />

	<cfsilent>
		<cfif isSimpleValue(attributes.smartList)>
			<cfset attributes.smartList = request.slatwallScope.getService("utilityORMService").getServiceByEntityName( attributes.smartList ).invokeMethod("get#attributes.smartList#SmartList") />
		</cfif>
		
		<!--- Setup the example entity --->
		<cfset thistag.exampleEntity = entityNew(attributes.smartList.getBaseEntityName()) />
		
		<!--- Setup the default table class --->
		<cfset attributes.tableclass = listPrepend(attributes.tableclass, 'table table-striped table-bordered table-condensed', ' ') />
		
		<!--- Setup Select --->
		<cfif len(attributes.selectFieldName)>
			<cfset thistag.selectable = true />
			
			<cfset attributes.tableclass = listAppend(attributes.tableclass, 'table-select', ' ') />
			<cfset attributes.tableattributes = listAppend(attributes.tableattributes, 'data-selectfield="#attributes.selectFieldName#"', " ") />
		</cfif>
		
		<!--- Setup Multiselect --->
		<cfif len(attributes.multiselectFieldName)>
			<cfset thistag.multiselectable = true />
			
			<cfset attributes.tableclass = listAppend(attributes.tableclass, 'table-multiselect', ' ') />
			<cfset attributes.tableattributes = listAppend(attributes.tableattributes, 'data-multiselectfield="#attributes.multiselectFieldName#"', " ") />
		</cfif>
		<cfif thistag.multiselectable and not arrayLen(thistag.columns) >
			<cfif thistag.exampleEntity.hasProperty('activeFlag')>
				<cfset attributes.smartList.addFilter("activeFlag", 1) />
			</cfif>
		</cfif>
		
		
		<!--- Look for Hierarchy in example entity --->
		<cfif not len(attributes.parentPropertyName)>
			<cfset thistag.entityMetaData = getMetaData(thisTag.exampleEntity) />
			<cfif structKeyExists(thisTag.entityMetaData, "parentPropertyName")>
				<cfset attributes.parentPropertyName = thisTag.entityMetaData.parentPropertyName />
			</cfif>
		</cfif>
		
		<!--- Setup Hierarchy Expandable --->
		<cfif len(attributes.parentPropertyName)>
			<cfset thistag.expandable = true />
			
			
			<cfset attributes.tableclass = listAppend(attributes.tableclass, 'table-expandable', ' ') />
			
			<cfset attributes.smartList.joinRelatedProperty( attributes.smartList.getBaseEntityName() , attributes.parentPropertyName, "LEFT") />
			<cfset attributes.smartList.addFilter("#attributes.parentPropertyName#.#thistag.exampleEntity.getPrimaryIDPropertyName()#", "NULL") />
			
			<cfset thistag.allpropertyidentifiers = listAppend(thistag.allpropertyidentifiers, "#thisTag.exampleEntity.getPrimaryIDPropertyName()#Path") />
			
			<cfset attributes.tableattributes = listAppend(attributes.tableattributes, 'data-parentidproperty="#attributes.parentPropertyName#.#thistag.exampleEntity.getPrimaryIDPropertyName()#"', " ") />
			
			<cfset attributes.smartList.setPageRecordsShow(1000000) />
		</cfif>
		
		<!--- Setup Sortability --->
		<cfif len(attributes.sortProperty)>
			<cfif not arrayLen(attributes.smartList.getOrders())>
				<cfset thistag.sortable = true />
				
				<cfset attributes.tableclass = listAppend(attributes.tableclass, 'table-sortable', ' ') />
				
				<cfset attributes.smartList.addOrder("#attributes.sortProperty#|ASC") />
				
				<cfset thistag.allpropertyidentifiers = listAppend(thistag.allpropertyidentifiers, "#attributes.sortProperty#") />
				
				<cfif len(attributes.sortContextID) and len(attributes.sortContextIDValue)>
					<cfset attributes.tableattributes = listAppend(attributes.tableattributes, 'data-sortcontextidcolumn="#attributes.sortContextID#"', " ") />
					<cfset attributes.tableattributes = listAppend(attributes.tableattributes, 'data-sortcontextidvalue="#attributes.sortContextIDValue#"', " ") />
				</cfif>
			</cfif>
		</cfif>
		
		<!--- Setup the admin meta info --->
		<cfset attributes.administativeCount = 0 />
		
		<!--- Detail --->
		<cfif len(attributes.recordDetailAction)>
			<cfset attributes.administativeCount++ />
			
			<cfset attributes.adminattributes = listAppend(attributes.adminattributes, 'data-detailaction="#attributes.recordDetailAction#"', " ") />
			<cfset attributes.adminattributes = listAppend(attributes.adminattributes, 'data-detailquerystring="#attributes.recordDetailQueryString#"', " ") />
			<cfset attributes.adminattributes = listAppend(attributes.adminattributes, 'data-detailmodal="#attributes.recordDetailModal#"', " ") />
		</cfif>
		
		<!--- Edit --->
		<cfif len(attributes.recordEditAction)>
			<cfset attributes.administativeCount++ />
			
			<cfset attributes.adminattributes = listAppend(attributes.adminattributes, 'data-editaction="#attributes.recordEditAction#"', " ") />
			<cfset attributes.adminattributes = listAppend(attributes.adminattributes, 'data-editquerystring="#attributes.recordEditQueryString#"', " ") />
			<cfset attributes.adminattributes = listAppend(attributes.adminattributes, 'data-editmodal="#attributes.recordEditModal#"', " ") />
		</cfif>
		
		<!--- Delete --->
		<cfif len(attributes.recordDeleteAction)>
			<cfset attributes.administativeCount++ />
			
			<cfset attributes.adminattributes = listAppend(attributes.adminattributes, 'data-deleteaction="#attributes.recordDeleteAction#"', " ") />
			<cfset attributes.adminattributes = listAppend(attributes.adminattributes, 'data-deletequerystring="#attributes.recordDeleteQueryString#"', " ") />
		</cfif>
		<!---
		<!--- Process --->
		<cfif len(attributes.recordProcessAction)>
			<cfset attributes.administativeCount++ />
			
			<cfset attributes.adminattributes = listAppend(attributes.adminattributes, 'data-processaction="#attributes.recordProcessAction#"', " ") />
			<cfset attributes.adminattributes = listAppend(attributes.adminattributes, 'data-processquerystring="#attributes.recordProcessQueryString#"', " ") />
			<cfset attributes.adminattributes = listAppend(attributes.adminattributes, 'data-processmodal="#attributes.recordProcessModal#"', " ") />
		</cfif>
		--->
		
		<!--- Setup the primary representation column if no columns were passed in --->
		<cfif not arrayLen(thistag.columns)>
			<cfset arrayAppend(thistag.columns, {
				propertyIdentifier = thistag.exampleentity.getSimpleRepresentationPropertyName(),
				title = "",
				tdClass="primary",
				search = true,
				sort = true,
				filter = false,
				range = false
			}) />
		</cfif>
		
		<!--- Setup the list of all property identifiers to be used later --->
		<cfloop array="#thistag.columns#" index="column">
			<cfset thistag.allpropertyidentifiers = listAppend(thistag.allpropertyidentifiers, column.propertyIdentifier) />
			<cfif findNoCase("primary", column.tdClass) and thistag.expandable>
				<cfset attributes.tableattributes = listAppend(attributes.tableattributes, 'data-expandsortproperty="#column.propertyIdentifier#"', " ") />
				<cfset column.sort = false />
			</cfif>
		</cfloop>
	</cfsilent>
	<cfoutput>
		<cfif arrayLen(attributes.smartList.getPageRecords())>
			<cfif thistag.selectable>
				<input type="hidden" name="#attributes.selectFieldName#" value="#attributes.selectValue#" />
			</cfif>
			<cfif thistag.multiselectable>
				<input type="hidden" name="#attributes.multiselectFieldName#" value="#attributes.multiselectValues#" />
			</cfif>
			<table id="LD#replace(attributes.smartList.getSavedStateID(),'-','','all')#" class="#attributes.tableclass#" data-savedstateid="#attributes.smartList.getSavedStateID()#" data-entityname="#attributes.smartList.getBaseEntityName()#" data-idproperty="#thistag.exampleEntity.getPrimaryIDPropertyName()#" data-propertyidentifiers="#thistag.exampleEntity.getPrimaryIDPropertyName()#,#thistag.allpropertyidentifiers#" #attributes.tableattributes#>
				<thead>
					<tr>
						<!--- Selectable --->
						<cfif thistag.selectable>
							<cfset class="select">
							<cfif not attributes.edit>
								<cfset class &= " disabled" />
							</cfif>
							<th class="#class#">#attributes.selectTitle#</th>
						</cfif>
						<!--- Multiselectable --->
						<cfif thistag.multiselectable>
							<cfset class="multiselect">
							<cfif not attributes.edit>
								<cfset class &= " disabled" />
							</cfif>
							<th class="#class#">&nbsp;</th>
						</cfif>
						<!--- Sortable --->
						<cfif thistag.sortable>
							<th class="sort">&nbsp;</th>
						</cfif>
						<cfloop array="#thistag.columns#" index="column">
							<cfsilent>
								<cfif not len(column.title)>
									<cfset column.title = thistag.exampleEntity.getTitleByPropertyIdentifier(column.propertyIdentifier) />
								</cfif>
							</cfsilent>
							<th class="data #column.tdClass#" data-propertyIdentifier="#column.propertyIdentifier#">
								<cfif not column.search and not column.sort and not column.filter and not column.range>
									#column.title#
								<cfelse>
									<div class="dropdown">
										<a href="##" class="dropdown-toggle" data-toggle="dropdown">#column.title# <span class="caret"></span> </a>
										<ul class="dropdown-menu nav">
											<cfif column.sort>
												<li class="nav-header">#request.slatwallScope.rbKey('define.sort')#</li>
												<li><a href="##" class="listing-sort" data-sortdirection="ASC"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
												<li><a href="##" class="listing-sort" data-sortdirection="DESC"><i class="icon-arrow-up"></i> Sort Decending</a></li>
											</cfif>
											<cfif column.search>
												<li class="divider"></li>
												<li class="nav-header">#request.slatwallScope.rbKey('define.search')#</li>
												<li class="search-filter"><input type="text" class="listing-search span2" name="FK:#column.propertyIdentifier#" value="" /> <i class="icon-search"></i></li>
											</cfif>
											<cfif column.range>
												<cfsilent>
													<cfset local.rangeClass = "text" />
													<cfset local.fieldType = thistag.exampleEntity.getFieldTypeByPropertyIdentifier(column.propertyIdentifier) />
													<cfif local.fieldType eq "dateTime">
														<cfset local.rangeClass = "datetimepicker" />	
													</cfif>
												</cfsilent>
												<li class="divider"></li>
												<li class="nav-header">#request.slatwallScope.rbKey('define.range')#</li>
												<li class="range-filter"><label for="">From</label><input type="text" class="#local.rangeClass# range-filter-lower span2" name="R:#column.propertyIdentifier#" value="" /></li>
												<li class="range-filter"><label for="">To</label><input type="text" class="#local.rangeClass# range-filter-upper span2" name="R:#column.propertyIdentifier#" value="" /></li>
											</cfif>
											<cfif column.filter>
												<li class="divider"></li>
												<li class="nav-header">#request.slatwallScope.rbKey('define.filter')#</li>
												<cfset filterOptions = attributes.smartList.getFilterOptions(valuePropertyIdentifier=column.propertyIdentifier, namePropertyIdentifier=column.propertyIdentifier) />
												<div class="filter-scroll">
													<input type="hidden" name="F:#column.propertyIdentifier#" value="#attributes.smartList.getFilters(column.propertyIdentifier)#" />
													<cfloop array="#filterOptions#" index="filter">
														<li><a href="##" class="listing-filter" data-filtervalue="#filter['value']#"><i class="slatwall-ui-checkbox"></i> #filter['name']#</a></li>
													</cfloop>
												</div>
											</cfif>
										</ul>
									</div>
								</cfif>
							</th>
						</cfloop>
						<cfif attributes.administativeCount>
							<th class="admin admin#attributes.administativeCount#" #attributes.adminattributes#>&nbsp;</th>
						</cfif>
					</tr>
				</thead>
				<tbody <cfif thistag.sortable>class="sortable"</cfif>>
					<cfloop array="#attributes.smartList.getPageRecords()#" index="record">
						<tr id="#record.getPrimaryIDValue()#" <cfif thistag.expandable>idPath="#record.getValueByPropertyIdentifier( propertyIdentifier="#thistag.exampleEntity.getPrimaryIDPropertyName()#Path" )#"</cfif>>
							<!--- Selectable --->
							<cfif thistag.selectable>
								<td><a href="##" class="table-action-select#IIF(attributes.edit, DE(""), DE(" disabled"))#" data-idvalue="#record.getPrimaryIDValue()#"><i class="slatwall-ui-radio"></i></a></td>
							</cfif>
							<!--- Multiselectable --->
							<cfif thistag.multiselectable>
								<td><a href="##" class="table-action-multiselect#IIF(attributes.edit, DE(""), DE(" disabled"))#" data-idvalue="#record.getPrimaryIDValue()#"><i class="slatwall-ui-checkbox"></i></a></td>
							</cfif>
							<!--- Sortable --->
							<cfif thistag.sortable>
								<td><a href="##" class="table-action-sort" data-idvalue="#record.getPrimaryIDValue()#" data-sortPropertyValue="#record.getValueByPropertyIdentifier( attributes.sortProperty )#"><i class="icon-move"></i></a></td>
							</cfif>
							<cfloop array="#thistag.columns#" index="column">
								<!--- Expandable Check --->
								<cfif column.tdclass eq "primary" and thistag.expandable>
									<td class="#column.tdclass#"><a href="##" class="table-action-expand depth0" data-depth="0"><i class="icon-plus"></i></a> #record.getValueByPropertyIdentifier( propertyIdentifier=column.propertyIdentifier, formatValue=true )#</td>
								<cfelse>
									<td class="#column.tdclass#">#record.getValueByPropertyIdentifier( propertyIdentifier=column.propertyIdentifier, formatValue=true )#</td>
								</cfif>
							</cfloop>
							<cfif attributes.administativeCount>
								<td class="admin admin#attributes.administativeCount#">
									<cfif attributes.recordDetailAction neq "">
										<cf_SlatwallActionCaller action="#attributes.recordDetailAction#" queryString="#listPrepend(attributes.recordDetailQueryString, '#record.getPrimaryIDPropertyName()#=#record.getPrimaryIDValue()#', '&')#" class="btn btn-mini" icon="eye-open" iconOnly="true" modal="#attributes.recordDetailModal#" />
									</cfif>
									<cfif attributes.recordEditAction neq "">
										
										<cf_SlatwallActionCaller action="#attributes.recordEditAction#" queryString="#listPrepend(attributes.recordEditQueryString, '#record.getPrimaryIDPropertyName()#=#record.getPrimaryIDValue()#', '&')#" class="btn btn-mini" icon="pencil" iconOnly="true" disabled="#record.isNotEditable()#" modal="#attributes.recordEditModal#" />
									</cfif>
									<!---
									<cfif attributes.recordProcessAction neq "">
										<cfif attributes.recordProcessContext eq "process">
											<cf_SlatwallActionCaller action="#attributes.recordProcessAction#" queryString="#record.getPrimaryIDPropertyName()#=#record.getPrimaryIDValue()#&#attributes.recordProcessQueryString#" class="btn btn-mini" icon="cog" text="#request.slatwallScope.rbKey('define.process')#" disabled="#record.isNotProcessable()#" modal="#attributes.recordProcessModal#" />
										<cfelse>
											<cfset attributes.recordProcessQueryString = "processContext=#attributes.recordProcessContext#&#attributes.recordProcessQueryString#" />
											<cf_SlatwallActionCaller action="#attributes.recordProcessAction#" queryString="#record.getPrimaryIDPropertyName()#=#record.getPrimaryIDValue()#&#attributes.recordProcessQueryString#" class="btn btn-mini" icon="cog" text="#request.slatwallScope.rbKey(replace(attributes.recordProcessAction,':','.') & '.#attributes.recordProcessContext#_nav')#" disabled="#record.isNotProcessable( attributes.recordProcessContext )#" modal="#attributes.recordProcessModal#" />
										</cfif>
									</cfif>
									--->
									<cfif attributes.recordDeleteAction neq "">
										<cf_SlatwallActionCaller action="#attributes.recordDeleteAction#" queryString="#listPrepend(attributes.recordDeleteQueryString, '#record.getPrimaryIDPropertyName()#=#record.getPrimaryIDValue()#', '&')#" class="btn btn-mini" icon="trash" iconOnly="true" disabled="#record.isNotDeletable()#" confirm="true" />
									</cfif>
								</td>
							</cfif>
						</tr>
					</cfloop>
				</tbody>
			</table>
			
			<!--- Pager --->
			<cfsilent>
				<cfset local.pageStart = 1 />
				<cfset local.pageCount = 2 />
				
				<cfif attributes.smartList.getTotalPages() gt 6>
					<cfif attributes.smartList.getCurrentPage() lte 3>
						<cfset local.pageCount = 4 />
					<cfelseif attributes.smartList.getCurrentPage() gt 3 and attributes.smartList.getCurrentPage() lt attributes.smartList.getTotalPages() - 3>
						<cfset local.pageStart = attributes.smartList.getCurrentPage()-1 />
					<cfelseif attributes.smartList.getCurrentPage() gte attributes.smartList.getTotalPages() - 3>
						<cfset local.pageStart = attributes.smartList.getTotalPages()-3 />
						<cfset local.pageCount = 4 />
					</cfif>
				<cfelse>
					<cfset local.pageCount = attributes.smartList.getTotalPages() - 1 />
				</cfif>
				
				<cfset local.pageEnd = local.pageStart + local.pageCount />
			</cfsilent>
			
			<cfif attributes.smartList.getTotalPages() gt 1>
				<div class="pagination" data-tableid="LD#replace(attributes.smartList.getSavedStateID(),'-','','all')#">
					<ul>
						<li><a href="##" class="paging-show-toggle">#request.slatwallScope.rbKey('define.show')# <span class="details">(#attributes.smartList.getPageRecordsStart()# - #attributes.smartList.getPageRecordsEnd()# #lcase(request.slatwallScope.rbKey('define.of'))# #attributes.smartList.getRecordsCount()#)</span></a></li>
						<li><a href="##" class="show-option" data-show="10">10</a></li>
						<li><a href="##" class="show-option" data-show="25">25</a></li>
						<li><a href="##" class="show-option" data-show="50">50</a></li>
						<li><a href="##" class="show-option" data-show="100">100</a></li>
						<li><a href="##" class="show-option" data-show="500">500</a></li>
						<li><a href="##" class="show-option" data-show="ALL">ALL</a></li>
						<cfif attributes.smartList.getCurrentPage() gt 1>
							<li><a href="##" class="listing-pager page-option prev" data-page="#attributes.smartList.getCurrentPage() - 1#">&laquo;</a></li>
						<cfelse>
							<li class="disabled"><a href="##" class="page-option prev">&laquo;</a></li>
						</cfif>
						<cfif attributes.smartList.getTotalPages() gt 6 and attributes.smartList.getCurrentPage() gt 3>
							<li><a href="##" class="listing-pager page-option" data-page="1">1</a></li>
							<li class="disabled"><a href="##" class="page-option">...</a></li>
						</cfif>
						<cfloop from="#local.pageStart#" to="#local.pageEnd#" index="i" step="1">
							<li <cfif attributes.smartList.getCurrentPage() eq i>class="active"</cfif>><a href="##" class="listing-pager page-option" data-page="#i#">#i#</a></li>
						</cfloop>
						<cfif attributes.smartList.getTotalPages() gt 6 and attributes.smartList.getCurrentPage() lt attributes.smartList.getTotalPages() - 3>
							<li class="disabled"><a href="##" class="page-option">...</a></li>
							<li><a href="##" class="listing-pager page-option" data-page="#attributes.smartList.getTotalPages()#">#attributes.smartList.getTotalPages()#</a></li>
						</cfif>
						<cfif attributes.smartList.getCurrentPage() lt attributes.smartList.getTotalPages()>
							<li><a href="##" class="listing-pager page-option next" data-page="#attributes.smartList.getCurrentPage() + 1#">&raquo;</a></li>
						<cfelse>
							<li class="disabled"><a href="##" class="page-option next">&raquo;</a></li>
						</cfif>
					</ul>
				</div>
			</cfif>
		<cfelse>
			<p><em>#replace(request.slatwallScope.rbKey("entity.define.norecords"), "${entityNamePlural}", request.slatwallScope.rbKey("entity.#replace(attributes.smartList.getBaseEntityName(), 'Slatwall', '', 'all')#_plural"))#</em></p>
		</cfif>
	</cfoutput>
</cfif>

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
	<cfparam name="attributes.processSmartList" type="any" default="" />
	<cfparam name="attributes.processHeaderString" type="any" default="" />
	<cfparam name="attributes.processRecordsProperty" type="string" default="" />
	
	<!--- ThisTag Variables used just inside --->
	<cfparam name="thistag.columns" type="array" default="#arrayNew(1)#" />
	
	<cfoutput>
		<table class="table table-striped table-bordered table-condensed">
			<thead>
				<cfloop array="#thistag.columns#" index="column">
					<cfif !len(column.title)>
						<cfif len(column.propertyIdentifier) && len(attributes.processRecordsProperty)>
							<cfset column.title = attributes.processSmartList.getRecords()[1].invokeMethod("get#attributes.processRecordsProperty#")[1].getTitleByPropertyIdentifier(column.propertyIdentifier) />
						<cfelseif len(column.propertyIdentifier)>
							<cfset column.title = attributes.processSmartList.getRecords()[1].getTitleByPropertyIdentifier(column.propertyIdentifier) />
						<cfelseif len(column.data)>
							<cfset column.title = request.slatwallScope.rbKey( replace(request.context.slatAction, ':', '.') & ".processOption.#column.data#" ) />
						</cfif>
					</cfif>
					<cfif column.fieldType neq "hidden">
						<th>#column.title#</th>
					</cfif>
				</cfloop>
			</thead>
			<tbody>
				<cfset hi = 0 />
				<cfset ri = 0 />
				
				<cfloop array="#attributes.processSmartList.getRecords()#" index="parentRecord">
					<cfset hi++ />
					
					<!--- Process Records are of a sub-property --->
					<cfif len(attributes.processRecordsProperty)>
						
						<cfif attributes.processSmartList.getRecordsCount() gt 1>
							<!--- Header for each group if there are more than 1 --->
							<tr>
								<td class="highlight-ltblue" colspan="#arrayLen(thistag.columns)#">
									#parentRecord.stringReplace( attributes.processHeaderString )#
						<cfelse>
							<!--- Hidden Header because there is only 1 --->
							<tr style="display:none;"><td>
						</cfif>
								<input type="hidden" name="processRecords[#hi#].#parentRecord.getPrimaryIDPropertyName()#" value="#parentRecord.getPrimaryIDValue()#" />
							</td>
						</tr>
						
						<!--- Get the actual records that we want to process --->
						<cfset processRecords = parentRecord.invokeMethod("get#attributes.processRecordsProperty#") />
						
						<cfloop array="#processRecords#" index="processRecord">
							<cfset ri++ />
							<tr><input type="hidden" name="processRecords[#hi#].records[#ri#].#processRecord.getPrimaryIDPropertyName()#" value="#processRecord.getPrimaryIDValue()#" style="width:40px;"/>
								<cfloop array="#thistag.columns#" index="column">
									<cfif len(column.propertyIdentifier)>
										<td class="#column.tdClass#">#processRecord.getValueByPropertyIdentifier( propertyIdentifier=column.propertyIdentifier, formatValue=true )#</td>
									<cfelseif len(column.data)>
										<cfset local.thisValue = column.value />
										<cfif left(column.value, "2") eq "${">
											<cfset local.thisValue = processRecord.getValueByPropertyIdentifier( replace(replace(column.value, '${', '', 'all'),'}','','all') ) />
										</cfif>
										<cfif column.fieldType neq "hidden">
											<td class="#column.tdClass#"><cf_SlatwallFormField fieldname="processRecords[#hi#].records[#ri#].#column.data#" fieldtype="#column.fieldType#" fieldclass="#column.fieldClass#" valueOptions="#column.valueOptions#" value="#local.thisValue#"></td>
										<cfelse>
											<cf_SlatwallFormField fieldname="processRecords[#hi#].records[#ri#].#column.data#" fieldtype="#column.fieldType#" fieldclass="#column.fieldClass#" valueOptions="#column.valueOptions#" value="#local.thisValue#">
										</cfif>	
									</cfif>
								</cfloop>
							</tr>
						</cfloop>
						
					<!--- Process Records are just the parent object --->
					<cfelse>
						
						<tr>
							<input type="hidden" name="processRecords[#hi#].#parentRecord.getPrimaryIDPropertyName()#" value="#parentRecord.getPrimaryIDValue()#" />
							<cfloop array="#thistag.columns#" index="column">
								<cfif len(column.propertyIdentifier)>
									<td class="#column.tdClass#">#parentRecord.getValueByPropertyIdentifier( propertyIdentifier=column.propertyIdentifier, formatValue=true )#</td>
								<cfelseif len(column.data)>
									<cfset local.thisValue = column.value />
									<cfif left(column.value, "2") eq "${">
										<cfset local.thisValue = parentRecord.getValueByPropertyIdentifier( replace(replace(column.value, '${', '', 'all'),'}','','all') ) />
									</cfif>
									<cfif column.fieldType neq "hidden">
										<td class="#column.tdClass#"><cf_SlatwallFormField fieldname="processRecords[#hi#].#column.data#" fieldtype="#column.fieldType#" fieldclass="#column.fieldClass#" valueOptions="#column.valueOptions#" value="#local.thisValue#"></td>
									<cfelse>
										<cf_SlatwallFormField fieldname="processRecords[#hi#].#column.data#" fieldtype="#column.fieldType#" fieldclass="#column.fieldClass#" valueOptions="#column.valueOptions#" value="#local.thisValue#">
									</cfif>	
								</cfif>
							</cfloop>
						</tr>
						
					</cfif>
					
				</cfloop>
			</tbody>
		</table>
	</cfoutput>
</cfif>
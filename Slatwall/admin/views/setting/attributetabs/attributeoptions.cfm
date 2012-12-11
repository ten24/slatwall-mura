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
<cfparam name="rc.attribute" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cfif rc.attribute.getAttributeType().getSystemCode() eq "atText">
		<cf_SlatwallPropertyList>
			<cf_SlatwallPropertyDisplay object="#rc.attribute#" property="validationMessage" edit="#rc.edit#">
			<cf_SlatwallPropertyDisplay object="#rc.attribute#" property="validationRegex" edit="#rc.edit#">	
		</cf_SlatwallPropertyList>
	<cfelseif rc.attribute.getAttributeType().getSystemCode() eq "atPassword">
		<cf_SlatwallPropertyList>
			<cf_SlatwallPropertyDisplay object="#rc.attribute#" property="decryptValueInAdminFlag" edit="#rc.edit#">
		</cf_SlatwallPropertyList>
	<cfelseif listFindNoCase( "atCheckBoxGroup,atMultiSelect,atRadioGroup,atSelect",rc.attribute.getAttributeType().getSystemCode() )>
		
		<cf_SlatwallListingDisplay smartList="#rc.attribute.getAttributeOptionsSmartList()#"
								   recordEditAction="admin:setting.editattributeoption" 
								   recordEditQueryString="attributeID=#rc.attribute.getAttributeID()#"
								   recordEditModal="true"
								   recordDeleteAction="admin:setting.deleteattributeoption"
								   recordDeleteQueryString="attributeID=#rc.attribute.getAttributeID()#&returnAction=admin:setting.detailAttribute"
								   sortProperty="sortOrder"
								   sortContextIDColumn="attributeID"
								   sortContextIDValue="#rc.attribute.getAttributeID()#">
			<cf_SlatwallListingColumn propertyIdentifier="attributeOptionValue" /> 
			<cf_SlatwallListingColumn tdclass="primary" propertyIdentifier="attributeOptionLabel" /> 
		</cf_SlatwallListingDisplay>
		
		<cf_SlatwallActionCaller action="admin:setting.createattributeoption" class="btn btn-inverse" icon="plus icon-white" queryString="attributeid=#rc.attribute.getAttributeID()#" modal=true />
	</cfif>
	
</cfoutput>
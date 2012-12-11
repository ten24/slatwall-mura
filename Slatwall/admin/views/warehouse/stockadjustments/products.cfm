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
<cfparam name="rc.stockAdjustment" type="any" />

<cf_SlatwallListingDisplay smartList="#rc.stockAdjustment.getstockAdjustmentItemsSmartList()#"
						   recorddeleteaction="admin:warehouse.deleteStockAdjustmentItem"
						   recorddeletequerystring="returnaction=admin:warehouse.editstockadjustment&stockAdjustmentID=#rc.stockadjustment.getStockAdjustmentID()#"
						   recordeditmodal="true"
						   recordeditaction="admin:warehouse.editStockAdjustmentItem"
						   recordeditquerystring="returnaction=admin:warehouse.editstockadjustment&stockAdjustmentID=#rc.stockadjustment.getStockAdjustmentID()#">
						   	   
	<cfif listFindNoCase("satLocationTransfer,satManualOut", rc.stockAdjustment.getStockAdjustmentType().getSystemCode())>
		<cf_SlatwallListingColumn tdclass="primary" propertyIdentifier="fromstock.sku.skucode" />
		<cf_SlatwallListingColumn propertyIdentifier="fromstock.sku.product.brand.brandName" />
		<cf_SlatwallListingColumn propertyIdentifier="fromstock.sku.product.productName" />
		<cf_SlatwallListingColumn propertyIdentifier="fromstock.sku.optionsDisplay" sort="false" />
		
		<cf_SlatwallListingColumn propertyIdentifier="fromstock.location.locationName" title="#$.slatwall.rbKey('admin.warehouse.detailstockadjustment.fromlocationname')#" />
		<cfif rc.stockAdjustment.getStockAdjustmentType().getSystemCode() eq "satLocationTransfer">
			<cf_SlatwallListingColumn propertyIdentifier="tostock.location.locationName" title="#$.slatwall.rbKey('admin.warehouse.detailstockadjustment.tolocationname')#" />
		</cfif>
	<cfelse>
		<cf_SlatwallListingColumn tdclass="primary" propertyIdentifier="tostock.sku.skucode" />
		<cf_SlatwallListingColumn propertyIdentifier="tostock.sku.product.brand.brandName" />
		<cf_SlatwallListingColumn propertyIdentifier="tostock.sku.product.productName" />
		<cf_SlatwallListingColumn propertyIdentifier="tostock.sku.optionsDisplay" sort="false" />
		<cf_SlatwallListingColumn propertyIdentifier="tostock.location.locationName" title="#$.slatwall.rbKey('admin.warehouse.detailstockadjustment.tolocationname')#" />
	</cfif>
	
	<cf_SlatwallListingColumn propertyIdentifier="quantity" />
</cf_SlatwallListingDisplay>

<cf_SlatwallProcessCaller entity="#rc.stockAdjustment#" action="admin:warehouse.processStockAdjustment" processContext="addItems" class="btn btn-inverse" icon="plus icon-white" queryString="stockAdjustmentID=#rc.stockAdjustment.getStockAdjustmentID()#" modal=true />


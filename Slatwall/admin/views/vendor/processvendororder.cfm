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

<cfparam name="rc.returnAction" type="string" default="admin:vendor.detailvendororder&vendorOrderID=#rc.vendorOrderID#" />
<cfparam name="rc.processVendorOrderSmartList" type="any" />
<cfparam name="rc.multiProcess" type="boolean" />

<cfset local.vendorOrder = rc.processVendorOrderSmartList.getRecords()[1] />

<cfoutput>
	<cf_SlatwallProcessForm>
		
		<cf_SlatwallActionBar type="process" />
		
		<cfswitch expression="#rc.processcontext#">
			
			<!--- Add Order Items --->
			<cfcase value="addOrderItems">
				
				<cf_SlatwallProcessOptionBar>
					<cf_SlatwallProcessOption data="locationID" fieldtype="select" valueOptions="#$.slatwall.getService('LocationService').getLocationOptions()#" />
				</cf_SlatwallProcessOptionBar>

				<cf_SlatwallProcessListing processSmartList="#rc.processVendorOrderSmartList#" processRecordsProperty="vendorSkus">
					<cf_SlatwallProcessColumn propertyIdentifier="product.brand.brandName" />
					<cf_SlatwallProcessColumn tdClass="primary" propertyIdentifier="product.productName" />
					<cf_SlatwallProcessColumn propertyIdentifier="skucode" />
					<cf_SlatwallProcessColumn propertyIdentifier="optionsdisplay" />
					<cf_SlatwallProcessColumn data="estimatedReceivalDateTime" fieldType="datetime" />
					<cf_SlatwallProcessColumn data="quantity" fieldType="text" fieldClass="span1 number" />
					<cf_SlatwallProcessColumn data="cost" fieldType="text" fieldClass="span1 number" />
				</cf_SlatwallProcessListing>

			</cfcase>
			
			<!--- Receive Stock --->
			<cfcase value="receiveStock">
				
				<cfset vendorOrder = rc.$.slatwall.getService('VendorOrderService').getVendorOrder(rc.vendorOrderID) />
				<cfset locations = rc.$.slatwall.getService('LocationService').getLocationOptions() /> 
				
				<cf_SlatwallFieldDisplay title="Box Count" fieldtype="text" fieldname="processOptions.boxcount" edit="true">
				<cf_SlatwallFieldDisplay title="Packing Slip Number" fieldtype="text" fieldname="processOptions.packingslipnumber" edit="true">
				<cf_SlatwallFieldDisplay title="Location" fieldname="processOptions.locationID" fieldType="select" valueOptions="#locations#" edit="true">
			
				<cf_SlatwallProcessListing processSmartList="#rc.processVendorOrderSmartList#" processRecordsProperty="vendorOrderItems">
					<cf_SlatwallProcessColumn propertyIdentifier="stock.sku.product.brand.brandName" />
					<cf_SlatwallProcessColumn tdclass="primary" propertyIdentifier="stock.sku.product.productName" />
					<cf_SlatwallProcessColumn propertyIdentifier="stock.sku.skucode" />
					<cf_SlatwallProcessColumn propertyIdentifier="stock.sku.optionsDisplay" />
					<cf_SlatwallProcessColumn propertyIdentifier="quantity"/>
					<cf_SlatwallProcessColumn propertyIdentifier="quantityReceived"/>
					<cf_SlatwallProcessColumn propertyIdentifier="quantityUnreceived"/>
					<cf_SlatwallProcessColumn data="quantity" fieldType="text" fieldClass="span2 number" value="" />
				</cf_SlatwallProcessListing>
				
			</cfcase>
			
		</cfswitch>
		
	</cf_SlatwallProcessForm>
</cfoutput>
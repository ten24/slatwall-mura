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
<cfparam name="rc.product" type="any">
<cfparam name="rc.locations" type="array">

<cfoutput>
	<div class="svoinventorydetailproduct">
		<table class="listing-grid stripe">
			<tr>
				<th colspan="3">Product Name / Sku / Location</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qoh.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qosh.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qndoo.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qndorvo.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qndosa.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qnroro.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qnrovo.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qnrosa.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qc.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qe.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qnc.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qats.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qiats.full')#</th>
			</tr>
			<cfloop array="#rc.product.getSkus()#" index="local.sku">
				<tr class="sku">
					<td style="text-align:left;">#local.sku.getSkuCode()#</td>
					<cfif arrayLen(rc.locations) gt 1>
						<td style="text-align:left;">#local.sku.displayOptions()#</td>
						<td>All Locations</td>
					<cfelse>
						<td style="text-align:left;" colspan="2">#local.sku.displayOptions()#</td>
					</cfif>
					<td>#local.sku.getQuantity('QOH')#</td>
					<td>#local.sku.getQuantity('QOSH')#</td>
					<td>#local.sku.getQuantity('QNDOO')#</td>
					<td>#local.sku.getQuantity('QNDORVO')#</td>
					<td>#local.sku.getQuantity('QNDOSA')#</td>
					<td>#local.sku.getQuantity('QNRORO')#</td>
					<td>#local.sku.getQuantity('QNROVO')#</td>
					<td>#local.sku.getQuantity('QNROSA')#</td>
					<td>#local.sku.getQuantity('QC')#</td>
					<td>#local.sku.getQuantity('QE')#</td>
					<td>#local.sku.getQuantity('QNC')#</td>
					<td>#local.sku.getQuantity('QATS')#</td>
					<td>#local.sku.getQuantity('QIATS')#</td>
				</tr>
				<cfif arrayLen(rc.locations) gt 1>
					<cfloop array="#rc.locations#" index="local.location">
						<tr class="stock">
							<td class="varWidth" colspan="2">&nbsp;</td>
							<td>#local.location.getLocationName()#</td>
							<td>#local.sku.getQuantity('QOH', local.location.getLocationID())#</td>
							<td>#local.sku.getQuantity('QOSH', local.location.getLocationID())#</td>
							<td>#local.sku.getQuantity('QNDOO', local.location.getLocationID())#</td>
							<td>#local.sku.getQuantity('QNDORVO', local.location.getLocationID())#</td>
							<td>#local.sku.getQuantity('QNDOSA', local.location.getLocationID())#</td>
							<td>#local.sku.getQuantity('QNRORO', local.location.getLocationID())#</td>
							<td>#local.sku.getQuantity('QNROVO', local.location.getLocationID())#</td>
							<td>#local.sku.getQuantity('QNROSA', local.location.getLocationID())#</td>
							<td>#local.sku.getQuantity('QC', local.location.getLocationID())#</td>
							<td>#local.sku.getQuantity('QE', local.location.getLocationID())#</td>
							<td>#local.sku.getQuantity('QNC', local.location.getLocationID())#</td>
							<td>#local.sku.getQuantity('QATS', local.location.getLocationID())#</td>
							<td>#local.sku.getQuantity('QIATS', local.location.getLocationID())#</td>
						</tr>
					</cfloop>
				</cfif>
			</cfloop>
			<tr class="product">
				<td colspan="3">TOTAL</td>
				<td>#rc.product.getQuantity('QOH')#</td>
				<td>#rc.product.getQuantity('QOSH')#</td>
				<td>#rc.product.getQuantity('QNDOO')#</td>
				<td>#rc.product.getQuantity('QNDORVO')#</td>
				<td>#rc.product.getQuantity('QNDOSA')#</td>
				<td>#rc.product.getQuantity('QNRORO')#</td>
				<td>#rc.product.getQuantity('QNROVO')#</td>
				<td>#rc.product.getQuantity('QNROSA')#</td>
				<td>#rc.product.getQuantity('QC')#</td>
				<td>#rc.product.getQuantity('QE')#</td>
				<td>#rc.product.getQuantity('QNC')#</td>
				<td>#rc.product.getQuantity('QATS')#</td>
				<td>#rc.product.getQuantity('QIATS')#</td>
			</tr>
		</table>
	</div>
</cfoutput>

















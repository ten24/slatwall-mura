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
<cfparam name="rc.orderDeliveryShipping" type="any" />

<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
	<head>
		<style type="text/css">
			* {font-family:Arial, Helvetica, sans-serif; color:##000000;}
			
			p, div, dt, dd, td, th {font-size:13px; text-align:left;}
			
			html, body {width:auto; height:auto;}
			
			h1 {border-bottom:1px solid ##cccccc; font-size:20px;}
			
			table {margin:0px; border:0px; border-collapse:collapse; width:100%;}
			th, td {padding:5px 20px 5px 10px;}
			th		{border-bottom:2px solid ##cccccc;}
			td		{border-bottom:1px solid ##cccccc;}
			
			dl {margin:0px; with:230px;}
			dt {margin:0px; clear:both; float:left; width:120px; padding:4px; font-weight:bold; padding-top:4px; border:1px solid ##cccccc;}
			dd {margin:0px; float:left; width:100px; padding:4px; border:1px solid ##cccccc;}
			
			div.shippingAddress {float:left; margin-top:20px;}
			div.orderDetails {float:right; margin-top:20px;}
			div.items {clear:both; margin-top:80px;}
			div.footer {margin-top:80px;}
			
			th.quantity, td.quantity {text-align:right; width:50px;}
			tr.total td {font-weight:bold; background-color:##dddddd;}
			
			.clear {clear:both;}
		</style>
		<script type="text/javascript">
			window.onload = function() {
				setTimeout("window.print()", 100);	
			}
		</script>
	</head>
	<body>
		<h1>Packing Slip</h1>
		<div class="shippingAddress">
			<cf_SlatwallAddressDisplay address="#rc.orderDeliveryShipping.getShippingAddress()#" edit="false" />
		</div>
		<div class="orderDetails">
			<dl>
				<dt>Order Number</dt>
				<dd>#rc.orderDeliveryShipping.getOrder().getOrderNumber()#</dd>
				<dt>Date Shipped</dt>
				<dd>#dateFormat(rc.orderDeliveryShipping.getDeliveryOpenDateTime(),"medium")#</dd>
				<dt>Shipping Method</dt>
				<dd>#rc.orderDeliveryShipping.getShippingMethod().getShippingMethodName()#</dd>
			</dl>
		</div>
		<br class="clear" />
		<div class="items">
			<table>
				<tr>
					<th class="skuCode">Sku Code</th>
					<th class="item">Item</th>
					<th class="quantity">Quantity</th>
				</tr>
			<cfloop array="#rc.orderDeliveryShipping.getOrderDeliveryItems()#" index="item">
				<tr>
					<td class="skuCode">#item.getOrderItem().getSku().getSkuCode()#</td>
					<td class="item">#item.getOrderItem().getSku().getProduct().getTitle()# - #item.getOrderItem().getSku().displayOptions()#</td>
					<td class="quantity">#item.getQuantity()#</td>
				</tr>
			</cfloop>
				<tr class="total">
					<td>Total</td>
					<td></td>
					<td class="quantity">#rc.orderDeliveryShipping.getTotalQuantityDelivered()#</td>
				</tr>
			</table>
		</div>
		<br class="clear" />
		<div class="footer">
			<p>Thank you for your order!</p>
		</div>
	</body>
</html>
</cfoutput>
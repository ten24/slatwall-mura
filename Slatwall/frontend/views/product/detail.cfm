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
<cfoutput>
	<div class="svoproductdetail">
		<div class="image">
			<a href="#$.slatwall.Product().getImagePath()#" target="_blank">#$.slatwall.Product().getImage(size="m")#</a>
		</div>
		<dl>
			<cf_SlatwallPropertyDisplay object="#$.slatwall.Product()#" property="productCode">
			<cf_SlatwallPropertyDisplay object="#$.slatwall.Product()#" property="livePrice">
			<cf_SlatwallPropertyDisplay object="#$.slatwall.Product()#" property="productDescription">
		</dl>
		<form action="#$.createHREF(filename=$.slatwall.setting('globalPageShoppingCart'),queryString='nocache=1')#" method="post">
			<input type="hidden" name="productID" value="#$.slatwall.Product().getProductID()#" />
			<input type="hidden" name="slatAction" value="frontend:cart.addItem" />
			<cfset local.fulfillmentMethodSkus = {} />
			<!--- Product Options --->
			<cfif arrayLen($.slatwall.product().getSkus(true)) eq 1>
				<input type="hidden" name="skuID" value="#$.slatwall.Product().getSkus()[1].getSkuID()#" />
			<cfelse>
				<dl>
					<dt>Select Option</dt>
					<dd>
						<select name="skuID">
							<cfset local.skus = $.slatwall.product().getSkus(sorted=true, fetchOptions=true) />
							<cfloop array="#local.skus#" index="local.sku">
								<option value="#local.sku.getSkuID()#">#local.sku.displayOptions()#</option>
								<cfloop list="#local.sku.setting('skuEligibleFulfillmentMethods')#" index="local.fulfillmentMethodID">
									<cfif structKeyExists(fulfillmentMethodSkus,local.fulfillmentMethodID)>
										<cfset fulfillmentMethodSkus[local.fulfillmentMethodID] = listAppend(fulfillmentMethodSkus[local.fulfillmentMethodID],local.sku.getSkuID()) />
									<cfelse>
										<cfset fulfillmentMethodSkus[local.fulfillmentMethodID] = local.sku.getSkuID() />
									</cfif>
								</cfloop>
							</cfloop>
						</select>
					</dd>
				</dl>
			</cfif>
			<!--- END: Product Options --->
			
			<!--- START: Sku Price --->
			<cfif !isNull($.slatwall.product('defaultSku').getUserDefinedPriceFlag()) AND $.slatwall.product('defaultSku').getUserDefinedPriceFlag()>
				<input type="text" name="price" value="" />
			</cfif>
			
			<!--- Fulfillment Options --->
			<cfif len(structKeyList(local.fulfillmentMethodSkus)) GT 1>
				<cfset local.fulfillmentMethodSmartList = $.slatwall.getService("fulfillmentService").getFulfillmentMethodSmartList() />
				<cfset local.fulfillmentMethodSmartList.addInFilter('fulfillmentMethodID', structKeyList(local.fulfillmentMethodSkus)) />
				<cfset local.fulfillmentMethodSmartList.addOrder('sortOrder|ASC') />
				<cfset local.fulfillmentMethods = local.fulfillmentMethodSmartList.getRecords() />
				<dl>
					<dt>Select Fulfillment Option</dt>
					<dd>
						<select name="fulfillmentMethodID">
							<cfloop array="#local.fulfillmentMethods#" index="local.fulfillmentMethod">
								<option value="#local.fulfillmentMethod.getFulfillmentMethodID()#" skuIDs="#local.fulfillmentMethodSkus[local.fulfillmentMethod.getFulfillmentMethodID()]#">#local.fulfillmentMethod.getFulfillmentMethodName()#</option>
							</cfloop>
						</select>
					</dd>
				</dl>
			</cfif>	
			
			<!--- END: Fulfillment Options --->
			
			<!--- Product Customizations --->
			<cfset customAttributeSetTypeArray = ['astProductCustomization','astOrderItem'] />
			<cfloop array="#$.slatwall.product().getAttributeSets(customAttributeSetTypeArray)#" index="local.customizationAttributeSet">
				<div class="productCustomizationSet #lcase(replace(local.customizationAttributeSet.getAttributeSetName(), ' ', '', 'all'))#">
					<h4>#local.customizationAttributeSet.getAttributeSetName()#</h4>
					<dl>
						<cf_SlatwallAttributeSetDisplay attributeSet="#local.customizationAttributeSet#" entity="#$.slatwall.product()#" edit="true" />
					</dl>
				</div>
			</cfloop>
			<!--- END: Product Customizations --->
				
			<label for="productQuantity">Quantity: </label><input type="text" name="quantity" value="1" size="2" id="productQuantity" />
			<button type="submit">Add To Cart</button>
		</form>
		<div class="reviews">
			<cfloop array="#$.slatwall.product().getProductReviews()#" index="review">
				<dl>
					<dt class="title">#review.getReviewTitle()#</dt>
					<dt class="name">#review.getReviewerName()#</dt>
					<dd class="rating">#review.getRating()#</dd>
					<dd class="review">#review.getReview()#</dd>
				</dl>
			</cfloop>
			<form action="?nocache=1" method="post">
				<input type="hidden" name="slatAction" value="frontend:product.addReview" />
				<input type="hidden" name="product.productID" value="#$.slatwall.product('productID')#" />
				<dl>
					<dt>Name</dt>
					<dd><input type="text" name="reviewerName" value="#$.slatwall.account('fullname')#" /></dd>
					<dt>Rating</dt>
					<dd>
						<select name="rating">
							<option value="5" selected="selected">5</option>
							<option value="4">4</option>
							<option value="3">3</option>
							<option value="2">2</option>
							<option value="1">1</option>
						</select>
					</dd>
					<dt>Title</dt>
					<dd><input type="text" name="reviewTitle" value="" /></dd>
					<dt>Review</dt>
					<dd><textarea name="review"></textarea></dd>
				</dl>
				<button type="submit">Add Review</button>
			</form>
		</div>
	</div>
</cfoutput>

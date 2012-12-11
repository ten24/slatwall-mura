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
																								
<!---[ DEVELOPER NOTES ]																		
																								
	This view is designed to display a list of products.  In order to do that Slatwall uses		
	a utility called a "SmartList".  The SmartList allows for you to easily add do common		
	listing tasks: Search, Range, Filter, Paging, ect.											
																								
	Anywhere on your site you can use the following to get the current productList:				
																								
	$.slatwall.productList()																	
																								
	The product list will always have these filters set by default:								
																								
	activeFlag = 1																				
	publishedFlag = 1																			
	(calculatedQATS > 0 or calculatedAllowBackorderFlag = 1)									
																								
	Whenever you are on a content page that has been flaged as a 'Slatwall Listing Page'		
	the $.slatwall.productList() will also include the filter to only show products that have	
	been explicitly assigned to that page in the admin.  In addition this view will be			
	automatically included on content flaged as such.											
																								
	The "SmartList" has the following API methods that you can use to get details about the		
	records being returned.  This productList has access to all of those methods:				
																								
	$.slatwall.productList().getRecordsCount()													
	$.slatwall.productList().getPageRecordsStart()												
	$.slatwall.productList().getPageRecordsEnd()												
	$.slatwall.productList().getPageRecordsShow()												
	$.slatwall.productList().getCurrentPage()													
	$.slatwall.productList().getTotalPages()													
																								
	You can find detailed information on SmartList and all of the additional API methods at:	
	http://docs.getSlatwall.com/reference/SmartList												
																								
																		[/ DEVELOPER NOTES ]--->
<cfoutput>
	<div class="sv-content-listproduct">
		
		<!--- Top Pager --->
		<cf_swListingPager smartList="#$.slatwall.getCurrentProductList()#" hiddenPageSymbol="..." previousPageSymbol="&laquo;" nextPageSymbol="&raquo;" />

		<div class="products">
			
			<!--- Main Loop of all the products in this list --->
			<cfloop array="#$.slatwall.getCurrentProductList().getPageRecords()#" index="local.product">

				<div class="record">
					<a href="#local.product.getCalculatedTitle()#">
						<div class="image">#local.product.getImage(size="s")#</div> <!--- For more infomation on the getImage() method take a look at the image manipulation docs here: http://docs.getslatwall.com/reference/product-images-and-cropping/ --->
						<div class="title">#local.product.getCalculatedTitle()#</div>
						<div class="price">
							<cfif local.product.getCalculatedSalePrice() lt local.product.getPrice()>
								<span class="oldPrice">#local.product.getPrice()#</span>	
							</cfif>
							#local.product.getCalculatedSalePrice()#
						</div>
					</a>
				</div>
				
				<!---[ DEVELOPER NOTES ]																		
																												
					Inside of the main loop of a productList() you can use any of the following properties		
					that will be be avaliable as part of the primary query.  If you ask for any additional		
					properties, you will run the Risk of N+1 SQL Statements where each record will make			
					1 or more additional database calls	and directly impact performance.  This is why we make	
					use of the 'calculated' fields so that processing necessary is done ahead of time. All of	
					the following values are safe to use in this listing without concern of lazy loading		
																												
					local.product.getProductID()																
					local.product.getActiveFlag()																
					local.product.getURLTitle()																	
					local.product.getProductName()																
					local.product.getProductCode()																
					local.product.getProductDescription()														
					local.product.getPublishedFlag()															
					local.product.getSortOrder()																
					local.product.getCalculatedSalePrice()														
					local.product.getCalculatedQATS()															
					local.product.getCalculatedAllowBackorderFlag()												
					local.product.getCalculatedTitle()															
					local.product.getCreatedDateTime()															
					local.product.getModifiedDateTime()															
					local.product.getRemoteID()																	
																												
					local.product.getDefaultSku().getSkuID()													
					local.product.getDefaultSku().getActiveFlag()												
					local.product.getDefaultSku().getSkuCode()													
					local.product.getDefaultSku().getListPrice()												
					local.product.getDefaultSku().getPrice()													
					local.product.getDefaultSku().getRenewalPrice()												
					local.product.getDefaultSku().getImageFile()												
					local.product.getDefaultSku().getUserDefinedPriceFlag()										
					local.product.getDefaultSku().getCreatedDateTime()											
					local.product.getDefaultSku().getModifiedDateTime()											
					local.product.getDefaultSku().getRemoteID()													
																												
					local.product.getBrand().getBrandID()														
					local.product.getBrand().getActiveFlag()													
					local.product.getBrand().getPublishedFlag()													
					local.product.getBrand().getURLTitle()														
					local.product.getBrand().getBrandName()														
					local.product.getBrand().getBrandWebsite()													
					local.product.getBrnad().getCreatedDateTime()												
					local.product.getBrnad().getModifiedDateTime()												
					local.product.getBrnad().getRemoteID()														
																												
					local.product.getProductType().getProductTypeID()											
					local.product.getProductType().getProductTypeIDPath()										
					local.product.getProductType().getActiveFlag()												
					local.product.getProductType().getPublishedFlag()											
					local.product.getProductType().getURLTitle()												
					local.product.getProductType().getProductTypeName()											
					local.product.getProductType().getProductTypeDescription()									
					local.product.getProductType().getSystemCode()												
					local.product.getProductType().getCreatedDateTime()											
					local.product.getProductType().getModifiedDateTime()										
					local.product.getProductType().getRemoteID()												
																												
																						[/ DEVELOPER NOTES ]--->
																		
			</cfloop>
		</div>
		
		<!--- Bottom Pager --->
		<cf_swListingPager smartList="#$.slatwall.getCurrentProductList()#" hiddenPageSymbol="..." previousPageSymbol="&laquo;" nextPageSymbol="&raquo;" />
		
	</div>
</cfoutput>
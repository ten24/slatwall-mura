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
																								
	This view is designed to display a specific product's details.  Typically this view will	
	be included inside the primary body section of the template that was assigned to this		
	product.  However sometime this layout of this internal view you would want to change on	
	a template by template basis.																
																								
	If you would like to change this layout from template to template, then we recommend you	
	just copy and paste the content of this view directly into each template.  After you move	
	the code, you can just comment out this entire file so that it doesn't get processed twice.	
																								
	Before this view or template is rendered, the correct product gets set inside of the		
	slatwall scope based on the products urlTitle, or if a productID is defined in the URL.		
	This entire view makes use of that product by refrencing it like this:						
																								
	$.slatwall.product()																		
																								
	Some of the key relational properties that you are going to want to work with are:			
																								
	$.slatwall.product().getBrand()				|	Returns brand object or null				
	$.slatwall.product().getProductType()		|	Returns the productType object				
	$.slatwall.product().getDefaultSku()		|	Returns the default sku object				
	$.slatwall.product().getSkus()				|	Retruns array of sku objects				
	$.slatwall.product().getProductReviews()	|	Returns array of review objects				
	$.slatwall.product().getRelatedProducts()	|	Returns array of product objects 			
																								
	There are a ton of properties that you can access from the product.	 For a full list of		
	what is available it is probably best to just open up the entity itself in the Slatwall		
	core and reference the properties that are there.  The file is located in:					
																								
	/Slatwall/com/entity/Product.cfc															
																								
																		[/ DEVELOPER NOTES ]--->
<cfoutput>
	<div class="svdetailproduct">
		
		<!--- Title --->
		<h1>#$.slatwall.product().getTitle()#</h1>
		
		<!--- Start: Images --->
		<div class="images">
			
			<div class="primary-image">
				<a href="#$.slatwall.product().getResizedImagePath(size='l')#" target="_blank">
					<img class="main-image" src="#$.slatwall.product().getResizedImagePath(size='m')#" />
				</a>
			</div>
			<div class="thumbnails">
				<cfset local.galleryDetails = $.slatwall.getImageGalleryArray() />
				<cfdump var="#local.galleryDetails#" abort />
				<!---[ DEVELOPER NOTES ]																		
																												
					The primary method that makes images galleries possible is:									
																												
					$.slatwall.getImageGalleryArray( array resizedSizes )										
																												
					This is a very unique method to give you all the data you need to create an image gallery	
					with whatever sizes.  The ImageGalleryArray will take whatever sizes you pass in, and pass	
					back the details and resized image paths for all of the skus default images as well as any	
					alternative images that were assigned to the product.										
																												
					For example, if you wanted to get 2 sizes back 100x100 and 500x500 so that you could		
					display thumbnails ect.  You would just do:													
																												
					$.slatwall.getImageGalleryArray( [ {width=100, height=100}, {width=500, height=500} ] )		
																												
																												
					By default if you don't pass in your own resizing array, it will just ask for the 3 sizes	
					of Small, Medium, and Large which will get the actually sizes from the product settings.	
					The logic it runs by default is the same as if you did this:								
																												
					$.slatwall.getImageGalleryArray( [ {size='small'},{size='medium'},{size='large'} ] )		
																												
																												
					Basically every structure in the array, will just call the getResizedImagePath() method		
					so you can pass in whatever resizing and cropping arguments you like based on the specs		
					that you read more about here:																
																												
					http://docs.getslatwall.com/reference/product-images-and-cropping/							
																												
																						[/ DEVELOPER NOTES ]--->
																						
				<cfloop array="#local.galleryDetails#" index="local.image">
					
					<!---[ DEVELOPER NOTES ]																		
																													
						Now that we are inside of the loop of images being returned, you have access to the			
						following detials insilde of the local.image struct that came back in the array				
																													
																							[/ DEVELOPER NOTES ]--->
				</cfloop>


			</div>
		</div>
		<!--- End: Images --->
		
		<!--- Start: Price --->
		<div id="PriceDetails" class="prices">
			<cfif $.slatwall.product().getPrice() neq $.slatwall.product.getListPrice()>
				<span class="list-price" data-propertyidentifier="listPrice">#$.slatwall.product().getFormattedValue('listPrice')#</span>
			</cfif>
			<cfif $.slatwall.product().getPrice() gt $.slatwall.product.getLivePrice()>
				<span class="old-price" data-propertyidentifier="price">#$.slatwall.product().getFormattedValue('price')#</span>
			</cfif>
			<span class="live-price" data-propertyidentifier="livePrice">#$.slatwall.product().getFormattedValue('livePrice')#</span>
			
			<!---[ DEVELOPER NOTES ]																		
																											
				There are a lot of ways to represent price in Slatwall.  The first thing to know is that	
				price is always stored at the "sku" level.  This means that when you ask for a given price	
				of a product, it will actually get the price based on the defaultSku that is assigned in	
				the product admin.  Also it is important to note the getFormattedValue() that is avalible	
				on all Slatwall objects.  The following are a list of all the diffent prices:				
																											
				$.slatwall.product().getPrice()																
				$.slatwall.product().getFormattedValue('price')												
					Returns the exact price that is stored in the defaultSku "price" field.					
																											
				$.slatwall.product().getListPrice()															
				$.slatwall.product().getFormattedValue('listPrice')											
					Returns the exact price that is stored in the defaultSku "listPrice" field.				
																											
				$.slatwall.product().getCurrentAccountPrice()												
				$.slatwall.product().getFormattedValue('currentAccountPrice')								
					This will return the price for the current account that is logged in based upon any		
					price groups that the account is either assigned to, or has a current and active		
					subscription in the system for.															
																											
				$.slatwall.product().getSalePrice()															
				$.slatwall.product().getFormattedValue('salePrice')											
					Returns the price based on any current active promotions that don't require any			
					qualifier or promotion code.															
																											
				$.slatwall.product().getLivePrice()															
				$.slatwall.product().getFormattedValue('livePrice')											
					Return the best price based on all of the above options.  That way you can display 1	
					price field as the price a end user is going to pay reguarless of if it is derived		
					from a promotion, or specific price list												
																											
																											
				There is another useful method that allows you to return a structure of sale price details	
				by skuID to get things like the discount type, and the promotion ID that the sale price		
				is derived from:																			
																											
				$.slatwal.product().salePriceDetailsForSkus()												
																											
																					[/ DEVELOPER NOTES ]--->
																					
		</div>
		<!--- End: Price --->
		
		<!--- Product Description --->
		<div class="description">
			#$.slatwall.product().getProductDescription()#
		</div>

		<!--- Add To Cart --->
		<cf_swAddToCartForm>
			
			<cf_swAddToCartOptionSelector type="select" ajaxPriceSelector="##PriceDetails" />
			<cf_swAddToCartProductCustomizations />

			<cf_swSubmitButton text="Add To Cart" />
		</cf_swAddToCartForm>
		
		<!--- Additional Attributes --->
		
	</div>
</cfoutput>
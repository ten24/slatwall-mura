/*

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

*/
component displayname="Image" entityname="SlatwallImage" table="SlatwallImage" persistent="true" extends="BaseEntity" {
			
	// Persistent Properties
	property name="imageID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="imageName" ormtype="string";
	property name="imageDescription" ormtype="string" length="4000";
	property name="imageExtension" ormtype="string";
	property name="imageFile" ormtype="string";
	property name="directory" ormtype="string";
	
	// Related entity properties (many-to-one)
	property name="imageType" cfc="Type" fieldtype="many-to-one" fkcolumn="imageTypeID" systemCode="itProduct";
	property name="product" cfc="Product" fieldtype="many-to-one" fkcolumn="productID";
	property name="promotion" cfc="Promotion" fieldtype="many-to-one" fkcolumn="promotionID";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	public string function getImagePath() {
		return "#request.muraScope.siteConfig().getAssetPath()#/assets/Image/Slatwall/#getDirectory()#/#getImageFile()#";
	}
	
	public string function getImageDirectory(){
		return "#request.muraScope.siteConfig().getAssetPath()#/assets/Image/Slatwall/#getDirectory()#/";	
	}
	
	public string function getImage(string size, numeric width=0, numeric height=0, string alt="", string class="", string resizeMethod="scale", string cropLocation="",numeric cropXStart=0, numeric cropYStart=0,numeric scaleWidth=0,numeric scaleHeight=0) {
		
		var path = getResizedImagePath(argumentcollection=arguments);
		
		// Setup Alt & Class for the image
		if(arguments.alt == "" && len(getImageName())) {
			arguments.alt = "#getImageName()#";
		}
		if(arguments.class == "") {
			arguments.class = "productImage";	
		}
		
		// Try to read and return the image, otherwise don't specify the height and width
		try {
			var img = imageRead(expandPath(path));
			return '<img src="#path#" width="#imageGetWidth(img)#" height="#imageGetHeight(img)#" alt="#arguments.alt#" class="#arguments.class#" />';	
		} catch(any e) {
			return '<img src="#path#" alt="#arguments.alt#" class="#arguments.class#" />';
		}
		
	}
	
	public string function getResizedImagePath(string size, numeric width=0, numeric height=0, string resizeMethod="scale", string cropLocation="",numeric cropXStart=0, numeric cropYStart=0,numeric scaleWidth=0,numeric scaleHeight=0) {
		
		arguments.imagePath = getImagePath();
		
		if(!isNull(getProduct())) {
			arguments.missingImagePath = getProduct().setting('productMissingImagePath');
		}
		
		if(structKeyExists(arguments, "size")) {
			arguments.size = lcase(arguments.size);
			if(arguments.size eq "l" || arguments.size eq "large") {
				arguments.size = "large";
			} else if (arguments.size eq "m" || arguments.size eq "medium") {
				arguments.size = "medium";
			} else {
				arguments.size = "small";
			}
			arguments.width = setting("productImage#arguments.size#Width");
			arguments.height = setting("productImage#arguments.size#Height");
		}
		
		return getService("imageService").getResizedImagePath(argumentCollection=arguments);
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// Product (many-to-one)
	public void function setProduct(required any product) {
		variables.product = arguments.product;
		if(isNew() or !arguments.product.hasProductImage( this )) {
			arrayAppend(arguments.product.getProductImages(), this);
		}
	}
	public void function removeProduct(any product) {
		if(!structKeyExists(arguments, "product")) {
			arguments.product = variables.product;
		}
		var index = arrayFind(arguments.product.getProductImages(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.product.getProductImages(), index);
		}
		structDelete(variables, "product");
	}
	
	// Promotion (many-to-one)
	public void function setPromotion(required any promotion) {
		variables.promotion = arguments.promotion;
		if(isNew() or !arguments.promotion.hasPromotionImage( this )) {
			arrayAppend(arguments.promotion.getPromotionImages(), this);
		}
	}
	public void function removePromotion(any promotion) {
		if(!structKeyExists(arguments, "promotion")) {
			arguments.promotion = variables.promotion;
		}
		var index = arrayFind(arguments.promotion.getPromotionImages(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.promotion.getPromotionImages(), index);
		}
		structDelete(variables, "promotion");
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentationPropertyName() {
		return "imageName";
	}
	
	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}
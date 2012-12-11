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
component accessors="true" output="false" extends="BaseObject" {

	property name="ormHasErrors";
	
	property name="currentAccount";
	property name="currentBrand";
	property name="currentCart";
	property name="currentContent";
	property name="currentProduct";
	property name="currentProductType";
	property name="currentProductSmartList";
	property name="currentSession";
	
	public any function init() {
		setORMHasErrors(false);
		
		return this;
	}
	
	public any function getCurrentAccount() {
		return getCurrentSession().getAccount();
	}
	
	public any function getCurrentBrand() {
		if(!structKeyExists(variables, "currentBrand")) {
			variables.currentBrand = getService("brandService").newBrand();
		}
		return variables.currentBrand;
	}
	
	public any function getCurrentCart() {
		if(!structKeyExists(variables, "currentCart")) {
			if(!isNull(getCurrentSession().getOrder())) {
				variables.currentCart = getCurrentSession().getOrder();
			} else {
				variables.currentCart = getService("orderService").newOrder();	
			}
		}
		return variables.currentCart;
	}
	
	public any function getCurrentContent() {
		if(!structKeyExists(variables, "currentContent")) {
			variables.currentContent = getService("contentService").newContent();
		}
		return variables.currentContent;
	}
	
	public any function getCurrentProduct() {
		if(!structKeyExists(variables, "currentProduct")) {
			variables.currentProduct = getService("productService").newProduct();
		}
		return variables.currentProduct;
	}
	
	public any function getCurrentProductType() {
		if(!structKeyExists(variables, "currentProductType")) {
			variables.currentProductType = getService("productService").newProductType();
		}
		return variables.currentProductType;
	}
	
	public any function getCurrentProductSmartList() {
		if(!structKeyExists(variables, "currentProductSmartList")) {
			variables.currentProductSmartList = getService("productService").getProductSmartList(data=url);
			variables.currentProductSmartList.addFilter('activeFlag', 1);
			variables.currentProductSmartList.addFilter('publishedFlag', 1);
			variables.currentProductSmartList.addRange('calculatedQATS', '1^');
			if(isBoolean(getCurrentContent().setting('contentProductListingFlag')) && getCurrentContent().setting('contentProductListingFlag') && isBoolean(getCurrentContent().setting('contentIncludeChildContentProductsFlag')) && getCurrentContent().setting('contentIncludeChildContentProductsFlag')) {
				variables.currentProductSmartList.addWhereCondition(" EXISTS(SELECT sc.contentID FROM SlatwallContent sc INNER JOIN sc.listingProducts slp WHERE sc.cmsContentIDPath LIKE '%#getCurrentContent().getCMSContentID()#%' AND slp.productID = aslatwallproduct.productID) ");
			} else if(isBoolean(getCurrentContent().setting('contentProductListingFlag')) && getCurrentContent().setting('contentProductListingFlag') && !isNull(getCurrentContent().getCMSContentID())) {
				variables.currentProductSmartList.addFilter('listingPages.cmsContentID',getCurrentContent().getCMSContentID());
			}
			if(!structKeyExists(url, "P:Show") && isNumeric(getCurrentContent().setting('contentDefaultProductsPerPage'))) {
				variables.currentProductSmartList.setPageRecordsShow(getCurrentContent().setting('contentDefaultProductsPerPage'));
			}
		}
		return variables.currentProductSmartList;
	}
	
	public any function getCurrentSession() {
		if(!structKeyExists(variables, "currentSession")) {
			getService("sessionService").setPropperSession();
		}
		return variables.currentSession;
	}
	
	// =========== These methods serve as a shorthand
	public any function account(string property, string value) {
		if(isDefined("arguments.property") && isDefined("arguments.value")) {
			return evaluate("getCurrentAccount().set#arguments.property#(#arguments.value#)");
		} else if (isDefined("arguments.property")) {
			return evaluate("getCurrentAccount().get#arguments.property#()");
		} else {
			return getCurrentAccount();	
		}
	}
	
	public any function cart(string property, string value) {
		if(structKeyExists(arguments, "property") && structKeyExists(arguments, "value")) {
			return getCurrentCart().invokeMethod("set#arguments.property#", {1=arguments.value});
		} else if (isDefined("arguments.property")) {
			return getCurrentCart().invokeMethod("get#arguments.property#", {});
		} else {
			return getCurrentCart();	
		}
	}
	
	public any function product(string property, string value) {
		if(isDefined("arguments.property") && isDefined("arguments.value")) {
			return evaluate("getCurrentProduct().set#arguments.property#(#arguments.value#)");
		} else if (isDefined("arguments.property")) {
			return evaluate("getCurrentProduct().get#arguments.property#()");
		} else {
			return getCurrentProduct();
		}
	}
	
	public any function productList(string property, string value) {
		if(isDefined("arguments.property") && isDefined("arguments.value")) {
			return evaluate("getCurrentProductSmartList().set#arguments.property#(#arguments.value#)");
		} else if (isDefined("arguments.property")) {
			return evaluate("getCurrentProductSmartList().get#arguments.property#()");
		} else {
			return getCurrentProductSmartList();
		}
	}
	
	public any function content(string property, string value) {
		if(isDefined("arguments.property") && isDefined("arguments.value")) {
			return evaluate("getCurrentContent().set#arguments.property#(#arguments.value#)");
		} else if (isDefined("arguments.property")) {
			return evaluate("getCurrentContent().get#arguments.property#()");
		} else {
			return getCurrentContent();
		}
	}
	
	public any function session(string property, string value) {
		if(structKeyExists(arguments, "property") && structKeyExists(arguments, "value")) {
			return evaluate("getCurrentSession().set#arguments.property#(#arguments.value#)");
		} else if (structKeyExists(arguments, "property")) {
			return evaluate("getCurrentSession().get#arguments.property#()");
		} else {
			return getCurrentSession();	
		}
	}
	
	public any function sessionFacade(string property, string value) {
		if(structKeyExists(arguments, "property") && structKeyExists(arguments, "value")) {
			return getService("sessionService").setValue(arguments.property, arguments.value);
		} else if (structKeyExists(arguments, "property")) {
			return getService("sessionService").getValue(arguments.property);
		} else {
			return getService("sessionService");	
		}
	}
	
	// ======== These are just simple methods used to place ramdom values that are stored for the duration of the request ========
	public boolean function hasValue(required string key) {
		return structKeyExists(variables, arguments.key);
	}

	public any function getValue(required string key) {
		if(hasValue( arguments.key )) {
			return variables[ arguments.key ]; 
		}
		
		throw("You have requested '#arguments.key#' as a value in the slatwall scope, however that value has not been set in the request.  In the futuer you should check for it's existance with hasValue().");
	}
	
	public void function setValue(required string key, required any value) {
		variables[ arguments.key ] = arguments.value;
	}
}
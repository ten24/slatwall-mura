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
component displayname="Category" entityname="SlatwallCategory" table="SlatwallCategory" persistent="true" accessors="true" extends="BaseEntity" parentPropertyName="parentCategory" {
	
	// Persistent Properties
	property name="categoryID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="categoryIDPath" ormtype="string";
	property name="categoryName" ormtype="string";
	property name="cmsCategoryID" ormtype="string";
	property name="cmsSiteID" ormtype="string";
	property name="restrictAccessFlag" ormtype="boolean";
	property name="allowProductAssignmentFlag" ormtype="boolean";
	
	// Related Object Properties (many-to-one)
	property name="parentCategory" cfc="Category" fieldtype="many-to-one" fkcolumn="parentCategoryID";
	
	// Related Object Properties (one-to-many)
	property name="childCategories" singularname="childCategory" cfc="Category" type="array" fieldtype="one-to-many" fkcolumn="parentCategoryID" cascade="all-delete-orphan" inverse="true";
	
	// Related Object Properties (many-to-many)
	property name="products" singularname="product" cfc="Product" fieldtype="many-to-many" linktable="SlatwallProductCategory" fkcolumn="categoryID" inversejoincolumn="productID" inverse="true";
	
	// Remote properties
	property name="remoteID" ormtype="string" hint="Only used when integrated with a remote system";
	
	// Audit Properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties



	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================

	// Child Categories (one-to-many)    
	public void function addChildCategory(required any childCategory) {    
		arguments.childCategory.setParentCategory( this );    
	}    
	public void function removeChildCategory(required any childCategory) {    
		arguments.childCategory.removeParentCategory( this );    
	}
	
	// Parent Category (many-to-one)
	public void function setParentCategory(required any parentCategory) {
		variables.parentCategory = arguments.parentCategory;
		if(isNew() or !arguments.parentCategory.hasChildCategory( this )) {
			arrayAppend(arguments.parentCategory.getChildCategories(), this);
		}
	}
	public void function removeParentCategory(any parentCategory) {
		if(!structKeyExists(arguments, "parentCategory")) {
			arguments.parentCategory = variables.parentCategory;
		}
		var index = arrayFind(arguments.parentCategory.getChildCategories(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.parentCategory.getChildCategories(), index);
		}
		structDelete(variables, "parentCategory");
	}
	
	// products (many-to-many)
	public void function addProduct(required any product) {
	   arguments.product.addCategory(this);
	}
	
	public void function removeProduct(required any product) {
	   arguments.product.removeCategory(this);
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	public void function preInsert(){
		super.preInsert();
		setCategoryIDPath( buildIDPathList( "parentCategory" ) );
	}
	
	public void function preUpdate(struct oldData){
		super.preUpdate(argumentcollection=arguments);
		setCategoryIDPath( buildIDPathList( "parentCategory" ) );
	}
	
	// ===================  END:  ORM Event Hooks  =========================
}
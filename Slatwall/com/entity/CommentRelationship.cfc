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
component displayname="Comment Relationship" entityname="SlatwallCommentRelationship" table="SlatwallCommentRelationship" persistent="true" accessors="true" extends="BaseEntity" {
	
	// Persistent Properties
	property name="commentRelationshipID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="referencedRelationshipFlag" ormtype="boolean" default="false";
	property name="referencedExpressionStart" ormtype="integer";
	property name="referencedExpressionEnd" ormtype="integer";
	property name="referencedExpressionEntity" ormtype="string";
	property name="referencedExpressionProperty" ormtype="string";
	property name="referencedExpressionValue" ormtype="string";
	
	// Related Object Properties (many-to-one)
	property name="comment" cfc="Comment" fieldtype="many-to-one" fkcolumn="commentID";
	
	property name="order" cfc="Order" fieldtype="many-to-one" fkcolumn="orderID";
	property name="stockAdjustment" cfc="StockAdjustment" fieldtype="many-to-one" fkcolumn="stockAdjustmentID";
	property name="vendorOrder" cfc="VendorOrder" fieldtype="many-to-one" fkcolumn="vendorOrderID";
	
	// Related Object Properties (one-to-many)
	
	// Related Object Properties (many-to-many)
	
	// Remote Properties
	
	// Audit Properties
	
	// Non-Persistent Properties
	
	public any function getRelationshipEntity() {
		if(!isNull(getOrder())) {
			return getOrder();
		} else if (!isNull(getStockAdjustment())) {
			return getStockAdjustment();
		}
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Comment (many-to-one)
	public void function setComment(required any comment) {
		variables.comment = arguments.comment;
		if(isNew() or !arguments.comment.hasCommentRelationship( this )) {
			arrayAppend(arguments.comment.getCommentRelationships(), this);
		}
	}
	public void function removeComment(any comment) {
		if(!structKeyExists(arguments, "comment")) {
			arguments.comment = variables.comment;
		}
		var index = arrayFind(arguments.comment.getCommentRelationships(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.comment.getCommentRelationships(), index);
		}
		structDelete(variables, "comment");
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
		
	// ===================  END:  ORM Event Hooks  =========================
}
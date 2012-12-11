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
component displayname="Comment" entityname="SlatwallComment" table="SlatwallComment" persistent="true" accessors="true" extends="BaseEntity" {
	
	// Persistent Properties
	property name="commentID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="comment" ormtype="string" length="4000" formFieldType="textarea";
	property name="publicFlag" ormtype="boolean";
	
	// Related Object Properties (many-to-one)
	
	// Related Object Properties (one-to-many)
	property name="commentRelationships" singularname="commentRelationship" cfc="CommentRelationship" type="array" fieldtype="one-to-many" fkcolumn="commentID" inverse="true" cascade="all-delete-orphan";
	
	// Related Object Properties (many-to-many)
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	
	// Non-Persistent Properties
	property name="primaryRelationship" persistent="false";
	property name="commentWithLinks" persistent="false";
	
	
	
	// ============ START: Non-Persistent Property Methods =================
	
	public any function getPrimaryRelationship() {
		if(!structKeyExists(variables, "primaryRelationship")) {
			for(var i=1; i<=arrayLen(getCommentRelationships()); i++) {
				if(!getCommentRelationships()[i].getReferencedRelationshipFlag()) {
					variables.primaryRelationship = getCommentRelationships()[i];
					break;
				}
			}
		}
		return variables.primaryRelationship;
	}
	
	public string function getCommentWithLinks() {
		if(!structKeyExists(variables, "commentWithLinks")) {
			variables.commentWithLinks = getService("commentService").getCommentWithLinks(comment=this);
		}
		return variables.commentWithLinks;
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Comment Relationships (one-to-many)
	public void function addCommentRelationship(required any commentRelationship) {
		arguments.commentRelationship.setComment( this );
	}
	public void function removeCommentRelationship(required any commentRelationship) {
		arguments.commentRelationship.removeComment( this );
	}

	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentation() {
		return getCreatedByAccount().getFullName() & " - " & getFormattedValue("createdDateTime");
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	public void function preUpdate(struct oldData) {
		if(oldData.comment != variables.comment) {
			throw("You cannot update a comment because this would display a fundamental flaw in comment management.");	
		}
	}
	
	// ===================  END:  ORM Event Hooks  =========================
}
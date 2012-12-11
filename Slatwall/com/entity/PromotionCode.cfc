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
component displayname="Promotion Code" entityname="SlatwallPromotionCode" table="SlatwallPromotionCode" persistent="true" extends="BaseEntity" {
	
	// Persistent Properties
	property name="promotionCodeID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="promotionCode" ormtype="string";
	property name="startDateTime" ormtype="timestamp" formatType="custom";
	property name="endDateTime" ormtype="timestamp" formatType="custom";
	property name="maximumUseCount" ormtype="integer" notnull="false" formatType="custom";
	property name="maximumAccountUseCount" ormtype="integer" notnull="false" formatType="custom";

	// Related Object Properties (many-to-one)
	property name="promotion" cfc="Promotion" fieldtype="many-to-one" fkcolumn="promotionID";
	
	// Related Object Properties (one-to-many)
	
	// Related Object Properties (many-to-many - owner)
	property name="accounts" singularname="account" cfc="Account" type="array" fieldtype="many-to-many" linktable="SlatwallPromotionCodeAccount" fkcolumn="promotionCodeID" inversejoincolumn="accountID";
	
	// Related Object Properties (many-to-many - inverse)
	property name="orders" singularname="order" cfc="Order" type="array" fieldtype="many-to-many" linktable="SlatwallOrderPromotionCode" fkcolumn="promotionCodeID" inversejoincolumn="orderID" inverse="true";

	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties
	
	
    
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================

    // Promotion (many-to-one)
	public void function setPromotion(required any promotion) {
		variables.promotion = arguments.promotion;
		
		if(isNew() or !arguments.promotion.hasPromotionCode(this)) {
			arrayAppend(arguments.Promotion.getPromotionCodes(),this);
		}
	}
	
	public void function removePromotion(any promotion) {
		if(!structKeyExists(arguments, 'promotion')) {
			arguments.promotion = variables.promotion;
		}
		var index = arrayFind(arguments.promotion.getPromotionCodes(),this);
		
		if(index > 0) {
			arrayDeleteAt(arguments.promotion.getPromotionCodes(),index);
		}
		structDelete(variables, "promotion");
    }
    
	// Accounts (many-to-many - owner)
	public void function addAccount(required any account) {
		if(arguments.account.isNew() or !hasAccount(arguments.account)) {
			arrayAppend(variables.accounts, arguments.account);
		}
		if(isNew() or !arguments.account.hasPromotionCode( this )) {
			arrayAppend(arguments.account.getPromotionCodes(), this);
		}
	}
	public void function removeAccount(required any account) {
		var thisIndex = arrayFind(variables.accounts, arguments.account);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.accounts, thisIndex);
		}
		var thatIndex = arrayFind(arguments.account.getPromotionCodes(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.account.getPromotionCodes(), thatIndex);
		}
	}
    
	// Orders (many-to-many - inverse)
	public void function addOrder(required any order) {
		arguments.order.addPromotionCode( this );
	}
	public void function removeOrder(required any order) {
		arguments.order.removePromotionCode( this );
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	public any function getStartDateTimeFormatted() {
		if(isNull(getStartDateTime())) {
			return rbKey('define.any');
		}
		return formatValue(getStartDateTime(), "datetime");
	}
	
	public any function getEndDateTimeFormatted() {
		if(isNull(getEndDateTime())) {
			return rbKey('define.any');
		}
		return formatValue(getEndDateTime(), "datetime");
	}
	
	public any function getMaximumUseCountFormatted() {
		if(isNull(getMaximumUseCount()) || !isNumeric(getMaximumUseCount()) || getMaximumUseCount() == 0) {
			return rbKey('define.unlimited');
		}
		return getMaximumUseCount();
	}
	
	public any function getMaximumAccountUseCountFormatted() {
		if(isNull(getMaximumAccountUseCount()) || !isNumeric(getMaximumAccountUseCount()) || getMaximumAccountUseCount() == 0) {
			return rbKey('define.unlimited');
		}
		return getMaximumAccountUseCount();
	}
	
	// ===============  END: Custom Formatting Methods =====================
	
	// ============== START: Overridden Implicet Getters ===================
	
	// ==============  END: Overridden Implicet Getters ====================

	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentationPropertyName() {
		return "promotionCode";
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	public void function preInsert() {
		// Override the preInsert method to set a promotion code if one wasn't assinged
		if(isNull(getPromotionCode()) || getPromotionCode() == ""){
			setPromotionCode(createUUID());
		}
		super.preInsert();
    }
    
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================
}
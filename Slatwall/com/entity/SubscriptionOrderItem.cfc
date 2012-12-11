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
component displayname="Subscription Order Item" entityname="SlatwallSubscriptionOrderItem" table="SlatwallSubscriptionOrderItem" persistent="true" accessors="true" extends="BaseEntity" {
	
	// Persistent Properties
	property name="subscriptionOrderItemID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	
	// Related Object Properties (many-to-one)
	property name="orderItem" cfc="OrderItem" fieldtype="many-to-one" fkcolumn="orderItemID";
	property name="subscriptionOrderItemType" cfc="Type" fieldtype="many-to-one" fkcolumn="subscriptionOrderItemTypeID";
	property name="subscriptionUsage" cfc="SubscriptionUsage" fieldtype="many-to-one" fkcolumn="subscriptionUsageID" cascade="all";

	// Related Object Properties (one-to-many)
	
	// Related Object Properties (many-to-many)
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties


	public void function setOrderItem(required any orderItem) {
		variables.orderItem = arguments.orderItem;
		//copy all the info from order items to subscription usage
		if(!isNull(variables.subscriptionUsage)) {
			variables.subscriptionUsage.copyOrderItemInfo(arguments.orderItem);
		}
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Sunscription Usage (many-to-one)
	public void function setSubscriptionUsage(required any subscriptionUsage) {
		variables.subscriptionUsage = arguments.subscriptionUsage;
		if(isNew() or !arguments.subscriptionUsage.hasSubscriptionOrderItem( this )) {
			arrayAppend(arguments.subscriptionUsage.getSubscriptionOrderItems(), this);
		}
	}
	public void function removeSubscriptionUsage(any subscriptionUsage) {
		if(!structKeyExists(arguments, "subscriptionUsage")) {
			arguments.subscriptionUsage = variables.subscriptionUsage;
		}
		var index = arrayFind(arguments.subscriptionUsage.getSubscriptionOrderItems(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.subscriptionUsage.getSubscriptionOrderItems(), index);
		}
		structDelete(variables, "subscriptionUsage");
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}
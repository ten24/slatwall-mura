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
						
	paymentMethodType	
		cash			
		check			
		creditCard		
		external		
		giftCard		
		paymentTerm		
						
*/
component displayname="Payment Method" entityname="SlatwallPaymentMethod" table="SlatwallPaymentMethod" persistent=true output=false accessors=true extends="BaseEntity" {
	
	// Persistent Properties
	property name="paymentMethodID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="paymentMethodName" ormtype="string";
	property name="paymentMethodType" ormtype="string" formatType="rbKey";
	property name="allowSaveFlag" ormtype="boolean" default="false";
	property name="activeFlag" ormtype="boolean" default="false";
	property name="sortOrder" ormtype="integer";
	
	// Related Object Properties (many-to-one)
	property name="paymentIntegration" cfc="Integration" fieldtype="many-to-one" fkcolumn="paymentIntegrationID";
	
	// Related Object Properties (one-to-many)
	property name="accountPaymentMethods" singularname="accountPaymentMethod" cfc="AccountPaymentMethod" type="array" fieldtype="one-to-many" fkcolumn="paymentMethodID" cascade="all" inverse="true" lazy="extra";		// Set to lazy, just used for delete validation
	property name="orderPayments" singularname="orderPayment" cfc="OrderPayment" type="array" fieldtype="one-to-many" fkcolumn="paymentMethodID" cascade="all-delete-orphan" inverse="true" lazy="extra";				// Set to lazy, just used for delete validation
	
	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)
	
	// Remote Properties
	property name="remoteID" ormtype="string";

	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties

	
	public array function getPaymentIntegrationOptions() {
		var returnArray = [{name=rbKey('define.select'), value=""}];
		
		var optionsSL = getService("integrationService").getIntegrationSmartList();
		optionsSL.addFilter('installedFlag', '1');
		optionsSL.addFilter('paymentActiveFlag', '1');
		
		for(var i=1; i<=arrayLen(optionsSL.getRecords()); i++) {
			if(listFindNoCase(optionsSL.getRecords()[i].getIntegrationCFC("payment").getPaymentMethodTypes(), getPaymentMethodType())) {
				arrayAppend(returnArray, {name=optionsSL.getRecords()[i].getIntegrationName(), value=optionsSL.getRecords()[i].getIntegrationID()});	
			}
		}
		
		return returnArray;
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Account Payment Methods (one-to-many)
	public void function addAccountPaymentMethod(required any accountPaymentMethod) {
		arguments.accountPaymentMethod.setPaymentMethod( this );
	}
	public void function removeAccountPaymentMethod(required any accountPaymentMethod) {
		arguments.accountPaymentMethod.removePaymentMethod( this );
	}
	
	// Order Payments (one-to-many)
	public void function addOrderPayment(required any orderPayment) {
		arguments.orderPayment.setPaymentMethod( this );
	}
	public void function removeOrderPayment(required any orderPayment) {
		arguments.orderPayment.removePaymentMethod( this );
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================
	
	// ============== START: Overridden Implicet Getters ===================
	
	// ==============  END: Overridden Implicet Getters ====================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	public any function getIntegration() {
		return getPaymentIntegration();
	}
	
	// ==================  END:  Deprecated Methods ========================
	
}

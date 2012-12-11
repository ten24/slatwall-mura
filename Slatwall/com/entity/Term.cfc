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
component displayname="Term" entityname="SlatwallTerm" table="SlatwallTerm" persistent="true" accessors="true" extends="BaseEntity" {
	
	// Persistent Properties
	property name="termID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="termName" ormtype="string";
	property name="termHours" ormtype="integer";
	property name="termDays" ormtype="integer";
	property name="termMonths" ormtype="integer";
	property name="termYears" ormtype="integer";
	property name="sortOrder" ormtype="integer";
	
	// Related Object Properties (many-to-one)
	
	// Related Object Properties (one-to-many)
	property name="paymentTerms" singularname="paymentTerm" cfc="PaymentTerm" type="array" fieldtype="one-to-many" fkcolumn="termID" cascade="all" inverse="true" lazy="extra"; 															// Extra Lazy because it is only used for validation
	property name="initialSubscriptionTerms" singularname="initialSubscriptionTerm" cfc="SubscriptionTerm" type="array" fieldtype="one-to-many" fkcolumn="initialTermID" cascade="all" inverse="true" lazy="extra"; 						// Extra Lazy because it is only used for validation
	property name="renewalSubscriptionTerms" singularname="renewalSubscriptionTerm" cfc="SubscriptionTerm" type="array" fieldtype="one-to-many" fkcolumn="renewalTermID" cascade="all" inverse="true" lazy="extra"; 						// Extra Lazy because it is only used for validation
	property name="gracePeriodSubscriptionTerms" singularname="gracePeriodSubscriptionTerm" cfc="SubscriptionTerm" type="array" fieldtype="one-to-many" fkcolumn="gracePeriodTermID" cascade="all" inverse="true" lazy="extra"; 			// Extra Lazy because it is only used for validation
	property name="initialSubscriptionUsageTerms" singularname="initialSubscriptionUsageTerm" cfc="SubscriptionUsage" type="array" fieldtype="one-to-many" fkcolumn="initialTermID" cascade="all" inverse="true" lazy="extra";				// Extra Lazy because it is only used for validation
	property name="renewalSubscriptionUsageTerms" singularname="renewalSubscriptionUsageTerm" cfc="SubscriptionUsage" type="array" fieldtype="one-to-many" fkcolumn="renewalTermID" cascade="all" inverse="true" lazy="extra";				// Extra Lazy because it is only used for validation
	property name="gracePeriodSubscriptionUsageTerms" singularname="gracePeriodSubscriptionUsageTerm" cfc="SubscriptionUsage" type="array" fieldtype="one-to-many" fkcolumn="gracePeriodTermID" cascade="all" inverse="true" lazy="extra";	// Extra Lazy because it is only used for validation
	
	// Related Object Properties (many-to-many)
	
	// Remote properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties

	public any function getEndDate(any startDate = now()) {
		var endDate = arguments.startDate;
		endDate = dateAdd('yyyy',val(getTermYears()),endDate);
		endDate = dateAdd('m',val(getTermMonths()),endDate);
		endDate = dateAdd('d',val(getTermDays()),endDate);
		endDate = dateAdd('h',val(getTermHours()),endDate);
		return endDate;
	}

	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Payment Terms (one-to-many)    
	public void function addPaymentTerm(required any paymentTerm) {    
		arguments.paymentTerm.setTerm( this );    
	}    
	public void function removePaymentTerm(required any paymentTerm) {    
		arguments.paymentTerm.removeTerm( this );    
	}
	
	// Initial Subscription Terms (one-to-many)
	public void function addInitialSubscriptionTerm(required any initialSubscriptionTerm) {
		arguments.initialSubscriptionTerm.setInitialTerm( this );
	}
	public void function removeInitialSubscriptionTerm(required any initialSubscriptionTerm) {
		arguments.initialSubscriptionTerm.removeInitialTerm( this );
	}
	
	// Renewal Subscription Terms (one-to-many)
	public void function addRenewalSubscriptionTerm(required any renewalSubscriptionTerm) {
		arguments.renewalSubscriptionTerm.setRenewalTerm( this );
	}
	public void function removeRenewalSubscriptionTerm(required any renewalSubscriptionTerm) {
		arguments.renewalSubscriptionTerm.removeRenewalTerm( this );
	}

	// Grace Period Subscription Terms (one-to-many)
	public void function addGracePeriodSubscriptionTerm(required any gracePeriodSubscriptionTerm) {
		arguments.gracePeriodSubscriptionTerm.setGracePeriodTerm( this );
	}
	public void function removeGracePeriodSubscriptionTerm(required any gracePeriodSubscriptionTerm) {
		arguments.gracePeriodSubscriptionTerm.removeGracePeriodTerm( this );
	}
	
	// Initial Subscription Usage Terms (one-to-many)
	public void function addInitialSubscriptionUsageTerm(required any initialSubscriptionUsageTerm) {
		arguments.initialSubscriptionUsageTerm.setInitialTerm( this );
	}
	public void function removeInitialSubscriptionUsageTerm(required any initialSubscriptionUsageTerm) {
		arguments.initialSubscriptionUsageTerm.removeInitialTerm( this );
	}
	
	// Renewal Subscription Terms (one-to-many)
	public void function addRenewalSubscriptionUsageTerm(required any renewalSubscriptionUsageTerm) {
		arguments.renewalSubscriptionUsageTerm.setRenewalTerm( this );
	}
	public void function removeRenewalSubscriptionUsageTerm(required any renewalSubscriptionUsageTerm) {
		arguments.renewalSubscriptionUsageTerm.removeRenewalTerm( this );
	}

	// Grace Period Subscription Terms (one-to-many)
	public void function addGracePeriodSubscriptionUsageTerm(required any gracePeriodSubscriptionUsageTerm) {
		arguments.gracePeriodSubscriptionUsageTerm.setGracePeriodTerm( this );
	}
	public void function removeGracePeriodSubscriptionUsageTerm(required any gracePeriodSubscriptionUsageTerm) {
		arguments.gracePeriodSubscriptionUsageTerm.removeGracePeriodTerm( this );
	}

	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}
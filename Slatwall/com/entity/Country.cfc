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
component displayname="Country" entityname="SlatwallCountry" table="SlatwallCountry" persistent="true" extends="BaseEntity" {
	
	// Persistent Properties
	property name="countryCode" length="2" ormtype="string" fieldtype="id";
	property name="countryName" ormtype="string";
	property name="activeFlag" ormtype="boolean";
	
	property name="streetAddressLabel" ormtype="string";
	property name="streetAddressShowFlag" ormtype="boolean";
	property name="streetAddressRequiredFlag" ormtype="boolean";
	
	property name="street2AddressLabel" ormtype="string";
	property name="street2AddressShowFlag" ormtype="boolean";
	property name="street2AddressRequiredFlag" ormtype="boolean";
	
	property name="localityLabel" ormtype="string";
	property name="localityShowFlag" ormtype="boolean";
	property name="localityRequiredFlag" ormtype="boolean";
	
	property name="cityLabel" ormtype="string";
	property name="cityShowFlag" ormtype="boolean";
	property name="cityRequiredFlag" ormtype="boolean";
	
	property name="stateCodeLabel" ormtype="string";
	property name="stateCodeShowFlag" ormtype="boolean";
	property name="stateCodeRequiredFlag" ormtype="boolean";
	
	property name="postalCodeLabel" ormtype="string";
	property name="postalCodeShowFlag" ormtype="boolean";
	property name="postalCodeRequiredFlag" ormtype="boolean";


	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================

}

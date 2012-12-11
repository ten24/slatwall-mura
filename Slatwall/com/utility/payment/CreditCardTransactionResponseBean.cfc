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

component displayname="Gateway Response"  accessors="true" output="false" extends="Slatwall.com.utility.ResponseBean" {

	property name="transactionID" type="string";   
	property name="authorizationCode" type="string";
	property name="amountAuthorized" type="numeric";
	property name="amountCharged" type="numeric";
	property name="amountCredited" type="numeric";
	property name="avsCode" type="string";
	property name="securityCodeMatch" type="boolean";
	property name="duplicateFlag" type="boolean";
	property name="providerToken" type="string";
	
	public function init(){
		// Set Defaults
		setTransactionID("");
		setAuthorizationCode("");
		setAmountAuthorized(0);
		setAmountCharged(0);
		setAmountCredited(0);
		setAVSCode("E");
		setSecurityCodeMatch(false);
		setProviderToken("");
		
		return super.init();
	}

	public string function setAVSCode(required string avsCode){
		if(structKeyExists(getAVSCodes(), arguments.avsCode)){
			variables.AVSCode = arguments.avsCode;
		} else {
			throw("Returned AVS code not allowed by the system","Slatwall");
		}
	}
	
	// Private methods
	private struct function getAVSCodes(){
		var allowedAVSCodes = {
			A = "Street address matches, but 5-digit and 9-digit postal code do not match.",	
			B = "Street address matches, but postal code not verified."	,
			C = "Street address and postal code do not match.",
			D = "Street address and postal code match. Code M is equivalent.",
			E = "AVS data is invalid or AVS is not allowed for this card type.",
			F = "Card member's name does not match, but billing postal code matches.",
			G = "Non-U.S. issuing bank does not support AVS.",
			H = "Card member's name does not match. Street address and postal code match.",
			I = "Standard international",
			J = "Card member's name, billing address, and postal code match.",
			K = "Card member's name matches but billing address and billing postal code do not match.",
			L = "Card member's name and billing postal code match, but billing address does not match.",	
			M = "Street address and postal code match. Code D is equivalent.",
			N = "Street address and postal code do not match.",
			O = "Card member's name and billing address match, but billing postal code does not match.",
			P = "Postal code matches, but street address not verified.",
			Q = "Card member's name, billing address, and postal code match.",
			R = "System unavailable.",
			S = "Bank does not support AVS.",
			T = "Card member's name does not match, but street address matches.",
			U = "Address information unavailable. Returned if the U.S. bank does not support non-U.S. AVS or if the AVS in a U.S. bank is not functioning properly.",
			V = "Card member's name, billing address, and billing postal code match.",
			W = "Street address does not match, but 9-digit postal code matches.",
			X = "Street address and 9-digit postal code match.",
			Y = "Street address and 5-digit postal code match.",
			Z = "Street address does not match, but 5-digit postal code matches."
		
		};
		
		return allowedAVSCodes;
	}
	
	/*
	AVS Code List
	A	Standard domestic		Street address matches, but 5-digit and 9-digit postal code do not match.	
	B	Standard international	Street address matches, but postal code not verified.	
	C	Standard international	Street address and postal code do not match.
	D	Standard international	Street address and postal code match. Code "M" is equivalent.	
	E	Standard domestic		AVS data is invalid or AVS is not allowed for this card type.
	F	American Express only	Card member's name does not match, but billing postal code matches.
	G	Standard international	Non-U.S. issuing bank does not support AVS.
	H	American Express only	Card member's name does not match. Street address and postal code match.
	I	Standard international	Address not verified.	
	J	American Express only	Card member's name, billing address, and postal code match.
	K	American Express only	Card member's name matches but billing address and billing postal code do not match.
	L	American Express only	Card member's name and billing postal code match, but billing address does not match.	
	M	Standard international	Street address and postal code match. Code "D" is equivalent.
	N	Standard domestic		Street address and postal code do not match.
	O	American Express only	Card member's name and billing address match, but billing postal code does not match.
	P	Standard international	Postal code matches, but street address not verified.
	Q	American Express only	Card member's name, billing address, and postal code match.
	R	Standard domestic		System unavailable.
	S	Standard domestic		Bank does not support AVS.
	T	American Express only	Card member's name does not match, but street address matches.
	U	Standard domestic		Address information unavailable. Returned if the U.S. bank does not support non-U.S. AVS or if the AVS in a U.S. bank is not functioning properly.
	V	American Express only	Card member's name, billing address, and billing postal code match.
	W	Standard domestic		Street address does not match, but 9-digit postal code matches.
	X	Standard domestic		Street address and 9-digit postal code match.
	Y	Standard domestic		Street address and 5-digit postal code match.
	Z	Standard domestic		Street address does not match, but 5-digit postal code matches.
	*/
	
}
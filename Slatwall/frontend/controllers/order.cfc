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
component persistent="false" accessors="true" output="false" extends="BaseController" {

	property name="accountService" type="any";
	property name="orderService" type="any";
	property name="sessionService" type="any";
	
	public void function detail(required struct rc) {
		param name="rc.orderID" default="";
		param name="rc.orderNumber" default="";
		param name="rc.lastName" default="";
		param name="rc.emailAddress" default="";
		
		if(rc.orderID != "") {
			rc.order = getOrderService().getOrder(rc.orderID, true);
		
			// Check to make sure that the order being requested is actually the customers
			if(isNull(rc.order.getAccount()) || rc.order.getAccount().getAccountID() != $.slatwall.account().getAccountID()) {
				rc.order = getOrderService().newOrder();
			}	
		}
		
		if(rc.orderNumber != "") {
			rc.order = getOrderService().getOrderByOrderNumber(rc.orderNumber, true);
			
			if(isNull(rc.order.getAccount()) || rc.order.getAccount().getLastName() != rc.lastName || rc.order.getAccount().getEmailAddress() != rc.emailAddress) {
				rc.order = getOrderService().newOrder();	
			}
		}
		
		if(isNull(rc.order)) {
			rc.order = getOrderService().newOrder();
		}
		
	}
	
	public void function confirmation(required struct rc) {
		
		// This pulls the order ID out of the session to find the order, and then removes it so that the confirmation page can't be seen twice.
		// This is set in session so that we don't have to pass via URL
		rc.order = getOrderService().getOrder( getSessionService().getValue("orderConfirmationID", ""), true );
		// TODO: This had to get removed so that the redirectExact will work with HTTPS.
		//getSessionService().removeValue("orderConfirmationID");
	}
	
}

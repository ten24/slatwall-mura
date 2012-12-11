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

Notes: Test.

*/
component extends="BaseController" persistent="false" accessors="true" output="false" {

	// fw1 Auto-Injected Service Properties
	property name="locationService" type="any";
	property name="productService" type="any";
	property name="skuService" type="any";
	property name="stockService" type="any";
	property name="typeService" type="any";
	property name="vendorOrderService" type="any";
	
	this.publicMethods='';
	
	this.anyAdminMethods='';
	
	this.secureMethods='';
	this.secureMethods=listAppend(this.secureMethods, '**stockAdjustment');
	this.secureMethods=listAppend(this.secureMethods, 'processStockAdjustment');
	this.secureMethods=listAppend(this.secureMethods, '*stockAdjustmentItem');
	this.secureMethods=listAppend(this.secureMethods, '**stockReceiver');
	this.secureMethods=listAppend(this.secureMethods, 'processStockReceiver');
	this.secureMethods=listAppend(this.secureMethods, '*stockReceiverItem');
	
	public void function default(required struct rc) {
		getFW().redirect(action="admin:warehouse.liststockreceiver");
	}
	
	public void function createLocationTransferAdjustment(required struct rc) {
		rc.stockAdjustment = getStockService().newStockAdjustment();
		rc.stockAdjustment.setStockAdjustmentType( getTypeService().getTypeBySystemCode('satLocationTransfer') );
		
		rc.listAction = "admin:warehouse.liststockadjustment"; 
		rc.saveAction = "admin:warehouse.savestockadjustment";
		rc.cancelAction = "admin:warehouse.savestockadjustment";
		
		rc.edit = true;
		getFW().setView("admin:warehouse.detailstockadjustment");
	}
	
	public void function createManualInAdjustment(required struct rc) {
		rc.stockAdjustment = getStockService().newStockAdjustment();
		rc.stockAdjustment.setStockAdjustmentType( getTypeService().getTypeBySystemCode('satManualIn') );
		
		rc.listAction = "admin:warehouse.liststockadjustment"; 
		rc.saveAction = "admin:warehouse.savestockadjustment";
		rc.cancelAction = "admin:warehouse.savestockadjustment";
		
		rc.edit = true;
		getFW().setView("admin:warehouse.detailstockadjustment");
	}
	
	public void function createManualOutAdjustment(required struct rc) {
		rc.stockAdjustment = getStockService().newStockAdjustment();
		rc.stockAdjustment.setStockAdjustmentType( getTypeService().getTypeBySystemCode('satManualOut') );
		
		rc.listAction = "admin:warehouse.liststockadjustment"; 
		rc.saveAction = "admin:warehouse.savestockadjustment";
		rc.cancelAction = "admin:warehouse.savestockadjustment";
		
		rc.edit = true;
		getFW().setView("admin:warehouse.detailstockadjustment");
	}
}

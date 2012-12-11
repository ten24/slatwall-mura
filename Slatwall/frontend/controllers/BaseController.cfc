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
component persistent="false" accessors="true" output="false" extends="Slatwall.com.utility.BaseObject" {
	
	property name="fw" type="any";
	
	public any function init(required any fw) {
		setFW(arguments.fw);
		
		return super.init();
	}
	
	public void function subSystemBefore(required struct rc) {
		param name="rc.overrideContent" default="false";
		
		// Place any functionality that you would like applied on every request of this subsystem.
		rc.itemTitle = rc.$.Slatwall.rbKey("#request.subsystem#.#request.section#.#request.item#_title");
		if(right(rc.itemTitle, 8) == "_missing") {
			rc.itemTitle = rc.$.Slatwall.rbKey("#request.subsystem#.#request.section#.#request.item#");	
		}
		var eventAction = getFW().getSubsystem(rc.$.event("slatAction")) & ":" & getFW().getSectionAndItem(rc.$.event("slatAction"));
		if(rc.overrideContent == true && rc.slatAction == eventAction) {
			rc.$.content().setTitle(rc.itemTitle);
			rc.$.content().setHTMLTitle(rc.itemTitle);	
		}
	}
}

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
component extends="Slatwall.meta.tests.unit.SlatwallUnitTestBase" {

	public void function setUp() {
		super.setup();
		
		variables.service = request.slatwallScope.getService("utilityRBService");
	}
	
	// getRBKey()
	public void function getRBKey_default() {
		assertEquals("all", variables.service.getRBKey('define.all'));
	}
	
	public void function getRBKey_en() {
		assertEquals("all", variables.service.getRBKey('define.all', 'en'));
	}
	
	public void function getRBKey_en_fully_qualified() {
		assertEquals("all", variables.service.getRBKey('define.all', 'en_us'));
	}
	
	public void function getRBKey_fully_qualified_local_missing_shows_both_tried() {
		assertEquals("define.aaa_en_us_missing,define.aaa_en_missing", variables.service.getRBKey('define.aaa', 'en_us'));
	}
	
	public void function getRBKey_step_down_define_works_when_key_not_found() {
		assertEquals("aaa.bbb.ccc.ddd_en_us_missing,aaa.bbb.ccc.ddd_en_missing,aaa.bbb.define.ddd_en_us_missing,aaa.bbb.define.ddd_en_missing,aaa.define.ddd_en_us_missing,aaa.define.ddd_en_missing,define.ddd_en_us_missing,define.ddd_en_missing", variables.service.getRBKey('aaa.bbb.ccc.ddd', 'en_us'));
	}
	
	public void function getRBKey_another_language_besides_english_works() {
		assertEquals("todos", variables.service.getRBKey('define.all', 'es'));
	}
	
	public void function getRBKey_another_language_besides_english_works_with_fully_qualified_locale() {
		assertEquals("todos", variables.service.getRBKey('define.all', 'es_sp'));
	}
	
	// getResourceBundle()
	public void function getResourceBundle_en() {
		assert(structCount(variables.service.getResourceBundle('en')) gt 1);
	}
}


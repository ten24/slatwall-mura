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
2/
*/
component extends="BaseService" output="false" {

	// ===================== START: Logical Methods ===========================
	
	public numeric function convertWeightToGlobalWeightUnit(required numeric weight, required any measurementUnitCode) {
		if(setting('globalWeightUnitCode') eq arguments.measurementUnitCode) {
			return arguments.weight;
		}
		
		return convertWeight(arguments.weight, arguments.measurementUnitCode, setting('globalWeightUnitCode'));
	}
	
	public numeric function convertWeight(required numeric weight, required originalUnitCode, required convertToUnitCode) {
		var omu = this.getMeasurementUnit(arguments.originalUnitCode);
		var nmu = this.getMeasurementUnit(arguments.convertToUnitCode);
		
		// As long as both of the measurement units exist, then we can return the conversion 
		if(!isNull(omu) && !isNUll(nmu) && !isNull(omu.getConversionRatio()) && !isNull(nmu.getConversionRatio()) ) {
			return (arguments.weight / omu.getConversionRatio()) * nmu.getConversionRatio();	
		}
		
		// Otherwise just return the original weight
		return arguments.weight;
	}
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
}
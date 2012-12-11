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
component extends="Slatwall.com.service.BaseService" persistent="false" accessors="true" output="false" {
	
	variables.roundingRuleDetails = {};

	// We override the default save so that we can clear the roundingRule Expressions that have been saved in the variables cache
	public any function saveRoundingRule(required any entity, struct data, string context="save") {
		if(!arguments.entity.isNew()) {
			if(structKeyExists(variables.roundingRuleDetails, arguments.entity.getRoundingRuleID())) {
				structDelete(variables.roundingRuleDetails, arguments.entity.getRoundingRuleID());	
			}
		}
		
		return super.save(argumentcollection=arguments);
	}
	
	// This method adds a roundingRuleID / Expression to the variables scope, and looks for it there first.  This improves performance when doing things like rebuilding the skuCache
	public struct function getRoundingRuleDetailsByID(required string roundingRuleID) {
		if(!structKeyExists(variables.roundingRuleDetails, arguments.roundingRuleID)) {
			
			var detailsQuery = getDAO().getRoundingRuleQuery(roundingRuleID = arguments.roundingRuleID);
			
			variables.roundingRuleDetails[ arguments.roundingRuleID ] = {};
			variables.roundingRuleDetails[ arguments.roundingRuleID ].roundingRuleExpression = detailsQuery.roundingRuleExpression;
			variables.roundingRuleDetails[ arguments.roundingRuleID ].roundingRuleDirection = detailsQuery.roundingRuleDirection;
		}
		return variables.roundingRuleDetails[ arguments.roundingRuleID ];
	}
	
	public numeric function roundValueByRoundingRuleID(required any value, required string roundingRuleID) {
		var details = getRoundingRuleDetailsByID(arguments.roundingRuleID);
		return roundValue(value=arguments.value, roundingExpression=details.roundingRuleExpression, roundingDirection=details.roundingRuleDirection);
	}
	
	public numeric function roundValueByRoundingRule(required any value, required any roundingRule) {
		return roundValue(value=arguments.value, roundingExpression=arguments.roundingRule.getRoundingRuleExpression(), roundingDirection=arguments.roundingRule.getRoundingRuleDirection());
	}
	
	public string function roundValue(required any value, string roundingExpression="0.00", string roundingDirection="Closest") {
		var inputValue = numberFormat(arguments.value, "0.00");
		var returnValue = javaCast("null", "");
		var returnDelta = javaCast("null", "");
		
		for(var i=1; i<=listLen(arguments.roundingExpression); i++) {
			var rr = listGetAt(arguments.roundingExpression, i);
			var rrPower = 1 * (10 ^ (len(rr)-3));
			
			if(len(inputValue) > len(rr)) {
				var valueOptionOne = left(inputValue, len(inputValue)-len(rr)) & rr;
				
				if(valueOptionOne > inputValue) {
					var lowerValue = inputValue - rrPower;
					if(len(lowerValue) > len(rr)) {
						var valueOptionTwo = left(lowerValue, len(lowerValue)-len(rr)) & rr;	
					} else {
						var valueOptionTwo = rr;		
					}
				} else {
					var higherValue = inputValue + rrPower;
					if(len(higherValue) > len(rr)) {
						var valueOptionTwo = left(higherValue, len(higherValue)-len(rr)) & rr;
					} else {
						var valueOptionTwo = rr;
					}
				}
			} else {
				var valueOptionOne = rr;
				var valueOptionTwo = rr;
			}
			
			if(valueOptionOne == inputValue || valueOptionTwo == inputValue) {
				return inputValue;
			} else {
				var valueOptionOneDelta = inputValue - valueOptionOne;
				if(valueOptionOneDelta < 0) {
					valueOptionOneDelta = valueOptionOneDelta*-1;
				}
				var valueOptionTwoDelta = inputValue - valueOptionTwo;
				if(valueOptionTwoDelta < 0) {
					valueOptionTwoDelta = valueOptionTwoDelta*-1;
				}
				
				switch(arguments.roundingDirection) {
					case "Closest": {
						if(isNull(returnDelta) || valueOptionOneDelta < returnDelta ) {
							returnValue = valueOptionOne;
							returnDelta = valueOptionOneDelta;
						}
						if (isNull(returnDelta) || valueOptionTwoDelta < returnDelta ) {
							returnValue = valueOptionTwo;
							returnDelta = valueOptionTwoDelta;
						}
						break;
					}
					case "Up": {
						if( valueOptionOne > inputValue && (isNull(returnDelta) || valueOptionOneDelta < returnDelta) )  {
							returnValue = valueOptionOne;
							returnDelta = valueOptionOneDelta;
						}
						if ( valueOptionTwo > inputValue && (isNull(returnDelta) || valueOptionTwoDelta < returnDelta) ) {
							returnValue = valueOptionTwo;
							returnDelta = valueOptionTwoDelta;
						}
						break;
					}
					case "Down": {
						if( valueOptionOne < inputValue && (isNull(returnDelta) || valueOptionOneDelta < returnDelta) ) {
							returnValue = valueOptionOne;
							returnDelta = valueOptionOneDelta;
						}
						if ( valueOptionTwo < inputValue && (isNull(returnDelta) || valueOptionTwoDelta < returnDelta) ) {
							returnValue = valueOptionTwo;
							returnDelta = valueOptionTwoDelta;
						}
						break;
					}
				}
			}
		}
		
		if(!isNull(returnValue)) {
			return returnValue;
		} else {
			return inputValue;	
		}
	}
	
	// ===================== START: Logical Methods ===========================
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Status Methods ===========================
	
	// ======================  END: Status Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
}
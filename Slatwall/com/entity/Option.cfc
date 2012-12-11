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
component displayname="Option" entityname="SlatwallOption" table="SlatwallOption" persistent=true output=false accessors=true extends="BaseEntity" {
	
	// Persistent Properties
	property name="optionID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="optionCode" ormtype="string";
	property name="optionName" ormtype="string";
	property name="optionImage" ormtype="string";
	property name="optionDescription" ormtype="string" length="4000";
	property name="sortOrder" ormtype="integer" sortContext="optionGroup";
	
	// Related Object Properties (many-to-one)
	property name="optionGroup" cfc="OptionGroup" fieldtype="many-to-one" fkcolumn="optionGroupID";
	
	// Related Object Properties (many-to-many - inverse)
	property name="skus" singularname="sku" cfc="Sku" fieldtype="many-to-many" linktable="SlatwallSkuOption" fkcolumn="optionID" inversejoincolumn="skuID" inverse="true"; 
	property name="promotionRewards" singularname="promotionReward" cfc="PromotionReward" fieldtype="many-to-many" linktable="SlatwallPromotionRewardOption" fkcolumn="optionID" inversejoincolumn="promotionRewardID" inverse="true";
	property name="promotionQualifiers" singularname="promotionQualifier" cfc="PromotionQualifier" fieldtype="many-to-many" linktable="SlatwallPromotionQualifierOption" fkcolumn="optionID" inversejoincolumn="promotionQualifierID" inverse="true";
	
	// Remote properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	   
    public string function getImageDirectory() {
    	return "#request.muraScope.siteConfig().getAssetPath()#/assets/Image/Slatwall/meta/";
    }
    
    // Image Management methods
	
	public string function getImage(numeric width=0, numeric height=0, string alt="", string class="") {
		if( this.hasImage() ) {
			
			// If there were sizes specified, get the resized image path
			if(arguments.width != 0 || arguments.height != 0) {
				path = getResizedImagePath(argumentcollection=arguments);	
			} else {
				path = getImagePath();
			}
			
			// Read the Image
			var img = imageRead(expandPath(path));
			
			// Setup Alt & Class for the image
			if(arguments.alt == "" and len(getOptionName())) {
				arguments.alt = "#getOptionName()#";
			}
			if(arguments.class == "") {
				arguments.class = "optionImage";	
			}
			return '<img src="#path#" width="#imageGetWidth(img)#" height="#imageGetHeight(img)#" alt="#arguments.alt#" class="#arguments.class#" />';
		}
	}
	
	public string function getResizedImagePath(numeric width=0, numeric height=0) {
		return getService("imageService").getResizedImagePath(imagePath=getImagePath(), width=arguments.width, height=arguments.height);
	}
	
	public boolean function hasImage() {
		return len(getOptionImage());
	}
	
    public string function getImagePath() {
        return getImageDirectory() & getOptionImage();
    }
    
    // ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// Option Group (many-to-one)
	public void function setOptionGroup(required any optionGroup) {
		variables.optionGroup = arguments.optionGroup;
		if(isNew() or !arguments.optionGroup.hasOption( this )) {
			arrayAppend(arguments.optionGroup.getOptions(), this);
		}
	}
	public void function removeOptionGroup(any optionGroup) {
		if(!structKeyExists(arguments, "optionGroup")) {
			arguments.optionGroup = variables.optionGroup;
		}
		var index = arrayFind(arguments.optionGroup.getOptions(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.optionGroup.getOptions(), index);
		}
		structDelete(variables, "optionGroup");
	}
	
	// Skus (many-to-many - inverse)
	public void function addSku(required any sku) {
		arguments.sku.addOption( this );
	}
	public void function removeSku(required any sku) {
		arguments.sku.removeOption( this );
	}
	
	// Promotion Rewards (many-to-many - inverse)
	public void function addPromotionReward(required any promotionReward) {
		arguments.promotionReward.addOption( this );
	}
	public void function removePromotionReward(required any promotionReward) {
		arguments.promotionReward.removeOption( this );
	}
	
	// Promotion Qualifiers (many-to-many - inverse)
	public void function addPromotionQualifier(required any promotionQualifier) {
		arguments.promotionQualifier.addOption( this );
	}
	public void function removePromotionQualifier(required any promotionQualifier) {
		arguments.promotionQualifier.removeOption( this );
	}	
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================

}

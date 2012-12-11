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
component displayname="Type" entityname="SlatwallType" table="SlatwallType" persistent="true" accessors="true" output="true" extends="BaseEntity" {
	
	// Persistent Properties
	property name="typeID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="typeIDPath" ormtype="string";
	property name="type" ormtype="string";
	property name="systemCode" ormtype="string";
	
	// Related Object Properties
	property name="parentType" cfc="Type" fieldtype="many-to-one" fkcolumn="parentTypeID";
	property name="childTypes" singularname="childType" type="array" cfc="Type" fieldtype="one-to-many" fkcolumn="parentTypeID" cascade="all" inverse="true";
	
	public any function getChildTypes() {
		if(!isDefined('variables.childTypes')) {
			variables.childTypes = arraynew(1);
		}
		return variables.childTypes;
	}
	
	public any function getType() {
		if(!structKeyExists(variables, "type")) {
			variables.type = "";
		}
		return variables.type;
	}
	
	// This overrides the build in system code getter to look up to the parent if a system code doesn't exist for this type.
	public string function getSystemCode() {
		if(isNull(variables.systemCode)) {
			return getParentType().getSystemCode();
		}
		return variables.systemCode;
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ============== START: Overridden Implicet Getters ===================
	
	public string function getTypeIDPath() {
		if(isNull(variables.typeIDPath)) {
			variables.typeIDPath = buildIDPathList( "parentType" );
		}
		return variables.typeIDPath;
	}
	
	// ==============  END: Overridden Implicet Getters ====================
		
	// ================== START: Overridden Methods ========================

	public string function getSimpleRepresentationPropertyName() {
    	return "type";
    }
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	public void function preInsert(){
		setTypeIDPath( buildIDPathList( "parentType" ) );
		super.preInsert();
	}
	
	public void function preUpdate(struct oldData){
		setTypeIDPath( buildIDPathList( "parentType" ) );;
		super.preUpdate(argumentcollection=arguments);
	}
	
	// ===================  END:  ORM Event Hooks  =========================
}

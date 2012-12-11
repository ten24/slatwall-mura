component accessors="true" output="false" displayname="Canada Post" extends="Slatwall.integrationServices.BaseIntegration" implements="Slatwall.integrationServices.IntegrationInterface" {
	
	public any function init() {
		return this;
	}
	
	public string function getIntegrationTypes() {
		return "shipping";
	}
		
	public string function getDisplayName() {
		return "Canada Post";
	}
	
	public struct function getSettings() {
		var settings = {
			CPCID = {fieldType="text", displayName="CPC Shipping Integration ID"}
		};
		
		return settings;
	}
}
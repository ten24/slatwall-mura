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
component accessors="true" output="false" extends="Slatwall.integrationServices.BaseIntegration" implements="Slatwall.integrationServices.IntegrationInterface" {
	
	// Mura Service Injection on Init
	property name="configBean" type="any";
	property name="contentManager" type="any";
	property name="categoryManager" type="any";
	property name="feedManager" type="any";

	public any function init() {
		setConfigBean( getCMSBean("configBean") );
		setContentManager( getCMSBean("contentManager") );
		setCategoryManager( getCMSBean("categoryManager") );
		setFeedManager( getCMSBean("feedManager") );

		return this;
	}
	
	public string function getIntegrationTypes() {
		return "cms,fw1";
	}
	
	public string function getDisplayName() {
		return "Mura";
	}
	
	public boolean function isFW1Subsystem() {
		return false;
	}
	
	public struct function getMailServerSettings() {
		var config = getConfigBean();
		var settings = {};
		if(!config.getUseDefaultSMTPServer()) {
			settings = {
				server = config.getMailServerIP(),
				username = config.getMailServerUsername(),
				password = config.getMailServerPassword(),
				port = config.getMailServerSMTPPort(),
				useSSL = config.getMailServerSSL(),
				useTLS = config.getMailServerTLS()
			};
		}
		return settings;
	}
	
	public void function setupIntegration() {
		logSlatwall("Setting Service - verifyMuraRequirements - Started", true);
		verifyMuraFrontendViews();
		verifyMuraRequiredPages();
		pullMuraCategory();
		logSlatwall("Setting Service - verifyMuraRequirements - Finished", true);
	}
	
	private void function verifyMuraFrontendViews() {
		logSlatwall("Setting Service - verifyMuraFrontendViews - Started", true);
		var assignedSites = getPluginConfig().getAssignedSites();
		for( var i=1; i<=assignedSites.recordCount; i++ ) {
			logSlatwall("Verify Mura Frontend Views For Site ID: #assignedSites["siteID"][i]#");
			
			var baseSlatwallPath = getDirectoryFromPath(expandPath("/muraWRM/plugins/Slatwall/frontend/views/")); 
			var baseSitePath = getDirectoryFromPath(expandPath("/muraWRM/#assignedSites["siteID"][i]#/includes/display_objects/custom/slatwall/"));
			
			getService("utilityFileService").duplicateDirectory(baseSlatwallPath,baseSitePath,false,true,".svn");
		}
		logSlatwall("Setting Service - verifyMuraFrontendViews - Finished", true);
	}

	private void function verifyMuraRequiredPages() {
		logSlatwall("Setting Service - verifyMuraRequiredPages - Started", true);
		
		var requiredMuraPages = [
			{settingName="globalPageShoppingCart",settingValue="shopping-cart",title="Shopping Cart",fileName="shopping-cart",isNav="1",isLocked="1"},
			{settingName="globalPageOrderStatus",settingValue="order-status",title="Order Status",fileName="order-status",isNav="1",isLocked="1"},
			{settingName="globalPageOrderConfirmation",settingValue="order-confirmation",title="Order Confirmation",fileName="order-confirmation",isNav="0",isLocked="1"},
			{settingName="globalPageMyAccount",settingValue="my-account",title="My Account",fileName="my-account",isNav="1",isLocked="1"},
			{settingName="globalPageCreateAccount",settingValue="create-account",title="Create Account",fileName="create-account",isNav="1",isLocked="1"},
			{settingName="globalPageCheckout",settingValue="checkout",title="Checkout",fileName="checkout",isNav="1",isLocked="1"},
			{settingName="productDisplayTemplate",settingValue="",title="Default Template",fileName="default-template",isNav="0",isLocked="0",templateFlag="1",slatwallContentFlag="1"},
			{settingName="productTypeDisplayTemplate",settingValue="",title="Default Template",fileName="default-template",isNav="0",isLocked="0",templateFlag="1",slatwallContentFlag="1"},
			{settingName="brandDisplayTemplate",settingValue="",title="Default Template",fileName="default-template",isNav="0",isLocked="0",templateFlag="1",slatwallContentFlag="1"}
		];
		
		var assignedSites = getPluginConfig().getAssignedSites();
		for( var i=1; i<=assignedSites.recordCount; i++ ) {
			logSlatwall("Verify Mura Required Pages For Site ID: #assignedSites["siteID"][i]#", true);
			var thisSiteID = assignedSites["siteID"][i];
			
			for(var page in requiredMuraPages) {
				var muraPage = createMuraPage(page,thisSiteID);
				if(structKeyExists(page,"slatwallContentFlag")) {
					var slatwallContent = createSlatwallContent(muraPage,page);
					page.settingValue = slatwallContent.getContentID();
				}
				createSetting(page,thisSiteID);
				// persist all changes
				ormflush();
			}
		}
		logSlatwall("Setting Service - verifyMuraRequiredPages - Finished", true);
	}
	
	private void function createSetting(required struct page,required any siteID) {
		var settingList = getService("settingService").listSetting({settingName=arguments.page.settingName});
		
		if(!arrayLen(settingList)){
			var setting = getService("settingService").newSetting();
			setting.setSettingValue(arguments.page.settingValue);
			setting.setSettingName(arguments.page.settingName);
			getService("settingService").saveSetting(setting);
		}
	}
	
	private any function createMuraPage(required struct page,required any siteID) {
		// Setup Mura Page
		var thisPage = getContentManager().getActiveContentByFilename(filename=arguments.page.fileName, siteid=arguments.siteID);
		if(thisPage.getIsNew()) {
			thisPage.setDisplayTitle(arguments.page.title);
			thisPage.setHTMLTitle(arguments.page.title);
			thisPage.setMenuTitle(arguments.page.title);
			thisPage.setIsNav(arguments.page.isNav);
			thisPage.setActive(1);
			thisPage.setApproved(1);
			thisPage.setIsLocked(arguments.page.isLocked);
			thisPage.setParentID("00000000000000000000000000000000001");
			thisPage.setFilename(arguments.page.fileName);
			thisPage.setSiteID(arguments.siteID);
			thisPage.save();
		}
		return thisPage;
	}
	
	private any function createSlatwallContent(required any muraPage, required struct pageAttributes) {
		var thisPage = getService("contentService").getcontentByCmsContentID(arguments.muraPage.getContentID(),true);
		if(thisPage.isNew()){
			thisPage.setCmsSiteID(arguments.muraPage.getSiteID());
			thisPage.setCmsContentID(arguments.muraPage.getContentID());
			thisPage.setTitle(arguments.muraPage.getTitle());
			thisPage = getService("contentService").saveContent(thisPage,arguments.pageAttributes);
		}
		return thisPage;
	}
	
	private void function pullMuraCategory() {
		logSlatwall("Setting Service - pullMuraCategory - Started", true);
		var assignedSites = getPluginConfig().getAssignedSites();
		for( var i=1; i<=assignedSites.recordCount; i++ ) {
			logSlatwall("Pull mura category For Site ID: #assignedSites["siteID"][i]#");
			
			var categoryQuery = getCategoryManager().getCategoriesBySiteID(siteID=assignedSites["siteID"][i]);
			for(var j=1; j<=categoryQuery.recordcount; j++) {
				var category = getService("contentService").getCategoryByCmsCategoryID(categoryQuery.categoryID[j],true);
				if(category.isNew()){
					category.setCmsSiteID(categoryQuery.siteID[j]);
					category.setCmsCategoryID(categoryQuery.categoryID[j]);
					category.setCategoryName(categoryQuery.name[j]);
					category = getService("contentService").saveCategory(category);
				}
			}
		}
		logSlatwall("Setting Service - pullMuraCategory - Finished", true);
	}

	public any function getPluginConfig() {
		if(!structKeyExists(variables, "pluginConfig")) {
			variables.pluginConfig = application.pluginManager.getConfig("Slatwall");
		}
		return variables.pluginConfig;
	}
}
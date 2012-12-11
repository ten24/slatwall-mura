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
component accessors="true" output="false" displayname="Endicia" extends="Slatwall.integrationServices.BaseIntegration" implements="Slatwall.integrationServices.IntegrationInterface" {
	
	public any function init() {
		return this;
	}
	
	public struct function getSettings() {
		return {
			accountID = {fieldType="text", displayName="Account ID"},
			fromPostalCode = {fieldType="text", displayName="From Postal Code"},
			passPhrase = {fieldType="password", displayName="Pass Phrase", encryptValue=true},
			syncFTPSite = {fieldType="text", displayName="FTP Sync Server Address"},
			syncFTPSiteUsername = {fieldType="text", displayName="FTP Sync Username"},
			syncFTPSitePassword = {fieldType="password", displayName="FTP Sync Password", encryptValue=true},
			syncFTPSitePort = {fieldType="text", displayName="FTP Sync Port", defaultValue=21},
			syncFTPSiteDropoffDirectory = {fieldType="text", displayName="FTP Sync Dropoff Directory"},
			syncFTPSiteDropoffFilename = {fieldType="text", displayName="FTP Sync Dropoff Fielname"},
			syncFTPSiteSecure = {fieldType="yesno", displayName="FTP Sync Secure?", defaultValue=0}
		};
	}
	
	public string function getIntegrationTypes() {
		return "shipping,fw1";
	}
	
	public string function getDisplayName() {
		return "Endicia";
	}
}
component accessors="true" output="false" displayname="Full Circle" extends="Slatwall.integrationServices.BaseIntegration" implements="Slatwall.integrationServices.IntegrationInterface" {
	
	public any function init() {
		return this;
	}
	
	public string function getIntegrationTypes() {
		return "fw1";
	}
	
	public string function getDisplayName() {
		return "Full Circle";
	}
	
	public struct function getSettings() {
		return {
			companyCode = {fieldType="text", displayName="Full Circle Company Code", hint="This is the Full Circle Company code that you would like to use for this integration"},
			fcFTPAddress = {fieldType="text", displayName="Full Circle FTP Address", hint="This is typically the WAN IP address of your fullcircle server"},
			fcFTPDirecotry = {fieldType="text", displayName="Full Circle FTP Directory", hint="This is the path on the server to the Full Circle web integration transfer directory. Example: /v2/common/webinv "},
			fcFTPUsername = {fieldType="text", displayName="Full Circle FTP Username", hint="Username to connect to FC Server via FTP"},
			fcFTPPassword = {fieldType="password", displayName="Full Circle FTP Password", hint="Username to connect to FC Server via FTP"},
			fcFTPPort = {fieldType="text", displayName="Full Circle FTP Port", hint="Port to connect to FTP over"},
			fcFTPUseSecure = {fieldType="yesno", displayName="Use Secure FTP (SFTP)", hint="Should files be pushed and pulled via secure FTP"},
			localTransferDirctory = {fieldType="text", displayName="Local Transfer Directory", hint="This is the full directory path on this web server to where you would like transfer files to go. Example: C:\Inetpub\wwwroot\fctransfer "},
			localTransferURLPath = {fieldType="text", displayName="Local Transfer URL Path", hint="This needs to be a URL that points to the Transfer Directory so that transfer files can be imported over HTTP. Example: http://202.202.202.202/fctransfer "},
			localTransferURLUsername = {fieldType="text", displayName="Local Transfer URL Username", hint="If the transfer URL sits behind a UN/PW then please specify it here."},
			localTransferURLPassword = {fieldType="password", displayName="Local Transfer URL Password", hint="If the transfer URL sits behind a UN/PW then please specify it here."}
		};
	}
	
}
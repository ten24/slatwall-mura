<!---

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

--->
<plugin>
	<name>Slatwall Mura Connector</name>
	<package>slatwall-mura</package>
	<directoryFormat>packageOnly</directoryFormat>
	<provider>Slatwall</provider>
	<version>1.0</version>
	<providerURL>http://www.getslatwall.com/</providerURL>
	<category>Application</category>
	<settings>
		<setting>
			<name>accountSyncType</name>
			<label>Account Sync Type</label>
			<hint>This setting will define how accounts are synced back and forth between Mura and Slatwall.  The default is "Mura System Users Only" which means that any new accounts in Slatwall will not create site members in Mura, but existing/new Mura system accounts will automatically have a linked account created in Slatwall.</hint>
			<type>select</type>
			<required>true</required>
			<defaultvalue>systemUserOnly</defaultvalue>
			<optionlist>systemUserOnly^siteUserOnly^all^none</optionlist>
			<optionlabellist>Mura System Users Only^Mura Site Members Only^All Users^None</optionlabellist>
		</setting>
		<setting>
			<name>superUserSyncFlag</name>
			<label>Add Mura Super Users to Slatwall Super User Group</label>
			<hint>If set to 'yes' then any S2 Super User accounts in mura will get added to the super user group in Slatwall.  This setting will only apply if the Account Sync Type is set to 'all' or 'systemUserOnly'.</hint>
			<type>radioGroup</type>
			<required>true</required>
			<defaultvalue>true</defaultvalue>
			<optionlist>true^false</optionlist>
			<optionlabellist> Yes ^ No </optionlabellist>
		</setting>
		<setting>
			<name>createDefaultPages</name>
			<label>Create Default Pages and Templates</label>
			<hint>If set to 'yes' then the first time the Slatwall is initiated for any site, it will automatically create pages in the site manager as well as the necessary template files in your theme.</hint>
			<type>radioGroup</type>
			<required>true</required>
			<defaultvalue>true</defaultvalue>
			<optionlist>true^false</optionlist>
			<optionlabellist> Yes ^ No </optionlabellist>
		</setting>
		<setting>
			<name>slatwallInstallPath</name>
			<label>Slatwall Install Path</label>
			<hint>Point this to directory where slatwall is installed.  If you don't have Slatwall installed in the directory specified the most recent stable version will be downloaded and installed.</hint>
			<type>text</type>
			<required>true</required>
			<defaultvalue><cfoutput>#replace(replace(getDirectoryFromPath(getCurrentTemplatePath()),'/plugin/','/'),'\plugin\','\')#</cfoutput></defaultvalue>
		</setting>
	</settings>
	<eventHandlers>
		<eventHandler event="onApplicationLoad" component="eventHandler" persist="false"/>
	</eventHandlers>
	<displayObjects />
</plugin>

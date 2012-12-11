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

<cfset local.scriptHasErrors = false />
<!--- Move filename to urltitle for products. --->
<cftry>
	<cfdbinfo datasource="#application.configBean.getDataSource()#" type="index" table="SlatwallProduct" name="local.indexes" />
	<cfdbinfo datasource="#application.configBean.getDataSource()#" type="Columns" table="SlatwallProduct" name="local.columns" />
	<cfquery name="getColumnInfo" dbtype="query">
		SELECT * 
		FROM columns
		WHERE COLUMN_NAME = 'filename'
	</cfquery>
	<cfif getColumnInfo.RecordCount>
		<cfquery name="updateProduct">
			UPDATE SlatwallProduct
			SET urlTitle = fileName
		</cfquery>
		<!--- If field updated, then try to remove the fileName field --->
		<cfquery name="getConstraint" dbtype="query">
			SELECT INDEX_NAME 
			FROM indexes
			WHERE COLUMN_NAME = 'filename'
		</cfquery>
		<cfif getConstraint.recordcount>
			<cfquery name="dropConstraint">
				ALTER TABLE SlatwallProduct
				DROP <cfif application.configBean.getDbType() eq "MySQL">INDEX<cfelse>CONSTRAINT</cfif> #getConstraint.INDEX_NAME#
			</cfquery>
		</cfif>
		<cfquery name="dropFileName">
			ALTER TABLE SlatwallProduct
			DROP COLUMN fileName
		</cfquery>
	</cfif>
	<cfcatch>
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<!--- Move displayTemplate to productDisplayTemplate for products. --->
<cftry>
	<cfdbinfo datasource="#application.configBean.getDataSource()#" type="Columns" table="SlatwallProduct" name="local.columns" />
	<cfquery name="getColumnInfo" dbtype="query">
		SELECT * 
		FROM columns
		WHERE COLUMN_NAME = 'displayTemplate'
	</cfquery>
	<cfif getColumnInfo.RecordCount>
		<cfquery name="updateProduct">
			UPDATE SlatwallProduct
			SET productDisplayTemplate = displayTemplate
		</cfquery>
		<!--- If field updated, then try to remove it --->
		<cfquery name="dropDisplayTemplate">
			ALTER TABLE SlatwallProduct
			DROP COLUMN displayTemplate
		</cfquery>
	</cfif>
	<cfcatch>
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<!--- Move displayTemplate to productDisplayTemplate for productTypes. --->
<cftry>
	<cfdbinfo datasource="#application.configBean.getDataSource()#" type="Columns" table="SlatwallProductType" name="local.columns" />
	<cfquery name="getColumnInfo" dbtype="query">
		SELECT * 
		FROM columns
		WHERE COLUMN_NAME = 'displayTemplate'
	</cfquery>
	<cfif getColumnInfo.RecordCount>
		<cfquery name="updateProductType">
			UPDATE SlatwallProductType
			SET productDisplayTemplate = displayTemplate
		</cfquery>
		<!--- If field updated, then try to remove it --->
		<cfquery name="dropDisplayTemplate">
			ALTER TABLE SlatwallProductType
			DROP COLUMN displayTemplate
		</cfquery>
	</cfif>
	<cfcatch>
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<!--- Delete Country codes no longer in use 'AN' & 'YU' --->
<cfquery name="deleteCountries">
	DELETE FROM SlatwallCountry WHERE countryCode ='AN' or countryCode = 'YU'
</cfquery>

<cfquery name="oldProductTemplate">
	SELECT settingValue FROM SlatwallSetting WHERE settingName = 'product_defaultTemplate'
</cfquery>

<cfif oldProductTemplate.recordcount>
	<cfquery name="updateSetting">
		UPDATE SlatwallSetting
		SET settingValue = '#oldProductTemplate.settingValue#'
		WHERE settingName = 'product_productDefaultTemplate'
	</cfquery>
	
	<cfquery name="deleteSetting">
		DELETE SlatwallSetting
		WHERE settingName = 'product_defaultTemplate'
	</cfquery>
</cfif>

<cftry>
	<cfquery name="alterProductCategory">
		ALTER TABLE SlatwallProductCategory 
		ALTER COLUMN productID VARCHAR(32) NOT NULL;
	</cfquery>
	<cfcatch>
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cftry>	
	<cfquery name="alterCategory">
		ALTER TABLE SlatwallProductCategory 
		ALTER COLUMN categoryID VARCHAR(32) NOT NULL;
	</cfquery>
	<cfcatch>
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cftry>
	<cfquery name="alterOrderPayment">
		ALTER TABLE SlatwallOrderPayment 
		ALTER COLUMN paymentMethodID VARCHAR(32) NOT NULL;
	</cfquery>
	<cfcatch>
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cftry>
	<cfquery name="alterPaymentMethod">
		ALTER TABLE SlatwallPaymentMethod 
		ALTER COLUMN paymentMethodID VARCHAR(32) NOT NULL;
	</cfquery>
	<cfcatch>
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cftry>
	<cfquery name="alterOrderFulfillment">
		ALTER TABLE SlatwallOrderFulfillment 
		ALTER COLUMN fulfillmentMethodID VARCHAR(32) NULL;
	</cfquery>
	<cfcatch>
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cftry>
	<cfquery name="alterOrderDelivery">
		ALTER TABLE SlatwallOrderDelivery 
		ALTER COLUMN fulfillmentMethodID VARCHAR(32) NULL;
	</cfquery>
	<cfcatch>
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cftry>
	<cfquery name="alterFulfillmentMethod">
		ALTER TABLE SlatwallFulfillmentMethod 
		ALTER COLUMN fulfillmentMethodID VARCHAR(32) NULL;
	</cfquery>
	<cfcatch>
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cftry>	
	<cfcatch>
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<!--- TODO: --->
<!--- easier to DROP ALL FK AND THEN DO THIS --->
<!--- drop FK constraint from fulfillmentMethodID from orderDelivery --->
<!--- set fulfillmentMethodID to the ID for fulfillmentMethod 'Shipping' --->
<!---
UPDATE SlatwallOrderDelivery
SET fulfillmentMethodID = '444df2fb93d5fa960ba2966ba2017953'
--->
<!--- create fulfillmentMethodType in orderDelivery --->
<!--- set fulfillmentMethodType in orderDelivery to shipping --->
<!--- drop FK constraint from fulfillmentMethodID from orderFulfillment --->
<!--- set fulfillmentMethodID to the ID for fulfillmentMethod 'Shipping' --->
<!---
UPDATE SlatwallOrderFulfillment
SET fulfillmentMethodID = '444df2fb93d5fa960ba2966ba2017953'
--->
<!--- create fulfillmentMethodType in orderFulfillment --->
<!--- set fulfillmentMethodType in orderFulfillment to shipping --->
<!--- drop fulfillmentMethodID FK constraint from orderItemStatusAction --->
<!--- drop PK constraint from fulfillmentMethod --->
<!--- alter fulfillmentMethod and change length to 32 with not null --->
<!--- add PK --->
<!--- alter orderItemStatusAction and change fulfillmentMethodID length to 32 --->
<!---
ALTER TABLE SlatwallOrderItemStatusAction
ALTER COLUMN fulfillmentMethodID varchar(32)
--->

<!--- delete old fulfillment methods --->
<!---
DELETE FROM SlatwallFulfillmentMethod
WHERE fulfillmentMethodID IN ('pickup','shipping')
--->

<!--- drop PK constraint from paymentMethod --->
<!--- alter paymentMethod and change paymentMethodID length to 32 with not null --->
<!--- add PK --->
<!--- 
ALTER TABLE SlatwallPaymentMethod
ALTER COLUMN paymentMethodID varchar(32) NOT NULL 

ALTER TABLE SlatwallPaymentMethod
ADD PRIMARY KEY (paymentMethodID)
 --->
<!--- alter SlatwallOrderStatusAction and change paymentMethodID length to 32 --->
<!---
ALTER TABLE SlatwallOrderStatusAction
ALTER COLUMN paymentMethodID varchar(32)
--->
<!--- drop FK constraint from paymentMethodID from orderPayment --->
<!--- set paymentMethodID to the ID for paymentMethod 'CreditCard' --->
<!---
UPDATE SlatwallOrderPayment
SET paymentMethodID = '444df303dedc6dab69dd7ebcc9b8036a'
--->
<!--- create paymentMethodType in orderPayment --->
<!--- set paymentMethodType in orderPayment to creditCard --->

<!--- delete old payment methods --->
<!---
DELETE FROM SlatwallPaymentMethod
WHERE paymentMethodID IN ('cash','check','creditCard','dwolla','giftCard','paypalExpress')
--->



<!--- create a copy of product content --->
<!---
SELECT * INTO SlatwallProductContentOld FROM SlatwallProductContent;
--->
<!--- alter SlatwallProductContent and drop PK AND columns --->
<!---
ALTER TABLE SlatwallProductContent
DROP [PK];
ALTER TABLE SlatwallProductContent
DROP COLUMN productContentID;
ALTER TABLE SlatwallProductContent
DROP COLUMN contentPath
--->
<!--- delete all data --->
<!---
DELETE FROM SlatwallProductContent
--->
<!--- alter SlatwallProductContent and drop contentID --->
<!---
ALTER TABLE SlatwallProductContent
DROP COLUMN contentID
--->

<!--- update account murauserID to cmsaccountID --->
<!---
UPDATE SlatwallAccount
SET cmsAccountID = muraUserID
--->

<!--- update product types --->
<!---
UPDATE productTypes
SET parentProductTypeID = [merchandise]
WHERE parentProductTypeID IS NULL
--->
<!--- rebuild producttypeIDPath --->

<!--- after orm reload --->
<!---
INSERT INTO SlatwallProductPage(productID,pageID)
SELECT productID,pageID 
FROM SlatwallProductContent INNER JOIN SlatwallPage ON SlatwallProductContent.contentID = SlatwallPage.cmsPageID 

DROP TABLE SlatwallProductContent;
--->


<cfif local.scriptHasErrors>
	<cfthrow detail="Part of Script v1_4 had errors when running">
</cfif>

<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<conditions>
		<condition name="isMerchandiseProduct" serverTest="getBaseProductType() EQ 'merchandise'" />
		<condition name="isSubscriptionProduct" serverTest="getBaseProductType() EQ 'subscription'" />
		<condition name="isContentAccessProduct" serverTest="getBaseProductType() EQ 'contentAccess'" />
	</conditions>
	<contexts>
		<context name="save" />
		<context name="delete" />
		<context name="edit" />
		<context name="updateSkus" />
		<context name="addOptionGroup" />
		<context name="addOption" />
		<context name="addSubscriptionTerm" />
	</contexts>
	<objectProperties>
		<property name="urlTitle">
			<rule type="required" contexts="save" />
			<rule type="custom" contexts="save" failureMessage="URL Title is Not Unique">
				<param name="methodName" value="hasUniqueURLTitle" />
			</rule>
		</property>
		<property name="productName">
			<rule type="required" contexts="save" />
		</property>
		<property name="productCode">
			<rule type="required" contexts="save" />
			<rule type="custom" contexts="save" failureMessage="Product Code is Not Unique">
				<param name="methodName" value="hasUniqueProductCode" />
			</rule>
		</property>
		
		<property name="productType">
			<rule type="required" contexts="save" />
		</property>
		<property name="unusedProductOptions">
			<rule type="collectionSize" contexts="addOption">
				<param name="min" value="1" />
			</rule>
		</property>
		<property name="unusedProductOptionGroups">
			<rule type="collectionSize" contexts="addOptionGroup">
				<param name="min" value="1" />
			</rule>
		</property>
		<property name="unusedProductSubscriptionTerms">
			<rule type="collectionSize" contexts="addSubscriptionTerm">
				<param name="min" value="1" />
			</rule>
		</property>
		<property name="baseProductType">
			<rule type="inList" contexts="addOptionGroup,addOption">
				<param name="list" value="merchandise" />
			</rule>
			<rule type="inList" contexts="addSubscriptionTerm">
				<param name="list" value="subscription" />
			</rule>
		</property>
		<property name="price">
			<rule type="numeric" contexts="save" />
		</property>
		<property name="listPrice">
			<rule type="numeric" contexts="save" />
		</property>
	</objectProperties>
</validateThis>
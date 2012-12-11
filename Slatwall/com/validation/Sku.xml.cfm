<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<contexts>
		<context name="save" />
		<context name="delete" />
		<context name="edit" />
	</contexts>
	<objectProperties>
		<property name="skuID">
			<rule type="custom" contexts="delete" failureMessage="You cannot delete this sku because it is the default sku">
				<param name="methodName" value="isNotDefaultSku" />
			</rule>
		</property>
		<property name="stocks">
			<rule type="collectionSize" contexts="delete">
				<param name="max" value="0" />
			</rule>
		</property>
		<property name="skuCode">
			<rule type="custom" contexts="save" failureMessage="Sku Code is Not Unique">
				<param name="methodName" value="hasUniqueSkuCode" />
			</rule>
		</property>
		<property name="options">
			<rule type="custom" contexts="save" failureMessage="This Sku has the same options as another Sku">
				<param name="methodName" value="hasUniqueOptions" />
			</rule>
			<rule type="custom" contexts="save" failureMessage="This Sku has two options from the same option group">
				<param name="methodName" value="hasOneOptionPerOptionGroup" />
			</rule>
		</property>
	</objectProperties>
</validateThis>
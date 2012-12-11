<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<contexts>
		<context name="save" />
		<context name="delete" />
		<context name="edit" />
	</contexts>
	<objectProperties>
		<property name="attributeSetName">
			<rule type="required" contexts="save" />
		</property>
		<property name="attributeSetCode">
			<rule type="required" contexts="save" />
			<rule type="custom" contexts="save" failureMessage="Attribute Set Code is Not Unique">
				<param name="methodName" value="hasUniqueAttributeSetCode" />
			</rule>
		</property>
		<property name="attributeSetType">
			<rule type="required" contexts="save" />
		</property>
	</objectProperties>
</validateThis>
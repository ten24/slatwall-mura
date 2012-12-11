<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<contexts>
		<context name="save" />
		<context name="delete" />
		<context name="edit" />
	</contexts>
	<objectProperties>
		<property name="optionCode">
			<rule type="required" contexts="save" />
			<rule type="custom" contexts="save" failureMessage="Option Code is Not Unique">
				<param name="methodName" value="hasUniqueOptionCode" />
			</rule>
		</property>
		<property name="optionName">
			<rule type="required" contexts="save" />
		</property>
		<property name="optionGroup">
			<rule type="required" contexts="save" />
		</property>
		<property name="skus">
			<rule type="collectionSize" contexts="delete">
				<param name="max" value="0" />
			</rule>
		</property>
	</objectProperties>
</validateThis>
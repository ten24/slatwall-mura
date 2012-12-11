<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<contexts>
		<context name="save" />
		<context name="delete" />
		<context name="edit" />
	</contexts>
	<objectProperties>
		<property name="optionGroupName">
			<rule type="required" contexts="save" />
		</property>
		<property name="optionGroupCode">
			<rule type="required" contexts="save" />
			<rule type="custom" contexts="save" failureMessage="Option Group Code is Not Unique">
				<param name="methodName" value="hasUniqueOptionGroupCode" />
			</rule>
		</property>
		<property name="options">
			<rule type="collectionSize" contexts="delete">
				<param name="max" value="0" />
			</rule>
		</property>
	</objectProperties>
</validateThis>
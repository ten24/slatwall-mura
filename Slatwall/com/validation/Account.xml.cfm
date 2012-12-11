<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<contexts>
		<context name="save" />
		<context name="delete" />
		<context name="edit" />
	</contexts>
	<objectProperties>
		<property name="firstName">
			<rule type="required" contexts="save" />
		</property>
		<property name="lastName">
			<rule type="required" contexts="save" />
		</property>
		<property name="orders">
			<rule type="collectionSize" contexts="delete">
				<param name="max" value="0" />
			</rule>
		</property>
		<property name="cmsAccountID">
			<rule type="custom" contexts="save" failureMessage="URL Title is Not Unique">
				<param name="methodName" value="hasUniqueOrNullCMSAccountID" />
			</rule>
		</property>
	</objectProperties>
</validateThis>

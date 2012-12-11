<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<contexts>
		<context name="save" />
		<context name="delete" />
		<context name="edit" />
	</contexts>
	<objectProperties>
		<property name="subscriptionBenefitName">
			<rule type="required" contexts="save" />
		</property>
		<property name="accessType">
			<rule type="required" contexts="save" />
		</property>
		<property name="maxUseCount">
			<rule type="required" contexts="save" />
			<rule type="numeric" contexts="save" />
		</property>
		<property name="skus">
			<rule type="collectionSize" contexts="delete">
				<param name="max" value="0" />
			</rule>
		</property>
	</objectProperties>
</validateThis>

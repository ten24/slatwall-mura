<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<contexts>
		<context name="save" />
		<context name="delete" />
		<context name="edit" />
	</contexts>
	<objectProperties>
		<property name="promotionName">
			<rule type="required" contexts="save" />
		</property>
		<property name="appliedPromotions">
			<rule type="collectionSize" contexts="delete">
				<param name="max" value="0" />
			</rule>
		</property>
		<property name="promotionCodes">
			<rule type="custom" contexts="save" failureMessage="This Promotion has promotion codes that are not unique">
				<param name="methodName" value="hasUniquePromotionCodes" />
			</rule>
		</property>
	</objectProperties>
</validateThis>

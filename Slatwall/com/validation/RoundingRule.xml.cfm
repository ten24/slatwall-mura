<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<contexts>
		<context name="save" />
		<context name="delete" />
		<context name="edit" />
	</contexts>
	<objectProperties>
		<property name="roundingRuleName">
			<rule type="required" contexts="save" />
		</property>
		<property name="roundingRuleExpression">
			<rule type="required" contexts="save" />
			<rule type="custom" contexts="save" failureMessage="The Rounding Rule Expression needs to be a comma seperated list of numeric values that have two decimal proints for each value.">
				<param name="methodName" value="hasExpressionWithListOfNumericValuesOnly" />
			</rule>
		</property>
		<property name="roundingRuleDirection">
			<rule type="required" contexts="save" />
		</property>
		<property name="priceGroupRates">
			<rule type="collectionSize" contexts="delete">
				<param name="max" value="0" />
			</rule>
		</property>
	</objectProperties>
</validateThis>
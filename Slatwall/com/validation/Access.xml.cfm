<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<contexts>
		<context name="save" />
		<context name="delete" />
		<context name="edit" />
	</contexts>
	<property name="accessID">
		<rule type="custom" contexts="save" failureMessage="Requires a SubscriptionUsage, SubscriptionUsageBenefit or SubscriptionUsageBenefitAccount">
			<param name="methodName" value="hasUsageOrUsageBenefitOrUsageBenefitAccount" />
		</rule>
	</property>
</validateThis>

<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<contexts>
		<context name="save" />
		<context name="delete" />
		<context name="edit" />
	</contexts>
	<objectProperties>
		<property name="termName">
			<rule type="required" contexts="save" />
		</property>
		<property name="termHours">
			<rule type="numeric" contexts="save" />
		</property>
		<property name="termDays">
			<rule type="numeric" contexts="save" />
		</property>
		<property name="termMonths">
			<rule type="numeric" contexts="save" />
		</property>
		<property name="termYears">
			<rule type="numeric" contexts="save" />
		</property>
		<property name="paymentTerms">
			<rule type="collectionSize" contexts="delete">
				<param name="max" value="0" />
			</rule>
		</property>
		<property name="initialSubscriptionTerms">
			<rule type="collectionSize" contexts="delete">
				<param name="max" value="0" />
			</rule>
		</property>
		<property name="renewalSubscriptionTerms">
			<rule type="collectionSize" contexts="delete">
				<param name="max" value="0" />
			</rule>
		</property>
		<property name="gracePeriodSubscriptionTerms">
			<rule type="collectionSize" contexts="delete">
				<param name="max" value="0" />
			</rule>
		</property>
		<property name="initialSubscriptionUsageTerms">
			<rule type="collectionSize" contexts="delete">
				<param name="max" value="0" />
			</rule>
		</property>
		<property name="renewalSubscriptionUsageTerms">
			<rule type="collectionSize" contexts="delete">
				<param name="max" value="0" />
			</rule>
		</property>
		<property name="gracePeriodSubscriptionUsageTerms">
			<rule type="collectionSize" contexts="delete">
				<param name="max" value="0" />
			</rule>
		</property>
	</objectProperties>
</validateThis>
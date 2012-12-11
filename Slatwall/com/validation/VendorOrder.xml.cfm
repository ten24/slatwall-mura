<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<contexts>
		<context name="save" />
		<context name="delete" />
		<context name="edit" />
		<context name="addOrderItems" />
	</contexts>
	<objectProperties>
		<property name="vendor">
			<rule type="required" contexts="save" />
		</property>
		<property name="vendorOrderType">
			<rule type="required" contexts="save" />
		</property>
		<property name="vendorOrderStatusType">
			<rule type="required" contexts="save" />
		</property>
		<property name="vendorOrderStatusType">
			<rule type="required" contexts="save" />
		</property>
		<property name="vendorSkus">
			<rule type="collectionSize" contexts="addOrderItems">
				<param name="min" value="1" />
			</rule>
		</property>
		<property name="stockReceivers">
			<rule type="collectionSize" contexts="delete">
				<param name="max" value="0" />
			</rule>
		</property>
	</objectProperties>
</validateThis>
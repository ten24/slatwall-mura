<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<contexts>
		<context name="save" />
		<context name="delete" />
		<context name="edit" />
	</contexts>
	<objectProperties>
		<property name="orderItemType">
			<rule type="required" contexts="save" />
		</property>
	</objectProperties>
	<objectProperties>
		<property name="orderItemStatusType">
			<rule type="required" contexts="save" />
		</property>
	</objectProperties>
	<objectProperties>
		<property name="sku">
			<rule type="required" contexts="save" />
		</property>
	</objectProperties>
	<objectProperties>
		<property name="quantity">
			<rule type="numeric" contexts="save" />
		</property>
	</objectProperties>
</validateThis>
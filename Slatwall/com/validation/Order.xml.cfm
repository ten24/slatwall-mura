<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<contexts>
		<context name="save" />
		<context name="delete" />
		<context name="placeOrder" />
		<context name="addOrderItem" />
		<context name="addOrderPayment" />
		<context name="placeOnHold" />
		<context name="takeOffHold" />
		<context name="cancelOrder" />
		<context name="closeOrder" />
		<context name="createReturn" />
	</contexts>
	<objectProperties>
		<property name="orderType">
			<rule type="required" contexts="save" />
		</property>
		<property name="orderStatusType">
			<rule type="required" contexts="save" />
		</property>
		<property name="statusCode">
			<rule type="inList" contexts="placeOrder">
				<param name="list" value="ostNotPlaced" />
			</rule>
			<rule type="inList" contexts="addOrderItem">
				<param name="list" value="ostNotPlaced,ostNew,ostProcessing,ostOnHold" />
			</rule>
			<rule type="inList" contexts="addOrderPayment,cancelOrder,closeOrder">
				<param name="list" value="ostNew,ostProcessing,ostOnHold" />
			</rule>
			<rule type="inList" contexts="createReturn">
				<param name="list" value="ostNew,ostProcessing,ostOnHold,ostClosed" />
			</rule>
			<rule type="inList" contexts="takeOffHold">
				<param name="list" value="ostOnHold" />
			</rule>
			<rule type="inList" contexts="placeOnHold">
				<param name="list" value="ostNew,ostProcessing" />
			</rule>
		</property>
		<property name="quantityDelivered">
			<rule type="max" contexts="cancelOrder">
				<param name="max" value="0" />
			</rule>
			<rule type="min" contexts="createReturn">
				<param name="min" value="1" />
			</rule>
		</property>
		<property name="quantityReceived">
			<rule type="max" contexts="cancelOrder">
				<param name="max" value="0" />
			</rule>
		</property>
	</objectProperties>
</validateThis>
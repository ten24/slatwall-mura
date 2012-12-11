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
		<property name="startDateTime">
			<rule type="required" contexts="save" />
			<rule type="date" contexts="save" />
		</property>
		<property name="endDateTime">
			<rule type="required" contexts="save" />
			<rule type="date" contexts="save" />
			<rule type="expression" contexts="save" failureMessage="End date needs to be after start date.">
				<param name="expression" value="getEndDateTime() gt getStartDateTime()" />
			</rule>
		</property>
	</objectProperties>
</validateThis>

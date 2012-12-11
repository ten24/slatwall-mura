<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<conditions>
		<condition name="fulfillmentTypeShipping" serverTest="getFulfillmentMethodType() EQ 'shipping'" />
	</conditions>
	<contexts>
		<context name="save" />
		<context name="delete" />
		<context name="edit" />
		<context name="placeOrder" />
		<context name="fulfillItems" />
	</contexts>
	<objectProperties>
		<property name="orderFulfillmentID">
			<rule type="maxLength" contexts="delete">
				<param name="maxLength" value="0" />
			</rule>
		</property>
		<property name="orderFulfillmentItems">
			<rule type="collectionSize" contexts="save,placeOrder,fulfillItems">
				<param name="min" value="1" />
			</rule>
		</property>
		<property name="quantityUndelivered">
			<rule type="min" contexts="fulfillItems">
				<param name="min" value="1" />
			</rule>
		</property>
		<property name="address">
			<rule type="required" condition="fulfillmentTypeShipping" contexts="placeOrder" />
		</property>
		<property name="shippingMethod">
			<rule type="required" condition="fulfillmentTypeShipping" contexts="placeOrder" />
			<rule type="custom" condition="fulfillmentTypeShipping" contexts="placeOrder">
				<param name="methodName" value="hasValidShippingMethodRate" /> 
			</rule>
		</property>
		<property name="orderStatusCode">
			<rule type="inList" contexts="fulfillItems">
				<param name="list" value="ostNew,ostProcessing" />
			</rule>
			<rule type="inList" contexts="edit">
				<param name="list" value="ostNotPlaced,ostNew,ostProcessing,ostOnHold" />
			</rule>
		</property>
	</objectProperties>
</validateThis>
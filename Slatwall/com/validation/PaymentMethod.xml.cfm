<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<contexts>
		<context name="save" />
		<context name="delete" />
		<context name="edit" />
	</contexts>
	<objectProperties>
		<property name="accountPaymentMethods">
			<rule type="collectionSize" contexts="delete">
				<param name="max" value="0" />
			</rule>
		</property>
		<property name="orderPayments">
			<rule type="collectionSize" contexts="delete">
				<param name="max" value="0" />
			</rule>
		</property>
		<property name="paymentMethodType">
			<rule type="required" contexts="save" /> 
			<rule type="inList" contexts="save">
				<param name="list" value="cash,check,creditCard,external,giftCard,termPayment" />
			</rule>
		</property>
	</objectProperties>
</validateThis>
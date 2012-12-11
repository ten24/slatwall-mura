<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<contexts>
		<context name="save" />
		<context name="delete" />
		<context name="edit" />
	</contexts>
	<objectProperties>
		<property name="paymentTransactionID">
			<rule type="maxLength" contexts="delete,edit">
				<param name="maxLength" value="0" />
			</rule>
		</property>
		<property name="orderPayment">
			<rule type="custom" contexts="save" failureMessage="This Transaction is not applied to an order payment or account payment">
				<param name="methodName" value="hasOrderPaymentOrAccountPayment" />
			</rule>
		</property>
		<property name="accountPayment">
			<rule type="custom" contexts="save" failureMessage="This Transaction is not applied to an order payment or account payment">
				<param name="methodName" value="hasOrderPaymentOrAccountPayment" />
			</rule>
		</property>
	</objectProperties>
</validateThis>
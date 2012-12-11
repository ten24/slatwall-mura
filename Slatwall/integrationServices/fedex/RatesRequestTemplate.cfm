<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

	Notes:
	
--->
<cfoutput>
	<ns:RateRequest xmlns:ns="http://fedex.com/ws/rate/v7" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	    <ns:WebAuthenticationDetail>
	        <ns:UserCredential>
	            <ns:Key>#trim(setting('transactionKey'))#</ns:Key>
	            <ns:Password>#trim(setting('password'))#</ns:Password>
	        </ns:UserCredential>
	    </ns:WebAuthenticationDetail>
	    <ns:ClientDetail>
	        <ns:AccountNumber>#trim(setting('accountNo'))#</ns:AccountNumber>
	        <ns:MeterNumber>#trim(setting('meterNo'))#</ns:MeterNumber>
	    </ns:ClientDetail>
	    <ns:Version>
	        <ns:ServiceId>crs</ns:ServiceId>
	        <ns:Major>7</ns:Major>
	        <ns:Intermediate>0</ns:Intermediate>
	        <ns:Minor>0</ns:Minor>
	    </ns:Version>
	    <ns:RequestedShipment>
	        <ns:ShipTimestamp>#DateFormat(Now(),'yyyy-mm-dd')#T#TimeFormat(Now(),'hh:mm:ss')#</ns:ShipTimestamp>
	        <ns:DropoffType>REGULAR_PICKUP</ns:DropoffType>
	        <ns:PackagingType>YOUR_PACKAGING</ns:PackagingType>
	        <ns:TotalWeight>
	            <ns:Units>LB</ns:Units>
	            <ns:Value>#arguments.requestBean.getTotalWeight( unitCode='lb' )#</ns:Value>
	        </ns:TotalWeight>
	        <ns:TotalInsuredValue>
	            <ns:Currency>USD</ns:Currency>
	            <ns:Amount>#arguments.requestBean.getTotalValue()#</ns:Amount>
	        </ns:TotalInsuredValue>
	        <ns:Shipper>
	            <ns:Address>
	            	<ns:StreetLines>#trim(setting('shipperStreet'))#</ns:StreetLines>
	                <ns:City>#trim(setting('shipperCity'))#</ns:City>
	                <ns:StateOrProvinceCode>#trim(setting('shipperStateCode'))#</ns:StateOrProvinceCode>
	                <ns:PostalCode>#trim(setting('shipperPostalCode'))#</ns:PostalCode>
	                <ns:CountryCode>#trim(setting('shipperCountryCode'))#</ns:CountryCode>
	            </ns:Address>
	        </ns:Shipper>
	        <ns:Recipient>
	        	<ns:Address>
	                <ns:StreetLines>#arguments.requestBean.getShipToStreetAddress()#</ns:StreetLines>
	                <ns:City>#arguments.requestBean.getShipToCity()#</ns:City>
					<cfif len(arguments.requestBean.getShipToStateCode()) eq 2>
	                	<ns:StateOrProvinceCode>#arguments.requestBean.getShipToStateCode()#</ns:StateOrProvinceCode>
					<cfelseif len(arguments.requestBean.getShipToStateCode()) eq 3>
						<ns:StateOrProvinceCode>#left(arguments.requestBean.getShipToStateCode(),2)#</ns:StateOrProvinceCode> 
					</cfif>
	                <ns:PostalCode>#arguments.requestBean.getShipToPostalCode()#</ns:PostalCode>
	                <ns:CountryCode>#arguments.requestBean.getShipToCountryCode()#</ns:CountryCode>
					<ns:Residential>false</ns:Residential>
	            </ns:Address>
	        </ns:Recipient>
	        <ns:RateRequestTypes>LIST</ns:RateRequestTypes>
	        <ns:PackageCount>1</ns:PackageCount>
	        <ns:PackageDetail>INDIVIDUAL_PACKAGES</ns:PackageDetail>
	        <ns:RequestedPackageLineItems>
	            <ns:SequenceNumber>1</ns:SequenceNumber>
	            <ns:InsuredValue>
	                <ns:Currency>USD</ns:Currency>
	                <ns:Amount>#arguments.requestBean.getTotalValue()#</ns:Amount>
	            </ns:InsuredValue>
	            <ns:Weight>
	                <ns:Units>LB</ns:Units>
	                <ns:Value>#arguments.requestBean.getTotalWeight( unitCode='lb' )#</ns:Value>
	            </ns:Weight>
	        </ns:RequestedPackageLineItems>
	    </ns:RequestedShipment>
	</ns:RateRequest>
</cfoutput>